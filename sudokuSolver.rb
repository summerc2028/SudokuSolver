def readFile (t)
	print "Please enter the file name: "
	fn = gets.chomp
	file = File.new(fn, "r")

	i = 0
	j = 0
	count = 0
	while (c = file.getc)
		if (c =~ /[[:digit:]\.]/)
			if (c != '.')
				t[i][j] = c.to_i
			end
			j += 1
			if (j == 9)
				j = 0
				i += 1
			end
		end
	end
	file.close
end

def printTable (t)
	rowCount = 0
	columnCount = 0
	for i in 0..8
		for j in 0..8
			if (t[i][j])
				print "#{t[i][j]}"
			else
				print "."
			end
			columnCount += 1
			if ((columnCount == 3) || (columnCount == 6))
				print "|"
			elsif columnCount == 9
				columnCount = 0
			end
		end
		puts
		rowCount += 1
		if ((rowCount == 3) || (rowCount == 6))
			for k in 0..10
				print "-"
			end
			puts
		end
	end
end


# determine whether putting the given value in t[i][j] violates the column constriant
def violateColumnConstraint (t, i, j, value)
	violate = false
	for k in 0..8
		if ((k != i) && (t[k][j] == value))
			violate = true
			break
		end
	end
	violate
end

# determine whether putting the given value in t[i][j] violates the row constriant
def violateRowConstraint (t, i, j, value)
	violate = false
	for k in 0..8
		if ((k != j) && (t[i][k] == value))
			violate = true
			break
		end
	end
	violate
end

# determine whether putting the given value in t[i][j] violates the box constriant
def violateBoxConstraint (t, i, j, value)
	violate = false
	if ((i < 3) && (j < 3))
		# top left block
		for p in 0..2
			for q in 0..2
				if (((p != i) || (q != j)) && (t[p][q] == value))
					violate = true
					break
				end
			end
		end
	elsif ((i < 3) && (j >= 3) && (j < 6))
		# top middle block
		for p in 0..2
			for q in 3..5
				if (((p != i) || (q != j)) && (t[p][q] == value))
					violate = true
					break
				end
			end
		end
	elsif ((i < 3) && (j >= 6))
		# top right block
		for p in 0..2
			for q in 6..8
				if (((p != i) || (q != j)) && (t[p][q] == value))
					violate = true
					break
				end
			end
		end
	elsif ((i >= 3) && (i < 6) && (j < 3))
		# middle left block
		for p in 3..5
			for q in 0..2
				if (((p != i) || (q != j)) && (t[p][q] == value))
					violate = true
					break
				end
			end
		end
	elsif ((i >= 3) && (i < 6) && (j >= 3) && (j < 6))
		# middle middle block
		for p in 3..5
			for q in 3..5
				if (((p != i) || (q != j)) && (t[p][q] == value))
					violate = true
					break
				end
			end
		end
	elsif ((i >= 3) && (i < 6) && (j >= 6))
		# middle right block
		for p in 3..5
			for q in 6..8
				if (((p != i) || (q != j)) && (t[p][q] == value))
					violate = true
					break
				end
			end
		end
	elsif ((i >= 6) && (j < 3))
		# bottom left block
		for p in 6..8
			for q in 0..2
				if (((p != i) || (q != j)) && (t[p][q] == value))
					violate = true
					break
				end
			end
		end
	elsif ((i >= 6) && (j >= 3) && (j < 6))
		# bottom middle block
		for p in 6..8
			for q in 3..5
				if (((p != i) || (q != j)) && (t[p][q] == value))
					violate = true
					break
				end
			end
		end
	elsif ((i >= 6) && (j >= 6))
		# bottom right block
		for p in 6..8
			for q in 6..8
				if (((p != i) || (q != j)) && (t[p][q] == value))
					violate = true
					break
				end
			end
		end
	end
	violate
end

def solveSudoku (t, i, j)
	if (i > 8)
		return true
	end
	p = i
	q = j + 1
	if (q > 8)
		q = 0
		p += 1
	end
	if (t[i][j])
		solved = solveSudoku(t, p, q)
		return solved
	end
	for value in 1..9
		if !(violateBoxConstraint(t, i, j, value) || violateRowConstraint(t, i, j, value) || violateColumnConstraint(t, i, j, value))
			t[i][j] = value
			if solveSudoku(t, p, q)
				return true
			end
			t[i][j] = nil
		end
	end
	false
end

# create a 9x9 array as the sudoku model
table = Array.new(9){Array.new(9)}

# open the file and read in all the numbers or empty cells
readFile(table)
puts

# print the input sudoku
puts "Your input:\n\n"
printTable(table)
puts
# solve sudoku
if (solveSudoku(table, 0, 0)) 
	puts "Solution:\n\n"
	printTable(table)
	puts
else
	puts "There is no solution for this Sudoku.\n\n"
end



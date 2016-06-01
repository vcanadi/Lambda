{} :
rec 
{ 

#[1, 2, ...]
	zero 		= s : z : z;
	succ 		= n : s : z: s (n s z);
	one			= succ zero;
	#IntToLambda
	lint		= x : if x==0 	then zero 
							else succ (lint (x -1));
	two 		= lint 2;
	error		= lint 1025;

	#LambdaToInt
	show 		= n : n (x : x+1) 0;


	comp		= f : g : z : f (g z);
	flip		= f : (z : w : f w z);

	#examples 
		exFlip 		= show ( (flip pow) (lint 2) (lint 3) );
		#  (+1) . (*2) 
		exComp		= show ( (comp (add one) (mul two)) (lint 5) );


#Boolean
	T 			= t : f : t;
	F 			= t : f : f;
	IF 			= b : t : f : b t f;
	AND			= b : c : b c F;
	OR			= b : c : b T c;
	NEG			= b : b F T;
	GT0			= n : (n F NEG) T;
	EQ0			= n : NEG (GT0 n);
	GT  		= n : m : GT0 (sub n m);
	GE			= n : m : GT (succ n) m;
	EQ 			= n : m : AND (GE n m) (GE m n);
	LT 			= flip GT ;
	LE 			= flip GE ;
	showBool	= b : IF b true false;

	#examples
		boolExample1 = showBool (LT (lint 3) (lint 2));
		boolExample2 = showBool (LE (lint 3) (lint 3));


# +, *, ^
	add			= n : m : n succ m;
	mul			= n : m : n (add m) zero;
	pow			= n : m : m n ;

# Pair (a,b), Pred, -
	pair		= n : m : i : i n m;
	showPair	= p : [(show (p T)) (show (p F))];

	pred		= n : ( n (p : pair (succ (p T)) (p T) ) (pair zero zero) ) F;

	sub			= n : m : m pred n;

	#examples
		exPair		= showPair (pair two (lint 3));
	

	# error = 1025
	div			= n : m : 	IF (EQ0 m) error
							(( n 
								(p : LT (p T) m (p) (pair (sub (p T) m) (succ (p F)) )) 
								(pair n zero)  
							) F );
	fac			= n : ( n (p : pair (succ (p T)) ( mul (p T) (p F) ) ) (pair one one) ) F; 

	fallFac		= n : k : ( k (p : pair (pred (p T)) (mul (p T) (p F) ) ) (pair n one) ) F;
	choose		= n : k : div (fallFac n k) (fac k);


#List
	empty		= pair zero error;
	cons		= a : kL : pair (succ (length kL)) (pair a (kL F));
	length		= kL : kL T;
	showList	= kL : showList' (length kL) (kL F) ;
	showList'	= k : L : ( k (p : pair (p T F) ([(show (p T T))] ++ p F) ) (pair L []) )  F;

	#example Lists
		L1 			= cons (lint 10) empty;
		L2 			= cons (lint 20) L1;
		L3 			= cons (lint 30) L2;


# Y combinator
	Y			= f : (x : f (x x) ) (x : f (x x) );

	sums		= Y (s : n : GT0 n (add n (s (pred n))) zero );

	sumWith 	= f : n : ( n (p : pair (succ (p T)) (add (p F) (f (p T)) ) ) (pair zero zero) ) F ;

#	bell		= Y (b : n : EQ0 n one (sumWith (k : mul (choose n k) (b k) ) n ) );


	

}
Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab1CMGbL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 01:31:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab1CMGbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 01:31:01 -0500
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] genksyms: Simplify lexer
Date: Sun, 13 Mar 2011 07:30:20 +0100
Message-Id: <1299997825-18977-3-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299997825-18977-1-git-send-email-mmarek@suse.cz>
References: <1299997825-18977-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The V2_TOKENS state is active all the time.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/genksyms/lex.c_shipped |  250 +++++++++++++++++++---------------------
 scripts/genksyms/lex.l         |   11 +--
 2 files changed, 123 insertions(+), 138 deletions(-)

diff --git a/scripts/genksyms/lex.c_shipped b/scripts/genksyms/lex.c_shipped
index b54044a..d0a0423 100644
--- a/scripts/genksyms/lex.c_shipped
+++ b/scripts/genksyms/lex.c_shipped
@@ -455,16 +455,16 @@ struct yy_trans_info
 	flex_int32_t yy_verify;
 	flex_int32_t yy_nxt;
 	};
-static yyconst flex_int16_t yy_accept[76] =
+static yyconst flex_int16_t yy_accept[73] =
     {   0,
-        0,    0,    0,    0,   14,   12,    4,    3,   12,    7,
-       12,   12,    7,   12,   12,   12,   12,   12,    9,    9,
-       12,   12,   12,    4,    0,    5,    0,    7,    0,    6,
-        0,    0,    0,    0,    0,    0,    2,    8,   10,   10,
-        9,    0,    0,    9,    9,    0,    9,    0,    0,   11,
-        0,    0,    0,   10,    0,   10,    9,    9,    0,    0,
-        0,    0,    0,    0,    0,   10,   10,    0,    0,    0,
-        0,    0,    0,    1,    0
+        0,    0,   14,   12,    4,    3,   12,    7,   12,   12,
+       12,   12,   12,    9,    9,   12,   12,    7,   12,   12,
+        4,    0,    5,    0,    7,    8,    0,    6,    0,    0,
+       10,   10,    9,    0,    0,    9,    9,    0,    9,    0,
+        0,    0,    0,    2,    0,    0,   11,    0,   10,    0,
+       10,    9,    9,    0,    0,    0,   10,   10,    0,    0,
+        0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
+        1,    0
     } ;
 
 static yyconst flex_int32_t yy_ec[256] =
@@ -506,108 +506,104 @@ static yyconst flex_int32_t yy_meta[29] =
         8,    7,    3,    3,    3,    1,    3,    1
     } ;
 
-static yyconst flex_int16_t yy_base[88] =
+static yyconst flex_int16_t yy_base[85] =
     {   0,
-        0,  147,   21,  140,  145,  284,   39,  284,   26,    0,
-       32,  126,   40,   44,  115,   35,   36,   46,   50,   53,
-       39,   61,   54,   79,   65,  284,    0,    0,   66,  284,
-        0,  119,   79,   75,  123,  104,  284,  284,  107,    0,
-       79,   73,   76,   76,   66,    0,    0,   85,   86,  284,
-      133,   83,   91,  284,   99,  147,  284,  114,  122,   70,
-      107,  141,  172,  151,  135,  181,  284,  137,  114,  157,
-      149,   48,   45,  284,  284,  208,  214,  222,  230,  238,
-      246,  250,  255,  256,  261,  267,  275
+        0,  145,  150,  266,   27,  266,   25,    0,  131,   23,
+       23,   16,   23,   39,   31,   25,   39,   60,   22,   65,
+       57,   43,  266,    0,    0,  266,   61,  266,    0,  128,
+       74,    0,  113,   59,   62,  113,   52,    0,    0,   72,
+       66,  110,  100,  266,   73,   74,  266,   70,  266,   90,
+      103,  266,   84,  129,  108,  113,  143,  266,  107,   66,
+      118,  137,  168,  120,   80,   91,  145,  143,   83,   41,
+      266,  266,  190,  196,  204,  212,  220,  228,  232,  237,
+      238,  243,  249,  257
     } ;
 
-static yyconst flex_int16_t yy_def[88] =
+static yyconst flex_int16_t yy_def[85] =
     {   0,
-       75,    1,    1,    3,   75,   75,   75,   75,   76,   77,
-       78,   75,   77,   79,   75,   75,   75,   75,   75,   19,
-       75,   75,   75,   75,   76,   75,   80,   77,   78,   75,
-       81,   75,   76,   78,   79,   79,   75,   75,   75,   39,
-       19,   82,   83,   75,   75,   84,   20,   76,   78,   75,
-       79,   51,   85,   75,   75,   75,   75,   84,   79,   51,
-       79,   79,   79,   51,   75,   75,   75,   86,   79,   63,
-       86,   87,   87,   75,    0,   75,   75,   75,   75,   75,
-       75,   75,   75,   75,   75,   75,   75
+       72,    1,   72,   72,   72,   72,   73,   74,   72,   72,
+       75,   72,   72,   72,   14,   72,   72,   74,   72,   76,
+       72,   73,   72,   77,   74,   72,   75,   72,   78,   72,
+       72,   31,   14,   79,   80,   72,   72,   81,   15,   73,
+       75,   76,   76,   72,   73,   75,   72,   82,   72,   72,
+       72,   72,   81,   76,   54,   72,   72,   72,   76,   54,
+       76,   76,   76,   54,   83,   76,   63,   83,   84,   84,
+       72,    0,   72,   72,   72,   72,   72,   72,   72,   72,
+       72,   72,   72,   72
     } ;
 
-static yyconst flex_int16_t yy_nxt[313] =
+static yyconst flex_int16_t yy_nxt[295] =
     {   0,
-        6,    7,    8,    7,    9,    6,   10,    6,    6,   11,
-        6,    6,   12,    6,    6,    6,    6,    6,    6,   10,
-       10,   10,   13,   10,   10,    6,   10,    6,   15,   16,
-       26,   15,   17,   18,   19,   20,   20,   21,   15,   22,
-       24,   30,   24,   38,   33,   36,   37,   74,   23,   34,
-       74,   27,   38,   38,   38,   38,   38,   31,   32,   39,
-       39,   39,   40,   41,   41,   42,   47,   47,   47,   26,
-       43,   38,   44,   45,   46,   30,   44,   75,   38,   38,
-       24,   38,   24,   26,   30,   40,   55,   55,   57,   26,
-       27,   31,   57,   43,   35,   30,   64,   64,   64,   57,
-
-       31,   65,   65,   75,   27,   36,   37,   35,   59,   37,
-       27,   31,   56,   56,   56,   59,   37,   51,   52,   52,
-       39,   39,   39,   59,   37,   37,   68,   53,   54,   54,
-       69,   50,   38,   54,   59,   37,   44,   45,   32,   37,
-       44,   35,   59,   37,   75,   14,   60,   60,   66,   66,
-       66,   37,   14,   72,   75,   61,   62,   63,   59,   61,
-       56,   56,   56,   69,   64,   64,   64,   69,   67,   67,
-       75,   75,   75,   67,   37,   35,   75,   75,   75,   61,
-       62,   75,   75,   61,   75,   70,   70,   70,   75,   75,
-       75,   70,   70,   70,   66,   66,   66,   75,   75,   75,
-
-       75,   75,   54,   54,   75,   75,   75,   54,   25,   25,
-       25,   25,   25,   25,   25,   25,   28,   75,   75,   28,
-       28,   28,   29,   29,   29,   29,   29,   29,   29,   29,
-       35,   35,   35,   35,   35,   35,   35,   35,   48,   75,
-       48,   48,   48,   48,   48,   48,   49,   75,   49,   49,
-       49,   49,   49,   49,   42,   42,   75,   42,   56,   75,
-       56,   58,   58,   58,   66,   75,   66,   71,   71,   71,
-       71,   71,   71,   71,   71,   73,   73,   73,   73,   73,
-       73,   73,   73,    5,   75,   75,   75,   75,   75,   75,
-       75,   75,   75,   75,   75,   75,   75,   75,   75,   75,
-
-       75,   75,   75,   75,   75,   75,   75,   75,   75,   75,
-       75,   75
+        4,    5,    6,    5,    7,    4,    8,    9,   10,   11,
+        9,   12,   13,   14,   15,   15,   16,    9,   17,    8,
+        8,    8,   18,    8,    8,    4,    8,   19,   21,   23,
+       21,   26,   28,   26,   26,   30,   31,   31,   31,   26,
+       26,   26,   26,   71,   39,   39,   39,   23,   29,   26,
+       24,   32,   33,   33,   34,   72,   26,   26,   21,   35,
+       21,   36,   37,   38,   40,   36,   43,   44,   24,   41,
+       28,   32,   50,   50,   52,   28,   23,   23,   52,   35,
+       56,   56,   44,   28,   42,   71,   29,   31,   31,   31,
+       42,   29,   59,   44,   48,   49,   49,   24,   24,   29,
+
+       49,   43,   44,   51,   51,   51,   36,   37,   59,   44,
+       36,   65,   44,   54,   55,   55,   51,   51,   51,   59,
+       44,   64,   64,   64,   58,   58,   57,   57,   57,   58,
+       59,   44,   42,   64,   64,   64,   52,   72,   59,   44,
+       47,   66,   60,   60,   42,   44,   59,   69,   26,   72,
+       20,   61,   62,   63,   72,   61,   57,   57,   57,   66,
+       72,   72,   72,   66,   49,   49,   72,   61,   62,   49,
+       44,   61,   72,   72,   72,   72,   72,   72,   72,   72,
+       72,   67,   67,   67,   72,   72,   72,   67,   67,   67,
+       22,   22,   22,   22,   22,   22,   22,   22,   25,   72,
+
+       72,   25,   25,   25,   27,   27,   27,   27,   27,   27,
+       27,   27,   42,   42,   42,   42,   42,   42,   42,   42,
+       45,   72,   45,   45,   45,   45,   45,   45,   46,   72,
+       46,   46,   46,   46,   46,   46,   34,   34,   72,   34,
+       51,   72,   51,   53,   53,   53,   57,   72,   57,   68,
+       68,   68,   68,   68,   68,   68,   68,   70,   70,   70,
+       70,   70,   70,   70,   70,    3,   72,   72,   72,   72,
+       72,   72,   72,   72,   72,   72,   72,   72,   72,   72,
+       72,   72,   72,   72,   72,   72,   72,   72,   72,   72,
+       72,   72,   72,   72
+
     } ;
 
-static yyconst flex_int16_t yy_chk[313] =
+static yyconst flex_int16_t yy_chk[295] =
     {   0,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
         1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
-        1,    1,    1,    1,    1,    1,    1,    1,    3,    3,
-        9,    3,    3,    3,    3,    3,    3,    3,    3,    3,
-        7,   11,    7,   16,   13,   14,   14,   73,    3,   13,
-       72,    9,   16,   17,   17,   21,   21,   11,   18,   18,
-       18,   18,   19,   19,   19,   19,   20,   20,   20,   25,
-       19,   23,   19,   19,   19,   29,   19,   20,   22,   22,
-       24,   23,   24,   33,   34,   42,   43,   43,   45,   48,
-       25,   29,   45,   42,   60,   49,   52,   52,   52,   44,
-
-       34,   53,   53,   41,   33,   36,   36,   52,   61,   61,
-       48,   49,   55,   55,   55,   69,   69,   36,   36,   36,
-       39,   39,   39,   59,   59,   35,   59,   39,   39,   39,
-       61,   32,   15,   39,   51,   51,   58,   58,   12,   68,
-       58,   68,   62,   62,    5,    4,   51,   51,   65,   65,
-       65,   71,    2,   71,    0,   51,   51,   51,   70,   51,
-       56,   56,   56,   62,   64,   64,   64,   62,   56,   56,
-        0,    0,    0,   56,   63,   64,    0,    0,    0,   70,
-       70,    0,    0,   70,    0,   63,   63,   63,    0,    0,
-        0,   63,   63,   63,   66,   66,   66,    0,    0,    0,
-
-        0,    0,   66,   66,    0,    0,    0,   66,   76,   76,
-       76,   76,   76,   76,   76,   76,   77,    0,    0,   77,
-       77,   77,   78,   78,   78,   78,   78,   78,   78,   78,
-       79,   79,   79,   79,   79,   79,   79,   79,   80,    0,
-       80,   80,   80,   80,   80,   80,   81,    0,   81,   81,
-       81,   81,   81,   81,   82,   82,    0,   82,   83,    0,
-       83,   84,   84,   84,   85,    0,   85,   86,   86,   86,
-       86,   86,   86,   86,   86,   87,   87,   87,   87,   87,
-       87,   87,   87,   75,   75,   75,   75,   75,   75,   75,
-       75,   75,   75,   75,   75,   75,   75,   75,   75,   75,
-
-       75,   75,   75,   75,   75,   75,   75,   75,   75,   75,
-       75,   75
+        1,    1,    1,    1,    1,    1,    1,    1,    5,    7,
+        5,   10,   11,   12,   12,   13,   13,   13,   13,   19,
+       10,   16,   16,   70,   15,   15,   15,   22,   11,   19,
+        7,   14,   14,   14,   14,   15,   17,   17,   21,   14,
+       21,   14,   14,   14,   18,   14,   20,   20,   22,   18,
+       27,   34,   35,   35,   37,   41,   40,   45,   37,   34,
+       48,   48,   65,   46,   65,   69,   27,   31,   31,   31,
+       60,   41,   66,   66,   31,   31,   31,   40,   45,   46,
+
+       31,   43,   43,   50,   50,   50,   53,   53,   59,   59,
+       53,   59,   42,   43,   43,   43,   51,   51,   51,   61,
+       61,   55,   55,   55,   51,   51,   56,   56,   56,   51,
+       54,   54,   55,   64,   64,   64,   36,   33,   62,   62,
+       30,   61,   54,   54,   64,   68,   67,   68,    9,    3,
+        2,   54,   54,   54,    0,   54,   57,   57,   57,   62,
+        0,    0,    0,   62,   57,   57,    0,   67,   67,   57,
+       63,   67,    0,    0,    0,    0,    0,    0,    0,    0,
+        0,   63,   63,   63,    0,    0,    0,   63,   63,   63,
+       73,   73,   73,   73,   73,   73,   73,   73,   74,    0,
+
+        0,   74,   74,   74,   75,   75,   75,   75,   75,   75,
+       75,   75,   76,   76,   76,   76,   76,   76,   76,   76,
+       77,    0,   77,   77,   77,   77,   77,   77,   78,    0,
+       78,   78,   78,   78,   78,   78,   79,   79,    0,   79,
+       80,    0,   80,   81,   81,   81,   82,    0,   82,   83,
+       83,   83,   83,   83,   83,   83,   83,   84,   84,   84,
+       84,   84,   84,   84,   84,   72,   72,   72,   72,   72,
+       72,   72,   72,   72,   72,   72,   72,   72,   72,   72,
+       72,   72,   72,   72,   72,   72,   72,   72,   72,   72,
+       72,   72,   72,   72
+
     } ;
 
 static yy_state_type yy_last_accepting_state;
@@ -618,8 +614,8 @@ int yy_flex_debug = 1;
 
 static yyconst flex_int16_t yy_rule_linenum[13] =
     {   0,
-       71,   72,   73,   76,   79,   80,   81,   87,   88,   89,
-       91,   94
+       67,   68,   69,   72,   75,   76,   77,   83,   84,   85,
+       87,   90
     } ;
 
 /* The intent behind this definition is that it'll catch
@@ -666,15 +662,11 @@ char *yytext;
    and then we categorize those basic tokens in the second stage.  */
 #define YY_DECL		static int yylex1(void)
 
-/* Version 2 checksumming does proper tokenization; version 1 wasn't
-   quite so pedantic.  */
-
 /* We don't do multiple input files.  */
 #define YY_NO_INPUT 1
-#line 675 "scripts/genksyms/lex.c"
+#line 668 "scripts/genksyms/lex.c"
 
 #define INITIAL 0
-#define V2_TOKENS 1
 
 #ifndef YY_NO_UNISTD_H
 /* Special case for "unistd.h", since it is non-ANSI. We include it way
@@ -917,12 +909,12 @@ YY_DECL
 	register int yy_act;
     
 /* %% [7.0] user's declarations go here */
-#line 67 "scripts/genksyms/lex.l"
+#line 63 "scripts/genksyms/lex.l"
 
 
 
  /* Keep track of our location in the original source files.  */
-#line 926 "scripts/genksyms/lex.c"
+#line 918 "scripts/genksyms/lex.c"
 
 	if ( !(yy_init) )
 		{
@@ -986,13 +978,13 @@ yy_match:
 			while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
 				{
 				yy_current_state = (int) yy_def[yy_current_state];
-				if ( yy_current_state >= 76 )
+				if ( yy_current_state >= 73 )
 					yy_c = yy_meta[(unsigned int) yy_c];
 				}
 			yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
 			++yy_cp;
 			}
-		while ( yy_base[yy_current_state] != 284 );
+		while ( yy_base[yy_current_state] != 266 );
 
 yy_find_action:
 /* %% [10.0] code to find the action number goes here */
@@ -1040,42 +1032,42 @@ do_action:	/* This label is used only to access EOF actions. */
 case 1:
 /* rule 1 can match eol */
 YY_RULE_SETUP
-#line 71 "scripts/genksyms/lex.l"
+#line 67 "scripts/genksyms/lex.l"
 return FILENAME;
 	YY_BREAK
 case 2:
 /* rule 2 can match eol */
 YY_RULE_SETUP
-#line 72 "scripts/genksyms/lex.l"
+#line 68 "scripts/genksyms/lex.l"
 cur_line++;
 	YY_BREAK
 case 3:
 /* rule 3 can match eol */
 YY_RULE_SETUP
-#line 73 "scripts/genksyms/lex.l"
+#line 69 "scripts/genksyms/lex.l"
 cur_line++;
 	YY_BREAK
 /* Ignore all other whitespace.  */
 case 4:
 YY_RULE_SETUP
-#line 76 "scripts/genksyms/lex.l"
+#line 72 "scripts/genksyms/lex.l"
 ;
 	YY_BREAK
 case 5:
 /* rule 5 can match eol */
 YY_RULE_SETUP
-#line 79 "scripts/genksyms/lex.l"
+#line 75 "scripts/genksyms/lex.l"
 return STRING;
 	YY_BREAK
 case 6:
 /* rule 6 can match eol */
 YY_RULE_SETUP
-#line 80 "scripts/genksyms/lex.l"
+#line 76 "scripts/genksyms/lex.l"
 return CHAR;
 	YY_BREAK
 case 7:
 YY_RULE_SETUP
-#line 81 "scripts/genksyms/lex.l"
+#line 77 "scripts/genksyms/lex.l"
 return IDENT;
 	YY_BREAK
 /* The Pedant requires that the other C multi-character tokens be
@@ -1084,38 +1076,37 @@ return IDENT;
     around them properly.  */
 case 8:
 YY_RULE_SETUP
-#line 87 "scripts/genksyms/lex.l"
+#line 83 "scripts/genksyms/lex.l"
 return OTHER;
 	YY_BREAK
 case 9:
 YY_RULE_SETUP
-#line 88 "scripts/genksyms/lex.l"
+#line 84 "scripts/genksyms/lex.l"
 return INT;
 	YY_BREAK
 case 10:
 YY_RULE_SETUP
-#line 89 "scripts/genksyms/lex.l"
+#line 85 "scripts/genksyms/lex.l"
 return REAL;
 	YY_BREAK
 case 11:
 YY_RULE_SETUP
-#line 91 "scripts/genksyms/lex.l"
+#line 87 "scripts/genksyms/lex.l"
 return DOTS;
 	YY_BREAK
 /* All other tokens are single characters.  */
 case 12:
 YY_RULE_SETUP
-#line 94 "scripts/genksyms/lex.l"
+#line 90 "scripts/genksyms/lex.l"
 return yytext[0];
 	YY_BREAK
 case 13:
 YY_RULE_SETUP
-#line 97 "scripts/genksyms/lex.l"
+#line 93 "scripts/genksyms/lex.l"
 ECHO;
 	YY_BREAK
-#line 1117 "scripts/genksyms/lex.c"
+#line 1109 "scripts/genksyms/lex.c"
 case YY_STATE_EOF(INITIAL):
-case YY_STATE_EOF(V2_TOKENS):
 	yyterminate();
 
 	case YY_END_OF_BUFFER:
@@ -1428,7 +1419,7 @@ static int yy_get_next_buffer (void)
 		while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
 			{
 			yy_current_state = (int) yy_def[yy_current_state];
-			if ( yy_current_state >= 76 )
+			if ( yy_current_state >= 73 )
 				yy_c = yy_meta[(unsigned int) yy_c];
 			}
 		yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
@@ -1461,11 +1452,11 @@ static int yy_get_next_buffer (void)
 	while ( yy_chk[yy_base[yy_current_state] + yy_c] != yy_current_state )
 		{
 		yy_current_state = (int) yy_def[yy_current_state];
-		if ( yy_current_state >= 76 )
+		if ( yy_current_state >= 73 )
 			yy_c = yy_meta[(unsigned int) yy_c];
 		}
 	yy_current_state = yy_nxt[yy_base[yy_current_state] + (unsigned int) yy_c];
-	yy_is_jam = (yy_current_state == 75);
+	yy_is_jam = (yy_current_state == 72);
 
 	return yy_is_jam ? 0 : yy_current_state;
 }
@@ -2251,7 +2242,7 @@ void yyfree (void * ptr )
 
 /* %ok-for-header */
 
-#line 97 "scripts/genksyms/lex.l"
+#line 93 "scripts/genksyms/lex.l"
 
 
 
@@ -2293,7 +2284,6 @@ yylex(void)
 
   if (lexstate == ST_NOTSTARTED)
     {
-      BEGIN(V2_TOKENS);
       next_node = xmalloc(sizeof(*next_node));
       next_node->next = NULL;
       lexstate = ST_NORMAL;
diff --git a/scripts/genksyms/lex.l b/scripts/genksyms/lex.l
index fe50ff9..4687b1d 100644
--- a/scripts/genksyms/lex.l
+++ b/scripts/genksyms/lex.l
@@ -55,10 +55,6 @@ CHAR			L?\'([^\\\']*\\.)*[^\\\']*\'
 
 MC_TOKEN		([~%^&*+=|<>/-]=)|(&&)|("||")|(->)|(<<)|(>>)
 
-/* Version 2 checksumming does proper tokenization; version 1 wasn't
-   quite so pedantic.  */
-%s V2_TOKENS
-
 /* We don't do multiple input files.  */
 %option noyywrap
 
@@ -84,9 +80,9 @@ MC_TOKEN		([~%^&*+=|<>/-]=)|(&&)|("||")|(->)|(<<)|(>>)
     recognized as tokens.  We don't actually use them since we don't
     parse expressions, but we do want whitespace to be arranged
     around them properly.  */
-<V2_TOKENS>{MC_TOKEN}			return OTHER;
-<V2_TOKENS>{INT}			return INT;
-<V2_TOKENS>{REAL}			return REAL;
+{MC_TOKEN}				return OTHER;
+{INT}					return INT;
+{REAL}					return REAL;
 
 "..."					return DOTS;
 
@@ -134,7 +130,6 @@ yylex(void)
 
   if (lexstate == ST_NOTSTARTED)
     {
-      BEGIN(V2_TOKENS);
       next_node = xmalloc(sizeof(*next_node));
       next_node->next = NULL;
       lexstate = ST_NORMAL;
-- 
1.7.4.1


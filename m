Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab1CMGbB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 01:31:01 -0500
Received: from cantor.suse.de ([195.135.220.2]:44106 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab1CMGa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 01:30:57 -0500
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] genksyms: Do not paste the bison header file to lex.c
Date: Sun, 13 Mar 2011 07:30:19 +0100
Message-Id: <1299997825-18977-2-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299997825-18977-1-git-send-email-mmarek@suse.cz>
References: <1299997825-18977-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header is already #included, no need to include it a second time.
lex.c_shipped was regenerated using flex-2.5.35.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/genksyms/Makefile      |    4 +-
 scripts/genksyms/lex.c_shipped |  150 ++--------------------------------------
 2 files changed, 7 insertions(+), 147 deletions(-)

diff --git a/scripts/genksyms/Makefile b/scripts/genksyms/Makefile
index e420fe4..13d03cf 100644
--- a/scripts/genksyms/Makefile
+++ b/scripts/genksyms/Makefile
@@ -28,9 +28,9 @@ $(obj)/keywords.c: $(obj)/keywords.gperf FORCE
 # flex
 
 quiet_cmd_lex.c = FLEX    $@
-      cmd_lex.c = flex -o$@ -d $< $(obj)/parse.h
+      cmd_lex.c = flex -o$@ -d $<
 
-$(obj)/lex.c: $(obj)/lex.l $(obj)/parse.h $(obj)/keywords.c FORCE
+$(obj)/lex.c: $(obj)/lex.l $(obj)/keywords.c FORCE
 	$(call if_changed,lex.c)
 	cp $@ $@_shipped
 
diff --git a/scripts/genksyms/lex.c_shipped b/scripts/genksyms/lex.c_shipped
index 2ac23bc..b54044a 100644
--- a/scripts/genksyms/lex.c_shipped
+++ b/scripts/genksyms/lex.c_shipped
@@ -79,6 +79,7 @@ typedef int flex_int32_t;
 typedef unsigned char flex_uint8_t; 
 typedef unsigned short int flex_uint16_t;
 typedef unsigned int flex_uint32_t;
+#endif /* ! C99 */
 
 /* Limits of integral types. */
 #ifndef INT8_MIN
@@ -109,8 +110,6 @@ typedef unsigned int flex_uint32_t;
 #define UINT32_MAX             (4294967295U)
 #endif
 
-#endif /* ! C99 */
-
 #endif /* ! FLEXINT_H */
 
 /* %endif */
@@ -672,7 +671,7 @@ char *yytext;
 
 /* We don't do multiple input files.  */
 #define YY_NO_INPUT 1
-#line 676 "scripts/genksyms/lex.c"
+#line 675 "scripts/genksyms/lex.c"
 
 #define INITIAL 0
 #define V2_TOKENS 1
@@ -808,7 +807,7 @@ static int input (void );
 	if ( YY_CURRENT_BUFFER_LVALUE->yy_is_interactive ) \
 		{ \
 		int c = '*'; \
-		size_t n; \
+		int n; \
 		for ( n = 0; n < max_size && \
 			     (c = getc( yyin )) != EOF && c != '\n'; ++n ) \
 			buf[n] = (char) c; \
@@ -923,7 +922,7 @@ YY_DECL
 
 
  /* Keep track of our location in the original source files.  */
-#line 927 "scripts/genksyms/lex.c"
+#line 926 "scripts/genksyms/lex.c"
 
 	if ( !(yy_init) )
 		{
@@ -1114,7 +1113,7 @@ YY_RULE_SETUP
 #line 97 "scripts/genksyms/lex.l"
 ECHO;
 	YY_BREAK
-#line 1118 "scripts/genksyms/lex.c"
+#line 1117 "scripts/genksyms/lex.c"
 case YY_STATE_EOF(INITIAL):
 case YY_STATE_EOF(V2_TOKENS):
 	yyterminate();
@@ -2567,143 +2566,4 @@ fini:
 
   return token;
 }
-/* A Bison parser, made by GNU Bison 2.3.  */
-
-/* Skeleton interface for Bison's Yacc-like parsers in C
-
-   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
-   Free Software Foundation, Inc.
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation; either version 2, or (at your option)
-   any later version.
-
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 51 Franklin Street, Fifth Floor,
-   Boston, MA 02110-1301, USA.  */
-
-/* As a special exception, you may create a larger work that contains
-   part or all of the Bison parser skeleton and distribute that work
-   under terms of your choice, so long as that work isn't itself a
-   parser generator using the skeleton or a modified version thereof
-   as a parser skeleton.  Alternatively, if you modify or redistribute
-   the parser skeleton itself, you may (at your option) remove this
-   special exception, which will cause the skeleton and the resulting
-   Bison output files to be licensed under the GNU General Public
-   License without this special exception.
-
-   This special exception was added by the Free Software Foundation in
-   version 2.2 of Bison.  */
-
-/* Tokens.  */
-#ifndef YYTOKENTYPE
-# define YYTOKENTYPE
-   /* Put the tokens into the symbol table, so that GDB and other debuggers
-      know about them.  */
-   enum yytokentype {
-     ASM_KEYW = 258,
-     ATTRIBUTE_KEYW = 259,
-     AUTO_KEYW = 260,
-     BOOL_KEYW = 261,
-     CHAR_KEYW = 262,
-     CONST_KEYW = 263,
-     DOUBLE_KEYW = 264,
-     ENUM_KEYW = 265,
-     EXTERN_KEYW = 266,
-     EXTENSION_KEYW = 267,
-     FLOAT_KEYW = 268,
-     INLINE_KEYW = 269,
-     INT_KEYW = 270,
-     LONG_KEYW = 271,
-     REGISTER_KEYW = 272,
-     RESTRICT_KEYW = 273,
-     SHORT_KEYW = 274,
-     SIGNED_KEYW = 275,
-     STATIC_KEYW = 276,
-     STRUCT_KEYW = 277,
-     TYPEDEF_KEYW = 278,
-     UNION_KEYW = 279,
-     UNSIGNED_KEYW = 280,
-     VOID_KEYW = 281,
-     VOLATILE_KEYW = 282,
-     TYPEOF_KEYW = 283,
-     EXPORT_SYMBOL_KEYW = 284,
-     ASM_PHRASE = 285,
-     ATTRIBUTE_PHRASE = 286,
-     BRACE_PHRASE = 287,
-     BRACKET_PHRASE = 288,
-     EXPRESSION_PHRASE = 289,
-     CHAR = 290,
-     DOTS = 291,
-     IDENT = 292,
-     INT = 293,
-     REAL = 294,
-     STRING = 295,
-     TYPE = 296,
-     OTHER = 297,
-     FILENAME = 298
-   };
-#endif
-/* Tokens.  */
-#define ASM_KEYW 258
-#define ATTRIBUTE_KEYW 259
-#define AUTO_KEYW 260
-#define BOOL_KEYW 261
-#define CHAR_KEYW 262
-#define CONST_KEYW 263
-#define DOUBLE_KEYW 264
-#define ENUM_KEYW 265
-#define EXTERN_KEYW 266
-#define EXTENSION_KEYW 267
-#define FLOAT_KEYW 268
-#define INLINE_KEYW 269
-#define INT_KEYW 270
-#define LONG_KEYW 271
-#define REGISTER_KEYW 272
-#define RESTRICT_KEYW 273
-#define SHORT_KEYW 274
-#define SIGNED_KEYW 275
-#define STATIC_KEYW 276
-#define STRUCT_KEYW 277
-#define TYPEDEF_KEYW 278
-#define UNION_KEYW 279
-#define UNSIGNED_KEYW 280
-#define VOID_KEYW 281
-#define VOLATILE_KEYW 282
-#define TYPEOF_KEYW 283
-#define EXPORT_SYMBOL_KEYW 284
-#define ASM_PHRASE 285
-#define ATTRIBUTE_PHRASE 286
-#define BRACE_PHRASE 287
-#define BRACKET_PHRASE 288
-#define EXPRESSION_PHRASE 289
-#define CHAR 290
-#define DOTS 291
-#define IDENT 292
-#define INT 293
-#define REAL 294
-#define STRING 295
-#define TYPE 296
-#define OTHER 297
-#define FILENAME 298
-
-
-
-
-#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
-typedef int YYSTYPE;
-# define yystype YYSTYPE /* obsolescent; will be withdrawn */
-# define YYSTYPE_IS_DECLARED 1
-# define YYSTYPE_IS_TRIVIAL 1
-#endif
-
-extern YYSTYPE yylval;
-
 
-- 
1.7.4.1


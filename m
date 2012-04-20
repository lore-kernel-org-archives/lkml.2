Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab2DTWE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:04:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34148 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab2DTWEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:04:53 -0400
Date: Fri, 20 Apr 2012 15:04:41 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-9c6751280b6206e2a96f9600938003a29968e4fa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
In-Reply-To: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
References: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, extable:
  Remove open-coded exception table entries in arch/x86/lib/usercopy_32.c
Git-Commit-ID: 9c6751280b6206e2a96f9600938003a29968e4fa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Apr 2012 15:04:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c6751280b6206e2a96f9600938003a29968e4fa
Gitweb:     http://git.kernel.org/tip/9c6751280b6206e2a96f9600938003a29968e4fa
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 20 Apr 2012 12:19:52 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Apr 2012 13:51:39 -0700

x86, extable: Remove open-coded exception table entries in arch/x86/lib/usercopy_32.c

Remove open-coded exception table entries in arch/x86/lib/usercopy_32.c,
and replace them with _ASM_EXTABLE() macros; this will allow us to
change the format and type of the exception table entries.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: David Daney <david.daney@cavium.com>
Link: http://lkml.kernel.org/r/CA%2B55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com
---
 arch/x86/lib/usercopy_32.c |  232 ++++++++++++++++++++------------------------
 1 files changed, 106 insertions(+), 126 deletions(-)

diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index ef2a6a5..883b216 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <asm/uaccess.h>
 #include <asm/mmx.h>
+#include <asm/asm.h>
 
 #ifdef CONFIG_X86_INTEL_USERCOPY
 /*
@@ -127,10 +128,7 @@ long strnlen_user(const char __user *s, long n)
 		"3:	movb $1,%%al\n"
 		"	jmp 1b\n"
 		".previous\n"
-		".section __ex_table,\"a\"\n"
-		"	.align 4\n"
-		"	.long 0b,2b\n"
-		".previous"
+		_ASM_EXTABLE(0b,2b)
 		:"=&r" (n), "=&D" (s), "=&a" (res), "=&c" (tmp)
 		:"0" (n), "1" (s), "2" (0), "3" (mask)
 		:"cc");
@@ -199,47 +197,44 @@ __copy_user_intel(void __user *to, const void *from, unsigned long size)
 		       "101:   lea 0(%%eax,%0,4),%0\n"
 		       "       jmp 100b\n"
 		       ".previous\n"
-		       ".section __ex_table,\"a\"\n"
-		       "       .align 4\n"
-		       "       .long 1b,100b\n"
-		       "       .long 2b,100b\n"
-		       "       .long 3b,100b\n"
-		       "       .long 4b,100b\n"
-		       "       .long 5b,100b\n"
-		       "       .long 6b,100b\n"
-		       "       .long 7b,100b\n"
-		       "       .long 8b,100b\n"
-		       "       .long 9b,100b\n"
-		       "       .long 10b,100b\n"
-		       "       .long 11b,100b\n"
-		       "       .long 12b,100b\n"
-		       "       .long 13b,100b\n"
-		       "       .long 14b,100b\n"
-		       "       .long 15b,100b\n"
-		       "       .long 16b,100b\n"
-		       "       .long 17b,100b\n"
-		       "       .long 18b,100b\n"
-		       "       .long 19b,100b\n"
-		       "       .long 20b,100b\n"
-		       "       .long 21b,100b\n"
-		       "       .long 22b,100b\n"
-		       "       .long 23b,100b\n"
-		       "       .long 24b,100b\n"
-		       "       .long 25b,100b\n"
-		       "       .long 26b,100b\n"
-		       "       .long 27b,100b\n"
-		       "       .long 28b,100b\n"
-		       "       .long 29b,100b\n"
-		       "       .long 30b,100b\n"
-		       "       .long 31b,100b\n"
-		       "       .long 32b,100b\n"
-		       "       .long 33b,100b\n"
-		       "       .long 34b,100b\n"
-		       "       .long 35b,100b\n"
-		       "       .long 36b,100b\n"
-		       "       .long 37b,100b\n"
-		       "       .long 99b,101b\n"
-		       ".previous"
+		       _ASM_EXTABLE(1b,100b)
+		       _ASM_EXTABLE(2b,100b)
+		       _ASM_EXTABLE(3b,100b)
+		       _ASM_EXTABLE(4b,100b)
+		       _ASM_EXTABLE(5b,100b)
+		       _ASM_EXTABLE(6b,100b)
+		       _ASM_EXTABLE(7b,100b)
+		       _ASM_EXTABLE(8b,100b)
+		       _ASM_EXTABLE(9b,100b)
+		       _ASM_EXTABLE(10b,100b)
+		       _ASM_EXTABLE(11b,100b)
+		       _ASM_EXTABLE(12b,100b)
+		       _ASM_EXTABLE(13b,100b)
+		       _ASM_EXTABLE(14b,100b)
+		       _ASM_EXTABLE(15b,100b)
+		       _ASM_EXTABLE(16b,100b)
+		       _ASM_EXTABLE(17b,100b)
+		       _ASM_EXTABLE(18b,100b)
+		       _ASM_EXTABLE(19b,100b)
+		       _ASM_EXTABLE(20b,100b)
+		       _ASM_EXTABLE(21b,100b)
+		       _ASM_EXTABLE(22b,100b)
+		       _ASM_EXTABLE(23b,100b)
+		       _ASM_EXTABLE(24b,100b)
+		       _ASM_EXTABLE(25b,100b)
+		       _ASM_EXTABLE(26b,100b)
+		       _ASM_EXTABLE(27b,100b)
+		       _ASM_EXTABLE(28b,100b)
+		       _ASM_EXTABLE(29b,100b)
+		       _ASM_EXTABLE(30b,100b)
+		       _ASM_EXTABLE(31b,100b)
+		       _ASM_EXTABLE(32b,100b)
+		       _ASM_EXTABLE(33b,100b)
+		       _ASM_EXTABLE(34b,100b)
+		       _ASM_EXTABLE(35b,100b)
+		       _ASM_EXTABLE(36b,100b)
+		       _ASM_EXTABLE(37b,100b)
+		       _ASM_EXTABLE(99b,101b)
 		       : "=&c"(size), "=&D" (d0), "=&S" (d1)
 		       :  "1"(to), "2"(from), "0"(size)
 		       : "eax", "edx", "memory");
@@ -312,29 +307,26 @@ __copy_user_zeroing_intel(void *to, const void __user *from, unsigned long size)
 		       "        popl %0\n"
 		       "        jmp 8b\n"
 		       ".previous\n"
-		       ".section __ex_table,\"a\"\n"
-		       "	.align 4\n"
-		       "	.long 0b,16b\n"
-		       "	.long 1b,16b\n"
-		       "	.long 2b,16b\n"
-		       "	.long 21b,16b\n"
-		       "	.long 3b,16b\n"
-		       "	.long 31b,16b\n"
-		       "	.long 4b,16b\n"
-		       "	.long 41b,16b\n"
-		       "	.long 10b,16b\n"
-		       "	.long 51b,16b\n"
-		       "	.long 11b,16b\n"
-		       "	.long 61b,16b\n"
-		       "	.long 12b,16b\n"
-		       "	.long 71b,16b\n"
-		       "	.long 13b,16b\n"
-		       "	.long 81b,16b\n"
-		       "	.long 14b,16b\n"
-		       "	.long 91b,16b\n"
-		       "	.long 6b,9b\n"
-		       "        .long 7b,16b\n"
-		       ".previous"
+		       _ASM_EXTABLE(0b,16b)
+		       _ASM_EXTABLE(1b,16b)
+		       _ASM_EXTABLE(2b,16b)
+		       _ASM_EXTABLE(21b,16b)
+		       _ASM_EXTABLE(3b,16b)
+		       _ASM_EXTABLE(31b,16b)
+		       _ASM_EXTABLE(4b,16b)
+		       _ASM_EXTABLE(41b,16b)
+		       _ASM_EXTABLE(10b,16b)
+		       _ASM_EXTABLE(51b,16b)
+		       _ASM_EXTABLE(11b,16b)
+		       _ASM_EXTABLE(61b,16b)
+		       _ASM_EXTABLE(12b,16b)
+		       _ASM_EXTABLE(71b,16b)
+		       _ASM_EXTABLE(13b,16b)
+		       _ASM_EXTABLE(81b,16b)
+		       _ASM_EXTABLE(14b,16b)
+		       _ASM_EXTABLE(91b,16b)
+		       _ASM_EXTABLE(6b,9b)
+		       _ASM_EXTABLE(7b,16b)
 		       : "=&c"(size), "=&D" (d0), "=&S" (d1)
 		       :  "1"(to), "2"(from), "0"(size)
 		       : "eax", "edx", "memory");
@@ -414,29 +406,26 @@ static unsigned long __copy_user_zeroing_intel_nocache(void *to,
 	       "        popl %0\n"
 	       "        jmp 8b\n"
 	       ".previous\n"
-	       ".section __ex_table,\"a\"\n"
-	       "	.align 4\n"
-	       "	.long 0b,16b\n"
-	       "	.long 1b,16b\n"
-	       "	.long 2b,16b\n"
-	       "	.long 21b,16b\n"
-	       "	.long 3b,16b\n"
-	       "	.long 31b,16b\n"
-	       "	.long 4b,16b\n"
-	       "	.long 41b,16b\n"
-	       "	.long 10b,16b\n"
-	       "	.long 51b,16b\n"
-	       "	.long 11b,16b\n"
-	       "	.long 61b,16b\n"
-	       "	.long 12b,16b\n"
-	       "	.long 71b,16b\n"
-	       "	.long 13b,16b\n"
-	       "	.long 81b,16b\n"
-	       "	.long 14b,16b\n"
-	       "	.long 91b,16b\n"
-	       "	.long 6b,9b\n"
-	       "        .long 7b,16b\n"
-	       ".previous"
+	       _ASM_EXTABLE(0b,16b)
+	       _ASM_EXTABLE(1b,16b)
+	       _ASM_EXTABLE(2b,16b)
+	       _ASM_EXTABLE(21b,16b)
+	       _ASM_EXTABLE(3b,16b)
+	       _ASM_EXTABLE(31b,16b)
+	       _ASM_EXTABLE(4b,16b)
+	       _ASM_EXTABLE(41b,16b)
+	       _ASM_EXTABLE(10b,16b)
+	       _ASM_EXTABLE(51b,16b)
+	       _ASM_EXTABLE(11b,16b)
+	       _ASM_EXTABLE(61b,16b)
+	       _ASM_EXTABLE(12b,16b)
+	       _ASM_EXTABLE(71b,16b)
+	       _ASM_EXTABLE(13b,16b)
+	       _ASM_EXTABLE(81b,16b)
+	       _ASM_EXTABLE(14b,16b)
+	       _ASM_EXTABLE(91b,16b)
+	       _ASM_EXTABLE(6b,9b)
+	       _ASM_EXTABLE(7b,16b)
 	       : "=&c"(size), "=&D" (d0), "=&S" (d1)
 	       :  "1"(to), "2"(from), "0"(size)
 	       : "eax", "edx", "memory");
@@ -505,29 +494,26 @@ static unsigned long __copy_user_intel_nocache(void *to,
 	       "9:      lea 0(%%eax,%0,4),%0\n"
 	       "16:     jmp 8b\n"
 	       ".previous\n"
-	       ".section __ex_table,\"a\"\n"
-	       "	.align 4\n"
-	       "	.long 0b,16b\n"
-	       "	.long 1b,16b\n"
-	       "	.long 2b,16b\n"
-	       "	.long 21b,16b\n"
-	       "	.long 3b,16b\n"
-	       "	.long 31b,16b\n"
-	       "	.long 4b,16b\n"
-	       "	.long 41b,16b\n"
-	       "	.long 10b,16b\n"
-	       "	.long 51b,16b\n"
-	       "	.long 11b,16b\n"
-	       "	.long 61b,16b\n"
-	       "	.long 12b,16b\n"
-	       "	.long 71b,16b\n"
-	       "	.long 13b,16b\n"
-	       "	.long 81b,16b\n"
-	       "	.long 14b,16b\n"
-	       "	.long 91b,16b\n"
-	       "	.long 6b,9b\n"
-	       "        .long 7b,16b\n"
-	       ".previous"
+	       _ASM_EXTABLE(0b,16b)
+	       _ASM_EXTABLE(1b,16b)
+	       _ASM_EXTABLE(2b,16b)
+	       _ASM_EXTABLE(21b,16b)
+	       _ASM_EXTABLE(3b,16b)
+	       _ASM_EXTABLE(31b,16b)
+	       _ASM_EXTABLE(4b,16b)
+	       _ASM_EXTABLE(41b,16b)
+	       _ASM_EXTABLE(10b,16b)
+	       _ASM_EXTABLE(51b,16b)
+	       _ASM_EXTABLE(11b,16b)
+	       _ASM_EXTABLE(61b,16b)
+	       _ASM_EXTABLE(12b,16b)
+	       _ASM_EXTABLE(71b,16b)
+	       _ASM_EXTABLE(13b,16b)
+	       _ASM_EXTABLE(81b,16b)
+	       _ASM_EXTABLE(14b,16b)
+	       _ASM_EXTABLE(91b,16b)
+	       _ASM_EXTABLE(6b,9b)
+	       _ASM_EXTABLE(7b,16b)
 	       : "=&c"(size), "=&D" (d0), "=&S" (d1)
 	       :  "1"(to), "2"(from), "0"(size)
 	       : "eax", "edx", "memory");
@@ -574,12 +560,9 @@ do {									\
 		"3:	lea 0(%3,%0,4),%0\n"				\
 		"	jmp 2b\n"					\
 		".previous\n"						\
-		".section __ex_table,\"a\"\n"				\
-		"	.align 4\n"					\
-		"	.long 4b,5b\n"					\
-		"	.long 0b,3b\n"					\
-		"	.long 1b,2b\n"					\
-		".previous"						\
+		_ASM_EXTABLE(4b,5b)					\
+		_ASM_EXTABLE(0b,3b)					\
+		_ASM_EXTABLE(1b,2b)					\
 		: "=&c"(size), "=&D" (__d0), "=&S" (__d1), "=r"(__d2)	\
 		: "3"(size), "0"(size), "1"(to), "2"(from)		\
 		: "memory");						\
@@ -616,12 +599,9 @@ do {									\
 		"	popl %0\n"					\
 		"	jmp 2b\n"					\
 		".previous\n"						\
-		".section __ex_table,\"a\"\n"				\
-		"	.align 4\n"					\
-		"	.long 4b,5b\n"					\
-		"	.long 0b,3b\n"					\
-		"	.long 1b,6b\n"					\
-		".previous"						\
+		_ASM_EXTABLE(4b,5b)					\
+		_ASM_EXTABLE(0b,3b)					\
+		_ASM_EXTABLE(1b,6b)					\
 		: "=&c"(size), "=&D" (__d0), "=&S" (__d1), "=r"(__d2)	\
 		: "3"(size), "0"(size), "1"(to), "2"(from)		\
 		: "memory");						\

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab2DTWAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:00:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34084 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2DTWAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:00:42 -0400
Date: Fri, 20 Apr 2012 15:00:31 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-9732da8ca860053515431298ec969e1f3e6bc64a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
In-Reply-To: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
References: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, extable:
  Remove open-coded exception table entries in arch/x86/lib/copy_user_64.S
Git-Commit-ID: 9732da8ca860053515431298ec969e1f3e6bc64a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Apr 2012 15:00:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9732da8ca860053515431298ec969e1f3e6bc64a
Gitweb:     http://git.kernel.org/tip/9732da8ca860053515431298ec969e1f3e6bc64a
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 20 Apr 2012 12:19:51 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Apr 2012 13:51:38 -0700

x86, extable: Remove open-coded exception table entries in arch/x86/lib/copy_user_64.S

Remove open-coded exception table entries in arch/x86/lib/copy_user_64.S,
and replace them with _ASM_EXTABLE() macros; this will allow us to
change the format and type of the exception table entries.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: David Daney <david.daney@cavium.com>
Link: http://lkml.kernel.org/r/CA%2B55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com
---
 arch/x86/lib/copy_user_64.S |   63 +++++++++++++++++-------------------------
 1 files changed, 26 insertions(+), 37 deletions(-)

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 0248402..5b2995f 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -16,6 +16,7 @@
 #include <asm/thread_info.h>
 #include <asm/cpufeature.h>
 #include <asm/alternative-asm.h>
+#include <asm/asm.h>
 
 /*
  * By placing feature2 after feature1 in altinstructions section, we logically
@@ -63,11 +64,8 @@
 	jmp copy_user_handle_tail
 	.previous
 
-	.section __ex_table,"a"
-	.align 8
-	.quad 100b,103b
-	.quad 101b,103b
-	.previous
+	_ASM_EXTABLE(100b,103b)
+	_ASM_EXTABLE(101b,103b)
 #endif
 	.endm
 
@@ -191,29 +189,26 @@ ENTRY(copy_user_generic_unrolled)
 60:	jmp copy_user_handle_tail /* ecx is zerorest also */
 	.previous
 
-	.section __ex_table,"a"
-	.align 8
-	.quad 1b,30b
-	.quad 2b,30b
-	.quad 3b,30b
-	.quad 4b,30b
-	.quad 5b,30b
-	.quad 6b,30b
-	.quad 7b,30b
-	.quad 8b,30b
-	.quad 9b,30b
-	.quad 10b,30b
-	.quad 11b,30b
-	.quad 12b,30b
-	.quad 13b,30b
-	.quad 14b,30b
-	.quad 15b,30b
-	.quad 16b,30b
-	.quad 18b,40b
-	.quad 19b,40b
-	.quad 21b,50b
-	.quad 22b,50b
-	.previous
+	_ASM_EXTABLE(1b,30b)
+	_ASM_EXTABLE(2b,30b)
+	_ASM_EXTABLE(3b,30b)
+	_ASM_EXTABLE(4b,30b)
+	_ASM_EXTABLE(5b,30b)
+	_ASM_EXTABLE(6b,30b)
+	_ASM_EXTABLE(7b,30b)
+	_ASM_EXTABLE(8b,30b)
+	_ASM_EXTABLE(9b,30b)
+	_ASM_EXTABLE(10b,30b)
+	_ASM_EXTABLE(11b,30b)
+	_ASM_EXTABLE(12b,30b)
+	_ASM_EXTABLE(13b,30b)
+	_ASM_EXTABLE(14b,30b)
+	_ASM_EXTABLE(15b,30b)
+	_ASM_EXTABLE(16b,30b)
+	_ASM_EXTABLE(18b,40b)
+	_ASM_EXTABLE(19b,40b)
+	_ASM_EXTABLE(21b,50b)
+	_ASM_EXTABLE(22b,50b)
 	CFI_ENDPROC
 ENDPROC(copy_user_generic_unrolled)
 
@@ -259,11 +254,8 @@ ENTRY(copy_user_generic_string)
 	jmp copy_user_handle_tail
 	.previous
 
-	.section __ex_table,"a"
-	.align 8
-	.quad 1b,11b
-	.quad 3b,12b
-	.previous
+	_ASM_EXTABLE(1b,11b)
+	_ASM_EXTABLE(3b,12b)
 	CFI_ENDPROC
 ENDPROC(copy_user_generic_string)
 
@@ -294,9 +286,6 @@ ENTRY(copy_user_enhanced_fast_string)
 	jmp copy_user_handle_tail
 	.previous
 
-	.section __ex_table,"a"
-	.align 8
-	.quad 1b,12b
-	.previous
+	_ASM_EXTABLE(1b,12b)
 	CFI_ENDPROC
 ENDPROC(copy_user_enhanced_fast_string)

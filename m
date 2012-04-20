Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab2DTWBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:01:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34101 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab2DTWBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:01:32 -0400
Date: Fri, 20 Apr 2012 15:01:22 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-0d8559feafbc9dc5a2c17ba42aea7de824b18308@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
In-Reply-To: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
References: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, extable:
  Remove open-coded exception table entries in arch/x86/lib/
 copy_user_nocache_64.S
Git-Commit-ID: 0d8559feafbc9dc5a2c17ba42aea7de824b18308
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Apr 2012 15:01:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d8559feafbc9dc5a2c17ba42aea7de824b18308
Gitweb:     http://git.kernel.org/tip/0d8559feafbc9dc5a2c17ba42aea7de824b18308
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 20 Apr 2012 12:19:51 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Apr 2012 13:51:38 -0700

x86, extable: Remove open-coded exception table entries in arch/x86/lib/copy_user_nocache_64.S

Remove open-coded exception table entries in arch/x86/lib/copy_user_nocache_64.S,
and replace them with _ASM_EXTABLE() macros; this will allow us to
change the format and type of the exception table entries.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: David Daney <david.daney@cavium.com>
Link: http://lkml.kernel.org/r/CA%2B55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com
---
 arch/x86/lib/copy_user_nocache_64.S |   50 ++++++++++++++++-------------------
 1 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/arch/x86/lib/copy_user_nocache_64.S b/arch/x86/lib/copy_user_nocache_64.S
index cb0c112..cacddc7 100644
--- a/arch/x86/lib/copy_user_nocache_64.S
+++ b/arch/x86/lib/copy_user_nocache_64.S
@@ -14,6 +14,7 @@
 #include <asm/current.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
+#include <asm/asm.h>
 
 	.macro ALIGN_DESTINATION
 #ifdef FIX_ALIGNMENT
@@ -36,11 +37,8 @@
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
 
@@ -111,27 +109,25 @@ ENTRY(__copy_user_nocache)
 	jmp copy_user_handle_tail
 	.previous
 
-	.section __ex_table,"a"
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
 ENDPROC(__copy_user_nocache)

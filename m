Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab2I2RH6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 13:07:58 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:58134 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994Ab2I2RHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 13:07:55 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        x86@kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/4] arch/x86/um: Drop UM_ prefix from printk() level specifiers
Date: Sat, 29 Sep 2012 19:07:39 +0200
Message-Id: <1348938460-20919-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1348938460-20919-1-git-send-email-geert@linux-m68k.org>
References: <1348938460-20919-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 9429ec96c2718c0d1e3317cf60a87a0405223814 ("um: Preinclude
include/linux/kern_levels.h") the non-prefixed printk() level specifiers
are usable for the user parts of UML.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/x86/um/bugs_32.c            |   14 +++++++-------
 arch/x86/um/os-Linux/registers.c |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/um/bugs_32.c b/arch/x86/um/bugs_32.c
index 17d88cf..d2bccc5 100644
--- a/arch/x86/um/bugs_32.c
+++ b/arch/x86/um/bugs_32.c
@@ -23,7 +23,7 @@ void arch_check_bugs(void)
 {
 	struct sigaction old, new;
 
-	printk(UM_KERN_INFO "Checking for host processor cmov support...");
+	printk(KERN_INFO "Checking for host processor cmov support...");
 	new.sa_handler = cmov_sigill_test_handler;
 
 	/* Make sure that SIGILL is enabled after the handler longjmps back */
@@ -34,9 +34,9 @@ void arch_check_bugs(void)
 	if (setjmp(cmov_test_return) == 0) {
 		unsigned long foo = 0;
 		__asm__ __volatile__("cmovz %0, %1" : "=r" (foo) : "0" (foo));
-		printk(UM_KERN_CONT "Yes\n");
+		printk(KERN_CONT "Yes\n");
 	} else
-		printk(UM_KERN_CONT "No\n");
+		printk(KERN_CONT "No\n");
 
 	sigaction(SIGILL, &old, &new);
 }
@@ -53,7 +53,7 @@ void arch_examine_signal(int sig, struct uml_pt_regs *regs)
 		return;
 
 	if (copy_from_user_proc(tmp, (void *) UPT_IP(regs), 2)) {
-		printk(UM_KERN_ERR "SIGILL in init, could not read "
+		printk(KERN_ERR "SIGILL in init, could not read "
 		       "instructions!\n");
 		return;
 	}
@@ -62,13 +62,13 @@ void arch_examine_signal(int sig, struct uml_pt_regs *regs)
 		return;
 
 	if (host_has_cmov == 0)
-		printk(UM_KERN_ERR "SIGILL caused by cmov, which this "
+		printk(KERN_ERR "SIGILL caused by cmov, which this "
 		       "processor doesn't implement.  Boot a filesystem "
 		       "compiled for older processors");
 	else if (host_has_cmov == 1)
-		printk(UM_KERN_ERR "SIGILL caused by cmov, which this "
+		printk(KERN_ERR "SIGILL caused by cmov, which this "
 		       "processor claims to implement");
 	else
-		printk(UM_KERN_ERR "Bad value for host_has_cmov (%d)",
+		printk(KERN_ERR "Bad value for host_has_cmov (%d)",
 			host_has_cmov);
 }
diff --git a/arch/x86/um/os-Linux/registers.c b/arch/x86/um/os-Linux/registers.c
index 0cdbb86..7719500 100644
--- a/arch/x86/um/os-Linux/registers.c
+++ b/arch/x86/um/os-Linux/registers.c
@@ -106,7 +106,7 @@ unsigned long get_thread_reg(int reg, jmp_buf *buf)
 		return buf[0]->__rbp;
 #endif
 	default:
-		printk(UM_KERN_ERR "get_thread_regs - unknown register %d\n",
+		printk(KERN_ERR "get_thread_regs - unknown register %d\n",
 		       reg);
 		return 0;
 	}
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934838Ab2DLWEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:04:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:38848 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965115Ab2DLWEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:04:08 -0400
Date: Fri, 13 Apr 2012 00:04:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: [GIT pull] x86 fixes for 3.4
Message-ID: <alpine.LFD.2.02.1204130000590.2542@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

Thanks,

	tglx

------------------>
Emil Goode (1):
      x86: vsyscall: Use NULL instead 0 for a pointer argument

H. Peter Anvin (1):
      x86: Use correct byte-sized register constraint in __add()

Jeremy Fitzhardinge (1):
      x86: Use correct byte-sized register constraint in __xchg_op()


 arch/x86/include/asm/cmpxchg.h |    4 ++--
 arch/x86/kernel/vsyscall_64.c  |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index b3b7332..99480e5 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -43,7 +43,7 @@ extern void __add_wrong_size(void)
 		switch (sizeof(*(ptr))) {				\
 		case __X86_CASE_B:					\
 			asm volatile (lock #op "b %b0, %1\n"		\
-				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : "+q" (__ret), "+m" (*(ptr))	\
 				      : : "memory", "cc");		\
 			break;						\
 		case __X86_CASE_W:					\
@@ -173,7 +173,7 @@ extern void __add_wrong_size(void)
 		switch (sizeof(*(ptr))) {				\
 		case __X86_CASE_B:					\
 			asm volatile (lock "addb %b1, %0\n"		\
-				      : "+m" (*(ptr)) : "ri" (inc)	\
+				      : "+m" (*(ptr)) : "qi" (inc)	\
 				      : "memory", "cc");		\
 			break;						\
 		case __X86_CASE_W:					\
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index f386dc4..7515cf0 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -216,9 +216,9 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 	current_thread_info()->sig_on_uaccess_error = 1;
 
 	/*
-	 * 0 is a valid user pointer (in the access_ok sense) on 32-bit and
+	 * NULL is a valid user pointer (in the access_ok sense) on 32-bit and
 	 * 64-bit, so we don't need to special-case it here.  For all the
-	 * vsyscalls, 0 means "don't write anything" not "write it at
+	 * vsyscalls, NULL means "don't write anything" not "write it at
 	 * address 0".
 	 */
 	ret = -EFAULT;
@@ -247,7 +247,7 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned long address)
 
 		ret = sys_getcpu((unsigned __user *)regs->di,
 				 (unsigned __user *)regs->si,
-				 0);
+				 NULL);
 		break;
 	}
 

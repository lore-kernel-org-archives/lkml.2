Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760408Ab2EJReT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:34:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58653 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760384Ab2EJReN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:34:13 -0400
Message-Id: <20120510173134.438866619@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 17/52] ARM: 7412/1: audit: use only AUDIT_ARCH_ARM regardless of endianness
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 2f978366984a418f38fcf44137be1fbc5a89cfd9 upstream.

The machine endianness has no direct correspondence to the syscall ABI,
so use only AUDIT_ARCH_ARM when identifying the ABI to the audit tools
in userspace.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/ptrace.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -905,12 +905,6 @@ long arch_ptrace(struct task_struct *chi
 	return ret;
 }
 
-#ifdef __ARMEB__
-#define AUDIT_ARCH_NR AUDIT_ARCH_ARMEB
-#else
-#define AUDIT_ARCH_NR AUDIT_ARCH_ARM
-#endif
-
 asmlinkage int syscall_trace(int why, struct pt_regs *regs, int scno)
 {
 	unsigned long ip;
@@ -918,7 +912,7 @@ asmlinkage int syscall_trace(int why, st
 	if (why)
 		audit_syscall_exit(regs);
 	else
-		audit_syscall_entry(AUDIT_ARCH_NR, scno, regs->ARM_r0,
+		audit_syscall_entry(AUDIT_ARCH_ARM, scno, regs->ARM_r0,
 				    regs->ARM_r1, regs->ARM_r2, regs->ARM_r3);
 
 	if (!test_thread_flag(TIF_SYSCALL_TRACE))



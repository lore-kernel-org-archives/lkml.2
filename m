Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934211Ab1EWWUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:20:14 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:45942 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab1EWWUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:20:11 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        namhyung@gmail.com, akpm@linux-foundation.org, davem@davemloft.net,
        fweisbec@gmail.com, dhowells@redhat.com,
        Richard Weinberger <richard@nod.at>
Subject: [RFC][PATCH] x86: get rid of asmregparm
Date: Tue, 24 May 2011 00:18:05 +0200
Message-Id: <1306189085-29896-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As UML does no longer need asmregparm we can remove it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/x86/include/asm/linkage.h |    5 -----
 arch/x86/kernel/ptrace.c       |    4 ++--
 include/linux/linkage.h        |    4 ----
 3 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index 12d55e7..4814297 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -8,11 +8,6 @@
 
 #ifdef CONFIG_X86_32
 #define asmlinkage CPP_ASMLINKAGE __attribute__((regparm(0)))
-/*
- * For 32-bit UML - mark functions implemented in assembly that use
- * regparm input parameters:
- */
-#define asmregparm __attribute__((regparm(3)))
 
 /*
  * Make sure the compiler doesn't do anything stupid with the
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index f65e5b5..807c2a2 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1363,7 +1363,7 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
  * We must return the syscall number to actually look up in the table.
  * This can be -1L to skip running any syscall at all.
  */
-asmregparm long syscall_trace_enter(struct pt_regs *regs)
+long syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
@@ -1408,7 +1408,7 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
 	return ret ?: regs->orig_ax;
 }
 
-asmregparm void syscall_trace_leave(struct pt_regs *regs)
+void syscall_trace_leave(struct pt_regs *regs)
 {
 	bool step;
 
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 7135ebc..3f46aed 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -14,10 +14,6 @@
 #define asmlinkage CPP_ASMLINKAGE
 #endif
 
-#ifndef asmregparm
-# define asmregparm
-#endif
-
 #define __page_aligned_data	__section(.data..page_aligned) __aligned(PAGE_SIZE)
 #define __page_aligned_bss	__section(.bss..page_aligned) __aligned(PAGE_SIZE)
 
-- 
1.7.4.2


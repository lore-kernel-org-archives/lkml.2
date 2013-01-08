Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab3AHXkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:40:25 -0500
Received: from mail.windriver.com ([147.11.1.11]:64295 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135Ab3AHXkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:40:21 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Richard Weinberger <richard@nod.at>, <namhyung@gmail.com>,
        <davem@davemloft.net>, <fweisbec@gmail.com>, <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 76/77] x86: Get rid of asmregparm
Date: Tue, 8 Jan 2013 18:35:55 -0500
Message-ID: <1357688156-25387-77-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 1b4ac2a935aaf194241a2f4165d6407ba9650e1a upstream.

As UML does no longer need asmregparm we can remove it.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: namhyung@gmail.com
Cc: davem@davemloft.net
Cc: fweisbec@gmail.com
Cc: dhowells@redhat.com
Link: http://lkml.kernel.org/r/%3C1306189085-29896-1-git-send-email-richard%40nod.at%3E
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/include/asm/linkage.h | 5 -----
 arch/x86/kernel/ptrace.c       | 4 ++--
 include/linux/linkage.h        | 4 ----
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
index 2e9b550..8b57128 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1730,7 +1730,7 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
  * We must return the syscall number to actually look up in the table.
  * This can be -1L to skip running any syscall at all.
  */
-asmregparm long syscall_trace_enter(struct pt_regs *regs)
+long syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
@@ -1775,7 +1775,7 @@ asmregparm long syscall_trace_enter(struct pt_regs *regs)
 	return ret ?: regs->orig_ax;
 }
 
-asmregparm void syscall_trace_leave(struct pt_regs *regs)
+void syscall_trace_leave(struct pt_regs *regs)
 {
 	bool step;
 
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 5126cce..a500d6b 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -14,10 +14,6 @@
 #define asmlinkage CPP_ASMLINKAGE
 #endif
 
-#ifndef asmregparm
-# define asmregparm
-#endif
-
 #define __page_aligned_data	__section(.data.page_aligned) __aligned(PAGE_SIZE)
 #define __page_aligned_bss	__section(.bss.page_aligned) __aligned(PAGE_SIZE)
 
-- 
1.7.12.1


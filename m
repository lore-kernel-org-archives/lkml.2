Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab0HRQ3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:29:00 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:39013 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750966Ab0HRQ26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:28:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALKma0zCTtAn/2dsb2JhbACgS3HAXoU3BIlt
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org
Cc: Philippe De Muyter <phdm@macqel.be>
Subject: [PATCH] m68k{nommu} : Remove unused DEFINE's from asm-offsets.c
Date: Wed, 18 Aug 2010 18:27:34 +0200
Message-Id: <1282148854-17103-1-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k{nommu}/asm-offsets.c define many constants which are not used
anymore anywhere; remove IRQ_DEVID, IRQ_HANDLER, IRQ_NEXT, STAT_IRQ,
TASK_ACTIVE_MM, TASK_BLOCKED, TASK_FLAGS, TASK_PTRACE, TASK_STATE,
TASK_THREAD_INFO, TI_CPU, TI_EXECDOMAIN and TI_TASK.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
---
 arch/m68k/kernel/asm-offsets.c      |   12 ------------
 arch/m68knommu/kernel/asm-offsets.c |    9 ---------
 2 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/arch/m68k/kernel/asm-offsets.c b/arch/m68k/kernel/asm-offsets.c
index 73e5e58..78e59b8 100644
--- a/arch/m68k/kernel/asm-offsets.c
+++ b/arch/m68k/kernel/asm-offsets.c
@@ -22,13 +22,9 @@
 int main(void)
 {
 	/* offsets into the task struct */
-	DEFINE(TASK_STATE, offsetof(struct task_struct, state));
-	DEFINE(TASK_FLAGS, offsetof(struct task_struct, flags));
-	DEFINE(TASK_PTRACE, offsetof(struct task_struct, ptrace));
 	DEFINE(TASK_THREAD, offsetof(struct task_struct, thread));
 	DEFINE(TASK_INFO, offsetof(struct task_struct, thread.info));
 	DEFINE(TASK_MM, offsetof(struct task_struct, mm));
-	DEFINE(TASK_ACTIVE_MM, offsetof(struct task_struct, active_mm));
 #ifdef CONFIG_MMU
 	DEFINE(TASK_TINFO, offsetof(struct task_struct, thread.info));
 #endif
@@ -64,14 +60,6 @@ int main(void)
 	/* bitfields are a bit difficult */
 	DEFINE(PT_OFF_FORMATVEC, offsetof(struct pt_regs, pc) + 4);
 
-	/* offsets into the irq_handler struct */
-	DEFINE(IRQ_HANDLER, offsetof(struct irq_node, handler));
-	DEFINE(IRQ_DEVID, offsetof(struct irq_node, dev_id));
-	DEFINE(IRQ_NEXT, offsetof(struct irq_node, next));
-
-	/* offsets into the kernel_stat struct */
-	DEFINE(STAT_IRQ, offsetof(struct kernel_stat, irqs));
-
 	/* offsets into the irq_cpustat_t struct */
 	DEFINE(CPUSTAT_SOFTIRQ_PENDING, offsetof(irq_cpustat_t, __softirq_pending));
 
diff --git a/arch/m68knommu/kernel/asm-offsets.c b/arch/m68knommu/kernel/asm-offsets.c
index 9a8876f..eca508c 100644
--- a/arch/m68knommu/kernel/asm-offsets.c
+++ b/arch/m68knommu/kernel/asm-offsets.c
@@ -21,14 +21,8 @@
 int main(void)
 {
 	/* offsets into the task struct */
-	DEFINE(TASK_STATE, offsetof(struct task_struct, state));
-	DEFINE(TASK_FLAGS, offsetof(struct task_struct, flags));
-	DEFINE(TASK_PTRACE, offsetof(struct task_struct, ptrace));
-	DEFINE(TASK_BLOCKED, offsetof(struct task_struct, blocked));
 	DEFINE(TASK_THREAD, offsetof(struct task_struct, thread));
-	DEFINE(TASK_THREAD_INFO, offsetof(struct task_struct, stack));
 	DEFINE(TASK_MM, offsetof(struct task_struct, mm));
-	DEFINE(TASK_ACTIVE_MM, offsetof(struct task_struct, active_mm));
 
 	/* offsets into the irq_cpustat_t struct */
 	DEFINE(CPUSTAT_SOFTIRQ_PENDING, offsetof(irq_cpustat_t, __softirq_pending));
@@ -77,11 +71,8 @@ int main(void)
 	DEFINE(THREAD_SIZE, THREAD_SIZE);
 
 	/* Offsets in thread_info structure */
-	DEFINE(TI_TASK, offsetof(struct thread_info, task));
-	DEFINE(TI_EXECDOMAIN, offsetof(struct thread_info, exec_domain));
 	DEFINE(TI_FLAGS, offsetof(struct thread_info, flags));
 	DEFINE(TI_PREEMPTCOUNT, offsetof(struct thread_info, preempt_count));
-	DEFINE(TI_CPU, offsetof(struct thread_info, cpu));
 
 	return 0;
 }
-- 
1.6.3.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab1DNIdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:33:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:47140 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757746Ab1DNIdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:33:23 -0400
Date: Thu, 14 Apr 2011 08:31:10 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-184748cc50b2dceb8287f9fb657eda48ff8fcfe7@git.kernel.org>
Cc: mingo@redhat.com, jesper.nilsson@axis.com, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, schwidefsky@de.ibm.com,
        rmk+kernel@arm.linux.org.uk, cmetcalf@tilera.com, npiggin@kernel.dk,
        akpm@linux-foundation.org, ralf@linux-mips.org,
        frank.rowand@am.sony.com, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org, mingo@elte.hu
Reply-To: mingo@redhat.com, jesper.nilsson@axis.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, rmk+kernel@arm.linux.org.uk,
        schwidefsky@de.ibm.com, efault@gmx.de, cmetcalf@tilera.com,
        npiggin@kernel.dk, ralf@linux-mips.org, akpm@linux-foundation.org,
        tglx@linutronix.de, frank.rowand@am.sony.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org, mingo@elte.hu
In-Reply-To: <20110405152728.744338123@chello.nl>
References: <20110405152728.744338123@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Provide scheduler_ipi() callback in response to smp_send_reschedule()
Git-Commit-ID: 184748cc50b2dceb8287f9fb657eda48ff8fcfe7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:31:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  184748cc50b2dceb8287f9fb657eda48ff8fcfe7
Gitweb:     http://git.kernel.org/tip/184748cc50b2dceb8287f9fb657eda48ff8fcfe7
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:32 +0200

sched: Provide scheduler_ipi() callback in response to smp_send_reschedule()

For future rework of try_to_wake_up() we'd like to push part of that
function onto the CPU the task is actually going to run on.

In order to do so we need a generic callback from the existing scheduler IPI.

This patch introduces such a generic callback: scheduler_ipi() and
implements it as a NOP.

BenH notes: PowerPC might use this IPI on offline CPUs under rare conditions!

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110405152728.744338123@chello.nl
---
 arch/alpha/kernel/smp.c             |    3 +--
 arch/arm/kernel/smp.c               |    5 +----
 arch/blackfin/mach-common/smp.c     |    3 +++
 arch/cris/arch-v32/kernel/smp.c     |   13 ++++++++-----
 arch/ia64/kernel/irq_ia64.c         |    2 ++
 arch/ia64/xen/irq_xen.c             |   10 +++++++++-
 arch/m32r/kernel/smp.c              |    4 +---
 arch/mips/cavium-octeon/smp.c       |    2 ++
 arch/mips/kernel/smtc.c             |    2 +-
 arch/mips/mti-malta/malta-int.c     |    2 ++
 arch/mips/pmc-sierra/yosemite/smp.c |    4 ++++
 arch/mips/sgi-ip27/ip27-irq.c       |    2 ++
 arch/mips/sibyte/bcm1480/smp.c      |    7 +++----
 arch/mips/sibyte/sb1250/smp.c       |    7 +++----
 arch/mn10300/kernel/smp.c           |    5 +----
 arch/parisc/kernel/smp.c            |    5 +----
 arch/powerpc/kernel/smp.c           |    4 ++--
 arch/s390/kernel/smp.c              |    6 +++---
 arch/sh/kernel/smp.c                |    2 ++
 arch/sparc/kernel/smp_32.c          |    4 +++-
 arch/sparc/kernel/smp_64.c          |    1 +
 arch/tile/kernel/smp.c              |    6 +-----
 arch/um/kernel/smp.c                |    2 +-
 arch/x86/kernel/smp.c               |    5 ++---
 arch/x86/xen/smp.c                  |    5 ++---
 include/linux/sched.h               |    2 ++
 26 files changed, 63 insertions(+), 50 deletions(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 42aa078..5a621c6 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -585,8 +585,7 @@ handle_ipi(struct pt_regs *regs)
 
 		switch (which) {
 		case IPI_RESCHEDULE:
-			/* Reschedule callback.  Everything to be done
-			   is done by the interrupt return path.  */
+			scheduler_ipi();
 			break;
 
 		case IPI_CALL_FUNC:
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 8fe05ad..7a561eb 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -560,10 +560,7 @@ asmlinkage void __exception_irq_entry do_IPI(int ipinr, struct pt_regs *regs)
 		break;
 
 	case IPI_RESCHEDULE:
-		/*
-		 * nothing more to do - eveything is
-		 * done on the interrupt return path
-		 */
+		scheduler_ipi();
 		break;
 
 	case IPI_CALL_FUNC:
diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index 6e17a26..326bb86 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -164,6 +164,9 @@ static irqreturn_t ipi_handler_int1(int irq, void *dev_instance)
 	while (msg_queue->count) {
 		msg = &msg_queue->ipi_message[msg_queue->head];
 		switch (msg->type) {
+		case BFIN_IPI_RESCHEDULE:
+			scheduler_ipi();
+			break;
 		case BFIN_IPI_CALL_FUNC:
 			spin_unlock_irqrestore(&msg_queue->lock, flags);
 			ipi_call_function(cpu, msg);
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index 4c9e3e1..66cc756 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -342,15 +342,18 @@ irqreturn_t crisv32_ipi_interrupt(int irq, void *dev_id)
 
 	ipi = REG_RD(intr_vect, irq_regs[smp_processor_id()], rw_ipi);
 
+	if (ipi.vector & IPI_SCHEDULE) {
+		scheduler_ipi();
+	}
 	if (ipi.vector & IPI_CALL) {
-	         func(info);
+		func(info);
 	}
 	if (ipi.vector & IPI_FLUSH_TLB) {
-		     if (flush_mm == FLUSH_ALL)
-			 __flush_tlb_all();
-		     else if (flush_vma == FLUSH_ALL)
+		if (flush_mm == FLUSH_ALL)
+			__flush_tlb_all();
+		else if (flush_vma == FLUSH_ALL)
 			__flush_tlb_mm(flush_mm);
-		     else
+		else
 			__flush_tlb_page(flush_vma, flush_addr);
 	}
 
diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index 5b70474..782c3a35 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -31,6 +31,7 @@
 #include <linux/irq.h>
 #include <linux/ratelimit.h>
 #include <linux/acpi.h>
+#include <linux/sched.h>
 
 #include <asm/delay.h>
 #include <asm/intrinsics.h>
@@ -496,6 +497,7 @@ ia64_handle_irq (ia64_vector vector, struct pt_regs *regs)
 			smp_local_flush_tlb();
 			kstat_incr_irqs_this_cpu(irq, desc);
 		} else if (unlikely(IS_RESCHEDULE(vector))) {
+			scheduler_ipi();
 			kstat_incr_irqs_this_cpu(irq, desc);
 		} else {
 			ia64_setreg(_IA64_REG_CR_TPR, vector);
diff --git a/arch/ia64/xen/irq_xen.c b/arch/ia64/xen/irq_xen.c
index 108bb85..b279e14 100644
--- a/arch/ia64/xen/irq_xen.c
+++ b/arch/ia64/xen/irq_xen.c
@@ -92,6 +92,8 @@ static unsigned short saved_irq_cnt;
 static int xen_slab_ready;
 
 #ifdef CONFIG_SMP
+#include <linux/sched.h>
+
 /* Dummy stub. Though we may check XEN_RESCHEDULE_VECTOR before __do_IRQ,
  * it ends up to issue several memory accesses upon percpu data and
  * thus adds unnecessary traffic to other paths.
@@ -99,7 +101,13 @@ static int xen_slab_ready;
 static irqreturn_t
 xen_dummy_handler(int irq, void *dev_id)
 {
+	return IRQ_HANDLED;
+}
 
+static irqreturn_t
+xen_resched_handler(int irq, void *dev_id)
+{
+	scheduler_ipi();
 	return IRQ_HANDLED;
 }
 
@@ -110,7 +118,7 @@ static struct irqaction xen_ipi_irqaction = {
 };
 
 static struct irqaction xen_resched_irqaction = {
-	.handler =	xen_dummy_handler,
+	.handler =	xen_resched_handler,
 	.flags =	IRQF_DISABLED,
 	.name =		"resched"
 };
diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
index 31cef20..fc10b39 100644
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -122,8 +122,6 @@ void smp_send_reschedule(int cpu_id)
  *
  * Description:  This routine executes on CPU which received
  *               'RESCHEDULE_IPI'.
- *               Rescheduling is processed at the exit of interrupt
- *               operation.
  *
  * Born on Date: 2002.02.05
  *
@@ -138,7 +136,7 @@ void smp_send_reschedule(int cpu_id)
  *==========================================================================*/
 void smp_reschedule_interrupt(void)
 {
-	/* nothing to do */
+	scheduler_ipi();
 }
 
 /*==========================================================================*
diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
index ba78b21..76923ee 100644
--- a/arch/mips/cavium-octeon/smp.c
+++ b/arch/mips/cavium-octeon/smp.c
@@ -44,6 +44,8 @@ static irqreturn_t mailbox_interrupt(int irq, void *dev_id)
 
 	if (action & SMP_CALL_FUNCTION)
 		smp_call_function_interrupt();
+	if (action & SMP_RESCHEDULE_YOURSELF)
+		scheduler_ipi();
 
 	/* Check if we've been told to flush the icache */
 	if (action & SMP_ICACHE_FLUSH)
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index 5a88cc4..cedac46 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -929,7 +929,7 @@ static void post_direct_ipi(int cpu, struct smtc_ipi *pipi)
 
 static void ipi_resched_interrupt(void)
 {
-	/* Return from interrupt should be enough to cause scheduler check */
+	scheduler_ipi();
 }
 
 static void ipi_call_interrupt(void)
diff --git a/arch/mips/mti-malta/malta-int.c b/arch/mips/mti-malta/malta-int.c
index 9027061..7d93e6f 100644
--- a/arch/mips/mti-malta/malta-int.c
+++ b/arch/mips/mti-malta/malta-int.c
@@ -309,6 +309,8 @@ static void ipi_call_dispatch(void)
 
 static irqreturn_t ipi_resched_interrupt(int irq, void *dev_id)
 {
+	scheduler_ipi();
+
 	return IRQ_HANDLED;
 }
 
diff --git a/arch/mips/pmc-sierra/yosemite/smp.c b/arch/mips/pmc-sierra/yosemite/smp.c
index efc9e88..2608752 100644
--- a/arch/mips/pmc-sierra/yosemite/smp.c
+++ b/arch/mips/pmc-sierra/yosemite/smp.c
@@ -55,6 +55,8 @@ void titan_mailbox_irq(void)
 
 		if (status & 0x2)
 			smp_call_function_interrupt();
+		if (status & 0x4)
+			scheduler_ipi();
 		break;
 
 	case 1:
@@ -63,6 +65,8 @@ void titan_mailbox_irq(void)
 
 		if (status & 0x2)
 			smp_call_function_interrupt();
+		if (status & 0x4)
+			scheduler_ipi();
 		break;
 	}
 }
diff --git a/arch/mips/sgi-ip27/ip27-irq.c b/arch/mips/sgi-ip27/ip27-irq.c
index 0a04603..b18b04e 100644
--- a/arch/mips/sgi-ip27/ip27-irq.c
+++ b/arch/mips/sgi-ip27/ip27-irq.c
@@ -147,8 +147,10 @@ static void ip27_do_irq_mask0(void)
 #ifdef CONFIG_SMP
 	if (pend0 & (1UL << CPU_RESCHED_A_IRQ)) {
 		LOCAL_HUB_CLR_INTR(CPU_RESCHED_A_IRQ);
+		scheduler_ipi();
 	} else if (pend0 & (1UL << CPU_RESCHED_B_IRQ)) {
 		LOCAL_HUB_CLR_INTR(CPU_RESCHED_B_IRQ);
+		scheduler_ipi();
 	} else if (pend0 & (1UL << CPU_CALL_A_IRQ)) {
 		LOCAL_HUB_CLR_INTR(CPU_CALL_A_IRQ);
 		smp_call_function_interrupt();
diff --git a/arch/mips/sibyte/bcm1480/smp.c b/arch/mips/sibyte/bcm1480/smp.c
index 47b347c..d667875 100644
--- a/arch/mips/sibyte/bcm1480/smp.c
+++ b/arch/mips/sibyte/bcm1480/smp.c
@@ -20,6 +20,7 @@
 #include <linux/delay.h>
 #include <linux/smp.h>
 #include <linux/kernel_stat.h>
+#include <linux/sched.h>
 
 #include <asm/mmu_context.h>
 #include <asm/io.h>
@@ -189,10 +190,8 @@ void bcm1480_mailbox_interrupt(void)
 	/* Clear the mailbox to clear the interrupt */
 	__raw_writeq(((u64)action)<<48, mailbox_0_clear_regs[cpu]);
 
-	/*
-	 * Nothing to do for SMP_RESCHEDULE_YOURSELF; returning from the
-	 * interrupt will do the reschedule for us
-	 */
+	if (action & SMP_RESCHEDULE_YOURSELF)
+		scheduler_ipi();
 
 	if (action & SMP_CALL_FUNCTION)
 		smp_call_function_interrupt();
diff --git a/arch/mips/sibyte/sb1250/smp.c b/arch/mips/sibyte/sb1250/smp.c
index c00a5cb..38e7f6b 100644
--- a/arch/mips/sibyte/sb1250/smp.c
+++ b/arch/mips/sibyte/sb1250/smp.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/smp.h>
 #include <linux/kernel_stat.h>
+#include <linux/sched.h>
 
 #include <asm/mmu_context.h>
 #include <asm/io.h>
@@ -177,10 +178,8 @@ void sb1250_mailbox_interrupt(void)
 	/* Clear the mailbox to clear the interrupt */
 	____raw_writeq(((u64)action) << 48, mailbox_clear_regs[cpu]);
 
-	/*
-	 * Nothing to do for SMP_RESCHEDULE_YOURSELF; returning from the
-	 * interrupt will do the reschedule for us
-	 */
+	if (action & SMP_RESCHEDULE_YOURSELF)
+		scheduler_ipi();
 
 	if (action & SMP_CALL_FUNCTION)
 		smp_call_function_interrupt();
diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index 226c826..83fb279 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -494,14 +494,11 @@ void smp_send_stop(void)
  * @irq: The interrupt number.
  * @dev_id: The device ID.
  *
- * We need do nothing here, since the scheduling will be effected on our way
- * back through entry.S.
- *
  * Returns IRQ_HANDLED to indicate we handled the interrupt successfully.
  */
 static irqreturn_t smp_reschedule_interrupt(int irq, void *dev_id)
 {
-	/* do nothing */
+	scheduler_ipi();
 	return IRQ_HANDLED;
 }
 
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 69d63d3..828305f 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -155,10 +155,7 @@ ipi_interrupt(int irq, void *dev_id)
 				
 			case IPI_RESCHEDULE:
 				smp_debug(100, KERN_DEBUG "CPU%d IPI_RESCHEDULE\n", this_cpu);
-				/*
-				 * Reschedule callback.  Everything to be
-				 * done is done by the interrupt return path.
-				 */
+				scheduler_ipi();
 				break;
 
 			case IPI_CALL_FUNC:
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index cbdbb14..9f9c204 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -116,7 +116,7 @@ void smp_message_recv(int msg)
 		generic_smp_call_function_interrupt();
 		break;
 	case PPC_MSG_RESCHEDULE:
-		/* we notice need_resched on exit */
+		scheduler_ipi();
 		break;
 	case PPC_MSG_CALL_FUNC_SINGLE:
 		generic_smp_call_function_single_interrupt();
@@ -146,7 +146,7 @@ static irqreturn_t call_function_action(int irq, void *data)
 
 static irqreturn_t reschedule_action(int irq, void *data)
 {
-	/* we just need the return path side effect of checking need_resched */
+	scheduler_ipi();
 	return IRQ_HANDLED;
 }
 
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 63a97db..63c7d9f 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -165,12 +165,12 @@ static void do_ext_call_interrupt(unsigned int ext_int_code,
 	kstat_cpu(smp_processor_id()).irqs[EXTINT_IPI]++;
 	/*
 	 * handle bit signal external calls
-	 *
-	 * For the ec_schedule signal we have to do nothing. All the work
-	 * is done automatically when we return from the interrupt.
 	 */
 	bits = xchg(&S390_lowcore.ext_call_fast, 0);
 
+	if (test_bit(ec_schedule, &bits))
+		scheduler_ipi();
+
 	if (test_bit(ec_call_function, &bits))
 		generic_smp_call_function_interrupt();
 
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index 509b36b..6207561 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/cpu.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <asm/atomic.h>
 #include <asm/processor.h>
 #include <asm/system.h>
@@ -323,6 +324,7 @@ void smp_message_recv(unsigned int msg)
 		generic_smp_call_function_interrupt();
 		break;
 	case SMP_MSG_RESCHEDULE:
+		scheduler_ipi();
 		break;
 	case SMP_MSG_FUNCTION_SINGLE:
 		generic_smp_call_function_single_interrupt();
diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index 91c10fb..f95690c 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -125,7 +125,9 @@ struct linux_prom_registers smp_penguin_ctable __cpuinitdata = { 0 };
 
 void smp_send_reschedule(int cpu)
 {
-	/* See sparc64 */
+	/*
+	 * XXX missing reschedule IPI, see scheduler_ipi()
+	 */
 }
 
 void smp_send_stop(void)
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 3e94a8c..9478da7 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -1368,6 +1368,7 @@ void smp_send_reschedule(int cpu)
 void __irq_entry smp_receive_signal_client(int irq, struct pt_regs *regs)
 {
 	clear_softint(1 << irq);
+	scheduler_ipi();
 }
 
 /* This is a nop because we capture all other cpus
diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
index a429310..c52224d 100644
--- a/arch/tile/kernel/smp.c
+++ b/arch/tile/kernel/smp.c
@@ -189,12 +189,8 @@ void flush_icache_range(unsigned long start, unsigned long end)
 /* Called when smp_send_reschedule() triggers IRQ_RESCHEDULE. */
 static irqreturn_t handle_reschedule_ipi(int irq, void *token)
 {
-	/*
-	 * Nothing to do here; when we return from interrupt, the
-	 * rescheduling will occur there. But do bump the interrupt
-	 * profiler count in the meantime.
-	 */
 	__get_cpu_var(irq_stat).irq_resched_count++;
+	scheduler_ipi();
 
 	return IRQ_HANDLED;
 }
diff --git a/arch/um/kernel/smp.c b/arch/um/kernel/smp.c
index 106bf27..eefb107 100644
--- a/arch/um/kernel/smp.c
+++ b/arch/um/kernel/smp.c
@@ -173,7 +173,7 @@ void IPI_handler(int cpu)
 			break;
 
 		case 'R':
-			set_tsk_need_resched(current);
+			scheduler_ipi();
 			break;
 
 		case 'S':
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 513deac..013e7eb 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -194,14 +194,13 @@ static void native_stop_other_cpus(int wait)
 }
 
 /*
- * Reschedule call back. Nothing to do,
- * all the work is done automatically when
- * we return from the interrupt.
+ * Reschedule call back.
  */
 void smp_reschedule_interrupt(struct pt_regs *regs)
 {
 	ack_APIC_irq();
 	inc_irq_stat(irq_resched_count);
+	scheduler_ipi();
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 3061244..762b46a 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -46,13 +46,12 @@ static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id);
 static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id);
 
 /*
- * Reschedule call back. Nothing to do,
- * all the work is done automatically when
- * we return from the interrupt.
+ * Reschedule call back.
  */
 static irqreturn_t xen_reschedule_interrupt(int irq, void *dev_id)
 {
 	inc_irq_stat(irq_resched_count);
+	scheduler_ipi();
 
 	return IRQ_HANDLED;
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ec2c02..758e27a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2189,8 +2189,10 @@ extern void set_task_comm(struct task_struct *tsk, char *from);
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
+static inline void scheduler_ipi(void) { }
 extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
 #else
+static inline void scheduler_ipi(void) { }
 static inline unsigned long wait_task_inactive(struct task_struct *p,
 					       long match_state)
 {

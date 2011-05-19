Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934511Ab1ESUZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:25:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49492 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933727Ab1ESUZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:25:30 -0400
Date: Thu, 19 May 2011 22:25:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler changes for v2.6.40
Message-ID: <20110519202508.GA17033@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-core-for-linus

 Thanks,

	Ingo

------------------>
Hillf Danton (2):
      sched: Remove noop in alloc_rt_sched_group()
      sched: Shorten the construction of the span cpu mask of sched domain

Jonathan Corbet (1):
      sched: Get rid of lock_depth

Mike Galbraith (1):
      sched, rt: Update rq clock when unthrottling of an otherwise idle CPU

Peter Zijlstra (46):
      sched: Remove obsolete arch_ prefixes
      sched: Simplify ->cpu_power initialization
      sched: Simplify build_sched_groups()
      sched: Change NODE sched_domain group creation
      sched: Clean up some ALLNODES code
      sched: Simplify sched_group creation
      sched: Simplify finding the lowest sched_domain
      sched: Simplify sched_groups_power initialization
      sched: Dynamically allocate sched_domain/sched_group data-structures
      sched: Simplify the free path some
      sched: Avoid using sd->level
      sched: Reduce some allocation pressure
      sched: Simplify NODE/ALLNODES domain creation
      sched: Remove nodemask allocation
      sched: Remove some dead code
      sched: Create persistent sched_domains_tmpmask
      sched: Avoid allocations in sched_domain_debug()
      sched: Create proper cpu_$DOM_mask() functions
      sched: Stuff the sched_domain creation in a data-structure
      sched: Unify the sched_domain build functions
      sched: Reverse the topology list
      sched: Move sched domain storage into the topology list
      sched: Dynamic sched_domain::level
      sched: Provide scheduler_ipi() callback in response to smp_send_reschedule()
      sched: Always provide p->on_cpu
      mutex: Use p->on_cpu for the adaptive spin
      sched: Move wq_worker_waking to the correct site
      sched: Change the ttwu() success details
      sched: Clean up ttwu() stats
      sched: Provide p->on_rq
      sched: Serialize p->cpus_allowed and ttwu() using p->pi_lock
      sched: Drop the rq argument to sched_class::select_task_rq()
      sched: Remove rq argument to sched_class::task_waking()
      sched: Deal with non-atomic min_vruntime reads on 32bits
      sched: Delay task_contributes_to_load()
      sched: Also serialize ttwu_local() with p->pi_lock
      sched: Add p->pi_lock to task_rq_lock()
      sched: Drop rq->lock from first part of wake_up_new_task()
      sched: Drop rq->lock from sched_exec()
      sched: Remove rq->lock from the first half of ttwu()
      sched: Remove rq argument from ttwu_stat()
      sched: Rename ttwu_post_activation() to ttwu_do_wakeup()
      sched: Restructure ttwu() some more
      sched: Move the second half of ttwu() to the remote cpu
      sched: Remove need_migrate_task()
      sched: Fix sched_domain iterations vs. RCU

Rakib Mullick (2):
      sched: Remove obsolete comment from scheduler_tick()
      sched: Wrap the 'cfs_rq->nr_spread_over' field with CONFIG_SCHED_DEBUG

Samir Bellabes (1):
      sched: Remove unused parameters from sched_fork() and wake_up_new_task()

Shaohua Li (1):
      sched: Eliminate dead code from wakeup_gran()

Stephan Baerwolf (1):
      sched: Fix and optimise calculation of the weight-inverse

Stephen Rothwell (1):
      sched, sparc64: Turn cpu_coregroup_mask() into a real function

Venkatesh Pallipadi (2):
      sched: Make set_*_buddy() work on non-task entities
      sched: Next buddy hint on sleep and preempt path

Vladimir Davydov (1):
      sched: Remove unused 'this_best_prio arg' from balance_tasks()

Yong Zhang (1):
      sched: Avoid going ahead if ->cpus_allowed is not changed


 Documentation/trace/kprobetrace.txt             |    1 -
 arch/alpha/kernel/smp.c                         |    3 +-
 arch/arm/kernel/smp.c                           |    5 +-
 arch/blackfin/mach-common/smp.c                 |    3 +
 arch/cris/arch-v32/kernel/smp.c                 |   13 +-
 arch/ia64/kernel/irq_ia64.c                     |    2 +
 arch/ia64/xen/irq_xen.c                         |   10 +-
 arch/m32r/kernel/smp.c                          |    4 +-
 arch/mips/cavium-octeon/smp.c                   |    2 +
 arch/mips/kernel/smtc.c                         |    2 +-
 arch/mips/mti-malta/malta-int.c                 |    2 +
 arch/mips/pmc-sierra/yosemite/smp.c             |    4 +
 arch/mips/sgi-ip27/ip27-irq.c                   |    2 +
 arch/mips/sibyte/bcm1480/smp.c                  |    7 +-
 arch/mips/sibyte/sb1250/smp.c                   |    7 +-
 arch/mn10300/kernel/smp.c                       |    5 +-
 arch/parisc/kernel/smp.c                        |    5 +-
 arch/powerpc/kernel/smp.c                       |    4 +-
 arch/s390/kernel/smp.c                          |    6 +-
 arch/sh/kernel/smp.c                            |    2 +
 arch/sparc/include/asm/topology_64.h            |    6 +-
 arch/sparc/kernel/smp_32.c                      |    4 +-
 arch/sparc/kernel/smp_64.c                      |    1 +
 arch/tile/kernel/smp.c                          |    6 +-
 arch/um/kernel/smp.c                            |    2 +-
 arch/x86/kernel/smp.c                           |    5 +-
 arch/x86/xen/smp.c                              |    5 +-
 include/linux/init_task.h                       |    1 -
 include/linux/mutex.h                           |    2 +-
 include/linux/sched.h                           |   61 +-
 init/Kconfig                                    |    5 +
 kernel/cpuset.c                                 |    2 +-
 kernel/fork.c                                   |    5 +-
 kernel/mutex-debug.c                            |    2 +-
 kernel/mutex-debug.h                            |    2 +-
 kernel/mutex.c                                  |    9 +-
 kernel/mutex.h                                  |    2 +-
 kernel/sched.c                                  | 1658 +++++++++--------------
 kernel/sched_debug.c                            |    6 +-
 kernel/sched_fair.c                             |  126 ++-
 kernel/sched_features.h                         |    6 +
 kernel/sched_idletask.c                         |    2 +-
 kernel/sched_rt.c                               |   61 +-
 kernel/sched_stoptask.c                         |    5 +-
 kernel/trace/trace_kprobe.c                     |    1 -
 tools/perf/Documentation/perf-script-perl.txt   |    1 -
 tools/perf/Documentation/perf-script-python.txt |    1 -
 47 files changed, 909 insertions(+), 1167 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index 6d27ab8..c83bd6b 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -120,7 +120,6 @@ format:
         field:unsigned char common_flags;       offset:2;       size:1; signed:0;
         field:unsigned char common_preempt_count;       offset:3; size:1;signed:0;
         field:int common_pid;   offset:4;       size:4; signed:1;
-        field:int common_lock_depth;    offset:8;       size:4; signed:1;
 
         field:unsigned long __probe_ip; offset:12;      size:4; signed:0;
         field:int __probe_nargs;        offset:16;      size:4; signed:1;
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
index f29b8a2..007a0a9 100644
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
index 8bce5ed..1fbd94c 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -177,6 +177,9 @@ static irqreturn_t ipi_handler_int1(int irq, void *dev_instance)
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
diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index 1c79f32..8b9c556 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -65,6 +65,10 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 #define smt_capable()				(sparc64_multi_core)
 #endif /* CONFIG_SMP */
 
-#define cpu_coregroup_mask(cpu)			(&cpu_core_map[cpu])
+extern cpumask_t cpu_core_map[NR_CPUS];
+static inline const struct cpumask *cpu_coregroup_mask(int cpu)
+{
+        return &cpu_core_map[cpu];
+}
 
 #endif /* _ASM_SPARC64_TOPOLOGY_H */
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
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index caa151f..689496b 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -134,7 +134,6 @@ extern struct cred init_cred;
 	.stack		= &init_thread_info,				\
 	.usage		= ATOMIC_INIT(2),				\
 	.flags		= PF_KTHREAD,					\
-	.lock_depth	= -1,						\
 	.prio		= MAX_PRIO-20,					\
 	.static_prio	= MAX_PRIO-20,					\
 	.normal_prio	= MAX_PRIO-20,					\
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 94b48bd..c75471d 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -51,7 +51,7 @@ struct mutex {
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
 #if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
-	struct thread_info	*owner;
+	struct task_struct	*owner;
 #endif
 #ifdef CONFIG_DEBUG_MUTEXES
 	const char 		*name;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 781abd1..12211e1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -360,7 +360,7 @@ extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void schedule(void);
-extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
+extern int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner);
 
 struct nsproxy;
 struct user_namespace;
@@ -731,10 +731,6 @@ struct sched_info {
 	/* timestamps */
 	unsigned long long last_arrival,/* when we last ran on a cpu */
 			   last_queued;	/* when we were last queued to run */
-#ifdef CONFIG_SCHEDSTATS
-	/* BKL stats */
-	unsigned int bkl_count;
-#endif
 };
 #endif /* defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT) */
 
@@ -868,6 +864,7 @@ static inline int sd_power_saving_flags(void)
 
 struct sched_group {
 	struct sched_group *next;	/* Must be a circular list */
+	atomic_t ref;
 
 	/*
 	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
@@ -882,9 +879,6 @@ struct sched_group {
 	 * NOTE: this field is variable length. (Allocated dynamically
 	 * by attaching extra space to the end of the structure,
 	 * depending on how many CPUs the kernel has booted up with)
-	 *
-	 * It is also be embedded into static data structures at build
-	 * time. (See 'struct static_sched_group' in kernel/sched.c)
 	 */
 	unsigned long cpumask[0];
 };
@@ -894,17 +888,6 @@ static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
 	return to_cpumask(sg->cpumask);
 }
 
-enum sched_domain_level {
-	SD_LV_NONE = 0,
-	SD_LV_SIBLING,
-	SD_LV_MC,
-	SD_LV_BOOK,
-	SD_LV_CPU,
-	SD_LV_NODE,
-	SD_LV_ALLNODES,
-	SD_LV_MAX
-};
-
 struct sched_domain_attr {
 	int relax_domain_level;
 };
@@ -913,6 +896,8 @@ struct sched_domain_attr {
 	.relax_domain_level = -1,			\
 }
 
+extern int sched_domain_level_max;
+
 struct sched_domain {
 	/* These fields must be setup */
 	struct sched_domain *parent;	/* top domain must be null terminated */
@@ -930,7 +915,7 @@ struct sched_domain {
 	unsigned int forkexec_idx;
 	unsigned int smt_gain;
 	int flags;			/* See SD_* */
-	enum sched_domain_level level;
+	int level;
 
 	/* Runtime fields. */
 	unsigned long last_balance;	/* init to jiffies. units in jiffies */
@@ -973,6 +958,10 @@ struct sched_domain {
 #ifdef CONFIG_SCHED_DEBUG
 	char *name;
 #endif
+	union {
+		void *private;		/* used during construction */
+		struct rcu_head rcu;	/* used during destruction */
+	};
 
 	unsigned int span_weight;
 	/*
@@ -981,9 +970,6 @@ struct sched_domain {
 	 * NOTE: this field is variable length. (Allocated dynamically
 	 * by attaching extra space to the end of the structure,
 	 * depending on how many CPUs the kernel has booted up with)
-	 *
-	 * It is also be embedded into static data structures at build
-	 * time. (See 'struct static_sched_domain' in kernel/sched.c)
 	 */
 	unsigned long span[0];
 };
@@ -1048,8 +1034,12 @@ struct sched_domain;
 #define WF_FORK		0x02		/* child wakeup after fork */
 
 #define ENQUEUE_WAKEUP		1
-#define ENQUEUE_WAKING		2
-#define ENQUEUE_HEAD		4
+#define ENQUEUE_HEAD		2
+#ifdef CONFIG_SMP
+#define ENQUEUE_WAKING		4	/* sched_class::task_waking was called */
+#else
+#define ENQUEUE_WAKING		0
+#endif
 
 #define DEQUEUE_SLEEP		1
 
@@ -1067,12 +1057,11 @@ struct sched_class {
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
-	int  (*select_task_rq)(struct rq *rq, struct task_struct *p,
-			       int sd_flag, int flags);
+	int  (*select_task_rq)(struct task_struct *p, int sd_flag, int flags);
 
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
-	void (*task_waking) (struct rq *this_rq, struct task_struct *task);
+	void (*task_waking) (struct task_struct *task);
 	void (*task_woken) (struct rq *this_rq, struct task_struct *task);
 
 	void (*set_cpus_allowed)(struct task_struct *p,
@@ -1197,13 +1186,11 @@ struct task_struct {
 	unsigned int flags;	/* per process flags, defined below */
 	unsigned int ptrace;
 
-	int lock_depth;		/* BKL lock depth */
-
 #ifdef CONFIG_SMP
-#ifdef __ARCH_WANT_UNLOCKED_CTXSW
-	int oncpu;
-#endif
+	struct task_struct *wake_entry;
+	int on_cpu;
 #endif
+	int on_rq;
 
 	int prio, static_prio, normal_prio;
 	unsigned int rt_priority;
@@ -1274,6 +1261,7 @@ struct task_struct {
 
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
+	unsigned sched_contributes_to_load:1;
 
 	pid_t pid;
 	pid_t tgid;
@@ -2063,14 +2051,13 @@ extern void xtime_update(unsigned long ticks);
 
 extern int wake_up_state(struct task_struct *tsk, unsigned int state);
 extern int wake_up_process(struct task_struct *tsk);
-extern void wake_up_new_task(struct task_struct *tsk,
-				unsigned long clone_flags);
+extern void wake_up_new_task(struct task_struct *tsk);
 #ifdef CONFIG_SMP
  extern void kick_process(struct task_struct *tsk);
 #else
  static inline void kick_process(struct task_struct *tsk) { }
 #endif
-extern void sched_fork(struct task_struct *p, int clone_flags);
+extern void sched_fork(struct task_struct *p);
 extern void sched_dead(struct task_struct *p);
 
 extern void proc_caches_init(void);
@@ -2195,8 +2182,10 @@ extern void set_task_comm(struct task_struct *tsk, char *from);
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
+void scheduler_ipi(void);
 extern unsigned long wait_task_inactive(struct task_struct *, long match_state);
 #else
+static inline void scheduler_ipi(void) { }
 static inline unsigned long wait_task_inactive(struct task_struct *p,
 					       long match_state)
 {
diff --git a/init/Kconfig b/init/Kconfig
index d886b1e..9c812c5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -827,6 +827,11 @@ config SCHED_AUTOGROUP
 	  desktop applications.  Task group autogeneration is currently based
 	  upon task session.
 
+config SCHED_TTWU_QUEUE
+	bool
+	depends on !SPARC32
+	default y
+
 config MM_OWNER
 	bool
 
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 33eee16..2bb8c2e 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1159,7 +1159,7 @@ int current_cpuset_is_being_rebound(void)
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
 {
 #ifdef CONFIG_SMP
-	if (val < -1 || val >= SD_LV_MAX)
+	if (val < -1 || val >= sched_domain_level_max)
 		return -EINVAL;
 #endif
 
diff --git a/kernel/fork.c b/kernel/fork.c
index e7548de..2b44d82 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1103,7 +1103,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	posix_cpu_timers_init(p);
 
-	p->lock_depth = -1;		/* -1 = no lock */
 	do_posix_clock_monotonic_gettime(&p->start_time);
 	p->real_start_time = p->start_time;
 	monotonic_to_bootbased(&p->real_start_time);
@@ -1153,7 +1152,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #endif
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
-	sched_fork(p, clone_flags);
+	sched_fork(p);
 
 	retval = perf_event_init_task(p);
 	if (retval)
@@ -1464,7 +1463,7 @@ long do_fork(unsigned long clone_flags,
 		 */
 		p->flags &= ~PF_STARTING;
 
-		wake_up_new_task(p, clone_flags);
+		wake_up_new_task(p);
 
 		tracehook_report_clone_complete(trace, regs,
 						clone_flags, nr, p);
diff --git a/kernel/mutex-debug.c b/kernel/mutex-debug.c
index ec815a9..73da83a 100644
--- a/kernel/mutex-debug.c
+++ b/kernel/mutex-debug.c
@@ -75,7 +75,7 @@ void debug_mutex_unlock(struct mutex *lock)
 		return;
 
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
-	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
+	DEBUG_LOCKS_WARN_ON(lock->owner != current);
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
 	mutex_clear_owner(lock);
 }
diff --git a/kernel/mutex-debug.h b/kernel/mutex-debug.h
index 57d527a..0799fd3 100644
--- a/kernel/mutex-debug.h
+++ b/kernel/mutex-debug.h
@@ -29,7 +29,7 @@ extern void debug_mutex_init(struct mutex *lock, const char *name,
 
 static inline void mutex_set_owner(struct mutex *lock)
 {
-	lock->owner = current_thread_info();
+	lock->owner = current;
 }
 
 static inline void mutex_clear_owner(struct mutex *lock)
diff --git a/kernel/mutex.c b/kernel/mutex.c
index c4195fa..2c938e2 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -160,14 +160,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	 */
 
 	for (;;) {
-		struct thread_info *owner;
-
-		/*
-		 * If we own the BKL, then don't spin. The owner of
-		 * the mutex might be waiting on us to release the BKL.
-		 */
-		if (unlikely(current->lock_depth >= 0))
-			break;
+		struct task_struct *owner;
 
 		/*
 		 * If there's an owner, wait for it to either
diff --git a/kernel/mutex.h b/kernel/mutex.h
index 67578ca..4115fbf 100644
--- a/kernel/mutex.h
+++ b/kernel/mutex.h
@@ -19,7 +19,7 @@
 #ifdef CONFIG_SMP
 static inline void mutex_set_owner(struct mutex *lock)
 {
-	lock->owner = current_thread_info();
+	lock->owner = current;
 }
 
 static inline void mutex_clear_owner(struct mutex *lock)
diff --git a/kernel/sched.c b/kernel/sched.c
index 312f8b9..c62acf4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -231,7 +231,7 @@ static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
 #endif
 
 /*
- * sched_domains_mutex serializes calls to arch_init_sched_domains,
+ * sched_domains_mutex serializes calls to init_sched_domains,
  * detach_destroy_domains and partition_sched_domains.
  */
 static DEFINE_MUTEX(sched_domains_mutex);
@@ -312,6 +312,9 @@ struct cfs_rq {
 
 	u64 exec_clock;
 	u64 min_vruntime;
+#ifndef CONFIG_64BIT
+	u64 min_vruntime_copy;
+#endif
 
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
@@ -325,7 +328,9 @@ struct cfs_rq {
 	 */
 	struct sched_entity *curr, *next, *last, *skip;
 
+#ifdef	CONFIG_SCHED_DEBUG
 	unsigned int nr_spread_over;
+#endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */
@@ -417,6 +422,7 @@ struct rt_rq {
  */
 struct root_domain {
 	atomic_t refcount;
+	struct rcu_head rcu;
 	cpumask_var_t span;
 	cpumask_var_t online;
 
@@ -460,7 +466,7 @@ struct rq {
 	u64 nohz_stamp;
 	unsigned char nohz_balance_kick;
 #endif
-	unsigned int skip_clock_update;
+	int skip_clock_update;
 
 	/* capture load from *all* tasks on this cpu: */
 	struct load_weight load;
@@ -553,6 +559,10 @@ struct rq {
 	unsigned int ttwu_count;
 	unsigned int ttwu_local;
 #endif
+
+#ifdef CONFIG_SMP
+	struct task_struct *wake_list;
+#endif
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
@@ -571,7 +581,7 @@ static inline int cpu_of(struct rq *rq)
 
 #define rcu_dereference_check_sched_domain(p) \
 	rcu_dereference_check((p), \
-			      rcu_read_lock_sched_held() || \
+			      rcu_read_lock_held() || \
 			      lockdep_is_held(&sched_domains_mutex))
 
 /*
@@ -596,7 +606,7 @@ static inline int cpu_of(struct rq *rq)
  * Return the group to which this tasks belongs.
  *
  * We use task_subsys_state_check() and extend the RCU verification
- * with lockdep_is_held(&task_rq(p)->lock) because cpu_cgroup_attach()
+ * with lockdep_is_held(&p->pi_lock) because cpu_cgroup_attach()
  * holds that lock for each task it moves into the cgroup. Therefore
  * by holding that lock, we pin the task to the current cgroup.
  */
@@ -606,7 +616,7 @@ static inline struct task_group *task_group(struct task_struct *p)
 	struct cgroup_subsys_state *css;
 
 	css = task_subsys_state_check(p, cpu_cgroup_subsys_id,
-			lockdep_is_held(&task_rq(p)->lock));
+			lockdep_is_held(&p->pi_lock));
 	tg = container_of(css, struct task_group, css);
 
 	return autogroup_task_group(p, tg);
@@ -642,7 +652,7 @@ static void update_rq_clock(struct rq *rq)
 {
 	s64 delta;
 
-	if (rq->skip_clock_update)
+	if (rq->skip_clock_update > 0)
 		return;
 
 	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
@@ -838,18 +848,39 @@ static inline int task_current(struct rq *rq, struct task_struct *p)
 	return rq->curr == p;
 }
 
-#ifndef __ARCH_WANT_UNLOCKED_CTXSW
 static inline int task_running(struct rq *rq, struct task_struct *p)
 {
+#ifdef CONFIG_SMP
+	return p->on_cpu;
+#else
 	return task_current(rq, p);
+#endif
 }
 
+#ifndef __ARCH_WANT_UNLOCKED_CTXSW
 static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
 {
+#ifdef CONFIG_SMP
+	/*
+	 * We can optimise this out completely for !SMP, because the
+	 * SMP rebalancing from interrupt is the only thing that cares
+	 * here.
+	 */
+	next->on_cpu = 1;
+#endif
 }
 
 static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 {
+#ifdef CONFIG_SMP
+	/*
+	 * After ->on_cpu is cleared, the task can be moved to a different CPU.
+	 * We must ensure this doesn't happen until the switch is completely
+	 * finished.
+	 */
+	smp_wmb();
+	prev->on_cpu = 0;
+#endif
 #ifdef CONFIG_DEBUG_SPINLOCK
 	/* this is a valid case when another task releases the spinlock */
 	rq->lock.owner = current;
@@ -865,15 +896,6 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 }
 
 #else /* __ARCH_WANT_UNLOCKED_CTXSW */
-static inline int task_running(struct rq *rq, struct task_struct *p)
-{
-#ifdef CONFIG_SMP
-	return p->oncpu;
-#else
-	return task_current(rq, p);
-#endif
-}
-
 static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
 {
 #ifdef CONFIG_SMP
@@ -882,7 +904,7 @@ static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
 	 * SMP rebalancing from interrupt is the only thing that cares
 	 * here.
 	 */
-	next->oncpu = 1;
+	next->on_cpu = 1;
 #endif
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 	raw_spin_unlock_irq(&rq->lock);
@@ -895,12 +917,12 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 {
 #ifdef CONFIG_SMP
 	/*
-	 * After ->oncpu is cleared, the task can be moved to a different CPU.
+	 * After ->on_cpu is cleared, the task can be moved to a different CPU.
 	 * We must ensure this doesn't happen until the switch is completely
 	 * finished.
 	 */
 	smp_wmb();
-	prev->oncpu = 0;
+	prev->on_cpu = 0;
 #endif
 #ifndef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 	local_irq_enable();
@@ -909,23 +931,15 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 #endif /* __ARCH_WANT_UNLOCKED_CTXSW */
 
 /*
- * Check whether the task is waking, we use this to synchronize ->cpus_allowed
- * against ttwu().
- */
-static inline int task_is_waking(struct task_struct *p)
-{
-	return unlikely(p->state == TASK_WAKING);
-}
-
-/*
- * __task_rq_lock - lock the runqueue a given task resides on.
- * Must be called interrupts disabled.
+ * __task_rq_lock - lock the rq @p resides on.
  */
 static inline struct rq *__task_rq_lock(struct task_struct *p)
 	__acquires(rq->lock)
 {
 	struct rq *rq;
 
+	lockdep_assert_held(&p->pi_lock);
+
 	for (;;) {
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
@@ -936,22 +950,22 @@ static inline struct rq *__task_rq_lock(struct task_struct *p)
 }
 
 /*
- * task_rq_lock - lock the runqueue a given task resides on and disable
- * interrupts. Note the ordering: we can safely lookup the task_rq without
- * explicitly disabling preemption.
+ * task_rq_lock - lock p->pi_lock and lock the rq @p resides on.
  */
 static struct rq *task_rq_lock(struct task_struct *p, unsigned long *flags)
+	__acquires(p->pi_lock)
 	__acquires(rq->lock)
 {
 	struct rq *rq;
 
 	for (;;) {
-		local_irq_save(*flags);
+		raw_spin_lock_irqsave(&p->pi_lock, *flags);
 		rq = task_rq(p);
 		raw_spin_lock(&rq->lock);
 		if (likely(rq == task_rq(p)))
 			return rq;
-		raw_spin_unlock_irqrestore(&rq->lock, *flags);
+		raw_spin_unlock(&rq->lock);
+		raw_spin_unlock_irqrestore(&p->pi_lock, *flags);
 	}
 }
 
@@ -961,10 +975,13 @@ static void __task_rq_unlock(struct rq *rq)
 	raw_spin_unlock(&rq->lock);
 }
 
-static inline void task_rq_unlock(struct rq *rq, unsigned long *flags)
+static inline void
+task_rq_unlock(struct rq *rq, struct task_struct *p, unsigned long *flags)
 	__releases(rq->lock)
+	__releases(p->pi_lock)
 {
-	raw_spin_unlock_irqrestore(&rq->lock, *flags);
+	raw_spin_unlock(&rq->lock);
+	raw_spin_unlock_irqrestore(&p->pi_lock, *flags);
 }
 
 /*
@@ -1193,11 +1210,17 @@ int get_nohz_timer_target(void)
 	int i;
 	struct sched_domain *sd;
 
+	rcu_read_lock();
 	for_each_domain(cpu, sd) {
-		for_each_cpu(i, sched_domain_span(sd))
-			if (!idle_cpu(i))
-				return i;
+		for_each_cpu(i, sched_domain_span(sd)) {
+			if (!idle_cpu(i)) {
+				cpu = i;
+				goto unlock;
+			}
+		}
 	}
+unlock:
+	rcu_read_unlock();
 	return cpu;
 }
 /*
@@ -1307,15 +1330,15 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
 {
 	u64 tmp;
 
+	tmp = (u64)delta_exec * weight;
+
 	if (!lw->inv_weight) {
 		if (BITS_PER_LONG > 32 && unlikely(lw->weight >= WMULT_CONST))
 			lw->inv_weight = 1;
 		else
-			lw->inv_weight = 1 + (WMULT_CONST-lw->weight/2)
-				/ (lw->weight+1);
+			lw->inv_weight = WMULT_CONST / lw->weight;
 	}
 
-	tmp = (u64)delta_exec * weight;
 	/*
 	 * Check whether we'd overflow the 64-bit multiplication:
 	 */
@@ -1773,7 +1796,6 @@ static void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 	update_rq_clock(rq);
 	sched_info_queued(p);
 	p->sched_class->enqueue_task(rq, p, flags);
-	p->se.on_rq = 1;
 }
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
@@ -1781,7 +1803,6 @@ static void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
 	update_rq_clock(rq);
 	sched_info_dequeued(p);
 	p->sched_class->dequeue_task(rq, p, flags);
-	p->se.on_rq = 0;
 }
 
 /*
@@ -2116,7 +2137,7 @@ static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 	 * A queue event has occurred, and we're going to schedule.  In
 	 * this case, we can save a useless back to back clock update.
 	 */
-	if (rq->curr->se.on_rq && test_tsk_need_resched(rq->curr))
+	if (rq->curr->on_rq && test_tsk_need_resched(rq->curr))
 		rq->skip_clock_update = 1;
 }
 
@@ -2162,6 +2183,11 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 	 */
 	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING &&
 			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
+
+#ifdef CONFIG_LOCKDEP
+	WARN_ON_ONCE(debug_locks && !(lockdep_is_held(&p->pi_lock) ||
+				      lockdep_is_held(&task_rq(p)->lock)));
+#endif
 #endif
 
 	trace_sched_migrate_task(p, new_cpu);
@@ -2182,19 +2208,6 @@ struct migration_arg {
 static int migration_cpu_stop(void *data);
 
 /*
- * The task's runqueue lock must be held.
- * Returns true if you have to wait for migration thread.
- */
-static bool migrate_task(struct task_struct *p, struct rq *rq)
-{
-	/*
-	 * If the task is not on a runqueue (and not running), then
-	 * the next wake-up will properly place the task.
-	 */
-	return p->se.on_rq || task_running(rq, p);
-}
-
-/*
  * wait_task_inactive - wait for a thread to unschedule.
  *
  * If @match_state is nonzero, it's the @p->state value just checked and
@@ -2251,11 +2264,11 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		rq = task_rq_lock(p, &flags);
 		trace_sched_wait_task(p);
 		running = task_running(rq, p);
-		on_rq = p->se.on_rq;
+		on_rq = p->on_rq;
 		ncsw = 0;
 		if (!match_state || p->state == match_state)
 			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
-		task_rq_unlock(rq, &flags);
+		task_rq_unlock(rq, p, &flags);
 
 		/*
 		 * If it changed from the expected state, bail out now.
@@ -2330,7 +2343,7 @@ EXPORT_SYMBOL_GPL(kick_process);
 
 #ifdef CONFIG_SMP
 /*
- * ->cpus_allowed is protected by either TASK_WAKING or rq->lock held.
+ * ->cpus_allowed is protected by both rq->lock and p->pi_lock
  */
 static int select_fallback_rq(int cpu, struct task_struct *p)
 {
@@ -2363,12 +2376,12 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 }
 
 /*
- * The caller (fork, wakeup) owns TASK_WAKING, ->cpus_allowed is stable.
+ * The caller (fork, wakeup) owns p->pi_lock, ->cpus_allowed is stable.
  */
 static inline
-int select_task_rq(struct rq *rq, struct task_struct *p, int sd_flags, int wake_flags)
+int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
 {
-	int cpu = p->sched_class->select_task_rq(rq, p, sd_flags, wake_flags);
+	int cpu = p->sched_class->select_task_rq(p, sd_flags, wake_flags);
 
 	/*
 	 * In order not to call set_task_cpu() on a blocking task we need
@@ -2394,27 +2407,62 @@ static void update_avg(u64 *avg, u64 sample)
 }
 #endif
 
-static inline void ttwu_activate(struct task_struct *p, struct rq *rq,
-				 bool is_sync, bool is_migrate, bool is_local,
-				 unsigned long en_flags)
+static void
+ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
 {
+#ifdef CONFIG_SCHEDSTATS
+	struct rq *rq = this_rq();
+
+#ifdef CONFIG_SMP
+	int this_cpu = smp_processor_id();
+
+	if (cpu == this_cpu) {
+		schedstat_inc(rq, ttwu_local);
+		schedstat_inc(p, se.statistics.nr_wakeups_local);
+	} else {
+		struct sched_domain *sd;
+
+		schedstat_inc(p, se.statistics.nr_wakeups_remote);
+		rcu_read_lock();
+		for_each_domain(this_cpu, sd) {
+			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
+				schedstat_inc(sd, ttwu_wake_remote);
+				break;
+			}
+		}
+		rcu_read_unlock();
+	}
+#endif /* CONFIG_SMP */
+
+	schedstat_inc(rq, ttwu_count);
 	schedstat_inc(p, se.statistics.nr_wakeups);
-	if (is_sync)
+
+	if (wake_flags & WF_SYNC)
 		schedstat_inc(p, se.statistics.nr_wakeups_sync);
-	if (is_migrate)
+
+	if (cpu != task_cpu(p))
 		schedstat_inc(p, se.statistics.nr_wakeups_migrate);
-	if (is_local)
-		schedstat_inc(p, se.statistics.nr_wakeups_local);
-	else
-		schedstat_inc(p, se.statistics.nr_wakeups_remote);
 
+#endif /* CONFIG_SCHEDSTATS */
+}
+
+static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
+{
 	activate_task(rq, p, en_flags);
+	p->on_rq = 1;
+
+	/* if a worker is waking up, notify workqueue */
+	if (p->flags & PF_WQ_WORKER)
+		wq_worker_waking_up(p, cpu_of(rq));
 }
 
-static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
-					int wake_flags, bool success)
+/*
+ * Mark the task runnable and perform wakeup-preemption.
+ */
+static void
+ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 {
-	trace_sched_wakeup(p, success);
+	trace_sched_wakeup(p, true);
 	check_preempt_curr(rq, p, wake_flags);
 
 	p->state = TASK_RUNNING;
@@ -2433,9 +2481,99 @@ static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
 		rq->idle_stamp = 0;
 	}
 #endif
-	/* if a worker is waking up, notify workqueue */
-	if ((p->flags & PF_WQ_WORKER) && success)
-		wq_worker_waking_up(p, cpu_of(rq));
+}
+
+static void
+ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags)
+{
+#ifdef CONFIG_SMP
+	if (p->sched_contributes_to_load)
+		rq->nr_uninterruptible--;
+#endif
+
+	ttwu_activate(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
+	ttwu_do_wakeup(rq, p, wake_flags);
+}
+
+/*
+ * Called in case the task @p isn't fully descheduled from its runqueue,
+ * in this case we must do a remote wakeup. Its a 'light' wakeup though,
+ * since all we need to do is flip p->state to TASK_RUNNING, since
+ * the task is still ->on_rq.
+ */
+static int ttwu_remote(struct task_struct *p, int wake_flags)
+{
+	struct rq *rq;
+	int ret = 0;
+
+	rq = __task_rq_lock(p);
+	if (p->on_rq) {
+		ttwu_do_wakeup(rq, p, wake_flags);
+		ret = 1;
+	}
+	__task_rq_unlock(rq);
+
+	return ret;
+}
+
+#ifdef CONFIG_SMP
+static void sched_ttwu_pending(void)
+{
+	struct rq *rq = this_rq();
+	struct task_struct *list = xchg(&rq->wake_list, NULL);
+
+	if (!list)
+		return;
+
+	raw_spin_lock(&rq->lock);
+
+	while (list) {
+		struct task_struct *p = list;
+		list = list->wake_entry;
+		ttwu_do_activate(rq, p, 0);
+	}
+
+	raw_spin_unlock(&rq->lock);
+}
+
+void scheduler_ipi(void)
+{
+	sched_ttwu_pending();
+}
+
+static void ttwu_queue_remote(struct task_struct *p, int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	struct task_struct *next = rq->wake_list;
+
+	for (;;) {
+		struct task_struct *old = next;
+
+		p->wake_entry = next;
+		next = cmpxchg(&rq->wake_list, old, p);
+		if (next == old)
+			break;
+	}
+
+	if (!next)
+		smp_send_reschedule(cpu);
+}
+#endif
+
+static void ttwu_queue(struct task_struct *p, int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+#if defined(CONFIG_SMP) && defined(CONFIG_SCHED_TTWU_QUEUE)
+	if (sched_feat(TTWU_QUEUE) && cpu != smp_processor_id()) {
+		ttwu_queue_remote(p, cpu);
+		return;
+	}
+#endif
+
+	raw_spin_lock(&rq->lock);
+	ttwu_do_activate(rq, p, 0);
+	raw_spin_unlock(&rq->lock);
 }
 
 /**
@@ -2453,92 +2591,64 @@ static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
  * Returns %true if @p was woken up, %false if it was already running
  * or @state didn't match @p's state.
  */
-static int try_to_wake_up(struct task_struct *p, unsigned int state,
-			  int wake_flags)
+static int
+try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
 {
-	int cpu, orig_cpu, this_cpu, success = 0;
 	unsigned long flags;
-	unsigned long en_flags = ENQUEUE_WAKEUP;
-	struct rq *rq;
-
-	this_cpu = get_cpu();
+	int cpu, success = 0;
 
 	smp_wmb();
-	rq = task_rq_lock(p, &flags);
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	if (!(p->state & state))
 		goto out;
 
-	if (p->se.on_rq)
-		goto out_running;
-
+	success = 1; /* we're going to change ->state */
 	cpu = task_cpu(p);
-	orig_cpu = cpu;
 
-#ifdef CONFIG_SMP
-	if (unlikely(task_running(rq, p)))
-		goto out_activate;
+	if (p->on_rq && ttwu_remote(p, wake_flags))
+		goto stat;
 
+#ifdef CONFIG_SMP
 	/*
-	 * In order to handle concurrent wakeups and release the rq->lock
-	 * we put the task in TASK_WAKING state.
-	 *
-	 * First fix up the nr_uninterruptible count:
+	 * If the owning (remote) cpu is still in the middle of schedule() with
+	 * this task as prev, wait until its done referencing the task.
 	 */
-	if (task_contributes_to_load(p)) {
-		if (likely(cpu_online(orig_cpu)))
-			rq->nr_uninterruptible--;
-		else
-			this_rq()->nr_uninterruptible--;
-	}
-	p->state = TASK_WAKING;
-
-	if (p->sched_class->task_waking) {
-		p->sched_class->task_waking(rq, p);
-		en_flags |= ENQUEUE_WAKING;
+	while (p->on_cpu) {
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+		/*
+		 * If called from interrupt context we could have landed in the
+		 * middle of schedule(), in this case we should take care not
+		 * to spin on ->on_cpu if p is current, since that would
+		 * deadlock.
+		 */
+		if (p == current) {
+			ttwu_queue(p, cpu);
+			goto stat;
+		}
+#endif
+		cpu_relax();
 	}
-
-	cpu = select_task_rq(rq, p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu)
-		set_task_cpu(p, cpu);
-	__task_rq_unlock(rq);
-
-	rq = cpu_rq(cpu);
-	raw_spin_lock(&rq->lock);
-
 	/*
-	 * We migrated the task without holding either rq->lock, however
-	 * since the task is not on the task list itself, nobody else
-	 * will try and migrate the task, hence the rq should match the
-	 * cpu we just moved it to.
+	 * Pairs with the smp_wmb() in finish_lock_switch().
 	 */
-	WARN_ON(task_cpu(p) != cpu);
-	WARN_ON(p->state != TASK_WAKING);
+	smp_rmb();
 
-#ifdef CONFIG_SCHEDSTATS
-	schedstat_inc(rq, ttwu_count);
-	if (cpu == this_cpu)
-		schedstat_inc(rq, ttwu_local);
-	else {
-		struct sched_domain *sd;
-		for_each_domain(this_cpu, sd) {
-			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
-				schedstat_inc(sd, ttwu_wake_remote);
-				break;
-			}
-		}
-	}
-#endif /* CONFIG_SCHEDSTATS */
+	p->sched_contributes_to_load = !!task_contributes_to_load(p);
+	p->state = TASK_WAKING;
 
-out_activate:
+	if (p->sched_class->task_waking)
+		p->sched_class->task_waking(p);
+
+	cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
+	if (task_cpu(p) != cpu)
+		set_task_cpu(p, cpu);
 #endif /* CONFIG_SMP */
-	ttwu_activate(p, rq, wake_flags & WF_SYNC, orig_cpu != cpu,
-		      cpu == this_cpu, en_flags);
-	success = 1;
-out_running:
-	ttwu_post_activation(p, rq, wake_flags, success);
+
+	ttwu_queue(p, cpu);
+stat:
+	ttwu_stat(p, cpu, wake_flags);
 out:
-	task_rq_unlock(rq, &flags);
-	put_cpu();
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
 	return success;
 }
@@ -2547,31 +2657,34 @@ out:
  * try_to_wake_up_local - try to wake up a local task with rq lock held
  * @p: the thread to be awakened
  *
- * Put @p on the run-queue if it's not already there.  The caller must
+ * Put @p on the run-queue if it's not already there. The caller must
  * ensure that this_rq() is locked, @p is bound to this_rq() and not
- * the current task.  this_rq() stays locked over invocation.
+ * the current task.
  */
 static void try_to_wake_up_local(struct task_struct *p)
 {
 	struct rq *rq = task_rq(p);
-	bool success = false;
 
 	BUG_ON(rq != this_rq());
 	BUG_ON(p == current);
 	lockdep_assert_held(&rq->lock);
 
+	if (!raw_spin_trylock(&p->pi_lock)) {
+		raw_spin_unlock(&rq->lock);
+		raw_spin_lock(&p->pi_lock);
+		raw_spin_lock(&rq->lock);
+	}
+
 	if (!(p->state & TASK_NORMAL))
-		return;
+		goto out;
 
-	if (!p->se.on_rq) {
-		if (likely(!task_running(rq, p))) {
-			schedstat_inc(rq, ttwu_count);
-			schedstat_inc(rq, ttwu_local);
-		}
-		ttwu_activate(p, rq, false, false, true, ENQUEUE_WAKEUP);
-		success = true;
-	}
-	ttwu_post_activation(p, rq, 0, success);
+	if (!p->on_rq)
+		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
+
+	ttwu_do_wakeup(rq, p, 0);
+	ttwu_stat(p, smp_processor_id(), 0);
+out:
+	raw_spin_unlock(&p->pi_lock);
 }
 
 /**
@@ -2604,19 +2717,21 @@ int wake_up_state(struct task_struct *p, unsigned int state)
  */
 static void __sched_fork(struct task_struct *p)
 {
+	p->on_rq			= 0;
+
+	p->se.on_rq			= 0;
 	p->se.exec_start		= 0;
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.nr_migrations		= 0;
 	p->se.vruntime			= 0;
+	INIT_LIST_HEAD(&p->se.group_node);
 
 #ifdef CONFIG_SCHEDSTATS
 	memset(&p->se.statistics, 0, sizeof(p->se.statistics));
 #endif
 
 	INIT_LIST_HEAD(&p->rt.run_list);
-	p->se.on_rq = 0;
-	INIT_LIST_HEAD(&p->se.group_node);
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
@@ -2626,8 +2741,9 @@ static void __sched_fork(struct task_struct *p)
 /*
  * fork()/clone()-time setup:
  */
-void sched_fork(struct task_struct *p, int clone_flags)
+void sched_fork(struct task_struct *p)
 {
+	unsigned long flags;
 	int cpu = get_cpu();
 
 	__sched_fork(p);
@@ -2678,16 +2794,16 @@ void sched_fork(struct task_struct *p, int clone_flags)
 	 *
 	 * Silence PROVE_RCU.
 	 */
-	rcu_read_lock();
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	set_task_cpu(p, cpu);
-	rcu_read_unlock();
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	if (likely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
 #endif
-#if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
-	p->oncpu = 0;
+#if defined(CONFIG_SMP)
+	p->on_cpu = 0;
 #endif
 #ifdef CONFIG_PREEMPT
 	/* Want to start with kernel preemption disabled. */
@@ -2707,41 +2823,31 @@ void sched_fork(struct task_struct *p, int clone_flags)
  * that must be done for every newly created context, then puts the task
  * on the runqueue and wakes it.
  */
-void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
+void wake_up_new_task(struct task_struct *p)
 {
 	unsigned long flags;
 	struct rq *rq;
-	int cpu __maybe_unused = get_cpu();
 
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
 #ifdef CONFIG_SMP
-	rq = task_rq_lock(p, &flags);
-	p->state = TASK_WAKING;
-
 	/*
 	 * Fork balancing, do it here and not earlier because:
 	 *  - cpus_allowed can change in the fork path
 	 *  - any previously selected cpu might disappear through hotplug
-	 *
-	 * We set TASK_WAKING so that select_task_rq() can drop rq->lock
-	 * without people poking at ->cpus_allowed.
 	 */
-	cpu = select_task_rq(rq, p, SD_BALANCE_FORK, 0);
-	set_task_cpu(p, cpu);
-
-	p->state = TASK_RUNNING;
-	task_rq_unlock(rq, &flags);
+	set_task_cpu(p, select_task_rq(p, SD_BALANCE_FORK, 0));
 #endif
 
-	rq = task_rq_lock(p, &flags);
+	rq = __task_rq_lock(p);
 	activate_task(rq, p, 0);
-	trace_sched_wakeup_new(p, 1);
+	p->on_rq = 1;
+	trace_sched_wakeup_new(p, true);
 	check_preempt_curr(rq, p, WF_FORK);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_woken)
 		p->sched_class->task_woken(rq, p);
 #endif
-	task_rq_unlock(rq, &flags);
-	put_cpu();
+	task_rq_unlock(rq, p, &flags);
 }
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
@@ -3450,27 +3556,22 @@ void sched_exec(void)
 {
 	struct task_struct *p = current;
 	unsigned long flags;
-	struct rq *rq;
 	int dest_cpu;
 
-	rq = task_rq_lock(p, &flags);
-	dest_cpu = p->sched_class->select_task_rq(rq, p, SD_BALANCE_EXEC, 0);
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
+	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
 	if (dest_cpu == smp_processor_id())
 		goto unlock;
 
-	/*
-	 * select_task_rq() can race against ->cpus_allowed
-	 */
-	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
-	    likely(cpu_active(dest_cpu)) && migrate_task(p, rq)) {
+	if (likely(cpu_active(dest_cpu))) {
 		struct migration_arg arg = { p, dest_cpu };
 
-		task_rq_unlock(rq, &flags);
-		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
+		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		stop_one_cpu(task_cpu(p), migration_cpu_stop, &arg);
 		return;
 	}
 unlock:
-	task_rq_unlock(rq, &flags);
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 }
 
 #endif
@@ -3507,7 +3608,7 @@ unsigned long long task_delta_exec(struct task_struct *p)
 
 	rq = task_rq_lock(p, &flags);
 	ns = do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 
 	return ns;
 }
@@ -3525,7 +3626,7 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 
 	rq = task_rq_lock(p, &flags);
 	ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 
 	return ns;
 }
@@ -3549,7 +3650,7 @@ unsigned long long thread_group_sched_runtime(struct task_struct *p)
 	rq = task_rq_lock(p, &flags);
 	thread_group_cputime(p, &totals);
 	ns = totals.sum_exec_runtime + do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 
 	return ns;
 }
@@ -3903,9 +4004,6 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 /*
  * This function gets called by the timer code, with HZ frequency.
  * We call it with interrupts disabled.
- *
- * It also gets called by the fork code, when changing the parent's
- * timeslices.
  */
 void scheduler_tick(void)
 {
@@ -4025,17 +4123,11 @@ static inline void schedule_debug(struct task_struct *prev)
 	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
 
 	schedstat_inc(this_rq(), sched_count);
-#ifdef CONFIG_SCHEDSTATS
-	if (unlikely(prev->lock_depth >= 0)) {
-		schedstat_inc(this_rq(), rq_sched_info.bkl_count);
-		schedstat_inc(prev, sched_info.bkl_count);
-	}
-#endif
 }
 
 static void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
-	if (prev->se.on_rq)
+	if (prev->on_rq || rq->skip_clock_update < 0)
 		update_rq_clock(rq);
 	prev->sched_class->put_prev_task(rq, prev);
 }
@@ -4097,11 +4189,13 @@ need_resched:
 		if (unlikely(signal_pending_state(prev->state, prev))) {
 			prev->state = TASK_RUNNING;
 		} else {
+			deactivate_task(rq, prev, DEQUEUE_SLEEP);
+			prev->on_rq = 0;
+
 			/*
-			 * If a worker is going to sleep, notify and
-			 * ask workqueue whether it wants to wake up a
-			 * task to maintain concurrency.  If so, wake
-			 * up the task.
+			 * If a worker went to sleep, notify and ask workqueue
+			 * whether it wants to wake up a task to maintain
+			 * concurrency.
 			 */
 			if (prev->flags & PF_WQ_WORKER) {
 				struct task_struct *to_wakeup;
@@ -4110,11 +4204,10 @@ need_resched:
 				if (to_wakeup)
 					try_to_wake_up_local(to_wakeup);
 			}
-			deactivate_task(rq, prev, DEQUEUE_SLEEP);
 
 			/*
-			 * If we are going to sleep and we have plugged IO queued, make
-			 * sure to submit it to avoid deadlocks.
+			 * If we are going to sleep and we have plugged IO
+			 * queued, make sure to submit it to avoid deadlocks.
 			 */
 			if (blk_needs_flush_plug(prev)) {
 				raw_spin_unlock(&rq->lock);
@@ -4161,70 +4254,53 @@ need_resched:
 EXPORT_SYMBOL(schedule);
 
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-/*
- * Look out! "owner" is an entirely speculative pointer
- * access and not reliable.
- */
-int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
-{
-	unsigned int cpu;
-	struct rq *rq;
 
-	if (!sched_feat(OWNER_SPIN))
-		return 0;
+static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
+{
+	bool ret = false;
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	/*
-	 * Need to access the cpu field knowing that
-	 * DEBUG_PAGEALLOC could have unmapped it if
-	 * the mutex owner just released it and exited.
-	 */
-	if (probe_kernel_address(&owner->cpu, cpu))
-		return 0;
-#else
-	cpu = owner->cpu;
-#endif
+	rcu_read_lock();
+	if (lock->owner != owner)
+		goto fail;
 
 	/*
-	 * Even if the access succeeded (likely case),
-	 * the cpu field may no longer be valid.
+	 * Ensure we emit the owner->on_cpu, dereference _after_ checking
+	 * lock->owner still matches owner, if that fails, owner might
+	 * point to free()d memory, if it still matches, the rcu_read_lock()
+	 * ensures the memory stays valid.
 	 */
-	if (cpu >= nr_cpumask_bits)
-		return 0;
+	barrier();
 
-	/*
-	 * We need to validate that we can do a
-	 * get_cpu() and that we have the percpu area.
-	 */
-	if (!cpu_online(cpu))
-		return 0;
+	ret = owner->on_cpu;
+fail:
+	rcu_read_unlock();
 
-	rq = cpu_rq(cpu);
+	return ret;
+}
 
-	for (;;) {
-		/*
-		 * Owner changed, break to re-assess state.
-		 */
-		if (lock->owner != owner) {
-			/*
-			 * If the lock has switched to a different owner,
-			 * we likely have heavy contention. Return 0 to quit
-			 * optimistic spinning and not contend further:
-			 */
-			if (lock->owner)
-				return 0;
-			break;
-		}
+/*
+ * Look out! "owner" is an entirely speculative pointer
+ * access and not reliable.
+ */
+int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
+{
+	if (!sched_feat(OWNER_SPIN))
+		return 0;
 
-		/*
-		 * Is that owner really running on that cpu?
-		 */
-		if (task_thread_info(rq->curr) != owner || need_resched())
+	while (owner_running(lock, owner)) {
+		if (need_resched())
 			return 0;
 
 		arch_mutex_cpu_relax();
 	}
 
+	/*
+	 * If the owner changed to another task there is likely
+	 * heavy contention, stop spinning.
+	 */
+	if (lock->owner)
+		return 0;
+
 	return 1;
 }
 #endif
@@ -4684,19 +4760,18 @@ EXPORT_SYMBOL(sleep_on_timeout);
  */
 void rt_mutex_setprio(struct task_struct *p, int prio)
 {
-	unsigned long flags;
 	int oldprio, on_rq, running;
 	struct rq *rq;
 	const struct sched_class *prev_class;
 
 	BUG_ON(prio < 0 || prio > MAX_PRIO);
 
-	rq = task_rq_lock(p, &flags);
+	rq = __task_rq_lock(p);
 
 	trace_sched_pi_setprio(p, prio);
 	oldprio = p->prio;
 	prev_class = p->sched_class;
-	on_rq = p->se.on_rq;
+	on_rq = p->on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
 		dequeue_task(rq, p, 0);
@@ -4716,7 +4791,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 		enqueue_task(rq, p, oldprio < prio ? ENQUEUE_HEAD : 0);
 
 	check_class_changed(rq, p, prev_class, oldprio);
-	task_rq_unlock(rq, &flags);
+	__task_rq_unlock(rq);
 }
 
 #endif
@@ -4744,7 +4819,7 @@ void set_user_nice(struct task_struct *p, long nice)
 		p->static_prio = NICE_TO_PRIO(nice);
 		goto out_unlock;
 	}
-	on_rq = p->se.on_rq;
+	on_rq = p->on_rq;
 	if (on_rq)
 		dequeue_task(rq, p, 0);
 
@@ -4764,7 +4839,7 @@ void set_user_nice(struct task_struct *p, long nice)
 			resched_task(rq->curr);
 	}
 out_unlock:
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 }
 EXPORT_SYMBOL(set_user_nice);
 
@@ -4878,8 +4953,6 @@ static struct task_struct *find_process_by_pid(pid_t pid)
 static void
 __setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
 {
-	BUG_ON(p->se.on_rq);
-
 	p->policy = policy;
 	p->rt_priority = prio;
 	p->normal_prio = normal_prio(p);
@@ -4994,20 +5067,17 @@ recheck:
 	/*
 	 * make sure no PI-waiters arrive (or leave) while we are
 	 * changing the priority of the task:
-	 */
-	raw_spin_lock_irqsave(&p->pi_lock, flags);
-	/*
+	 *
 	 * To be able to change p->policy safely, the appropriate
 	 * runqueue lock must be held.
 	 */
-	rq = __task_rq_lock(p);
+	rq = task_rq_lock(p, &flags);
 
 	/*
 	 * Changing the policy of the stop threads its a very bad idea
 	 */
 	if (p == rq->stop) {
-		__task_rq_unlock(rq);
-		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		task_rq_unlock(rq, p, &flags);
 		return -EINVAL;
 	}
 
@@ -5031,8 +5101,7 @@ recheck:
 		if (rt_bandwidth_enabled() && rt_policy(policy) &&
 				task_group(p)->rt_bandwidth.rt_runtime == 0 &&
 				!task_group_is_autogroup(task_group(p))) {
-			__task_rq_unlock(rq);
-			raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+			task_rq_unlock(rq, p, &flags);
 			return -EPERM;
 		}
 	}
@@ -5041,11 +5110,10 @@ recheck:
 	/* recheck policy now with rq lock held */
 	if (unlikely(oldpolicy != -1 && oldpolicy != p->policy)) {
 		policy = oldpolicy = -1;
-		__task_rq_unlock(rq);
-		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+		task_rq_unlock(rq, p, &flags);
 		goto recheck;
 	}
-	on_rq = p->se.on_rq;
+	on_rq = p->on_rq;
 	running = task_current(rq, p);
 	if (on_rq)
 		deactivate_task(rq, p, 0);
@@ -5064,8 +5132,7 @@ recheck:
 		activate_task(rq, p, 0);
 
 	check_class_changed(rq, p, prev_class, oldprio);
-	__task_rq_unlock(rq);
-	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+	task_rq_unlock(rq, p, &flags);
 
 	rt_mutex_adjust_pi(p);
 
@@ -5316,7 +5383,6 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
 {
 	struct task_struct *p;
 	unsigned long flags;
-	struct rq *rq;
 	int retval;
 
 	get_online_cpus();
@@ -5331,9 +5397,9 @@ long sched_getaffinity(pid_t pid, struct cpumask *mask)
 	if (retval)
 		goto out_unlock;
 
-	rq = task_rq_lock(p, &flags);
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	cpumask_and(mask, &p->cpus_allowed, cpu_online_mask);
-	task_rq_unlock(rq, &flags);
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
 out_unlock:
 	rcu_read_unlock();
@@ -5658,7 +5724,7 @@ SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
 
 	rq = task_rq_lock(p, &flags);
 	time_slice = p->sched_class->get_rr_interval(rq, p);
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 
 	rcu_read_unlock();
 	jiffies_to_timespec(time_slice, &t);
@@ -5776,17 +5842,14 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	rcu_read_unlock();
 
 	rq->curr = rq->idle = idle;
-#if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
-	idle->oncpu = 1;
+#if defined(CONFIG_SMP)
+	idle->on_cpu = 1;
 #endif
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
 	/* Set the preempt count _outside_ the spinlocks! */
-#if defined(CONFIG_PREEMPT)
-	task_thread_info(idle)->preempt_count = (idle->lock_depth >= 0);
-#else
 	task_thread_info(idle)->preempt_count = 0;
-#endif
+
 	/*
 	 * The idle tasks have their own, simple scheduling class:
 	 */
@@ -5881,26 +5944,17 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 	unsigned int dest_cpu;
 	int ret = 0;
 
-	/*
-	 * Serialize against TASK_WAKING so that ttwu() and wunt() can
-	 * drop the rq->lock and still rely on ->cpus_allowed.
-	 */
-again:
-	while (task_is_waking(p))
-		cpu_relax();
 	rq = task_rq_lock(p, &flags);
-	if (task_is_waking(p)) {
-		task_rq_unlock(rq, &flags);
-		goto again;
-	}
+
+	if (cpumask_equal(&p->cpus_allowed, new_mask))
+		goto out;
 
 	if (!cpumask_intersects(new_mask, cpu_active_mask)) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
-		     !cpumask_equal(&p->cpus_allowed, new_mask))) {
+	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -5917,16 +5971,16 @@ again:
 		goto out;
 
 	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
-	if (migrate_task(p, rq)) {
+	if (p->on_rq) {
 		struct migration_arg arg = { p, dest_cpu };
 		/* Need help from migration thread: drop lock and wait. */
-		task_rq_unlock(rq, &flags);
+		task_rq_unlock(rq, p, &flags);
 		stop_one_cpu(cpu_of(rq), migration_cpu_stop, &arg);
 		tlb_migrate_finish(p->mm);
 		return 0;
 	}
 out:
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, p, &flags);
 
 	return ret;
 }
@@ -5954,6 +6008,7 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	rq_src = cpu_rq(src_cpu);
 	rq_dest = cpu_rq(dest_cpu);
 
+	raw_spin_lock(&p->pi_lock);
 	double_rq_lock(rq_src, rq_dest);
 	/* Already moved. */
 	if (task_cpu(p) != src_cpu)
@@ -5966,7 +6021,7 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	 * If we're not on a rq, the next wake-up will ensure we're
 	 * placed properly.
 	 */
-	if (p->se.on_rq) {
+	if (p->on_rq) {
 		deactivate_task(rq_src, p, 0);
 		set_task_cpu(p, dest_cpu);
 		activate_task(rq_dest, p, 0);
@@ -5976,6 +6031,7 @@ done:
 	ret = 1;
 fail:
 	double_rq_unlock(rq_src, rq_dest);
+	raw_spin_unlock(&p->pi_lock);
 	return ret;
 }
 
@@ -6316,6 +6372,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DYING:
+		sched_ttwu_pending();
 		/* Update our root-domain */
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {
@@ -6394,6 +6451,8 @@ early_initcall(migration_init);
 
 #ifdef CONFIG_SMP
 
+static cpumask_var_t sched_domains_tmpmask; /* sched_domains_mutex */
+
 #ifdef CONFIG_SCHED_DEBUG
 
 static __read_mostly int sched_domain_debug_enabled;
@@ -6489,7 +6548,6 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 
 static void sched_domain_debug(struct sched_domain *sd, int cpu)
 {
-	cpumask_var_t groupmask;
 	int level = 0;
 
 	if (!sched_domain_debug_enabled)
@@ -6502,20 +6560,14 @@ static void sched_domain_debug(struct sched_domain *sd, int cpu)
 
 	printk(KERN_DEBUG "CPU%d attaching sched-domain:\n", cpu);
 
-	if (!alloc_cpumask_var(&groupmask, GFP_KERNEL)) {
-		printk(KERN_DEBUG "Cannot load-balance (out of memory)\n");
-		return;
-	}
-
 	for (;;) {
-		if (sched_domain_debug_one(sd, cpu, level, groupmask))
+		if (sched_domain_debug_one(sd, cpu, level, sched_domains_tmpmask))
 			break;
 		level++;
 		sd = sd->parent;
 		if (!sd)
 			break;
 	}
-	free_cpumask_var(groupmask);
 }
 #else /* !CONFIG_SCHED_DEBUG */
 # define sched_domain_debug(sd, cpu) do { } while (0)
@@ -6572,12 +6624,11 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 	return 1;
 }
 
-static void free_rootdomain(struct root_domain *rd)
+static void free_rootdomain(struct rcu_head *rcu)
 {
-	synchronize_sched();
+	struct root_domain *rd = container_of(rcu, struct root_domain, rcu);
 
 	cpupri_cleanup(&rd->cpupri);
-
 	free_cpumask_var(rd->rto_mask);
 	free_cpumask_var(rd->online);
 	free_cpumask_var(rd->span);
@@ -6618,7 +6669,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
 	if (old_rd)
-		free_rootdomain(old_rd);
+		call_rcu_sched(&old_rd->rcu, free_rootdomain);
 }
 
 static int init_rootdomain(struct root_domain *rd)
@@ -6669,6 +6720,25 @@ static struct root_domain *alloc_rootdomain(void)
 	return rd;
 }
 
+static void free_sched_domain(struct rcu_head *rcu)
+{
+	struct sched_domain *sd = container_of(rcu, struct sched_domain, rcu);
+	if (atomic_dec_and_test(&sd->groups->ref))
+		kfree(sd->groups);
+	kfree(sd);
+}
+
+static void destroy_sched_domain(struct sched_domain *sd, int cpu)
+{
+	call_rcu(&sd->rcu, free_sched_domain);
+}
+
+static void destroy_sched_domains(struct sched_domain *sd, int cpu)
+{
+	for (; sd; sd = sd->parent)
+		destroy_sched_domain(sd, cpu);
+}
+
 /*
  * Attach the domain 'sd' to 'cpu' as its base domain. Callers must
  * hold the hotplug lock.
@@ -6679,9 +6749,6 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	struct sched_domain *tmp;
 
-	for (tmp = sd; tmp; tmp = tmp->parent)
-		tmp->span_weight = cpumask_weight(sched_domain_span(tmp));
-
 	/* Remove the sched domains which do not contribute to scheduling. */
 	for (tmp = sd; tmp; ) {
 		struct sched_domain *parent = tmp->parent;
@@ -6692,12 +6759,15 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 			tmp->parent = parent->parent;
 			if (parent->parent)
 				parent->parent->child = tmp;
+			destroy_sched_domain(parent, cpu);
 		} else
 			tmp = tmp->parent;
 	}
 
 	if (sd && sd_degenerate(sd)) {
+		tmp = sd;
 		sd = sd->parent;
+		destroy_sched_domain(tmp, cpu);
 		if (sd)
 			sd->child = NULL;
 	}
@@ -6705,7 +6775,9 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
 	sched_domain_debug(sd, cpu);
 
 	rq_attach_root(rq, rd);
+	tmp = rq->sd;
 	rcu_assign_pointer(rq->sd, sd);
+	destroy_sched_domains(tmp, cpu);
 }
 
 /* cpus with isolated domains */
@@ -6721,56 +6793,6 @@ static int __init isolated_cpu_setup(char *str)
 
 __setup("isolcpus=", isolated_cpu_setup);
 
-/*
- * init_sched_build_groups takes the cpumask we wish to span, and a pointer
- * to a function which identifies what group(along with sched group) a CPU
- * belongs to. The return value of group_fn must be a >= 0 and < nr_cpu_ids
- * (due to the fact that we keep track of groups covered with a struct cpumask).
- *
- * init_sched_build_groups will build a circular linked list of the groups
- * covered by the given span, and will set each group's ->cpumask correctly,
- * and ->cpu_power to 0.
- */
-static void
-init_sched_build_groups(const struct cpumask *span,
-			const struct cpumask *cpu_map,
-			int (*group_fn)(int cpu, const struct cpumask *cpu_map,
-					struct sched_group **sg,
-					struct cpumask *tmpmask),
-			struct cpumask *covered, struct cpumask *tmpmask)
-{
-	struct sched_group *first = NULL, *last = NULL;
-	int i;
-
-	cpumask_clear(covered);
-
-	for_each_cpu(i, span) {
-		struct sched_group *sg;
-		int group = group_fn(i, cpu_map, &sg, tmpmask);
-		int j;
-
-		if (cpumask_test_cpu(i, covered))
-			continue;
-
-		cpumask_clear(sched_group_cpus(sg));
-		sg->cpu_power = 0;
-
-		for_each_cpu(j, span) {
-			if (group_fn(j, cpu_map, NULL, tmpmask) != group)
-				continue;
-
-			cpumask_set_cpu(j, covered);
-			cpumask_set_cpu(j, sched_group_cpus(sg));
-		}
-		if (!first)
-			first = sg;
-		if (last)
-			last->next = sg;
-		last = sg;
-	}
-	last->next = first;
-}
-
 #define SD_NODES_PER_DOMAIN 16
 
 #ifdef CONFIG_NUMA
@@ -6787,7 +6809,7 @@ init_sched_build_groups(const struct cpumask *span,
  */
 static int find_next_best_node(int node, nodemask_t *used_nodes)
 {
-	int i, n, val, min_val, best_node = 0;
+	int i, n, val, min_val, best_node = -1;
 
 	min_val = INT_MAX;
 
@@ -6811,7 +6833,8 @@ static int find_next_best_node(int node, nodemask_t *used_nodes)
 		}
 	}
 
-	node_set(best_node, *used_nodes);
+	if (best_node != -1)
+		node_set(best_node, *used_nodes);
 	return best_node;
 }
 
@@ -6837,315 +6860,130 @@ static void sched_domain_node_span(int node, struct cpumask *span)
 
 	for (i = 1; i < SD_NODES_PER_DOMAIN; i++) {
 		int next_node = find_next_best_node(node, &used_nodes);
-
+		if (next_node < 0)
+			break;
 		cpumask_or(span, span, cpumask_of_node(next_node));
 	}
 }
+
+static const struct cpumask *cpu_node_mask(int cpu)
+{
+	lockdep_assert_held(&sched_domains_mutex);
+
+	sched_domain_node_span(cpu_to_node(cpu), sched_domains_tmpmask);
+
+	return sched_domains_tmpmask;
+}
+
+static const struct cpumask *cpu_allnodes_mask(int cpu)
+{
+	return cpu_possible_mask;
+}
 #endif /* CONFIG_NUMA */
 
-int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
+static const struct cpumask *cpu_cpu_mask(int cpu)
+{
+	return cpumask_of_node(cpu_to_node(cpu));
+}
 
-/*
- * The cpus mask in sched_group and sched_domain hangs off the end.
- *
- * ( See the the comments in include/linux/sched.h:struct sched_group
- *   and struct sched_domain. )
- */
-struct static_sched_group {
-	struct sched_group sg;
-	DECLARE_BITMAP(cpus, CONFIG_NR_CPUS);
-};
+int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
 
-struct static_sched_domain {
-	struct sched_domain sd;
-	DECLARE_BITMAP(span, CONFIG_NR_CPUS);
+struct sd_data {
+	struct sched_domain **__percpu sd;
+	struct sched_group **__percpu sg;
 };
 
 struct s_data {
-#ifdef CONFIG_NUMA
-	int			sd_allnodes;
-	cpumask_var_t		domainspan;
-	cpumask_var_t		covered;
-	cpumask_var_t		notcovered;
-#endif
-	cpumask_var_t		nodemask;
-	cpumask_var_t		this_sibling_map;
-	cpumask_var_t		this_core_map;
-	cpumask_var_t		this_book_map;
-	cpumask_var_t		send_covered;
-	cpumask_var_t		tmpmask;
-	struct sched_group	**sched_group_nodes;
+	struct sched_domain ** __percpu sd;
 	struct root_domain	*rd;
 };
 
 enum s_alloc {
-	sa_sched_groups = 0,
 	sa_rootdomain,
-	sa_tmpmask,
-	sa_send_covered,
-	sa_this_book_map,
-	sa_this_core_map,
-	sa_this_sibling_map,
-	sa_nodemask,
-	sa_sched_group_nodes,
-#ifdef CONFIG_NUMA
-	sa_notcovered,
-	sa_covered,
-	sa_domainspan,
-#endif
+	sa_sd,
+	sa_sd_storage,
 	sa_none,
 };
 
-/*
- * SMT sched-domains:
- */
-#ifdef CONFIG_SCHED_SMT
-static DEFINE_PER_CPU(struct static_sched_domain, cpu_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_groups);
-
-static int
-cpu_to_cpu_group(int cpu, const struct cpumask *cpu_map,
-		 struct sched_group **sg, struct cpumask *unused)
-{
-	if (sg)
-		*sg = &per_cpu(sched_groups, cpu).sg;
-	return cpu;
-}
-#endif /* CONFIG_SCHED_SMT */
+struct sched_domain_topology_level;
 
-/*
- * multi-core sched-domains:
- */
-#ifdef CONFIG_SCHED_MC
-static DEFINE_PER_CPU(struct static_sched_domain, core_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_core);
+typedef struct sched_domain *(*sched_domain_init_f)(struct sched_domain_topology_level *tl, int cpu);
+typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
 
-static int
-cpu_to_core_group(int cpu, const struct cpumask *cpu_map,
-		  struct sched_group **sg, struct cpumask *mask)
-{
-	int group;
-#ifdef CONFIG_SCHED_SMT
-	cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
-	group = cpumask_first(mask);
-#else
-	group = cpu;
-#endif
-	if (sg)
-		*sg = &per_cpu(sched_group_core, group).sg;
-	return group;
-}
-#endif /* CONFIG_SCHED_MC */
+struct sched_domain_topology_level {
+	sched_domain_init_f init;
+	sched_domain_mask_f mask;
+	struct sd_data      data;
+};
 
 /*
- * book sched-domains:
+ * Assumes the sched_domain tree is fully constructed
  */
-#ifdef CONFIG_SCHED_BOOK
-static DEFINE_PER_CPU(struct static_sched_domain, book_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_book);
-
-static int
-cpu_to_book_group(int cpu, const struct cpumask *cpu_map,
-		  struct sched_group **sg, struct cpumask *mask)
+static int get_group(int cpu, struct sd_data *sdd, struct sched_group **sg)
 {
-	int group = cpu;
-#ifdef CONFIG_SCHED_MC
-	cpumask_and(mask, cpu_coregroup_mask(cpu), cpu_map);
-	group = cpumask_first(mask);
-#elif defined(CONFIG_SCHED_SMT)
-	cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
-	group = cpumask_first(mask);
-#endif
-	if (sg)
-		*sg = &per_cpu(sched_group_book, group).sg;
-	return group;
-}
-#endif /* CONFIG_SCHED_BOOK */
+	struct sched_domain *sd = *per_cpu_ptr(sdd->sd, cpu);
+	struct sched_domain *child = sd->child;
 
-static DEFINE_PER_CPU(struct static_sched_domain, phys_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_phys);
+	if (child)
+		cpu = cpumask_first(sched_domain_span(child));
 
-static int
-cpu_to_phys_group(int cpu, const struct cpumask *cpu_map,
-		  struct sched_group **sg, struct cpumask *mask)
-{
-	int group;
-#ifdef CONFIG_SCHED_BOOK
-	cpumask_and(mask, cpu_book_mask(cpu), cpu_map);
-	group = cpumask_first(mask);
-#elif defined(CONFIG_SCHED_MC)
-	cpumask_and(mask, cpu_coregroup_mask(cpu), cpu_map);
-	group = cpumask_first(mask);
-#elif defined(CONFIG_SCHED_SMT)
-	cpumask_and(mask, topology_thread_cpumask(cpu), cpu_map);
-	group = cpumask_first(mask);
-#else
-	group = cpu;
-#endif
 	if (sg)
-		*sg = &per_cpu(sched_group_phys, group).sg;
-	return group;
+		*sg = *per_cpu_ptr(sdd->sg, cpu);
+
+	return cpu;
 }
 
-#ifdef CONFIG_NUMA
 /*
- * The init_sched_build_groups can't handle what we want to do with node
- * groups, so roll our own. Now each node has its own list of groups which
- * gets dynamically allocated.
+ * build_sched_groups takes the cpumask we wish to span, and a pointer
+ * to a function which identifies what group(along with sched group) a CPU
+ * belongs to. The return value of group_fn must be a >= 0 and < nr_cpu_ids
+ * (due to the fact that we keep track of groups covered with a struct cpumask).
+ *
+ * build_sched_groups will build a circular linked list of the groups
+ * covered by the given span, and will set each group's ->cpumask correctly,
+ * and ->cpu_power to 0.
  */
-static DEFINE_PER_CPU(struct static_sched_domain, node_domains);
-static struct sched_group ***sched_group_nodes_bycpu;
-
-static DEFINE_PER_CPU(struct static_sched_domain, allnodes_domains);
-static DEFINE_PER_CPU(struct static_sched_group, sched_group_allnodes);
-
-static int cpu_to_allnodes_group(int cpu, const struct cpumask *cpu_map,
-				 struct sched_group **sg,
-				 struct cpumask *nodemask)
-{
-	int group;
-
-	cpumask_and(nodemask, cpumask_of_node(cpu_to_node(cpu)), cpu_map);
-	group = cpumask_first(nodemask);
-
-	if (sg)
-		*sg = &per_cpu(sched_group_allnodes, group).sg;
-	return group;
-}
-
-static void init_numa_sched_groups_power(struct sched_group *group_head)
-{
-	struct sched_group *sg = group_head;
-	int j;
-
-	if (!sg)
-		return;
-	do {
-		for_each_cpu(j, sched_group_cpus(sg)) {
-			struct sched_domain *sd;
-
-			sd = &per_cpu(phys_domains, j).sd;
-			if (j != group_first_cpu(sd->groups)) {
-				/*
-				 * Only add "power" once for each
-				 * physical package.
-				 */
-				continue;
-			}
-
-			sg->cpu_power += sd->groups->cpu_power;
-		}
-		sg = sg->next;
-	} while (sg != group_head);
-}
-
-static int build_numa_sched_groups(struct s_data *d,
-				   const struct cpumask *cpu_map, int num)
+static void
+build_sched_groups(struct sched_domain *sd)
 {
-	struct sched_domain *sd;
-	struct sched_group *sg, *prev;
-	int n, j;
-
-	cpumask_clear(d->covered);
-	cpumask_and(d->nodemask, cpumask_of_node(num), cpu_map);
-	if (cpumask_empty(d->nodemask)) {
-		d->sched_group_nodes[num] = NULL;
-		goto out;
-	}
-
-	sched_domain_node_span(num, d->domainspan);
-	cpumask_and(d->domainspan, d->domainspan, cpu_map);
-
-	sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
-			  GFP_KERNEL, num);
-	if (!sg) {
-		printk(KERN_WARNING "Can not alloc domain group for node %d\n",
-		       num);
-		return -ENOMEM;
-	}
-	d->sched_group_nodes[num] = sg;
-
-	for_each_cpu(j, d->nodemask) {
-		sd = &per_cpu(node_domains, j).sd;
-		sd->groups = sg;
-	}
-
-	sg->cpu_power = 0;
-	cpumask_copy(sched_group_cpus(sg), d->nodemask);
-	sg->next = sg;
-	cpumask_or(d->covered, d->covered, d->nodemask);
+	struct sched_group *first = NULL, *last = NULL;
+	struct sd_data *sdd = sd->private;
+	const struct cpumask *span = sched_domain_span(sd);
+	struct cpumask *covered;
+	int i;
 
-	prev = sg;
-	for (j = 0; j < nr_node_ids; j++) {
-		n = (num + j) % nr_node_ids;
-		cpumask_complement(d->notcovered, d->covered);
-		cpumask_and(d->tmpmask, d->notcovered, cpu_map);
-		cpumask_and(d->tmpmask, d->tmpmask, d->domainspan);
-		if (cpumask_empty(d->tmpmask))
-			break;
-		cpumask_and(d->tmpmask, d->tmpmask, cpumask_of_node(n));
-		if (cpumask_empty(d->tmpmask))
-			continue;
-		sg = kmalloc_node(sizeof(struct sched_group) + cpumask_size(),
-				  GFP_KERNEL, num);
-		if (!sg) {
-			printk(KERN_WARNING
-			       "Can not alloc domain group for node %d\n", j);
-			return -ENOMEM;
-		}
-		sg->cpu_power = 0;
-		cpumask_copy(sched_group_cpus(sg), d->tmpmask);
-		sg->next = prev->next;
-		cpumask_or(d->covered, d->covered, d->tmpmask);
-		prev->next = sg;
-		prev = sg;
-	}
-out:
-	return 0;
-}
-#endif /* CONFIG_NUMA */
+	lockdep_assert_held(&sched_domains_mutex);
+	covered = sched_domains_tmpmask;
 
-#ifdef CONFIG_NUMA
-/* Free memory allocated for various sched_group structures */
-static void free_sched_groups(const struct cpumask *cpu_map,
-			      struct cpumask *nodemask)
-{
-	int cpu, i;
+	cpumask_clear(covered);
 
-	for_each_cpu(cpu, cpu_map) {
-		struct sched_group **sched_group_nodes
-			= sched_group_nodes_bycpu[cpu];
+	for_each_cpu(i, span) {
+		struct sched_group *sg;
+		int group = get_group(i, sdd, &sg);
+		int j;
 
-		if (!sched_group_nodes)
+		if (cpumask_test_cpu(i, covered))
 			continue;
 
-		for (i = 0; i < nr_node_ids; i++) {
-			struct sched_group *oldsg, *sg = sched_group_nodes[i];
+		cpumask_clear(sched_group_cpus(sg));
+		sg->cpu_power = 0;
 
-			cpumask_and(nodemask, cpumask_of_node(i), cpu_map);
-			if (cpumask_empty(nodemask))
+		for_each_cpu(j, span) {
+			if (get_group(j, sdd, NULL) != group)
 				continue;
 
-			if (sg == NULL)
-				continue;
-			sg = sg->next;
-next_sg:
-			oldsg = sg;
-			sg = sg->next;
-			kfree(oldsg);
-			if (oldsg != sched_group_nodes[i])
-				goto next_sg;
+			cpumask_set_cpu(j, covered);
+			cpumask_set_cpu(j, sched_group_cpus(sg));
 		}
-		kfree(sched_group_nodes);
-		sched_group_nodes_bycpu[cpu] = NULL;
+
+		if (!first)
+			first = sg;
+		if (last)
+			last->next = sg;
+		last = sg;
 	}
+	last->next = first;
 }
-#else /* !CONFIG_NUMA */
-static void free_sched_groups(const struct cpumask *cpu_map,
-			      struct cpumask *nodemask)
-{
-}
-#endif /* CONFIG_NUMA */
 
 /*
  * Initialize sched groups cpu_power.
@@ -7159,11 +6997,6 @@ static void free_sched_groups(const struct cpumask *cpu_map,
  */
 static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 {
-	struct sched_domain *child;
-	struct sched_group *group;
-	long power;
-	int weight;
-
 	WARN_ON(!sd || !sd->groups);
 
 	if (cpu != group_first_cpu(sd->groups))
@@ -7171,36 +7004,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 
 	sd->groups->group_weight = cpumask_weight(sched_group_cpus(sd->groups));
 
-	child = sd->child;
-
-	sd->groups->cpu_power = 0;
-
-	if (!child) {
-		power = SCHED_LOAD_SCALE;
-		weight = cpumask_weight(sched_domain_span(sd));
-		/*
-		 * SMT siblings share the power of a single core.
-		 * Usually multiple threads get a better yield out of
-		 * that one core than a single thread would have,
-		 * reflect that in sd->smt_gain.
-		 */
-		if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
-			power *= sd->smt_gain;
-			power /= weight;
-			power >>= SCHED_LOAD_SHIFT;
-		}
-		sd->groups->cpu_power += power;
-		return;
-	}
-
-	/*
-	 * Add cpu_power of each child group to this groups cpu_power.
-	 */
-	group = child->groups;
-	do {
-		sd->groups->cpu_power += group->cpu_power;
-		group = group->next;
-	} while (group != child->groups);
+	update_group_power(sd, cpu);
 }
 
 /*
@@ -7214,15 +7018,15 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 # define SD_INIT_NAME(sd, type)		do { } while (0)
 #endif
 
-#define	SD_INIT(sd, type)	sd_init_##type(sd)
-
-#define SD_INIT_FUNC(type)	\
-static noinline void sd_init_##type(struct sched_domain *sd)	\
-{								\
-	memset(sd, 0, sizeof(*sd));				\
-	*sd = SD_##type##_INIT;					\
-	sd->level = SD_LV_##type;				\
-	SD_INIT_NAME(sd, type);					\
+#define SD_INIT_FUNC(type)						\
+static noinline struct sched_domain *					\
+sd_init_##type(struct sched_domain_topology_level *tl, int cpu) 	\
+{									\
+	struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);	\
+	*sd = SD_##type##_INIT;						\
+	SD_INIT_NAME(sd, type);						\
+	sd->private = &tl->data;					\
+	return sd;							\
 }
 
 SD_INIT_FUNC(CPU)
@@ -7241,13 +7045,14 @@ SD_INIT_FUNC(CPU)
 #endif
 
 static int default_relax_domain_level = -1;
+int sched_domain_level_max;
 
 static int __init setup_relax_domain_level(char *str)
 {
 	unsigned long val;
 
 	val = simple_strtoul(str, NULL, 0);
-	if (val < SD_LV_MAX)
+	if (val < sched_domain_level_max)
 		default_relax_domain_level = val;
 
 	return 1;
@@ -7275,37 +7080,20 @@ static void set_domain_attribute(struct sched_domain *sd,
 	}
 }
 
+static void __sdt_free(const struct cpumask *cpu_map);
+static int __sdt_alloc(const struct cpumask *cpu_map);
+
 static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 				 const struct cpumask *cpu_map)
 {
 	switch (what) {
-	case sa_sched_groups:
-		free_sched_groups(cpu_map, d->tmpmask); /* fall through */
-		d->sched_group_nodes = NULL;
 	case sa_rootdomain:
-		free_rootdomain(d->rd); /* fall through */
-	case sa_tmpmask:
-		free_cpumask_var(d->tmpmask); /* fall through */
-	case sa_send_covered:
-		free_cpumask_var(d->send_covered); /* fall through */
-	case sa_this_book_map:
-		free_cpumask_var(d->this_book_map); /* fall through */
-	case sa_this_core_map:
-		free_cpumask_var(d->this_core_map); /* fall through */
-	case sa_this_sibling_map:
-		free_cpumask_var(d->this_sibling_map); /* fall through */
-	case sa_nodemask:
-		free_cpumask_var(d->nodemask); /* fall through */
-	case sa_sched_group_nodes:
-#ifdef CONFIG_NUMA
-		kfree(d->sched_group_nodes); /* fall through */
-	case sa_notcovered:
-		free_cpumask_var(d->notcovered); /* fall through */
-	case sa_covered:
-		free_cpumask_var(d->covered); /* fall through */
-	case sa_domainspan:
-		free_cpumask_var(d->domainspan); /* fall through */
-#endif
+		if (!atomic_read(&d->rd->refcount))
+			free_rootdomain(&d->rd->rcu); /* fall through */
+	case sa_sd:
+		free_percpu(d->sd); /* fall through */
+	case sa_sd_storage:
+		__sdt_free(cpu_map); /* fall through */
 	case sa_none:
 		break;
 	}
@@ -7314,308 +7102,212 @@ static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 						   const struct cpumask *cpu_map)
 {
-#ifdef CONFIG_NUMA
-	if (!alloc_cpumask_var(&d->domainspan, GFP_KERNEL))
-		return sa_none;
-	if (!alloc_cpumask_var(&d->covered, GFP_KERNEL))
-		return sa_domainspan;
-	if (!alloc_cpumask_var(&d->notcovered, GFP_KERNEL))
-		return sa_covered;
-	/* Allocate the per-node list of sched groups */
-	d->sched_group_nodes = kcalloc(nr_node_ids,
-				      sizeof(struct sched_group *), GFP_KERNEL);
-	if (!d->sched_group_nodes) {
-		printk(KERN_WARNING "Can not alloc sched group node list\n");
-		return sa_notcovered;
-	}
-	sched_group_nodes_bycpu[cpumask_first(cpu_map)] = d->sched_group_nodes;
-#endif
-	if (!alloc_cpumask_var(&d->nodemask, GFP_KERNEL))
-		return sa_sched_group_nodes;
-	if (!alloc_cpumask_var(&d->this_sibling_map, GFP_KERNEL))
-		return sa_nodemask;
-	if (!alloc_cpumask_var(&d->this_core_map, GFP_KERNEL))
-		return sa_this_sibling_map;
-	if (!alloc_cpumask_var(&d->this_book_map, GFP_KERNEL))
-		return sa_this_core_map;
-	if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
-		return sa_this_book_map;
-	if (!alloc_cpumask_var(&d->tmpmask, GFP_KERNEL))
-		return sa_send_covered;
+	memset(d, 0, sizeof(*d));
+
+	if (__sdt_alloc(cpu_map))
+		return sa_sd_storage;
+	d->sd = alloc_percpu(struct sched_domain *);
+	if (!d->sd)
+		return sa_sd_storage;
 	d->rd = alloc_rootdomain();
-	if (!d->rd) {
-		printk(KERN_WARNING "Cannot alloc root domain\n");
-		return sa_tmpmask;
-	}
+	if (!d->rd)
+		return sa_sd;
 	return sa_rootdomain;
 }
 
-static struct sched_domain *__build_numa_sched_domains(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr, int i)
+/*
+ * NULL the sd_data elements we've used to build the sched_domain and
+ * sched_group structure so that the subsequent __free_domain_allocs()
+ * will not free the data we're using.
+ */
+static void claim_allocations(int cpu, struct sched_domain *sd)
 {
-	struct sched_domain *sd = NULL;
-#ifdef CONFIG_NUMA
-	struct sched_domain *parent;
-
-	d->sd_allnodes = 0;
-	if (cpumask_weight(cpu_map) >
-	    SD_NODES_PER_DOMAIN * cpumask_weight(d->nodemask)) {
-		sd = &per_cpu(allnodes_domains, i).sd;
-		SD_INIT(sd, ALLNODES);
-		set_domain_attribute(sd, attr);
-		cpumask_copy(sched_domain_span(sd), cpu_map);
-		cpu_to_allnodes_group(i, cpu_map, &sd->groups, d->tmpmask);
-		d->sd_allnodes = 1;
-	}
-	parent = sd;
-
-	sd = &per_cpu(node_domains, i).sd;
-	SD_INIT(sd, NODE);
-	set_domain_attribute(sd, attr);
-	sched_domain_node_span(cpu_to_node(i), sched_domain_span(sd));
-	sd->parent = parent;
-	if (parent)
-		parent->child = sd;
-	cpumask_and(sched_domain_span(sd), sched_domain_span(sd), cpu_map);
-#endif
-	return sd;
-}
+	struct sd_data *sdd = sd->private;
+	struct sched_group *sg = sd->groups;
 
-static struct sched_domain *__build_cpu_sched_domain(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
-	struct sched_domain *parent, int i)
-{
-	struct sched_domain *sd;
-	sd = &per_cpu(phys_domains, i).sd;
-	SD_INIT(sd, CPU);
-	set_domain_attribute(sd, attr);
-	cpumask_copy(sched_domain_span(sd), d->nodemask);
-	sd->parent = parent;
-	if (parent)
-		parent->child = sd;
-	cpu_to_phys_group(i, cpu_map, &sd->groups, d->tmpmask);
-	return sd;
-}
+	WARN_ON_ONCE(*per_cpu_ptr(sdd->sd, cpu) != sd);
+	*per_cpu_ptr(sdd->sd, cpu) = NULL;
 
-static struct sched_domain *__build_book_sched_domain(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
-	struct sched_domain *parent, int i)
-{
-	struct sched_domain *sd = parent;
-#ifdef CONFIG_SCHED_BOOK
-	sd = &per_cpu(book_domains, i).sd;
-	SD_INIT(sd, BOOK);
-	set_domain_attribute(sd, attr);
-	cpumask_and(sched_domain_span(sd), cpu_map, cpu_book_mask(i));
-	sd->parent = parent;
-	parent->child = sd;
-	cpu_to_book_group(i, cpu_map, &sd->groups, d->tmpmask);
-#endif
-	return sd;
+	if (cpu == cpumask_first(sched_group_cpus(sg))) {
+		WARN_ON_ONCE(*per_cpu_ptr(sdd->sg, cpu) != sg);
+		*per_cpu_ptr(sdd->sg, cpu) = NULL;
+	}
 }
 
-static struct sched_domain *__build_mc_sched_domain(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
-	struct sched_domain *parent, int i)
+#ifdef CONFIG_SCHED_SMT
+static const struct cpumask *cpu_smt_mask(int cpu)
 {
-	struct sched_domain *sd = parent;
-#ifdef CONFIG_SCHED_MC
-	sd = &per_cpu(core_domains, i).sd;
-	SD_INIT(sd, MC);
-	set_domain_attribute(sd, attr);
-	cpumask_and(sched_domain_span(sd), cpu_map, cpu_coregroup_mask(i));
-	sd->parent = parent;
-	parent->child = sd;
-	cpu_to_core_group(i, cpu_map, &sd->groups, d->tmpmask);
-#endif
-	return sd;
+	return topology_thread_cpumask(cpu);
 }
-
-static struct sched_domain *__build_smt_sched_domain(struct s_data *d,
-	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
-	struct sched_domain *parent, int i)
-{
-	struct sched_domain *sd = parent;
-#ifdef CONFIG_SCHED_SMT
-	sd = &per_cpu(cpu_domains, i).sd;
-	SD_INIT(sd, SIBLING);
-	set_domain_attribute(sd, attr);
-	cpumask_and(sched_domain_span(sd), cpu_map, topology_thread_cpumask(i));
-	sd->parent = parent;
-	parent->child = sd;
-	cpu_to_cpu_group(i, cpu_map, &sd->groups, d->tmpmask);
 #endif
-	return sd;
-}
 
-static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
-			       const struct cpumask *cpu_map, int cpu)
-{
-	switch (l) {
+/*
+ * Topology list, bottom-up.
+ */
+static struct sched_domain_topology_level default_topology[] = {
 #ifdef CONFIG_SCHED_SMT
-	case SD_LV_SIBLING: /* set up CPU (sibling) groups */
-		cpumask_and(d->this_sibling_map, cpu_map,
-			    topology_thread_cpumask(cpu));
-		if (cpu == cpumask_first(d->this_sibling_map))
-			init_sched_build_groups(d->this_sibling_map, cpu_map,
-						&cpu_to_cpu_group,
-						d->send_covered, d->tmpmask);
-		break;
+	{ sd_init_SIBLING, cpu_smt_mask, },
 #endif
 #ifdef CONFIG_SCHED_MC
-	case SD_LV_MC: /* set up multi-core groups */
-		cpumask_and(d->this_core_map, cpu_map, cpu_coregroup_mask(cpu));
-		if (cpu == cpumask_first(d->this_core_map))
-			init_sched_build_groups(d->this_core_map, cpu_map,
-						&cpu_to_core_group,
-						d->send_covered, d->tmpmask);
-		break;
+	{ sd_init_MC, cpu_coregroup_mask, },
 #endif
 #ifdef CONFIG_SCHED_BOOK
-	case SD_LV_BOOK: /* set up book groups */
-		cpumask_and(d->this_book_map, cpu_map, cpu_book_mask(cpu));
-		if (cpu == cpumask_first(d->this_book_map))
-			init_sched_build_groups(d->this_book_map, cpu_map,
-						&cpu_to_book_group,
-						d->send_covered, d->tmpmask);
-		break;
+	{ sd_init_BOOK, cpu_book_mask, },
 #endif
-	case SD_LV_CPU: /* set up physical groups */
-		cpumask_and(d->nodemask, cpumask_of_node(cpu), cpu_map);
-		if (!cpumask_empty(d->nodemask))
-			init_sched_build_groups(d->nodemask, cpu_map,
-						&cpu_to_phys_group,
-						d->send_covered, d->tmpmask);
-		break;
+	{ sd_init_CPU, cpu_cpu_mask, },
 #ifdef CONFIG_NUMA
-	case SD_LV_ALLNODES:
-		init_sched_build_groups(cpu_map, cpu_map, &cpu_to_allnodes_group,
-					d->send_covered, d->tmpmask);
-		break;
+	{ sd_init_NODE, cpu_node_mask, },
+	{ sd_init_ALLNODES, cpu_allnodes_mask, },
 #endif
-	default:
-		break;
+	{ NULL, },
+};
+
+static struct sched_domain_topology_level *sched_domain_topology = default_topology;
+
+static int __sdt_alloc(const struct cpumask *cpu_map)
+{
+	struct sched_domain_topology_level *tl;
+	int j;
+
+	for (tl = sched_domain_topology; tl->init; tl++) {
+		struct sd_data *sdd = &tl->data;
+
+		sdd->sd = alloc_percpu(struct sched_domain *);
+		if (!sdd->sd)
+			return -ENOMEM;
+
+		sdd->sg = alloc_percpu(struct sched_group *);
+		if (!sdd->sg)
+			return -ENOMEM;
+
+		for_each_cpu(j, cpu_map) {
+			struct sched_domain *sd;
+			struct sched_group *sg;
+
+		       	sd = kzalloc_node(sizeof(struct sched_domain) + cpumask_size(),
+					GFP_KERNEL, cpu_to_node(j));
+			if (!sd)
+				return -ENOMEM;
+
+			*per_cpu_ptr(sdd->sd, j) = sd;
+
+			sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
+					GFP_KERNEL, cpu_to_node(j));
+			if (!sg)
+				return -ENOMEM;
+
+			*per_cpu_ptr(sdd->sg, j) = sg;
+		}
 	}
+
+	return 0;
+}
+
+static void __sdt_free(const struct cpumask *cpu_map)
+{
+	struct sched_domain_topology_level *tl;
+	int j;
+
+	for (tl = sched_domain_topology; tl->init; tl++) {
+		struct sd_data *sdd = &tl->data;
+
+		for_each_cpu(j, cpu_map) {
+			kfree(*per_cpu_ptr(sdd->sd, j));
+			kfree(*per_cpu_ptr(sdd->sg, j));
+		}
+		free_percpu(sdd->sd);
+		free_percpu(sdd->sg);
+	}
+}
+
+struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
+		struct s_data *d, const struct cpumask *cpu_map,
+		struct sched_domain_attr *attr, struct sched_domain *child,
+		int cpu)
+{
+	struct sched_domain *sd = tl->init(tl, cpu);
+	if (!sd)
+		return child;
+
+	set_domain_attribute(sd, attr);
+	cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
+	if (child) {
+		sd->level = child->level + 1;
+		sched_domain_level_max = max(sched_domain_level_max, sd->level);
+		child->parent = sd;
+	}
+	sd->child = child;
+
+	return sd;
 }
 
 /*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
  */
-static int __build_sched_domains(const struct cpumask *cpu_map,
-				 struct sched_domain_attr *attr)
+static int build_sched_domains(const struct cpumask *cpu_map,
+			       struct sched_domain_attr *attr)
 {
 	enum s_alloc alloc_state = sa_none;
-	struct s_data d;
 	struct sched_domain *sd;
-	int i;
-#ifdef CONFIG_NUMA
-	d.sd_allnodes = 0;
-#endif
+	struct s_data d;
+	int i, ret = -ENOMEM;
 
 	alloc_state = __visit_domain_allocation_hell(&d, cpu_map);
 	if (alloc_state != sa_rootdomain)
 		goto error;
-	alloc_state = sa_sched_groups;
-
-	/*
-	 * Set up domains for cpus specified by the cpu_map.
-	 */
-	for_each_cpu(i, cpu_map) {
-		cpumask_and(d.nodemask, cpumask_of_node(cpu_to_node(i)),
-			    cpu_map);
-
-		sd = __build_numa_sched_domains(&d, cpu_map, attr, i);
-		sd = __build_cpu_sched_domain(&d, cpu_map, attr, sd, i);
-		sd = __build_book_sched_domain(&d, cpu_map, attr, sd, i);
-		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
-		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
-	}
 
+	/* Set up domains for cpus specified by the cpu_map. */
 	for_each_cpu(i, cpu_map) {
-		build_sched_groups(&d, SD_LV_SIBLING, cpu_map, i);
-		build_sched_groups(&d, SD_LV_BOOK, cpu_map, i);
-		build_sched_groups(&d, SD_LV_MC, cpu_map, i);
-	}
+		struct sched_domain_topology_level *tl;
 
-	/* Set up physical groups */
-	for (i = 0; i < nr_node_ids; i++)
-		build_sched_groups(&d, SD_LV_CPU, cpu_map, i);
+		sd = NULL;
+		for (tl = sched_domain_topology; tl->init; tl++)
+			sd = build_sched_domain(tl, &d, cpu_map, attr, sd, i);
 
-#ifdef CONFIG_NUMA
-	/* Set up node groups */
-	if (d.sd_allnodes)
-		build_sched_groups(&d, SD_LV_ALLNODES, cpu_map, 0);
+		while (sd->child)
+			sd = sd->child;
 
-	for (i = 0; i < nr_node_ids; i++)
-		if (build_numa_sched_groups(&d, cpu_map, i))
-			goto error;
-#endif
-
-	/* Calculate CPU power for physical packages and nodes */
-#ifdef CONFIG_SCHED_SMT
-	for_each_cpu(i, cpu_map) {
-		sd = &per_cpu(cpu_domains, i).sd;
-		init_sched_groups_power(i, sd);
-	}
-#endif
-#ifdef CONFIG_SCHED_MC
-	for_each_cpu(i, cpu_map) {
-		sd = &per_cpu(core_domains, i).sd;
-		init_sched_groups_power(i, sd);
+		*per_cpu_ptr(d.sd, i) = sd;
 	}
-#endif
-#ifdef CONFIG_SCHED_BOOK
-	for_each_cpu(i, cpu_map) {
-		sd = &per_cpu(book_domains, i).sd;
-		init_sched_groups_power(i, sd);
-	}
-#endif
 
+	/* Build the groups for the domains */
 	for_each_cpu(i, cpu_map) {
-		sd = &per_cpu(phys_domains, i).sd;
-		init_sched_groups_power(i, sd);
-	}
+		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
+			sd->span_weight = cpumask_weight(sched_domain_span(sd));
+			get_group(i, sd->private, &sd->groups);
+			atomic_inc(&sd->groups->ref);
 
-#ifdef CONFIG_NUMA
-	for (i = 0; i < nr_node_ids; i++)
-		init_numa_sched_groups_power(d.sched_group_nodes[i]);
+			if (i != cpumask_first(sched_domain_span(sd)))
+				continue;
 
-	if (d.sd_allnodes) {
-		struct sched_group *sg;
+			build_sched_groups(sd);
+		}
+	}
 
-		cpu_to_allnodes_group(cpumask_first(cpu_map), cpu_map, &sg,
-								d.tmpmask);
-		init_numa_sched_groups_power(sg);
+	/* Calculate CPU power for physical packages and nodes */
+	for (i = nr_cpumask_bits-1; i >= 0; i--) {
+		if (!cpumask_test_cpu(i, cpu_map))
+			continue;
+
+		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
+			claim_allocations(i, sd);
+			init_sched_groups_power(i, sd);
+		}
 	}
-#endif
 
 	/* Attach the domains */
+	rcu_read_lock();
 	for_each_cpu(i, cpu_map) {
-#ifdef CONFIG_SCHED_SMT
-		sd = &per_cpu(cpu_domains, i).sd;
-#elif defined(CONFIG_SCHED_MC)
-		sd = &per_cpu(core_domains, i).sd;
-#elif defined(CONFIG_SCHED_BOOK)
-		sd = &per_cpu(book_domains, i).sd;
-#else
-		sd = &per_cpu(phys_domains, i).sd;
-#endif
+		sd = *per_cpu_ptr(d.sd, i);
 		cpu_attach_domain(sd, d.rd, i);
 	}
+	rcu_read_unlock();
 
-	d.sched_group_nodes = NULL; /* don't free this we still need it */
-	__free_domain_allocs(&d, sa_tmpmask, cpu_map);
-	return 0;
-
+	ret = 0;
 error:
 	__free_domain_allocs(&d, alloc_state, cpu_map);
-	return -ENOMEM;
-}
-
-static int build_sched_domains(const struct cpumask *cpu_map)
-{
-	return __build_sched_domains(cpu_map, NULL);
+	return ret;
 }
 
 static cpumask_var_t *doms_cur;	/* current sched domains */
@@ -7670,7 +7362,7 @@ void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms)
  * For now this just excludes isolated cpus, but could be used to
  * exclude other special cases in the future.
  */
-static int arch_init_sched_domains(const struct cpumask *cpu_map)
+static int init_sched_domains(const struct cpumask *cpu_map)
 {
 	int err;
 
@@ -7681,32 +7373,24 @@ static int arch_init_sched_domains(const struct cpumask *cpu_map)
 		doms_cur = &fallback_doms;
 	cpumask_andnot(doms_cur[0], cpu_map, cpu_isolated_map);
 	dattr_cur = NULL;
-	err = build_sched_domains(doms_cur[0]);
+	err = build_sched_domains(doms_cur[0], NULL);
 	register_sched_domain_sysctl();
 
 	return err;
 }
 
-static void arch_destroy_sched_domains(const struct cpumask *cpu_map,
-				       struct cpumask *tmpmask)
-{
-	free_sched_groups(cpu_map, tmpmask);
-}
-
 /*
  * Detach sched domains from a group of cpus specified in cpu_map
  * These cpus will now be attached to the NULL domain
  */
 static void detach_destroy_domains(const struct cpumask *cpu_map)
 {
-	/* Save because hotplug lock held. */
-	static DECLARE_BITMAP(tmpmask, CONFIG_NR_CPUS);
 	int i;
 
+	rcu_read_lock();
 	for_each_cpu(i, cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
-	synchronize_sched();
-	arch_destroy_sched_domains(cpu_map, to_cpumask(tmpmask));
+	rcu_read_unlock();
 }
 
 /* handle null as "default" */
@@ -7795,8 +7479,7 @@ match1:
 				goto match2;
 		}
 		/* no match - add a new doms_new */
-		__build_sched_domains(doms_new[i],
-					dattr_new ? dattr_new + i : NULL);
+		build_sched_domains(doms_new[i], dattr_new ? dattr_new + i : NULL);
 match2:
 		;
 	}
@@ -7815,7 +7498,7 @@ match2:
 }
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-static void arch_reinit_sched_domains(void)
+static void reinit_sched_domains(void)
 {
 	get_online_cpus();
 
@@ -7848,7 +7531,7 @@ static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
 	else
 		sched_mc_power_savings = level;
 
-	arch_reinit_sched_domains();
+	reinit_sched_domains();
 
 	return count;
 }
@@ -7967,14 +7650,9 @@ void __init sched_init_smp(void)
 	alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL);
 	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
 
-#if defined(CONFIG_NUMA)
-	sched_group_nodes_bycpu = kzalloc(nr_cpu_ids * sizeof(void **),
-								GFP_KERNEL);
-	BUG_ON(sched_group_nodes_bycpu == NULL);
-#endif
 	get_online_cpus();
 	mutex_lock(&sched_domains_mutex);
-	arch_init_sched_domains(cpu_active_mask);
+	init_sched_domains(cpu_active_mask);
 	cpumask_andnot(non_isolated_cpus, cpu_possible_mask, cpu_isolated_map);
 	if (cpumask_empty(non_isolated_cpus))
 		cpumask_set_cpu(smp_processor_id(), non_isolated_cpus);
@@ -8281,6 +7959,7 @@ void __init sched_init(void)
 	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
 	zalloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
 #ifdef CONFIG_SMP
+	zalloc_cpumask_var(&sched_domains_tmpmask, GFP_NOWAIT);
 #ifdef CONFIG_NO_HZ
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
 	alloc_cpumask_var(&nohz.grp_idle_mask, GFP_NOWAIT);
@@ -8340,7 +8019,7 @@ static void normalize_task(struct rq *rq, struct task_struct *p)
 	int old_prio = p->prio;
 	int on_rq;
 
-	on_rq = p->se.on_rq;
+	on_rq = p->on_rq;
 	if (on_rq)
 		deactivate_task(rq, p, 0);
 	__setscheduler(rq, p, SCHED_NORMAL, 0);
@@ -8553,7 +8232,6 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 {
 	struct rt_rq *rt_rq;
 	struct sched_rt_entity *rt_se;
-	struct rq *rq;
 	int i;
 
 	tg->rt_rq = kzalloc(sizeof(rt_rq) * nr_cpu_ids, GFP_KERNEL);
@@ -8567,8 +8245,6 @@ int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent)
 			ktime_to_ns(def_rt_bandwidth.rt_period), 0);
 
 	for_each_possible_cpu(i) {
-		rq = cpu_rq(i);
-
 		rt_rq = kzalloc_node(sizeof(struct rt_rq),
 				     GFP_KERNEL, cpu_to_node(i));
 		if (!rt_rq)
@@ -8683,7 +8359,7 @@ void sched_move_task(struct task_struct *tsk)
 	rq = task_rq_lock(tsk, &flags);
 
 	running = task_current(rq, tsk);
-	on_rq = tsk->se.on_rq;
+	on_rq = tsk->on_rq;
 
 	if (on_rq)
 		dequeue_task(rq, tsk, 0);
@@ -8702,7 +8378,7 @@ void sched_move_task(struct task_struct *tsk)
 	if (on_rq)
 		enqueue_task(rq, tsk, 0);
 
-	task_rq_unlock(rq, &flags);
+	task_rq_unlock(rq, tsk, &flags);
 }
 #endif /* CONFIG_CGROUP_SCHED */
 
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 7bacd83..a6710a1 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -152,7 +152,7 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 	read_lock_irqsave(&tasklist_lock, flags);
 
 	do_each_thread(g, p) {
-		if (!p->se.on_rq || task_cpu(p) != rq_cpu)
+		if (!p->on_rq || task_cpu(p) != rq_cpu)
 			continue;
 
 		print_task(m, rq, p);
@@ -296,9 +296,6 @@ static void print_cpu(struct seq_file *m, int cpu)
 	P(ttwu_count);
 	P(ttwu_local);
 
-	SEQ_printf(m, "  .%-30s: %d\n", "bkl_count",
-				rq->rq_sched_info.bkl_count);
-
 #undef P
 #undef P64
 #endif
@@ -441,7 +438,6 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	P(se.statistics.wait_count);
 	PN(se.statistics.iowait_sum);
 	P(se.statistics.iowait_count);
-	P(sched_info.bkl_count);
 	P(se.nr_migrations);
 	P(se.statistics.nr_migrations_cold);
 	P(se.statistics.nr_failed_migrations_affine);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 6fa833a..37f2262 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -358,6 +358,10 @@ static void update_min_vruntime(struct cfs_rq *cfs_rq)
 	}
 
 	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
+#ifndef CONFIG_64BIT
+	smp_wmb();
+	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
+#endif
 }
 
 /*
@@ -1340,6 +1344,8 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	hrtick_update(rq);
 }
 
+static void set_next_buddy(struct sched_entity *se);
+
 /*
  * The dequeue_task method is called before nr_running is
  * decreased. We remove the task from the rbtree and
@@ -1349,14 +1355,22 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
+	int task_sleep = flags & DEQUEUE_SLEEP;
 
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		dequeue_entity(cfs_rq, se, flags);
 
 		/* Don't dequeue parent if it has other entities besides us */
-		if (cfs_rq->load.weight)
+		if (cfs_rq->load.weight) {
+			/*
+			 * Bias pick_next to pick a task from this cfs_rq, as
+			 * p is sleeping when it is within its sched_slice.
+			 */
+			if (task_sleep && parent_entity(se))
+				set_next_buddy(parent_entity(se));
 			break;
+		}
 		flags |= DEQUEUE_SLEEP;
 	}
 
@@ -1372,12 +1386,25 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 
 #ifdef CONFIG_SMP
 
-static void task_waking_fair(struct rq *rq, struct task_struct *p)
+static void task_waking_fair(struct task_struct *p)
 {
 	struct sched_entity *se = &p->se;
 	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+	u64 min_vruntime;
 
-	se->vruntime -= cfs_rq->min_vruntime;
+#ifndef CONFIG_64BIT
+	u64 min_vruntime_copy;
+
+	do {
+		min_vruntime_copy = cfs_rq->min_vruntime_copy;
+		smp_rmb();
+		min_vruntime = cfs_rq->min_vruntime;
+	} while (min_vruntime != min_vruntime_copy);
+#else
+	min_vruntime = cfs_rq->min_vruntime;
+#endif
+
+	se->vruntime -= min_vruntime;
 }
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -1622,6 +1649,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	/*
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
+	rcu_read_lock();
 	for_each_domain(target, sd) {
 		if (!(sd->flags & SD_SHARE_PKG_RESOURCES))
 			break;
@@ -1641,6 +1669,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
 		    cpumask_test_cpu(prev_cpu, sched_domain_span(sd)))
 			break;
 	}
+	rcu_read_unlock();
 
 	return target;
 }
@@ -1657,7 +1686,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
  * preempt must be disabled.
  */
 static int
-select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_flags)
+select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 {
 	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
 	int cpu = smp_processor_id();
@@ -1673,6 +1702,7 @@ select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_
 		new_cpu = prev_cpu;
 	}
 
+	rcu_read_lock();
 	for_each_domain(cpu, tmp) {
 		if (!(tmp->flags & SD_LOAD_BALANCE))
 			continue;
@@ -1723,9 +1753,10 @@ select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_
 
 	if (affine_sd) {
 		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
-			return select_idle_sibling(p, cpu);
-		else
-			return select_idle_sibling(p, prev_cpu);
+			prev_cpu = cpu;
+
+		new_cpu = select_idle_sibling(p, prev_cpu);
+		goto unlock;
 	}
 
 	while (sd) {
@@ -1766,6 +1797,8 @@ select_task_rq_fair(struct rq *rq, struct task_struct *p, int sd_flag, int wake_
 		}
 		/* while loop will break here if sd == NULL */
 	}
+unlock:
+	rcu_read_unlock();
 
 	return new_cpu;
 }
@@ -1789,10 +1822,7 @@ wakeup_gran(struct sched_entity *curr, struct sched_entity *se)
 	 * This is especially important for buddies when the leftmost
 	 * task is higher priority than the buddy.
 	 */
-	if (unlikely(se->load.weight != NICE_0_LOAD))
-		gran = calc_delta_fair(gran, se);
-
-	return gran;
+	return calc_delta_fair(gran, se);
 }
 
 /*
@@ -1826,26 +1856,26 @@ wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
 
 static void set_last_buddy(struct sched_entity *se)
 {
-	if (likely(task_of(se)->policy != SCHED_IDLE)) {
-		for_each_sched_entity(se)
-			cfs_rq_of(se)->last = se;
-	}
+	if (entity_is_task(se) && unlikely(task_of(se)->policy == SCHED_IDLE))
+		return;
+
+	for_each_sched_entity(se)
+		cfs_rq_of(se)->last = se;
 }
 
 static void set_next_buddy(struct sched_entity *se)
 {
-	if (likely(task_of(se)->policy != SCHED_IDLE)) {
-		for_each_sched_entity(se)
-			cfs_rq_of(se)->next = se;
-	}
+	if (entity_is_task(se) && unlikely(task_of(se)->policy == SCHED_IDLE))
+		return;
+
+	for_each_sched_entity(se)
+		cfs_rq_of(se)->next = se;
 }
 
 static void set_skip_buddy(struct sched_entity *se)
 {
-	if (likely(task_of(se)->policy != SCHED_IDLE)) {
-		for_each_sched_entity(se)
-			cfs_rq_of(se)->skip = se;
-	}
+	for_each_sched_entity(se)
+		cfs_rq_of(se)->skip = se;
 }
 
 /*
@@ -1857,12 +1887,15 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	struct sched_entity *se = &curr->se, *pse = &p->se;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	int scale = cfs_rq->nr_running >= sched_nr_latency;
+	int next_buddy_marked = 0;
 
 	if (unlikely(se == pse))
 		return;
 
-	if (sched_feat(NEXT_BUDDY) && scale && !(wake_flags & WF_FORK))
+	if (sched_feat(NEXT_BUDDY) && scale && !(wake_flags & WF_FORK)) {
 		set_next_buddy(pse);
+		next_buddy_marked = 1;
+	}
 
 	/*
 	 * We can come here with TIF_NEED_RESCHED already set from new task
@@ -1890,8 +1923,15 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	update_curr(cfs_rq);
 	find_matching_se(&se, &pse);
 	BUG_ON(!pse);
-	if (wakeup_preempt_entity(se, pse) == 1)
+	if (wakeup_preempt_entity(se, pse) == 1) {
+		/*
+		 * Bias pick_next to pick the sched entity that is
+		 * triggering this preemption.
+		 */
+		if (!next_buddy_marked)
+			set_next_buddy(pse);
 		goto preempt;
+	}
 
 	return;
 
@@ -2102,7 +2142,7 @@ static unsigned long
 balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	      unsigned long max_load_move, struct sched_domain *sd,
 	      enum cpu_idle_type idle, int *all_pinned,
-	      int *this_best_prio, struct cfs_rq *busiest_cfs_rq)
+	      struct cfs_rq *busiest_cfs_rq)
 {
 	int loops = 0, pulled = 0;
 	long rem_load_move = max_load_move;
@@ -2140,9 +2180,6 @@ balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		 */
 		if (rem_load_move <= 0)
 			break;
-
-		if (p->prio < *this_best_prio)
-			*this_best_prio = p->prio;
 	}
 out:
 	/*
@@ -2202,7 +2239,7 @@ static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
+		  int *all_pinned)
 {
 	long rem_load_move = max_load_move;
 	int busiest_cpu = cpu_of(busiest);
@@ -2227,7 +2264,7 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		rem_load = div_u64(rem_load, busiest_h_load + 1);
 
 		moved_load = balance_tasks(this_rq, this_cpu, busiest,
-				rem_load, sd, idle, all_pinned, this_best_prio,
+				rem_load, sd, idle, all_pinned,
 				busiest_cfs_rq);
 
 		if (!moved_load)
@@ -2253,11 +2290,11 @@ static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
+		  int *all_pinned)
 {
 	return balance_tasks(this_rq, this_cpu, busiest,
 			max_load_move, sd, idle, all_pinned,
-			this_best_prio, &busiest->cfs);
+			&busiest->cfs);
 }
 #endif
 
@@ -2274,12 +2311,11 @@ static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		      int *all_pinned)
 {
 	unsigned long total_load_moved = 0, load_moved;
-	int this_best_prio = this_rq->curr->prio;
 
 	do {
 		load_moved = load_balance_fair(this_rq, this_cpu, busiest,
 				max_load_move - total_load_moved,
-				sd, idle, all_pinned, &this_best_prio);
+				sd, idle, all_pinned);
 
 		total_load_moved += load_moved;
 
@@ -2648,7 +2684,7 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
 	/*
 	 * Only siblings can have significantly less than SCHED_LOAD_SCALE
 	 */
-	if (sd->level != SD_LV_SIBLING)
+	if (!(sd->flags & SD_SHARE_CPUPOWER))
 		return 0;
 
 	/*
@@ -3465,6 +3501,7 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 	raw_spin_unlock(&this_rq->lock);
 
 	update_shares(this_cpu);
+	rcu_read_lock();
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
 		int balance = 1;
@@ -3486,6 +3523,7 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 			break;
 		}
 	}
+	rcu_read_unlock();
 
 	raw_spin_lock(&this_rq->lock);
 
@@ -3534,6 +3572,7 @@ static int active_load_balance_cpu_stop(void *data)
 	double_lock_balance(busiest_rq, target_rq);
 
 	/* Search for an sd spanning us and the target CPU. */
+	rcu_read_lock();
 	for_each_domain(target_cpu, sd) {
 		if ((sd->flags & SD_LOAD_BALANCE) &&
 		    cpumask_test_cpu(busiest_cpu, sched_domain_span(sd)))
@@ -3549,6 +3588,7 @@ static int active_load_balance_cpu_stop(void *data)
 		else
 			schedstat_inc(sd, alb_failed);
 	}
+	rcu_read_unlock();
 	double_unlock_balance(busiest_rq, target_rq);
 out_unlock:
 	busiest_rq->active_balance = 0;
@@ -3675,6 +3715,7 @@ static int find_new_ilb(int cpu)
 {
 	struct sched_domain *sd;
 	struct sched_group *ilb_group;
+	int ilb = nr_cpu_ids;
 
 	/*
 	 * Have idle load balancer selection from semi-idle packages only
@@ -3690,20 +3731,25 @@ static int find_new_ilb(int cpu)
 	if (cpumask_weight(nohz.idle_cpus_mask) < 2)
 		goto out_done;
 
+	rcu_read_lock();
 	for_each_flag_domain(cpu, sd, SD_POWERSAVINGS_BALANCE) {
 		ilb_group = sd->groups;
 
 		do {
-			if (is_semi_idle_group(ilb_group))
-				return cpumask_first(nohz.grp_idle_mask);
+			if (is_semi_idle_group(ilb_group)) {
+				ilb = cpumask_first(nohz.grp_idle_mask);
+				goto unlock;
+			}
 
 			ilb_group = ilb_group->next;
 
 		} while (ilb_group != sd->groups);
 	}
+unlock:
+	rcu_read_unlock();
 
 out_done:
-	return nr_cpu_ids;
+	return ilb;
 }
 #else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
 static inline int find_new_ilb(int call_cpu)
@@ -3848,6 +3894,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 
 	update_shares(cpu);
 
+	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
@@ -3893,6 +3940,7 @@ out:
 		if (!balance)
 			break;
 	}
+	rcu_read_unlock();
 
 	/*
 	 * next_balance will be updated only when there is a need.
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 68e69ac..be40f73 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -64,3 +64,9 @@ SCHED_FEAT(OWNER_SPIN, 1)
  * Decrement CPU power based on irq activity
  */
 SCHED_FEAT(NONIRQ_POWER, 1)
+
+/*
+ * Queue remote wakeups on the target CPU and process them
+ * using the scheduler IPI. Reduces rq->lock contention/bounces.
+ */
+SCHED_FEAT(TTWU_QUEUE, 1)
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index a776a63..0a51882 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -7,7 +7,7 @@
 
 #ifdef CONFIG_SMP
 static int
-select_task_rq_idle(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
+select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
 {
 	return task_cpu(p); /* IDLE tasks as never migrated */
 }
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index e7cebdc..0943ed7 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -562,6 +562,13 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 			if (rt_rq->rt_throttled && rt_rq->rt_time < runtime) {
 				rt_rq->rt_throttled = 0;
 				enqueue = 1;
+
+				/*
+				 * Force a clock update if the CPU was idle,
+				 * lest wakeup -> unthrottle time accumulate.
+				 */
+				if (rt_rq->rt_nr_running && rq->curr == rq->idle)
+					rq->skip_clock_update = -1;
 			}
 			if (rt_rq->rt_time || rt_rq->rt_nr_running)
 				idle = 0;
@@ -977,13 +984,23 @@ static void yield_task_rt(struct rq *rq)
 static int find_lowest_rq(struct task_struct *task);
 
 static int
-select_task_rq_rt(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
+select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
 {
+	struct task_struct *curr;
+	struct rq *rq;
+	int cpu;
+
 	if (sd_flag != SD_BALANCE_WAKE)
 		return smp_processor_id();
 
+	cpu = task_cpu(p);
+	rq = cpu_rq(cpu);
+
+	rcu_read_lock();
+	curr = ACCESS_ONCE(rq->curr); /* unlocked access */
+
 	/*
-	 * If the current task is an RT task, then
+	 * If the current task on @p's runqueue is an RT task, then
 	 * try to see if we can wake this RT task up on another
 	 * runqueue. Otherwise simply start this RT task
 	 * on its current runqueue.
@@ -997,21 +1014,25 @@ select_task_rq_rt(struct rq *rq, struct task_struct *p, int sd_flag, int flags)
 	 * lock?
 	 *
 	 * For equal prio tasks, we just let the scheduler sort it out.
+	 *
+	 * Otherwise, just let it ride on the affined RQ and the
+	 * post-schedule router will push the preempted task away
+	 *
+	 * This test is optimistic, if we get it wrong the load-balancer
+	 * will have to sort it out.
 	 */
-	if (unlikely(rt_task(rq->curr)) &&
-	    (rq->curr->rt.nr_cpus_allowed < 2 ||
-	     rq->curr->prio < p->prio) &&
+	if (curr && unlikely(rt_task(curr)) &&
+	    (curr->rt.nr_cpus_allowed < 2 ||
+	     curr->prio < p->prio) &&
 	    (p->rt.nr_cpus_allowed > 1)) {
-		int cpu = find_lowest_rq(p);
+		int target = find_lowest_rq(p);
 
-		return (cpu == -1) ? task_cpu(p) : cpu;
+		if (target != -1)
+			cpu = target;
 	}
+	rcu_read_unlock();
 
-	/*
-	 * Otherwise, just let it ride on the affined RQ and the
-	 * post-schedule router will push the preempted task away
-	 */
-	return task_cpu(p);
+	return cpu;
 }
 
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
@@ -1136,7 +1157,7 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 	 * The previous task needs to be made eligible for pushing
 	 * if it is still active
 	 */
-	if (p->se.on_rq && p->rt.nr_cpus_allowed > 1)
+	if (on_rt_rq(&p->rt) && p->rt.nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
 }
 
@@ -1287,7 +1308,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
 				     !cpumask_test_cpu(lowest_rq->cpu,
 						       &task->cpus_allowed) ||
 				     task_running(rq, task) ||
-				     !task->se.on_rq)) {
+				     !task->on_rq)) {
 
 				raw_spin_unlock(&lowest_rq->lock);
 				lowest_rq = NULL;
@@ -1321,7 +1342,7 @@ static struct task_struct *pick_next_pushable_task(struct rq *rq)
 	BUG_ON(task_current(rq, p));
 	BUG_ON(p->rt.nr_cpus_allowed <= 1);
 
-	BUG_ON(!p->se.on_rq);
+	BUG_ON(!p->on_rq);
 	BUG_ON(!rt_task(p));
 
 	return p;
@@ -1467,7 +1488,7 @@ static int pull_rt_task(struct rq *this_rq)
 		 */
 		if (p && (p->prio < this_rq->rt.highest_prio.curr)) {
 			WARN_ON(p == src_rq->curr);
-			WARN_ON(!p->se.on_rq);
+			WARN_ON(!p->on_rq);
 
 			/*
 			 * There's a chance that p is higher in priority
@@ -1538,7 +1559,7 @@ static void set_cpus_allowed_rt(struct task_struct *p,
 	 * Update the migration status of the RQ if we have an RT task
 	 * which is running AND changing its weight value.
 	 */
-	if (p->se.on_rq && (weight != p->rt.nr_cpus_allowed)) {
+	if (p->on_rq && (weight != p->rt.nr_cpus_allowed)) {
 		struct rq *rq = task_rq(p);
 
 		if (!task_current(rq, p)) {
@@ -1608,7 +1629,7 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p)
 	 * we may need to handle the pulling of RT tasks
 	 * now.
 	 */
-	if (p->se.on_rq && !rq->rt.rt_nr_running)
+	if (p->on_rq && !rq->rt.rt_nr_running)
 		pull_rt_task(rq);
 }
 
@@ -1638,7 +1659,7 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
 	 * If that current running task is also an RT task
 	 * then see if we can move to another run queue.
 	 */
-	if (p->se.on_rq && rq->curr != p) {
+	if (p->on_rq && rq->curr != p) {
 #ifdef CONFIG_SMP
 		if (rq->rt.overloaded && push_rt_task(rq) &&
 		    /* Don't resched if we changed runqueues */
@@ -1657,7 +1678,7 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
 static void
 prio_changed_rt(struct rq *rq, struct task_struct *p, int oldprio)
 {
-	if (!p->se.on_rq)
+	if (!p->on_rq)
 		return;
 
 	if (rq->curr == p) {
diff --git a/kernel/sched_stoptask.c b/kernel/sched_stoptask.c
index 1ba2bd4..6f43763 100644
--- a/kernel/sched_stoptask.c
+++ b/kernel/sched_stoptask.c
@@ -9,8 +9,7 @@
 
 #ifdef CONFIG_SMP
 static int
-select_task_rq_stop(struct rq *rq, struct task_struct *p,
-		    int sd_flag, int flags)
+select_task_rq_stop(struct task_struct *p, int sd_flag, int flags)
 {
 	return task_cpu(p); /* stop tasks as never migrate */
 }
@@ -26,7 +25,7 @@ static struct task_struct *pick_next_task_stop(struct rq *rq)
 {
 	struct task_struct *stop = rq->stop;
 
-	if (stop && stop->se.on_rq)
+	if (stop && stop->on_rq)
 		return stop;
 
 	return NULL;
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 35d55a3..f925c45 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -53,7 +53,6 @@ const char *reserved_field_names[] = {
 	"common_preempt_count",
 	"common_pid",
 	"common_tgid",
-	"common_lock_depth",
 	FIELD_STRING_IP,
 	FIELD_STRING_RETIP,
 	FIELD_STRING_FUNC,
diff --git a/tools/perf/Documentation/perf-script-perl.txt b/tools/perf/Documentation/perf-script-perl.txt
index 5bb41e5..3152cca 100644
--- a/tools/perf/Documentation/perf-script-perl.txt
+++ b/tools/perf/Documentation/perf-script-perl.txt
@@ -63,7 +63,6 @@ The format file for the sched_wakep event defines the following fields
         field:unsigned char common_flags;
         field:unsigned char common_preempt_count;
         field:int common_pid;
-        field:int common_lock_depth;
 
         field:char comm[TASK_COMM_LEN];
         field:pid_t pid;
diff --git a/tools/perf/Documentation/perf-script-python.txt b/tools/perf/Documentation/perf-script-python.txt
index 36b3827..4710220 100644
--- a/tools/perf/Documentation/perf-script-python.txt
+++ b/tools/perf/Documentation/perf-script-python.txt
@@ -463,7 +463,6 @@ The format file for the sched_wakep event defines the following fields
         field:unsigned char common_flags;
         field:unsigned char common_preempt_count;
         field:int common_pid;
-        field:int common_lock_depth;
 
         field:char comm[TASK_COMM_LEN];
         field:pid_t pid;

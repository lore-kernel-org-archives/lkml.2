Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab2CLXpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:45:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932248Ab2CLXiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:38:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/35] Disintegrate asm/system.h for MIPS [ver #2]
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>, linux-mips@linux-mips.org
Date: Mon, 12 Mar 2012 23:38:37 +0000
Message-ID: <20120312233837.13888.87741.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for MIPS.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-mips@linux-mips.org
---

 arch/mips/cavium-octeon/setup.c                |    1 
 arch/mips/cavium-octeon/smp.c                  |    1 
 arch/mips/dec/ecc-berr.c                       |    1 
 arch/mips/dec/kn01-berr.c                      |    1 
 arch/mips/dec/kn02xa-berr.c                    |    1 
 arch/mips/dec/wbflush.c                        |    1 
 arch/mips/emma/markeins/irq.c                  |    1 
 arch/mips/fw/arc/misc.c                        |    1 
 arch/mips/include/asm/atomic.h                 |    2 
 arch/mips/include/asm/cmpxchg.h                |  124 +++++++++++++
 arch/mips/include/asm/dma.h                    |    1 
 arch/mips/include/asm/exec.h                   |   17 ++
 arch/mips/include/asm/mach-au1x00/au1000_dma.h |    1 
 arch/mips/include/asm/processor.h              |    7 +
 arch/mips/include/asm/setup.h                  |   11 +
 arch/mips/include/asm/switch_to.h              |   85 +++++++++
 arch/mips/include/asm/system.h                 |  236 ------------------------
 arch/mips/include/asm/txx9/jmr3927.h           |    1 
 arch/mips/kernel/cpu-bugs64.c                  |    1 
 arch/mips/kernel/cpu-probe.c                   |    1 
 arch/mips/kernel/irq-rm7000.c                  |    1 
 arch/mips/kernel/irq-rm9000.c                  |    1 
 arch/mips/kernel/irq.c                         |    1 
 arch/mips/kernel/irq_cpu.c                     |    1 
 arch/mips/kernel/mips-mt.c                     |    1 
 arch/mips/kernel/process.c                     |    1 
 arch/mips/kernel/ptrace.c                      |    1 
 arch/mips/kernel/ptrace32.c                    |    1 
 arch/mips/kernel/rtlx.c                        |    1 
 arch/mips/kernel/setup.c                       |    1 
 arch/mips/kernel/signal.c                      |    1 
 arch/mips/kernel/signal32.c                    |    1 
 arch/mips/kernel/signal_n32.c                  |    1 
 arch/mips/kernel/smp-bmips.c                   |    1 
 arch/mips/kernel/smp-cmp.c                     |    1 
 arch/mips/kernel/smp-mt.c                      |    1 
 arch/mips/kernel/smp.c                         |    1 
 arch/mips/kernel/smtc-proc.c                   |    1 
 arch/mips/kernel/smtc.c                        |    1 
 arch/mips/kernel/spram.c                       |    1 
 arch/mips/kernel/syscall.c                     |    1 
 arch/mips/kernel/traps.c                       |    1 
 arch/mips/kernel/unaligned.c                   |    1 
 arch/mips/kernel/vpe.c                         |    1 
 arch/mips/lasat/reset.c                        |    1 
 arch/mips/math-emu/dsemul.c                    |    1 
 arch/mips/mipssim/sim_smtc.c                   |    1 
 arch/mips/mm/c-octeon.c                        |    1 
 arch/mips/mm/c-r3k.c                           |    1 
 arch/mips/mm/c-r4k.c                           |    1 
 arch/mips/mm/c-tx39.c                          |    1 
 arch/mips/mm/fault.c                           |    1 
 arch/mips/mm/page.c                            |    1 
 arch/mips/mm/sc-ip22.c                         |    1 
 arch/mips/mm/sc-mips.c                         |    1 
 arch/mips/mm/sc-r5k.c                          |    1 
 arch/mips/mm/tlb-r3k.c                         |    1 
 arch/mips/mm/tlb-r4k.c                         |    1 
 arch/mips/mm/tlb-r8k.c                         |    1 
 arch/mips/mm/tlbex.c                           |    1 
 arch/mips/mti-malta/malta-init.c               |    1 
 arch/mips/netlogic/common/irq.c                |    1 
 arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c     |    1 
 arch/mips/pmc-sierra/msp71xx/msp_irq_per.c     |    1 
 arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c     |    1 
 arch/mips/pmc-sierra/yosemite/irq.c            |    1 
 arch/mips/pmc-sierra/yosemite/prom.c           |    1 
 arch/mips/powertv/asic/irq_asic.c              |    1 
 arch/mips/powertv/init.c                       |    1 
 arch/mips/rb532/irq.c                          |    1 
 arch/mips/sgi-ip22/ip22-berr.c                 |    1 
 arch/mips/sgi-ip22/ip22-reset.c                |    1 
 arch/mips/sgi-ip22/ip28-berr.c                 |    1 
 arch/mips/sgi-ip27/ip27-irq.c                  |    1 
 arch/mips/sgi-ip27/ip27-reset.c                |    1 
 arch/mips/sgi-ip32/ip32-irq.c                  |    1 
 arch/mips/sgi-ip32/ip32-reset.c                |    1 
 arch/mips/sibyte/bcm1480/irq.c                 |    1 
 arch/mips/sibyte/common/sb_tbprof.c            |    1 
 arch/mips/sibyte/sb1250/bus_watcher.c          |    1 
 arch/mips/sibyte/sb1250/irq.c                  |    1 
 arch/mips/sni/reset.c                          |    1 
 arch/mips/vr41xx/common/irq.c                  |    1 
 arch/mips/vr41xx/common/pmu.c                  |    1 
 84 files changed, 250 insertions(+), 309 deletions(-)
 create mode 100644 arch/mips/include/asm/exec.h
 create mode 100644 arch/mips/include/asm/switch_to.h

diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index 260b273..d3a9f012 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -24,7 +24,6 @@
 #include <asm/processor.h>
 #include <asm/reboot.h>
 #include <asm/smp-ops.h>
-#include <asm/system.h>
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
 #include <asm/bootinfo.h>
diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
index b1535fe..599a6db 100644
--- a/arch/mips/cavium-octeon/smp.c
+++ b/arch/mips/cavium-octeon/smp.c
@@ -15,7 +15,6 @@
 #include <linux/module.h>
 
 #include <asm/mmu_context.h>
-#include <asm/system.h>
 #include <asm/time.h>
 
 #include <asm/octeon/octeon.h>
diff --git a/arch/mips/dec/ecc-berr.c b/arch/mips/dec/ecc-berr.c
index 7abce66..5abf4e8 100644
--- a/arch/mips/dec/ecc-berr.c
+++ b/arch/mips/dec/ecc-berr.c
@@ -24,7 +24,6 @@
 #include <asm/irq_regs.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 
 #include <asm/dec/ecc.h>
diff --git a/arch/mips/dec/kn01-berr.c b/arch/mips/dec/kn01-berr.c
index 94d23b4..44d8a87 100644
--- a/arch/mips/dec/kn01-berr.c
+++ b/arch/mips/dec/kn01-berr.c
@@ -22,7 +22,6 @@
 #include <asm/mipsregs.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/uaccess.h>
 
diff --git a/arch/mips/dec/kn02xa-berr.c b/arch/mips/dec/kn02xa-berr.c
index 07ca540..ebb73c5 100644
--- a/arch/mips/dec/kn02xa-berr.c
+++ b/arch/mips/dec/kn02xa-berr.c
@@ -21,7 +21,6 @@
 #include <asm/addrspace.h>
 #include <asm/irq_regs.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 
 #include <asm/dec/kn02ca.h>
diff --git a/arch/mips/dec/wbflush.c b/arch/mips/dec/wbflush.c
index 925c052..46ef903 100644
--- a/arch/mips/dec/wbflush.c
+++ b/arch/mips/dec/wbflush.c
@@ -17,7 +17,6 @@
 #include <linux/init.h>
 
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 #include <asm/wbflush.h>
 
 static void wbflush_kn01(void);
diff --git a/arch/mips/emma/markeins/irq.c b/arch/mips/emma/markeins/irq.c
index 7798887..b5f0825 100644
--- a/arch/mips/emma/markeins/irq.c
+++ b/arch/mips/emma/markeins/irq.c
@@ -27,7 +27,6 @@
 #include <linux/delay.h>
 
 #include <asm/irq_cpu.h>
-#include <asm/system.h>
 #include <asm/mipsregs.h>
 #include <asm/addrspace.h>
 #include <asm/bootinfo.h>
diff --git a/arch/mips/fw/arc/misc.c b/arch/mips/fw/arc/misc.c
index 29627fb..7cf80ca 100644
--- a/arch/mips/fw/arc/misc.c
+++ b/arch/mips/fw/arc/misc.c
@@ -17,7 +17,6 @@
 #include <asm/fw/arc/types.h>
 #include <asm/sgialib.h>
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 
 VOID
 ArcHalt(VOID)
diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index 1d93f81..3f4c5cb 100644
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -18,8 +18,8 @@
 #include <linux/types.h>
 #include <asm/barrier.h>
 #include <asm/cpu-features.h>
+#include <asm/cmpxchg.h>
 #include <asm/war.h>
-#include <asm/system.h>
 
 #define ATOMIC_INIT(i)    { (i) }
 
diff --git a/arch/mips/include/asm/cmpxchg.h b/arch/mips/include/asm/cmpxchg.h
index d8d1c28..285a41f 100644
--- a/arch/mips/include/asm/cmpxchg.h
+++ b/arch/mips/include/asm/cmpxchg.h
@@ -9,6 +9,130 @@
 #define __ASM_CMPXCHG_H
 
 #include <linux/irqflags.h>
+#include <asm/war.h>
+
+static inline unsigned long __xchg_u32(volatile int * m, unsigned int val)
+{
+	__u32 retval;
+
+	smp_mb__before_llsc();
+
+	if (kernel_uses_llsc && R10000_LLSC_WAR) {
+		unsigned long dummy;
+
+		__asm__ __volatile__(
+		"	.set	mips3					\n"
+		"1:	ll	%0, %3			# xchg_u32	\n"
+		"	.set	mips0					\n"
+		"	move	%2, %z4					\n"
+		"	.set	mips3					\n"
+		"	sc	%2, %1					\n"
+		"	beqzl	%2, 1b					\n"
+		"	.set	mips0					\n"
+		: "=&r" (retval), "=m" (*m), "=&r" (dummy)
+		: "R" (*m), "Jr" (val)
+		: "memory");
+	} else if (kernel_uses_llsc) {
+		unsigned long dummy;
+
+		do {
+			__asm__ __volatile__(
+			"	.set	mips3				\n"
+			"	ll	%0, %3		# xchg_u32	\n"
+			"	.set	mips0				\n"
+			"	move	%2, %z4				\n"
+			"	.set	mips3				\n"
+			"	sc	%2, %1				\n"
+			"	.set	mips0				\n"
+			: "=&r" (retval), "=m" (*m), "=&r" (dummy)
+			: "R" (*m), "Jr" (val)
+			: "memory");
+		} while (unlikely(!dummy));
+	} else {
+		unsigned long flags;
+
+		raw_local_irq_save(flags);
+		retval = *m;
+		*m = val;
+		raw_local_irq_restore(flags);	/* implies memory barrier  */
+	}
+
+	smp_llsc_mb();
+
+	return retval;
+}
+
+#ifdef CONFIG_64BIT
+static inline __u64 __xchg_u64(volatile __u64 * m, __u64 val)
+{
+	__u64 retval;
+
+	smp_mb__before_llsc();
+
+	if (kernel_uses_llsc && R10000_LLSC_WAR) {
+		unsigned long dummy;
+
+		__asm__ __volatile__(
+		"	.set	mips3					\n"
+		"1:	lld	%0, %3			# xchg_u64	\n"
+		"	move	%2, %z4					\n"
+		"	scd	%2, %1					\n"
+		"	beqzl	%2, 1b					\n"
+		"	.set	mips0					\n"
+		: "=&r" (retval), "=m" (*m), "=&r" (dummy)
+		: "R" (*m), "Jr" (val)
+		: "memory");
+	} else if (kernel_uses_llsc) {
+		unsigned long dummy;
+
+		do {
+			__asm__ __volatile__(
+			"	.set	mips3				\n"
+			"	lld	%0, %3		# xchg_u64	\n"
+			"	move	%2, %z4				\n"
+			"	scd	%2, %1				\n"
+			"	.set	mips0				\n"
+			: "=&r" (retval), "=m" (*m), "=&r" (dummy)
+			: "R" (*m), "Jr" (val)
+			: "memory");
+		} while (unlikely(!dummy));
+	} else {
+		unsigned long flags;
+
+		raw_local_irq_save(flags);
+		retval = *m;
+		*m = val;
+		raw_local_irq_restore(flags);	/* implies memory barrier  */
+	}
+
+	smp_llsc_mb();
+
+	return retval;
+}
+#else
+extern __u64 __xchg_u64_unsupported_on_32bit_kernels(volatile __u64 * m, __u64 val);
+#define __xchg_u64 __xchg_u64_unsupported_on_32bit_kernels
+#endif
+
+static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
+{
+	switch (size) {
+	case 4:
+		return __xchg_u32(ptr, x);
+	case 8:
+		return __xchg_u64(ptr, x);
+	}
+
+	return x;
+}
+
+#define xchg(ptr, x)							\
+({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) & ~0xc);				\
+									\
+	((__typeof__(*(ptr)))						\
+		__xchg((unsigned long)(x), (ptr), sizeof(*(ptr))));	\
+})
 
 #define __HAVE_ARCH_CMPXCHG 1
 
diff --git a/arch/mips/include/asm/dma.h b/arch/mips/include/asm/dma.h
index 2d47da6..f5097f6 100644
--- a/arch/mips/include/asm/dma.h
+++ b/arch/mips/include/asm/dma.h
@@ -15,7 +15,6 @@
 #include <asm/io.h>			/* need byte IO */
 #include <linux/spinlock.h>		/* And spinlocks */
 #include <linux/delay.h>
-#include <asm/system.h>
 
 
 #ifdef HAVE_REALLY_SLOW_DMA_CONTROLLER
diff --git a/arch/mips/include/asm/exec.h b/arch/mips/include/asm/exec.h
new file mode 100644
index 0000000..c1f6afa
--- /dev/null
+++ b/arch/mips/include/asm/exec.h
@@ -0,0 +1,17 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1994, 95, 96, 97, 98, 99, 2003, 06 by Ralf Baechle
+ * Copyright (C) 1996 by Paul M. Antoine
+ * Copyright (C) 1999 Silicon Graphics
+ * Kevin D. Kissell, kevink@mips.org and Carsten Langgaard, carstenl@mips.com
+ * Copyright (C) 2000 MIPS Technologies, Inc.
+ */
+#ifndef _ASM_EXEC_H
+#define _ASM_EXEC_H
+
+extern unsigned long arch_align_stack(unsigned long sp);
+
+#endif /* _ASM_EXEC_H */
diff --git a/arch/mips/include/asm/mach-au1x00/au1000_dma.h b/arch/mips/include/asm/mach-au1x00/au1000_dma.h
index 59f5b55..ba4cf0e 100644
--- a/arch/mips/include/asm/mach-au1x00/au1000_dma.h
+++ b/arch/mips/include/asm/mach-au1x00/au1000_dma.h
@@ -33,7 +33,6 @@
 #include <linux/io.h>		/* need byte IO */
 #include <linux/spinlock.h>	/* And spinlocks */
 #include <linux/delay.h>
-#include <asm/system.h>
 
 #define NUM_AU1000_DMA_CHANNELS	8
 
diff --git a/arch/mips/include/asm/processor.h b/arch/mips/include/asm/processor.h
index c104f10..20e9dcf 100644
--- a/arch/mips/include/asm/processor.h
+++ b/arch/mips/include/asm/processor.h
@@ -19,7 +19,6 @@
 #include <asm/cpu-info.h>
 #include <asm/mipsregs.h>
 #include <asm/prefetch.h>
-#include <asm/system.h>
 
 /*
  * Return current * instruction pointer ("program counter").
@@ -356,6 +355,12 @@ unsigned long get_wchan(struct task_struct *p);
 #define ARCH_HAS_PREFETCHW
 #define prefetchw(x) __builtin_prefetch((x), 1, 1)
 
+/*
+ * See Documentation/scheduler/sched-arch.txt; prevents deadlock on SMP
+ * systems.
+ */
+#define __ARCH_WANT_UNLOCKED_CTXSW
+
 #endif
 
 #endif /* _ASM_PROCESSOR_H */
diff --git a/arch/mips/include/asm/setup.h b/arch/mips/include/asm/setup.h
index 50511aa..6dce6d8 100644
--- a/arch/mips/include/asm/setup.h
+++ b/arch/mips/include/asm/setup.h
@@ -5,6 +5,17 @@
 
 #ifdef  __KERNEL__
 extern void setup_early_printk(void);
+
+extern void set_handler(unsigned long offset, void *addr, unsigned long len);
+extern void set_uncached_handler(unsigned long offset, void *addr, unsigned long len);
+
+typedef void (*vi_handler_t)(void);
+extern void *set_vi_handler(int n, vi_handler_t addr);
+
+extern void *set_except_vector(int n, void *addr);
+extern unsigned long ebase;
+extern void per_cpu_trap_init(void);
+
 #endif /* __KERNEL__ */
 
 #endif /* __SETUP_H */
diff --git a/arch/mips/include/asm/switch_to.h b/arch/mips/include/asm/switch_to.h
new file mode 100644
index 0000000..5d33621
--- /dev/null
+++ b/arch/mips/include/asm/switch_to.h
@@ -0,0 +1,85 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1994, 95, 96, 97, 98, 99, 2003, 06 by Ralf Baechle
+ * Copyright (C) 1996 by Paul M. Antoine
+ * Copyright (C) 1999 Silicon Graphics
+ * Kevin D. Kissell, kevink@mips.org and Carsten Langgaard, carstenl@mips.com
+ * Copyright (C) 2000 MIPS Technologies, Inc.
+ */
+#ifndef _ASM_SWITCH_TO_H
+#define _ASM_SWITCH_TO_H
+
+#include <asm/cpu-features.h>
+#include <asm/watch.h>
+#include <asm/dsp.h>
+
+struct task_struct;
+
+/*
+ * switch_to(n) should switch tasks to task nr n, first
+ * checking that n isn't the current task, in which case it does nothing.
+ */
+extern asmlinkage void *resume(void *last, void *next, void *next_ti);
+
+extern unsigned int ll_bit;
+extern struct task_struct *ll_task;
+
+#ifdef CONFIG_MIPS_MT_FPAFF
+
+/*
+ * Handle the scheduler resume end of FPU affinity management.  We do this
+ * inline to try to keep the overhead down. If we have been forced to run on
+ * a "CPU" with an FPU because of a previous high level of FP computation,
+ * but did not actually use the FPU during the most recent time-slice (CU1
+ * isn't set), we undo the restriction on cpus_allowed.
+ *
+ * We're not calling set_cpus_allowed() here, because we have no need to
+ * force prompt migration - we're already switching the current CPU to a
+ * different thread.
+ */
+
+#define __mips_mt_fpaff_switch_to(prev)					\
+do {									\
+	struct thread_info *__prev_ti = task_thread_info(prev);		\
+									\
+	if (cpu_has_fpu &&						\
+	    test_ti_thread_flag(__prev_ti, TIF_FPUBOUND) &&		\
+	    (!(KSTK_STATUS(prev) & ST0_CU1))) {				\
+		clear_ti_thread_flag(__prev_ti, TIF_FPUBOUND);		\
+		prev->cpus_allowed = prev->thread.user_cpus_allowed;	\
+	}								\
+	next->thread.emulated_fp = 0;					\
+} while(0)
+
+#else
+#define __mips_mt_fpaff_switch_to(prev) do { (void) (prev); } while (0)
+#endif
+
+#define __clear_software_ll_bit()					\
+do {									\
+	if (!__builtin_constant_p(cpu_has_llsc) || !cpu_has_llsc)	\
+		ll_bit = 0;						\
+} while (0)
+
+#define switch_to(prev, next, last)					\
+do {									\
+	__mips_mt_fpaff_switch_to(prev);				\
+	if (cpu_has_dsp)						\
+		__save_dsp(prev);					\
+	__clear_software_ll_bit();					\
+	(last) = resume(prev, next, task_thread_info(next));		\
+} while (0)
+
+#define finish_arch_switch(prev)					\
+do {									\
+	if (cpu_has_dsp)						\
+		__restore_dsp(current);					\
+	if (cpu_has_userlocal)						\
+		write_c0_userlocal(current_thread_info()->tp_value);	\
+	__restore_watch();						\
+} while (0)
+
+#endif /* _ASM_SWITCH_TO_H */
diff --git a/arch/mips/include/asm/system.h b/arch/mips/include/asm/system.h
index 6018c80..a7f4057 100644
--- a/arch/mips/include/asm/system.h
+++ b/arch/mips/include/asm/system.h
@@ -1,235 +1,5 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 1994, 95, 96, 97, 98, 99, 2003, 06 by Ralf Baechle
- * Copyright (C) 1996 by Paul M. Antoine
- * Copyright (C) 1999 Silicon Graphics
- * Kevin D. Kissell, kevink@mips.org and Carsten Langgaard, carstenl@mips.com
- * Copyright (C) 2000 MIPS Technologies, Inc.
- */
-#ifndef _ASM_SYSTEM_H
-#define _ASM_SYSTEM_H
-
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/irqflags.h>
-
-#include <asm/addrspace.h>
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
 #include <asm/barrier.h>
 #include <asm/cmpxchg.h>
-#include <asm/cpu-features.h>
-#include <asm/dsp.h>
-#include <asm/watch.h>
-#include <asm/war.h>
-
-
-/*
- * switch_to(n) should switch tasks to task nr n, first
- * checking that n isn't the current task, in which case it does nothing.
- */
-extern asmlinkage void *resume(void *last, void *next, void *next_ti);
-
-struct task_struct;
-
-extern unsigned int ll_bit;
-extern struct task_struct *ll_task;
-
-#ifdef CONFIG_MIPS_MT_FPAFF
-
-/*
- * Handle the scheduler resume end of FPU affinity management.  We do this
- * inline to try to keep the overhead down. If we have been forced to run on
- * a "CPU" with an FPU because of a previous high level of FP computation,
- * but did not actually use the FPU during the most recent time-slice (CU1
- * isn't set), we undo the restriction on cpus_allowed.
- *
- * We're not calling set_cpus_allowed() here, because we have no need to
- * force prompt migration - we're already switching the current CPU to a
- * different thread.
- */
-
-#define __mips_mt_fpaff_switch_to(prev)					\
-do {									\
-	struct thread_info *__prev_ti = task_thread_info(prev);		\
-									\
-	if (cpu_has_fpu &&						\
-	    test_ti_thread_flag(__prev_ti, TIF_FPUBOUND) &&		\
-	    (!(KSTK_STATUS(prev) & ST0_CU1))) {				\
-		clear_ti_thread_flag(__prev_ti, TIF_FPUBOUND);		\
-		prev->cpus_allowed = prev->thread.user_cpus_allowed;	\
-	}								\
-	next->thread.emulated_fp = 0;					\
-} while(0)
-
-#else
-#define __mips_mt_fpaff_switch_to(prev) do { (void) (prev); } while (0)
-#endif
-
-#define __clear_software_ll_bit()					\
-do {									\
-	if (!__builtin_constant_p(cpu_has_llsc) || !cpu_has_llsc)	\
-		ll_bit = 0;						\
-} while (0)
-
-#define switch_to(prev, next, last)					\
-do {									\
-	__mips_mt_fpaff_switch_to(prev);				\
-	if (cpu_has_dsp)						\
-		__save_dsp(prev);					\
-	__clear_software_ll_bit();					\
-	(last) = resume(prev, next, task_thread_info(next));		\
-} while (0)
-
-#define finish_arch_switch(prev)					\
-do {									\
-	if (cpu_has_dsp)						\
-		__restore_dsp(current);					\
-	if (cpu_has_userlocal)						\
-		write_c0_userlocal(current_thread_info()->tp_value);	\
-	__restore_watch();						\
-} while (0)
-
-static inline unsigned long __xchg_u32(volatile int * m, unsigned int val)
-{
-	__u32 retval;
-
-	smp_mb__before_llsc();
-
-	if (kernel_uses_llsc && R10000_LLSC_WAR) {
-		unsigned long dummy;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:	ll	%0, %3			# xchg_u32	\n"
-		"	.set	mips0					\n"
-		"	move	%2, %z4					\n"
-		"	.set	mips3					\n"
-		"	sc	%2, %1					\n"
-		"	beqzl	%2, 1b					\n"
-		"	.set	mips0					\n"
-		: "=&r" (retval), "=m" (*m), "=&r" (dummy)
-		: "R" (*m), "Jr" (val)
-		: "memory");
-	} else if (kernel_uses_llsc) {
-		unsigned long dummy;
-
-		do {
-			__asm__ __volatile__(
-			"	.set	mips3				\n"
-			"	ll	%0, %3		# xchg_u32	\n"
-			"	.set	mips0				\n"
-			"	move	%2, %z4				\n"
-			"	.set	mips3				\n"
-			"	sc	%2, %1				\n"
-			"	.set	mips0				\n"
-			: "=&r" (retval), "=m" (*m), "=&r" (dummy)
-			: "R" (*m), "Jr" (val)
-			: "memory");
-		} while (unlikely(!dummy));
-	} else {
-		unsigned long flags;
-
-		raw_local_irq_save(flags);
-		retval = *m;
-		*m = val;
-		raw_local_irq_restore(flags);	/* implies memory barrier  */
-	}
-
-	smp_llsc_mb();
-
-	return retval;
-}
-
-#ifdef CONFIG_64BIT
-static inline __u64 __xchg_u64(volatile __u64 * m, __u64 val)
-{
-	__u64 retval;
-
-	smp_mb__before_llsc();
-
-	if (kernel_uses_llsc && R10000_LLSC_WAR) {
-		unsigned long dummy;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:	lld	%0, %3			# xchg_u64	\n"
-		"	move	%2, %z4					\n"
-		"	scd	%2, %1					\n"
-		"	beqzl	%2, 1b					\n"
-		"	.set	mips0					\n"
-		: "=&r" (retval), "=m" (*m), "=&r" (dummy)
-		: "R" (*m), "Jr" (val)
-		: "memory");
-	} else if (kernel_uses_llsc) {
-		unsigned long dummy;
-
-		do {
-			__asm__ __volatile__(
-			"	.set	mips3				\n"
-			"	lld	%0, %3		# xchg_u64	\n"
-			"	move	%2, %z4				\n"
-			"	scd	%2, %1				\n"
-			"	.set	mips0				\n"
-			: "=&r" (retval), "=m" (*m), "=&r" (dummy)
-			: "R" (*m), "Jr" (val)
-			: "memory");
-		} while (unlikely(!dummy));
-	} else {
-		unsigned long flags;
-
-		raw_local_irq_save(flags);
-		retval = *m;
-		*m = val;
-		raw_local_irq_restore(flags);	/* implies memory barrier  */
-	}
-
-	smp_llsc_mb();
-
-	return retval;
-}
-#else
-extern __u64 __xchg_u64_unsupported_on_32bit_kernels(volatile __u64 * m, __u64 val);
-#define __xchg_u64 __xchg_u64_unsupported_on_32bit_kernels
-#endif
-
-static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
-{
-	switch (size) {
-	case 4:
-		return __xchg_u32(ptr, x);
-	case 8:
-		return __xchg_u64(ptr, x);
-	}
-
-	return x;
-}
-
-#define xchg(ptr, x)							\
-({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) & ~0xc);				\
-									\
-	((__typeof__(*(ptr)))						\
-		__xchg((unsigned long)(x), (ptr), sizeof(*(ptr))));	\
-})
-
-extern void set_handler(unsigned long offset, void *addr, unsigned long len);
-extern void set_uncached_handler(unsigned long offset, void *addr, unsigned long len);
-
-typedef void (*vi_handler_t)(void);
-extern void *set_vi_handler(int n, vi_handler_t addr);
-
-extern void *set_except_vector(int n, void *addr);
-extern unsigned long ebase;
-extern void per_cpu_trap_init(void);
-
-/*
- * See include/asm-ia64/system.h; prevents deadlock on SMP
- * systems.
- */
-#define __ARCH_WANT_UNLOCKED_CTXSW
-
-extern unsigned long arch_align_stack(unsigned long sp);
-
-#endif /* _ASM_SYSTEM_H */
+#include <asm/exec.h>
+#include <asm/switch_to.h>
diff --git a/arch/mips/include/asm/txx9/jmr3927.h b/arch/mips/include/asm/txx9/jmr3927.h
index a409c44..8808d7f 100644
--- a/arch/mips/include/asm/txx9/jmr3927.h
+++ b/arch/mips/include/asm/txx9/jmr3927.h
@@ -12,7 +12,6 @@
 
 #include <asm/txx9/tx3927.h>
 #include <asm/addrspace.h>
-#include <asm/system.h>
 #include <asm/txx9irq.h>
 
 /* CS */
diff --git a/arch/mips/kernel/cpu-bugs64.c b/arch/mips/kernel/cpu-bugs64.c
index f305ca1..bc794f7 100644
--- a/arch/mips/kernel/cpu-bugs64.c
+++ b/arch/mips/kernel/cpu-bugs64.c
@@ -16,7 +16,6 @@
 #include <asm/cpu.h>
 #include <asm/fpu.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 
 static char bug64hit[] __initdata =
 	"reliable operation impossible!\n%s";
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 0bab464..5099201 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -22,7 +22,6 @@
 #include <asm/cpu.h>
 #include <asm/fpu.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 #include <asm/watch.h>
 #include <asm/elf.h>
 #include <asm/spram.h>
diff --git a/arch/mips/kernel/irq-rm7000.c b/arch/mips/kernel/irq-rm7000.c
index a8a8977..b0662cf 100644
--- a/arch/mips/kernel/irq-rm7000.c
+++ b/arch/mips/kernel/irq-rm7000.c
@@ -16,7 +16,6 @@
 
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 
 static inline void unmask_rm7k_irq(struct irq_data *d)
 {
diff --git a/arch/mips/kernel/irq-rm9000.c b/arch/mips/kernel/irq-rm9000.c
index 38874a4..1282b9a 100644
--- a/arch/mips/kernel/irq-rm9000.c
+++ b/arch/mips/kernel/irq-rm9000.c
@@ -17,7 +17,6 @@
 
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 
 static inline void unmask_rm9k_irq(struct irq_data *d)
 {
diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index 7f50318..a5aa43d 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -23,7 +23,6 @@
 #include <linux/ftrace.h>
 
 #include <linux/atomic.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #ifdef CONFIG_KGDB
diff --git a/arch/mips/kernel/irq_cpu.c b/arch/mips/kernel/irq_cpu.c
index 191eb52..972263b 100644
--- a/arch/mips/kernel/irq_cpu.c
+++ b/arch/mips/kernel/irq_cpu.c
@@ -35,7 +35,6 @@
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
 #include <asm/mipsmtregs.h>
-#include <asm/system.h>
 
 static inline void unmask_mips_irq(struct irq_data *d)
 {
diff --git a/arch/mips/kernel/mips-mt.c b/arch/mips/kernel/mips-mt.c
index c23d11f..7f3376b 100644
--- a/arch/mips/kernel/mips-mt.c
+++ b/arch/mips/kernel/mips-mt.c
@@ -13,7 +13,6 @@
 #include <asm/cpu.h>
 #include <asm/processor.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 #include <asm/hardirq.h>
 #include <asm/mmu_context.h>
 #include <asm/mipsmtregs.h>
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 7955409..5bfaea8 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -32,7 +32,6 @@
 #include <asm/dsp.h>
 #include <asm/fpu.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/mipsregs.h>
 #include <asm/processor.h>
 #include <asm/uaccess.h>
diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index 7786b60..7c24c29 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -34,7 +34,6 @@
 #include <asm/mipsmtregs.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/bootinfo.h>
 #include <asm/reg.h>
diff --git a/arch/mips/kernel/ptrace32.c b/arch/mips/kernel/ptrace32.c
index 32644b4..a3b0178 100644
--- a/arch/mips/kernel/ptrace32.c
+++ b/arch/mips/kernel/ptrace32.c
@@ -32,7 +32,6 @@
 #include <asm/mipsmtregs.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/bootinfo.h>
 
diff --git a/arch/mips/kernel/rtlx.c b/arch/mips/kernel/rtlx.c
index a9d801d..b8c18dc 100644
--- a/arch/mips/kernel/rtlx.c
+++ b/arch/mips/kernel/rtlx.c
@@ -38,7 +38,6 @@
 #include <linux/atomic.h>
 #include <asm/cpu.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/vpe.h>
 #include <asm/rtlx.h>
 
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 058e964..c504b21 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -31,7 +31,6 @@
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/smp-ops.h>
-#include <asm/system.h>
 #include <asm/prom.h>
 
 struct cpuinfo_mips cpu_data[NR_CPUS] __read_mostly;
diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
index f852400..185ca00 100644
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -34,6 +34,7 @@
 #include <asm/cpu-features.h>
 #include <asm/war.h>
 #include <asm/vdso.h>
+#include <asm/dsp.h>
 
 #include "signal-common.h"
 
diff --git a/arch/mips/kernel/signal32.c b/arch/mips/kernel/signal32.c
index aae9866..e5ee38e 100644
--- a/arch/mips/kernel/signal32.c
+++ b/arch/mips/kernel/signal32.c
@@ -29,7 +29,6 @@
 #include <asm/cacheflush.h>
 #include <asm/sim.h>
 #include <asm/ucontext.h>
-#include <asm/system.h>
 #include <asm/fpu.h>
 #include <asm/war.h>
 #include <asm/vdso.h>
diff --git a/arch/mips/kernel/signal_n32.c b/arch/mips/kernel/signal_n32.c
index ee24d81..ae29e89 100644
--- a/arch/mips/kernel/signal_n32.c
+++ b/arch/mips/kernel/signal_n32.c
@@ -35,7 +35,6 @@
 #include <asm/sim.h>
 #include <asm/uaccess.h>
 #include <asm/ucontext.h>
-#include <asm/system.h>
 #include <asm/fpu.h>
 #include <asm/cpu-features.h>
 #include <asm/war.h>
diff --git a/arch/mips/kernel/smp-bmips.c b/arch/mips/kernel/smp-bmips.c
index d5e950a..ca67356 100644
--- a/arch/mips/kernel/smp-bmips.c
+++ b/arch/mips/kernel/smp-bmips.c
@@ -28,7 +28,6 @@
 #include <asm/time.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/bootinfo.h>
 #include <asm/pmon.h>
 #include <asm/cacheflush.h>
diff --git a/arch/mips/kernel/smp-cmp.c b/arch/mips/kernel/smp-cmp.c
index fe30951..e7e03ec 100644
--- a/arch/mips/kernel/smp-cmp.c
+++ b/arch/mips/kernel/smp-cmp.c
@@ -29,7 +29,6 @@
 #include <asm/cacheflush.h>
 #include <asm/cpu.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/hardirq.h>
 #include <asm/mmu_context.h>
 #include <asm/smp.h>
diff --git a/arch/mips/kernel/smp-mt.c b/arch/mips/kernel/smp-mt.c
index ce9e286..ff17868 100644
--- a/arch/mips/kernel/smp-mt.c
+++ b/arch/mips/kernel/smp-mt.c
@@ -28,7 +28,6 @@
 #include <asm/cacheflush.h>
 #include <asm/cpu.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/hardirq.h>
 #include <asm/mmu_context.h>
 #include <asm/time.h>
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 32c1e95..a37b082 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -38,7 +38,6 @@
 #include <asm/cpu.h>
 #include <asm/processor.h>
 #include <asm/r4k-timer.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/time.h>
 
diff --git a/arch/mips/kernel/smtc-proc.c b/arch/mips/kernel/smtc-proc.c
index 928a5a6..145771c 100644
--- a/arch/mips/kernel/smtc-proc.c
+++ b/arch/mips/kernel/smtc-proc.c
@@ -11,7 +11,6 @@
 #include <asm/cpu.h>
 #include <asm/processor.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 #include <asm/hardirq.h>
 #include <asm/mmu_context.h>
 #include <asm/mipsregs.h>
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index 0a42ff3..c4f75bb 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -31,7 +31,6 @@
 #include <asm/cpu.h>
 #include <asm/processor.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 #include <asm/hardirq.h>
 #include <asm/hazards.h>
 #include <asm/irq.h>
diff --git a/arch/mips/kernel/spram.c b/arch/mips/kernel/spram.c
index 1821d12..6af08d8 100644
--- a/arch/mips/kernel/spram.c
+++ b/arch/mips/kernel/spram.c
@@ -15,7 +15,6 @@
 
 #include <asm/fpu.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 #include <asm/r4kcache.h>
 #include <asm/hazards.h>
 
diff --git a/arch/mips/kernel/syscall.c b/arch/mips/kernel/syscall.c
index d027657..b08220c 100644
--- a/arch/mips/kernel/syscall.c
+++ b/arch/mips/kernel/syscall.c
@@ -37,6 +37,7 @@
 #include <asm/shmparam.h>
 #include <asm/sysmips.h>
 #include <asm/uaccess.h>
+#include <asm/switch_to.h>
 
 /*
  * For historic reasons the pipe(2) syscall on MIPS has an unusual calling
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index d79ae54..cfdaaa4 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -45,7 +45,6 @@
 #include <asm/pgtable.h>
 #include <asm/ptrace.h>
 #include <asm/sections.h>
-#include <asm/system.h>
 #include <asm/tlbdebug.h>
 #include <asm/traps.h>
 #include <asm/uaccess.h>
diff --git a/arch/mips/kernel/unaligned.c b/arch/mips/kernel/unaligned.c
index aedb894..9c58bdf 100644
--- a/arch/mips/kernel/unaligned.c
+++ b/arch/mips/kernel/unaligned.c
@@ -85,7 +85,6 @@
 #include <asm/cop2.h>
 #include <asm/inst.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #define STR(x)  __STR(x)
 #define __STR(x)  #x
diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index bfa12a4..f6f9152 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -49,7 +49,6 @@
 #include <asm/cpu.h>
 #include <asm/mips_mt.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/vpe.h>
 #include <asm/kspd.h>
 
diff --git a/arch/mips/lasat/reset.c b/arch/mips/lasat/reset.c
index b1e7a89..e21f0b9 100644
--- a/arch/mips/lasat/reset.c
+++ b/arch/mips/lasat/reset.c
@@ -21,7 +21,6 @@
 #include <linux/pm.h>
 
 #include <asm/reboot.h>
-#include <asm/system.h>
 #include <asm/lasat/lasat.h>
 
 #include "picvue.h"
diff --git a/arch/mips/math-emu/dsemul.c b/arch/mips/math-emu/dsemul.c
index 3c4a8c5..384a3b0 100644
--- a/arch/mips/math-emu/dsemul.c
+++ b/arch/mips/math-emu/dsemul.c
@@ -12,7 +12,6 @@
 #include <asm/uaccess.h>
 #include <asm/branch.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 #include <asm/cacheflush.h>
 
 #include <asm/fpu_emulator.h>
diff --git a/arch/mips/mipssim/sim_smtc.c b/arch/mips/mipssim/sim_smtc.c
index 9150639..3c104ab 100644
--- a/arch/mips/mipssim/sim_smtc.c
+++ b/arch/mips/mipssim/sim_smtc.c
@@ -28,7 +28,6 @@
 #include <asm/cpu.h>
 #include <asm/processor.h>
 #include <asm/smtc.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/smtc_ipi.h>
 
diff --git a/arch/mips/mm/c-octeon.c b/arch/mips/mm/c-octeon.c
index cf7895d..1f9ca07 100644
--- a/arch/mips/mm/c-octeon.c
+++ b/arch/mips/mm/c-octeon.c
@@ -21,7 +21,6 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/r4kcache.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/war.h>
 
diff --git a/arch/mips/mm/c-r3k.c b/arch/mips/mm/c-r3k.c
index 0765583..031c4c2 100644
--- a/arch/mips/mm/c-r3k.c
+++ b/arch/mips/mm/c-r3k.c
@@ -18,7 +18,6 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
-#include <asm/system.h>
 #include <asm/isadep.h>
 #include <asm/io.h>
 #include <asm/bootinfo.h>
diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index 4f9eb0b..f62d64f 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -29,7 +29,6 @@
 #include <asm/pgtable.h>
 #include <asm/r4kcache.h>
 #include <asm/sections.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/war.h>
 #include <asm/cacheflush.h> /* for run_uncached() */
diff --git a/arch/mips/mm/c-tx39.c b/arch/mips/mm/c-tx39.c
index a43c197c..87d23ca 100644
--- a/arch/mips/mm/c-tx39.c
+++ b/arch/mips/mm/c-tx39.c
@@ -18,7 +18,6 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
-#include <asm/system.h>
 #include <asm/isadep.h>
 #include <asm/io.h>
 #include <asm/bootinfo.h>
diff --git a/arch/mips/mm/fault.c b/arch/mips/mm/fault.c
index 69ebd58..c14f6df 100644
--- a/arch/mips/mm/fault.c
+++ b/arch/mips/mm/fault.c
@@ -22,7 +22,6 @@
 
 #include <asm/branch.h>
 #include <asm/mmu_context.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/ptrace.h>
 #include <asm/highmem.h>		/* For VMALLOC_END */
diff --git a/arch/mips/mm/page.c b/arch/mips/mm/page.c
index 36272f7..cc0b626 100644
--- a/arch/mips/mm/page.c
+++ b/arch/mips/mm/page.c
@@ -22,7 +22,6 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/prefetch.h>
-#include <asm/system.h>
 #include <asm/bootinfo.h>
 #include <asm/mipsregs.h>
 #include <asm/mmu_context.h>
diff --git a/arch/mips/mm/sc-ip22.c b/arch/mips/mm/sc-ip22.c
index a6bd11f..1eb708e 100644
--- a/arch/mips/mm/sc-ip22.c
+++ b/arch/mips/mm/sc-ip22.c
@@ -12,7 +12,6 @@
 #include <asm/bcache.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/bootinfo.h>
 #include <asm/sgi/ip22.h>
 #include <asm/sgi/mc.h>
diff --git a/arch/mips/mm/sc-mips.c b/arch/mips/mm/sc-mips.c
index 9cca8de..93d937b 100644
--- a/arch/mips/mm/sc-mips.c
+++ b/arch/mips/mm/sc-mips.c
@@ -11,7 +11,6 @@
 #include <asm/cacheops.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/r4kcache.h>
 
diff --git a/arch/mips/mm/sc-r5k.c b/arch/mips/mm/sc-r5k.c
index ae1e533..8d90ff2 100644
--- a/arch/mips/mm/sc-r5k.c
+++ b/arch/mips/mm/sc-r5k.c
@@ -12,7 +12,6 @@
 #include <asm/cacheops.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/r4kcache.h>
 
diff --git a/arch/mips/mm/tlb-r3k.c b/arch/mips/mm/tlb-r3k.c
index ed1fa46..a63d1ed 100644
--- a/arch/mips/mm/tlb-r3k.c
+++ b/arch/mips/mm/tlb-r3k.c
@@ -19,7 +19,6 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
-#include <asm/system.h>
 #include <asm/tlbmisc.h>
 #include <asm/isadep.h>
 #include <asm/io.h>
diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index 2dc6253..d2572cb 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -18,7 +18,6 @@
 #include <asm/bootinfo.h>
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/tlbmisc.h>
 
 extern void build_tlb_refill_handler(void);
diff --git a/arch/mips/mm/tlb-r8k.c b/arch/mips/mm/tlb-r8k.c
index 3d95f76..91c2499 100644
--- a/arch/mips/mm/tlb-r8k.c
+++ b/arch/mips/mm/tlb-r8k.c
@@ -17,7 +17,6 @@
 #include <asm/bootinfo.h>
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 
 extern void build_tlb_refill_handler(void);
 
diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index e06370f..0bc485b 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -32,6 +32,7 @@
 #include <asm/pgtable.h>
 #include <asm/war.h>
 #include <asm/uasm.h>
+#include <asm/setup.h>
 
 /*
  * TLB load/store/modify handlers.
diff --git a/arch/mips/mti-malta/malta-init.c b/arch/mips/mti-malta/malta-init.c
index 4b988b9..27a6cdb 100644
--- a/arch/mips/mti-malta/malta-init.c
+++ b/arch/mips/mti-malta/malta-init.c
@@ -26,7 +26,6 @@
 #include <asm/bootinfo.h>
 #include <asm/gt64120.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/cacheflush.h>
 #include <asm/smp-ops.h>
 #include <asm/traps.h>
diff --git a/arch/mips/netlogic/common/irq.c b/arch/mips/netlogic/common/irq.c
index 49a4f6c..e52bfcb 100644
--- a/arch/mips/netlogic/common/irq.c
+++ b/arch/mips/netlogic/common/irq.c
@@ -43,7 +43,6 @@
 
 #include <asm/errno.h>
 #include <asm/signal.h>
-#include <asm/system.h>
 #include <asm/ptrace.h>
 #include <asm/mipsregs.h>
 #include <asm/thread_info.h>
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c b/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c
index c4fa2d7..2e6f7ca 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c
@@ -16,7 +16,6 @@
 #include <linux/irq.h>
 
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 
 #include <msp_cic_int.h>
 #include <msp_regs.h>
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_irq_per.c b/arch/mips/pmc-sierra/msp71xx/msp_irq_per.c
index 98fd009..598b6a6 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_irq_per.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_irq_per.c
@@ -16,7 +16,6 @@
 #include <linux/bitops.h>
 
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 
 #include <msp_cic_int.h>
 #include <msp_regs.h>
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c b/arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c
index 5bbcc47..83a1c5e 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c
@@ -16,7 +16,6 @@
 #include <linux/bitops.h>
 
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 
 #include <msp_slp_int.h>
 #include <msp_regs.h>
diff --git a/arch/mips/pmc-sierra/yosemite/irq.c b/arch/mips/pmc-sierra/yosemite/irq.c
index 25bbbf4..6590812 100644
--- a/arch/mips/pmc-sierra/yosemite/irq.c
+++ b/arch/mips/pmc-sierra/yosemite/irq.c
@@ -44,7 +44,6 @@
 #include <asm/irq.h>
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 #include <asm/titan_dep.h>
 
 /* Hypertransport specific */
diff --git a/arch/mips/pmc-sierra/yosemite/prom.c b/arch/mips/pmc-sierra/yosemite/prom.c
index dcc926e..6a2754c 100644
--- a/arch/mips/pmc-sierra/yosemite/prom.c
+++ b/arch/mips/pmc-sierra/yosemite/prom.c
@@ -20,7 +20,6 @@
 #include <asm/processor.h>
 #include <asm/reboot.h>
 #include <asm/smp-ops.h>
-#include <asm/system.h>
 #include <asm/bootinfo.h>
 #include <asm/pmon.h>
 
diff --git a/arch/mips/powertv/asic/irq_asic.c b/arch/mips/powertv/asic/irq_asic.c
index 7fb97fb..fa9ae95 100644
--- a/arch/mips/powertv/asic/irq_asic.c
+++ b/arch/mips/powertv/asic/irq_asic.c
@@ -17,7 +17,6 @@
 
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 
 #include <asm/mach-powertv/asic_regs.h>
 
diff --git a/arch/mips/powertv/init.c b/arch/mips/powertv/init.c
index 8355228..1cf5abb 100644
--- a/arch/mips/powertv/init.c
+++ b/arch/mips/powertv/init.c
@@ -26,7 +26,6 @@
 
 #include <asm/bootinfo.h>
 #include <linux/io.h>
-#include <asm/system.h>
 #include <asm/cacheflush.h>
 #include <asm/traps.h>
 
diff --git a/arch/mips/rb532/irq.c b/arch/mips/rb532/irq.c
index 7c6db74..f298430 100644
--- a/arch/mips/rb532/irq.c
+++ b/arch/mips/rb532/irq.c
@@ -42,7 +42,6 @@
 #include <asm/bootinfo.h>
 #include <asm/time.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 
 #include <asm/mach-rc32434/irq.h>
 #include <asm/mach-rc32434/gpio.h>
diff --git a/arch/mips/sgi-ip22/ip22-berr.c b/arch/mips/sgi-ip22/ip22-berr.c
index 911d399..3f6ccd5 100644
--- a/arch/mips/sgi-ip22/ip22-berr.c
+++ b/arch/mips/sgi-ip22/ip22-berr.c
@@ -9,7 +9,6 @@
 #include <linux/sched.h>
 
 #include <asm/addrspace.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/branch.h>
 #include <asm/irq_regs.h>
diff --git a/arch/mips/sgi-ip22/ip22-reset.c b/arch/mips/sgi-ip22/ip22-reset.c
index 45b6694..20363d2 100644
--- a/arch/mips/sgi-ip22/ip22-reset.c
+++ b/arch/mips/sgi-ip22/ip22-reset.c
@@ -18,7 +18,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/reboot.h>
 #include <asm/sgialib.h>
 #include <asm/sgi/ioc.h>
diff --git a/arch/mips/sgi-ip22/ip28-berr.c b/arch/mips/sgi-ip22/ip28-berr.c
index 88c684e..0626555 100644
--- a/arch/mips/sgi-ip22/ip28-berr.c
+++ b/arch/mips/sgi-ip22/ip28-berr.c
@@ -11,7 +11,6 @@
 #include <linux/seq_file.h>
 
 #include <asm/addrspace.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/branch.h>
 #include <asm/irq_regs.h>
diff --git a/arch/mips/sgi-ip27/ip27-irq.c b/arch/mips/sgi-ip27/ip27-irq.c
index 2364223..69a939a 100644
--- a/arch/mips/sgi-ip27/ip27-irq.c
+++ b/arch/mips/sgi-ip27/ip27-irq.c
@@ -27,7 +27,6 @@
 #include <asm/bootinfo.h>
 #include <asm/io.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 
 #include <asm/processor.h>
 #include <asm/pci/bridge.h>
diff --git a/arch/mips/sgi-ip27/ip27-reset.c b/arch/mips/sgi-ip27/ip27-reset.c
index c170761..f347bc6 100644
--- a/arch/mips/sgi-ip27/ip27-reset.c
+++ b/arch/mips/sgi-ip27/ip27-reset.c
@@ -19,7 +19,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/reboot.h>
-#include <asm/system.h>
 #include <asm/sgialib.h>
 #include <asm/sn/addrs.h>
 #include <asm/sn/arch.h>
diff --git a/arch/mips/sgi-ip32/ip32-irq.c b/arch/mips/sgi-ip32/ip32-irq.c
index a092860..e7d5054 100644
--- a/arch/mips/sgi-ip32/ip32-irq.c
+++ b/arch/mips/sgi-ip32/ip32-irq.c
@@ -22,7 +22,6 @@
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
 #include <asm/signal.h>
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/ip32/crime.h>
 #include <asm/ip32/mace.h>
diff --git a/arch/mips/sgi-ip32/ip32-reset.c b/arch/mips/sgi-ip32/ip32-reset.c
index 9b95d80..1f823da 100644
--- a/arch/mips/sgi-ip32/ip32-reset.c
+++ b/arch/mips/sgi-ip32/ip32-reset.c
@@ -20,7 +20,6 @@
 #include <asm/addrspace.h>
 #include <asm/irq.h>
 #include <asm/reboot.h>
-#include <asm/system.h>
 #include <asm/wbflush.h>
 #include <asm/ip32/mace.h>
 #include <asm/ip32/crime.h>
diff --git a/arch/mips/sibyte/bcm1480/irq.c b/arch/mips/sibyte/bcm1480/irq.c
index 09740d6..215713e 100644
--- a/arch/mips/sibyte/bcm1480/irq.c
+++ b/arch/mips/sibyte/bcm1480/irq.c
@@ -27,7 +27,6 @@
 #include <asm/errno.h>
 #include <asm/irq_regs.h>
 #include <asm/signal.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include <asm/sibyte/bcm1480_regs.h>
diff --git a/arch/mips/sibyte/common/sb_tbprof.c b/arch/mips/sibyte/common/sb_tbprof.c
index 48853ab..e8c4538 100644
--- a/arch/mips/sibyte/common/sb_tbprof.c
+++ b/arch/mips/sibyte/common/sb_tbprof.c
@@ -53,7 +53,6 @@
 #define K_INT_PERF_CNT K_BCM1480_INT_PERF_CNT
 #endif
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #define SBPROF_TB_MAJOR 240
diff --git a/arch/mips/sibyte/sb1250/bus_watcher.c b/arch/mips/sibyte/sb1250/bus_watcher.c
index 45274bd..86e6e54 100644
--- a/arch/mips/sibyte/sb1250/bus_watcher.c
+++ b/arch/mips/sibyte/sb1250/bus_watcher.c
@@ -30,7 +30,6 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/proc_fs.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include <asm/sibyte/sb1250.h>
diff --git a/arch/mips/sibyte/sb1250/irq.c b/arch/mips/sibyte/sb1250/irq.c
index 76ee045..340aaf6 100644
--- a/arch/mips/sibyte/sb1250/irq.c
+++ b/arch/mips/sibyte/sb1250/irq.c
@@ -26,7 +26,6 @@
 
 #include <asm/errno.h>
 #include <asm/signal.h>
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/io.h>
 
diff --git a/arch/mips/sni/reset.c b/arch/mips/sni/reset.c
index 79f8d70..244f942 100644
--- a/arch/mips/sni/reset.c
+++ b/arch/mips/sni/reset.c
@@ -5,7 +5,6 @@
  */
 #include <asm/io.h>
 #include <asm/reboot.h>
-#include <asm/system.h>
 #include <asm/sni.h>
 
 /*
diff --git a/arch/mips/vr41xx/common/irq.c b/arch/mips/vr41xx/common/irq.c
index fad2bef..ae0e4ee 100644
--- a/arch/mips/vr41xx/common/irq.c
+++ b/arch/mips/vr41xx/common/irq.c
@@ -22,7 +22,6 @@
 #include <linux/irq.h>
 
 #include <asm/irq_cpu.h>
-#include <asm/system.h>
 #include <asm/vr41xx/irq.h>
 
 typedef struct irq_cascade {
diff --git a/arch/mips/vr41xx/common/pmu.c b/arch/mips/vr41xx/common/pmu.c
index 692b4e8..9fbf5f0 100644
--- a/arch/mips/vr41xx/common/pmu.c
+++ b/arch/mips/vr41xx/common/pmu.c
@@ -30,7 +30,6 @@
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/reboot.h>
-#include <asm/system.h>
 
 #define PMU_TYPE1_BASE	0x0b0000a0UL
 #define PMU_TYPE1_SIZE	0x0eUL


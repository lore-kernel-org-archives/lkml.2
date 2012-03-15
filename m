Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161689Ab2COU64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:58:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161628Ab2COU6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:58:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 21/38] Disintegrate asm/system.h for PowerPC [ver #3]
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>, linuxppc-dev@lists.ozlabs.org
Date: Thu, 15 Mar 2012 20:58:32 +0000
Message-ID: <20120315205831.28759.61679.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for PowerPC.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linuxppc-dev@lists.ozlabs.org
---

 arch/powerpc/include/asm/atomic.h                 |    8 
 arch/powerpc/include/asm/auxvec.h                 |    2 
 arch/powerpc/include/asm/barrier.h                |   68 +++
 arch/powerpc/include/asm/bug.h                    |   11 
 arch/powerpc/include/asm/cache.h                  |   16 +
 arch/powerpc/include/asm/cmpxchg.h                |  309 ++++++++++++
 arch/powerpc/include/asm/debug.h                  |   56 ++
 arch/powerpc/include/asm/dma.h                    |    1 
 arch/powerpc/include/asm/exec.h                   |    9 
 arch/powerpc/include/asm/hw_breakpoint.h          |    2 
 arch/powerpc/include/asm/irq.h                    |    1 
 arch/powerpc/include/asm/processor.h              |   30 +
 arch/powerpc/include/asm/reg_booke.h              |    5 
 arch/powerpc/include/asm/rtas.h                   |    2 
 arch/powerpc/include/asm/setup.h                  |   24 +
 arch/powerpc/include/asm/switch_to.h              |   65 ++
 arch/powerpc/include/asm/system.h                 |  560 ---------------------
 arch/powerpc/kernel/align.c                       |    2 
 arch/powerpc/kernel/cputable.c                    |    1 
 arch/powerpc/kernel/crash.c                       |    2 
 arch/powerpc/kernel/idle.c                        |    1 
 arch/powerpc/kernel/irq.c                         |    1 
 arch/powerpc/kernel/kprobes.c                     |    1 
 arch/powerpc/kernel/lparcfg.c                     |    1 
 arch/powerpc/kernel/ppc_ksyms.c                   |    2 
 arch/powerpc/kernel/process.c                     |    3 
 arch/powerpc/kernel/prom.c                        |    1 
 arch/powerpc/kernel/prom_init.c                   |    1 
 arch/powerpc/kernel/ptrace.c                      |    2 
 arch/powerpc/kernel/ptrace32.c                    |    2 
 arch/powerpc/kernel/rtas.c                        |    1 
 arch/powerpc/kernel/setup-common.c                |    1 
 arch/powerpc/kernel/setup_32.c                    |    1 
 arch/powerpc/kernel/setup_64.c                    |    1 
 arch/powerpc/kernel/signal.c                      |    1 
 arch/powerpc/kernel/signal_32.c                   |    1 
 arch/powerpc/kernel/signal_64.c                   |    1 
 arch/powerpc/kernel/smp.c                         |    2 
 arch/powerpc/kernel/softemu8xx.c                  |    1 
 arch/powerpc/kernel/swsusp.c                      |    2 
 arch/powerpc/kernel/swsusp_64.c                   |    1 
 arch/powerpc/kernel/sys_ppc32.c                   |    1 
 arch/powerpc/kernel/sysfs.c                       |    1 
 arch/powerpc/kernel/traps.c                       |    3 
 arch/powerpc/kernel/vdso.c                        |    1 
 arch/powerpc/kvm/book3s_hv.c                      |    1 
 arch/powerpc/lib/alloc.c                          |    2 
 arch/powerpc/lib/copyuser_power7_vmx.c            |    1 
 arch/powerpc/mm/44x_mmu.c                         |    1 
 arch/powerpc/mm/fault.c                           |    2 
 arch/powerpc/mm/hash_utils_64.c                   |    1 
 arch/powerpc/mm/init_32.c                         |    1 
 arch/powerpc/mm/init_64.c                         |    1 
 arch/powerpc/mm/numa.c                            |    2 
 arch/powerpc/mm/pgtable_32.c                      |    1 
 arch/powerpc/mm/pgtable_64.c                      |    1 
 arch/powerpc/oprofile/common.c                    |    1 
 arch/powerpc/oprofile/op_model_7450.c             |    1 
 arch/powerpc/oprofile/op_model_cell.c             |    1 
 arch/powerpc/oprofile/op_model_fsl_emb.c          |    1 
 arch/powerpc/oprofile/op_model_power4.c           |    1 
 arch/powerpc/oprofile/op_model_rs64.c             |    1 
 arch/powerpc/platforms/82xx/pq2.c                 |    1 
 arch/powerpc/platforms/83xx/km83xx.c              |    1 
 arch/powerpc/platforms/83xx/mpc832x_mds.c         |    1 
 arch/powerpc/platforms/83xx/mpc834x_itx.c         |    1 
 arch/powerpc/platforms/83xx/mpc834x_mds.c         |    1 
 arch/powerpc/platforms/83xx/mpc836x_mds.c         |    1 
 arch/powerpc/platforms/83xx/sbc834x.c             |    1 
 arch/powerpc/platforms/85xx/corenet_ds.c          |    1 
 arch/powerpc/platforms/85xx/ksi8560.c             |    1 
 arch/powerpc/platforms/85xx/mpc8536_ds.c          |    1 
 arch/powerpc/platforms/85xx/mpc85xx_ads.c         |    1 
 arch/powerpc/platforms/85xx/mpc85xx_cds.c         |    1 
 arch/powerpc/platforms/85xx/mpc85xx_ds.c          |    1 
 arch/powerpc/platforms/85xx/mpc85xx_mds.c         |    1 
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c         |    1 
 arch/powerpc/platforms/85xx/p1010rdb.c            |    1 
 arch/powerpc/platforms/85xx/p1023_rds.c           |    1 
 arch/powerpc/platforms/85xx/p2041_rdb.c           |    1 
 arch/powerpc/platforms/85xx/p3041_ds.c            |    1 
 arch/powerpc/platforms/85xx/p4080_ds.c            |    1 
 arch/powerpc/platforms/85xx/p5020_ds.c            |    1 
 arch/powerpc/platforms/85xx/sbc8548.c             |    1 
 arch/powerpc/platforms/85xx/sbc8560.c             |    1 
 arch/powerpc/platforms/85xx/socrates.c            |    1 
 arch/powerpc/platforms/85xx/stx_gp3.c             |    1 
 arch/powerpc/platforms/85xx/tqm85xx.c             |    1 
 arch/powerpc/platforms/85xx/xes_mpc85xx.c         |    1 
 arch/powerpc/platforms/86xx/gef_ppc9a.c           |    1 
 arch/powerpc/platforms/86xx/gef_sbc310.c          |    1 
 arch/powerpc/platforms/86xx/gef_sbc610.c          |    1 
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c        |    1 
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c        |    1 
 arch/powerpc/platforms/86xx/pic.c                 |    1 
 arch/powerpc/platforms/86xx/sbc8641d.c            |    1 
 arch/powerpc/platforms/8xx/mpc86xads_setup.c      |    1 
 arch/powerpc/platforms/8xx/mpc885ads_setup.c      |    1 
 arch/powerpc/platforms/8xx/tqm8xx_setup.c         |    1 
 arch/powerpc/platforms/cell/smp.c                 |    1 
 arch/powerpc/platforms/embedded6xx/c2k.c          |    1 
 arch/powerpc/platforms/embedded6xx/holly.c        |    1 
 arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c |    1 
 arch/powerpc/platforms/embedded6xx/prpmc2800.c    |    1 
 arch/powerpc/platforms/embedded6xx/storcenter.c   |    1 
 arch/powerpc/platforms/fsl_uli1575.c              |    1 
 arch/powerpc/platforms/iseries/dt.c               |    1 
 arch/powerpc/platforms/iseries/lpevents.c         |    1 
 arch/powerpc/platforms/iseries/setup.c            |    1 
 arch/powerpc/platforms/iseries/smp.c              |    1 
 arch/powerpc/platforms/iseries/viopath.c          |    1 
 arch/powerpc/platforms/maple/setup.c              |    1 
 arch/powerpc/platforms/maple/time.c               |    1 
 arch/powerpc/platforms/pasemi/setup.c             |    2 
 arch/powerpc/platforms/powermac/bootx_init.c      |    1 
 arch/powerpc/platforms/powermac/cpufreq_32.c      |    2 
 arch/powerpc/platforms/powermac/nvram.c           |    1 
 arch/powerpc/platforms/powermac/setup.c           |    1 
 arch/powerpc/platforms/powermac/time.c            |    1 
 arch/powerpc/platforms/powernv/smp.c              |    1 
 arch/powerpc/platforms/ps3/mm.c                   |    1 
 arch/powerpc/platforms/pseries/dtl.c              |    2 
 arch/powerpc/platforms/pseries/hotplug-cpu.c      |    1 
 arch/powerpc/platforms/pseries/processor_idle.c   |    1 
 arch/powerpc/platforms/pseries/ras.c              |    1 
 arch/powerpc/platforms/pseries/smp.c              |    1 
 arch/powerpc/platforms/wsp/chroma.c               |    1 
 arch/powerpc/platforms/wsp/psr2.c                 |    1 
 arch/powerpc/sysdev/cpm_common.c                  |    1 
 arch/powerpc/sysdev/fsl_soc.c                     |    1 
 arch/powerpc/sysdev/msi_bitmap.c                  |    1 
 arch/powerpc/sysdev/tsi108_dev.c                  |    1 
 arch/powerpc/xmon/xmon.c                          |    1 
 133 files changed, 635 insertions(+), 667 deletions(-)
 create mode 100644 arch/powerpc/include/asm/barrier.h
 create mode 100644 arch/powerpc/include/asm/cmpxchg.h
 create mode 100644 arch/powerpc/include/asm/debug.h
 create mode 100644 arch/powerpc/include/asm/exec.h
 create mode 100644 arch/powerpc/include/asm/switch_to.h

diff --git a/arch/powerpc/include/asm/atomic.h b/arch/powerpc/include/asm/atomic.h
index 02e41b5..801aaaf 100644
--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -5,13 +5,9 @@
  * PowerPC atomic operations
  */
 
-#include <linux/types.h>
-
 #ifdef __KERNEL__
-#include <linux/compiler.h>
-#include <asm/synch.h>
-#include <asm/asm-compat.h>
-#include <asm/system.h>
+#include <linux/types.h>
+#include <asm/cmpxchg.h>
 
 #define ATOMIC_INIT(i)		{ (i) }
 
diff --git a/arch/powerpc/include/asm/auxvec.h b/arch/powerpc/include/asm/auxvec.h
index 19a099b..ce17d2c 100644
--- a/arch/powerpc/include/asm/auxvec.h
+++ b/arch/powerpc/include/asm/auxvec.h
@@ -16,4 +16,6 @@
  */
 #define AT_SYSINFO_EHDR		33
 
+#define AT_VECTOR_SIZE_ARCH 6 /* entries in ARCH_DLINFO */
+
 #endif
diff --git a/arch/powerpc/include/asm/barrier.h b/arch/powerpc/include/asm/barrier.h
new file mode 100644
index 0000000..ae78225
--- /dev/null
+++ b/arch/powerpc/include/asm/barrier.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright (C) 1999 Cort Dougan <cort@cs.nmt.edu>
+ */
+#ifndef _ASM_POWERPC_BARRIER_H
+#define _ASM_POWERPC_BARRIER_H
+
+/*
+ * Memory barrier.
+ * The sync instruction guarantees that all memory accesses initiated
+ * by this processor have been performed (with respect to all other
+ * mechanisms that access memory).  The eieio instruction is a barrier
+ * providing an ordering (separately) for (a) cacheable stores and (b)
+ * loads and stores to non-cacheable memory (e.g. I/O devices).
+ *
+ * mb() prevents loads and stores being reordered across this point.
+ * rmb() prevents loads being reordered across this point.
+ * wmb() prevents stores being reordered across this point.
+ * read_barrier_depends() prevents data-dependent loads being reordered
+ *	across this point (nop on PPC).
+ *
+ * *mb() variants without smp_ prefix must order all types of memory
+ * operations with one another. sync is the only instruction sufficient
+ * to do this.
+ *
+ * For the smp_ barriers, ordering is for cacheable memory operations
+ * only. We have to use the sync instruction for smp_mb(), since lwsync
+ * doesn't order loads with respect to previous stores.  Lwsync can be
+ * used for smp_rmb() and smp_wmb().
+ *
+ * However, on CPUs that don't support lwsync, lwsync actually maps to a
+ * heavy-weight sync, so smp_wmb() can be a lighter-weight eieio.
+ */
+#define mb()   __asm__ __volatile__ ("sync" : : : "memory")
+#define rmb()  __asm__ __volatile__ ("sync" : : : "memory")
+#define wmb()  __asm__ __volatile__ ("sync" : : : "memory")
+#define read_barrier_depends()  do { } while(0)
+
+#define set_mb(var, value)	do { var = value; mb(); } while (0)
+
+#ifdef CONFIG_SMP
+
+#ifdef __SUBARCH_HAS_LWSYNC
+#    define SMPWMB      LWSYNC
+#else
+#    define SMPWMB      eieio
+#endif
+
+#define smp_mb()	mb()
+#define smp_rmb()	__asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory")
+#define smp_wmb()	__asm__ __volatile__ (stringify_in_c(SMPWMB) : : :"memory")
+#define smp_read_barrier_depends()	read_barrier_depends()
+#else
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#define smp_read_barrier_depends()	do { } while(0)
+#endif /* CONFIG_SMP */
+
+/*
+ * This is a barrier which prevents following instructions from being
+ * started until the value of the argument x is known.  For example, if
+ * x is a variable loaded from memory, this prevents following
+ * instructions from being executed until the load has been performed.
+ */
+#define data_barrier(x)	\
+	asm volatile("twi 0,%0,0; isync" : : "r" (x) : "memory");
+
+#endif /* _ASM_POWERPC_BARRIER_H */
diff --git a/arch/powerpc/include/asm/bug.h b/arch/powerpc/include/asm/bug.h
index 065c590..3eb53d7 100644
--- a/arch/powerpc/include/asm/bug.h
+++ b/arch/powerpc/include/asm/bug.h
@@ -126,5 +126,16 @@
 
 #include <asm-generic/bug.h>
 
+#ifndef __ASSEMBLY__
+
+struct pt_regs;
+extern int do_page_fault(struct pt_regs *, unsigned long, unsigned long);
+extern void bad_page_fault(struct pt_regs *, unsigned long, int);
+extern void _exception(int, struct pt_regs *, int, unsigned long);
+extern void die(const char *, struct pt_regs *, long);
+extern void print_backtrace(unsigned long *);
+
+#endif /* !__ASSEMBLY__ */
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_BUG_H */
diff --git a/arch/powerpc/include/asm/cache.h b/arch/powerpc/include/asm/cache.h
index 4b50941..9e495c9 100644
--- a/arch/powerpc/include/asm/cache.h
+++ b/arch/powerpc/include/asm/cache.h
@@ -42,8 +42,24 @@ extern struct ppc64_caches ppc64_caches;
 #endif /* __powerpc64__ && ! __ASSEMBLY__ */
 
 #if !defined(__ASSEMBLY__)
+
 #define __read_mostly __attribute__((__section__(".data..read_mostly")))
+
+#ifdef CONFIG_6xx
+extern long _get_L2CR(void);
+extern long _get_L3CR(void);
+extern void _set_L2CR(unsigned long);
+extern void _set_L3CR(unsigned long);
+#else
+#define _get_L2CR()	0L
+#define _get_L3CR()	0L
+#define _set_L2CR(val)	do { } while(0)
+#define _set_L3CR(val)	do { } while(0)
 #endif
 
+extern void cacheable_memzero(void *p, unsigned int nb);
+extern void *cacheable_memcpy(void *, const void *, unsigned int);
+
+#endif /* !__ASSEMBLY__ */
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_CACHE_H */
diff --git a/arch/powerpc/include/asm/cmpxchg.h b/arch/powerpc/include/asm/cmpxchg.h
new file mode 100644
index 0000000..e245aab
--- /dev/null
+++ b/arch/powerpc/include/asm/cmpxchg.h
@@ -0,0 +1,309 @@
+#ifndef _ASM_POWERPC_CMPXCHG_H_
+#define _ASM_POWERPC_CMPXCHG_H_
+
+#ifdef __KERNEL__
+#include <linux/compiler.h>
+#include <asm/synch.h>
+#include <asm/asm-compat.h>
+
+/*
+ * Atomic exchange
+ *
+ * Changes the memory location '*ptr' to be val and returns
+ * the previous value stored there.
+ */
+static __always_inline unsigned long
+__xchg_u32(volatile void *p, unsigned long val)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__(
+	PPC_RELEASE_BARRIER
+"1:	lwarx	%0,0,%2 \n"
+	PPC405_ERR77(0,%2)
+"	stwcx.	%3,0,%2 \n\
+	bne-	1b"
+	PPC_ACQUIRE_BARRIER
+	: "=&r" (prev), "+m" (*(volatile unsigned int *)p)
+	: "r" (p), "r" (val)
+	: "cc", "memory");
+
+	return prev;
+}
+
+/*
+ * Atomic exchange
+ *
+ * Changes the memory location '*ptr' to be val and returns
+ * the previous value stored there.
+ */
+static __always_inline unsigned long
+__xchg_u32_local(volatile void *p, unsigned long val)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__(
+"1:	lwarx	%0,0,%2 \n"
+	PPC405_ERR77(0,%2)
+"	stwcx.	%3,0,%2 \n\
+	bne-	1b"
+	: "=&r" (prev), "+m" (*(volatile unsigned int *)p)
+	: "r" (p), "r" (val)
+	: "cc", "memory");
+
+	return prev;
+}
+
+#ifdef CONFIG_PPC64
+static __always_inline unsigned long
+__xchg_u64(volatile void *p, unsigned long val)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__(
+	PPC_RELEASE_BARRIER
+"1:	ldarx	%0,0,%2 \n"
+	PPC405_ERR77(0,%2)
+"	stdcx.	%3,0,%2 \n\
+	bne-	1b"
+	PPC_ACQUIRE_BARRIER
+	: "=&r" (prev), "+m" (*(volatile unsigned long *)p)
+	: "r" (p), "r" (val)
+	: "cc", "memory");
+
+	return prev;
+}
+
+static __always_inline unsigned long
+__xchg_u64_local(volatile void *p, unsigned long val)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__(
+"1:	ldarx	%0,0,%2 \n"
+	PPC405_ERR77(0,%2)
+"	stdcx.	%3,0,%2 \n\
+	bne-	1b"
+	: "=&r" (prev), "+m" (*(volatile unsigned long *)p)
+	: "r" (p), "r" (val)
+	: "cc", "memory");
+
+	return prev;
+}
+#endif
+
+/*
+ * This function doesn't exist, so you'll get a linker error
+ * if something tries to do an invalid xchg().
+ */
+extern void __xchg_called_with_bad_pointer(void);
+
+static __always_inline unsigned long
+__xchg(volatile void *ptr, unsigned long x, unsigned int size)
+{
+	switch (size) {
+	case 4:
+		return __xchg_u32(ptr, x);
+#ifdef CONFIG_PPC64
+	case 8:
+		return __xchg_u64(ptr, x);
+#endif
+	}
+	__xchg_called_with_bad_pointer();
+	return x;
+}
+
+static __always_inline unsigned long
+__xchg_local(volatile void *ptr, unsigned long x, unsigned int size)
+{
+	switch (size) {
+	case 4:
+		return __xchg_u32_local(ptr, x);
+#ifdef CONFIG_PPC64
+	case 8:
+		return __xchg_u64_local(ptr, x);
+#endif
+	}
+	__xchg_called_with_bad_pointer();
+	return x;
+}
+#define xchg(ptr,x)							     \
+  ({									     \
+     __typeof__(*(ptr)) _x_ = (x);					     \
+     (__typeof__(*(ptr))) __xchg((ptr), (unsigned long)_x_, sizeof(*(ptr))); \
+  })
+
+#define xchg_local(ptr,x)						     \
+  ({									     \
+     __typeof__(*(ptr)) _x_ = (x);					     \
+     (__typeof__(*(ptr))) __xchg_local((ptr),				     \
+     		(unsigned long)_x_, sizeof(*(ptr))); 			     \
+  })
+
+/*
+ * Compare and exchange - if *p == old, set it to new,
+ * and return the old value of *p.
+ */
+#define __HAVE_ARCH_CMPXCHG	1
+
+static __always_inline unsigned long
+__cmpxchg_u32(volatile unsigned int *p, unsigned long old, unsigned long new)
+{
+	unsigned int prev;
+
+	__asm__ __volatile__ (
+	PPC_RELEASE_BARRIER
+"1:	lwarx	%0,0,%2		# __cmpxchg_u32\n\
+	cmpw	0,%0,%3\n\
+	bne-	2f\n"
+	PPC405_ERR77(0,%2)
+"	stwcx.	%4,0,%2\n\
+	bne-	1b"
+	PPC_ACQUIRE_BARRIER
+	"\n\
+2:"
+	: "=&r" (prev), "+m" (*p)
+	: "r" (p), "r" (old), "r" (new)
+	: "cc", "memory");
+
+	return prev;
+}
+
+static __always_inline unsigned long
+__cmpxchg_u32_local(volatile unsigned int *p, unsigned long old,
+			unsigned long new)
+{
+	unsigned int prev;
+
+	__asm__ __volatile__ (
+"1:	lwarx	%0,0,%2		# __cmpxchg_u32\n\
+	cmpw	0,%0,%3\n\
+	bne-	2f\n"
+	PPC405_ERR77(0,%2)
+"	stwcx.	%4,0,%2\n\
+	bne-	1b"
+	"\n\
+2:"
+	: "=&r" (prev), "+m" (*p)
+	: "r" (p), "r" (old), "r" (new)
+	: "cc", "memory");
+
+	return prev;
+}
+
+#ifdef CONFIG_PPC64
+static __always_inline unsigned long
+__cmpxchg_u64(volatile unsigned long *p, unsigned long old, unsigned long new)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__ (
+	PPC_RELEASE_BARRIER
+"1:	ldarx	%0,0,%2		# __cmpxchg_u64\n\
+	cmpd	0,%0,%3\n\
+	bne-	2f\n\
+	stdcx.	%4,0,%2\n\
+	bne-	1b"
+	PPC_ACQUIRE_BARRIER
+	"\n\
+2:"
+	: "=&r" (prev), "+m" (*p)
+	: "r" (p), "r" (old), "r" (new)
+	: "cc", "memory");
+
+	return prev;
+}
+
+static __always_inline unsigned long
+__cmpxchg_u64_local(volatile unsigned long *p, unsigned long old,
+			unsigned long new)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__ (
+"1:	ldarx	%0,0,%2		# __cmpxchg_u64\n\
+	cmpd	0,%0,%3\n\
+	bne-	2f\n\
+	stdcx.	%4,0,%2\n\
+	bne-	1b"
+	"\n\
+2:"
+	: "=&r" (prev), "+m" (*p)
+	: "r" (p), "r" (old), "r" (new)
+	: "cc", "memory");
+
+	return prev;
+}
+#endif
+
+/* This function doesn't exist, so you'll get a linker error
+   if something tries to do an invalid cmpxchg().  */
+extern void __cmpxchg_called_with_bad_pointer(void);
+
+static __always_inline unsigned long
+__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new,
+	  unsigned int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_u32(ptr, old, new);
+#ifdef CONFIG_PPC64
+	case 8:
+		return __cmpxchg_u64(ptr, old, new);
+#endif
+	}
+	__cmpxchg_called_with_bad_pointer();
+	return old;
+}
+
+static __always_inline unsigned long
+__cmpxchg_local(volatile void *ptr, unsigned long old, unsigned long new,
+	  unsigned int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_u32_local(ptr, old, new);
+#ifdef CONFIG_PPC64
+	case 8:
+		return __cmpxchg_u64_local(ptr, old, new);
+#endif
+	}
+	__cmpxchg_called_with_bad_pointer();
+	return old;
+}
+
+#define cmpxchg(ptr, o, n)						 \
+  ({									 \
+     __typeof__(*(ptr)) _o_ = (o);					 \
+     __typeof__(*(ptr)) _n_ = (n);					 \
+     (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		 \
+				    (unsigned long)_n_, sizeof(*(ptr))); \
+  })
+
+
+#define cmpxchg_local(ptr, o, n)					 \
+  ({									 \
+     __typeof__(*(ptr)) _o_ = (o);					 \
+     __typeof__(*(ptr)) _n_ = (n);					 \
+     (__typeof__(*(ptr))) __cmpxchg_local((ptr), (unsigned long)_o_,	 \
+				    (unsigned long)_n_, sizeof(*(ptr))); \
+  })
+
+#ifdef CONFIG_PPC64
+#define cmpxchg64(ptr, o, n)						\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg((ptr), (o), (n));					\
+  })
+#define cmpxchg64_local(ptr, o, n)					\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg_local((ptr), (o), (n));					\
+  })
+#else
+#include <asm-generic/cmpxchg-local.h>
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+#endif
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_POWERPC_CMPXCHG_H_ */
diff --git a/arch/powerpc/include/asm/debug.h b/arch/powerpc/include/asm/debug.h
new file mode 100644
index 0000000..716d2f0
--- /dev/null
+++ b/arch/powerpc/include/asm/debug.h
@@ -0,0 +1,56 @@
+/*
+ * Copyright (C) 1999 Cort Dougan <cort@cs.nmt.edu>
+ */
+#ifndef _ASM_POWERPC_DEBUG_H
+#define _ASM_POWERPC_DEBUG_H
+
+struct pt_regs;
+
+extern struct dentry *powerpc_debugfs_root;
+
+#if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
+
+extern int (*__debugger)(struct pt_regs *regs);
+extern int (*__debugger_ipi)(struct pt_regs *regs);
+extern int (*__debugger_bpt)(struct pt_regs *regs);
+extern int (*__debugger_sstep)(struct pt_regs *regs);
+extern int (*__debugger_iabr_match)(struct pt_regs *regs);
+extern int (*__debugger_dabr_match)(struct pt_regs *regs);
+extern int (*__debugger_fault_handler)(struct pt_regs *regs);
+
+#define DEBUGGER_BOILERPLATE(__NAME) \
+static inline int __NAME(struct pt_regs *regs) \
+{ \
+	if (unlikely(__ ## __NAME)) \
+		return __ ## __NAME(regs); \
+	return 0; \
+}
+
+DEBUGGER_BOILERPLATE(debugger)
+DEBUGGER_BOILERPLATE(debugger_ipi)
+DEBUGGER_BOILERPLATE(debugger_bpt)
+DEBUGGER_BOILERPLATE(debugger_sstep)
+DEBUGGER_BOILERPLATE(debugger_iabr_match)
+DEBUGGER_BOILERPLATE(debugger_dabr_match)
+DEBUGGER_BOILERPLATE(debugger_fault_handler)
+
+#else
+static inline int debugger(struct pt_regs *regs) { return 0; }
+static inline int debugger_ipi(struct pt_regs *regs) { return 0; }
+static inline int debugger_bpt(struct pt_regs *regs) { return 0; }
+static inline int debugger_sstep(struct pt_regs *regs) { return 0; }
+static inline int debugger_iabr_match(struct pt_regs *regs) { return 0; }
+static inline int debugger_dabr_match(struct pt_regs *regs) { return 0; }
+static inline int debugger_fault_handler(struct pt_regs *regs) { return 0; }
+#endif
+
+extern int set_dabr(unsigned long dabr);
+#ifdef CONFIG_PPC_ADV_DEBUG_REGS
+extern void do_send_trap(struct pt_regs *regs, unsigned long address,
+			 unsigned long error_code, int signal_code, int brkpt);
+#else
+extern void do_dabr(struct pt_regs *regs, unsigned long address,
+		    unsigned long error_code);
+#endif
+
+#endif /* _ASM_POWERPC_DEBUG_H */
diff --git a/arch/powerpc/include/asm/dma.h b/arch/powerpc/include/asm/dma.h
index a7e06e2..2f3511a 100644
--- a/arch/powerpc/include/asm/dma.h
+++ b/arch/powerpc/include/asm/dma.h
@@ -24,7 +24,6 @@
 
 #include <asm/io.h>
 #include <linux/spinlock.h>
-#include <asm/system.h>
 
 #ifndef MAX_DMA_CHANNELS
 #define MAX_DMA_CHANNELS	8
diff --git a/arch/powerpc/include/asm/exec.h b/arch/powerpc/include/asm/exec.h
new file mode 100644
index 0000000..8196e9c
--- /dev/null
+++ b/arch/powerpc/include/asm/exec.h
@@ -0,0 +1,9 @@
+/*
+ * Copyright (C) 1999 Cort Dougan <cort@cs.nmt.edu>
+ */
+#ifndef _ASM_POWERPC_EXEC_H
+#define _ASM_POWERPC_EXEC_H
+
+extern unsigned long arch_align_stack(unsigned long sp);
+
+#endif /* _ASM_POWERPC_EXEC_H */
diff --git a/arch/powerpc/include/asm/hw_breakpoint.h b/arch/powerpc/include/asm/hw_breakpoint.h
index 80fd4d2..be04330 100644
--- a/arch/powerpc/include/asm/hw_breakpoint.h
+++ b/arch/powerpc/include/asm/hw_breakpoint.h
@@ -35,7 +35,7 @@ struct arch_hw_breakpoint {
 
 #include <linux/kdebug.h>
 #include <asm/reg.h>
-#include <asm/system.h>
+#include <asm/debug.h>
 
 struct perf_event;
 struct pmu;
diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
index c0e1bc3..034c5ca 100644
--- a/arch/powerpc/include/asm/irq.h
+++ b/arch/powerpc/include/asm/irq.h
@@ -68,6 +68,7 @@ typedef unsigned long irq_hw_number_t;
  */
 struct irq_host;
 struct radix_tree_root;
+struct device_node;
 
 /* Functions below are provided by the host and called whenever a new mapping
  * is created or an old mapping is disposed. The host can then proceed to
diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index b585bff..8e2d037 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -385,6 +385,36 @@ static inline unsigned long get_clean_sp(struct pt_regs *regs, int is_32)
 extern unsigned long cpuidle_disable;
 enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_POWERSAVE_OFF};
 
+extern int powersave_nap;	/* set if nap mode can be used in idle loop */
+void cpu_idle_wait(void);
+
+#ifdef CONFIG_PSERIES_IDLE
+extern void update_smt_snooze_delay(int snooze);
+extern int pseries_notify_cpuidle_add_cpu(int cpu);
+#else
+static inline void update_smt_snooze_delay(int snooze) {}
+static inline int pseries_notify_cpuidle_add_cpu(int cpu) { return 0; }
+#endif
+
+extern void flush_instruction_cache(void);
+extern void hard_reset_now(void);
+extern void poweroff_now(void);
+extern int fix_alignment(struct pt_regs *);
+extern void cvt_fd(float *from, double *to);
+extern void cvt_df(double *from, float *to);
+extern void _nmask_and_or_msr(unsigned long nmask, unsigned long or_val);
+
+#ifdef CONFIG_PPC64
+/*
+ * We handle most unaligned accesses in hardware. On the other hand 
+ * unaligned DMA can be very expensive on some ppc64 IO chips (it does
+ * powers of 2 writes until it reaches sufficient alignment).
+ *
+ * Based on this we disable the IP header alignment in network drivers.
+ */
+#define NET_IP_ALIGN	0
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_POWERPC_PROCESSOR_H */
diff --git a/arch/powerpc/include/asm/reg_booke.h b/arch/powerpc/include/asm/reg_booke.h
index 500fe1d..0e94450 100644
--- a/arch/powerpc/include/asm/reg_booke.h
+++ b/arch/powerpc/include/asm/reg_booke.h
@@ -15,6 +15,11 @@
 #ifndef __ASM_POWERPC_REG_BOOKE_H__
 #define __ASM_POWERPC_REG_BOOKE_H__
 
+#ifdef CONFIG_BOOKE_WDT
+extern u32 booke_wdt_enabled;
+extern u32 booke_wdt_period;
+#endif /* CONFIG_BOOKE_WDT */
+
 /* Machine State Register (MSR) Fields */
 #define MSR_GS		(1<<28) /* Guest state */
 #define MSR_UCLE	(1<<26)	/* User-mode cache lock enable */
diff --git a/arch/powerpc/include/asm/rtas.h b/arch/powerpc/include/asm/rtas.h
index 01c143b..9d6c37a 100644
--- a/arch/powerpc/include/asm/rtas.h
+++ b/arch/powerpc/include/asm/rtas.h
@@ -325,5 +325,7 @@ static inline int page_is_rtas_user_buf(unsigned long pfn)
 static inline int page_is_rtas_user_buf(unsigned long pfn) { return 0;}
 #endif
 
+extern int call_rtas(const char *, int, int, unsigned long *, ...);
+
 #endif /* __KERNEL__ */
 #endif /* _POWERPC_RTAS_H */
diff --git a/arch/powerpc/include/asm/setup.h b/arch/powerpc/include/asm/setup.h
index 186e0fb..d084ce1 100644
--- a/arch/powerpc/include/asm/setup.h
+++ b/arch/powerpc/include/asm/setup.h
@@ -5,6 +5,28 @@
 
 #ifndef __ASSEMBLY__
 extern void ppc_printk_progress(char *s, unsigned short hex);
-#endif
+
+extern unsigned int rtas_data;
+extern int mem_init_done;	/* set on boot once kmalloc can be called */
+extern int init_bootmem_done;	/* set once bootmem is available */
+extern phys_addr_t memory_limit;
+extern unsigned long klimit;
+extern void *zalloc_maybe_bootmem(size_t size, gfp_t mask);
+
+extern void via_cuda_init(void);
+extern void read_rtc_time(void);
+extern void pmac_find_display(void);
+
+struct device_node;
+extern void note_scsi_host(struct device_node *, void *);
+
+/* Used in very early kernel initialization. */
+extern unsigned long reloc_offset(void);
+extern unsigned long add_reloc_offset(unsigned long);
+extern void reloc_got2(unsigned long);
+
+#define PTRRELOC(x)	((typeof(x)) add_reloc_offset((unsigned long)(x)))
+
+#endif /* !__ASSEMBLY__ */
 
 #endif	/* _ASM_POWERPC_SETUP_H */
diff --git a/arch/powerpc/include/asm/switch_to.h b/arch/powerpc/include/asm/switch_to.h
new file mode 100644
index 0000000..caf82d0
--- /dev/null
+++ b/arch/powerpc/include/asm/switch_to.h
@@ -0,0 +1,65 @@
+/*
+ * Copyright (C) 1999 Cort Dougan <cort@cs.nmt.edu>
+ */
+#ifndef _ASM_POWERPC_SWITCH_TO_H
+#define _ASM_POWERPC_SWITCH_TO_H
+
+struct thread_struct;
+struct task_struct;
+struct pt_regs;
+
+extern struct task_struct *__switch_to(struct task_struct *,
+	struct task_struct *);
+#define switch_to(prev, next, last)	((last) = __switch_to((prev), (next)))
+
+struct thread_struct;
+extern struct task_struct *_switch(struct thread_struct *prev,
+				   struct thread_struct *next);
+
+extern void giveup_fpu(struct task_struct *);
+extern void disable_kernel_fp(void);
+extern void enable_kernel_fp(void);
+extern void flush_fp_to_thread(struct task_struct *);
+extern void enable_kernel_altivec(void);
+extern void giveup_altivec(struct task_struct *);
+extern void load_up_altivec(struct task_struct *);
+extern int emulate_altivec(struct pt_regs *);
+extern void __giveup_vsx(struct task_struct *);
+extern void giveup_vsx(struct task_struct *);
+extern void enable_kernel_spe(void);
+extern void giveup_spe(struct task_struct *);
+extern void load_up_spe(struct task_struct *);
+
+#ifndef CONFIG_SMP
+extern void discard_lazy_cpu_state(void);
+#else
+static inline void discard_lazy_cpu_state(void)
+{
+}
+#endif
+
+#ifdef CONFIG_ALTIVEC
+extern void flush_altivec_to_thread(struct task_struct *);
+#else
+static inline void flush_altivec_to_thread(struct task_struct *t)
+{
+}
+#endif
+
+#ifdef CONFIG_VSX
+extern void flush_vsx_to_thread(struct task_struct *);
+#else
+static inline void flush_vsx_to_thread(struct task_struct *t)
+{
+}
+#endif
+
+#ifdef CONFIG_SPE
+extern void flush_spe_to_thread(struct task_struct *);
+#else
+static inline void flush_spe_to_thread(struct task_struct *t)
+{
+}
+#endif
+
+#endif /* _ASM_POWERPC_SWITCH_TO_H */
diff --git a/arch/powerpc/include/asm/system.h b/arch/powerpc/include/asm/system.h
index c377457..502c1e0 100644
--- a/arch/powerpc/include/asm/system.h
+++ b/arch/powerpc/include/asm/system.h
@@ -1,554 +1,6 @@
-/*
- * Copyright (C) 1999 Cort Dougan <cort@cs.nmt.edu>
- */
-#ifndef _ASM_POWERPC_SYSTEM_H
-#define _ASM_POWERPC_SYSTEM_H
-
-#include <linux/kernel.h>
-#include <linux/irqflags.h>
-
-#include <asm/hw_irq.h>
-
-/*
- * Memory barrier.
- * The sync instruction guarantees that all memory accesses initiated
- * by this processor have been performed (with respect to all other
- * mechanisms that access memory).  The eieio instruction is a barrier
- * providing an ordering (separately) for (a) cacheable stores and (b)
- * loads and stores to non-cacheable memory (e.g. I/O devices).
- *
- * mb() prevents loads and stores being reordered across this point.
- * rmb() prevents loads being reordered across this point.
- * wmb() prevents stores being reordered across this point.
- * read_barrier_depends() prevents data-dependent loads being reordered
- *	across this point (nop on PPC).
- *
- * *mb() variants without smp_ prefix must order all types of memory
- * operations with one another. sync is the only instruction sufficient
- * to do this.
- *
- * For the smp_ barriers, ordering is for cacheable memory operations
- * only. We have to use the sync instruction for smp_mb(), since lwsync
- * doesn't order loads with respect to previous stores.  Lwsync can be
- * used for smp_rmb() and smp_wmb().
- *
- * However, on CPUs that don't support lwsync, lwsync actually maps to a
- * heavy-weight sync, so smp_wmb() can be a lighter-weight eieio.
- */
-#define mb()   __asm__ __volatile__ ("sync" : : : "memory")
-#define rmb()  __asm__ __volatile__ ("sync" : : : "memory")
-#define wmb()  __asm__ __volatile__ ("sync" : : : "memory")
-#define read_barrier_depends()  do { } while(0)
-
-#define set_mb(var, value)	do { var = value; mb(); } while (0)
-
-#ifdef __KERNEL__
-#define AT_VECTOR_SIZE_ARCH 6 /* entries in ARCH_DLINFO */
-#ifdef CONFIG_SMP
-
-#ifdef __SUBARCH_HAS_LWSYNC
-#    define SMPWMB      LWSYNC
-#else
-#    define SMPWMB      eieio
-#endif
-
-#define smp_mb()	mb()
-#define smp_rmb()	__asm__ __volatile__ (stringify_in_c(LWSYNC) : : :"memory")
-#define smp_wmb()	__asm__ __volatile__ (stringify_in_c(SMPWMB) : : :"memory")
-#define smp_read_barrier_depends()	read_barrier_depends()
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do { } while(0)
-#endif /* CONFIG_SMP */
-
-/*
- * This is a barrier which prevents following instructions from being
- * started until the value of the argument x is known.  For example, if
- * x is a variable loaded from memory, this prevents following
- * instructions from being executed until the load has been performed.
- */
-#define data_barrier(x)	\
-	asm volatile("twi 0,%0,0; isync" : : "r" (x) : "memory");
-
-struct task_struct;
-struct pt_regs;
-
-#if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
-
-extern int (*__debugger)(struct pt_regs *regs);
-extern int (*__debugger_ipi)(struct pt_regs *regs);
-extern int (*__debugger_bpt)(struct pt_regs *regs);
-extern int (*__debugger_sstep)(struct pt_regs *regs);
-extern int (*__debugger_iabr_match)(struct pt_regs *regs);
-extern int (*__debugger_dabr_match)(struct pt_regs *regs);
-extern int (*__debugger_fault_handler)(struct pt_regs *regs);
-
-#define DEBUGGER_BOILERPLATE(__NAME) \
-static inline int __NAME(struct pt_regs *regs) \
-{ \
-	if (unlikely(__ ## __NAME)) \
-		return __ ## __NAME(regs); \
-	return 0; \
-}
-
-DEBUGGER_BOILERPLATE(debugger)
-DEBUGGER_BOILERPLATE(debugger_ipi)
-DEBUGGER_BOILERPLATE(debugger_bpt)
-DEBUGGER_BOILERPLATE(debugger_sstep)
-DEBUGGER_BOILERPLATE(debugger_iabr_match)
-DEBUGGER_BOILERPLATE(debugger_dabr_match)
-DEBUGGER_BOILERPLATE(debugger_fault_handler)
-
-#else
-static inline int debugger(struct pt_regs *regs) { return 0; }
-static inline int debugger_ipi(struct pt_regs *regs) { return 0; }
-static inline int debugger_bpt(struct pt_regs *regs) { return 0; }
-static inline int debugger_sstep(struct pt_regs *regs) { return 0; }
-static inline int debugger_iabr_match(struct pt_regs *regs) { return 0; }
-static inline int debugger_dabr_match(struct pt_regs *regs) { return 0; }
-static inline int debugger_fault_handler(struct pt_regs *regs) { return 0; }
-#endif
-
-extern int set_dabr(unsigned long dabr);
-#ifdef CONFIG_PPC_ADV_DEBUG_REGS
-extern void do_send_trap(struct pt_regs *regs, unsigned long address,
-			 unsigned long error_code, int signal_code, int brkpt);
-#else
-extern void do_dabr(struct pt_regs *regs, unsigned long address,
-		    unsigned long error_code);
-#endif
-extern void print_backtrace(unsigned long *);
-extern void flush_instruction_cache(void);
-extern void hard_reset_now(void);
-extern void poweroff_now(void);
-
-#ifdef CONFIG_6xx
-extern long _get_L2CR(void);
-extern long _get_L3CR(void);
-extern void _set_L2CR(unsigned long);
-extern void _set_L3CR(unsigned long);
-#else
-#define _get_L2CR()	0L
-#define _get_L3CR()	0L
-#define _set_L2CR(val)	do { } while(0)
-#define _set_L3CR(val)	do { } while(0)
-#endif
-
-extern void via_cuda_init(void);
-extern void read_rtc_time(void);
-extern void pmac_find_display(void);
-extern void giveup_fpu(struct task_struct *);
-extern void disable_kernel_fp(void);
-extern void enable_kernel_fp(void);
-extern void flush_fp_to_thread(struct task_struct *);
-extern void enable_kernel_altivec(void);
-extern void giveup_altivec(struct task_struct *);
-extern void load_up_altivec(struct task_struct *);
-extern int emulate_altivec(struct pt_regs *);
-extern void __giveup_vsx(struct task_struct *);
-extern void giveup_vsx(struct task_struct *);
-extern void enable_kernel_spe(void);
-extern void giveup_spe(struct task_struct *);
-extern void load_up_spe(struct task_struct *);
-extern int fix_alignment(struct pt_regs *);
-extern void cvt_fd(float *from, double *to);
-extern void cvt_df(double *from, float *to);
-
-#ifndef CONFIG_SMP
-extern void discard_lazy_cpu_state(void);
-#else
-static inline void discard_lazy_cpu_state(void)
-{
-}
-#endif
-
-#ifdef CONFIG_ALTIVEC
-extern void flush_altivec_to_thread(struct task_struct *);
-#else
-static inline void flush_altivec_to_thread(struct task_struct *t)
-{
-}
-#endif
-
-#ifdef CONFIG_VSX
-extern void flush_vsx_to_thread(struct task_struct *);
-#else
-static inline void flush_vsx_to_thread(struct task_struct *t)
-{
-}
-#endif
-
-#ifdef CONFIG_SPE
-extern void flush_spe_to_thread(struct task_struct *);
-#else
-static inline void flush_spe_to_thread(struct task_struct *t)
-{
-}
-#endif
-
-extern int call_rtas(const char *, int, int, unsigned long *, ...);
-extern void cacheable_memzero(void *p, unsigned int nb);
-extern void *cacheable_memcpy(void *, const void *, unsigned int);
-extern int do_page_fault(struct pt_regs *, unsigned long, unsigned long);
-extern void bad_page_fault(struct pt_regs *, unsigned long, int);
-extern void _exception(int, struct pt_regs *, int, unsigned long);
-extern void die(const char *, struct pt_regs *, long);
-extern void _nmask_and_or_msr(unsigned long nmask, unsigned long or_val);
-
-#ifdef CONFIG_BOOKE_WDT
-extern u32 booke_wdt_enabled;
-extern u32 booke_wdt_period;
-#endif /* CONFIG_BOOKE_WDT */
-
-struct device_node;
-extern void note_scsi_host(struct device_node *, void *);
-
-extern struct task_struct *__switch_to(struct task_struct *,
-	struct task_struct *);
-#define switch_to(prev, next, last)	((last) = __switch_to((prev), (next)))
-
-struct thread_struct;
-extern struct task_struct *_switch(struct thread_struct *prev,
-				   struct thread_struct *next);
-
-extern unsigned int rtas_data;
-extern int mem_init_done;	/* set on boot once kmalloc can be called */
-extern int init_bootmem_done;	/* set once bootmem is available */
-extern phys_addr_t memory_limit;
-extern unsigned long klimit;
-extern void *zalloc_maybe_bootmem(size_t size, gfp_t mask);
-
-extern int powersave_nap;	/* set if nap mode can be used in idle loop */
-void cpu_idle_wait(void);
-
-#ifdef CONFIG_PSERIES_IDLE
-extern void update_smt_snooze_delay(int snooze);
-extern int pseries_notify_cpuidle_add_cpu(int cpu);
-#else
-static inline void update_smt_snooze_delay(int snooze) {}
-static inline int pseries_notify_cpuidle_add_cpu(int cpu) { return 0; }
-#endif
-
-/*
- * Atomic exchange
- *
- * Changes the memory location '*ptr' to be val and returns
- * the previous value stored there.
- */
-static __always_inline unsigned long
-__xchg_u32(volatile void *p, unsigned long val)
-{
-	unsigned long prev;
-
-	__asm__ __volatile__(
-	PPC_RELEASE_BARRIER
-"1:	lwarx	%0,0,%2 \n"
-	PPC405_ERR77(0,%2)
-"	stwcx.	%3,0,%2 \n\
-	bne-	1b"
-	PPC_ACQUIRE_BARRIER
-	: "=&r" (prev), "+m" (*(volatile unsigned int *)p)
-	: "r" (p), "r" (val)
-	: "cc", "memory");
-
-	return prev;
-}
-
-/*
- * Atomic exchange
- *
- * Changes the memory location '*ptr' to be val and returns
- * the previous value stored there.
- */
-static __always_inline unsigned long
-__xchg_u32_local(volatile void *p, unsigned long val)
-{
-	unsigned long prev;
-
-	__asm__ __volatile__(
-"1:	lwarx	%0,0,%2 \n"
-	PPC405_ERR77(0,%2)
-"	stwcx.	%3,0,%2 \n\
-	bne-	1b"
-	: "=&r" (prev), "+m" (*(volatile unsigned int *)p)
-	: "r" (p), "r" (val)
-	: "cc", "memory");
-
-	return prev;
-}
-
-#ifdef CONFIG_PPC64
-static __always_inline unsigned long
-__xchg_u64(volatile void *p, unsigned long val)
-{
-	unsigned long prev;
-
-	__asm__ __volatile__(
-	PPC_RELEASE_BARRIER
-"1:	ldarx	%0,0,%2 \n"
-	PPC405_ERR77(0,%2)
-"	stdcx.	%3,0,%2 \n\
-	bne-	1b"
-	PPC_ACQUIRE_BARRIER
-	: "=&r" (prev), "+m" (*(volatile unsigned long *)p)
-	: "r" (p), "r" (val)
-	: "cc", "memory");
-
-	return prev;
-}
-
-static __always_inline unsigned long
-__xchg_u64_local(volatile void *p, unsigned long val)
-{
-	unsigned long prev;
-
-	__asm__ __volatile__(
-"1:	ldarx	%0,0,%2 \n"
-	PPC405_ERR77(0,%2)
-"	stdcx.	%3,0,%2 \n\
-	bne-	1b"
-	: "=&r" (prev), "+m" (*(volatile unsigned long *)p)
-	: "r" (p), "r" (val)
-	: "cc", "memory");
-
-	return prev;
-}
-#endif
-
-/*
- * This function doesn't exist, so you'll get a linker error
- * if something tries to do an invalid xchg().
- */
-extern void __xchg_called_with_bad_pointer(void);
-
-static __always_inline unsigned long
-__xchg(volatile void *ptr, unsigned long x, unsigned int size)
-{
-	switch (size) {
-	case 4:
-		return __xchg_u32(ptr, x);
-#ifdef CONFIG_PPC64
-	case 8:
-		return __xchg_u64(ptr, x);
-#endif
-	}
-	__xchg_called_with_bad_pointer();
-	return x;
-}
-
-static __always_inline unsigned long
-__xchg_local(volatile void *ptr, unsigned long x, unsigned int size)
-{
-	switch (size) {
-	case 4:
-		return __xchg_u32_local(ptr, x);
-#ifdef CONFIG_PPC64
-	case 8:
-		return __xchg_u64_local(ptr, x);
-#endif
-	}
-	__xchg_called_with_bad_pointer();
-	return x;
-}
-#define xchg(ptr,x)							     \
-  ({									     \
-     __typeof__(*(ptr)) _x_ = (x);					     \
-     (__typeof__(*(ptr))) __xchg((ptr), (unsigned long)_x_, sizeof(*(ptr))); \
-  })
-
-#define xchg_local(ptr,x)						     \
-  ({									     \
-     __typeof__(*(ptr)) _x_ = (x);					     \
-     (__typeof__(*(ptr))) __xchg_local((ptr),				     \
-     		(unsigned long)_x_, sizeof(*(ptr))); 			     \
-  })
-
-/*
- * Compare and exchange - if *p == old, set it to new,
- * and return the old value of *p.
- */
-#define __HAVE_ARCH_CMPXCHG	1
-
-static __always_inline unsigned long
-__cmpxchg_u32(volatile unsigned int *p, unsigned long old, unsigned long new)
-{
-	unsigned int prev;
-
-	__asm__ __volatile__ (
-	PPC_RELEASE_BARRIER
-"1:	lwarx	%0,0,%2		# __cmpxchg_u32\n\
-	cmpw	0,%0,%3\n\
-	bne-	2f\n"
-	PPC405_ERR77(0,%2)
-"	stwcx.	%4,0,%2\n\
-	bne-	1b"
-	PPC_ACQUIRE_BARRIER
-	"\n\
-2:"
-	: "=&r" (prev), "+m" (*p)
-	: "r" (p), "r" (old), "r" (new)
-	: "cc", "memory");
-
-	return prev;
-}
-
-static __always_inline unsigned long
-__cmpxchg_u32_local(volatile unsigned int *p, unsigned long old,
-			unsigned long new)
-{
-	unsigned int prev;
-
-	__asm__ __volatile__ (
-"1:	lwarx	%0,0,%2		# __cmpxchg_u32\n\
-	cmpw	0,%0,%3\n\
-	bne-	2f\n"
-	PPC405_ERR77(0,%2)
-"	stwcx.	%4,0,%2\n\
-	bne-	1b"
-	"\n\
-2:"
-	: "=&r" (prev), "+m" (*p)
-	: "r" (p), "r" (old), "r" (new)
-	: "cc", "memory");
-
-	return prev;
-}
-
-#ifdef CONFIG_PPC64
-static __always_inline unsigned long
-__cmpxchg_u64(volatile unsigned long *p, unsigned long old, unsigned long new)
-{
-	unsigned long prev;
-
-	__asm__ __volatile__ (
-	PPC_RELEASE_BARRIER
-"1:	ldarx	%0,0,%2		# __cmpxchg_u64\n\
-	cmpd	0,%0,%3\n\
-	bne-	2f\n\
-	stdcx.	%4,0,%2\n\
-	bne-	1b"
-	PPC_ACQUIRE_BARRIER
-	"\n\
-2:"
-	: "=&r" (prev), "+m" (*p)
-	: "r" (p), "r" (old), "r" (new)
-	: "cc", "memory");
-
-	return prev;
-}
-
-static __always_inline unsigned long
-__cmpxchg_u64_local(volatile unsigned long *p, unsigned long old,
-			unsigned long new)
-{
-	unsigned long prev;
-
-	__asm__ __volatile__ (
-"1:	ldarx	%0,0,%2		# __cmpxchg_u64\n\
-	cmpd	0,%0,%3\n\
-	bne-	2f\n\
-	stdcx.	%4,0,%2\n\
-	bne-	1b"
-	"\n\
-2:"
-	: "=&r" (prev), "+m" (*p)
-	: "r" (p), "r" (old), "r" (new)
-	: "cc", "memory");
-
-	return prev;
-}
-#endif
-
-/* This function doesn't exist, so you'll get a linker error
-   if something tries to do an invalid cmpxchg().  */
-extern void __cmpxchg_called_with_bad_pointer(void);
-
-static __always_inline unsigned long
-__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new,
-	  unsigned int size)
-{
-	switch (size) {
-	case 4:
-		return __cmpxchg_u32(ptr, old, new);
-#ifdef CONFIG_PPC64
-	case 8:
-		return __cmpxchg_u64(ptr, old, new);
-#endif
-	}
-	__cmpxchg_called_with_bad_pointer();
-	return old;
-}
-
-static __always_inline unsigned long
-__cmpxchg_local(volatile void *ptr, unsigned long old, unsigned long new,
-	  unsigned int size)
-{
-	switch (size) {
-	case 4:
-		return __cmpxchg_u32_local(ptr, old, new);
-#ifdef CONFIG_PPC64
-	case 8:
-		return __cmpxchg_u64_local(ptr, old, new);
-#endif
-	}
-	__cmpxchg_called_with_bad_pointer();
-	return old;
-}
-
-#define cmpxchg(ptr, o, n)						 \
-  ({									 \
-     __typeof__(*(ptr)) _o_ = (o);					 \
-     __typeof__(*(ptr)) _n_ = (n);					 \
-     (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		 \
-				    (unsigned long)_n_, sizeof(*(ptr))); \
-  })
-
-
-#define cmpxchg_local(ptr, o, n)					 \
-  ({									 \
-     __typeof__(*(ptr)) _o_ = (o);					 \
-     __typeof__(*(ptr)) _n_ = (n);					 \
-     (__typeof__(*(ptr))) __cmpxchg_local((ptr), (unsigned long)_o_,	 \
-				    (unsigned long)_n_, sizeof(*(ptr))); \
-  })
-
-#ifdef CONFIG_PPC64
-/*
- * We handle most unaligned accesses in hardware. On the other hand 
- * unaligned DMA can be very expensive on some ppc64 IO chips (it does
- * powers of 2 writes until it reaches sufficient alignment).
- *
- * Based on this we disable the IP header alignment in network drivers.
- */
-#define NET_IP_ALIGN	0
-
-#define cmpxchg64(ptr, o, n)						\
-  ({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
-	cmpxchg((ptr), (o), (n));					\
-  })
-#define cmpxchg64_local(ptr, o, n)					\
-  ({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
-	cmpxchg_local((ptr), (o), (n));					\
-  })
-#else
-#include <asm-generic/cmpxchg-local.h>
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-#endif
-
-extern unsigned long arch_align_stack(unsigned long sp);
-
-/* Used in very early kernel initialization. */
-extern unsigned long reloc_offset(void);
-extern unsigned long add_reloc_offset(unsigned long);
-extern void reloc_got2(unsigned long);
-
-#define PTRRELOC(x)	((typeof(x)) add_reloc_offset((unsigned long)(x)))
-
-extern struct dentry *powerpc_debugfs_root;
-
-#endif /* __KERNEL__ */
-#endif /* _ASM_POWERPC_SYSTEM_H */
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+#include <asm/debug.h>
+#include <asm/exec.h>
+#include <asm/switch_to.h>
diff --git a/arch/powerpc/kernel/align.c b/arch/powerpc/kernel/align.c
index 8184ee9..ee5b690 100644
--- a/arch/powerpc/kernel/align.c
+++ b/arch/powerpc/kernel/align.c
@@ -21,10 +21,10 @@
 #include <linux/mm.h>
 #include <asm/processor.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/cache.h>
 #include <asm/cputable.h>
 #include <asm/emulated_ops.h>
+#include <asm/switch_to.h>
 
 struct aligninfo {
 	unsigned char len;
diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index 81db9e2..ff381f4 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -20,6 +20,7 @@
 #include <asm/cputable.h>
 #include <asm/prom.h>		/* for PTRRELOC on ARCH=ppc */
 #include <asm/mmu.h>
+#include <asm/setup.h>
 
 struct cpu_spec* cur_cpu_spec = NULL;
 EXPORT_SYMBOL(cur_cpu_spec);
diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index abef751..fdcd8f5 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -27,8 +27,8 @@
 #include <asm/kdump.h>
 #include <asm/prom.h>
 #include <asm/smp.h>
-#include <asm/system.h>
 #include <asm/setjmp.h>
+#include <asm/debug.h>
 
 /*
  * The primary CPU waits a while for all secondary CPUs to enter. This is to
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 0a48bf5..b84d0a4 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -26,7 +26,6 @@
 #include <linux/sysctl.h>
 #include <linux/tick.h>
 
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/cputable.h>
 #include <asm/time.h>
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 01e2877..422d87c 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -57,7 +57,6 @@
 #include <linux/of_irq.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/irq.h>
diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
index bc47352..e88c643 100644
--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -35,7 +35,6 @@
 #include <asm/cacheflush.h>
 #include <asm/sstep.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_PPC_ADV_DEBUG_REGS
 #define MSR_SINGLESTEP	(MSR_DE)
diff --git a/arch/powerpc/kernel/lparcfg.c b/arch/powerpc/kernel/lparcfg.c
index 578f35f..4190e80 100644
--- a/arch/powerpc/kernel/lparcfg.c
+++ b/arch/powerpc/kernel/lparcfg.c
@@ -31,7 +31,6 @@
 #include <asm/hvcall.h>
 #include <asm/firmware.h>
 #include <asm/rtas.h>
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/prom.h>
 #include <asm/vdso_datapage.h>
diff --git a/arch/powerpc/kernel/ppc_ksyms.c b/arch/powerpc/kernel/ppc_ksyms.c
index d3114a7..786a270 100644
--- a/arch/powerpc/kernel/ppc_ksyms.c
+++ b/arch/powerpc/kernel/ppc_ksyms.c
@@ -26,7 +26,6 @@
 #include <linux/cuda.h>
 #include <linux/pmu.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/pci-bridge.h>
 #include <asm/irq.h>
 #include <asm/pmac_feature.h>
@@ -43,6 +42,7 @@
 #include <asm/signal.h>
 #include <asm/dcr.h>
 #include <asm/ftrace.h>
+#include <asm/switch_to.h>
 
 #ifdef CONFIG_PPC32
 extern void transfer_to_handler(void);
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index d817ab0..bb67db0 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -41,7 +41,6 @@
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/mmu.h>
@@ -49,6 +48,8 @@
 #include <asm/machdep.h>
 #include <asm/time.h>
 #include <asm/syscalls.h>
+#include <asm/switch_to.h>
+#include <asm/debug.h>
 #ifdef CONFIG_PPC64
 #include <asm/firmware.h>
 #endif
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index abe405d..7f4eb14 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -41,7 +41,6 @@
 #include <asm/io.h>
 #include <asm/kdump.h>
 #include <asm/smp.h>
-#include <asm/system.h>
 #include <asm/mmu.h>
 #include <asm/paca.h>
 #include <asm/pgtable.h>
diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index eca626e..ba30059 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -35,7 +35,6 @@
 #include <asm/irq.h>
 #include <asm/io.h>
 #include <asm/smp.h>
-#include <asm/system.h>
 #include <asm/mmu.h>
 #include <asm/pgtable.h>
 #include <asm/pci.h>
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 5b43325..8d8e028 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -36,7 +36,7 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
+#include <asm/switch_to.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/syscalls.h>
diff --git a/arch/powerpc/kernel/ptrace32.c b/arch/powerpc/kernel/ptrace32.c
index 69c4be9..469349d 100644
--- a/arch/powerpc/kernel/ptrace32.c
+++ b/arch/powerpc/kernel/ptrace32.c
@@ -32,7 +32,7 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
+#include <asm/switch_to.h>
 
 /*
  * does not yet catch signals sent when the child dies.
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 9f843cd..3dc6799 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -33,7 +33,6 @@
 #include <asm/firmware.h>
 #include <asm/page.h>
 #include <asm/param.h>
-#include <asm/system.h>
 #include <asm/delay.h>
 #include <asm/uaccess.h>
 #include <asm/udbg.h>
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 77bb77d..9a25543 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -51,7 +51,6 @@
 #include <asm/btext.h>
 #include <asm/nvram.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/rtas.h>
 #include <asm/iommu.h>
 #include <asm/serial.h>
diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
index ac76108..9825f29 100644
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -30,7 +30,6 @@
 #include <asm/btext.h>
 #include <asm/machdep.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/pmac_feature.h>
 #include <asm/sections.h>
 #include <asm/nvram.h>
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 4cb8f1e..6d639b2 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -52,7 +52,6 @@
 #include <asm/btext.h>
 #include <asm/nvram.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/rtas.h>
 #include <asm/iommu.h>
 #include <asm/serial.h>
diff --git a/arch/powerpc/kernel/signal.c b/arch/powerpc/kernel/signal.c
index ac6e437..d9e9ca9 100644
--- a/arch/powerpc/kernel/signal.c
+++ b/arch/powerpc/kernel/signal.c
@@ -15,6 +15,7 @@
 #include <asm/hw_breakpoint.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
+#include <asm/debug.h>
 
 #include "signal.h"
 
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index 836a5a1..6d10f8c 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -43,6 +43,7 @@
 #include <asm/syscalls.h>
 #include <asm/sigcontext.h>
 #include <asm/vdso.h>
+#include <asm/switch_to.h>
 #ifdef CONFIG_PPC64
 #include "ppc32.h"
 #include <asm/unistd.h>
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index a50b5ec..2692efd 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -33,6 +33,7 @@
 #include <asm/cacheflush.h>
 #include <asm/syscalls.h>
 #include <asm/vdso.h>
+#include <asm/switch_to.h>
 
 #include "signal.h"
 
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 46695fe..d9f9441 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -43,12 +43,12 @@
 #include <asm/machdep.h>
 #include <asm/cputhreads.h>
 #include <asm/cputable.h>
-#include <asm/system.h>
 #include <asm/mpic.h>
 #include <asm/vdso_datapage.h>
 #ifdef CONFIG_PPC64
 #include <asm/paca.h>
 #endif
+#include <asm/debug.h>
 
 #ifdef DEBUG
 #include <asm/udbg.h>
diff --git a/arch/powerpc/kernel/softemu8xx.c b/arch/powerpc/kernel/softemu8xx.c
index af0e829..29b2f81 100644
--- a/arch/powerpc/kernel/softemu8xx.c
+++ b/arch/powerpc/kernel/softemu8xx.c
@@ -26,7 +26,6 @@
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 /* Eventually we may need a look-up table, but this works for now.
diff --git a/arch/powerpc/kernel/swsusp.c b/arch/powerpc/kernel/swsusp.c
index 641f9ad..eae33e1 100644
--- a/arch/powerpc/kernel/swsusp.c
+++ b/arch/powerpc/kernel/swsusp.c
@@ -10,9 +10,9 @@
  */
 
 #include <linux/sched.h>
-#include <asm/system.h>
 #include <asm/current.h>
 #include <asm/mmu_context.h>
+#include <asm/switch_to.h>
 
 void save_processor_state(void)
 {
diff --git a/arch/powerpc/kernel/swsusp_64.c b/arch/powerpc/kernel/swsusp_64.c
index 168e884..0e899e4 100644
--- a/arch/powerpc/kernel/swsusp_64.c
+++ b/arch/powerpc/kernel/swsusp_64.c
@@ -6,7 +6,6 @@
  * GPLv2
  */
 
-#include <asm/system.h>
 #include <asm/iommu.h>
 #include <linux/irq.h>
 #include <linux/sched.h>
diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index 4e5bf1e..81c5706 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -50,6 +50,7 @@
 #include <asm/mmu_context.h>
 #include <asm/ppc-pci.h>
 #include <asm/syscalls.h>
+#include <asm/switch_to.h>
 
 
 asmlinkage long ppc32_select(u32 n, compat_ulong_t __user *inp,
diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
index 883e74c..bf6af0d 100644
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -18,7 +18,6 @@
 #include <asm/machdep.h>
 #include <asm/smp.h>
 #include <asm/pmc.h>
-#include <asm/system.h>
 
 #include "cacheinfo.h"
 
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index c091527..db1ede7 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -39,7 +39,6 @@
 #include <asm/emulated_ops.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
 #include <asm/rtas.h>
@@ -57,6 +56,8 @@
 #include <asm/kexec.h>
 #include <asm/ppc-opcode.h>
 #include <asm/rio.h>
+#include <asm/switch_to.h>
+#include <asm/debug.h>
 
 #if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
 int (*__debugger)(struct pt_regs *regs) __read_mostly;
diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index 7d14bb6..1ce1ec4 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -24,7 +24,6 @@
 #include <linux/memblock.h>
 
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 336983d..6efde9c 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -45,6 +45,7 @@
 #include <asm/cputhreads.h>
 #include <asm/page.h>
 #include <asm/hvcall.h>
+#include <asm/switch_to.h>
 #include <linux/gfp.h>
 #include <linux/sched.h>
 #include <linux/vmalloc.h>
diff --git a/arch/powerpc/lib/alloc.c b/arch/powerpc/lib/alloc.c
index 13b676c..da22c84 100644
--- a/arch/powerpc/lib/alloc.c
+++ b/arch/powerpc/lib/alloc.c
@@ -3,8 +3,8 @@
 #include <linux/slab.h>
 #include <linux/bootmem.h>
 #include <linux/string.h>
+#include <asm/setup.h>
 
-#include <asm/system.h>
 
 void * __init_refok zalloc_maybe_bootmem(size_t size, gfp_t mask)
 {
diff --git a/arch/powerpc/lib/copyuser_power7_vmx.c b/arch/powerpc/lib/copyuser_power7_vmx.c
index 6e1efad..bf2654f 100644
--- a/arch/powerpc/lib/copyuser_power7_vmx.c
+++ b/arch/powerpc/lib/copyuser_power7_vmx.c
@@ -20,6 +20,7 @@
  */
 #include <linux/uaccess.h>
 #include <linux/hardirq.h>
+#include <asm/switch_to.h>
 
 int enter_vmx_copy(void)
 {
diff --git a/arch/powerpc/mm/44x_mmu.c b/arch/powerpc/mm/44x_mmu.c
index 388b95e..2c9441e 100644
--- a/arch/powerpc/mm/44x_mmu.c
+++ b/arch/powerpc/mm/44x_mmu.c
@@ -27,7 +27,6 @@
 #include <linux/memblock.h>
 
 #include <asm/mmu.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/cacheflush.h>
 
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 2f0d1b0..253e6f5 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -38,10 +38,10 @@
 #include <asm/pgtable.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
 #include <asm/siginfo.h>
+#include <asm/debug.h>
 #include <mm/mmu_decl.h>
 
 #include "icswx.h"
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index 2d28218..e43a231 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -40,7 +40,6 @@
 #include <asm/mmu_context.h>
 #include <asm/page.h>
 #include <asm/types.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/machdep.h>
 #include <asm/prom.h>
diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
index 6157be2..01e2db9 100644
--- a/arch/powerpc/mm/init_32.c
+++ b/arch/powerpc/mm/init_32.c
@@ -45,7 +45,6 @@
 #include <asm/btext.h>
 #include <asm/tlb.h>
 #include <asm/sections.h>
-#include <asm/system.h>
 #include <asm/hugetlb.h>
 
 #include "mmu_decl.h"
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index e94b57f..620b7ac 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -61,7 +61,6 @@
 #include <asm/mmzone.h>
 #include <asm/cputable.h>
 #include <asm/sections.h>
-#include <asm/system.h>
 #include <asm/iommu.h>
 #include <asm/abs_addr.h>
 #include <asm/vdso.h>
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 3feefc3..b6edbb3 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -24,11 +24,11 @@
 #include <linux/node.h>
 #include <asm/sparsemem.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/smp.h>
 #include <asm/firmware.h>
 #include <asm/paca.h>
 #include <asm/hvcall.h>
+#include <asm/setup.h>
 
 static int numa_enabled = 1;
 
diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index 51f8795..e9c513a 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -33,6 +33,7 @@
 #include <asm/pgalloc.h>
 #include <asm/fixmap.h>
 #include <asm/io.h>
+#include <asm/setup.h>
 
 #include "mmu_decl.h"
 
diff --git a/arch/powerpc/mm/pgtable_64.c b/arch/powerpc/mm/pgtable_64.c
index ad36ede..249a063 100644
--- a/arch/powerpc/mm/pgtable_64.c
+++ b/arch/powerpc/mm/pgtable_64.c
@@ -51,7 +51,6 @@
 #include <asm/processor.h>
 #include <asm/cputable.h>
 #include <asm/sections.h>
-#include <asm/system.h>
 #include <asm/abs_addr.h>
 #include <asm/firmware.h>
 
diff --git a/arch/powerpc/oprofile/common.c b/arch/powerpc/oprofile/common.c
index d65e68f..7056dc9 100644
--- a/arch/powerpc/oprofile/common.c
+++ b/arch/powerpc/oprofile/common.c
@@ -18,7 +18,6 @@
 #include <linux/smp.h>
 #include <linux/errno.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/pmc.h>
 #include <asm/cputable.h>
 #include <asm/oprofile_impl.h>
diff --git a/arch/powerpc/oprofile/op_model_7450.c b/arch/powerpc/oprofile/op_model_7450.c
index f8d36f9..ff61724 100644
--- a/arch/powerpc/oprofile/op_model_7450.c
+++ b/arch/powerpc/oprofile/op_model_7450.c
@@ -19,7 +19,6 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/cputable.h>
 #include <asm/page.h>
diff --git a/arch/powerpc/oprofile/op_model_cell.c b/arch/powerpc/oprofile/op_model_cell.c
index cb515cf..b9589c1 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -34,7 +34,6 @@
 #include <asm/ptrace.h>
 #include <asm/reg.h>
 #include <asm/rtas.h>
-#include <asm/system.h>
 #include <asm/cell-regs.h>
 
 #include "../platforms/cell/interrupt.h"
diff --git a/arch/powerpc/oprofile/op_model_fsl_emb.c b/arch/powerpc/oprofile/op_model_fsl_emb.c
index d4e6507..ccc1daa 100644
--- a/arch/powerpc/oprofile/op_model_fsl_emb.c
+++ b/arch/powerpc/oprofile/op_model_fsl_emb.c
@@ -17,7 +17,6 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/cputable.h>
 #include <asm/reg_fsl_emb.h>
diff --git a/arch/powerpc/oprofile/op_model_power4.c b/arch/powerpc/oprofile/op_model_power4.c
index e6bec74..95ae77d 100644
--- a/arch/powerpc/oprofile/op_model_power4.c
+++ b/arch/powerpc/oprofile/op_model_power4.c
@@ -14,7 +14,6 @@
 #include <linux/smp.h>
 #include <asm/firmware.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/cputable.h>
 #include <asm/rtas.h>
diff --git a/arch/powerpc/oprofile/op_model_rs64.c b/arch/powerpc/oprofile/op_model_rs64.c
index a20afe4..9b801b8 100644
--- a/arch/powerpc/oprofile/op_model_rs64.c
+++ b/arch/powerpc/oprofile/op_model_rs64.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/cputable.h>
 #include <asm/oprofile_impl.h>
diff --git a/arch/powerpc/platforms/82xx/pq2.c b/arch/powerpc/platforms/82xx/pq2.c
index d111b02..fb94d10 100644
--- a/arch/powerpc/platforms/82xx/pq2.c
+++ b/arch/powerpc/platforms/82xx/pq2.c
@@ -17,7 +17,6 @@
 #include <asm/cpm2.h>
 #include <asm/io.h>
 #include <asm/pci-bridge.h>
-#include <asm/system.h>
 
 #include <platforms/82xx/pq2.h>
 
diff --git a/arch/powerpc/platforms/83xx/km83xx.c b/arch/powerpc/platforms/83xx/km83xx.c
index 65eb792..a266ba8 100644
--- a/arch/powerpc/platforms/83xx/km83xx.c
+++ b/arch/powerpc/platforms/83xx/km83xx.c
@@ -27,7 +27,6 @@
 #include <linux/of_platform.h>
 #include <linux/of_device.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
diff --git a/arch/powerpc/platforms/83xx/mpc832x_mds.c b/arch/powerpc/platforms/83xx/mpc832x_mds.c
index e36bc61..d440435 100644
--- a/arch/powerpc/platforms/83xx/mpc832x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc832x_mds.c
@@ -26,7 +26,6 @@
 #include <linux/of_platform.h>
 #include <linux/of_device.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
diff --git a/arch/powerpc/platforms/83xx/mpc834x_itx.c b/arch/powerpc/platforms/83xx/mpc834x_itx.c
index 39849dd..a494fa5 100644
--- a/arch/powerpc/platforms/83xx/mpc834x_itx.c
+++ b/arch/powerpc/platforms/83xx/mpc834x_itx.c
@@ -25,7 +25,6 @@
 #include <linux/root_dev.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
diff --git a/arch/powerpc/platforms/83xx/mpc834x_mds.c b/arch/powerpc/platforms/83xx/mpc834x_mds.c
index 5828d8e..553e793 100644
--- a/arch/powerpc/platforms/83xx/mpc834x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc834x_mds.c
@@ -25,7 +25,6 @@
 #include <linux/root_dev.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
diff --git a/arch/powerpc/platforms/83xx/mpc836x_mds.c b/arch/powerpc/platforms/83xx/mpc836x_mds.c
index ad8e4bc..1b1f6c8 100644
--- a/arch/powerpc/platforms/83xx/mpc836x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc836x_mds.c
@@ -33,7 +33,6 @@
 #include <linux/of_platform.h>
 #include <linux/of_device.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
diff --git a/arch/powerpc/platforms/83xx/sbc834x.c b/arch/powerpc/platforms/83xx/sbc834x.c
index 8a81d76..26cb3e9 100644
--- a/arch/powerpc/platforms/83xx/sbc834x.c
+++ b/arch/powerpc/platforms/83xx/sbc834x.c
@@ -27,7 +27,6 @@
 #include <linux/root_dev.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
diff --git a/arch/powerpc/platforms/85xx/corenet_ds.c b/arch/powerpc/platforms/85xx/corenet_ds.c
index 07e3e6c..d517d9e 100644
--- a/arch/powerpc/platforms/85xx/corenet_ds.c
+++ b/arch/powerpc/platforms/85xx/corenet_ds.c
@@ -18,7 +18,6 @@
 #include <linux/interrupt.h>
 #include <linux/memblock.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/ksi8560.c b/arch/powerpc/platforms/85xx/ksi8560.c
index 20f75d7..8bc1be1 100644
--- a/arch/powerpc/platforms/85xx/ksi8560.c
+++ b/arch/powerpc/platforms/85xx/ksi8560.c
@@ -20,7 +20,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/mpc8536_ds.c b/arch/powerpc/platforms/85xx/mpc8536_ds.c
index cf26682..77b84d9 100644
--- a/arch/powerpc/platforms/85xx/mpc8536_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc8536_ds.c
@@ -19,7 +19,6 @@
 #include <linux/of_platform.h>
 #include <linux/memblock.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ads.c b/arch/powerpc/platforms/85xx/mpc85xx_ads.c
index 3bebb51..f26aae2 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ads.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ads.c
@@ -19,7 +19,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_cds.c b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
index 40f03da..b43c45b 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_cds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
@@ -27,7 +27,6 @@
 #include <linux/fsl_devices.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <linux/atomic.h>
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ds.c b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
index eefbb91..4fc46b4 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
@@ -22,7 +22,6 @@
 #include <linux/of_platform.h>
 #include <linux/memblock.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
index 1d15a0c..53f102c 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
@@ -34,7 +34,6 @@
 #include <linux/phy.h>
 #include <linux/memblock.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
index ccf520e..fcf3317 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
@@ -18,7 +18,6 @@
 #include <linux/interrupt.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/p1010rdb.c b/arch/powerpc/platforms/85xx/p1010rdb.c
index 538bc3f..462066a 100644
--- a/arch/powerpc/platforms/85xx/p1010rdb.c
+++ b/arch/powerpc/platforms/85xx/p1010rdb.c
@@ -16,7 +16,6 @@
 #include <linux/interrupt.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/p1023_rds.c b/arch/powerpc/platforms/85xx/p1023_rds.c
index d951e70..01e8da5 100644
--- a/arch/powerpc/platforms/85xx/p1023_rds.c
+++ b/arch/powerpc/platforms/85xx/p1023_rds.c
@@ -22,7 +22,6 @@
 #include <linux/of_platform.h>
 #include <linux/of_device.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/p2041_rdb.c b/arch/powerpc/platforms/85xx/p2041_rdb.c
index eda6ed5..6541fa2 100644
--- a/arch/powerpc/platforms/85xx/p2041_rdb.c
+++ b/arch/powerpc/platforms/85xx/p2041_rdb.c
@@ -16,7 +16,6 @@
 #include <linux/interrupt.h>
 #include <linux/phy.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/p3041_ds.c b/arch/powerpc/platforms/85xx/p3041_ds.c
index 96d99a3..f238efa 100644
--- a/arch/powerpc/platforms/85xx/p3041_ds.c
+++ b/arch/powerpc/platforms/85xx/p3041_ds.c
@@ -18,7 +18,6 @@
 #include <linux/interrupt.h>
 #include <linux/phy.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/p4080_ds.c b/arch/powerpc/platforms/85xx/p4080_ds.c
index d1b21d7..c92417d 100644
--- a/arch/powerpc/platforms/85xx/p4080_ds.c
+++ b/arch/powerpc/platforms/85xx/p4080_ds.c
@@ -17,7 +17,6 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/p5020_ds.c b/arch/powerpc/platforms/85xx/p5020_ds.c
index e8cba50..17bef15 100644
--- a/arch/powerpc/platforms/85xx/p5020_ds.c
+++ b/arch/powerpc/platforms/85xx/p5020_ds.c
@@ -18,7 +18,6 @@
 #include <linux/interrupt.h>
 #include <linux/phy.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/sbc8548.c b/arch/powerpc/platforms/85xx/sbc8548.c
index 184a507..3f6b3dc 100644
--- a/arch/powerpc/platforms/85xx/sbc8548.c
+++ b/arch/powerpc/platforms/85xx/sbc8548.c
@@ -30,7 +30,6 @@
 #include <linux/fsl_devices.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <linux/atomic.h>
diff --git a/arch/powerpc/platforms/85xx/sbc8560.c b/arch/powerpc/platforms/85xx/sbc8560.c
index 940752e..f863c35 100644
--- a/arch/powerpc/platforms/85xx/sbc8560.c
+++ b/arch/powerpc/platforms/85xx/sbc8560.c
@@ -21,7 +21,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/socrates.c b/arch/powerpc/platforms/85xx/socrates.c
index 18f6359..278022a 100644
--- a/arch/powerpc/platforms/85xx/socrates.c
+++ b/arch/powerpc/platforms/85xx/socrates.c
@@ -29,7 +29,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/stx_gp3.c b/arch/powerpc/platforms/85xx/stx_gp3.c
index e9e5234..cc681dc 100644
--- a/arch/powerpc/platforms/85xx/stx_gp3.c
+++ b/arch/powerpc/platforms/85xx/stx_gp3.c
@@ -28,7 +28,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/tqm85xx.c b/arch/powerpc/platforms/85xx/tqm85xx.c
index bf7c89f..b451f54 100644
--- a/arch/powerpc/platforms/85xx/tqm85xx.c
+++ b/arch/powerpc/platforms/85xx/tqm85xx.c
@@ -26,7 +26,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/xes_mpc85xx.c b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
index 3a69f8b..8085d34 100644
--- a/arch/powerpc/platforms/85xx/xes_mpc85xx.c
+++ b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
@@ -21,7 +21,6 @@
 #include <linux/interrupt.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/86xx/gef_ppc9a.c b/arch/powerpc/platforms/86xx/gef_ppc9a.c
index 60ce07e..09e56c3 100644
--- a/arch/powerpc/platforms/86xx/gef_ppc9a.c
+++ b/arch/powerpc/platforms/86xx/gef_ppc9a.c
@@ -24,7 +24,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/86xx/gef_sbc310.c b/arch/powerpc/platforms/86xx/gef_sbc310.c
index 3ecee25..e49365a 100644
--- a/arch/powerpc/platforms/86xx/gef_sbc310.c
+++ b/arch/powerpc/platforms/86xx/gef_sbc310.c
@@ -24,7 +24,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/86xx/gef_sbc610.c b/arch/powerpc/platforms/86xx/gef_sbc610.c
index 5090d60..4b34bee 100644
--- a/arch/powerpc/platforms/86xx/gef_sbc610.c
+++ b/arch/powerpc/platforms/86xx/gef_sbc610.c
@@ -24,7 +24,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c b/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
index 13fa9a6..bbc6152 100644
--- a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
+++ b/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
@@ -25,7 +25,6 @@
 #include <linux/seq_file.h>
 #include <linux/of.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
index 569262c..3755e61 100644
--- a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
+++ b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
@@ -21,7 +21,6 @@
 #include <linux/of_platform.h>
 #include <linux/memblock.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/86xx/pic.c b/arch/powerpc/platforms/86xx/pic.c
index 52bbfa0..962e6b7 100644
--- a/arch/powerpc/platforms/86xx/pic.c
+++ b/arch/powerpc/platforms/86xx/pic.c
@@ -12,7 +12,6 @@
 #include <linux/interrupt.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/mpic.h>
 #include <asm/i8259.h>
 
diff --git a/arch/powerpc/platforms/86xx/sbc8641d.c b/arch/powerpc/platforms/86xx/sbc8641d.c
index 51c8f33..e7007d0 100644
--- a/arch/powerpc/platforms/86xx/sbc8641d.c
+++ b/arch/powerpc/platforms/86xx/sbc8641d.c
@@ -21,7 +21,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/8xx/mpc86xads_setup.c b/arch/powerpc/platforms/8xx/mpc86xads_setup.c
index caaec29..866feff 100644
--- a/arch/powerpc/platforms/8xx/mpc86xads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc86xads_setup.c
@@ -19,7 +19,6 @@
 
 #include <asm/io.h>
 #include <asm/machdep.h>
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/8xx_immap.h>
 #include <asm/cpm1.h>
diff --git a/arch/powerpc/platforms/8xx/mpc885ads_setup.c b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
index 45ed6cd..5d98398 100644
--- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
@@ -32,7 +32,6 @@
 #include <asm/machdep.h>
 #include <asm/page.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/mpc8xx.h>
 #include <asm/8xx_immap.h>
diff --git a/arch/powerpc/platforms/8xx/tqm8xx_setup.c b/arch/powerpc/platforms/8xx/tqm8xx_setup.c
index 528e00d..8d21ab7 100644
--- a/arch/powerpc/platforms/8xx/tqm8xx_setup.c
+++ b/arch/powerpc/platforms/8xx/tqm8xx_setup.c
@@ -35,7 +35,6 @@
 #include <asm/machdep.h>
 #include <asm/page.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/mpc8xx.h>
 #include <asm/8xx_immap.h>
diff --git a/arch/powerpc/platforms/cell/smp.c b/arch/powerpc/platforms/cell/smp.c
index 4a255cf..49a65e2 100644
--- a/arch/powerpc/platforms/cell/smp.c
+++ b/arch/powerpc/platforms/cell/smp.c
@@ -38,7 +38,6 @@
 #include <asm/machdep.h>
 #include <asm/cputable.h>
 #include <asm/firmware.h>
-#include <asm/system.h>
 #include <asm/rtas.h>
 #include <asm/cputhreads.h>
 
diff --git a/arch/powerpc/platforms/embedded6xx/c2k.c b/arch/powerpc/platforms/embedded6xx/c2k.c
index 8cab573..ebd3963 100644
--- a/arch/powerpc/platforms/embedded6xx/c2k.c
+++ b/arch/powerpc/platforms/embedded6xx/c2k.c
@@ -23,7 +23,6 @@
 
 #include <asm/machdep.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/time.h>
 
 #include <mm/mmu_decl.h>
diff --git a/arch/powerpc/platforms/embedded6xx/holly.c b/arch/powerpc/platforms/embedded6xx/holly.c
index 9cfcf20..a7cd6a2 100644
--- a/arch/powerpc/platforms/embedded6xx/holly.c
+++ b/arch/powerpc/platforms/embedded6xx/holly.c
@@ -28,7 +28,6 @@
 #include <linux/of_platform.h>
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/prom.h>
diff --git a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
index f3350d7..916c6d2 100644
--- a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
+++ b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
@@ -32,7 +32,6 @@
 #include <linux/tty.h>
 #include <linux/serial_core.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/prom.h>
diff --git a/arch/powerpc/platforms/embedded6xx/prpmc2800.c b/arch/powerpc/platforms/embedded6xx/prpmc2800.c
index 670035f..d455f08 100644
--- a/arch/powerpc/platforms/embedded6xx/prpmc2800.c
+++ b/arch/powerpc/platforms/embedded6xx/prpmc2800.c
@@ -17,7 +17,6 @@
 
 #include <asm/machdep.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/time.h>
 
 #include <mm/mmu_decl.h>
diff --git a/arch/powerpc/platforms/embedded6xx/storcenter.c b/arch/powerpc/platforms/embedded6xx/storcenter.c
index afa6388..999b0ea 100644
--- a/arch/powerpc/platforms/embedded6xx/storcenter.c
+++ b/arch/powerpc/platforms/embedded6xx/storcenter.c
@@ -16,7 +16,6 @@
 #include <linux/initrd.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/prom.h>
 #include <asm/mpic.h>
diff --git a/arch/powerpc/platforms/fsl_uli1575.c b/arch/powerpc/platforms/fsl_uli1575.c
index 8b0c208..64fde05 100644
--- a/arch/powerpc/platforms/fsl_uli1575.c
+++ b/arch/powerpc/platforms/fsl_uli1575.c
@@ -15,7 +15,6 @@
 #include <linux/interrupt.h>
 #include <linux/mc146818rtc.h>
 
-#include <asm/system.h>
 #include <asm/pci-bridge.h>
 
 #define ULI_PIRQA	0x08
diff --git a/arch/powerpc/platforms/iseries/dt.c b/arch/powerpc/platforms/iseries/dt.c
index f0491cc..75adf10 100644
--- a/arch/powerpc/platforms/iseries/dt.c
+++ b/arch/powerpc/platforms/iseries/dt.c
@@ -30,7 +30,6 @@
 #include <asm/lppaca.h>
 #include <asm/cputable.h>
 #include <asm/abs_addr.h>
-#include <asm/system.h>
 #include <asm/iseries/hv_types.h>
 #include <asm/iseries/hv_lp_config.h>
 #include <asm/iseries/hv_call_xm.h>
diff --git a/arch/powerpc/platforms/iseries/lpevents.c b/arch/powerpc/platforms/iseries/lpevents.c
index 202e227..e305d62 100644
--- a/arch/powerpc/platforms/iseries/lpevents.c
+++ b/arch/powerpc/platforms/iseries/lpevents.c
@@ -15,7 +15,6 @@
 #include <linux/proc_fs.h>
 #include <linux/export.h>
 
-#include <asm/system.h>
 #include <asm/paca.h>
 #include <asm/firmware.h>
 #include <asm/iseries/it_lp_queue.h>
diff --git a/arch/powerpc/platforms/iseries/setup.c b/arch/powerpc/platforms/iseries/setup.c
index 8fc6258..3799f2f 100644
--- a/arch/powerpc/platforms/iseries/setup.c
+++ b/arch/powerpc/platforms/iseries/setup.c
@@ -41,7 +41,6 @@
 #include <asm/sections.h>
 #include <asm/iommu.h>
 #include <asm/firmware.h>
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/paca.h>
 #include <asm/cache.h>
diff --git a/arch/powerpc/platforms/iseries/smp.c b/arch/powerpc/platforms/iseries/smp.c
index 02df49f..5100bc7 100644
--- a/arch/powerpc/platforms/iseries/smp.c
+++ b/arch/powerpc/platforms/iseries/smp.c
@@ -39,7 +39,6 @@
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/cputable.h>
-#include <asm/system.h>
 
 static void smp_iSeries_cause_ipi(int cpu, unsigned long data)
 {
diff --git a/arch/powerpc/platforms/iseries/viopath.c b/arch/powerpc/platforms/iseries/viopath.c
index 40dad08..51c38b0 100644
--- a/arch/powerpc/platforms/iseries/viopath.c
+++ b/arch/powerpc/platforms/iseries/viopath.c
@@ -40,7 +40,6 @@
 #include <linux/interrupt.h>
 #include <linux/completion.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/prom.h>
 #include <asm/firmware.h>
diff --git a/arch/powerpc/platforms/maple/setup.c b/arch/powerpc/platforms/maple/setup.c
index 0bcbfe7..0d05f09 100644
--- a/arch/powerpc/platforms/maple/setup.c
+++ b/arch/powerpc/platforms/maple/setup.c
@@ -47,7 +47,6 @@
 #include <asm/processor.h>
 #include <asm/sections.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/maple/time.c b/arch/powerpc/platforms/maple/time.c
index eac569d..b4a369d 100644
--- a/arch/powerpc/platforms/maple/time.c
+++ b/arch/powerpc/platforms/maple/time.c
@@ -27,7 +27,6 @@
 
 #include <asm/sections.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/machdep.h>
diff --git a/arch/powerpc/platforms/pasemi/setup.c b/arch/powerpc/platforms/pasemi/setup.c
index 98b7a7c..dd981728 100644
--- a/arch/powerpc/platforms/pasemi/setup.c
+++ b/arch/powerpc/platforms/pasemi/setup.c
@@ -32,13 +32,13 @@
 #include <linux/gfp.h>
 
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/iommu.h>
 #include <asm/machdep.h>
 #include <asm/mpic.h>
 #include <asm/smp.h>
 #include <asm/time.h>
 #include <asm/mmu.h>
+#include <asm/debug.h>
 
 #include <pcmcia/ss.h>
 #include <pcmcia/cistpl.h>
diff --git a/arch/powerpc/platforms/powermac/bootx_init.c b/arch/powerpc/platforms/powermac/bootx_init.c
index 84d7fd9..3e91ef5 100644
--- a/arch/powerpc/platforms/powermac/bootx_init.c
+++ b/arch/powerpc/platforms/powermac/bootx_init.c
@@ -19,6 +19,7 @@
 #include <asm/bootx.h>
 #include <asm/btext.h>
 #include <asm/io.h>
+#include <asm/setup.h>
 
 #undef DEBUG
 #define SET_BOOT_BAT
diff --git a/arch/powerpc/platforms/powermac/cpufreq_32.c b/arch/powerpc/platforms/powermac/cpufreq_32.c
index 1fc386a..6417119 100644
--- a/arch/powerpc/platforms/powermac/cpufreq_32.c
+++ b/arch/powerpc/platforms/powermac/cpufreq_32.c
@@ -33,9 +33,9 @@
 #include <asm/sections.h>
 #include <asm/cputable.h>
 #include <asm/time.h>
-#include <asm/system.h>
 #include <asm/mpic.h>
 #include <asm/keylargo.h>
+#include <asm/switch_to.h>
 
 /* WARNING !!! This will cause calibrate_delay() to be called,
  * but this is an __init function ! So you MUST go edit
diff --git a/arch/powerpc/platforms/powermac/nvram.c b/arch/powerpc/platforms/powermac/nvram.c
index 54d2271..bf0a2cc 100644
--- a/arch/powerpc/platforms/powermac/nvram.c
+++ b/arch/powerpc/platforms/powermac/nvram.c
@@ -23,7 +23,6 @@
 #include <linux/spinlock.h>
 #include <asm/sections.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/nvram.h>
diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
index 970ea1d..141f889 100644
--- a/arch/powerpc/platforms/powermac/setup.c
+++ b/arch/powerpc/platforms/powermac/setup.c
@@ -57,7 +57,6 @@
 #include <asm/reg.h>
 #include <asm/sections.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/powermac/time.c b/arch/powerpc/platforms/powermac/time.c
index 11c9fce..8680bb6 100644
--- a/arch/powerpc/platforms/powermac/time.c
+++ b/arch/powerpc/platforms/powermac/time.c
@@ -26,7 +26,6 @@
 
 #include <asm/sections.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/machdep.h>
diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
index 17210c5..3ef4625 100644
--- a/arch/powerpc/platforms/powernv/smp.c
+++ b/arch/powerpc/platforms/powernv/smp.c
@@ -25,7 +25,6 @@
 #include <asm/machdep.h>
 #include <asm/cputable.h>
 #include <asm/firmware.h>
-#include <asm/system.h>
 #include <asm/rtas.h>
 #include <asm/vdso_datapage.h>
 #include <asm/cputhreads.h>
diff --git a/arch/powerpc/platforms/ps3/mm.c b/arch/powerpc/platforms/ps3/mm.c
index 8bd6ba5..de2aea4 100644
--- a/arch/powerpc/platforms/ps3/mm.c
+++ b/arch/powerpc/platforms/ps3/mm.c
@@ -29,6 +29,7 @@
 #include <asm/prom.h>
 #include <asm/udbg.h>
 #include <asm/lv1call.h>
+#include <asm/setup.h>
 
 #include "platform.h"
 
diff --git a/arch/powerpc/platforms/pseries/dtl.c b/arch/powerpc/platforms/pseries/dtl.c
index 0e86563..a764854 100644
--- a/arch/powerpc/platforms/pseries/dtl.c
+++ b/arch/powerpc/platforms/pseries/dtl.c
@@ -25,10 +25,10 @@
 #include <linux/debugfs.h>
 #include <linux/spinlock.h>
 #include <asm/smp.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/firmware.h>
 #include <asm/lppaca.h>
+#include <asm/debug.h>
 
 #include "plpar_wrappers.h"
 
diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index c986d08..64c97d8 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -23,7 +23,6 @@
 #include <linux/delay.h>
 #include <linux/sched.h>	/* for idle_task_exit */
 #include <linux/cpu.h>
-#include <asm/system.h>
 #include <asm/prom.h>
 #include <asm/rtas.h>
 #include <asm/firmware.h>
diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
index 085fd3f..f4cf675 100644
--- a/arch/powerpc/platforms/pseries/processor_idle.c
+++ b/arch/powerpc/platforms/pseries/processor_idle.c
@@ -14,7 +14,6 @@
 
 #include <asm/paca.h>
 #include <asm/reg.h>
-#include <asm/system.h>
 #include <asm/machdep.h>
 #include <asm/firmware.h>
 
diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
index 086d2ae..9e248ef 100644
--- a/arch/powerpc/platforms/pseries/ras.c
+++ b/arch/powerpc/platforms/pseries/ras.c
@@ -37,7 +37,6 @@
 #include <linux/bitops.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/irq.h>
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index eadba95..e16bb8d 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -37,7 +37,6 @@
 #include <asm/machdep.h>
 #include <asm/cputable.h>
 #include <asm/firmware.h>
-#include <asm/system.h>
 #include <asm/rtas.h>
 #include <asm/pSeries_reconfig.h>
 #include <asm/mpic.h>
diff --git a/arch/powerpc/platforms/wsp/chroma.c b/arch/powerpc/platforms/wsp/chroma.c
index ca6fa26..8ef53bc 100644
--- a/arch/powerpc/platforms/wsp/chroma.c
+++ b/arch/powerpc/platforms/wsp/chroma.c
@@ -17,7 +17,6 @@
 #include <linux/time.h>
 
 #include <asm/machdep.h>
-#include <asm/system.h>
 #include <asm/udbg.h>
 
 #include "ics.h"
diff --git a/arch/powerpc/platforms/wsp/psr2.c b/arch/powerpc/platforms/wsp/psr2.c
index 0c1ae06..508ec82 100644
--- a/arch/powerpc/platforms/wsp/psr2.c
+++ b/arch/powerpc/platforms/wsp/psr2.c
@@ -17,7 +17,6 @@
 #include <linux/time.h>
 
 #include <asm/machdep.h>
-#include <asm/system.h>
 #include <asm/udbg.h>
 
 #include "ics.h"
diff --git a/arch/powerpc/sysdev/cpm_common.c b/arch/powerpc/sysdev/cpm_common.c
index bf6c7cc..4dd5341 100644
--- a/arch/powerpc/sysdev/cpm_common.c
+++ b/arch/powerpc/sysdev/cpm_common.c
@@ -26,7 +26,6 @@
 
 #include <asm/udbg.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/rheap.h>
 #include <asm/cpm.h>
 
diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
index e8f385f..c449dbd 100644
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -31,7 +31,6 @@
 #include <linux/fs_enet_pd.h>
 #include <linux/fs_uart_pd.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/irq.h>
diff --git a/arch/powerpc/sysdev/msi_bitmap.c b/arch/powerpc/sysdev/msi_bitmap.c
index 5287e95..0968b66 100644
--- a/arch/powerpc/sysdev/msi_bitmap.c
+++ b/arch/powerpc/sysdev/msi_bitmap.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/bitmap.h>
 #include <asm/msi_bitmap.h>
+#include <asm/setup.h>
 
 int msi_bitmap_alloc_hwirqs(struct msi_bitmap *bmp, int num)
 {
diff --git a/arch/powerpc/sysdev/tsi108_dev.c b/arch/powerpc/sysdev/tsi108_dev.c
index 2370e1c..1fd0717 100644
--- a/arch/powerpc/sysdev/tsi108_dev.c
+++ b/arch/powerpc/sysdev/tsi108_dev.c
@@ -22,7 +22,6 @@
 #include <linux/of_net.h>
 #include <asm/tsi108.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/irq.h>
diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index cb95eea..d240f0c 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -42,6 +42,7 @@
 #include <asm/firmware.h>
 #include <asm/setjmp.h>
 #include <asm/reg.h>
+#include <asm/debug.h>
 
 #ifdef CONFIG_PPC64
 #include <asm/hvcall.h>


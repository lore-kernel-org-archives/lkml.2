Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161767Ab2COVEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:04:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161677Ab2COU7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:59:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 25/38] Disintegrate asm/system.h for Sparc [ver #3]
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>, sparclinux@vger.kernel.org
Date: Thu, 15 Mar 2012 20:59:09 +0000
Message-ID: <20120315205909.28759.19471.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for Sparc.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: sparclinux@vger.kernel.org
---

 arch/sparc/include/asm/atomic_32.h      |    2 
 arch/sparc/include/asm/atomic_64.h      |    3 
 arch/sparc/include/asm/auxio_32.h       |    1 
 arch/sparc/include/asm/barrier.h        |    8 +
 arch/sparc/include/asm/barrier_32.h     |   15 +
 arch/sparc/include/asm/barrier_64.h     |   56 +++++
 arch/sparc/include/asm/bug.h            |    3 
 arch/sparc/include/asm/cacheflush_32.h  |    9 +
 arch/sparc/include/asm/cacheflush_64.h  |   10 +
 arch/sparc/include/asm/cmpxchg.h        |    8 +
 arch/sparc/include/asm/cmpxchg_32.h     |  112 ++++++++++
 arch/sparc/include/asm/cmpxchg_64.h     |  145 ++++++++++++++
 arch/sparc/include/asm/cpu_type.h       |   34 +++
 arch/sparc/include/asm/exec.h           |    6 +
 arch/sparc/include/asm/floppy_32.h      |    1 
 arch/sparc/include/asm/futex_64.h       |    1 
 arch/sparc/include/asm/io_32.h          |    1 
 arch/sparc/include/asm/io_64.h          |    1 
 arch/sparc/include/asm/irqflags_32.h    |    1 
 arch/sparc/include/asm/mmu_context_64.h |    1 
 arch/sparc/include/asm/ns87303.h        |    1 
 arch/sparc/include/asm/perfctr.h        |   23 ++
 arch/sparc/include/asm/pgtable_32.h     |    2 
 arch/sparc/include/asm/pgtable_64.h     |    1 
 arch/sparc/include/asm/processor.h      |    3 
 arch/sparc/include/asm/processor_64.h   |    3 
 arch/sparc/include/asm/ptrace.h         |    5 
 arch/sparc/include/asm/setup.h          |   16 +
 arch/sparc/include/asm/switch_to.h      |    8 +
 arch/sparc/include/asm/switch_to_32.h   |  106 ++++++++++
 arch/sparc/include/asm/switch_to_64.h   |   72 +++++++
 arch/sparc/include/asm/system.h         |   14 +
 arch/sparc/include/asm/system_32.h      |  284 ---------------------------
 arch/sparc/include/asm/system_64.h      |  331 -------------------------------
 arch/sparc/include/asm/timer_32.h       |    3 
 arch/sparc/include/asm/uaccess_64.h     |    1 
 arch/sparc/kernel/auxio_32.c            |    1 
 arch/sparc/kernel/devices.c             |    2 
 arch/sparc/kernel/irq.h                 |    1 
 arch/sparc/kernel/irq_64.c              |    1 
 arch/sparc/kernel/kgdb_32.c             |    1 
 arch/sparc/kernel/module.c              |    1 
 arch/sparc/kernel/muldiv.c              |    1 
 arch/sparc/kernel/nmi.c                 |    1 
 arch/sparc/kernel/pcr.c                 |    1 
 arch/sparc/kernel/perf_event.c          |    2 
 arch/sparc/kernel/process_32.c          |    2 
 arch/sparc/kernel/process_64.c          |    1 
 arch/sparc/kernel/ptrace_32.c           |    2 
 arch/sparc/kernel/ptrace_64.c           |    1 
 arch/sparc/kernel/reboot.c              |    2 
 arch/sparc/kernel/setup_32.c            |    2 
 arch/sparc/kernel/setup_64.c            |    2 
 arch/sparc/kernel/signal32.c            |    1 
 arch/sparc/kernel/signal_32.c           |    1 
 arch/sparc/kernel/signal_64.c           |    2 
 arch/sparc/kernel/sigutil_32.c          |    1 
 arch/sparc/kernel/sigutil_64.c          |    1 
 arch/sparc/kernel/sparc_ksyms_64.c      |    2 
 arch/sparc/kernel/time_32.c             |    1 
 arch/sparc/kernel/traps_32.c            |    1 
 arch/sparc/kernel/traps_64.c            |    2 
 arch/sparc/kernel/unaligned_32.c        |    1 
 arch/sparc/kernel/unaligned_64.c        |    2 
 arch/sparc/kernel/visemul.c             |    2 
 arch/sparc/math-emu/math_64.c           |    1 
 arch/sparc/mm/btfixup.c                 |    1 
 arch/sparc/mm/fault_32.c                |    1 
 arch/sparc/mm/init_32.c                 |    1 
 arch/sparc/mm/init_64.c                 |    1 
 arch/sparc/mm/loadmmu.c                 |    1 
 arch/sparc/mm/tsb.c                     |    1 
 arch/sparc/prom/console_32.c            |    1 
 arch/sparc/prom/console_64.c            |    1 
 arch/sparc/prom/misc_32.c               |    1 
 arch/sparc/prom/misc_64.c               |    1 
 arch/sparc/prom/p1275.c                 |    1 
 arch/sparc/prom/ranges.c                |    1 
 drivers/tty/serial/sunhv.c              |    1 
 drivers/tty/serial/sunsab.c             |    1 
 drivers/tty/serial/sunsu.c              |    1 
 drivers/tty/serial/sunzilog.c           |    1 
 kernel/signal.c                         |    1 
 kernel/sysctl.c                         |    3 
 84 files changed, 684 insertions(+), 669 deletions(-)
 create mode 100644 arch/sparc/include/asm/barrier.h
 create mode 100644 arch/sparc/include/asm/barrier_32.h
 create mode 100644 arch/sparc/include/asm/barrier_64.h
 create mode 100644 arch/sparc/include/asm/cmpxchg.h
 create mode 100644 arch/sparc/include/asm/cmpxchg_32.h
 create mode 100644 arch/sparc/include/asm/cmpxchg_64.h
 create mode 100644 arch/sparc/include/asm/cpu_type.h
 create mode 100644 arch/sparc/include/asm/exec.h
 create mode 100644 arch/sparc/include/asm/switch_to.h
 create mode 100644 arch/sparc/include/asm/switch_to_32.h
 create mode 100644 arch/sparc/include/asm/switch_to_64.h
 delete mode 100644 arch/sparc/include/asm/system_32.h
 delete mode 100644 arch/sparc/include/asm/system_64.h

diff --git a/arch/sparc/include/asm/atomic_32.h b/arch/sparc/include/asm/atomic_32.h
index 9dd0a76..905832a 100644
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -13,9 +13,9 @@
 
 #include <linux/types.h>
 
+#include <asm/cmpxchg.h>
 #include <asm-generic/atomic64.h>
 
-#include <asm/system.h>
 
 #define ATOMIC_INIT(i)  { (i) }
 
diff --git a/arch/sparc/include/asm/atomic_64.h b/arch/sparc/include/asm/atomic_64.h
index 9f421df..ce35a1c 100644
--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -8,7 +8,7 @@
 #define __ARCH_SPARC64_ATOMIC__
 
 #include <linux/types.h>
-#include <asm/system.h>
+#include <asm/cmpxchg.h>
 
 #define ATOMIC_INIT(i)		{ (i) }
 #define ATOMIC64_INIT(i)	{ (i) }
@@ -85,7 +85,6 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 	return c;
 }
 
-
 #define atomic64_cmpxchg(v, o, n) \
 	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
diff --git a/arch/sparc/include/asm/auxio_32.h b/arch/sparc/include/asm/auxio_32.h
index e03e088..3a31977 100644
--- a/arch/sparc/include/asm/auxio_32.h
+++ b/arch/sparc/include/asm/auxio_32.h
@@ -6,7 +6,6 @@
 #ifndef _SPARC_AUXIO_H
 #define _SPARC_AUXIO_H
 
-#include <asm/system.h>
 #include <asm/vaddrs.h>
 
 /* This register is an unsigned char in IO space.  It does two things.
diff --git a/arch/sparc/include/asm/barrier.h b/arch/sparc/include/asm/barrier.h
new file mode 100644
index 0000000..b25f02a
--- /dev/null
+++ b/arch/sparc/include/asm/barrier.h
@@ -0,0 +1,8 @@
+#ifndef ___ASM_SPARC_BARRIER_H
+#define ___ASM_SPARC_BARRIER_H
+#if defined(__sparc__) && defined(__arch64__)
+#include <asm/barrier_64.h>
+#else
+#include <asm/barrier_32.h>
+#endif
+#endif
diff --git a/arch/sparc/include/asm/barrier_32.h b/arch/sparc/include/asm/barrier_32.h
new file mode 100644
index 0000000..c1b7665
--- /dev/null
+++ b/arch/sparc/include/asm/barrier_32.h
@@ -0,0 +1,15 @@
+#ifndef __SPARC_BARRIER_H
+#define __SPARC_BARRIER_H
+
+/* XXX Change this if we ever use a PSO mode kernel. */
+#define mb()	__asm__ __volatile__ ("" : : : "memory")
+#define rmb()	mb()
+#define wmb()	mb()
+#define read_barrier_depends()	do { } while(0)
+#define set_mb(__var, __value)  do { __var = __value; mb(); } while(0)
+#define smp_mb()	__asm__ __volatile__("":::"memory")
+#define smp_rmb()	__asm__ __volatile__("":::"memory")
+#define smp_wmb()	__asm__ __volatile__("":::"memory")
+#define smp_read_barrier_depends()	do { } while(0)
+
+#endif /* !(__SPARC_BARRIER_H) */
diff --git a/arch/sparc/include/asm/barrier_64.h b/arch/sparc/include/asm/barrier_64.h
new file mode 100644
index 0000000..95d4598
--- /dev/null
+++ b/arch/sparc/include/asm/barrier_64.h
@@ -0,0 +1,56 @@
+#ifndef __SPARC64_BARRIER_H
+#define __SPARC64_BARRIER_H
+
+/* These are here in an effort to more fully work around Spitfire Errata
+ * #51.  Essentially, if a memory barrier occurs soon after a mispredicted
+ * branch, the chip can stop executing instructions until a trap occurs.
+ * Therefore, if interrupts are disabled, the chip can hang forever.
+ *
+ * It used to be believed that the memory barrier had to be right in the
+ * delay slot, but a case has been traced recently wherein the memory barrier
+ * was one instruction after the branch delay slot and the chip still hung.
+ * The offending sequence was the following in sym_wakeup_done() of the
+ * sym53c8xx_2 driver:
+ *
+ *	call	sym_ccb_from_dsa, 0
+ *	 movge	%icc, 0, %l0
+ *	brz,pn	%o0, .LL1303
+ *	 mov	%o0, %l2
+ *	membar	#LoadLoad
+ *
+ * The branch has to be mispredicted for the bug to occur.  Therefore, we put
+ * the memory barrier explicitly into a "branch always, predicted taken"
+ * delay slot to avoid the problem case.
+ */
+#define membar_safe(type) \
+do {	__asm__ __volatile__("ba,pt	%%xcc, 1f\n\t" \
+			     " membar	" type "\n" \
+			     "1:\n" \
+			     : : : "memory"); \
+} while (0)
+
+/* The kernel always executes in TSO memory model these days,
+ * and furthermore most sparc64 chips implement more stringent
+ * memory ordering than required by the specifications.
+ */
+#define mb()	membar_safe("#StoreLoad")
+#define rmb()	__asm__ __volatile__("":::"memory")
+#define wmb()	__asm__ __volatile__("":::"memory")
+
+#define read_barrier_depends()		do { } while(0)
+#define set_mb(__var, __value) \
+	do { __var = __value; membar_safe("#StoreLoad"); } while(0)
+
+#ifdef CONFIG_SMP
+#define smp_mb()	mb()
+#define smp_rmb()	rmb()
+#define smp_wmb()	wmb()
+#else
+#define smp_mb()	__asm__ __volatile__("":::"memory")
+#define smp_rmb()	__asm__ __volatile__("":::"memory")
+#define smp_wmb()	__asm__ __volatile__("":::"memory")
+#endif
+
+#define smp_read_barrier_depends()	do { } while(0)
+
+#endif /* !(__SPARC64_BARRIER_H) */
diff --git a/arch/sparc/include/asm/bug.h b/arch/sparc/include/asm/bug.h
index 8a59e5a..6bd9f43 100644
--- a/arch/sparc/include/asm/bug.h
+++ b/arch/sparc/include/asm/bug.h
@@ -19,4 +19,7 @@ extern void do_BUG(const char *file, int line);
 
 #include <asm-generic/bug.h>
 
+struct pt_regs;
+extern void die_if_kernel(char *str, struct pt_regs *regs) __attribute__ ((noreturn));
+
 #endif
diff --git a/arch/sparc/include/asm/cacheflush_32.h b/arch/sparc/include/asm/cacheflush_32.h
index 2e46877..68431b4 100644
--- a/arch/sparc/include/asm/cacheflush_32.h
+++ b/arch/sparc/include/asm/cacheflush_32.h
@@ -83,4 +83,13 @@ extern void sparc_flush_page_to_ram(struct page *page);
 #define flush_cache_vmap(start, end)		flush_cache_all()
 #define flush_cache_vunmap(start, end)		flush_cache_all()
 
+/* When a context switch happens we must flush all user windows so that
+ * the windows of the current process are flushed onto its stack. This
+ * way the windows are all clean for the next process and the stack
+ * frames are up to date.
+ */
+extern void flush_user_windows(void);
+extern void kill_user_windows(void);
+extern void flushw_all(void);
+
 #endif /* _SPARC_CACHEFLUSH_H */
diff --git a/arch/sparc/include/asm/cacheflush_64.h b/arch/sparc/include/asm/cacheflush_64.h
index b953840..2efea2f 100644
--- a/arch/sparc/include/asm/cacheflush_64.h
+++ b/arch/sparc/include/asm/cacheflush_64.h
@@ -9,6 +9,16 @@
 
 /* Cache flush operations. */
 
+
+#define flushi(addr)	__asm__ __volatile__ ("flush %0" : : "r" (addr) : "memory")
+#define flushw_all()	__asm__ __volatile__("flushw")
+
+extern void __flushw_user(void);
+#define flushw_user() __flushw_user()
+
+#define flush_user_windows flushw_user
+#define flush_register_windows flushw_all
+
 /* These are the same regardless of whether this is an SMP kernel or not. */
 #define flush_cache_mm(__mm) \
 	do { if ((__mm) == current->mm) flushw_user(); } while(0)
diff --git a/arch/sparc/include/asm/cmpxchg.h b/arch/sparc/include/asm/cmpxchg.h
new file mode 100644
index 0000000..9355893
--- /dev/null
+++ b/arch/sparc/include/asm/cmpxchg.h
@@ -0,0 +1,8 @@
+#ifndef ___ASM_SPARC_CMPXCHG_H
+#define ___ASM_SPARC_CMPXCHG_H
+#if defined(__sparc__) && defined(__arch64__)
+#include <asm/cmpxchg_64.h>
+#else
+#include <asm/cmpxchg_32.h>
+#endif
+#endif
diff --git a/arch/sparc/include/asm/cmpxchg_32.h b/arch/sparc/include/asm/cmpxchg_32.h
new file mode 100644
index 0000000..c786b0a
--- /dev/null
+++ b/arch/sparc/include/asm/cmpxchg_32.h
@@ -0,0 +1,112 @@
+/* 32-bit atomic xchg() and cmpxchg() definitions.
+ *
+ * Copyright (C) 1996 David S. Miller (davem@davemloft.net)
+ * Copyright (C) 2000 Anton Blanchard (anton@linuxcare.com.au)
+ * Copyright (C) 2007 Kyle McMartin (kyle@parisc-linux.org)
+ *
+ * Additions by Keith M Wesolowski (wesolows@foobazco.org) based
+ * on asm-parisc/atomic.h Copyright (C) 2000 Philipp Rumpf <prumpf@tux.org>.
+ */
+
+#ifndef __ARCH_SPARC_CMPXCHG__
+#define __ARCH_SPARC_CMPXCHG__
+
+#include <asm/btfixup.h>
+
+/* This has special calling conventions */
+#ifndef CONFIG_SMP
+BTFIXUPDEF_CALL(void, ___xchg32, void)
+#endif
+
+static inline unsigned long xchg_u32(__volatile__ unsigned long *m, unsigned long val)
+{
+#ifdef CONFIG_SMP
+	__asm__ __volatile__("swap [%2], %0"
+			     : "=&r" (val)
+			     : "0" (val), "r" (m)
+			     : "memory");
+	return val;
+#else
+	register unsigned long *ptr asm("g1");
+	register unsigned long ret asm("g2");
+
+	ptr = (unsigned long *) m;
+	ret = val;
+
+	/* Note: this is magic and the nop there is
+	   really needed. */
+	__asm__ __volatile__(
+	"mov	%%o7, %%g4\n\t"
+	"call	___f____xchg32\n\t"
+	" nop\n\t"
+	: "=&r" (ret)
+	: "0" (ret), "r" (ptr)
+	: "g3", "g4", "g7", "memory", "cc");
+
+	return ret;
+#endif
+}
+
+extern void __xchg_called_with_bad_pointer(void);
+
+static inline unsigned long __xchg(unsigned long x, __volatile__ void * ptr, int size)
+{
+	switch (size) {
+	case 4:
+		return xchg_u32(ptr, x);
+	}
+	__xchg_called_with_bad_pointer();
+	return x;
+}
+
+#define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
+
+/* Emulate cmpxchg() the same way we emulate atomics,
+ * by hashing the object address and indexing into an array
+ * of spinlocks to get a bit of performance...
+ *
+ * See arch/sparc/lib/atomic32.c for implementation.
+ *
+ * Cribbed from <asm-parisc/atomic.h>
+ */
+#define __HAVE_ARCH_CMPXCHG	1
+
+/* bug catcher for when unsupported size is used - won't link */
+extern void __cmpxchg_called_with_bad_pointer(void);
+/* we only need to support cmpxchg of a u32 on sparc */
+extern unsigned long __cmpxchg_u32(volatile u32 *m, u32 old, u32 new_);
+
+/* don't worry...optimizer will get rid of most of this */
+static inline unsigned long
+__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new_, int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_u32((u32 *)ptr, (u32)old, (u32)new_);
+	default:
+		__cmpxchg_called_with_bad_pointer();
+		break;
+	}
+	return old;
+}
+
+#define cmpxchg(ptr, o, n)						\
+({									\
+	__typeof__(*(ptr)) _o_ = (o);					\
+	__typeof__(*(ptr)) _n_ = (n);					\
+	(__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,	\
+			(unsigned long)_n_, sizeof(*(ptr)));		\
+})
+
+#include <asm-generic/cmpxchg-local.h>
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)				  	       \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#endif /* __ARCH_SPARC_CMPXCHG__ */
diff --git a/arch/sparc/include/asm/cmpxchg_64.h b/arch/sparc/include/asm/cmpxchg_64.h
new file mode 100644
index 0000000..b30eb37
--- /dev/null
+++ b/arch/sparc/include/asm/cmpxchg_64.h
@@ -0,0 +1,145 @@
+/* 64-bit atomic xchg() and cmpxchg() definitions.
+ *
+ * Copyright (C) 1996, 1997, 2000 David S. Miller (davem@redhat.com)
+ */
+
+#ifndef __ARCH_SPARC64_CMPXCHG__
+#define __ARCH_SPARC64_CMPXCHG__
+
+static inline unsigned long xchg32(__volatile__ unsigned int *m, unsigned int val)
+{
+	unsigned long tmp1, tmp2;
+
+	__asm__ __volatile__(
+"	mov		%0, %1\n"
+"1:	lduw		[%4], %2\n"
+"	cas		[%4], %2, %0\n"
+"	cmp		%2, %0\n"
+"	bne,a,pn	%%icc, 1b\n"
+"	 mov		%1, %0\n"
+	: "=&r" (val), "=&r" (tmp1), "=&r" (tmp2)
+	: "0" (val), "r" (m)
+	: "cc", "memory");
+	return val;
+}
+
+static inline unsigned long xchg64(__volatile__ unsigned long *m, unsigned long val)
+{
+	unsigned long tmp1, tmp2;
+
+	__asm__ __volatile__(
+"	mov		%0, %1\n"
+"1:	ldx		[%4], %2\n"
+"	casx		[%4], %2, %0\n"
+"	cmp		%2, %0\n"
+"	bne,a,pn	%%xcc, 1b\n"
+"	 mov		%1, %0\n"
+	: "=&r" (val), "=&r" (tmp1), "=&r" (tmp2)
+	: "0" (val), "r" (m)
+	: "cc", "memory");
+	return val;
+}
+
+#define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
+
+extern void __xchg_called_with_bad_pointer(void);
+
+static inline unsigned long __xchg(unsigned long x, __volatile__ void * ptr,
+				       int size)
+{
+	switch (size) {
+	case 4:
+		return xchg32(ptr, x);
+	case 8:
+		return xchg64(ptr, x);
+	}
+	__xchg_called_with_bad_pointer();
+	return x;
+}
+
+/*
+ * Atomic compare and exchange.  Compare OLD with MEM, if identical,
+ * store NEW in MEM.  Return the initial value in MEM.  Success is
+ * indicated by comparing RETURN with OLD.
+ */
+
+#include <asm-generic/cmpxchg-local.h>
+
+#define __HAVE_ARCH_CMPXCHG 1
+
+static inline unsigned long
+__cmpxchg_u32(volatile int *m, int old, int new)
+{
+	__asm__ __volatile__("cas [%2], %3, %0"
+			     : "=&r" (new)
+			     : "0" (new), "r" (m), "r" (old)
+			     : "memory");
+
+	return new;
+}
+
+static inline unsigned long
+__cmpxchg_u64(volatile long *m, unsigned long old, unsigned long new)
+{
+	__asm__ __volatile__("casx [%2], %3, %0"
+			     : "=&r" (new)
+			     : "0" (new), "r" (m), "r" (old)
+			     : "memory");
+
+	return new;
+}
+
+/* This function doesn't exist, so you'll get a linker error
+   if something tries to do an invalid cmpxchg().  */
+extern void __cmpxchg_called_with_bad_pointer(void);
+
+static inline unsigned long
+__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new, int size)
+{
+	switch (size) {
+		case 4:
+			return __cmpxchg_u32(ptr, old, new);
+		case 8:
+			return __cmpxchg_u64(ptr, old, new);
+	}
+	__cmpxchg_called_with_bad_pointer();
+	return old;
+}
+
+#define cmpxchg(ptr,o,n)						 \
+  ({									 \
+     __typeof__(*(ptr)) _o_ = (o);					 \
+     __typeof__(*(ptr)) _n_ = (n);					 \
+     (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		 \
+				    (unsigned long)_n_, sizeof(*(ptr))); \
+  })
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+	case 8:	return __cmpxchg(ptr, old, new, size);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new, size);
+	}
+
+	return old;
+}
+
+#define cmpxchg_local(ptr, o, n)				  	\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n)					\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg_local((ptr), (o), (n));					\
+  })
+
+#endif /* __ARCH_SPARC64_CMPXCHG__ */
diff --git a/arch/sparc/include/asm/cpu_type.h b/arch/sparc/include/asm/cpu_type.h
new file mode 100644
index 0000000..4ca184d
--- /dev/null
+++ b/arch/sparc/include/asm/cpu_type.h
@@ -0,0 +1,34 @@
+#ifndef __ASM_CPU_TYPE_H
+#define __ASM_CPU_TYPE_H
+
+/*
+ * Sparc (general) CPU types
+ */
+enum sparc_cpu {
+  sun4        = 0x00,
+  sun4c       = 0x01,
+  sun4m       = 0x02,
+  sun4d       = 0x03,
+  sun4e       = 0x04,
+  sun4u       = 0x05, /* V8 ploos ploos */
+  sun_unknown = 0x06,
+  ap1000      = 0x07, /* almost a sun4m */
+  sparc_leon  = 0x08, /* Leon SoC */
+};
+
+#ifdef CONFIG_SPARC32
+extern enum sparc_cpu sparc_cpu_model;
+
+#define ARCH_SUN4C (sparc_cpu_model==sun4c)
+
+#define SUN4M_NCPUS            4              /* Architectural limit of sun4m. */
+
+#else
+
+#define sparc_cpu_model sun4u
+
+/* This cannot ever be a sun4c :) That's just history. */
+#define ARCH_SUN4C 0
+#endif
+
+#endif /* __ASM_CPU_TYPE_H */
diff --git a/arch/sparc/include/asm/exec.h b/arch/sparc/include/asm/exec.h
new file mode 100644
index 0000000..2e08588
--- /dev/null
+++ b/arch/sparc/include/asm/exec.h
@@ -0,0 +1,6 @@
+#ifndef __SPARC_EXEC_H
+#define __SPARC_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* __SPARC_EXEC_H */
diff --git a/arch/sparc/include/asm/floppy_32.h b/arch/sparc/include/asm/floppy_32.h
index 7440915..698d955 100644
--- a/arch/sparc/include/asm/floppy_32.h
+++ b/arch/sparc/include/asm/floppy_32.h
@@ -11,7 +11,6 @@
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/idprom.h>
 #include <asm/machines.h>
 #include <asm/oplib.h>
diff --git a/arch/sparc/include/asm/futex_64.h b/arch/sparc/include/asm/futex_64.h
index 444e7be..4e899b0 100644
--- a/arch/sparc/include/asm/futex_64.h
+++ b/arch/sparc/include/asm/futex_64.h
@@ -4,7 +4,6 @@
 #include <linux/futex.h>
 #include <linux/uaccess.h>
 #include <asm/errno.h>
-#include <asm/system.h>
 
 #define __futex_cas_op(insn, ret, oldval, uaddr, oparg)	\
 	__asm__ __volatile__(				\
diff --git a/arch/sparc/include/asm/io_32.h b/arch/sparc/include/asm/io_32.h
index 2006e5d..c1acbd8 100644
--- a/arch/sparc/include/asm/io_32.h
+++ b/arch/sparc/include/asm/io_32.h
@@ -6,7 +6,6 @@
 #include <linux/ioport.h>  /* struct resource */
 
 #include <asm/page.h>      /* IO address mapping routines need this */
-#include <asm/system.h>
 #include <asm-generic/pci_iomap.h>
 
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
diff --git a/arch/sparc/include/asm/io_64.h b/arch/sparc/include/asm/io_64.h
index 9481e5a..09b0b88 100644
--- a/arch/sparc/include/asm/io_64.h
+++ b/arch/sparc/include/asm/io_64.h
@@ -6,7 +6,6 @@
 #include <linux/types.h>
 
 #include <asm/page.h>      /* IO address mapping routines need this */
-#include <asm/system.h>
 #include <asm/asi.h>
 #include <asm-generic/pci_iomap.h>
 
diff --git a/arch/sparc/include/asm/irqflags_32.h b/arch/sparc/include/asm/irqflags_32.h
index 1484890..e414c06 100644
--- a/arch/sparc/include/asm/irqflags_32.h
+++ b/arch/sparc/include/asm/irqflags_32.h
@@ -13,6 +13,7 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/types.h>
+#include <asm/psr.h>
 
 extern void arch_local_irq_restore(unsigned long);
 extern unsigned long arch_local_irq_save(void);
diff --git a/arch/sparc/include/asm/mmu_context_64.h b/arch/sparc/include/asm/mmu_context_64.h
index 666a73f..a97fd08 100644
--- a/arch/sparc/include/asm/mmu_context_64.h
+++ b/arch/sparc/include/asm/mmu_context_64.h
@@ -6,7 +6,6 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/spinlock.h>
-#include <asm/system.h>
 #include <asm/spitfire.h>
 #include <asm-generic/mm_hooks.h>
 
diff --git a/arch/sparc/include/asm/ns87303.h b/arch/sparc/include/asm/ns87303.h
index af75548..6b947ee 100644
--- a/arch/sparc/include/asm/ns87303.h
+++ b/arch/sparc/include/asm/ns87303.h
@@ -79,7 +79,6 @@
 
 #include <linux/spinlock.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 
 extern spinlock_t ns87303_lock;
diff --git a/arch/sparc/include/asm/perfctr.h b/arch/sparc/include/asm/perfctr.h
index 8d8720a..3332d2c 100644
--- a/arch/sparc/include/asm/perfctr.h
+++ b/arch/sparc/include/asm/perfctr.h
@@ -168,6 +168,29 @@ struct vcounter_struct {
   unsigned long long vcnt1;
 };
 
+#else /* !(__KERNEL__) */
+
+#ifndef CONFIG_SPARC32
+
+/* Performance counter register access. */
+#define read_pcr(__p)  __asm__ __volatile__("rd	%%pcr, %0" : "=r" (__p))
+#define write_pcr(__p) __asm__ __volatile__("wr	%0, 0x0, %%pcr" : : "r" (__p))
+#define read_pic(__p)  __asm__ __volatile__("rd %%pic, %0" : "=r" (__p))
+
+/* Blackbird errata workaround.  See commentary in
+ * arch/sparc64/kernel/smp.c:smp_percpu_timer_interrupt()
+ * for more information.
+ */
+#define write_pic(__p)  					\
+	__asm__ __volatile__("ba,pt	%%xcc, 99f\n\t"		\
+			     " nop\n\t"				\
+			     ".align	64\n"			\
+			  "99:wr	%0, 0x0, %%pic\n\t"	\
+			     "rd	%%pic, %%g0" : : "r" (__p))
+#define reset_pic()	write_pic(0)
+
+#endif /* !CONFIG_SPARC32 */
+
 #endif /* !(__KERNEL__) */
 
 #endif /* !(PERF_COUNTER_API) */
diff --git a/arch/sparc/include/asm/pgtable_32.h b/arch/sparc/include/asm/pgtable_32.h
index a790cc6..3d71018 100644
--- a/arch/sparc/include/asm/pgtable_32.h
+++ b/arch/sparc/include/asm/pgtable_32.h
@@ -21,7 +21,7 @@
 #include <asm/vac-ops.h>
 #include <asm/oplib.h>
 #include <asm/btfixup.h>
-#include <asm/system.h>
+#include <asm/cpu_type.h>
 
 
 struct vm_area_struct;
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 38ebb2c..6fa2f79 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -19,7 +19,6 @@
 #include <asm/types.h>
 #include <asm/spitfire.h>
 #include <asm/asi.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 
diff --git a/arch/sparc/include/asm/processor.h b/arch/sparc/include/asm/processor.h
index 9da9646..2fe99e6 100644
--- a/arch/sparc/include/asm/processor.h
+++ b/arch/sparc/include/asm/processor.h
@@ -5,4 +5,7 @@
 #else
 #include <asm/processor_32.h>
 #endif
+
+#define nop() 		__asm__ __volatile__ ("nop")
+
 #endif
diff --git a/arch/sparc/include/asm/processor_64.h b/arch/sparc/include/asm/processor_64.h
index 59fcebb..e713db2 100644
--- a/arch/sparc/include/asm/processor_64.h
+++ b/arch/sparc/include/asm/processor_64.h
@@ -18,6 +18,9 @@
 #include <asm/ptrace.h>
 #include <asm/page.h>
 
+/* Don't hold the runqueue lock over context switch */
+#define __ARCH_WANT_UNLOCKED_CTXSW
+
 /* The sparc has no problems with write protection */
 #define wp_works_ok 1
 #define wp_works_ok__is_a_macro /* for versions in ksyms.c */
diff --git a/arch/sparc/include/asm/ptrace.h b/arch/sparc/include/asm/ptrace.h
index c00c3b5..ef8c7c0 100644
--- a/arch/sparc/include/asm/ptrace.h
+++ b/arch/sparc/include/asm/ptrace.h
@@ -98,6 +98,8 @@ struct sparc_trapf {
  */
 #ifndef __ASSEMBLY__
 
+#include <linux/types.h>
+
 struct pt_regs {
 	unsigned long psr;
 	unsigned long pc;
@@ -163,7 +165,6 @@ struct sparc_stackf {
 #ifdef __KERNEL__
 
 #include <linux/threads.h>
-#include <asm/system.h>
 
 static inline int pt_regs_trap_type(struct pt_regs *regs)
 {
@@ -240,8 +241,6 @@ extern unsigned long profile_pc(struct pt_regs *);
 
 #ifdef __KERNEL__
 
-#include <asm/system.h>
-
 static inline bool pt_regs_is_syscall(struct pt_regs *regs)
 {
 	return (regs->psr & PSR_SYSCALL);
diff --git a/arch/sparc/include/asm/setup.h b/arch/sparc/include/asm/setup.h
index 64718ba..00497ab 100644
--- a/arch/sparc/include/asm/setup.h
+++ b/arch/sparc/include/asm/setup.h
@@ -13,14 +13,30 @@
 
 #ifdef __KERNEL__
 
+extern char reboot_command[];
+
 #ifdef CONFIG_SPARC32
 /* The CPU that was used for booting
  * Only sun4d + leon may have boot_cpu_id != 0
  */
 extern unsigned char boot_cpu_id;
 extern unsigned char boot_cpu_id4;
+
+extern unsigned long empty_bad_page;
+extern unsigned long empty_bad_page_table;
+extern unsigned long empty_zero_page;
+
+extern int serial_console;
+static inline int con_is_present(void)
+{
+	return serial_console ? 0 : 1;
+}
 #endif
 
+extern void sun_do_break(void);
+extern int stop_a_enabled;
+extern int scons_pwroff;
+
 #endif /* __KERNEL__ */
 
 #endif /* _SPARC_SETUP_H */
diff --git a/arch/sparc/include/asm/switch_to.h b/arch/sparc/include/asm/switch_to.h
new file mode 100644
index 0000000..2dc4fa5
--- /dev/null
+++ b/arch/sparc/include/asm/switch_to.h
@@ -0,0 +1,8 @@
+#ifndef ___ASM_SPARC_SWITCH_TO_H
+#define ___ASM_SPARC_SWITCH_TO_H
+#if defined(__sparc__) && defined(__arch64__)
+#include <asm/switch_to_64.h>
+#else
+#include <asm/switch_to_32.h>
+#endif
+#endif
diff --git a/arch/sparc/include/asm/switch_to_32.h b/arch/sparc/include/asm/switch_to_32.h
new file mode 100644
index 0000000..e32e82b
--- /dev/null
+++ b/arch/sparc/include/asm/switch_to_32.h
@@ -0,0 +1,106 @@
+#ifndef __SPARC_SWITCH_TO_H
+#define __SPARC_SWITCH_TO_H
+
+#include <asm/smp.h>
+
+extern struct thread_info *current_set[NR_CPUS];
+
+/*
+ * Flush windows so that the VM switch which follows
+ * would not pull the stack from under us.
+ *
+ * SWITCH_ENTER and SWITH_DO_LAZY_FPU do not work yet (e.g. SMP does not work)
+ * XXX WTF is the above comment? Found in late teen 2.4.x.
+ */
+#ifdef CONFIG_SMP
+#define SWITCH_ENTER(prv) \
+	do {			\
+	if (test_tsk_thread_flag(prv, TIF_USEDFPU)) { \
+		put_psr(get_psr() | PSR_EF); \
+		fpsave(&(prv)->thread.float_regs[0], &(prv)->thread.fsr, \
+		       &(prv)->thread.fpqueue[0], &(prv)->thread.fpqdepth); \
+		clear_tsk_thread_flag(prv, TIF_USEDFPU); \
+		(prv)->thread.kregs->psr &= ~PSR_EF; \
+	} \
+	} while(0)
+
+#define SWITCH_DO_LAZY_FPU(next)	/* */
+#else
+#define SWITCH_ENTER(prv)		/* */
+#define SWITCH_DO_LAZY_FPU(nxt)	\
+	do {			\
+	if (last_task_used_math != (nxt))		\
+		(nxt)->thread.kregs->psr&=~PSR_EF;	\
+	} while(0)
+#endif
+
+#define prepare_arch_switch(next) do { \
+	__asm__ __volatile__( \
+	".globl\tflush_patch_switch\nflush_patch_switch:\n\t" \
+	"save %sp, -0x40, %sp; save %sp, -0x40, %sp; save %sp, -0x40, %sp\n\t" \
+	"save %sp, -0x40, %sp; save %sp, -0x40, %sp; save %sp, -0x40, %sp\n\t" \
+	"save %sp, -0x40, %sp\n\t" \
+	"restore; restore; restore; restore; restore; restore; restore"); \
+} while(0)
+
+	/* Much care has gone into this code, do not touch it.
+	 *
+	 * We need to loadup regs l0/l1 for the newly forked child
+	 * case because the trap return path relies on those registers
+	 * holding certain values, gcc is told that they are clobbered.
+	 * Gcc needs registers for 3 values in and 1 value out, so we
+	 * clobber every non-fixed-usage register besides l2/l3/o4/o5.  -DaveM
+	 *
+	 * Hey Dave, that do not touch sign is too much of an incentive
+	 * - Anton & Pete
+	 */
+#define switch_to(prev, next, last) do {						\
+	SWITCH_ENTER(prev);								\
+	SWITCH_DO_LAZY_FPU(next);							\
+	cpumask_set_cpu(smp_processor_id(), mm_cpumask(next->active_mm));		\
+	__asm__ __volatile__(								\
+	"sethi	%%hi(here - 0x8), %%o7\n\t"						\
+	"mov	%%g6, %%g3\n\t"								\
+	"or	%%o7, %%lo(here - 0x8), %%o7\n\t"					\
+	"rd	%%psr, %%g4\n\t"							\
+	"std	%%sp, [%%g6 + %4]\n\t"							\
+	"rd	%%wim, %%g5\n\t"							\
+	"wr	%%g4, 0x20, %%psr\n\t"							\
+	"nop\n\t"									\
+	"std	%%g4, [%%g6 + %3]\n\t"							\
+	"ldd	[%2 + %3], %%g4\n\t"							\
+	"mov	%2, %%g6\n\t"								\
+	".globl	patchme_store_new_current\n"						\
+"patchme_store_new_current:\n\t"							\
+	"st	%2, [%1]\n\t"								\
+	"wr	%%g4, 0x20, %%psr\n\t"							\
+	"nop\n\t"									\
+	"nop\n\t"									\
+	"nop\n\t"	/* LEON needs all 3 nops: load to %sp depends on CWP. */		\
+	"ldd	[%%g6 + %4], %%sp\n\t"							\
+	"wr	%%g5, 0x0, %%wim\n\t"							\
+	"ldd	[%%sp + 0x00], %%l0\n\t"						\
+	"ldd	[%%sp + 0x38], %%i6\n\t"						\
+	"wr	%%g4, 0x0, %%psr\n\t"							\
+	"nop\n\t"									\
+	"nop\n\t"									\
+	"jmpl	%%o7 + 0x8, %%g0\n\t"							\
+	" ld	[%%g3 + %5], %0\n\t"							\
+	"here:\n"									\
+        : "=&r" (last)									\
+        : "r" (&(current_set[hard_smp_processor_id()])),	\
+	  "r" (task_thread_info(next)),				\
+	  "i" (TI_KPSR),					\
+	  "i" (TI_KSP),						\
+	  "i" (TI_TASK)						\
+	:       "g1", "g2", "g3", "g4", "g5",       "g7",	\
+	  "l0", "l1",       "l3", "l4", "l5", "l6", "l7",	\
+	  "i0", "i1", "i2", "i3", "i4", "i5",			\
+	  "o0", "o1", "o2", "o3",                   "o7");	\
+	} while(0)
+
+extern void fpsave(unsigned long *fpregs, unsigned long *fsr,
+		   void *fpqueue, unsigned long *fpqdepth);
+extern void synchronize_user_stack(void);
+
+#endif /* __SPARC_SWITCH_TO_H */
diff --git a/arch/sparc/include/asm/switch_to_64.h b/arch/sparc/include/asm/switch_to_64.h
new file mode 100644
index 0000000..7923c4a
--- /dev/null
+++ b/arch/sparc/include/asm/switch_to_64.h
@@ -0,0 +1,72 @@
+#ifndef __SPARC64_SWITCH_TO_64_H
+#define __SPARC64_SWITCH_TO_64_H
+
+#include <asm/visasm.h>
+
+#define prepare_arch_switch(next)		\
+do {						\
+	flushw_all();				\
+} while (0)
+
+	/* See what happens when you design the chip correctly?
+	 *
+	 * We tell gcc we clobber all non-fixed-usage registers except
+	 * for l0/l1.  It will use one for 'next' and the other to hold
+	 * the output value of 'last'.  'next' is not referenced again
+	 * past the invocation of switch_to in the scheduler, so we need
+	 * not preserve it's value.  Hairy, but it lets us remove 2 loads
+	 * and 2 stores in this critical code path.  -DaveM
+	 */
+#define switch_to(prev, next, last)					\
+do {	flush_tlb_pending();						\
+	save_and_clear_fpu();						\
+	/* If you are tempted to conditionalize the following */	\
+	/* so that ASI is only written if it changes, think again. */	\
+	__asm__ __volatile__("wr %%g0, %0, %%asi"			\
+	: : "r" (__thread_flag_byte_ptr(task_thread_info(next))[TI_FLAG_BYTE_CURRENT_DS]));\
+	trap_block[current_thread_info()->cpu].thread =			\
+		task_thread_info(next);					\
+	__asm__ __volatile__(						\
+	"mov	%%g4, %%g7\n\t"						\
+	"stx	%%i6, [%%sp + 2047 + 0x70]\n\t"				\
+	"stx	%%i7, [%%sp + 2047 + 0x78]\n\t"				\
+	"rdpr	%%wstate, %%o5\n\t"					\
+	"stx	%%o6, [%%g6 + %6]\n\t"					\
+	"stb	%%o5, [%%g6 + %5]\n\t"					\
+	"rdpr	%%cwp, %%o5\n\t"					\
+	"stb	%%o5, [%%g6 + %8]\n\t"					\
+	"wrpr	%%g0, 15, %%pil\n\t"					\
+	"mov	%4, %%g6\n\t"						\
+	"ldub	[%4 + %8], %%g1\n\t"					\
+	"wrpr	%%g1, %%cwp\n\t"					\
+	"ldx	[%%g6 + %6], %%o6\n\t"					\
+	"ldub	[%%g6 + %5], %%o5\n\t"					\
+	"ldub	[%%g6 + %7], %%o7\n\t"					\
+	"wrpr	%%o5, 0x0, %%wstate\n\t"				\
+	"ldx	[%%sp + 2047 + 0x70], %%i6\n\t"				\
+	"ldx	[%%sp + 2047 + 0x78], %%i7\n\t"				\
+	"ldx	[%%g6 + %9], %%g4\n\t"					\
+	"wrpr	%%g0, 14, %%pil\n\t"					\
+	"brz,pt %%o7, switch_to_pc\n\t"					\
+	" mov	%%g7, %0\n\t"						\
+	"sethi	%%hi(ret_from_syscall), %%g1\n\t"			\
+	"jmpl	%%g1 + %%lo(ret_from_syscall), %%g0\n\t"		\
+	" nop\n\t"							\
+	".globl switch_to_pc\n\t"					\
+	"switch_to_pc:\n\t"						\
+	: "=&r" (last), "=r" (current), "=r" (current_thread_info_reg),	\
+	  "=r" (__local_per_cpu_offset)					\
+	: "0" (task_thread_info(next)),					\
+	  "i" (TI_WSTATE), "i" (TI_KSP), "i" (TI_NEW_CHILD),            \
+	  "i" (TI_CWP), "i" (TI_TASK)					\
+	: "cc",								\
+	        "g1", "g2", "g3",                   "g7",		\
+	        "l1", "l2", "l3", "l4", "l5", "l6", "l7",		\
+	  "i0", "i1", "i2", "i3", "i4", "i5",				\
+	  "o0", "o1", "o2", "o3", "o4", "o5",       "o7");		\
+} while(0)
+
+extern void synchronize_user_stack(void);
+extern void fault_in_user_windows(void);
+
+#endif /* __SPARC64_SWITCH_TO_64_H */
diff --git a/arch/sparc/include/asm/system.h b/arch/sparc/include/asm/system.h
index 7944a7c..ed532ba 100644
--- a/arch/sparc/include/asm/system.h
+++ b/arch/sparc/include/asm/system.h
@@ -1,8 +1,6 @@
-#ifndef ___ASM_SPARC_SYSTEM_H
-#define ___ASM_SPARC_SYSTEM_H
-#if defined(__sparc__) && defined(__arch64__)
-#include <asm/system_64.h>
-#else
-#include <asm/system_32.h>
-#endif
-#endif
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/cpu_type.h>
+#include <asm/cmpxchg.h>
+#include <asm/exec.h>
+#include <asm/switch_to.h>
diff --git a/arch/sparc/include/asm/system_32.h b/arch/sparc/include/asm/system_32.h
deleted file mode 100644
index aba1609..0000000
--- a/arch/sparc/include/asm/system_32.h
+++ /dev/null
@@ -1,284 +0,0 @@
-#ifndef __SPARC_SYSTEM_H
-#define __SPARC_SYSTEM_H
-
-#include <linux/kernel.h>
-#include <linux/threads.h>	/* NR_CPUS */
-#include <linux/thread_info.h>
-
-#include <asm/page.h>
-#include <asm/psr.h>
-#include <asm/ptrace.h>
-#include <asm/btfixup.h>
-#include <asm/smp.h>
-
-#ifndef __ASSEMBLY__
-
-#include <linux/irqflags.h>
-
-/*
- * Sparc (general) CPU types
- */
-enum sparc_cpu {
-  sun4        = 0x00,
-  sun4c       = 0x01,
-  sun4m       = 0x02,
-  sun4d       = 0x03,
-  sun4e       = 0x04,
-  sun4u       = 0x05, /* V8 ploos ploos */
-  sun_unknown = 0x06,
-  ap1000      = 0x07, /* almost a sun4m */
-  sparc_leon  = 0x08, /* Leon SoC */
-};
-
-/* Really, userland should not be looking at any of this... */
-#ifdef __KERNEL__
-
-extern enum sparc_cpu sparc_cpu_model;
-
-#define ARCH_SUN4C (sparc_cpu_model==sun4c)
-
-#define SUN4M_NCPUS            4              /* Architectural limit of sun4m. */
-
-extern char reboot_command[];
-
-extern struct thread_info *current_set[NR_CPUS];
-
-extern unsigned long empty_bad_page;
-extern unsigned long empty_bad_page_table;
-extern unsigned long empty_zero_page;
-
-extern void sun_do_break(void);
-extern int serial_console;
-extern int stop_a_enabled;
-extern int scons_pwroff;
-
-static inline int con_is_present(void)
-{
-	return serial_console ? 0 : 1;
-}
-
-/* When a context switch happens we must flush all user windows so that
- * the windows of the current process are flushed onto its stack. This
- * way the windows are all clean for the next process and the stack
- * frames are up to date.
- */
-extern void flush_user_windows(void);
-extern void kill_user_windows(void);
-extern void synchronize_user_stack(void);
-extern void fpsave(unsigned long *fpregs, unsigned long *fsr,
-		   void *fpqueue, unsigned long *fpqdepth);
-
-#ifdef CONFIG_SMP
-#define SWITCH_ENTER(prv) \
-	do {			\
-	if (test_tsk_thread_flag(prv, TIF_USEDFPU)) { \
-		put_psr(get_psr() | PSR_EF); \
-		fpsave(&(prv)->thread.float_regs[0], &(prv)->thread.fsr, \
-		       &(prv)->thread.fpqueue[0], &(prv)->thread.fpqdepth); \
-		clear_tsk_thread_flag(prv, TIF_USEDFPU); \
-		(prv)->thread.kregs->psr &= ~PSR_EF; \
-	} \
-	} while(0)
-
-#define SWITCH_DO_LAZY_FPU(next)	/* */
-#else
-#define SWITCH_ENTER(prv)		/* */
-#define SWITCH_DO_LAZY_FPU(nxt)	\
-	do {			\
-	if (last_task_used_math != (nxt))		\
-		(nxt)->thread.kregs->psr&=~PSR_EF;	\
-	} while(0)
-#endif
-
-extern void flushw_all(void);
-
-/*
- * Flush windows so that the VM switch which follows
- * would not pull the stack from under us.
- *
- * SWITCH_ENTER and SWITH_DO_LAZY_FPU do not work yet (e.g. SMP does not work)
- * XXX WTF is the above comment? Found in late teen 2.4.x.
- */
-#define prepare_arch_switch(next) do { \
-	__asm__ __volatile__( \
-	".globl\tflush_patch_switch\nflush_patch_switch:\n\t" \
-	"save %sp, -0x40, %sp; save %sp, -0x40, %sp; save %sp, -0x40, %sp\n\t" \
-	"save %sp, -0x40, %sp; save %sp, -0x40, %sp; save %sp, -0x40, %sp\n\t" \
-	"save %sp, -0x40, %sp\n\t" \
-	"restore; restore; restore; restore; restore; restore; restore"); \
-} while(0)
-
-	/* Much care has gone into this code, do not touch it.
-	 *
-	 * We need to loadup regs l0/l1 for the newly forked child
-	 * case because the trap return path relies on those registers
-	 * holding certain values, gcc is told that they are clobbered.
-	 * Gcc needs registers for 3 values in and 1 value out, so we
-	 * clobber every non-fixed-usage register besides l2/l3/o4/o5.  -DaveM
-	 *
-	 * Hey Dave, that do not touch sign is too much of an incentive
-	 * - Anton & Pete
-	 */
-#define switch_to(prev, next, last) do {						\
-	SWITCH_ENTER(prev);								\
-	SWITCH_DO_LAZY_FPU(next);							\
-	cpumask_set_cpu(smp_processor_id(), mm_cpumask(next->active_mm));		\
-	__asm__ __volatile__(								\
-	"sethi	%%hi(here - 0x8), %%o7\n\t"						\
-	"mov	%%g6, %%g3\n\t"								\
-	"or	%%o7, %%lo(here - 0x8), %%o7\n\t"					\
-	"rd	%%psr, %%g4\n\t"							\
-	"std	%%sp, [%%g6 + %4]\n\t"							\
-	"rd	%%wim, %%g5\n\t"							\
-	"wr	%%g4, 0x20, %%psr\n\t"							\
-	"nop\n\t"									\
-	"std	%%g4, [%%g6 + %3]\n\t"							\
-	"ldd	[%2 + %3], %%g4\n\t"							\
-	"mov	%2, %%g6\n\t"								\
-	".globl	patchme_store_new_current\n"						\
-"patchme_store_new_current:\n\t"							\
-	"st	%2, [%1]\n\t"								\
-	"wr	%%g4, 0x20, %%psr\n\t"							\
-	"nop\n\t"									\
-	"nop\n\t"									\
-	"nop\n\t"	/* LEON needs all 3 nops: load to %sp depends on CWP. */		\
-	"ldd	[%%g6 + %4], %%sp\n\t"							\
-	"wr	%%g5, 0x0, %%wim\n\t"							\
-	"ldd	[%%sp + 0x00], %%l0\n\t"						\
-	"ldd	[%%sp + 0x38], %%i6\n\t"						\
-	"wr	%%g4, 0x0, %%psr\n\t"							\
-	"nop\n\t"									\
-	"nop\n\t"									\
-	"jmpl	%%o7 + 0x8, %%g0\n\t"							\
-	" ld	[%%g3 + %5], %0\n\t"							\
-	"here:\n"									\
-        : "=&r" (last)									\
-        : "r" (&(current_set[hard_smp_processor_id()])),	\
-	  "r" (task_thread_info(next)),				\
-	  "i" (TI_KPSR),					\
-	  "i" (TI_KSP),						\
-	  "i" (TI_TASK)						\
-	:       "g1", "g2", "g3", "g4", "g5",       "g7",	\
-	  "l0", "l1",       "l3", "l4", "l5", "l6", "l7",	\
-	  "i0", "i1", "i2", "i3", "i4", "i5",			\
-	  "o0", "o1", "o2", "o3",                   "o7");	\
-	} while(0)
-
-/* XXX Change this if we ever use a PSO mode kernel. */
-#define mb()	__asm__ __volatile__ ("" : : : "memory")
-#define rmb()	mb()
-#define wmb()	mb()
-#define read_barrier_depends()	do { } while(0)
-#define set_mb(__var, __value)  do { __var = __value; mb(); } while(0)
-#define smp_mb()	__asm__ __volatile__("":::"memory")
-#define smp_rmb()	__asm__ __volatile__("":::"memory")
-#define smp_wmb()	__asm__ __volatile__("":::"memory")
-#define smp_read_barrier_depends()	do { } while(0)
-
-#define nop() __asm__ __volatile__ ("nop")
-
-/* This has special calling conventions */
-#ifndef CONFIG_SMP
-BTFIXUPDEF_CALL(void, ___xchg32, void)
-#endif
-
-static inline unsigned long xchg_u32(__volatile__ unsigned long *m, unsigned long val)
-{
-#ifdef CONFIG_SMP
-	__asm__ __volatile__("swap [%2], %0"
-			     : "=&r" (val)
-			     : "0" (val), "r" (m)
-			     : "memory");
-	return val;
-#else
-	register unsigned long *ptr asm("g1");
-	register unsigned long ret asm("g2");
-
-	ptr = (unsigned long *) m;
-	ret = val;
-
-	/* Note: this is magic and the nop there is
-	   really needed. */
-	__asm__ __volatile__(
-	"mov	%%o7, %%g4\n\t"
-	"call	___f____xchg32\n\t"
-	" nop\n\t"
-	: "=&r" (ret)
-	: "0" (ret), "r" (ptr)
-	: "g3", "g4", "g7", "memory", "cc");
-
-	return ret;
-#endif
-}
-
-#define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-
-extern void __xchg_called_with_bad_pointer(void);
-
-static inline unsigned long __xchg(unsigned long x, __volatile__ void * ptr, int size)
-{
-	switch (size) {
-	case 4:
-		return xchg_u32(ptr, x);
-	}
-	__xchg_called_with_bad_pointer();
-	return x;
-}
-
-/* Emulate cmpxchg() the same way we emulate atomics,
- * by hashing the object address and indexing into an array
- * of spinlocks to get a bit of performance...
- *
- * See arch/sparc/lib/atomic32.c for implementation.
- *
- * Cribbed from <asm-parisc/atomic.h>
- */
-#define __HAVE_ARCH_CMPXCHG	1
-
-/* bug catcher for when unsupported size is used - won't link */
-extern void __cmpxchg_called_with_bad_pointer(void);
-/* we only need to support cmpxchg of a u32 on sparc */
-extern unsigned long __cmpxchg_u32(volatile u32 *m, u32 old, u32 new_);
-
-/* don't worry...optimizer will get rid of most of this */
-static inline unsigned long
-__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new_, int size)
-{
-	switch (size) {
-	case 4:
-		return __cmpxchg_u32((u32 *)ptr, (u32)old, (u32)new_);
-	default:
-		__cmpxchg_called_with_bad_pointer();
-		break;
-	}
-	return old;
-}
-
-#define cmpxchg(ptr, o, n)						\
-({									\
-	__typeof__(*(ptr)) _o_ = (o);					\
-	__typeof__(*(ptr)) _n_ = (n);					\
-	(__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,	\
-			(unsigned long)_n_, sizeof(*(ptr)));		\
-})
-
-#include <asm-generic/cmpxchg-local.h>
-
-/*
- * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
- * them available.
- */
-#define cmpxchg_local(ptr, o, n)				  	       \
-	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
-			(unsigned long)(n), sizeof(*(ptr))))
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-
-extern void die_if_kernel(char *str, struct pt_regs *regs) __attribute__ ((noreturn));
-
-#endif /* __KERNEL__ */
-
-#endif /* __ASSEMBLY__ */
-
-#define arch_align_stack(x) (x)
-
-#endif /* !(__SPARC_SYSTEM_H) */
diff --git a/arch/sparc/include/asm/system_64.h b/arch/sparc/include/asm/system_64.h
deleted file mode 100644
index 10bcabc..0000000
--- a/arch/sparc/include/asm/system_64.h
+++ /dev/null
@@ -1,331 +0,0 @@
-#ifndef __SPARC64_SYSTEM_H
-#define __SPARC64_SYSTEM_H
-
-#include <asm/ptrace.h>
-#include <asm/processor.h>
-#include <asm/visasm.h>
-
-#ifndef __ASSEMBLY__
-
-#include <linux/irqflags.h>
-#include <asm-generic/cmpxchg-local.h>
-
-/*
- * Sparc (general) CPU types
- */
-enum sparc_cpu {
-  sun4        = 0x00,
-  sun4c       = 0x01,
-  sun4m       = 0x02,
-  sun4d       = 0x03,
-  sun4e       = 0x04,
-  sun4u       = 0x05, /* V8 ploos ploos */
-  sun_unknown = 0x06,
-  ap1000      = 0x07, /* almost a sun4m */
-};
-
-#define sparc_cpu_model sun4u
-
-/* This cannot ever be a sun4c :) That's just history. */
-#define ARCH_SUN4C 0
-
-extern char reboot_command[];
-
-/* These are here in an effort to more fully work around Spitfire Errata
- * #51.  Essentially, if a memory barrier occurs soon after a mispredicted
- * branch, the chip can stop executing instructions until a trap occurs.
- * Therefore, if interrupts are disabled, the chip can hang forever.
- *
- * It used to be believed that the memory barrier had to be right in the
- * delay slot, but a case has been traced recently wherein the memory barrier
- * was one instruction after the branch delay slot and the chip still hung.
- * The offending sequence was the following in sym_wakeup_done() of the
- * sym53c8xx_2 driver:
- *
- *	call	sym_ccb_from_dsa, 0
- *	 movge	%icc, 0, %l0
- *	brz,pn	%o0, .LL1303
- *	 mov	%o0, %l2
- *	membar	#LoadLoad
- *
- * The branch has to be mispredicted for the bug to occur.  Therefore, we put
- * the memory barrier explicitly into a "branch always, predicted taken"
- * delay slot to avoid the problem case.
- */
-#define membar_safe(type) \
-do {	__asm__ __volatile__("ba,pt	%%xcc, 1f\n\t" \
-			     " membar	" type "\n" \
-			     "1:\n" \
-			     : : : "memory"); \
-} while (0)
-
-/* The kernel always executes in TSO memory model these days,
- * and furthermore most sparc64 chips implement more stringent
- * memory ordering than required by the specifications.
- */
-#define mb()	membar_safe("#StoreLoad")
-#define rmb()	__asm__ __volatile__("":::"memory")
-#define wmb()	__asm__ __volatile__("":::"memory")
-
-#endif
-
-#define nop() 		__asm__ __volatile__ ("nop")
-
-#define read_barrier_depends()		do { } while(0)
-#define set_mb(__var, __value) \
-	do { __var = __value; membar_safe("#StoreLoad"); } while(0)
-
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#else
-#define smp_mb()	__asm__ __volatile__("":::"memory")
-#define smp_rmb()	__asm__ __volatile__("":::"memory")
-#define smp_wmb()	__asm__ __volatile__("":::"memory")
-#endif
-
-#define smp_read_barrier_depends()	do { } while(0)
-
-#define flushi(addr)	__asm__ __volatile__ ("flush %0" : : "r" (addr) : "memory")
-
-#define flushw_all()	__asm__ __volatile__("flushw")
-
-/* Performance counter register access. */
-#define read_pcr(__p)  __asm__ __volatile__("rd	%%pcr, %0" : "=r" (__p))
-#define write_pcr(__p) __asm__ __volatile__("wr	%0, 0x0, %%pcr" : : "r" (__p))
-#define read_pic(__p)  __asm__ __volatile__("rd %%pic, %0" : "=r" (__p))
-
-/* Blackbird errata workaround.  See commentary in
- * arch/sparc64/kernel/smp.c:smp_percpu_timer_interrupt()
- * for more information.
- */
-#define write_pic(__p)  					\
-	__asm__ __volatile__("ba,pt	%%xcc, 99f\n\t"		\
-			     " nop\n\t"				\
-			     ".align	64\n"			\
-			  "99:wr	%0, 0x0, %%pic\n\t"	\
-			     "rd	%%pic, %%g0" : : "r" (__p))
-#define reset_pic()	write_pic(0)
-
-#ifndef __ASSEMBLY__
-
-extern void sun_do_break(void);
-extern int stop_a_enabled;
-extern int scons_pwroff;
-
-extern void fault_in_user_windows(void);
-extern void synchronize_user_stack(void);
-
-extern void __flushw_user(void);
-#define flushw_user() __flushw_user()
-
-#define flush_user_windows flushw_user
-#define flush_register_windows flushw_all
-
-/* Don't hold the runqueue lock over context switch */
-#define __ARCH_WANT_UNLOCKED_CTXSW
-#define prepare_arch_switch(next)		\
-do {						\
-	flushw_all();				\
-} while (0)
-
-	/* See what happens when you design the chip correctly?
-	 *
-	 * We tell gcc we clobber all non-fixed-usage registers except
-	 * for l0/l1.  It will use one for 'next' and the other to hold
-	 * the output value of 'last'.  'next' is not referenced again
-	 * past the invocation of switch_to in the scheduler, so we need
-	 * not preserve it's value.  Hairy, but it lets us remove 2 loads
-	 * and 2 stores in this critical code path.  -DaveM
-	 */
-#define switch_to(prev, next, last)					\
-do {	flush_tlb_pending();						\
-	save_and_clear_fpu();						\
-	/* If you are tempted to conditionalize the following */	\
-	/* so that ASI is only written if it changes, think again. */	\
-	__asm__ __volatile__("wr %%g0, %0, %%asi"			\
-	: : "r" (__thread_flag_byte_ptr(task_thread_info(next))[TI_FLAG_BYTE_CURRENT_DS]));\
-	trap_block[current_thread_info()->cpu].thread =			\
-		task_thread_info(next);					\
-	__asm__ __volatile__(						\
-	"mov	%%g4, %%g7\n\t"						\
-	"stx	%%i6, [%%sp + 2047 + 0x70]\n\t"				\
-	"stx	%%i7, [%%sp + 2047 + 0x78]\n\t"				\
-	"rdpr	%%wstate, %%o5\n\t"					\
-	"stx	%%o6, [%%g6 + %6]\n\t"					\
-	"stb	%%o5, [%%g6 + %5]\n\t"					\
-	"rdpr	%%cwp, %%o5\n\t"					\
-	"stb	%%o5, [%%g6 + %8]\n\t"					\
-	"wrpr	%%g0, 15, %%pil\n\t"					\
-	"mov	%4, %%g6\n\t"						\
-	"ldub	[%4 + %8], %%g1\n\t"					\
-	"wrpr	%%g1, %%cwp\n\t"					\
-	"ldx	[%%g6 + %6], %%o6\n\t"					\
-	"ldub	[%%g6 + %5], %%o5\n\t"					\
-	"ldub	[%%g6 + %7], %%o7\n\t"					\
-	"wrpr	%%o5, 0x0, %%wstate\n\t"				\
-	"ldx	[%%sp + 2047 + 0x70], %%i6\n\t"				\
-	"ldx	[%%sp + 2047 + 0x78], %%i7\n\t"				\
-	"ldx	[%%g6 + %9], %%g4\n\t"					\
-	"wrpr	%%g0, 14, %%pil\n\t"					\
-	"brz,pt %%o7, switch_to_pc\n\t"					\
-	" mov	%%g7, %0\n\t"						\
-	"sethi	%%hi(ret_from_syscall), %%g1\n\t"			\
-	"jmpl	%%g1 + %%lo(ret_from_syscall), %%g0\n\t"		\
-	" nop\n\t"							\
-	".globl switch_to_pc\n\t"					\
-	"switch_to_pc:\n\t"						\
-	: "=&r" (last), "=r" (current), "=r" (current_thread_info_reg),	\
-	  "=r" (__local_per_cpu_offset)					\
-	: "0" (task_thread_info(next)),					\
-	  "i" (TI_WSTATE), "i" (TI_KSP), "i" (TI_NEW_CHILD),            \
-	  "i" (TI_CWP), "i" (TI_TASK)					\
-	: "cc",								\
-	        "g1", "g2", "g3",                   "g7",		\
-	        "l1", "l2", "l3", "l4", "l5", "l6", "l7",		\
-	  "i0", "i1", "i2", "i3", "i4", "i5",				\
-	  "o0", "o1", "o2", "o3", "o4", "o5",       "o7");		\
-} while(0)
-
-static inline unsigned long xchg32(__volatile__ unsigned int *m, unsigned int val)
-{
-	unsigned long tmp1, tmp2;
-
-	__asm__ __volatile__(
-"	mov		%0, %1\n"
-"1:	lduw		[%4], %2\n"
-"	cas		[%4], %2, %0\n"
-"	cmp		%2, %0\n"
-"	bne,a,pn	%%icc, 1b\n"
-"	 mov		%1, %0\n"
-	: "=&r" (val), "=&r" (tmp1), "=&r" (tmp2)
-	: "0" (val), "r" (m)
-	: "cc", "memory");
-	return val;
-}
-
-static inline unsigned long xchg64(__volatile__ unsigned long *m, unsigned long val)
-{
-	unsigned long tmp1, tmp2;
-
-	__asm__ __volatile__(
-"	mov		%0, %1\n"
-"1:	ldx		[%4], %2\n"
-"	casx		[%4], %2, %0\n"
-"	cmp		%2, %0\n"
-"	bne,a,pn	%%xcc, 1b\n"
-"	 mov		%1, %0\n"
-	: "=&r" (val), "=&r" (tmp1), "=&r" (tmp2)
-	: "0" (val), "r" (m)
-	: "cc", "memory");
-	return val;
-}
-
-#define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-
-extern void __xchg_called_with_bad_pointer(void);
-
-static inline unsigned long __xchg(unsigned long x, __volatile__ void * ptr,
-				       int size)
-{
-	switch (size) {
-	case 4:
-		return xchg32(ptr, x);
-	case 8:
-		return xchg64(ptr, x);
-	}
-	__xchg_called_with_bad_pointer();
-	return x;
-}
-
-extern void die_if_kernel(char *str, struct pt_regs *regs) __attribute__ ((noreturn));
-
-/*
- * Atomic compare and exchange.  Compare OLD with MEM, if identical,
- * store NEW in MEM.  Return the initial value in MEM.  Success is
- * indicated by comparing RETURN with OLD.
- */
-
-#define __HAVE_ARCH_CMPXCHG 1
-
-static inline unsigned long
-__cmpxchg_u32(volatile int *m, int old, int new)
-{
-	__asm__ __volatile__("cas [%2], %3, %0"
-			     : "=&r" (new)
-			     : "0" (new), "r" (m), "r" (old)
-			     : "memory");
-
-	return new;
-}
-
-static inline unsigned long
-__cmpxchg_u64(volatile long *m, unsigned long old, unsigned long new)
-{
-	__asm__ __volatile__("casx [%2], %3, %0"
-			     : "=&r" (new)
-			     : "0" (new), "r" (m), "r" (old)
-			     : "memory");
-
-	return new;
-}
-
-/* This function doesn't exist, so you'll get a linker error
-   if something tries to do an invalid cmpxchg().  */
-extern void __cmpxchg_called_with_bad_pointer(void);
-
-static inline unsigned long
-__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new, int size)
-{
-	switch (size) {
-		case 4:
-			return __cmpxchg_u32(ptr, old, new);
-		case 8:
-			return __cmpxchg_u64(ptr, old, new);
-	}
-	__cmpxchg_called_with_bad_pointer();
-	return old;
-}
-
-#define cmpxchg(ptr,o,n)						 \
-  ({									 \
-     __typeof__(*(ptr)) _o_ = (o);					 \
-     __typeof__(*(ptr)) _n_ = (n);					 \
-     (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		 \
-				    (unsigned long)_n_, sizeof(*(ptr))); \
-  })
-
-/*
- * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
- * them available.
- */
-
-static inline unsigned long __cmpxchg_local(volatile void *ptr,
-				      unsigned long old,
-				      unsigned long new, int size)
-{
-	switch (size) {
-	case 4:
-	case 8:	return __cmpxchg(ptr, old, new, size);
-	default:
-		return __cmpxchg_local_generic(ptr, old, new, size);
-	}
-
-	return old;
-}
-
-#define cmpxchg_local(ptr, o, n)				  	\
-	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
-			(unsigned long)(n), sizeof(*(ptr))))
-#define cmpxchg64_local(ptr, o, n)					\
-  ({									\
-	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
-	cmpxchg_local((ptr), (o), (n));					\
-  })
-
-#endif /* !(__ASSEMBLY__) */
-
-#define arch_align_stack(x) (x)
-
-#endif /* !(__SPARC64_SYSTEM_H) */
diff --git a/arch/sparc/include/asm/timer_32.h b/arch/sparc/include/asm/timer_32.h
index 2ec030e..1a91e11 100644
--- a/arch/sparc/include/asm/timer_32.h
+++ b/arch/sparc/include/asm/timer_32.h
@@ -8,12 +8,13 @@
 #ifndef _SPARC_TIMER_H
 #define _SPARC_TIMER_H
 
-#include <asm/system.h>  /* For SUN4M_NCPUS */
+#include <asm/cpu_type.h>  /* For SUN4M_NCPUS */
 #include <asm/btfixup.h>
 
 extern __volatile__ unsigned int *master_l10_counter;
 
 /* FIXME: Make do_[gs]ettimeofday btfixup calls */
+struct timespec;
 BTFIXUPDEF_CALL(int, bus_do_settimeofday, struct timespec *tv)
 #define bus_do_settimeofday(tv) BTFIXUP_CALL(bus_do_settimeofday)(tv)
 
diff --git a/arch/sparc/include/asm/uaccess_64.h b/arch/sparc/include/asm/uaccess_64.h
index 3e1449f..a1091afb 100644
--- a/arch/sparc/include/asm/uaccess_64.h
+++ b/arch/sparc/include/asm/uaccess_64.h
@@ -11,7 +11,6 @@
 #include <linux/string.h>
 #include <linux/thread_info.h>
 #include <asm/asi.h>
-#include <asm/system.h>
 #include <asm/spitfire.h>
 #include <asm-generic/uaccess-unaligned.h>
 #endif
diff --git a/arch/sparc/kernel/auxio_32.c b/arch/sparc/kernel/auxio_32.c
index f7ea8f0..56d0f52 100644
--- a/arch/sparc/kernel/auxio_32.c
+++ b/arch/sparc/kernel/auxio_32.c
@@ -13,6 +13,7 @@
 #include <asm/io.h>
 #include <asm/auxio.h>
 #include <asm/string.h>		/* memset(), Linux has no bzero() */
+#include <asm/cpu_type.h>
 
 /* Probe and map in the Auxiliary I/O register */
 
diff --git a/arch/sparc/kernel/devices.c b/arch/sparc/kernel/devices.c
index 113c052..6b2f56a 100644
--- a/arch/sparc/kernel/devices.c
+++ b/arch/sparc/kernel/devices.c
@@ -17,8 +17,8 @@
 #include <asm/oplib.h>
 #include <asm/prom.h>
 #include <asm/smp.h>
-#include <asm/system.h>
 #include <asm/cpudata.h>
+#include <asm/cpu_type.h>
 
 extern void clock_stop_probe(void); /* tadpole.c */
 extern void sun4c_probe_memerr_reg(void);
diff --git a/arch/sparc/kernel/irq.h b/arch/sparc/kernel/irq.h
index 4285112..5a021dd 100644
--- a/arch/sparc/kernel/irq.h
+++ b/arch/sparc/kernel/irq.h
@@ -1,6 +1,7 @@
 #include <linux/platform_device.h>
 
 #include <asm/btfixup.h>
+#include <asm/cpu_type.h>
 
 struct irq_bucket {
         struct irq_bucket *next;
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index d45b710..dff2c3d 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -26,7 +26,6 @@
 #include <asm/ptrace.h>
 #include <asm/processor.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/io.h>
 #include <asm/iommu.h>
diff --git a/arch/sparc/kernel/kgdb_32.c b/arch/sparc/kernel/kgdb_32.c
index 539243b..2e424a5 100644
--- a/arch/sparc/kernel/kgdb_32.c
+++ b/arch/sparc/kernel/kgdb_32.c
@@ -9,6 +9,7 @@
 #include <asm/kdebug.h>
 #include <asm/ptrace.h>
 #include <asm/irq.h>
+#include <asm/cacheflush.h>
 
 extern unsigned long trapbase;
 
diff --git a/arch/sparc/kernel/module.c b/arch/sparc/kernel/module.c
index e551987..276359e 100644
--- a/arch/sparc/kernel/module.c
+++ b/arch/sparc/kernel/module.c
@@ -16,6 +16,7 @@
 
 #include <asm/processor.h>
 #include <asm/spitfire.h>
+#include <asm/cacheflush.h>
 
 #include "entry.h"
 
diff --git a/arch/sparc/kernel/muldiv.c b/arch/sparc/kernel/muldiv.c
index 6ce1021..f7db516 100644
--- a/arch/sparc/kernel/muldiv.c
+++ b/arch/sparc/kernel/muldiv.c
@@ -14,7 +14,6 @@
 #include <linux/mm.h>
 #include <asm/ptrace.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #include "kernel.h"
diff --git a/arch/sparc/kernel/nmi.c b/arch/sparc/kernel/nmi.c
index c76fe0b..eb1c1f0 100644
--- a/arch/sparc/kernel/nmi.c
+++ b/arch/sparc/kernel/nmi.c
@@ -22,6 +22,7 @@
 #include <asm/perf_event.h>
 #include <asm/ptrace.h>
 #include <asm/pcr.h>
+#include <asm/perfctr.h>
 
 #include "kstack.h"
 
diff --git a/arch/sparc/kernel/pcr.c b/arch/sparc/kernel/pcr.c
index a24072a..0ce0dd2 100644
--- a/arch/sparc/kernel/pcr.c
+++ b/arch/sparc/kernel/pcr.c
@@ -14,6 +14,7 @@
 #include <asm/pcr.h>
 #include <asm/nmi.h>
 #include <asm/spitfire.h>
+#include <asm/perfctr.h>
 
 /* This code is shared between various users of the performance
  * counters.  Users will be oprofile, pseudo-NMI watchdog, and the
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 614da62..4361286 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -25,6 +25,8 @@
 #include <linux/atomic.h>
 #include <asm/nmi.h>
 #include <asm/pcr.h>
+#include <asm/perfctr.h>
+#include <asm/cacheflush.h>
 
 #include "kernel.h"
 #include "kstack.h"
diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
index f793742..8a91a0c 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -28,7 +28,6 @@
 #include <asm/auxio.h>
 #include <asm/oplib.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
@@ -38,6 +37,7 @@
 #include <asm/elf.h>
 #include <asm/prom.h>
 #include <asm/unistd.h>
+#include <asm/setup.h>
 
 /* 
  * Power management idle function 
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 39d8b05..5099c6d 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -32,7 +32,6 @@
 #include <linux/nmi.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
diff --git a/arch/sparc/kernel/ptrace_32.c b/arch/sparc/kernel/ptrace_32.c
index 27b9e93..896ba7c 100644
--- a/arch/sparc/kernel/ptrace_32.c
+++ b/arch/sparc/kernel/ptrace_32.c
@@ -23,8 +23,8 @@
 #include <linux/tracehook.h>
 
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
+#include <asm/cacheflush.h>
 
 /* #define ALLOW_INIT_TRACING */
 
diff --git a/arch/sparc/kernel/ptrace_64.c b/arch/sparc/kernel/ptrace_64.c
index 9388844..6f97c07 100644
--- a/arch/sparc/kernel/ptrace_64.c
+++ b/arch/sparc/kernel/ptrace_64.c
@@ -29,7 +29,6 @@
 
 #include <asm/asi.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/psrcompat.h>
 #include <asm/visasm.h>
diff --git a/arch/sparc/kernel/reboot.c b/arch/sparc/kernel/reboot.c
index 006a42d..eba7d91 100644
--- a/arch/sparc/kernel/reboot.c
+++ b/arch/sparc/kernel/reboot.c
@@ -7,9 +7,9 @@
 #include <linux/export.h>
 #include <linux/pm.h>
 
-#include <asm/system.h>
 #include <asm/oplib.h>
 #include <asm/prom.h>
+#include <asm/setup.h>
 
 /* sysctl - toggle power-off restriction for serial console
  * systems in machine_power_off()
diff --git a/arch/sparc/kernel/setup_32.c b/arch/sparc/kernel/setup_32.c
index ffb883d..d444468 100644
--- a/arch/sparc/kernel/setup_32.c
+++ b/arch/sparc/kernel/setup_32.c
@@ -33,7 +33,6 @@
 #include <linux/kdebug.h>
 #include <linux/export.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/oplib.h>
@@ -46,6 +45,7 @@
 #include <asm/machines.h>
 #include <asm/cpudata.h>
 #include <asm/setup.h>
+#include <asm/cacheflush.h>
 
 #include "kernel.h"
 
diff --git a/arch/sparc/kernel/setup_64.c b/arch/sparc/kernel/setup_64.c
index a854a1c..1414d16 100644
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -31,7 +31,6 @@
 #include <linux/initrd.h>
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/oplib.h>
@@ -49,6 +48,7 @@
 #include <asm/btext.h>
 #include <asm/elf.h>
 #include <asm/mdesc.h>
+#include <asm/cacheflush.h>
 
 #ifdef CONFIG_IP_PNP
 #include <net/ipconfig.h>
diff --git a/arch/sparc/kernel/signal32.c b/arch/sparc/kernel/signal32.c
index 023b886..df3e6c8 100644
--- a/arch/sparc/kernel/signal32.c
+++ b/arch/sparc/kernel/signal32.c
@@ -28,6 +28,7 @@
 #include <asm/fpumacro.h>
 #include <asm/visasm.h>
 #include <asm/compat_signal.h>
+#include <asm/switch_to.h>
 
 #include "sigutil.h"
 
diff --git a/arch/sparc/kernel/signal_32.c b/arch/sparc/kernel/signal_32.c
index d54c6e5..d260126 100644
--- a/arch/sparc/kernel/signal_32.c
+++ b/arch/sparc/kernel/signal_32.c
@@ -25,6 +25,7 @@
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>	/* flush_sig_insns */
+#include <asm/switch_to.h>
 
 #include "sigutil.h"
 
diff --git a/arch/sparc/kernel/signal_64.c b/arch/sparc/kernel/signal_64.c
index f0836cd..4e50215 100644
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -31,6 +31,8 @@
 #include <asm/uctx.h>
 #include <asm/siginfo.h>
 #include <asm/visasm.h>
+#include <asm/switch_to.h>
+#include <asm/cacheflush.h>
 
 #include "entry.h"
 #include "systbls.h"
diff --git a/arch/sparc/kernel/sigutil_32.c b/arch/sparc/kernel/sigutil_32.c
index 35c7897..0f6eebe 100644
--- a/arch/sparc/kernel/sigutil_32.c
+++ b/arch/sparc/kernel/sigutil_32.c
@@ -7,6 +7,7 @@
 #include <asm/sigcontext.h>
 #include <asm/fpumacro.h>
 #include <asm/ptrace.h>
+#include <asm/switch_to.h>
 
 #include "sigutil.h"
 
diff --git a/arch/sparc/kernel/sigutil_64.c b/arch/sparc/kernel/sigutil_64.c
index b19570d..387834a 100644
--- a/arch/sparc/kernel/sigutil_64.c
+++ b/arch/sparc/kernel/sigutil_64.c
@@ -7,6 +7,7 @@
 #include <asm/sigcontext.h>
 #include <asm/fpumacro.h>
 #include <asm/ptrace.h>
+#include <asm/switch_to.h>
 
 #include "sigutil.h"
 
diff --git a/arch/sparc/kernel/sparc_ksyms_64.c b/arch/sparc/kernel/sparc_ksyms_64.c
index 12ff098..9f5e24d 100644
--- a/arch/sparc/kernel/sparc_ksyms_64.c
+++ b/arch/sparc/kernel/sparc_ksyms_64.c
@@ -10,12 +10,12 @@
 #include <linux/init.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/cpudata.h>
 #include <asm/uaccess.h>
 #include <asm/spitfire.h>
 #include <asm/oplib.h>
 #include <asm/hypervisor.h>
+#include <asm/cacheflush.h>
 
 struct poll {
 	int fd;
diff --git a/arch/sparc/kernel/time_32.c b/arch/sparc/kernel/time_32.c
index 1060e06..7d0c088 100644
--- a/arch/sparc/kernel/time_32.c
+++ b/arch/sparc/kernel/time_32.c
@@ -37,7 +37,6 @@
 #include <asm/oplib.h>
 #include <asm/timex.h>
 #include <asm/timer.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/io.h>
 #include <asm/idprom.h>
diff --git a/arch/sparc/kernel/traps_32.c b/arch/sparc/kernel/traps_32.c
index 591f20c..d2de213 100644
--- a/arch/sparc/kernel/traps_32.c
+++ b/arch/sparc/kernel/traps_32.c
@@ -17,7 +17,6 @@
 #include <linux/export.h>
 
 #include <asm/delay.h>
-#include <asm/system.h>
 #include <asm/ptrace.h>
 #include <asm/oplib.h>
 #include <asm/page.h>
diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index 0cbdaa4..c72fdf5 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -22,7 +22,6 @@
 
 #include <asm/smp.h>
 #include <asm/delay.h>
-#include <asm/system.h>
 #include <asm/ptrace.h>
 #include <asm/oplib.h>
 #include <asm/page.h>
@@ -41,6 +40,7 @@
 #include <asm/head.h>
 #include <asm/prom.h>
 #include <asm/memctrl.h>
+#include <asm/cacheflush.h>
 
 #include "entry.h"
 #include "kstack.h"
diff --git a/arch/sparc/kernel/unaligned_32.c b/arch/sparc/kernel/unaligned_32.c
index 4d043a1..c0ec897 100644
--- a/arch/sparc/kernel/unaligned_32.c
+++ b/arch/sparc/kernel/unaligned_32.c
@@ -12,7 +12,6 @@
 #include <linux/mm.h>
 #include <asm/ptrace.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/smp.h>
 #include <linux/perf_event.h>
diff --git a/arch/sparc/kernel/unaligned_64.c b/arch/sparc/kernel/unaligned_64.c
index 76e4ac1..dae85bc 100644
--- a/arch/sparc/kernel/unaligned_64.c
+++ b/arch/sparc/kernel/unaligned_64.c
@@ -16,7 +16,6 @@
 #include <asm/ptrace.h>
 #include <asm/pstate.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/smp.h>
 #include <linux/bitops.h>
@@ -24,6 +23,7 @@
 #include <linux/ratelimit.h>
 #include <linux/bitops.h>
 #include <asm/fpumacro.h>
+#include <asm/cacheflush.h>
 
 enum direction {
 	load,    /* ld, ldd, ldh, ldsh */
diff --git a/arch/sparc/kernel/visemul.c b/arch/sparc/kernel/visemul.c
index 7337067..08e074b7 100644
--- a/arch/sparc/kernel/visemul.c
+++ b/arch/sparc/kernel/visemul.c
@@ -9,9 +9,9 @@
 
 #include <asm/ptrace.h>
 #include <asm/pstate.h>
-#include <asm/system.h>
 #include <asm/fpumacro.h>
 #include <asm/uaccess.h>
+#include <asm/cacheflush.h>
 
 /* OPF field of various VIS instructions.  */
 
diff --git a/arch/sparc/math-emu/math_64.c b/arch/sparc/math-emu/math_64.c
index e575bd2..2bbe2f2 100644
--- a/arch/sparc/math-emu/math_64.c
+++ b/arch/sparc/math-emu/math_64.c
@@ -16,6 +16,7 @@
 #include <asm/fpumacro.h>
 #include <asm/ptrace.h>
 #include <asm/uaccess.h>
+#include <asm/cacheflush.h>
 
 #include "sfp-util_64.h"
 #include <math-emu/soft-fp.h>
diff --git a/arch/sparc/mm/btfixup.c b/arch/sparc/mm/btfixup.c
index 8a7f817..09d6af2 100644
--- a/arch/sparc/mm/btfixup.c
+++ b/arch/sparc/mm/btfixup.c
@@ -12,7 +12,6 @@
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 #include <asm/oplib.h>
-#include <asm/system.h>
 #include <asm/cacheflush.h>
 
 #define BTFIXUP_OPTIMIZE_NOP
diff --git a/arch/sparc/mm/fault_32.c b/arch/sparc/mm/fault_32.c
index 8023fd7..7705c67 100644
--- a/arch/sparc/mm/fault_32.c
+++ b/arch/sparc/mm/fault_32.c
@@ -22,7 +22,6 @@
 #include <linux/interrupt.h>
 #include <linux/kdebug.h>
 
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/memreg.h>
diff --git a/arch/sparc/mm/init_32.c b/arch/sparc/mm/init_32.c
index 7b00de6..c5f9021 100644
--- a/arch/sparc/mm/init_32.c
+++ b/arch/sparc/mm/init_32.c
@@ -27,7 +27,6 @@
 #include <linux/gfp.h>
 
 #include <asm/sections.h>
-#include <asm/system.h>
 #include <asm/vac-ops.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index b3f5e7d..21faaee 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -28,7 +28,6 @@
 #include <linux/gfp.h>
 
 #include <asm/head.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
diff --git a/arch/sparc/mm/loadmmu.c b/arch/sparc/mm/loadmmu.c
index 82ec8f6..c5bf2a6 100644
--- a/arch/sparc/mm/loadmmu.c
+++ b/arch/sparc/mm/loadmmu.c
@@ -11,7 +11,6 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
index 536412d..c52add7 100644
--- a/arch/sparc/mm/tsb.c
+++ b/arch/sparc/mm/tsb.c
@@ -6,7 +6,6 @@
 #include <linux/kernel.h>
 #include <linux/preempt.h>
 #include <linux/slab.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
diff --git a/arch/sparc/prom/console_32.c b/arch/sparc/prom/console_32.c
index a00f47b..1cfb50f 100644
--- a/arch/sparc/prom/console_32.c
+++ b/arch/sparc/prom/console_32.c
@@ -11,7 +11,6 @@
 #include <linux/sched.h>
 #include <asm/openprom.h>
 #include <asm/oplib.h>
-#include <asm/system.h>
 #include <linux/string.h>
 
 extern void restore_current(void);
diff --git a/arch/sparc/prom/console_64.c b/arch/sparc/prom/console_64.c
index 9de6c8c..f95edcc 100644
--- a/arch/sparc/prom/console_64.c
+++ b/arch/sparc/prom/console_64.c
@@ -10,7 +10,6 @@
 #include <linux/sched.h>
 #include <asm/openprom.h>
 #include <asm/oplib.h>
-#include <asm/system.h>
 #include <linux/string.h>
 
 static int __prom_console_write_buf(const char *buf, int len)
diff --git a/arch/sparc/prom/misc_32.c b/arch/sparc/prom/misc_32.c
index 677b6a1..8dc0b6b 100644
--- a/arch/sparc/prom/misc_32.c
+++ b/arch/sparc/prom/misc_32.c
@@ -13,7 +13,6 @@
 #include <asm/openprom.h>
 #include <asm/oplib.h>
 #include <asm/auxio.h>
-#include <asm/system.h>
 
 extern void restore_current(void);
 
diff --git a/arch/sparc/prom/misc_64.c b/arch/sparc/prom/misc_64.c
index e4f31d4..f178b9d 100644
--- a/arch/sparc/prom/misc_64.c
+++ b/arch/sparc/prom/misc_64.c
@@ -15,7 +15,6 @@
 
 #include <asm/openprom.h>
 #include <asm/oplib.h>
-#include <asm/system.h>
 #include <asm/ldc.h>
 
 static int prom_service_exists(const char *service_name)
diff --git a/arch/sparc/prom/p1275.c b/arch/sparc/prom/p1275.c
index d9850c2..04a4540 100644
--- a/arch/sparc/prom/p1275.c
+++ b/arch/sparc/prom/p1275.c
@@ -13,7 +13,6 @@
 
 #include <asm/openprom.h>
 #include <asm/oplib.h>
-#include <asm/system.h>
 #include <asm/spitfire.h>
 #include <asm/pstate.h>
 #include <asm/ldc.h>
diff --git a/arch/sparc/prom/ranges.c b/arch/sparc/prom/ranges.c
index 0857aa9..ad143c1 100644
--- a/arch/sparc/prom/ranges.c
+++ b/arch/sparc/prom/ranges.c
@@ -11,7 +11,6 @@
 #include <asm/openprom.h>
 #include <asm/oplib.h>
 #include <asm/types.h>
-#include <asm/system.h>
 
 static struct linux_prom_ranges promlib_obio_ranges[PROMREG_MAX];
 static int num_obio_ranges;
diff --git a/drivers/tty/serial/sunhv.c b/drivers/tty/serial/sunhv.c
index c0b7246..143fb50 100644
--- a/drivers/tty/serial/sunhv.c
+++ b/drivers/tty/serial/sunhv.c
@@ -23,6 +23,7 @@
 #include <asm/spitfire.h>
 #include <asm/prom.h>
 #include <asm/irq.h>
+#include <asm/setup.h>
 
 #if defined(CONFIG_MAGIC_SYSRQ)
 #define SUPPORT_SYSRQ
diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index b5fa2a5..3b63165 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -37,6 +37,7 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/prom.h>
+#include <asm/setup.h>
 
 #if defined(CONFIG_SERIAL_SUNSAB_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
 #define SUPPORT_SYSRQ
diff --git a/drivers/tty/serial/sunsu.c b/drivers/tty/serial/sunsu.c
index ad0f8f5..c53d737 100644
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -41,6 +41,7 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/prom.h>
+#include <asm/setup.h>
 
 #if defined(CONFIG_SERIAL_SUNSU_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
 #define SUPPORT_SYSRQ
diff --git a/drivers/tty/serial/sunzilog.c b/drivers/tty/serial/sunzilog.c
index 8e916e7..f0ca0ac 100644
--- a/drivers/tty/serial/sunzilog.c
+++ b/drivers/tty/serial/sunzilog.c
@@ -37,6 +37,7 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/prom.h>
+#include <asm/setup.h>
 
 #if defined(CONFIG_SERIAL_SUNZILOG_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
 #define SUPPORT_SYSRQ
diff --git a/kernel/signal.c b/kernel/signal.c
index c73c428..9c78afd 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -36,6 +36,7 @@
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include <asm/siginfo.h>
+#include <asm/cacheflush.h>
 #include "audit.h"	/* audit_signal_info() */
 
 /*
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f487f25..0063bc4 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -67,6 +67,9 @@
 #include <asm/stacktrace.h>
 #include <asm/io.h>
 #endif
+#ifdef CONFIG_SPARC
+#include <asm/setup.h>
+#endif
 #ifdef CONFIG_BSD_PROCESS_ACCT
 #include <linux/acct.h>
 #endif


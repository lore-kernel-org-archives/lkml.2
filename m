Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030517Ab2CGTvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:51:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030312Ab2CGTu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:50:59 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 25/29] Disintegrate asm/system.h for Sparc
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:50:34 +0000
Message-ID: <20120307195034.15987.13239.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for Sparc.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/sparc/include/asm/atomic_32.h     |   97 +++++++++
 arch/sparc/include/asm/atomic_64.h     |  137 +++++++++++++
 arch/sparc/include/asm/barrier.h       |    8 +
 arch/sparc/include/asm/barrier_32.h    |   15 +
 arch/sparc/include/asm/barrier_64.h    |   56 +++++
 arch/sparc/include/asm/bug.h           |    3 
 arch/sparc/include/asm/cacheflush_32.h |    9 +
 arch/sparc/include/asm/cacheflush_64.h |   10 +
 arch/sparc/include/asm/cpu_type.h      |   34 +++
 arch/sparc/include/asm/exec.h          |    6 +
 arch/sparc/include/asm/irqflags_32.h   |    1 
 arch/sparc/include/asm/perfctr.h       |   23 ++
 arch/sparc/include/asm/pgtable_32.h    |    1 
 arch/sparc/include/asm/processor.h     |    3 
 arch/sparc/include/asm/processor_64.h  |    3 
 arch/sparc/include/asm/ptrace.h        |    2 
 arch/sparc/include/asm/setup.h         |   16 ++
 arch/sparc/include/asm/switch_to.h     |    8 +
 arch/sparc/include/asm/switch_to_32.h  |  106 ++++++++++
 arch/sparc/include/asm/switch_to_64.h  |   73 +++++++
 arch/sparc/include/asm/system.h        |    8 -
 arch/sparc/include/asm/system_32.h     |  284 ---------------------------
 arch/sparc/include/asm/system_64.h     |  331 --------------------------------
 arch/sparc/include/asm/timer_32.h      |    3 
 arch/sparc/kernel/auxio_32.c           |    1 
 arch/sparc/kernel/devices.c            |    1 
 arch/sparc/kernel/irq.h                |    1 
 arch/sparc/kernel/kgdb_32.c            |    1 
 arch/sparc/kernel/module.c             |    1 
 arch/sparc/kernel/nmi.c                |    1 
 arch/sparc/kernel/pcr.c                |    1 
 arch/sparc/kernel/perf_event.c         |    2 
 arch/sparc/kernel/process_32.c         |    1 
 arch/sparc/kernel/ptrace_32.c          |    1 
 arch/sparc/kernel/reboot.c             |    1 
 arch/sparc/kernel/setup_32.c           |    1 
 arch/sparc/kernel/setup_64.c           |    1 
 arch/sparc/kernel/signal32.c           |    1 
 arch/sparc/kernel/signal_32.c          |    1 
 arch/sparc/kernel/signal_64.c          |    2 
 arch/sparc/kernel/sigutil_32.c         |    1 
 arch/sparc/kernel/sigutil_64.c         |    1 
 arch/sparc/kernel/sparc_ksyms_64.c     |    1 
 arch/sparc/kernel/traps_64.c           |    1 
 arch/sparc/kernel/unaligned_64.c       |    1 
 arch/sparc/kernel/visemul.c            |    1 
 arch/sparc/math-emu/math_64.c          |    1 
 drivers/tty/serial/sunhv.c             |    1 
 drivers/tty/serial/sunsab.c            |    1 
 drivers/tty/serial/sunsu.c             |    1 
 drivers/tty/serial/sunzilog.c          |    1 
 kernel/signal.c                        |    2 
 kernel/sysctl.c                        |    3 
 53 files changed, 646 insertions(+), 625 deletions(-)
 create mode 100644 arch/sparc/include/asm/barrier.h
 create mode 100644 arch/sparc/include/asm/barrier_32.h
 create mode 100644 arch/sparc/include/asm/barrier_64.h
 create mode 100644 arch/sparc/include/asm/cpu_type.h
 create mode 100644 arch/sparc/include/asm/exec.h
 create mode 100644 arch/sparc/include/asm/switch_to.h
 create mode 100644 arch/sparc/include/asm/switch_to_32.h
 create mode 100644 arch/sparc/include/asm/switch_to_64.h
 delete mode 100644 arch/sparc/include/asm/system.h
 delete mode 100644 arch/sparc/include/asm/system_32.h
 delete mode 100644 arch/sparc/include/asm/system_64.h

diff --git a/arch/sparc/include/asm/atomic_32.h b/arch/sparc/include/asm/atomic_32.h
index e6d75af..21fec1b 100644
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -12,6 +12,7 @@
 #define __ARCH_SPARC_ATOMIC__
 
 #include <linux/types.h>
+#include <asm/btfixup.h>
 
 #include <asm-generic/atomic64.h>
 
@@ -57,4 +58,100 @@ extern void atomic_set(atomic_t *, int);
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
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
 #endif /* !(__ARCH_SPARC_ATOMIC__) */
diff --git a/arch/sparc/include/asm/atomic_64.h b/arch/sparc/include/asm/atomic_64.h
index 5ab4e89..913b45e 100644
--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -66,6 +66,142 @@ extern long atomic64_sub_ret(long, atomic64_t *);
 #define atomic_add_negative(i, v) (atomic_add_ret(i, v) < 0)
 #define atomic64_add_negative(i, v) (atomic64_add_ret(i, v) < 0)
 
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
 #define atomic_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
@@ -84,7 +220,6 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 	return c;
 }
 
-
 #define atomic64_cmpxchg(v, o, n) \
 	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
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
index 496664b..3d71018 100644
--- a/arch/sparc/include/asm/pgtable_32.h
+++ b/arch/sparc/include/asm/pgtable_32.h
@@ -21,6 +21,7 @@
 #include <asm/vac-ops.h>
 #include <asm/oplib.h>
 #include <asm/btfixup.h>
+#include <asm/cpu_type.h>
 
 
 struct vm_area_struct;
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
index 0495388..afba9f2 100644
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
index 0000000..eb5121b
--- /dev/null
+++ b/arch/sparc/include/asm/switch_to_64.h
@@ -0,0 +1,73 @@
+#ifndef __SPARC64_SWITCH_TO_64_H
+#define __SPARC64_SWITCH_TO_64_H
+
+#include <asm/visasm.h>
+#include <asm/cacheflush.h>
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
deleted file mode 100644
index 7944a7c..0000000
--- a/arch/sparc/include/asm/system.h
+++ /dev/null
@@ -1,8 +0,0 @@
-#ifndef ___ASM_SPARC_SYSTEM_H
-#define ___ASM_SPARC_SYSTEM_H
-#if defined(__sparc__) && defined(__arch64__)
-#include <asm/system_64.h>
-#else
-#include <asm/system_32.h>
-#endif
-#endif
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
index 876c9f6..6b2f56a 100644
--- a/arch/sparc/kernel/devices.c
+++ b/arch/sparc/kernel/devices.c
@@ -18,6 +18,7 @@
 #include <asm/prom.h>
 #include <asm/smp.h>
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
index a2050b3..8a91a0c 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -37,6 +37,7 @@
 #include <asm/elf.h>
 #include <asm/prom.h>
 #include <asm/unistd.h>
+#include <asm/setup.h>
 
 /* 
  * Power management idle function 
diff --git a/arch/sparc/kernel/ptrace_32.c b/arch/sparc/kernel/ptrace_32.c
index 38af4a8..896ba7c 100644
--- a/arch/sparc/kernel/ptrace_32.c
+++ b/arch/sparc/kernel/ptrace_32.c
@@ -24,6 +24,7 @@
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
+#include <asm/cacheflush.h>
 
 /* #define ALLOW_INIT_TRACING */
 
diff --git a/arch/sparc/kernel/reboot.c b/arch/sparc/kernel/reboot.c
index 5384d56..eba7d91 100644
--- a/arch/sparc/kernel/reboot.c
+++ b/arch/sparc/kernel/reboot.c
@@ -9,6 +9,7 @@
 
 #include <asm/oplib.h>
 #include <asm/prom.h>
+#include <asm/setup.h>
 
 /* sysctl - toggle power-off restriction for serial console
  * systems in machine_power_off()
diff --git a/arch/sparc/kernel/setup_32.c b/arch/sparc/kernel/setup_32.c
index 010f719..d444468 100644
--- a/arch/sparc/kernel/setup_32.c
+++ b/arch/sparc/kernel/setup_32.c
@@ -45,6 +45,7 @@
 #include <asm/machines.h>
 #include <asm/cpudata.h>
 #include <asm/setup.h>
+#include <asm/cacheflush.h>
 
 #include "kernel.h"
 
diff --git a/arch/sparc/kernel/setup_64.c b/arch/sparc/kernel/setup_64.c
index 0a6b078..1414d16 100644
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -48,6 +48,7 @@
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
index af39e3f..9f5e24d 100644
--- a/arch/sparc/kernel/sparc_ksyms_64.c
+++ b/arch/sparc/kernel/sparc_ksyms_64.c
@@ -15,6 +15,7 @@
 #include <asm/spitfire.h>
 #include <asm/oplib.h>
 #include <asm/hypervisor.h>
+#include <asm/cacheflush.h>
 
 struct poll {
 	int fd;
diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index bd3d285..c72fdf5 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -40,6 +40,7 @@
 #include <asm/head.h>
 #include <asm/prom.h>
 #include <asm/memctrl.h>
+#include <asm/cacheflush.h>
 
 #include "entry.h"
 #include "kstack.h"
diff --git a/arch/sparc/kernel/unaligned_64.c b/arch/sparc/kernel/unaligned_64.c
index 622f653..dae85bc 100644
--- a/arch/sparc/kernel/unaligned_64.c
+++ b/arch/sparc/kernel/unaligned_64.c
@@ -23,6 +23,7 @@
 #include <linux/ratelimit.h>
 #include <linux/bitops.h>
 #include <asm/fpumacro.h>
+#include <asm/cacheflush.h>
 
 enum direction {
 	load,    /* ld, ldd, ldh, ldsh */
diff --git a/arch/sparc/kernel/visemul.c b/arch/sparc/kernel/visemul.c
index 8573025..08e074b7 100644
--- a/arch/sparc/kernel/visemul.c
+++ b/arch/sparc/kernel/visemul.c
@@ -11,6 +11,7 @@
 #include <asm/pstate.h>
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
index c73c428..7e41ae3 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -36,6 +36,8 @@
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include <asm/siginfo.h>
+#include <asm/switch_to.h>
+#include <asm/cacheflush.h>
 #include "audit.h"	/* audit_signal_info() */
 
 /*
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 79f799c..e739679 100644
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


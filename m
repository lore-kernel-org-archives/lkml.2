Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030501Ab2CGTuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:50:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030350Ab2CGTur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:50:47 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 24/29] Disintegrate asm/system.h for SH
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:50:23 +0000
Message-ID: <20120307195022.15987.36696.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for SH.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/sh/include/asm/atomic-irq.h     |    2 
 arch/sh/include/asm/atomic.h         |   53 ++++++++
 arch/sh/include/asm/auxvec.h         |    2 
 arch/sh/include/asm/barrier.h        |   54 ++++++++
 arch/sh/include/asm/bl_bit.h         |   10 +
 arch/sh/include/asm/bl_bit_32.h      |   33 +++++
 arch/sh/include/asm/bl_bit_64.h      |   38 +++++
 arch/sh/include/asm/bug.h            |    5 +
 arch/sh/include/asm/cache_insns.h    |   11 ++
 arch/sh/include/asm/cache_insns_32.h |   19 +++
 arch/sh/include/asm/cache_insns_64.h |   23 +++
 arch/sh/include/asm/exec.h           |   10 +
 arch/sh/include/asm/processor.h      |   15 ++
 arch/sh/include/asm/setup.h          |    1 
 arch/sh/include/asm/switch_to.h      |   19 +++
 arch/sh/include/asm/switch_to_32.h   |  134 +++++++++++++++++++
 arch/sh/include/asm/switch_to_64.h   |   35 +++++
 arch/sh/include/asm/system.h         |  183 --------------------------
 arch/sh/include/asm/system_32.h      |  236 ----------------------------------
 arch/sh/include/asm/system_64.h      |   79 -----------
 arch/sh/include/asm/traps.h          |   20 +++
 arch/sh/include/asm/traps_32.h       |   68 ++++++++++
 arch/sh/include/asm/traps_64.h       |   24 +++
 arch/sh/include/asm/uaccess.h        |   14 ++
 arch/sh/kernel/cpu/init.c            |    1 
 arch/sh/kernel/hw_breakpoint.c       |    1 
 arch/sh/kernel/idle.c                |    1 
 arch/sh/kernel/process_64.c          |    1 
 arch/sh/kernel/ptrace_64.c           |    1 
 arch/sh/kernel/reboot.c              |    1 
 arch/sh/kernel/traps.c               |    1 
 arch/sh/kernel/traps_32.c            |    2 
 arch/sh/mm/fault_32.c                |    1 
 arch/sh/mm/flush-sh4.c               |    1 
 34 files changed, 601 insertions(+), 498 deletions(-)
 create mode 100644 arch/sh/include/asm/barrier.h
 create mode 100644 arch/sh/include/asm/bl_bit.h
 create mode 100644 arch/sh/include/asm/bl_bit_32.h
 create mode 100644 arch/sh/include/asm/bl_bit_64.h
 create mode 100644 arch/sh/include/asm/cache_insns.h
 create mode 100644 arch/sh/include/asm/cache_insns_32.h
 create mode 100644 arch/sh/include/asm/cache_insns_64.h
 create mode 100644 arch/sh/include/asm/exec.h
 create mode 100644 arch/sh/include/asm/switch_to.h
 create mode 100644 arch/sh/include/asm/switch_to_32.h
 create mode 100644 arch/sh/include/asm/switch_to_64.h
 delete mode 100644 arch/sh/include/asm/system.h
 delete mode 100644 arch/sh/include/asm/system_32.h
 delete mode 100644 arch/sh/include/asm/system_64.h
 create mode 100644 arch/sh/include/asm/traps.h
 create mode 100644 arch/sh/include/asm/traps_32.h
 create mode 100644 arch/sh/include/asm/traps_64.h

diff --git a/arch/sh/include/asm/atomic-irq.h b/arch/sh/include/asm/atomic-irq.h
index 467d941..9f7c566 100644
--- a/arch/sh/include/asm/atomic-irq.h
+++ b/arch/sh/include/asm/atomic-irq.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_SH_ATOMIC_IRQ_H
 #define __ASM_SH_ATOMIC_IRQ_H
 
+#include <linux/irqflags.h>
+
 /*
  * To get proper branch prediction for the main line, we must branch
  * forward to code at the end of this object's .text section, then
diff --git a/arch/sh/include/asm/atomic.h b/arch/sh/include/asm/atomic.h
index 31f4a9a..de3a173 100644
--- a/arch/sh/include/asm/atomic.h
+++ b/arch/sh/include/asm/atomic.h
@@ -17,10 +17,13 @@
 
 #if defined(CONFIG_GUSA_RB)
 #include <asm/atomic-grb.h>
+#include <asm/cmpxchg-grb.h>
 #elif defined(CONFIG_CPU_SH4A)
 #include <asm/atomic-llsc.h>
+#include <asm/cmpxchg-llsc.h>
 #else
 #include <asm/atomic-irq.h>
+#include <asm/cmpxchg-irq.h>
 #endif
 
 #define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
@@ -33,6 +36,56 @@
 #define atomic_inc(v)			atomic_add(1, (v))
 #define atomic_dec(v)			atomic_sub(1, (v))
 
+extern void __xchg_called_with_bad_pointer(void);
+
+#define __xchg(ptr, x, size)				\
+({							\
+	unsigned long __xchg__res;			\
+	volatile void *__xchg_ptr = (ptr);		\
+	switch (size) {					\
+	case 4:						\
+		__xchg__res = xchg_u32(__xchg_ptr, x);	\
+		break;					\
+	case 1:						\
+		__xchg__res = xchg_u8(__xchg_ptr, x);	\
+		break;					\
+	default:					\
+		__xchg_called_with_bad_pointer();	\
+		__xchg__res = x;			\
+		break;					\
+	}						\
+							\
+	__xchg__res;					\
+})
+
+#define xchg(ptr,x)	\
+	((__typeof__(*(ptr)))__xchg((ptr),(unsigned long)(x), sizeof(*(ptr))))
+
+/* This function doesn't exist, so you'll get a linker error
+ * if something tries to do an invalid cmpxchg(). */
+extern void __cmpxchg_called_with_bad_pointer(void);
+
+#define __HAVE_ARCH_CMPXCHG 1
+
+static inline unsigned long __cmpxchg(volatile void * ptr, unsigned long old,
+		unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_u32(ptr, old, new);
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
 #define atomic_xchg(v, new)		(xchg(&((v)->counter), new))
 #define atomic_cmpxchg(v, o, n)		(cmpxchg(&((v)->counter), (o), (n)))
 
diff --git a/arch/sh/include/asm/auxvec.h b/arch/sh/include/asm/auxvec.h
index 483effd..8bcc51a 100644
--- a/arch/sh/include/asm/auxvec.h
+++ b/arch/sh/include/asm/auxvec.h
@@ -33,4 +33,6 @@
 #define AT_L1D_CACHESHAPE	35
 #define AT_L2_CACHESHAPE	36
 
+#define AT_VECTOR_SIZE_ARCH 5 /* entries in ARCH_DLINFO */
+
 #endif /* __ASM_SH_AUXVEC_H */
diff --git a/arch/sh/include/asm/barrier.h b/arch/sh/include/asm/barrier.h
new file mode 100644
index 0000000..72c103d
--- /dev/null
+++ b/arch/sh/include/asm/barrier.h
@@ -0,0 +1,54 @@
+/*
+ * Copyright (C) 1999, 2000  Niibe Yutaka  &  Kaz Kojima
+ * Copyright (C) 2002 Paul Mundt
+ */
+#ifndef __ASM_SH_BARRIER_H
+#define __ASM_SH_BARRIER_H
+
+#if defined(CONFIG_CPU_SH4A) || defined(CONFIG_CPU_SH5)
+#include <asm/cache_insns.h>
+#endif
+
+/*
+ * A brief note on ctrl_barrier(), the control register write barrier.
+ *
+ * Legacy SH cores typically require a sequence of 8 nops after
+ * modification of a control register in order for the changes to take
+ * effect. On newer cores (like the sh4a and sh5) this is accomplished
+ * with icbi.
+ *
+ * Also note that on sh4a in the icbi case we can forego a synco for the
+ * write barrier, as it's not necessary for control registers.
+ *
+ * Historically we have only done this type of barrier for the MMUCR, but
+ * it's also necessary for the CCR, so we make it generic here instead.
+ */
+#if defined(CONFIG_CPU_SH4A) || defined(CONFIG_CPU_SH5)
+#define mb()		__asm__ __volatile__ ("synco": : :"memory")
+#define rmb()		mb()
+#define wmb()		__asm__ __volatile__ ("synco": : :"memory")
+#define ctrl_barrier()	__icbi(PAGE_OFFSET)
+#define read_barrier_depends()	do { } while(0)
+#else
+#define mb()		__asm__ __volatile__ ("": : :"memory")
+#define rmb()		mb()
+#define wmb()		__asm__ __volatile__ ("": : :"memory")
+#define ctrl_barrier()	__asm__ __volatile__ ("nop;nop;nop;nop;nop;nop;nop;nop")
+#define read_barrier_depends()	do { } while(0)
+#endif
+
+#ifdef CONFIG_SMP
+#define smp_mb()	mb()
+#define smp_rmb()	rmb()
+#define smp_wmb()	wmb()
+#define smp_read_barrier_depends()	read_barrier_depends()
+#else
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#define smp_read_barrier_depends()	do { } while(0)
+#endif
+
+#define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
+
+#endif /* __ASM_SH_BARRIER_H */
diff --git a/arch/sh/include/asm/bl_bit.h b/arch/sh/include/asm/bl_bit.h
new file mode 100644
index 0000000..45e6b9f
--- /dev/null
+++ b/arch/sh/include/asm/bl_bit.h
@@ -0,0 +1,10 @@
+#ifndef __ASM_SH_BL_BIT_H
+#define __ASM_SH_BL_BIT_H
+
+#ifdef CONFIG_SUPERH32
+# include "bl_bit_32.h"
+#else
+# include "bl_bit_64.h"
+#endif
+
+#endif /* __ASM_SH_BL_BIT_H */
diff --git a/arch/sh/include/asm/bl_bit_32.h b/arch/sh/include/asm/bl_bit_32.h
new file mode 100644
index 0000000..fd21eee
--- /dev/null
+++ b/arch/sh/include/asm/bl_bit_32.h
@@ -0,0 +1,33 @@
+#ifndef __ASM_SH_BL_BIT_32_H
+#define __ASM_SH_BL_BIT_32_H
+
+static inline void set_bl_bit(void)
+{
+	unsigned long __dummy0, __dummy1;
+
+	__asm__ __volatile__ (
+		"stc	sr, %0\n\t"
+		"or	%2, %0\n\t"
+		"and	%3, %0\n\t"
+		"ldc	%0, sr\n\t"
+		: "=&r" (__dummy0), "=r" (__dummy1)
+		: "r" (0x10000000), "r" (0xffffff0f)
+		: "memory"
+	);
+}
+
+static inline void clear_bl_bit(void)
+{
+	unsigned long __dummy0, __dummy1;
+
+	__asm__ __volatile__ (
+		"stc	sr, %0\n\t"
+		"and	%2, %0\n\t"
+		"ldc	%0, sr\n\t"
+		: "=&r" (__dummy0), "=r" (__dummy1)
+		: "1" (~0x10000000)
+		: "memory"
+	);
+}
+
+#endif /* __ASM_SH_BL_BIT_32_H */
diff --git a/arch/sh/include/asm/bl_bit_64.h b/arch/sh/include/asm/bl_bit_64.h
new file mode 100644
index 0000000..8ec480c
--- /dev/null
+++ b/arch/sh/include/asm/bl_bit_64.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright (C) 2000, 2001  Paolo Alberelli
+ * Copyright (C) 2003  Paul Mundt
+ * Copyright (C) 2004  Richard Curnow
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+#ifndef __ASM_SH_BL_BIT_64_H
+#define __ASM_SH_BL_BIT_64_H
+
+#define SR_BL_LL	0x0000000010000000LL
+
+static inline void set_bl_bit(void)
+{
+	unsigned long long __dummy0, __dummy1 = SR_BL_LL;
+
+	__asm__ __volatile__("getcon	" __SR ", %0\n\t"
+			     "or	%0, %1, %0\n\t"
+			     "putcon	%0, " __SR "\n\t"
+			     : "=&r" (__dummy0)
+			     : "r" (__dummy1));
+
+}
+
+static inline void clear_bl_bit(void)
+{
+	unsigned long long __dummy0, __dummy1 = ~SR_BL_LL;
+
+	__asm__ __volatile__("getcon	" __SR ", %0\n\t"
+			     "and	%0, %1, %0\n\t"
+			     "putcon	%0, " __SR "\n\t"
+			     : "=&r" (__dummy0)
+			     : "r" (__dummy1));
+}
+
+#endif /* __ASM_SH_BL_BIT_64_H */
diff --git a/arch/sh/include/asm/bug.h b/arch/sh/include/asm/bug.h
index 6323f86..2b87d86 100644
--- a/arch/sh/include/asm/bug.h
+++ b/arch/sh/include/asm/bug.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_SH_BUG_H
 #define __ASM_SH_BUG_H
 
+#include <linux/linkage.h>
+
 #define TRAPA_BUG_OPCODE	0xc33e	/* trapa #0x3e */
 #define BUGFLAG_UNWINDER	(1 << 1)
 
@@ -107,4 +109,7 @@ do {							\
 
 #include <asm-generic/bug.h>
 
+struct pt_regs;
+extern void die(const char *str, struct pt_regs *regs, long err) __attribute__ ((noreturn));
+
 #endif /* __ASM_SH_BUG_H */
diff --git a/arch/sh/include/asm/cache_insns.h b/arch/sh/include/asm/cache_insns.h
new file mode 100644
index 0000000..d25fbe5
--- /dev/null
+++ b/arch/sh/include/asm/cache_insns.h
@@ -0,0 +1,11 @@
+#ifndef __ASM_SH_CACHE_INSNS_H
+#define __ASM_SH_CACHE_INSNS_H
+
+
+#ifdef CONFIG_SUPERH32
+# include "cache_insns_32.h"
+#else
+# include "cache_insns_64.h"
+#endif
+
+#endif /* __ASM_SH_CACHE_INSNS_H */
diff --git a/arch/sh/include/asm/cache_insns_32.h b/arch/sh/include/asm/cache_insns_32.h
new file mode 100644
index 0000000..7d1bb50
--- /dev/null
+++ b/arch/sh/include/asm/cache_insns_32.h
@@ -0,0 +1,19 @@
+#ifndef __ASM_SH_CACHE_INSNS_32_H
+#define __ASM_SH_CACHE_INSNS_32_H
+
+#if defined(CONFIG_CPU_SH4A)
+#define __icbi(addr)	__asm__ __volatile__ ( "icbi @%0\n\t" : : "r" (addr))
+#else
+#define __icbi(addr)	mb()
+#endif
+
+#define __ocbp(addr)	__asm__ __volatile__ ( "ocbp @%0\n\t" : : "r" (addr))
+#define __ocbi(addr)	__asm__ __volatile__ ( "ocbi @%0\n\t" : : "r" (addr))
+#define __ocbwb(addr)	__asm__ __volatile__ ( "ocbwb @%0\n\t" : : "r" (addr))
+
+static inline reg_size_t register_align(void *val)
+{
+	return (unsigned long)(signed long)val;
+}
+
+#endif /* __ASM_SH_CACHE_INSNS_32_H */
diff --git a/arch/sh/include/asm/cache_insns_64.h b/arch/sh/include/asm/cache_insns_64.h
new file mode 100644
index 0000000..70b6357
--- /dev/null
+++ b/arch/sh/include/asm/cache_insns_64.h
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 2000, 2001  Paolo Alberelli
+ * Copyright (C) 2003  Paul Mundt
+ * Copyright (C) 2004  Richard Curnow
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+#ifndef __ASM_SH_CACHE_INSNS_64_H
+#define __ASM_SH_CACHE_INSNS_64_H
+
+#define __icbi(addr)	__asm__ __volatile__ ( "icbi %0, 0\n\t" : : "r" (addr))
+#define __ocbp(addr)	__asm__ __volatile__ ( "ocbp %0, 0\n\t" : : "r" (addr))
+#define __ocbi(addr)	__asm__ __volatile__ ( "ocbi %0, 0\n\t" : : "r" (addr))
+#define __ocbwb(addr)	__asm__ __volatile__ ( "ocbwb %0, 0\n\t" : : "r" (addr))
+
+static inline reg_size_t register_align(void *val)
+{
+	return (unsigned long long)(signed long long)(signed long)val;
+}
+
+#endif /* __ASM_SH_CACHE_INSNS_64_H */
diff --git a/arch/sh/include/asm/exec.h b/arch/sh/include/asm/exec.h
new file mode 100644
index 0000000..69486a9
--- /dev/null
+++ b/arch/sh/include/asm/exec.h
@@ -0,0 +1,10 @@
+/*
+ * Copyright (C) 1999, 2000  Niibe Yutaka  &  Kaz Kojima
+ * Copyright (C) 2002 Paul Mundt
+ */
+#ifndef __ASM_SH_EXEC_H
+#define __ASM_SH_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* __ASM_SH_EXEC_H */
diff --git a/arch/sh/include/asm/processor.h b/arch/sh/include/asm/processor.h
index 9c7bdfc..a229c39 100644
--- a/arch/sh/include/asm/processor.h
+++ b/arch/sh/include/asm/processor.h
@@ -101,6 +101,10 @@ extern struct sh_cpuinfo cpu_data[];
 #define cpu_sleep()	__asm__ __volatile__ ("sleep" : : : "memory")
 #define cpu_relax()	barrier()
 
+void default_idle(void);
+void cpu_idle_wait(void);
+void stop_this_cpu(void *);
+
 /* Forward decl */
 struct seq_operations;
 struct task_struct;
@@ -161,6 +165,17 @@ int vsyscall_init(void);
 #define vsyscall_init() do { } while (0)
 #endif
 
+/*
+ * SH-2A has both 16 and 32-bit opcodes, do lame encoding checks.
+ */
+#ifdef CONFIG_CPU_SH2A
+extern unsigned int instruction_size(unsigned int insn);
+#elif defined(CONFIG_SUPERH32)
+#define instruction_size(insn)	(2)
+#else
+#define instruction_size(insn)	(4)
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #ifdef CONFIG_SUPERH32
diff --git a/arch/sh/include/asm/setup.h b/arch/sh/include/asm/setup.h
index 01fa17a..465a22d 100644
--- a/arch/sh/include/asm/setup.h
+++ b/arch/sh/include/asm/setup.h
@@ -20,6 +20,7 @@
 
 void sh_mv_setup(void);
 void check_for_initrd(void);
+void per_cpu_trap_init(void);
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/sh/include/asm/switch_to.h b/arch/sh/include/asm/switch_to.h
new file mode 100644
index 0000000..62b1941
--- /dev/null
+++ b/arch/sh/include/asm/switch_to.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright (C) 2000, 2001  Paolo Alberelli
+ * Copyright (C) 2003  Paul Mundt
+ * Copyright (C) 2004  Richard Curnow
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+#ifndef __ASM_SH_SWITCH_TO_H
+#define __ASM_SH_SWITCH_TO_H
+
+#ifdef CONFIG_SUPERH32
+# include "switch_to_32.h"
+#else
+# include "switch_to_64.h"
+#endif
+
+#endif /* __ASM_SH_SWITCH_TO_H */
diff --git a/arch/sh/include/asm/switch_to_32.h b/arch/sh/include/asm/switch_to_32.h
new file mode 100644
index 0000000..0c06551
--- /dev/null
+++ b/arch/sh/include/asm/switch_to_32.h
@@ -0,0 +1,134 @@
+#ifndef __ASM_SH_SWITCH_TO_32_H
+#define __ASM_SH_SWITCH_TO_32_H
+
+#ifdef CONFIG_SH_DSP
+
+#define is_dsp_enabled(tsk)						\
+	(!!(tsk->thread.dsp_status.status & SR_DSP))
+
+#define __restore_dsp(tsk)						\
+do {									\
+	register u32 *__ts2 __asm__ ("r2") =				\
+			(u32 *)&tsk->thread.dsp_status;			\
+	__asm__ __volatile__ (						\
+		".balign 4\n\t"						\
+		"movs.l	@r2+, a0\n\t"					\
+		"movs.l	@r2+, a1\n\t"					\
+		"movs.l	@r2+, a0g\n\t"					\
+		"movs.l	@r2+, a1g\n\t"					\
+		"movs.l	@r2+, m0\n\t"					\
+		"movs.l	@r2+, m1\n\t"					\
+		"movs.l	@r2+, x0\n\t"					\
+		"movs.l	@r2+, x1\n\t"					\
+		"movs.l	@r2+, y0\n\t"					\
+		"movs.l	@r2+, y1\n\t"					\
+		"lds.l	@r2+, dsr\n\t"					\
+		"ldc.l	@r2+, rs\n\t"					\
+		"ldc.l	@r2+, re\n\t"					\
+		"ldc.l	@r2+, mod\n\t"					\
+		: : "r" (__ts2));					\
+} while (0)
+
+#define __save_dsp(tsk)							\
+do {									\
+	register u32 *__ts2 __asm__ ("r2") =				\
+			(u32 *)&tsk->thread.dsp_status + 14;		\
+									\
+	__asm__ __volatile__ (						\
+		".balign 4\n\t"						\
+		"stc.l	mod, @-r2\n\t"					\
+		"stc.l	re, @-r2\n\t"					\
+		"stc.l	rs, @-r2\n\t"					\
+		"sts.l	dsr, @-r2\n\t"					\
+		"movs.l	y1, @-r2\n\t"					\
+		"movs.l	y0, @-r2\n\t"					\
+		"movs.l	x1, @-r2\n\t"					\
+		"movs.l	x0, @-r2\n\t"					\
+		"movs.l	m1, @-r2\n\t"					\
+		"movs.l	m0, @-r2\n\t"					\
+		"movs.l	a1g, @-r2\n\t"					\
+		"movs.l	a0g, @-r2\n\t"					\
+		"movs.l	a1, @-r2\n\t"					\
+		"movs.l	a0, @-r2\n\t"					\
+		: : "r" (__ts2));					\
+} while (0)
+
+#else
+
+#define is_dsp_enabled(tsk)	(0)
+#define __save_dsp(tsk)		do { } while (0)
+#define __restore_dsp(tsk)	do { } while (0)
+#endif
+
+struct task_struct *__switch_to(struct task_struct *prev,
+				struct task_struct *next);
+
+/*
+ *	switch_to() should switch tasks to task nr n, first
+ */
+#define switch_to(prev, next, last)				\
+do {								\
+	register u32 *__ts1 __asm__ ("r1");			\
+	register u32 *__ts2 __asm__ ("r2");			\
+	register u32 *__ts4 __asm__ ("r4");			\
+	register u32 *__ts5 __asm__ ("r5");			\
+	register u32 *__ts6 __asm__ ("r6");			\
+	register u32 __ts7 __asm__ ("r7");			\
+	struct task_struct *__last;				\
+								\
+	if (is_dsp_enabled(prev))				\
+		__save_dsp(prev);				\
+								\
+	__ts1 = (u32 *)&prev->thread.sp;			\
+	__ts2 = (u32 *)&prev->thread.pc;			\
+	__ts4 = (u32 *)prev;					\
+	__ts5 = (u32 *)next;					\
+	__ts6 = (u32 *)&next->thread.sp;			\
+	__ts7 = next->thread.pc;				\
+								\
+	__asm__ __volatile__ (					\
+		".balign 4\n\t"					\
+		"stc.l	gbr, @-r15\n\t"				\
+		"sts.l	pr, @-r15\n\t"				\
+		"mov.l	r8, @-r15\n\t"				\
+		"mov.l	r9, @-r15\n\t"				\
+		"mov.l	r10, @-r15\n\t"				\
+		"mov.l	r11, @-r15\n\t"				\
+		"mov.l	r12, @-r15\n\t"				\
+		"mov.l	r13, @-r15\n\t"				\
+		"mov.l	r14, @-r15\n\t"				\
+		"mov.l	r15, @r1\t! save SP\n\t"		\
+		"mov.l	@r6, r15\t! change to new stack\n\t"	\
+		"mova	1f, %0\n\t"				\
+		"mov.l	%0, @r2\t! save PC\n\t"			\
+		"mov.l	2f, %0\n\t"				\
+		"jmp	@%0\t! call __switch_to\n\t"		\
+		" lds	r7, pr\t!  with return to new PC\n\t"	\
+		".balign	4\n"				\
+		"2:\n\t"					\
+		".long	__switch_to\n"				\
+		"1:\n\t"					\
+		"mov.l	@r15+, r14\n\t"				\
+		"mov.l	@r15+, r13\n\t"				\
+		"mov.l	@r15+, r12\n\t"				\
+		"mov.l	@r15+, r11\n\t"				\
+		"mov.l	@r15+, r10\n\t"				\
+		"mov.l	@r15+, r9\n\t"				\
+		"mov.l	@r15+, r8\n\t"				\
+		"lds.l	@r15+, pr\n\t"				\
+		"ldc.l	@r15+, gbr\n\t"				\
+		: "=z" (__last)					\
+		: "r" (__ts1), "r" (__ts2), "r" (__ts4),	\
+		  "r" (__ts5), "r" (__ts6), "r" (__ts7)		\
+		: "r3", "t");					\
+								\
+	last = __last;						\
+} while (0)
+
+#define finish_arch_switch(prev)				\
+do {								\
+	if (is_dsp_enabled(prev))				\
+		__restore_dsp(prev);				\
+} while (0)
+
+#endif /* __ASM_SH_SWITCH_TO_32_H */
diff --git a/arch/sh/include/asm/switch_to_64.h b/arch/sh/include/asm/switch_to_64.h
new file mode 100644
index 0000000..ba3129d
--- /dev/null
+++ b/arch/sh/include/asm/switch_to_64.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright (C) 2000, 2001  Paolo Alberelli
+ * Copyright (C) 2003  Paul Mundt
+ * Copyright (C) 2004  Richard Curnow
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+#ifndef __ASM_SH_SWITCH_TO_64_H
+#define __ASM_SH_SWITCH_TO_64_H
+
+struct thread_struct;
+struct task_struct;
+
+/*
+ *	switch_to() should switch tasks to task nr n, first
+ */
+struct task_struct *sh64_switch_to(struct task_struct *prev,
+				   struct thread_struct *prev_thread,
+				   struct task_struct *next,
+				   struct thread_struct *next_thread);
+
+#define switch_to(prev,next,last)				\
+do {								\
+	if (last_task_used_math != next) {			\
+		struct pt_regs *regs = next->thread.uregs;	\
+		if (regs) regs->sr |= SR_FD;			\
+	}							\
+	last = sh64_switch_to(prev, &prev->thread, next,	\
+			      &next->thread);			\
+} while (0)
+
+
+#endif /* __ASM_SH_SWITCH_TO_64_H */
diff --git a/arch/sh/include/asm/system.h b/arch/sh/include/asm/system.h
deleted file mode 100644
index 11fa6f3..0000000
--- a/arch/sh/include/asm/system.h
+++ /dev/null
@@ -1,183 +0,0 @@
-#ifndef __ASM_SH_SYSTEM_H
-#define __ASM_SH_SYSTEM_H
-
-/*
- * Copyright (C) 1999, 2000  Niibe Yutaka  &  Kaz Kojima
- * Copyright (C) 2002 Paul Mundt
- */
-
-#include <linux/irqflags.h>
-#include <linux/compiler.h>
-#include <linux/linkage.h>
-#include <asm/types.h>
-#include <asm/uncached.h>
-
-#define AT_VECTOR_SIZE_ARCH 5 /* entries in ARCH_DLINFO */
-
-/*
- * A brief note on ctrl_barrier(), the control register write barrier.
- *
- * Legacy SH cores typically require a sequence of 8 nops after
- * modification of a control register in order for the changes to take
- * effect. On newer cores (like the sh4a and sh5) this is accomplished
- * with icbi.
- *
- * Also note that on sh4a in the icbi case we can forego a synco for the
- * write barrier, as it's not necessary for control registers.
- *
- * Historically we have only done this type of barrier for the MMUCR, but
- * it's also necessary for the CCR, so we make it generic here instead.
- */
-#if defined(CONFIG_CPU_SH4A) || defined(CONFIG_CPU_SH5)
-#define mb()		__asm__ __volatile__ ("synco": : :"memory")
-#define rmb()		mb()
-#define wmb()		__asm__ __volatile__ ("synco": : :"memory")
-#define ctrl_barrier()	__icbi(PAGE_OFFSET)
-#define read_barrier_depends()	do { } while(0)
-#else
-#define mb()		__asm__ __volatile__ ("": : :"memory")
-#define rmb()		mb()
-#define wmb()		__asm__ __volatile__ ("": : :"memory")
-#define ctrl_barrier()	__asm__ __volatile__ ("nop;nop;nop;nop;nop;nop;nop;nop")
-#define read_barrier_depends()	do { } while(0)
-#endif
-
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#define smp_read_barrier_depends()	read_barrier_depends()
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do { } while(0)
-#endif
-
-#define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
-
-#ifdef CONFIG_GUSA_RB
-#include <asm/cmpxchg-grb.h>
-#elif defined(CONFIG_CPU_SH4A)
-#include <asm/cmpxchg-llsc.h>
-#else
-#include <asm/cmpxchg-irq.h>
-#endif
-
-extern void __xchg_called_with_bad_pointer(void);
-
-#define __xchg(ptr, x, size)				\
-({							\
-	unsigned long __xchg__res;			\
-	volatile void *__xchg_ptr = (ptr);		\
-	switch (size) {					\
-	case 4:						\
-		__xchg__res = xchg_u32(__xchg_ptr, x);	\
-		break;					\
-	case 1:						\
-		__xchg__res = xchg_u8(__xchg_ptr, x);	\
-		break;					\
-	default:					\
-		__xchg_called_with_bad_pointer();	\
-		__xchg__res = x;			\
-		break;					\
-	}						\
-							\
-	__xchg__res;					\
-})
-
-#define xchg(ptr,x)	\
-	((__typeof__(*(ptr)))__xchg((ptr),(unsigned long)(x), sizeof(*(ptr))))
-
-/* This function doesn't exist, so you'll get a linker error
- * if something tries to do an invalid cmpxchg(). */
-extern void __cmpxchg_called_with_bad_pointer(void);
-
-#define __HAVE_ARCH_CMPXCHG 1
-
-static inline unsigned long __cmpxchg(volatile void * ptr, unsigned long old,
-		unsigned long new, int size)
-{
-	switch (size) {
-	case 4:
-		return __cmpxchg_u32(ptr, old, new);
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
-struct pt_regs;
-
-extern void die(const char *str, struct pt_regs *regs, long err) __attribute__ ((noreturn));
-void free_initrd_mem(unsigned long start, unsigned long end);
-
-extern void *set_exception_table_vec(unsigned int vec, void *handler);
-
-static inline void *set_exception_table_evt(unsigned int evt, void *handler)
-{
-	return set_exception_table_vec(evt >> 5, handler);
-}
-
-/*
- * SH-2A has both 16 and 32-bit opcodes, do lame encoding checks.
- */
-#ifdef CONFIG_CPU_SH2A
-extern unsigned int instruction_size(unsigned int insn);
-#elif defined(CONFIG_SUPERH32)
-#define instruction_size(insn)	(2)
-#else
-#define instruction_size(insn)	(4)
-#endif
-
-void per_cpu_trap_init(void);
-void default_idle(void);
-void cpu_idle_wait(void);
-void stop_this_cpu(void *);
-
-#ifdef CONFIG_SUPERH32
-#define BUILD_TRAP_HANDLER(name)					\
-asmlinkage void name##_trap_handler(unsigned long r4, unsigned long r5,	\
-				    unsigned long r6, unsigned long r7,	\
-				    struct pt_regs __regs)
-
-#define TRAP_HANDLER_DECL				\
-	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);	\
-	unsigned int vec = regs->tra;			\
-	(void)vec;
-#else
-#define BUILD_TRAP_HANDLER(name)	\
-asmlinkage void name##_trap_handler(unsigned int vec, struct pt_regs *regs)
-#define TRAP_HANDLER_DECL
-#endif
-
-BUILD_TRAP_HANDLER(address_error);
-BUILD_TRAP_HANDLER(debug);
-BUILD_TRAP_HANDLER(bug);
-BUILD_TRAP_HANDLER(breakpoint);
-BUILD_TRAP_HANDLER(singlestep);
-BUILD_TRAP_HANDLER(fpu_error);
-BUILD_TRAP_HANDLER(fpu_state_restore);
-BUILD_TRAP_HANDLER(nmi);
-
-#define arch_align_stack(x) (x)
-
-struct mem_access {
-	unsigned long (*from)(void *dst, const void __user *src, unsigned long cnt);
-	unsigned long (*to)(void __user *dst, const void *src, unsigned long cnt);
-};
-
-#ifdef CONFIG_SUPERH32
-# include "system_32.h"
-#else
-# include "system_64.h"
-#endif
-
-#endif
diff --git a/arch/sh/include/asm/system_32.h b/arch/sh/include/asm/system_32.h
deleted file mode 100644
index a4ad1cd..0000000
--- a/arch/sh/include/asm/system_32.h
+++ /dev/null
@@ -1,236 +0,0 @@
-#ifndef __ASM_SH_SYSTEM_32_H
-#define __ASM_SH_SYSTEM_32_H
-
-#include <linux/types.h>
-#include <asm/mmu.h>
-
-#ifdef CONFIG_SH_DSP
-
-#define is_dsp_enabled(tsk)						\
-	(!!(tsk->thread.dsp_status.status & SR_DSP))
-
-#define __restore_dsp(tsk)						\
-do {									\
-	register u32 *__ts2 __asm__ ("r2") =				\
-			(u32 *)&tsk->thread.dsp_status;			\
-	__asm__ __volatile__ (						\
-		".balign 4\n\t"						\
-		"movs.l	@r2+, a0\n\t"					\
-		"movs.l	@r2+, a1\n\t"					\
-		"movs.l	@r2+, a0g\n\t"					\
-		"movs.l	@r2+, a1g\n\t"					\
-		"movs.l	@r2+, m0\n\t"					\
-		"movs.l	@r2+, m1\n\t"					\
-		"movs.l	@r2+, x0\n\t"					\
-		"movs.l	@r2+, x1\n\t"					\
-		"movs.l	@r2+, y0\n\t"					\
-		"movs.l	@r2+, y1\n\t"					\
-		"lds.l	@r2+, dsr\n\t"					\
-		"ldc.l	@r2+, rs\n\t"					\
-		"ldc.l	@r2+, re\n\t"					\
-		"ldc.l	@r2+, mod\n\t"					\
-		: : "r" (__ts2));					\
-} while (0)
-
-
-#define __save_dsp(tsk)							\
-do {									\
-	register u32 *__ts2 __asm__ ("r2") =				\
-			(u32 *)&tsk->thread.dsp_status + 14;		\
-									\
-	__asm__ __volatile__ (						\
-		".balign 4\n\t"						\
-		"stc.l	mod, @-r2\n\t"					\
-		"stc.l	re, @-r2\n\t"					\
-		"stc.l	rs, @-r2\n\t"					\
-		"sts.l	dsr, @-r2\n\t"					\
-		"movs.l	y1, @-r2\n\t"					\
-		"movs.l	y0, @-r2\n\t"					\
-		"movs.l	x1, @-r2\n\t"					\
-		"movs.l	x0, @-r2\n\t"					\
-		"movs.l	m1, @-r2\n\t"					\
-		"movs.l	m0, @-r2\n\t"					\
-		"movs.l	a1g, @-r2\n\t"					\
-		"movs.l	a0g, @-r2\n\t"					\
-		"movs.l	a1, @-r2\n\t"					\
-		"movs.l	a0, @-r2\n\t"					\
-		: : "r" (__ts2));					\
-} while (0)
-
-#else
-
-#define is_dsp_enabled(tsk)	(0)
-#define __save_dsp(tsk)		do { } while (0)
-#define __restore_dsp(tsk)	do { } while (0)
-#endif
-
-#if defined(CONFIG_CPU_SH4A)
-#define __icbi(addr)	__asm__ __volatile__ ( "icbi @%0\n\t" : : "r" (addr))
-#else
-#define __icbi(addr)	mb()
-#endif
-
-#define __ocbp(addr)	__asm__ __volatile__ ( "ocbp @%0\n\t" : : "r" (addr))
-#define __ocbi(addr)	__asm__ __volatile__ ( "ocbi @%0\n\t" : : "r" (addr))
-#define __ocbwb(addr)	__asm__ __volatile__ ( "ocbwb @%0\n\t" : : "r" (addr))
-
-struct task_struct *__switch_to(struct task_struct *prev,
-				struct task_struct *next);
-
-/*
- *	switch_to() should switch tasks to task nr n, first
- */
-#define switch_to(prev, next, last)				\
-do {								\
-	register u32 *__ts1 __asm__ ("r1");			\
-	register u32 *__ts2 __asm__ ("r2");			\
-	register u32 *__ts4 __asm__ ("r4");			\
-	register u32 *__ts5 __asm__ ("r5");			\
-	register u32 *__ts6 __asm__ ("r6");			\
-	register u32 __ts7 __asm__ ("r7");			\
-	struct task_struct *__last;				\
-								\
-	if (is_dsp_enabled(prev))				\
-		__save_dsp(prev);				\
-								\
-	__ts1 = (u32 *)&prev->thread.sp;			\
-	__ts2 = (u32 *)&prev->thread.pc;			\
-	__ts4 = (u32 *)prev;					\
-	__ts5 = (u32 *)next;					\
-	__ts6 = (u32 *)&next->thread.sp;			\
-	__ts7 = next->thread.pc;				\
-								\
-	__asm__ __volatile__ (					\
-		".balign 4\n\t"					\
-		"stc.l	gbr, @-r15\n\t"				\
-		"sts.l	pr, @-r15\n\t"				\
-		"mov.l	r8, @-r15\n\t"				\
-		"mov.l	r9, @-r15\n\t"				\
-		"mov.l	r10, @-r15\n\t"				\
-		"mov.l	r11, @-r15\n\t"				\
-		"mov.l	r12, @-r15\n\t"				\
-		"mov.l	r13, @-r15\n\t"				\
-		"mov.l	r14, @-r15\n\t"				\
-		"mov.l	r15, @r1\t! save SP\n\t"		\
-		"mov.l	@r6, r15\t! change to new stack\n\t"	\
-		"mova	1f, %0\n\t"				\
-		"mov.l	%0, @r2\t! save PC\n\t"			\
-		"mov.l	2f, %0\n\t"				\
-		"jmp	@%0\t! call __switch_to\n\t"		\
-		" lds	r7, pr\t!  with return to new PC\n\t"	\
-		".balign	4\n"				\
-		"2:\n\t"					\
-		".long	__switch_to\n"				\
-		"1:\n\t"					\
-		"mov.l	@r15+, r14\n\t"				\
-		"mov.l	@r15+, r13\n\t"				\
-		"mov.l	@r15+, r12\n\t"				\
-		"mov.l	@r15+, r11\n\t"				\
-		"mov.l	@r15+, r10\n\t"				\
-		"mov.l	@r15+, r9\n\t"				\
-		"mov.l	@r15+, r8\n\t"				\
-		"lds.l	@r15+, pr\n\t"				\
-		"ldc.l	@r15+, gbr\n\t"				\
-		: "=z" (__last)					\
-		: "r" (__ts1), "r" (__ts2), "r" (__ts4),	\
-		  "r" (__ts5), "r" (__ts6), "r" (__ts7)		\
-		: "r3", "t");					\
-								\
-	last = __last;						\
-} while (0)
-
-#define finish_arch_switch(prev)				\
-do {								\
-	if (is_dsp_enabled(prev))				\
-		__restore_dsp(prev);				\
-} while (0)
-
-#ifdef CONFIG_CPU_HAS_SR_RB
-#define lookup_exception_vector()	\
-({					\
-	unsigned long _vec;		\
-					\
-	__asm__ __volatile__ (		\
-		"stc r2_bank, %0\n\t"	\
-		: "=r" (_vec)		\
-	);				\
-					\
-	_vec;				\
-})
-#else
-#define lookup_exception_vector()	\
-({					\
-	unsigned long _vec;		\
-	__asm__ __volatile__ (		\
-		"mov r4, %0\n\t"	\
-		: "=r" (_vec)		\
-	);				\
-					\
-	_vec;				\
-})
-#endif
-
-static inline reg_size_t register_align(void *val)
-{
-	return (unsigned long)(signed long)val;
-}
-
-int handle_unaligned_access(insn_size_t instruction, struct pt_regs *regs,
-			    struct mem_access *ma, int, unsigned long address);
-
-static inline void trigger_address_error(void)
-{
-	__asm__ __volatile__ (
-		"ldc %0, sr\n\t"
-		"mov.l @%1, %0"
-		:
-		: "r" (0x10000000), "r" (0x80000001)
-	);
-}
-
-asmlinkage void do_address_error(struct pt_regs *regs,
-				 unsigned long writeaccess,
-				 unsigned long address);
-asmlinkage void do_divide_error(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs);
-asmlinkage void do_reserved_inst(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs);
-asmlinkage void do_illegal_slot_inst(unsigned long r4, unsigned long r5,
-				unsigned long r6, unsigned long r7,
-				struct pt_regs __regs);
-asmlinkage void do_exception_error(unsigned long r4, unsigned long r5,
-				   unsigned long r6, unsigned long r7,
-				   struct pt_regs __regs);
-
-static inline void set_bl_bit(void)
-{
-	unsigned long __dummy0, __dummy1;
-
-	__asm__ __volatile__ (
-		"stc	sr, %0\n\t"
-		"or	%2, %0\n\t"
-		"and	%3, %0\n\t"
-		"ldc	%0, sr\n\t"
-		: "=&r" (__dummy0), "=r" (__dummy1)
-		: "r" (0x10000000), "r" (0xffffff0f)
-		: "memory"
-	);
-}
-
-static inline void clear_bl_bit(void)
-{
-	unsigned long __dummy0, __dummy1;
-
-	__asm__ __volatile__ (
-		"stc	sr, %0\n\t"
-		"and	%2, %0\n\t"
-		"ldc	%0, sr\n\t"
-		: "=&r" (__dummy0), "=r" (__dummy1)
-		: "1" (~0x10000000)
-		: "memory"
-	);
-}
-
-#endif /* __ASM_SH_SYSTEM_32_H */
diff --git a/arch/sh/include/asm/system_64.h b/arch/sh/include/asm/system_64.h
deleted file mode 100644
index 8593bc8d..0000000
--- a/arch/sh/include/asm/system_64.h
+++ /dev/null
@@ -1,79 +0,0 @@
-#ifndef __ASM_SH_SYSTEM_64_H
-#define __ASM_SH_SYSTEM_64_H
-
-/*
- * include/asm-sh/system_64.h
- *
- * Copyright (C) 2000, 2001  Paolo Alberelli
- * Copyright (C) 2003  Paul Mundt
- * Copyright (C) 2004  Richard Curnow
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-#include <cpu/registers.h>
-#include <asm/processor.h>
-
-/*
- *	switch_to() should switch tasks to task nr n, first
- */
-struct thread_struct;
-struct task_struct *sh64_switch_to(struct task_struct *prev,
-				   struct thread_struct *prev_thread,
-				   struct task_struct *next,
-				   struct thread_struct *next_thread);
-
-#define switch_to(prev,next,last)				\
-do {								\
-	if (last_task_used_math != next) {			\
-		struct pt_regs *regs = next->thread.uregs;	\
-		if (regs) regs->sr |= SR_FD;			\
-	}							\
-	last = sh64_switch_to(prev, &prev->thread, next,	\
-			      &next->thread);			\
-} while (0)
-
-#define __icbi(addr)	__asm__ __volatile__ ( "icbi %0, 0\n\t" : : "r" (addr))
-#define __ocbp(addr)	__asm__ __volatile__ ( "ocbp %0, 0\n\t" : : "r" (addr))
-#define __ocbi(addr)	__asm__ __volatile__ ( "ocbi %0, 0\n\t" : : "r" (addr))
-#define __ocbwb(addr)	__asm__ __volatile__ ( "ocbwb %0, 0\n\t" : : "r" (addr))
-
-static inline reg_size_t register_align(void *val)
-{
-	return (unsigned long long)(signed long long)(signed long)val;
-}
-
-extern void phys_stext(void);
-
-static inline void trigger_address_error(void)
-{
-	phys_stext();
-}
-
-#define SR_BL_LL	0x0000000010000000LL
-
-static inline void set_bl_bit(void)
-{
-	unsigned long long __dummy0, __dummy1 = SR_BL_LL;
-
-	__asm__ __volatile__("getcon	" __SR ", %0\n\t"
-			     "or	%0, %1, %0\n\t"
-			     "putcon	%0, " __SR "\n\t"
-			     : "=&r" (__dummy0)
-			     : "r" (__dummy1));
-
-}
-
-static inline void clear_bl_bit(void)
-{
-	unsigned long long __dummy0, __dummy1 = ~SR_BL_LL;
-
-	__asm__ __volatile__("getcon	" __SR ", %0\n\t"
-			     "and	%0, %1, %0\n\t"
-			     "putcon	%0, " __SR "\n\t"
-			     : "=&r" (__dummy0)
-			     : "r" (__dummy1));
-}
-
-#endif /* __ASM_SH_SYSTEM_64_H */
diff --git a/arch/sh/include/asm/traps.h b/arch/sh/include/asm/traps.h
new file mode 100644
index 0000000..fe95168
--- /dev/null
+++ b/arch/sh/include/asm/traps.h
@@ -0,0 +1,20 @@
+#ifndef __ASM_SH_TRAPS_H
+#define __ASM_SH_TRAPS_H
+
+
+#ifdef CONFIG_SUPERH32
+# include "traps_32.h"
+#else
+# include "traps_64.h"
+#endif
+
+BUILD_TRAP_HANDLER(address_error);
+BUILD_TRAP_HANDLER(debug);
+BUILD_TRAP_HANDLER(bug);
+BUILD_TRAP_HANDLER(breakpoint);
+BUILD_TRAP_HANDLER(singlestep);
+BUILD_TRAP_HANDLER(fpu_error);
+BUILD_TRAP_HANDLER(fpu_state_restore);
+BUILD_TRAP_HANDLER(nmi);
+
+#endif /* __ASM_SH_TRAPS_H */
diff --git a/arch/sh/include/asm/traps_32.h b/arch/sh/include/asm/traps_32.h
new file mode 100644
index 0000000..cfd55ff
--- /dev/null
+++ b/arch/sh/include/asm/traps_32.h
@@ -0,0 +1,68 @@
+#ifndef __ASM_SH_TRAPS_32_H
+#define __ASM_SH_TRAPS_32_H
+
+#include <linux/types.h>
+#include <asm/mmu.h>
+
+#ifdef CONFIG_CPU_HAS_SR_RB
+#define lookup_exception_vector()	\
+({					\
+	unsigned long _vec;		\
+					\
+	__asm__ __volatile__ (		\
+		"stc r2_bank, %0\n\t"	\
+		: "=r" (_vec)		\
+	);				\
+					\
+	_vec;				\
+})
+#else
+#define lookup_exception_vector()	\
+({					\
+	unsigned long _vec;		\
+	__asm__ __volatile__ (		\
+		"mov r4, %0\n\t"	\
+		: "=r" (_vec)		\
+	);				\
+					\
+	_vec;				\
+})
+#endif
+
+static inline void trigger_address_error(void)
+{
+	__asm__ __volatile__ (
+		"ldc %0, sr\n\t"
+		"mov.l @%1, %0"
+		:
+		: "r" (0x10000000), "r" (0x80000001)
+	);
+}
+
+asmlinkage void do_address_error(struct pt_regs *regs,
+				 unsigned long writeaccess,
+				 unsigned long address);
+asmlinkage void do_divide_error(unsigned long r4, unsigned long r5,
+				unsigned long r6, unsigned long r7,
+				struct pt_regs __regs);
+asmlinkage void do_reserved_inst(unsigned long r4, unsigned long r5,
+				unsigned long r6, unsigned long r7,
+				struct pt_regs __regs);
+asmlinkage void do_illegal_slot_inst(unsigned long r4, unsigned long r5,
+				unsigned long r6, unsigned long r7,
+				struct pt_regs __regs);
+asmlinkage void do_exception_error(unsigned long r4, unsigned long r5,
+				   unsigned long r6, unsigned long r7,
+				   struct pt_regs __regs);
+
+#define BUILD_TRAP_HANDLER(name)					\
+asmlinkage void name##_trap_handler(unsigned long r4, unsigned long r5,	\
+				    unsigned long r6, unsigned long r7,	\
+				    struct pt_regs __regs)
+
+#define TRAP_HANDLER_DECL				\
+	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);	\
+	unsigned int vec = regs->tra;			\
+	(void)vec;
+
+#endif /* __ASM_SH_TRAPS_32_H */
diff --git a/arch/sh/include/asm/traps_64.h b/arch/sh/include/asm/traps_64.h
new file mode 100644
index 0000000..c52d7f9
--- /dev/null
+++ b/arch/sh/include/asm/traps_64.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2000, 2001  Paolo Alberelli
+ * Copyright (C) 2003  Paul Mundt
+ * Copyright (C) 2004  Richard Curnow
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+#ifndef __ASM_SH_TRAPS_64_H
+#define __ASM_SH_TRAPS_64_H
+
+extern void phys_stext(void);
+
+static inline void trigger_address_error(void)
+{
+	phys_stext();
+}
+
+#define BUILD_TRAP_HANDLER(name)	\
+asmlinkage void name##_trap_handler(unsigned int vec, struct pt_regs *regs)
+#define TRAP_HANDLER_DECL
+
+#endif /* __ASM_SH_TRAPS_64_H */
diff --git a/arch/sh/include/asm/uaccess.h b/arch/sh/include/asm/uaccess.h
index 075848f..050f221 100644
--- a/arch/sh/include/asm/uaccess.h
+++ b/arch/sh/include/asm/uaccess.h
@@ -254,5 +254,19 @@ int fixup_exception(struct pt_regs *regs);
 unsigned long search_exception_table(unsigned long addr);
 const struct exception_table_entry *search_exception_tables(unsigned long addr);
 
+extern void *set_exception_table_vec(unsigned int vec, void *handler);
+
+static inline void *set_exception_table_evt(unsigned int evt, void *handler)
+{
+	return set_exception_table_vec(evt >> 5, handler);
+}
+
+struct mem_access {
+	unsigned long (*from)(void *dst, const void __user *src, unsigned long cnt);
+	unsigned long (*to)(void __user *dst, const void *src, unsigned long cnt);
+};
+
+int handle_unaligned_access(insn_size_t instruction, struct pt_regs *regs,
+			    struct mem_access *ma, int, unsigned long address);
 
 #endif /* __ASM_SH_UACCESS_H */
diff --git a/arch/sh/kernel/cpu/init.c b/arch/sh/kernel/cpu/init.c
index b95f84c..61a07da 100644
--- a/arch/sh/kernel/cpu/init.c
+++ b/arch/sh/kernel/cpu/init.c
@@ -24,6 +24,7 @@
 #include <asm/io.h>
 #include <asm/smp.h>
 #include <asm/sh_bios.h>
+#include <asm/setup.h>
 
 #ifdef CONFIG_SH_FPU
 #define cpu_has_fpu	1
diff --git a/arch/sh/kernel/hw_breakpoint.c b/arch/sh/kernel/hw_breakpoint.c
index efae6ab..f917376 100644
--- a/arch/sh/kernel/hw_breakpoint.c
+++ b/arch/sh/kernel/hw_breakpoint.c
@@ -22,6 +22,7 @@
 #include <asm/hw_breakpoint.h>
 #include <asm/mmu_context.h>
 #include <asm/ptrace.h>
+#include <asm/traps.h>
 
 /*
  * Stores the breakpoints currently in use on each breakpoint address
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 17ad04f..b7c8f68 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -20,6 +20,7 @@
 #include <asm/pgalloc.h>
 #include <linux/atomic.h>
 #include <asm/smp.h>
+#include <asm/bl_bit.h>
 
 void (*pm_idle)(void);
 
diff --git a/arch/sh/kernel/process_64.c b/arch/sh/kernel/process_64.c
index cbd4e4b..4264583 100644
--- a/arch/sh/kernel/process_64.c
+++ b/arch/sh/kernel/process_64.c
@@ -30,6 +30,7 @@
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 #include <asm/fpu.h>
+#include <asm/switch_to.h>
 
 struct task_struct *last_task_used_math = NULL;
 
diff --git a/arch/sh/kernel/ptrace_64.c b/arch/sh/kernel/ptrace_64.c
index 663c9ae..bc81e07 100644
--- a/arch/sh/kernel/ptrace_64.c
+++ b/arch/sh/kernel/ptrace_64.c
@@ -38,6 +38,7 @@
 #include <asm/mmu_context.h>
 #include <asm/syscalls.h>
 #include <asm/fpu.h>
+#include <asm/traps.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/syscalls.h>
diff --git a/arch/sh/kernel/reboot.c b/arch/sh/kernel/reboot.c
index 7cc034b..04afe5b 100644
--- a/arch/sh/kernel/reboot.c
+++ b/arch/sh/kernel/reboot.c
@@ -9,6 +9,7 @@
 #include <asm/addrspace.h>
 #include <asm/reboot.h>
 #include <asm/tlbflush.h>
+#include <asm/traps.h>
 
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
diff --git a/arch/sh/kernel/traps.c b/arch/sh/kernel/traps.c
index 931baa8..a87e58a 100644
--- a/arch/sh/kernel/traps.c
+++ b/arch/sh/kernel/traps.c
@@ -7,6 +7,7 @@
 #include <linux/uaccess.h>
 #include <linux/hardirq.h>
 #include <asm/unwinder.h>
+#include <asm/traps.h>
 
 #ifdef CONFIG_GENERIC_BUG
 static void handle_BUG(struct pt_regs *regs)
diff --git a/arch/sh/kernel/traps_32.c b/arch/sh/kernel/traps_32.c
index 227c21a..a37175d 100644
--- a/arch/sh/kernel/traps_32.c
+++ b/arch/sh/kernel/traps_32.c
@@ -30,6 +30,8 @@
 #include <asm/alignment.h>
 #include <asm/fpu.h>
 #include <asm/kprobes.h>
+#include <asm/traps.h>
+#include <asm/bl_bit.h>
 
 #ifdef CONFIG_CPU_SH2
 # define TRAP_RESERVED_INST	4
diff --git a/arch/sh/mm/fault_32.c b/arch/sh/mm/fault_32.c
index ddbc2d4..324eef9 100644
--- a/arch/sh/mm/fault_32.c
+++ b/arch/sh/mm/fault_32.c
@@ -19,6 +19,7 @@
 #include <asm/io_trapped.h>
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
+#include <asm/traps.h>
 
 static inline int notify_page_fault(struct pt_regs *regs, int trap)
 {
diff --git a/arch/sh/mm/flush-sh4.c b/arch/sh/mm/flush-sh4.c
index cef4026..75a17f5 100644
--- a/arch/sh/mm/flush-sh4.c
+++ b/arch/sh/mm/flush-sh4.c
@@ -1,6 +1,7 @@
 #include <linux/mm.h>
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
+#include <asm/traps.h>
 
 /*
  * Write back the dirty D-caches, but not invalidate them.


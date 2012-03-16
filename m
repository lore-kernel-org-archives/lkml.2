Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161336Ab2CPDUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 23:20:19 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:36095 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161000Ab2CPDUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 23:20:16 -0400
Message-ID: <1331868043.1971.10.camel@epip-laptop>
Subject: Re: [PATCH 27/38] Disintegrate asm/system.h for Unicore32 [ver #3]
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: David Howells <dhowells@redhat.com>
Cc: paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de
Date: Fri, 16 Mar 2012 11:20:43 +0800
In-Reply-To: <20120315205931.28759.81875.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
	 <20120315205931.28759.81875.stgit@warthog.procyon.org.uk>
Organization: MPRC, PKU
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 20:59 +0000, David Howells wrote:
> Disintegrate asm/system.h for Unicore32.  Not Compiled.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
> ---
> 

Great work!

Based on your patch, I adjusted some tiny bits and it could build
successful now. Please see the following:

Disintegrate asm/system.h for Unicore32. (Compilation successful)
The implementation details are not changed, but only splitted.
BTW, some codestyles are adjusted.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/Kbuild        |    1 -
 arch/unicore32/include/asm/barrier.h     |   28 +++++
 arch/unicore32/include/asm/bug.h         |   27 +++++
 arch/unicore32/include/asm/cmpxchg.h     |   60 +++++++++++
 arch/unicore32/include/asm/exec.h        |   15 +++
 arch/unicore32/include/asm/hwdef-copro.h |   49 +++++++++
 arch/unicore32/include/asm/io.h          |    1 -
 arch/unicore32/include/asm/switch_to.h   |   30 ++++++
 arch/unicore32/include/asm/system.h      |  166
+-----------------------------
 arch/unicore32/include/asm/uaccess.h     |    1 -
 arch/unicore32/kernel/dma.c              |    1 -
 arch/unicore32/kernel/head.S             |    2 +-
 arch/unicore32/kernel/hibernate.c        |    1 -
 arch/unicore32/kernel/irq.c              |    1 -
 arch/unicore32/kernel/ksyms.c            |    1 -
 arch/unicore32/kernel/process.c          |    1 -
 arch/unicore32/kernel/setup.h            |    3 +
 arch/unicore32/kernel/traps.c            |    1 -
 arch/unicore32/mm/alignment.c            |    2 +
 arch/unicore32/mm/fault.c                |    1 -
 arch/unicore32/mm/flush.c                |    1 -
 arch/unicore32/mm/mm.h                   |    5 +
 22 files changed, 225 insertions(+), 173 deletions(-)
 create mode 100644 arch/unicore32/include/asm/barrier.h
 create mode 100644 arch/unicore32/include/asm/bug.h
 create mode 100644 arch/unicore32/include/asm/cmpxchg.h
 create mode 100644 arch/unicore32/include/asm/exec.h
 create mode 100644 arch/unicore32/include/asm/hwdef-copro.h
 create mode 100644 arch/unicore32/include/asm/switch_to.h

diff --git a/arch/unicore32/include/asm/Kbuild
b/arch/unicore32/include/asm/Kbuild
index ca113d6..34b789b 100644
--- a/arch/unicore32/include/asm/Kbuild
+++ b/arch/unicore32/include/asm/Kbuild
@@ -3,7 +3,6 @@ include include/asm-generic/Kbuild.asm
 generic-y += atomic.h
 generic-y += auxvec.h
 generic-y += bitsperlong.h
-generic-y += bug.h
 generic-y += bugs.h
 generic-y += cputime.h
 generic-y += current.h
diff --git a/arch/unicore32/include/asm/barrier.h
b/arch/unicore32/include/asm/barrier.h
new file mode 100644
index 0000000..a6620e5
--- /dev/null
+++ b/arch/unicore32/include/asm/barrier.h
@@ -0,0 +1,28 @@
+/*
+ * Memory barrier implementations for PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2012 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_BARRIER_H__
+#define __UNICORE_BARRIER_H__
+
+#define isb() __asm__ __volatile__ ("" : : : "memory")
+#define dsb() __asm__ __volatile__ ("" : : : "memory")
+#define dmb() __asm__ __volatile__ ("" : : : "memory")
+
+#define mb()				barrier()
+#define rmb()				barrier()
+#define wmb()				barrier()
+#define smp_mb()			barrier()
+#define smp_rmb()			barrier()
+#define smp_wmb()			barrier()
+#define read_barrier_depends()		do { } while (0)
+#define smp_read_barrier_depends()	do { } while (0)
+
+#define set_mb(var, value)		do { var = value; smp_mb(); } while (0)
+
+#endif /* __UNICORE_BARRIER_H__ */
diff --git a/arch/unicore32/include/asm/bug.h
b/arch/unicore32/include/asm/bug.h
new file mode 100644
index 0000000..b1ff8ca
--- /dev/null
+++ b/arch/unicore32/include/asm/bug.h
@@ -0,0 +1,27 @@
+/*
+ * Bug handling for PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2012 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_BUG_H__
+#define __UNICORE_BUG_H__
+
+#include <asm-generic/bug.h>
+
+struct pt_regs;
+struct siginfo;
+
+extern void die(const char *msg, struct pt_regs *regs, int err);
+extern void uc32_notify_die(const char *str, struct pt_regs *regs,
+		struct siginfo *info, unsigned long err, unsigned long trap);
+
+extern asmlinkage void __backtrace(void);
+extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
+
+extern void __show_regs(struct pt_regs *);
+
+#endif /* __UNICORE_BUG_H__ */
diff --git a/arch/unicore32/include/asm/cmpxchg.h
b/arch/unicore32/include/asm/cmpxchg.h
new file mode 100644
index 0000000..e175b1c
--- /dev/null
+++ b/arch/unicore32/include/asm/cmpxchg.h
@@ -0,0 +1,60 @@
+/*
+ * Atomics xchg/cmpxchg for PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2012 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_CMPXCHG_H__
+#define __UNICORE_CMPXCHG_H__
+
+extern void panic(const char *fmt, ...);
+
+static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
+		int size)
+{
+	unsigned long ret;
+
+	switch (size) {
+	case 1:
+		asm volatile("@	__xchg1\n"
+		"	swapb	%0, %1, [%2]"
+			: "=&r" (ret)
+			: "r" (x), "r" (ptr)
+			: "memory", "cc");
+		break;
+	case 4:
+		asm volatile("@	__xchg4\n"
+		"	swapw	%0, %1, [%2]"
+			: "=&r" (ret)
+			: "r" (x), "r" (ptr)
+			: "memory", "cc");
+		break;
+	default:
+		panic("xchg: bad data size: ptr 0x%p, size %d\n",
+			ptr, size);
+	}
+
+	return ret;
+}
+
+#define xchg(ptr, x) \
+	((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr),
sizeof(*(ptr))))
+
+#include <asm-generic/cmpxchg-local.h>
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always
make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)					\
+		((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr),	\
+		(unsigned long)(o), (unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n)					\
+		__cmpxchg64_local_generic((ptr), (o), (n))
+
+#include <asm-generic/cmpxchg.h>
+
+#endif /* __UNICORE_CMPXCHG_H__ */
diff --git a/arch/unicore32/include/asm/exec.h
b/arch/unicore32/include/asm/exec.h
new file mode 100644
index 0000000..989be7e
--- /dev/null
+++ b/arch/unicore32/include/asm/exec.h
@@ -0,0 +1,15 @@
+/*
+ * Process execution bits for PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2012 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_EXEC_H__
+#define __UNICORE_EXEC_H__
+
+#define arch_align_stack(x) (x)
+
+#endif /* __UNICORE_EXEC_H__ */
diff --git a/arch/unicore32/include/asm/hwdef-copro.h
b/arch/unicore32/include/asm/hwdef-copro.h
new file mode 100644
index 0000000..b24349c
--- /dev/null
+++ b/arch/unicore32/include/asm/hwdef-copro.h
@@ -0,0 +1,49 @@
+/*
+ * Co-processor register definitions for PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2012 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_HWDEF_COPRO_H__
+#define __UNICORE_HWDEF_COPRO_H__
+
+/*
+ * Control Register bits (CP#0 CR1)
+ */
+#define CR_M	(1 << 0)	/* MMU enable				*/
+#define CR_A	(1 << 1)	/* Alignment abort enable		*/
+#define CR_D	(1 << 2)	/* Dcache enable			*/
+#define CR_I	(1 << 3)	/* Icache enable			*/
+#define CR_B	(1 << 4)	/* Dcache write mechanism: write back	*/
+#define CR_T	(1 << 5)	/* Burst enable				*/
+#define CR_V	(1 << 13)	/* Vectors relocated to 0xffff0000	*/
+
+#ifndef __ASSEMBLY__
+
+#define vectors_high()	(cr_alignment & CR_V)
+
+extern unsigned long cr_no_alignment;	/* defined in entry.S */
+extern unsigned long cr_alignment;	/* defined in entry.S */
+
+static inline unsigned int get_cr(void)
+{
+	unsigned int val;
+	asm("movc %0, p0.c1, #0" : "=r" (val) : : "cc");
+	return val;
+}
+
+static inline void set_cr(unsigned int val)
+{
+	asm volatile("movc p0.c1, %0, #0	@set CR"
+	  : : "r" (val) : "cc");
+	isb();
+}
+
+extern void adjust_cr(unsigned long mask, unsigned long set);
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __UNICORE_HWDEF_COPRO_H__ */
diff --git a/arch/unicore32/include/asm/io.h
b/arch/unicore32/include/asm/io.h
index adddf6d..39decb6 100644
--- a/arch/unicore32/include/asm/io.h
+++ b/arch/unicore32/include/asm/io.h
@@ -16,7 +16,6 @@
 
 #include <asm/byteorder.h>
 #include <asm/memory.h>
-#include <asm/system.h>
 
 #define PCI_IOBASE	PKUNITY_PCILIO_BASE
 #include <asm-generic/io.h>
diff --git a/arch/unicore32/include/asm/switch_to.h
b/arch/unicore32/include/asm/switch_to.h
new file mode 100644
index 0000000..39572d2
--- /dev/null
+++ b/arch/unicore32/include/asm/switch_to.h
@@ -0,0 +1,30 @@
+/*
+ * Task switching for PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2012 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_SWITCH_TO_H__
+#define __UNICORE_SWITCH_TO_H__
+
+struct task_struct;
+struct thread_info;
+
+/*
+ * switch_to(prev, next) should switch from task `prev' to `next'
+ * `prev' will never be the same as `next'.  schedule() itself
+ * contains the memory barrier to tell GCC not to cache `current'.
+ */
+extern struct task_struct *__switch_to(struct task_struct *,
+		struct thread_info *, struct thread_info *);
+
+#define switch_to(prev, next, last)					\
+	do {								\
+		last = __switch_to(prev, task_thread_info(prev),	\
+					task_thread_info(next));	\
+	} while (0)
+
+#endif /* __UNICORE_SWITCH_TO_H__ */
diff --git a/arch/unicore32/include/asm/system.h
b/arch/unicore32/include/asm/system.h
index 246b71c..a7f4057 100644
--- a/arch/unicore32/include/asm/system.h
+++ b/arch/unicore32/include/asm/system.h
@@ -1,161 +1,5 @@
-/*
- * linux/arch/unicore32/include/asm/system.h
- *
- * Code specific to PKUnity SoC and UniCore ISA
- *
- * Copyright (C) 2001-2010 GUAN Xue-tao
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#ifndef __UNICORE_SYSTEM_H__
-#define __UNICORE_SYSTEM_H__
-
-#ifdef __KERNEL__
-
-/*
- * CR1 bits (CP#0 CR1)
- */
-#define CR_M	(1 << 0)	/* MMU enable				*/
-#define CR_A	(1 << 1)	/* Alignment abort enable		*/
-#define CR_D	(1 << 2)	/* Dcache enable			*/
-#define CR_I	(1 << 3)	/* Icache enable			*/
-#define CR_B	(1 << 4)	/* Dcache write mechanism: write back	*/
-#define CR_T	(1 << 5)	/* Burst enable				*/
-#define CR_V	(1 << 13)	/* Vectors relocated to 0xffff0000	*/
-
-#ifndef __ASSEMBLY__
-
-#include <linux/linkage.h>
-#include <linux/irqflags.h>
-
-struct thread_info;
-struct task_struct;
-
-struct pt_regs;
-
-void die(const char *msg, struct pt_regs *regs, int err);
-
-struct siginfo;
-void uc32_notify_die(const char *str, struct pt_regs *regs,
-		struct siginfo *info, unsigned long err, unsigned long trap);
-
-void hook_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
-				       struct pt_regs *),
-		     int sig, int code, const char *name);
-
-#define xchg(ptr, x) \
-	((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr),
sizeof(*(ptr))))
-
-extern asmlinkage void __backtrace(void);
-extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
-
-struct mm_struct;
-extern void show_pte(struct mm_struct *mm, unsigned long addr);
-extern void __show_regs(struct pt_regs *);
-
-extern int cpu_architecture(void);
-extern void cpu_init(void);
-
-#define vectors_high()	(cr_alignment & CR_V)
-
-#define isb() __asm__ __volatile__ ("" : : : "memory")
-#define dsb() __asm__ __volatile__ ("" : : : "memory")
-#define dmb() __asm__ __volatile__ ("" : : : "memory")
-
-#define mb()		barrier()
-#define rmb()		barrier()
-#define wmb()		barrier()
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define read_barrier_depends()		do { } while (0)
-#define smp_read_barrier_depends()	do { } while (0)
-
-#define set_mb(var, value)	do { var = value; smp_mb(); } while (0)
-#define nop() __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t");
-
-extern unsigned long cr_no_alignment;	/* defined in entry-unicore.S */
-extern unsigned long cr_alignment;	/* defined in entry-unicore.S */
-
-static inline unsigned int get_cr(void)
-{
-	unsigned int val;
-	asm("movc %0, p0.c1, #0" : "=r" (val) : : "cc");
-	return val;
-}
-
-static inline void set_cr(unsigned int val)
-{
-	asm volatile("movc p0.c1, %0, #0	@set CR"
-	  : : "r" (val) : "cc");
-	isb();
-}
-
-extern void adjust_cr(unsigned long mask, unsigned long set);
-
-/*
- * switch_to(prev, next) should switch from task `prev' to `next'
- * `prev' will never be the same as `next'.  schedule() itself
- * contains the memory barrier to tell GCC not to cache `current'.
- */
-extern struct task_struct *__switch_to(struct task_struct *,
-		struct thread_info *, struct thread_info *);
-extern void panic(const char *fmt, ...);
-
-#define switch_to(prev, next, last)					\
-do {									\
-	last = __switch_to(prev,					\
-		task_thread_info(prev), task_thread_info(next));	\
-} while (0)
-
-static inline unsigned long
-__xchg(unsigned long x, volatile void *ptr, int size)
-{
-	unsigned long ret;
-
-	switch (size) {
-	case 1:
-		asm volatile("@	__xchg1\n"
-		"	swapb	%0, %1, [%2]"
-			: "=&r" (ret)
-			: "r" (x), "r" (ptr)
-			: "memory", "cc");
-		break;
-	case 4:
-		asm volatile("@	__xchg4\n"
-		"	swapw	%0, %1, [%2]"
-			: "=&r" (ret)
-			: "r" (x), "r" (ptr)
-			: "memory", "cc");
-		break;
-	default:
-		panic("xchg: bad data size: ptr 0x%p, size %d\n",
-			ptr, size);
-	}
-
-	return ret;
-}
-
-#include <asm-generic/cmpxchg-local.h>
-
-/*
- * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always
make
- * them available.
- */
-#define cmpxchg_local(ptr, o, n)					\
-		((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr),	\
-		(unsigned long)(o), (unsigned long)(n), sizeof(*(ptr))))
-#define cmpxchg64_local(ptr, o, n)					\
-		__cmpxchg64_local_generic((ptr), (o), (n))
-
-#include <asm-generic/cmpxchg.h>
-
-#endif /* __ASSEMBLY__ */
-
-#define arch_align_stack(x) (x)
-
-#endif /* __KERNEL__ */
-
-#endif
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+#include <asm/exec.h>
+#include <asm/switch_to.h>
diff --git a/arch/unicore32/include/asm/uaccess.h
b/arch/unicore32/include/asm/uaccess.h
index 2acda50..897e11a 100644
--- a/arch/unicore32/include/asm/uaccess.h
+++ b/arch/unicore32/include/asm/uaccess.h
@@ -16,7 +16,6 @@
 #include <linux/errno.h>
 
 #include <asm/memory.h>
-#include <asm/system.h>
 
 #define __copy_from_user	__copy_from_user
 #define __copy_to_user		__copy_to_user
diff --git a/arch/unicore32/kernel/dma.c b/arch/unicore32/kernel/dma.c
index ae441bc..ed2d4d7 100644
--- a/arch/unicore32/kernel/dma.c
+++ b/arch/unicore32/kernel/dma.c
@@ -18,7 +18,6 @@
 #include <linux/errno.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <mach/hardware.h>
 #include <mach/dma.h>
diff --git a/arch/unicore32/kernel/head.S b/arch/unicore32/kernel/head.S
index 8caf322..e8f0b98 100644
--- a/arch/unicore32/kernel/head.S
+++ b/arch/unicore32/kernel/head.S
@@ -17,7 +17,7 @@
 #include <generated/asm-offsets.h>
 #include <asm/memory.h>
 #include <asm/thread_info.h>
-#include <asm/system.h>
+#include <asm/hwdef-copro.h>
 #include <asm/pgtable-hwdef.h>
 
 #if (PHYS_OFFSET & 0x003fffff)
diff --git a/arch/unicore32/kernel/hibernate.c
b/arch/unicore32/kernel/hibernate.c
index 7d0f0b7..d75ef8b 100644
--- a/arch/unicore32/kernel/hibernate.c
+++ b/arch/unicore32/kernel/hibernate.c
@@ -15,7 +15,6 @@
 #include <linux/suspend.h>
 #include <linux/bootmem.h>
 
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
diff --git a/arch/unicore32/kernel/irq.c b/arch/unicore32/kernel/irq.c
index d4efa7d..0be5ccd 100644
--- a/arch/unicore32/kernel/irq.c
+++ b/arch/unicore32/kernel/irq.c
@@ -26,7 +26,6 @@
 #include <linux/syscore_ops.h>
 #include <linux/gpio.h>
 
-#include <asm/system.h>
 #include <mach/hardware.h>
 
 #include "setup.h"
diff --git a/arch/unicore32/kernel/ksyms.c
b/arch/unicore32/kernel/ksyms.c
index d98bd81..d285d71 100644
--- a/arch/unicore32/kernel/ksyms.c
+++ b/arch/unicore32/kernel/ksyms.c
@@ -20,7 +20,6 @@
 #include <linux/io.h>
 
 #include <asm/checksum.h>
-#include <asm/system.h>
 
 #include "ksyms.h"
 
diff --git a/arch/unicore32/kernel/process.c
b/arch/unicore32/kernel/process.c
index 52edc2b..1b3f152 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -34,7 +34,6 @@
 
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/stacktrace.h>
 
 #include "setup.h"
diff --git a/arch/unicore32/kernel/setup.h
b/arch/unicore32/kernel/setup.h
index dcd1306..f239550 100644
--- a/arch/unicore32/kernel/setup.h
+++ b/arch/unicore32/kernel/setup.h
@@ -12,8 +12,11 @@
 #ifndef __UNICORE_KERNEL_SETUP_H__
 #define __UNICORE_KERNEL_SETUP_H__
 
+#include <asm/hwdef-copro.h>
+
 extern void paging_init(void);
 extern void puv3_core_init(void);
+extern void cpu_init(void);
 
 extern void puv3_ps2_init(void);
 extern void pci_puv3_preinit(void);
diff --git a/arch/unicore32/kernel/traps.c
b/arch/unicore32/kernel/traps.c
index b9a2646..2054f0d 100644
--- a/arch/unicore32/kernel/traps.c
+++ b/arch/unicore32/kernel/traps.c
@@ -26,7 +26,6 @@
 #include <linux/unistd.h>
 
 #include <asm/cacheflush.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 
 #include "setup.h"
diff --git a/arch/unicore32/mm/alignment.c
b/arch/unicore32/mm/alignment.c
index 28f576d..de7dc5f 100644
--- a/arch/unicore32/mm/alignment.c
+++ b/arch/unicore32/mm/alignment.c
@@ -24,6 +24,8 @@
 #include <asm/tlbflush.h>
 #include <asm/unaligned.h>
 
+#include "mm.h"
+
 #define CODING_BITS(i)	(i & 0xe0000120)
 
 #define LDST_P_BIT(i)	(i & (1 << 28))	/* Preindex             */
diff --git a/arch/unicore32/mm/fault.c b/arch/unicore32/mm/fault.c
index 283aa4b..2eeb9c0 100644
--- a/arch/unicore32/mm/fault.c
+++ b/arch/unicore32/mm/fault.c
@@ -20,7 +20,6 @@
 #include <linux/sched.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
diff --git a/arch/unicore32/mm/flush.c b/arch/unicore32/mm/flush.c
index 93478cc..6d4c096 100644
--- a/arch/unicore32/mm/flush.c
+++ b/arch/unicore32/mm/flush.c
@@ -14,7 +14,6 @@
 #include <linux/pagemap.h>
 
 #include <asm/cacheflush.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 
 void flush_cache_mm(struct mm_struct *mm)
diff --git a/arch/unicore32/mm/mm.h b/arch/unicore32/mm/mm.h
index 3296bca..81bda11 100644
--- a/arch/unicore32/mm/mm.h
+++ b/arch/unicore32/mm/mm.h
@@ -9,6 +9,8 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <asm/hwdef-copro.h>
+
 /* the upper-most page table pointer */
 extern pmd_t *top_pmd;
 extern int sysctl_overcommit_memory;
@@ -34,6 +36,9 @@ struct mem_type {
 const struct mem_type *get_mem_type(unsigned int type);
 
 extern void __flush_dcache_page(struct address_space *, struct page *);
+extern void hook_fault_code(int nr, int (*fn)(unsigned long, unsigned
int,
+				       struct pt_regs *),
+		     int sig, int code, const char *name);
 
 void __init bootmem_init(void);
 void uc32_mm_memblock_reserve(void);
-- 
1.7.0.4



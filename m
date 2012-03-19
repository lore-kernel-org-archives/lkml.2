Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030895Ab2CSLTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 07:19:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756949Ab2CSLS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 07:18:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4F66F55A.1060904@pku.edu.cn>
References: <4F66F55A.1060904@pku.edu.cn> <1331868043.1971.10.camel@epip-laptop> <20120315205514.28759.58969.stgit@warthog.procyon.org.uk> <20120315205931.28759.81875.stgit@warthog.procyon.org.uk> <19084.1331908123@redhat.com>
To: gxt@mprc.pku.edu.cn
Cc: dhowells@redhat.com, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        arnd@arndb.de
Subject: Re: [PATCH 27/38] Disintegrate asm/system.h for Unicore32 [ver #3]
Date: Mon, 19 Mar 2012 11:18:45 +0000
Message-ID: <7019.1332155925@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Guan Xueao <gxt@pku.edu.cn> wrote:

> The patch is  a replacement for your patch, because I adjusted some codestyles
> at  the meantime.

Your mail client broke your patch to some extent, though I'm not sure exactly
what.  Here's an incremental diff that takes my patch to what I think yours
should have been.  Is this correct?

David
---
diff --git a/arch/unicore32/include/asm/barrier.h b/arch/unicore32/include/asm/barrier.h
index b7e5f82..26a87b7 100644
--- a/arch/unicore32/include/asm/barrier.h
+++ b/arch/unicore32/include/asm/barrier.h
@@ -1,7 +1,7 @@
 /*
  * Memory barrier implementations for PKUnity SoC and UniCore ISA
  *
- * Copyright (C) 2001-2010 GUAN Xue-tao
+ * Copyright (C) 2001-2012 GUAN Xue-tao
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/arch/unicore32/include/asm/bug.h b/arch/unicore32/include/asm/bug.h
index 8304b64..bddab00 100644
--- a/arch/unicore32/include/asm/bug.h
+++ b/arch/unicore32/include/asm/bug.h
@@ -1,7 +1,7 @@
 /*
  * Bug handling for PKUnity SoC and UniCore ISA
  *
- * Copyright (C) 2001-2010 GUAN Xue-tao
+ * Copyright (C) 2001-2012 GUAN Xue-tao
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -10,20 +10,14 @@
 #ifndef __UNICORE_BUG_H__
 #define __UNICORE_BUG_H__
 
-#include <linux/linkage.h>
-#include <asm/bug.h>
+#include <asm-generic/bug.h>
 
 struct pt_regs;
 struct siginfo;
 
-void die(const char *msg, struct pt_regs *regs, int err);
-
-void uc32_notify_die(const char *str, struct pt_regs *regs,
-		struct siginfo *info, unsigned long err, unsigned long trap);
-
-void hook_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
-				       struct pt_regs *),
-		     int sig, int code, const char *name);
+extern void die(const char *msg, struct pt_regs *regs, int err);
+extern void uc32_notify_die(const char *str, struct pt_regs *regs,
+	struct siginfo *info, unsigned long err, unsigned long trap);
 
 extern asmlinkage void __backtrace(void);
 extern asmlinkage void c_backtrace(unsigned long fp, int pmode);
diff --git a/arch/unicore32/include/asm/cmpxchg.h b/arch/unicore32/include/asm/cmpxchg.h
index 2c36450..0d68d2a 100644
--- a/arch/unicore32/include/asm/cmpxchg.h
+++ b/arch/unicore32/include/asm/cmpxchg.h
@@ -1,7 +1,7 @@
 /*
- * Atomics for PKUnity SoC and UniCore ISA
+ * Atomic xchg/cmpxchg for PKUnity SoC and UniCore ISA
  *
- * Copyright (C) 2001-2010 GUAN Xue-tao
+ * Copyright (C) 2001-2012 GUAN Xue-tao
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -10,36 +10,36 @@
 #ifndef __UNICORE_CMPXCHG_H__
 #define __UNICORE_CMPXCHG_H__
 
-static inline unsigned long
-__xchg(unsigned long x, volatile void *ptr, int size)
+static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
+        int size)
 {
 	unsigned long ret;
 
 	switch (size) {
 	case 1:
-		asm volatile("@	__xchg1\n"
-		"	swapb	%0, %1, [%2]"
-			: "=&r" (ret)
-			: "r" (x), "r" (ptr)
-			: "memory", "cc");
+		asm volatile("@    __xchg1\n"
+			     "    swapb    %0, %1, [%2]"
+			     : "=&r" (ret)
+			     : "r" (x), "r" (ptr)
+			     : "memory", "cc");
 		break;
 	case 4:
-		asm volatile("@	__xchg4\n"
-		"	swapw	%0, %1, [%2]"
-			: "=&r" (ret)
-			: "r" (x), "r" (ptr)
-			: "memory", "cc");
+		asm volatile("@    __xchg4\n"
+			     "    swapw    %0, %1, [%2]"
+			     : "=&r" (ret)
+			     : "r" (x), "r" (ptr)
+			     : "memory", "cc");
 		break;
 	default:
 		panic("xchg: bad data size: ptr 0x%p, size %d\n",
-			ptr, size);
+		      ptr, size);
 	}
 
 	return ret;
 }
 
 #define xchg(ptr, x) \
-	((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
+    ((__typeof__(*(ptr)))__xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
 
 #include <asm-generic/cmpxchg-local.h>
 
@@ -47,11 +47,11 @@ __xchg(unsigned long x, volatile void *ptr, int size)
  * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
  * them available.
  */
-#define cmpxchg_local(ptr, o, n)					\
-		((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr),	\
-		(unsigned long)(o), (unsigned long)(n), sizeof(*(ptr))))
-#define cmpxchg64_local(ptr, o, n)					\
-		__cmpxchg64_local_generic((ptr), (o), (n))
+#define cmpxchg_local(ptr, o, n)                    \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr),    \
+	(unsigned long)(o), (unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n)                    \
+	__cmpxchg64_local_generic((ptr), (o), (n))
 
 #include <asm-generic/cmpxchg.h>
 
diff --git a/arch/unicore32/include/asm/exec.h b/arch/unicore32/include/asm/exec.h
index ae707b3..989be7e 100644
--- a/arch/unicore32/include/asm/exec.h
+++ b/arch/unicore32/include/asm/exec.h
@@ -1,7 +1,7 @@
 /*
  * Process execution bits for PKUnity SoC and UniCore ISA
  *
- * Copyright (C) 2001-2010 GUAN Xue-tao
+ * Copyright (C) 2001-2012 GUAN Xue-tao
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/arch/unicore32/include/asm/hwdef-copro.h b/arch/unicore32/include/asm/hwdef-copro.h
new file mode 100644
index 0000000..6285249
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
+#define CR_M    (1 << 0)    /* MMU enable                */
+#define CR_A    (1 << 1)    /* Alignment abort enable        */
+#define CR_D    (1 << 2)    /* Dcache enable            */
+#define CR_I    (1 << 3)    /* Icache enable            */
+#define CR_B    (1 << 4)    /* Dcache write mechanism: write back    */
+#define CR_T    (1 << 5)    /* Burst enable                */
+#define CR_V    (1 << 13)    /* Vectors relocated to 0xffff0000    */
+
+#ifndef __ASSEMBLY__
+
+#define vectors_high()    (cr_alignment & CR_V)
+
+extern unsigned long cr_no_alignment;    /* defined in entry.S */
+extern unsigned long cr_alignment;    /* defined in entry.S */
+
+static inline unsigned int get_cr(void)
+{
+    unsigned int val;
+    asm("movc %0, p0.c1, #0" : "=r" (val) : : "cc");
+    return val;
+}
+
+static inline void set_cr(unsigned int val)
+{
+    asm volatile("movc p0.c1, %0, #0    @set CR"
+      : : "r" (val) : "cc");
+    isb();
+}
+
+extern void adjust_cr(unsigned long mask, unsigned long set);
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __UNICORE_HWDEF_COPRO_H__ */
diff --git a/arch/unicore32/include/asm/switch_to.h b/arch/unicore32/include/asm/switch_to.h
index db7a40c..dfa3175 100644
--- a/arch/unicore32/include/asm/switch_to.h
+++ b/arch/unicore32/include/asm/switch_to.h
@@ -1,7 +1,7 @@
 /*
  * Task switching for PKUnity SoC and UniCore ISA
  *
- * Copyright (C) 2001-2010 GUAN Xue-tao
+ * Copyright (C) 2001-2012 GUAN Xue-tao
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -19,12 +19,12 @@ struct thread_info;
  * contains the memory barrier to tell GCC not to cache `current'.
  */
 extern struct task_struct *__switch_to(struct task_struct *,
-		struct thread_info *, struct thread_info *);
+	struct thread_info *, struct thread_info *);
 
-#define switch_to(prev, next, last)					\
-do {									\
-	last = __switch_to(prev,					\
-		task_thread_info(prev), task_thread_info(next));	\
-} while (0)
+#define switch_to(prev, next, last)				    \
+	do {							    \
+		last = __switch_to(prev, task_thread_info(prev),    \
+				   task_thread_info(next));	    \
+	} while (0)
 
 #endif /* __UNICORE_SWITCH_TO_H__ */
diff --git a/arch/unicore32/include/asm/system.h b/arch/unicore32/include/asm/system.h
index cfc1498..a7f4057 100644
--- a/arch/unicore32/include/asm/system.h
+++ b/arch/unicore32/include/asm/system.h
@@ -1,7 +1,5 @@
 /* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
 #include <asm/barrier.h>
 #include <asm/cmpxchg.h>
-#include <asm/cr.h>
 #include <asm/exec.h>
-#include <asm/setup.h>
 #include <asm/switch_to.h>
diff --git a/arch/unicore32/kernel/head.S b/arch/unicore32/kernel/head.S
index fb1eb5c..e8f0b98 100644
--- a/arch/unicore32/kernel/head.S
+++ b/arch/unicore32/kernel/head.S
@@ -17,6 +17,7 @@
 #include <generated/asm-offsets.h>
 #include <asm/memory.h>
 #include <asm/thread_info.h>
+#include <asm/hwdef-copro.h>
 #include <asm/pgtable-hwdef.h>
 
 #if (PHYS_OFFSET & 0x003fffff)
diff --git a/arch/unicore32/kernel/setup.h b/arch/unicore32/kernel/setup.h
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
diff --git a/arch/unicore32/mm/alignment.c b/arch/unicore32/mm/alignment.c
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
diff --git a/arch/unicore32/mm/mm.h b/arch/unicore32/mm/mm.h
index 3296bca..3d2b524 100644
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
+extern void hook_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
+                       struct pt_regs *),
+             int sig, int code, const char *name);
 
 void __init bootmem_init(void);
 void uc32_mm_memblock_reserve(void);

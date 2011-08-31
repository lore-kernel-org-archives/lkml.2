Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab1HaV2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:28:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613Ab1HaV2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:28:41 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, ming.lei@canonical.com,
        stern@rowland.harvard.edu, Mark Salter <msalter@redhat.com>
Subject: [PATCH 18/24] C6X: headers
Date: Wed, 31 Aug 2011 17:26:53 -0400
Message-Id: <1314826019-22330-19-git-send-email-msalter@redhat.com>
In-Reply-To: <1314826019-22330-1-git-send-email-msalter@redhat.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/include/asm/asm-offsets.h |    1 +
 arch/c6x/include/asm/bitops.h      |  105 +++++++++++++
 arch/c6x/include/asm/byteorder.h   |   12 ++
 arch/c6x/include/asm/delay.h       |   67 +++++++++
 arch/c6x/include/asm/elf.h         |  113 ++++++++++++++
 arch/c6x/include/asm/ftrace.h      |    6 +
 arch/c6x/include/asm/linkage.h     |   30 ++++
 arch/c6x/include/asm/memblock.h    |    4 +
 arch/c6x/include/asm/mmu.h         |   18 +++
 arch/c6x/include/asm/mutex.h       |    6 +
 arch/c6x/include/asm/page.h        |   11 ++
 arch/c6x/include/asm/pgtable.h     |   81 ++++++++++
 arch/c6x/include/asm/procinfo.h    |   28 ++++
 arch/c6x/include/asm/prom.h        |    1 +
 arch/c6x/include/asm/sections.h    |   12 ++
 arch/c6x/include/asm/setup.h       |   29 ++++
 arch/c6x/include/asm/string.h      |   21 +++
 arch/c6x/include/asm/system.h      |  197 ++++++++++++++++++++++++
 arch/c6x/include/asm/tlb.h         |    8 +
 arch/c6x/include/asm/uaccess.h     |  107 +++++++++++++
 arch/c6x/include/asm/unaligned.h   |  288 ++++++++++++++++++++++++++++++++++++
 21 files changed, 1145 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/include/asm/asm-offsets.h
 create mode 100644 arch/c6x/include/asm/bitops.h
 create mode 100644 arch/c6x/include/asm/byteorder.h
 create mode 100644 arch/c6x/include/asm/delay.h
 create mode 100644 arch/c6x/include/asm/elf.h
 create mode 100644 arch/c6x/include/asm/ftrace.h
 create mode 100644 arch/c6x/include/asm/linkage.h
 create mode 100644 arch/c6x/include/asm/memblock.h
 create mode 100644 arch/c6x/include/asm/mmu.h
 create mode 100644 arch/c6x/include/asm/mutex.h
 create mode 100644 arch/c6x/include/asm/page.h
 create mode 100644 arch/c6x/include/asm/pgtable.h
 create mode 100644 arch/c6x/include/asm/procinfo.h
 create mode 100644 arch/c6x/include/asm/prom.h
 create mode 100644 arch/c6x/include/asm/sections.h
 create mode 100644 arch/c6x/include/asm/setup.h
 create mode 100644 arch/c6x/include/asm/string.h
 create mode 100644 arch/c6x/include/asm/system.h
 create mode 100644 arch/c6x/include/asm/tlb.h
 create mode 100644 arch/c6x/include/asm/uaccess.h
 create mode 100644 arch/c6x/include/asm/unaligned.h

diff --git a/arch/c6x/include/asm/asm-offsets.h b/arch/c6x/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/c6x/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/c6x/include/asm/bitops.h b/arch/c6x/include/asm/bitops.h
new file mode 100644
index 0000000..39ab7e8
--- /dev/null
+++ b/arch/c6x/include/asm/bitops.h
@@ -0,0 +1,105 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_BITOPS_H
+#define _ASM_C6X_BITOPS_H
+
+#ifdef __KERNEL__
+
+#include <linux/bitops.h>
+
+#include <asm/system.h>
+#include <asm/byteorder.h>
+
+/*
+ * clear_bit() doesn't provide any barrier for the compiler.
+ */
+#define smp_mb__before_clear_bit() barrier()
+#define smp_mb__after_clear_bit()  barrier()
+
+/*
+ * We are lucky, DSP is perfect for bitops: do it in 3 cycles
+ */
+
+/**
+ * __ffs - find first bit in word.
+ * @word: The word to search
+ *
+ * Undefined if no bit exists, so code should check against 0 first.
+ * Note __ffs(0) = undef, __ffs(1) = 0, __ffs(0x80000000) = 31.
+ *
+ */
+static inline unsigned long __ffs(unsigned long x)
+{
+	asm (" bitr  .M1  %0,%0\n"
+	     " nop\n"
+	     " lmbd  .L1  1,%0,%0\n"
+	     : "+a"(x));
+
+	return x;
+}
+
+/*
+ * ffz - find first zero in word.
+ * @word: The word to search
+ *
+ * Undefined if no zero exists, so code should check against ~0UL first.
+ */
+#define ffz(x) __ffs(~(x))
+
+/**
+ * fls - find last (most-significant) bit set
+ * @x: the word to search
+ *
+ * This is defined the same way as ffs.
+ * Note fls(0) = 0, fls(1) = 1, fls(0x80000000) = 32.
+ */
+static inline int fls(int x)
+{
+	if (!x)
+		return 0;
+
+	asm (" lmbd  .L1  1,%0,%0\n" : "+a"(x));
+
+	return 32 - x;
+}
+
+/**
+ * ffs - find first bit set
+ * @x: the word to search
+ *
+ * This is defined the same way as
+ * the libc and compiler builtin ffs routines, therefore
+ * differs in spirit from the above ffz (man ffs).
+ * Note ffs(0) = 0, ffs(1) = 1, ffs(0x80000000) = 32.
+ */
+static inline int ffs(int x)
+{
+	if (!x)
+		return 0;
+
+	return __ffs(x) + 1;
+}
+
+#include <asm-generic/bitops/__fls.h>
+#include <asm-generic/bitops/fls64.h>
+#include <asm-generic/bitops/find.h>
+
+#include <asm-generic/bitops/sched.h>
+#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
+
+#include <asm-generic/bitops/atomic.h>
+#include <asm-generic/bitops/non-atomic.h>
+#include <asm-generic/bitops/le.h>
+#include <asm-generic/bitops/ext2-atomic.h>
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_C6X_BITOPS_H */
diff --git a/arch/c6x/include/asm/byteorder.h b/arch/c6x/include/asm/byteorder.h
new file mode 100644
index 0000000..166038d
--- /dev/null
+++ b/arch/c6x/include/asm/byteorder.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_C6X_BYTEORDER_H
+#define _ASM_C6X_BYTEORDER_H
+
+#include <asm/types.h>
+
+#ifdef _BIG_ENDIAN
+#include <linux/byteorder/big_endian.h>
+#else /* _BIG_ENDIAN */
+#include <linux/byteorder/little_endian.h>
+#endif /* _BIG_ENDIAN */
+
+#endif /* _ASM_BYTEORDER_H */
diff --git a/arch/c6x/include/asm/delay.h b/arch/c6x/include/asm/delay.h
new file mode 100644
index 0000000..f314c2e
--- /dev/null
+++ b/arch/c6x/include/asm/delay.h
@@ -0,0 +1,67 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_DELAY_H
+#define _ASM_C6X_DELAY_H
+
+#include <linux/kernel.h>
+
+extern unsigned int ticks_per_ns_scaled;
+
+static inline void __delay(unsigned long loops)
+{
+	uint32_t tmp;
+
+	/* 6 cycles per loop */
+	asm volatile ("        mv    .s1  %0,%1\n"
+		      "0: [%1] b     .s1  0b\n"
+		      "        add   .l1  -6,%0,%0\n"
+		      "        cmplt .l1  1,%0,%1\n"
+		      "        nop   3\n"
+		      : "+a"(loops), "=A"(tmp));
+}
+
+static inline void _c6x_tickdelay(unsigned int x)
+{
+	uint32_t cnt, endcnt;
+
+	asm volatile ("        mvc   .s2   TSCL,%0\n"
+		      "        add   .s2x  %0,%1,%2\n"
+		      " ||     mvk   .l2   1,B0\n"
+		      "0: [B0] b     .s2   0b\n"
+		      "        mvc   .s2   TSCL,%0\n"
+		      "        sub   .s2   %0,%2,%0\n"
+		      "        cmpgt .l2   0,%0,B0\n"
+		      "        nop   2\n"
+		      : "=b"(cnt), "+a"(x), "=b"(endcnt) : : "B0");
+}
+
+/* use scaled math to avoid slow division */
+#define C6X_NDELAY_SCALE 10
+
+static inline void _ndelay(unsigned int n)
+{
+	_c6x_tickdelay((ticks_per_ns_scaled * n) >> C6X_NDELAY_SCALE);
+}
+
+static inline void _udelay(unsigned int n)
+{
+	while (n >= 10) {
+		_ndelay(10000);
+		n -= 10;
+	}
+	while (n-- > 0)
+		_ndelay(1000);
+}
+
+#define udelay(x) _udelay((unsigned int)(x))
+#define ndelay(x) _ndelay((unsigned int)(x))
+
+#endif /* _ASM_C6X_DELAY_H */
diff --git a/arch/c6x/include/asm/elf.h b/arch/c6x/include/asm/elf.h
new file mode 100644
index 0000000..d57865b
--- /dev/null
+++ b/arch/c6x/include/asm/elf.h
@@ -0,0 +1,113 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_ELF_H
+#define _ASM_C6X_ELF_H
+
+/*
+ * ELF register definitions..
+ */
+#include <asm/ptrace.h>
+
+typedef unsigned long elf_greg_t;
+typedef unsigned long elf_fpreg_t;
+
+#define ELF_NGREG  58
+#define ELF_NFPREG 1
+
+typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
+
+/*
+ * This is used to ensure we don't load something for the wrong architecture.
+ */
+#define elf_check_arch(x) ((x)->e_machine == EM_TI_C6000)
+
+#define elf_check_const_displacement(x) (1)
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#ifdef __LITTLE_ENDIAN__
+#define ELF_DATA	ELFDATA2LSB
+#else
+#define ELF_DATA	ELFDATA2MSB
+#endif
+
+#define ELF_CLASS	ELFCLASS32
+#define ELF_ARCH	EM_TI_C6000
+
+/* Nothing for now. Need to setup DP... */
+#define ELF_PLAT_INIT(_r)
+
+#define USE_ELF_CORE_DUMP
+#define ELF_EXEC_PAGESIZE	4096
+
+#define ELF_CORE_COPY_REGS(_dest, _regs)		\
+	memcpy((char *) &_dest, (char *) _regs,		\
+	sizeof(struct pt_regs));
+
+/* This yields a mask that user programs can use to figure out what
+   instruction set this cpu supports.  */
+
+#define ELF_HWCAP	(0)
+
+/* This yields a string that ld.so will use to load implementation
+   specific libraries for optimization.  This is more specific in
+   intent than poking at uname or /proc/cpuinfo.  */
+
+#define ELF_PLATFORM  (NULL)
+
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
+
+/* C6X specific section types */
+#define SHT_C6000_UNWIND	0x70000001
+#define SHT_C6000_PREEMPTMAP	0x70000002
+#define SHT_C6000_ATTRIBUTES	0x70000003
+
+/* C6X specific DT_ tags */
+#define DT_C6000_DSBT_BASE	0x70000000
+#define DT_C6000_DSBT_SIZE	0x70000001
+#define DT_C6000_PREEMPTMAP	0x70000002
+#define DT_C6000_DSBT_INDEX	0x70000003
+
+/* C6X specific relocs */
+#define R_C6000_NONE		0
+#define R_C6000_ABS32		1
+#define R_C6000_ABS16		2
+#define R_C6000_ABS8		3
+#define R_C6000_PCR_S21		4
+#define R_C6000_PCR_S12		5
+#define R_C6000_PCR_S10		6
+#define R_C6000_PCR_S7		7
+#define R_C6000_ABS_S16		8
+#define R_C6000_ABS_L16		9
+#define R_C6000_ABS_H16		10
+#define R_C6000_SBR_U15_B	11
+#define R_C6000_SBR_U15_H	12
+#define R_C6000_SBR_U15_W	13
+#define R_C6000_SBR_S16		14
+#define R_C6000_SBR_L16_B	15
+#define R_C6000_SBR_L16_H	16
+#define R_C6000_SBR_L16_W	17
+#define R_C6000_SBR_H16_B	18
+#define R_C6000_SBR_H16_H	19
+#define R_C6000_SBR_H16_W	20
+#define R_C6000_SBR_GOT_U15_W	21
+#define R_C6000_SBR_GOT_L16_W	22
+#define R_C6000_SBR_GOT_H16_W	23
+#define R_C6000_DSBT_INDEX	24
+#define R_C6000_PREL31		25
+#define R_C6000_COPY		26
+#define R_C6000_ALIGN		253
+#define R_C6000_FPHEAD		254
+#define R_C6000_NOCMP		255
+
+#endif /*_ASM_C6X_ELF_H */
diff --git a/arch/c6x/include/asm/ftrace.h b/arch/c6x/include/asm/ftrace.h
new file mode 100644
index 0000000..3701958
--- /dev/null
+++ b/arch/c6x/include/asm/ftrace.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_FTRACE_H
+#define _ASM_C6X_FTRACE_H
+
+/* empty */
+
+#endif /* _ASM_C6X_FTRACE_H */
diff --git a/arch/c6x/include/asm/linkage.h b/arch/c6x/include/asm/linkage.h
new file mode 100644
index 0000000..376925c
--- /dev/null
+++ b/arch/c6x/include/asm/linkage.h
@@ -0,0 +1,30 @@
+#ifndef _ASM_C6X_LINKAGE_H
+#define _ASM_C6X_LINKAGE_H
+
+#ifdef __ASSEMBLER__
+
+#define __ALIGN		.align 2
+#define __ALIGN_STR	".align 2"
+
+#ifndef __DSBT__
+#define ENTRY(name)		\
+	.global name @		\
+	__ALIGN @		\
+name:
+#else
+#define ENTRY(name)		\
+	.global name @		\
+	.hidden name @		\
+	__ALIGN @		\
+name:
+#endif
+
+#define ENDPROC(name)		\
+	.type name, @function @	\
+	.size name, . - name
+
+#endif
+
+#include <asm-generic/linkage.h>
+
+#endif /* _ASM_C6X_LINKAGE_H */
diff --git a/arch/c6x/include/asm/memblock.h b/arch/c6x/include/asm/memblock.h
new file mode 100644
index 0000000..1181a97
--- /dev/null
+++ b/arch/c6x/include/asm/memblock.h
@@ -0,0 +1,4 @@
+#ifndef _ASM_C6X_MEMBLOCK_H
+#define _ASM_C6X_MEMBLOCK_H
+
+#endif /* _ASM_C6X_MEMBLOCK_H */
diff --git a/arch/c6x/include/asm/mmu.h b/arch/c6x/include/asm/mmu.h
new file mode 100644
index 0000000..41592bf
--- /dev/null
+++ b/arch/c6x/include/asm/mmu.h
@@ -0,0 +1,18 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_MMU_H
+#define _ASM_C6X_MMU_H
+
+typedef struct {
+	unsigned long		end_brk;
+} mm_context_t;
+
+#endif /* _ASM_C6X_MMU_H */
diff --git a/arch/c6x/include/asm/mutex.h b/arch/c6x/include/asm/mutex.h
new file mode 100644
index 0000000..7a7248e
--- /dev/null
+++ b/arch/c6x/include/asm/mutex.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_C6X_MUTEX_H
+#define _ASM_C6X_MUTEX_H
+
+#include <asm-generic/mutex-null.h>
+
+#endif /* _ASM_C6X_MUTEX_H */
diff --git a/arch/c6x/include/asm/page.h b/arch/c6x/include/asm/page.h
new file mode 100644
index 0000000..d18e2b0
--- /dev/null
+++ b/arch/c6x/include/asm/page.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_C6X_PAGE_H
+#define _ASM_C6X_PAGE_H
+
+#define VM_DATA_DEFAULT_FLAGS \
+	(VM_READ | VM_WRITE | \
+	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0) | \
+		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+
+#include <asm-generic/page.h>
+
+#endif /* _ASM_C6X_PAGE_H */
diff --git a/arch/c6x/include/asm/pgtable.h b/arch/c6x/include/asm/pgtable.h
new file mode 100644
index 0000000..68c8af4
--- /dev/null
+++ b/arch/c6x/include/asm/pgtable.h
@@ -0,0 +1,81 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_PGTABLE_H
+#define _ASM_C6X_PGTABLE_H
+
+#include <asm-generic/4level-fixup.h>
+
+#include <asm/setup.h>
+#include <asm/page.h>
+
+/*
+ * All 32bit addresses are effectively valid for vmalloc...
+ * Sort of meaningless for non-VM targets.
+ */
+#define	VMALLOC_START	0
+#define	VMALLOC_END	0xffffffff
+
+#define pgd_present(pgd)	(1)
+#define pgd_none(pgd)		(0)
+#define pgd_bad(pgd)		(0)
+#define pgd_clear(pgdp)
+#define kern_addr_valid(addr) (1)
+
+#define pmd_offset(a, b)	((void *)0)
+#define pmd_none(x)		(!pmd_val(x))
+#define pmd_present(x)		(pmd_val(x))
+#define pmd_clear(xp)		do { set_pmd(xp, __pmd(0)); } while (0)
+#define pmd_bad(x)		(pmd_val(x) & ~PAGE_MASK)
+
+#define PAGE_NONE		__pgprot(0)    /* these mean nothing to NO_MM */
+#define PAGE_SHARED		__pgprot(0)    /* these mean nothing to NO_MM */
+#define PAGE_COPY		__pgprot(0)    /* these mean nothing to NO_MM */
+#define PAGE_READONLY	        __pgprot(0)    /* these mean nothing to NO_MM */
+#define PAGE_KERNEL		__pgprot(0)    /* these mean nothing to NO_MM */
+#define pgprot_noncached(prot)	(prot)
+
+extern void paging_init(void);
+
+#define __swp_type(x)		(0)
+#define __swp_offset(x)		(0)
+#define __swp_entry(typ, off)	((swp_entry_t) { ((typ) | ((off) << 7)) })
+#define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
+#define __swp_entry_to_pte(x)	((pte_t) { (x).val })
+
+static inline int pte_file(pte_t pte)
+{
+	return 0;
+}
+
+#define set_pte(pteptr, pteval) (*(pteptr) = pteval)
+#define set_pte_at(mm, addr, ptep, pteval) set_pte(ptep, pteval)
+
+/*
+ * ZERO_PAGE is a global shared page that is always zero: used
+ * for zero-mapped memory areas etc..
+ */
+#define ZERO_PAGE(vaddr)	virt_to_page(empty_zero_page)
+extern unsigned long empty_zero_page;
+
+#define swapper_pg_dir ((pgd_t *) 0)
+
+/*
+ * No page table caches to initialise
+ */
+#define pgtable_cache_init()   do { } while (0)
+#define io_remap_pfn_range      remap_pfn_range
+
+#define io_remap_page_range(vma, vaddr, paddr, size, prot)		\
+		remap_pfn_range(vma, vaddr, (paddr) >> PAGE_SHIFT, size, prot)
+
+#include <asm-generic/pgtable.h>
+
+#endif /* _ASM_C6X_PGTABLE_H */
diff --git a/arch/c6x/include/asm/procinfo.h b/arch/c6x/include/asm/procinfo.h
new file mode 100644
index 0000000..c139d1e
--- /dev/null
+++ b/arch/c6x/include/asm/procinfo.h
@@ -0,0 +1,28 @@
+/*
+ *  Copyright (C) 2010 Texas Instruments Incorporated
+ *  Author: Mark Salter (msalter@redhat.com)
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_PROCINFO_H
+#define _ASM_C6X_PROCINFO_H
+
+#ifdef __KERNEL__
+
+struct proc_info_list {
+	unsigned int		cpu_val;
+	unsigned int		cpu_mask;
+	const char		*arch_name;
+	const char		*elf_name;
+	unsigned int		elf_hwcap;
+};
+
+#else	/* __KERNEL__ */
+#include <asm/elf.h>
+#warning "Please include asm/elf.h instead"
+#endif	/* __KERNEL__ */
+
+#endif	/* _ASM_C6X_PROCINFO_H */
diff --git a/arch/c6x/include/asm/prom.h b/arch/c6x/include/asm/prom.h
new file mode 100644
index 0000000..b4ec95f
--- /dev/null
+++ b/arch/c6x/include/asm/prom.h
@@ -0,0 +1 @@
+/* dummy prom.h; here to make linux/of.h's #includes happy */
diff --git a/arch/c6x/include/asm/sections.h b/arch/c6x/include/asm/sections.h
new file mode 100644
index 0000000..f703989
--- /dev/null
+++ b/arch/c6x/include/asm/sections.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_C6X_SECTIONS_H
+#define _ASM_C6X_SECTIONS_H
+
+#include <asm-generic/sections.h>
+
+extern char _vectors_start[];
+extern char _vectors_end[];
+
+extern char _data_lma[];
+extern char _fdt_start[], _fdt_end[];
+
+#endif /* _ASM_C6X_SECTIONS_H */
diff --git a/arch/c6x/include/asm/setup.h b/arch/c6x/include/asm/setup.h
new file mode 100644
index 0000000..ee3188d
--- /dev/null
+++ b/arch/c6x/include/asm/setup.h
@@ -0,0 +1,29 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_SETUP_H
+#define _ASM_C6X_SETUP_H
+
+#define COMMAND_LINE_SIZE   1024
+
+#ifndef __ASSEMBLY__
+extern char c6x_command_line[COMMAND_LINE_SIZE];
+
+extern int c6x_add_memory(phys_addr_t start, unsigned long size);
+
+extern unsigned long ram_start;
+extern unsigned long ram_end;
+
+extern int c6x_num_cores;
+
+extern void machine_init(unsigned long dt_ptr);
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _ASM_C6X_SETUP_H */
diff --git a/arch/c6x/include/asm/string.h b/arch/c6x/include/asm/string.h
new file mode 100644
index 0000000..b21517c
--- /dev/null
+++ b/arch/c6x/include/asm/string.h
@@ -0,0 +1,21 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_STRING_H
+#define _ASM_C6X_STRING_H
+
+#include <asm/page.h>
+#include <linux/linkage.h>
+
+asmlinkage extern void *memcpy(void *to, const void *from, size_t n);
+
+#define __HAVE_ARCH_MEMCPY
+
+#endif /* _ASM_C6X_STRING_H */
diff --git a/arch/c6x/include/asm/system.h b/arch/c6x/include/asm/system.h
new file mode 100644
index 0000000..e783096
--- /dev/null
+++ b/arch/c6x/include/asm/system.h
@@ -0,0 +1,197 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_SYSTEM_H
+#define _ASM_C6X_SYSTEM_H
+
+#include <linux/linkage.h>
+#include <linux/irqflags.h>
+
+#define prepare_to_switch()    do { } while (0)
+
+struct task_struct;
+struct thread_struct;
+asmlinkage void *__switch_to(struct thread_struct *prev,
+			     struct thread_struct *next,
+			     struct task_struct *tsk);
+
+#define switch_to(prev, next, last)				\
+	do {							\
+		current->thread.wchan = (u_long) __builtin_return_address(0); \
+		(last) = __switch_to(&(prev)->thread,		\
+				     &(next)->thread, (prev));	\
+		mb();						\
+		current->thread.wchan = 0;			\
+	} while (0)
+
+/* Reset the board */
+#define HARD_RESET_NOW()
+
+#define get_creg(reg) \
+	({ unsigned int __x; \
+	   asm volatile ("mvc .s2 " #reg ",%0\n" : "=b"(__x)); __x; })
+
+#define set_creg(reg, v) \
+	do { unsigned int __x = (unsigned int)(v); \
+		asm volatile ("mvc .s2 %0," #reg "\n" : : "b"(__x)); \
+	} while (0)
+
+#define or_creg(reg, n) \
+	do { unsigned __x, __n = (unsigned)(n);		  \
+		asm volatile ("mvc .s2 " #reg ",%0\n"	  \
+			      "or  .l2 %1,%0,%0\n"	  \
+			      "mvc .s2 %0," #reg "\n"	  \
+			      "nop\n"			  \
+			      : "=&b"(__x) : "b"(__n));	  \
+	} while (0)
+
+#define and_creg(reg, n) \
+	do { unsigned __x, __n = (unsigned)(n);		  \
+		asm volatile ("mvc .s2 " #reg ",%0\n"	  \
+			      "and .l2 %1,%0,%0\n"	  \
+			      "mvc .s2 %0," #reg "\n"	  \
+			      "nop\n"    \
+			      : "=&b"(__x) : "b"(__n));	  \
+	} while (0)
+
+#define get_coreid() (get_creg(DNUM) & 0xff)
+
+/*
+ * Interrupt management
+ */
+
+/* Return from interrupt function */
+#define iret()	  asm volatile("B   .S2 IRP\n" \
+			       "NOP 5\n")
+
+/* Set/get IST */
+#define set_ist(x)	set_creg(ISTP, x)
+#define get_ist()       get_creg(ISTP)
+
+#ifdef __TMS320C6XPLUS__
+#define __dint()                 asm volatile ("DINT\n")
+#define __rint()                 asm volatile ("RINT\n")
+#endif
+
+/*
+ * Exception management
+ */
+
+#ifdef __TMS320C6XPLUS__
+asmlinkage void enable_exception(void);
+#define disable_exception()
+#define get_except_type()        get_creg(EFR)
+#define ack_exception(type)      set_creg(ECR, 1 << (type))
+#define get_iexcept()            get_creg(IERR)
+#define set_iexcept(mask)        set_creg(IERR, (mask))
+#else
+#define enable_exception()
+#define disable_exception()
+#define get_except_type()
+#define ack_exception(type)
+#define get_iexcept()
+#define set_iexcept(mask)
+#endif
+
+/*
+ * Misc. functions
+ */
+
+/* Return from exception function */
+#define eret()			 { asm("B   .S2 NRP\n"); \
+				   asm("NOP  5\n"); }
+
+#define nop()                    asm("NOP\n");
+#define mb()                     barrier()
+#define rmb()                    barrier()
+#define wmb()                    barrier()
+#define set_mb(var, value)       do { var = value;  mb(); } while (0)
+#define set_wmb(var, value)      do { var = value; wmb(); } while (0)
+
+#define smp_mb()	         barrier()
+#define smp_rmb()	         barrier()
+#define smp_wmb()	         barrier()
+#define smp_read_barrier_depends()	do { } while (0)
+
+#define xchg(ptr, x) \
+	((__typeof__(*(ptr)))__xchg((unsigned int)(x), (void *) (ptr), \
+				    sizeof(*(ptr))))
+#define tas(ptr)    xchg((ptr), 1)
+
+unsigned int _lmbd(unsigned int, unsigned int);
+unsigned int _bitr(unsigned int);
+
+struct __xchg_dummy { unsigned int a[100]; };
+#define __xg(x) ((volatile struct __xchg_dummy *)(x))
+
+static inline unsigned int __xchg(unsigned int x, volatile void *ptr, int size)
+{
+	unsigned int tmp;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	switch (size) {
+	case 1:
+		tmp = 0;
+		tmp = *((unsigned char *) ptr);
+		*((unsigned char *) ptr) = (unsigned char) x;
+		break;
+	case 2:
+		tmp = 0;
+		tmp = *((unsigned short *) ptr);
+		*((unsigned short *) ptr) = x;
+		break;
+	case 4:
+		tmp = 0;
+		tmp = *((unsigned int *) ptr);
+		*((unsigned int *) ptr) = x;
+		break;
+	}
+	local_irq_restore(flags);
+	return tmp;
+}
+
+#include <asm-generic/cmpxchg-local.h>
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)					\
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr),		\
+						     (unsigned long)(o), \
+						     (unsigned long)(n), \
+						     sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#include <asm-generic/cmpxchg.h>
+
+#define _extu(x, s, e)							\
+	({      unsigned int __x;					\
+		asm volatile ("extu .S2 %3,%1,%2,%0\n" :		\
+			      "=b"(__x) : "n"(s), "n"(e), "b"(x));	\
+	       __x; })
+
+
+extern unsigned int c6x_core_freq;
+
+struct pt_regs;
+
+extern void die(char *str, struct pt_regs *fp, int nr);
+extern asmlinkage int process_exception(struct pt_regs *regs);
+extern void time_init(void);
+extern void free_initmem(void);
+
+extern void (*c6x_restart)(void);
+extern void (*c6x_halt)(void);
+extern void (*c6x_power_off)(void);
+
+#endif /* _ASM_C6X_SYSTEM_H */
diff --git a/arch/c6x/include/asm/tlb.h b/arch/c6x/include/asm/tlb.h
new file mode 100644
index 0000000..8709e5e
--- /dev/null
+++ b/arch/c6x/include/asm/tlb.h
@@ -0,0 +1,8 @@
+#ifndef _ASM_C6X_TLB_H
+#define _ASM_C6X_TLB_H
+
+#define tlb_flush(tlb) flush_tlb_mm((tlb)->mm)
+
+#include <asm-generic/tlb.h>
+
+#endif /* _ASM_C6X_TLB_H */
diff --git a/arch/c6x/include/asm/uaccess.h b/arch/c6x/include/asm/uaccess.h
new file mode 100644
index 0000000..453dd26
--- /dev/null
+++ b/arch/c6x/include/asm/uaccess.h
@@ -0,0 +1,107 @@
+/*
+ *  Copyright (C) 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_UACCESS_H
+#define _ASM_C6X_UACCESS_H
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/string.h>
+
+#ifdef CONFIG_ACCESS_CHECK
+#define __access_ok _access_ok
+#endif
+
+/*
+ * __copy_from_user/copy_to_user are based on ones in asm-generic/uaccess.h
+ *
+ * C6X supports unaligned 32 and 64 bit loads and stores.
+ */
+static inline __must_check long __copy_from_user(void *to,
+		const void __user *from, unsigned long n)
+{
+	u32 tmp32;
+	u64 tmp64;
+
+	if (__builtin_constant_p(n)) {
+		switch (n) {
+		case 1:
+			*(u8 *)to = *(u8 __force *)from;
+			return 0;
+		case 4:
+			asm volatile ("ldnw .d1t1 *%2,%0\n"
+				      "nop  4\n"
+				      "stnw .d1t1 %0,*%1\n"
+				      : "=&a"(tmp32)
+				      : "A"(to), "a"(from)
+				      : "memory");
+			return 0;
+		case 8:
+			asm volatile ("ldndw .d1t1 *%2,%0\n"
+				      "nop   4\n"
+				      "stndw .d1t1 %0,*%1\n"
+				      : "=&a"(tmp64)
+				      : "a"(to), "a"(from)
+				      : "memory");
+			return 0;
+		default:
+			break;
+		}
+	}
+
+	memcpy(to, (const void __force *)from, n);
+	return 0;
+}
+
+static inline __must_check long __copy_to_user(void __user *to,
+		const void *from, unsigned long n)
+{
+	u32 tmp32;
+	u64 tmp64;
+
+	if (__builtin_constant_p(n)) {
+		switch (n) {
+		case 1:
+			*(u8 __force *)to = *(u8 *)from;
+			return 0;
+		case 4:
+			asm volatile ("ldnw .d1t1 *%2,%0\n"
+				      "nop  4\n"
+				      "stnw .d1t1 %0,*%1\n"
+				      : "=&a"(tmp32)
+				      : "a"(to), "a"(from)
+				      : "memory");
+			return 0;
+		case 8:
+			asm volatile ("ldndw .d1t1 *%2,%0\n"
+				      "nop   4\n"
+				      "stndw .d1t1 %0,*%1\n"
+				      : "=&a"(tmp64)
+				      : "a"(to), "a"(from)
+				      : "memory");
+			return 0;
+		default:
+			break;
+		}
+	}
+
+	memcpy((void __force *)to, from, n);
+	return 0;
+}
+
+#define __copy_to_user   __copy_to_user
+#define __copy_from_user __copy_from_user
+
+extern int _access_ok(unsigned long addr, unsigned long size);
+#ifdef CONFIG_ACCESS_CHECK
+#define __access_ok _access_ok
+#endif
+
+#include <asm-generic/uaccess.h>
+
+#endif /* _ASM_C6X_UACCESS_H */
diff --git a/arch/c6x/include/asm/unaligned.h b/arch/c6x/include/asm/unaligned.h
new file mode 100644
index 0000000..1dcb006
--- /dev/null
+++ b/arch/c6x/include/asm/unaligned.h
@@ -0,0 +1,288 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *  Rewritten for 2.6.3x: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef _ASM_C6X_UNALIGNED_H
+#define _ASM_C6X_UNALIGNED_H
+
+/*
+ * The C64x+ can do unaligned word and dword accesses in hardware
+ * using special load/store instructions.
+ */
+
+static inline u16 __get_unaligned_le16(const u8 *p)
+{
+	return p[0] | p[1] << 8;
+}
+
+static inline u16 __get_unaligned_be16(const u8 *p)
+{
+	return p[0] << 8 | p[1];
+}
+
+static inline void __put_unaligned_le16(u16 val, u8 *p)
+{
+	*p++ = val;
+	*p++ = val >> 8;
+}
+
+static inline void __put_unaligned_be16(u16 val, u8 *p)
+{
+	*p++ = val >> 8;
+	*p++ = val;
+}
+
+static inline u32 __get_unaligned32_swab(const u8 *p)
+{
+	u32 val = (u32) p;
+	asm volatile (" ldnw	.d1t1	*%0,%0\n"
+		      " nop	4\n"
+		      " swap2	.s1	%0,%0\n"
+		      " swap4	.l1	%0,%0\n"
+		      : "+a"(val));
+	return val;
+}
+
+static inline u32 __get_unaligned32(const u8 *p)
+{
+	u32 val = (u32) p;
+	asm volatile (" ldnw	.d1t1	*%0,%0\n"
+		      " nop     4\n"
+		      : "+a"(val));
+	return val;
+}
+
+static inline void __put_unaligned32_swab(u32 val, u8 *p)
+{
+	asm volatile (" swap2	.s1	%0,%0\n"
+		      " swap4	.l1	%0,%0\n"
+		      " stnw	.d2t1	%0,*%1\n"
+		      : : "a"(val), "b"(p) : "memory");
+}
+
+static inline void __put_unaligned32(u32 val, u8 *p)
+{
+	asm volatile (" stnw	.d2t1	%0,*%1\n"
+		      : : "a"(val), "b"(p) : "memory");
+}
+
+static inline u64 __get_unaligned64_swab(const u8 *p)
+{
+	u64 val;
+
+	asm volatile ("    ldndw   .d2t1  *%1,%0\n"
+		      "    nop	   4\n"
+		      "    swap2   .s1	  %p0,%P0\n"
+		      " || swap2   .l1    %P0,%p0\n"
+		      "    swap4   .l1    %p0,%p0\n"
+		      "    swap4   .l1    %P0,%P0\n"
+		      : "=a"(val) : "b"(p));
+	return val;
+}
+
+static inline u64 __get_unaligned64(const u8 *p)
+{
+	u64 val;
+	asm volatile (" ldndw	.d1t1	*%1,%0\n"
+		      " nop     4\n"
+		      : "=a"(val) : "a"(p));
+	return val;
+}
+
+static inline void __put_unaligned64_swab(u64 val, u8 *p)
+{
+	asm volatile ("    swap2  .s1     %p0,%P0\n"
+		      " || swap2  .l1	  %P0,%p0\n"
+		      "	   swap4  .l1	  %p0,%p0\n"
+		      "	   swap4  .l1	  %P0,%P0\n"
+		      "	   stndw  .d2t1	  %0,*%1\n"
+		      : : "a"(val), "b"(p) : "memory");
+}
+
+static inline void __put_unaligned64(u64 val, u8 *p)
+{
+	asm volatile (" stndw	.d2t1	%0,*%1\n"
+		      : : "a"(val), "b"(p) : "memory");
+}
+
+
+static inline u16 get_unaligned_le16(const void *p)
+{
+	return __get_unaligned_le16((const u8 *)p);
+}
+
+static inline u16 get_unaligned_be16(const void *p)
+{
+	return __get_unaligned_be16((const u8 *)p);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+	__put_unaligned_le16(val, p);
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+	__put_unaligned_be16(val, p);
+}
+
+
+static inline u32 get_unaligned_le32(const void *p)
+{
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	return __get_unaligned32_swab((const u8 *)p);
+#else
+	return __get_unaligned32((const u8 *)p);
+#endif
+}
+
+static inline u32 get_unaligned_be32(const void *p)
+{
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	return __get_unaligned32((const u8 *)p);
+#else
+	return __get_unaligned32_swab((const u8 *)p);
+#endif
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	__put_unaligned32_swab(val, p);
+#else
+	__put_unaligned32(val, p);
+#endif
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	__put_unaligned32(val, p);
+#else
+	__put_unaligned32_swab(val, p);
+#endif
+}
+
+static inline u64 get_unaligned_le64(const void *p)
+{
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	return __get_unaligned64_swab((const u8 *)p);
+#else
+	return __get_unaligned64((const u8 *)p);
+#endif
+}
+
+static inline u64 get_unaligned_be64(const void *p)
+{
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	return __get_unaligned64((const u8 *)p);
+#else
+	return __get_unaligned64_swab((const u8 *)p);
+#endif
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	__put_unaligned64_swab(val, p);
+#else
+	__put_unaligned64(val, p);
+#endif
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	__put_unaligned64(val, p);
+#else
+	__put_unaligned64_swab(val, p);
+#endif
+}
+
+/*
+ * Cause a link-time error if we try an unaligned access other than
+ * 1,2,4 or 8 bytes long
+ */
+extern int __bad_unaligned_access_size(void);
+
+#define __get_unaligned_le(ptr) (typeof(*(ptr)))({			\
+	sizeof(*(ptr)) == 1 ? *(ptr) :					\
+	  (sizeof(*(ptr)) == 2 ? get_unaligned_le16((ptr)) :		\
+	     (sizeof(*(ptr)) == 4 ? get_unaligned_le32((ptr)) :		\
+		(sizeof(*(ptr)) == 8 ? get_unaligned_le64((ptr)) :	\
+		   __bad_unaligned_access_size())));			\
+	})
+
+#define __get_unaligned_be(ptr) (__force typeof(*(ptr)))({	\
+	sizeof(*(ptr)) == 1 ? *(ptr) :					\
+	  (sizeof(*(ptr)) == 2 ? get_unaligned_be16((ptr)) :		\
+	     (sizeof(*(ptr)) == 4 ? get_unaligned_be32((ptr)) :		\
+		(sizeof(*(ptr)) == 8 ? get_unaligned_be64((ptr)) :	\
+		   __bad_unaligned_access_size())));			\
+	})
+
+#define __put_unaligned_le(val, ptr) ({					\
+	void *__gu_p = (ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		*(u8 *)__gu_p = (__force u8)(val);			\
+		break;							\
+	case 2:								\
+		put_unaligned_le16((__force u16)(val), __gu_p);		\
+		break;							\
+	case 4:								\
+		put_unaligned_le32((__force u32)(val), __gu_p);		\
+		break;							\
+	case 8:								\
+		put_unaligned_le64((__force u64)(val), __gu_p);		\
+		break;							\
+	default:							\
+		__bad_unaligned_access_size();				\
+		break;							\
+	}								\
+	(void)0; })
+
+#define __put_unaligned_be(val, ptr) ({					\
+	void *__gu_p = (ptr);						\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		*(u8 *)__gu_p = (__force u8)(val);			\
+		break;							\
+	case 2:								\
+		put_unaligned_be16((__force u16)(val), __gu_p);		\
+		break;							\
+	case 4:								\
+		put_unaligned_be32((__force u32)(val), __gu_p);		\
+		break;							\
+	case 8:								\
+		put_unaligned_be64((__force u64)(val), __gu_p);		\
+		break;							\
+	default:							\
+		__bad_unaligned_access_size();				\
+		break;							\
+	}								\
+	(void)0; })
+
+
+#ifdef _BIG_ENDIAN
+#define get_unaligned	__get_unaligned_be
+#define put_unaligned	__put_unaligned_be
+#define get_unaligned16	get_unaligned_be16
+#define get_unaligned32	get_unaligned_be32
+#define get_unaligned64	get_unaligned_be64
+#else
+#define get_unaligned	__get_unaligned_le
+#define put_unaligned	__put_unaligned_le
+#define get_unaligned16	get_unaligned_le16
+#define get_unaligned32	get_unaligned_le32
+#define get_unaligned64	get_unaligned_le64
+#endif
+
+#endif /* _ASM_C6X_UNALIGNED_H */
-- 
1.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab1FSLqr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 07:46:47 -0400
Received: from mail.southpole.se ([193.12.106.18]:37752 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab1FSLp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 07:45:29 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 16/19] OpenRISC: Headers
Date: Sun, 19 Jun 2011 13:43:42 +0200
Message-Id: <1308483825-6023-17-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308483825-6023-1-git-send-email-jonas@southpole.se>
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/include/asm/asm-offsets.h  |    1 +
 arch/openrisc/include/asm/bitops.h       |   59 +++
 arch/openrisc/include/asm/bitops/__ffs.h |   32 ++
 arch/openrisc/include/asm/bitops/__fls.h |   32 ++
 arch/openrisc/include/asm/bitops/ffs.h   |   31 ++
 arch/openrisc/include/asm/bitops/fls.h   |   32 ++
 arch/openrisc/include/asm/byteorder.h    |    1 +
 arch/openrisc/include/asm/cacheflush.h   |   25 ++
 arch/openrisc/include/asm/cpuinfo.h      |   34 ++
 arch/openrisc/include/asm/delay.h        |   44 +++
 arch/openrisc/include/asm/elf.h          |  109 ++++++
 arch/openrisc/include/asm/io.h           |  220 +++++++++++
 arch/openrisc/include/asm/linkage.h      |   25 ++
 arch/openrisc/include/asm/mutex.h        |   27 ++
 arch/openrisc/include/asm/param.h        |   26 ++
 arch/openrisc/include/asm/pci.h          |   28 ++
 arch/openrisc/include/asm/processor.h    |  117 ++++++
 arch/openrisc/include/asm/serial.h       |   36 ++
 arch/openrisc/include/asm/smp.h          |   22 ++
 arch/openrisc/include/asm/spinlock.h     |   24 ++
 arch/openrisc/include/asm/spr_defs.h     |  604 ++++++++++++++++++++++++++++++
 arch/openrisc/include/asm/string.h       |   34 ++
 arch/openrisc/include/asm/system.h       |   56 +++
 arch/openrisc/include/asm/unaligned.h    |   51 +++
 24 files changed, 1670 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/include/asm/asm-offsets.h
 create mode 100644 arch/openrisc/include/asm/bitops.h
 create mode 100644 arch/openrisc/include/asm/bitops/__ffs.h
 create mode 100644 arch/openrisc/include/asm/bitops/__fls.h
 create mode 100644 arch/openrisc/include/asm/bitops/ffs.h
 create mode 100644 arch/openrisc/include/asm/bitops/fls.h
 create mode 100644 arch/openrisc/include/asm/byteorder.h
 create mode 100644 arch/openrisc/include/asm/cacheflush.h
 create mode 100644 arch/openrisc/include/asm/cpuinfo.h
 create mode 100644 arch/openrisc/include/asm/delay.h
 create mode 100644 arch/openrisc/include/asm/elf.h
 create mode 100644 arch/openrisc/include/asm/io.h
 create mode 100644 arch/openrisc/include/asm/linkage.h
 create mode 100644 arch/openrisc/include/asm/mutex.h
 create mode 100644 arch/openrisc/include/asm/param.h
 create mode 100644 arch/openrisc/include/asm/pci.h
 create mode 100644 arch/openrisc/include/asm/processor.h
 create mode 100644 arch/openrisc/include/asm/serial.h
 create mode 100644 arch/openrisc/include/asm/smp.h
 create mode 100644 arch/openrisc/include/asm/spinlock.h
 create mode 100644 arch/openrisc/include/asm/spr_defs.h
 create mode 100644 arch/openrisc/include/asm/string.h
 create mode 100644 arch/openrisc/include/asm/system.h
 create mode 100644 arch/openrisc/include/asm/unaligned.h

diff --git a/arch/openrisc/include/asm/asm-offsets.h b/arch/openrisc/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/openrisc/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/openrisc/include/asm/bitops.h b/arch/openrisc/include/asm/bitops.h
new file mode 100644
index 0000000..a9e11ef
--- /dev/null
+++ b/arch/openrisc/include/asm/bitops.h
@@ -0,0 +1,59 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_BITOPS_H
+#define __ASM_OPENRISC_BITOPS_H
+
+/*
+ * Where we haven't written assembly versions yet, we fall back to the
+ * generic implementations.  Otherwise, we pull in our (hopefully)
+ * optimized versions.
+ */
+
+#include <linux/irqflags.h>
+#include <linux/compiler.h>
+
+/*
+ * clear_bit may not imply a memory barrier
+ */
+#ifndef smp_mb__before_clear_bit
+#define smp_mb__before_clear_bit()	smp_mb()
+#define smp_mb__after_clear_bit()	smp_mb()
+#endif
+
+#include <asm/bitops/__ffs.h>
+#include <asm-generic/bitops/ffz.h>
+#include <asm/bitops/fls.h>
+#include <asm/bitops/__fls.h>
+#include <asm-generic/bitops/fls64.h>
+#include <asm-generic/bitops/find.h>
+
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
+#include <asm-generic/bitops/sched.h>
+#include <asm/bitops/ffs.h>
+#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
+
+#include <asm-generic/bitops/atomic.h>
+#include <asm-generic/bitops/non-atomic.h>
+#include <asm-generic/bitops/ext2-atomic.h>
+
+#endif /* __ASM_GENERIC_BITOPS_H */
diff --git a/arch/openrisc/include/asm/bitops/__ffs.h b/arch/openrisc/include/asm/bitops/__ffs.h
new file mode 100644
index 0000000..8144041
--- /dev/null
+++ b/arch/openrisc/include/asm/bitops/__ffs.h
@@ -0,0 +1,32 @@
+/*
+ * OpenRISC Linux
+ *
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC___FFS_H
+#define __ASM_OPENRISC___FFS_H
+
+
+#ifdef CONFIG_OPENRISC_HAVE_INST_FF1
+
+static inline unsigned long __ffs(unsigned long x) {
+	int ret;
+
+	__asm__ ( "l.ff1 %0,%1"
+		: "=r" (ret)
+		: "r" (x));
+
+	return ret-1;
+}
+
+#else
+#include <asm-generic/bitops/__ffs.h>
+#endif
+
+#endif /* __ASM_OPENRISC___FFS_H */
diff --git a/arch/openrisc/include/asm/bitops/__fls.h b/arch/openrisc/include/asm/bitops/__fls.h
new file mode 100644
index 0000000..4204c0d
--- /dev/null
+++ b/arch/openrisc/include/asm/bitops/__fls.h
@@ -0,0 +1,32 @@
+/*
+ * OpenRISC Linux
+ *
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC___FLS_H
+#define __ASM_OPENRISC___FLS_H
+
+
+#ifdef CONFIG_OPENRISC_HAVE_INST_FL1
+
+static inline unsigned long __fls(unsigned long x) {
+	int ret;
+
+	__asm__ ( "l.fl1 %0,%1"
+		: "=r" (ret)
+		: "r" (x));
+
+	return ret-1;
+}
+
+#else
+#include <asm-generic/bitops/__fls.h>
+#endif
+
+#endif /* __ASM_OPENRISC___FLS_H */
diff --git a/arch/openrisc/include/asm/bitops/ffs.h b/arch/openrisc/include/asm/bitops/ffs.h
new file mode 100644
index 0000000..cfa36cf
--- /dev/null
+++ b/arch/openrisc/include/asm/bitops/ffs.h
@@ -0,0 +1,31 @@
+/*
+ * OpenRISC Linux
+ *
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_FFS_H
+#define __ASM_OPENRISC_FFS_H
+
+#ifdef CONFIG_OPENRISC_HAVE_INST_FF1
+
+static inline int ffs(int x) {
+	int ret;
+
+	__asm__ ( "l.ff1 %0,%1"
+		: "=r" (ret)
+		: "r" (x));
+
+	return ret;
+}
+
+#else
+#include <asm-generic/bitops/ffs.h>
+#endif
+
+#endif /* __ASM_OPENRISC_FFS_H */
diff --git a/arch/openrisc/include/asm/bitops/fls.h b/arch/openrisc/include/asm/bitops/fls.h
new file mode 100644
index 0000000..0e2d500
--- /dev/null
+++ b/arch/openrisc/include/asm/bitops/fls.h
@@ -0,0 +1,32 @@
+/*
+ * OpenRISC Linux
+ *
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_FLS_H
+#define __ASM_OPENRISC_FLS_H
+
+
+#ifdef CONFIG_OPENRISC_HAVE_INST_FL1
+
+static inline int fls(int x) {
+	int ret;
+
+	__asm__ ( "l.fl1 %0,%1"
+		: "=r" (ret)
+		: "r" (x));
+
+	return ret;
+}
+
+#else
+#include <asm-generic/bitops/fls.h>
+#endif
+
+#endif /* __ASM_OPENRISC_FLS_H */
diff --git a/arch/openrisc/include/asm/byteorder.h b/arch/openrisc/include/asm/byteorder.h
new file mode 100644
index 0000000..60d14f7
--- /dev/null
+++ b/arch/openrisc/include/asm/byteorder.h
@@ -0,0 +1 @@
+#include <linux/byteorder/big_endian.h>
diff --git a/arch/openrisc/include/asm/cacheflush.h b/arch/openrisc/include/asm/cacheflush.h
new file mode 100644
index 0000000..27b6439
--- /dev/null
+++ b/arch/openrisc/include/asm/cacheflush.h
@@ -0,0 +1,25 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * The cache doesn't need to be flushed when TLB entries change when
+ * the cache is mapped to physical memory, not virtual memory...
+ * that's what the generic implementation gets us.
+ */
+
+#include <asm-generic/cacheflush.h>
diff --git a/arch/openrisc/include/asm/cpuinfo.h b/arch/openrisc/include/asm/cpuinfo.h
new file mode 100644
index 0000000..917318b
--- /dev/null
+++ b/arch/openrisc/include/asm/cpuinfo.h
@@ -0,0 +1,34 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_CPUINFO_H
+#define __ASM_OPENRISC_CPUINFO_H
+
+struct cpuinfo {
+	u32 clock_frequency;
+
+	u32 icache_size;
+	u32 icache_block_size;
+
+	u32 dcache_size;
+	u32 dcache_block_size;
+};
+
+extern struct cpuinfo cpuinfo;
+
+#endif /* __ASM_OPENRISC_CPUINFO_H */
diff --git a/arch/openrisc/include/asm/delay.h b/arch/openrisc/include/asm/delay.h
new file mode 100644
index 0000000..41476bd
--- /dev/null
+++ b/arch/openrisc/include/asm/delay.h
@@ -0,0 +1,44 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_DELAY_H
+#define __ASM_OPENRISC_DELAY_H
+
+#include <linux/linkage.h>
+#include <asm/param.h>
+
+extern inline void __delay(int loops)
+{
+	__asm__ __volatile__ (
+			      "l.srli %0,%0,1;"
+			      "1: l.sfeqi %0,0;"
+			      "l.bnf 1b;"
+			      "l.addi %0,%0,-1;"
+			      : "=r" (loops): "0" (loops));
+}
+
+/* Use only for very small delays ( < 1 msec).  */
+
+extern unsigned long loops_per_jiffy;
+
+extern inline void udelay(unsigned long usecs)
+{
+	__delay( usecs * loops_per_jiffy * HZ / 1000000 );
+}
+
+#endif
diff --git a/arch/openrisc/include/asm/elf.h b/arch/openrisc/include/asm/elf.h
new file mode 100644
index 0000000..a2055f6
--- /dev/null
+++ b/arch/openrisc/include/asm/elf.h
@@ -0,0 +1,109 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_ELF_H
+#define __ASM_OPENRISC_ELF_H
+
+/*
+ * ELF register definitions..
+ */
+#include <asm/types.h>
+#include <asm/ptrace.h>
+
+
+/* The OR1K relocation types... not all relevant for module loader */
+#define R_OR32_NONE	0
+#define R_OR32_32	1
+#define R_OR32_16	2
+#define R_OR32_8	3
+#define R_OR32_CONST	4
+#define R_OR32_CONSTH	5
+#define R_OR32_JUMPTARG	6
+#define R_OR32_VTINHERIT 7
+#define R_OR32_VTENTRY	8
+
+typedef unsigned long elf_greg_t;
+
+/* Note that NGREG is defined to ELF_NGREG in include/linux/elfcore.h, and is
+   thus exposed to user-space. */
+#define ELF_NGREG (sizeof (struct pt_regs) / sizeof(elf_greg_t))
+typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+
+/* A placeholder; OR32 does not have fp support yes, so no fp regs for now.  */
+typedef unsigned long elf_fpregset_t;
+
+/* This should be moved to include/linux/elf.h */
+#define EM_OR32         0x8472
+#define EM_OPENRISC     92     /* OpenRISC 32-bit embedded processor */
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#define ELF_ARCH	EM_OR32
+#define ELF_CLASS	ELFCLASS32
+#define ELF_DATA	ELFDATA2MSB
+
+#ifdef __KERNEL__
+
+/*
+ * This is used to ensure we don't load something for the wrong architecture.
+ */
+
+#define elf_check_arch(x) \
+       (((x)->e_machine == EM_OR32) || ((x)->e_machine == EM_OPENRISC))
+
+/* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
+   use of this is to invoke "./ld.so someprog" to test out a new version of
+   the loader.  We need to make sure that it is out of the way of the program
+   that it will "exec", and that there is sufficient room for the brk.  */
+
+#define ELF_ET_DYN_BASE         (0x08000000)
+
+/*
+ * Enable dump using regset.
+ * This covers all of general/DSP/FPU regs.
+ */
+#define CORE_DUMP_USE_REGSET
+
+#define ELF_EXEC_PAGESIZE	8192
+
+#define ELF_CORE_COPY_REGS(gregs, regs) \
+	memcpy(gregs, regs, \
+	       sizeof(struct pt_regs) < sizeof(elf_gregset_t)? \
+	       sizeof(struct pt_regs): sizeof(elf_gregset_t));
+
+
+/* This yields a mask that user programs can use to figure out what
+   instruction set this cpu supports.  This could be done in userspace,
+   but it's not easy, and we've already done it here.  */
+
+#define ELF_HWCAP	(0)
+
+/* This yields a string that ld.so will use to load implementation
+   specific libraries for optimization.  This is more specific in
+   intent than poking at uname or /proc/cpuinfo.
+
+   For the moment, we have only optimizations for the Intel generations,
+   but that could change... */
+
+#define ELF_PLATFORM	(NULL)
+
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
+
+#endif /* __KERNEL__ */
+#endif
diff --git a/arch/openrisc/include/asm/io.h b/arch/openrisc/include/asm/io.h
new file mode 100644
index 0000000..592b91c
--- /dev/null
+++ b/arch/openrisc/include/asm/io.h
@@ -0,0 +1,220 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_IO_H
+#define __ASM_OPENRISC_IO_H
+
+#include <asm/page.h>   /* for __va, __pa */
+#include <asm/byteorder.h>
+
+
+/*
+ * Change virtual addresses to physical addresses and vice versa.
+ */
+
+static inline unsigned long
+virt_to_phys(volatile void * address)
+{
+	return __pa(address);
+}
+
+static inline void*
+phys_to_virt(unsigned long address)
+{
+	return __va(address);
+}
+
+extern void __iomem*
+__ioremap(phys_addr_t offset, unsigned long size, unsigned long flags);
+
+static inline void __iomem*
+ioremap(phys_addr_t offset, unsigned long size)
+{
+	return __ioremap(offset, size, 0);
+}
+
+/* #define _PAGE_CI       0x002 */
+static inline void __iomem*
+ioremap_nocache(phys_addr_t offset, unsigned long size)
+{
+	return __ioremap(offset, size, 0x002);
+}
+
+extern void iounmap(void *addr);
+
+//#define page_to_phys(page)	((page - mem_map) << PAGE_SHIFT)
+
+/*
+ * IO bus memory addresses are also 1:1 with the physical address
+ */
+
+/* Deprecated */
+#define virt_to_bus virt_to_phys
+#define bus_to_virt phys_to_virt
+
+#define __raw_readb(addr) (*(volatile unsigned char *) (addr))
+#define __raw_readw(addr) (*(volatile unsigned short *) (addr))
+#define __raw_readl(addr) (*(volatile unsigned int *) (addr))
+
+#define __raw_writeb(b,addr) ((*(volatile unsigned char *) (addr)) = (b))
+#define __raw_writew(b,addr) ((*(volatile unsigned short *) (addr)) = (b))
+#define __raw_writel(b,addr) ((*(volatile unsigned int *) (addr)) = (b))
+
+/* Wishbone Interface
+ *
+ * The Wishbone bus can be both big or little-endian, but is generally
+ * of the same endianess as the CPU ("native endian").  As peripherals
+ * are generally synthesized together with the CPU, they will also be
+ * of the same endianess.  In order to simplify things, we assume for
+ * now that there are no memory-mapped IO devices on any other bus than
+ * then the local Wishbone bus and that these devices are all native
+ * endian.
+ */
+
+#define wb_ioread8(p)  __raw_readb(p)
+#define wb_ioread16(p) __raw_readw(p)
+#define wb_ioread32(p) __raw_readl(p)
+
+#define wb_iowrite8(v,p)  __raw_writeb(v,p)
+#define wb_iowrite16(v,p) __raw_writew(v,p)
+#define wb_iowrite32(v,p) __raw_writel(v,p)
+
+/*
+ * readX/writeX() are used to access memory mapped devices.
+ *
+ * Note that these accessors make assumptions about the endianess of
+ * the accessed device and, as such, aren't particularly useful on a
+ * platform like OpenRISC where the device endianess is generally
+ * determined at synthesis time and where the device endianess is
+ * generally the same as the CPU (native endian).
+ *
+ * For OpenRISC it is recommended to use the __iomem accessors
+ * instead of these MMIO accessors.
+ */
+
+#define readb __raw_readb
+#define readw(addr) (le16_to_cpu(__raw_readw(addr)))
+#define readl(addr) (le32_to_cpu(__raw_readl(addr)))
+
+#define writeb __raw_writeb
+#define writew(b,addr) __raw_writew(cpu_to_le16(b), addr)
+#define writel(b,addr) __raw_writel(cpu_to_le32(b), addr)
+
+#define memset_io(a,b,c)	memset((void *)(a),(b),(c))
+#define memcpy_fromio(a,b,c)	memcpy((a),(void *)(b),(c))
+#define memcpy_toio(a,b,c)	memcpy((void *)(a),(b),(c))
+
+/*
+ * Again, OpenRISC does not require mem IO specific function.
+ */
+
+#define eth_io_copy_and_sum(a,b,c,d)	eth_copy_and_sum((a),(void *)(b),(c),(d))
+
+#define IO_BASE			0x0
+#define IO_SPACE_LIMIT 		0xffffffff
+
+#define inb(port)		(*(volatile unsigned char *) (port+IO_BASE))
+#define outb(value,port)	((*(volatile unsigned char *) (port+IO_BASE)) = (value))
+
+#define inb_p(port)             inb((port))
+#define outb_p(val, port)       outb((val), (port))
+
+static inline void ioread8_rep(void __iomem *port, void *buf, unsigned long count)
+{
+	unsigned char *p = buf;
+	while (count--)
+		*p++ = readb(port);
+}
+
+static inline void ioread16_rep(void __iomem *port, void *buf, unsigned long count)
+{
+	unsigned short *p = buf;
+	while (count >= 2) {
+		*p++ = readw(port);
+		count -= 2;
+	}
+}
+
+static inline void ioread32_rep(void __iomem *port, void *buf, unsigned long count)
+{
+	unsigned int *p = buf;
+	while (count >= 4) {
+		*p++ = readl(port);
+		count -= 4;
+	}
+}
+
+static inline void iowrite8_rep(void __iomem *port, void *buf, unsigned long count)
+{
+	unsigned char *p = buf;
+	while (count--)
+		writeb(*p++, port);
+}
+
+static inline void iowrite16_rep(void __iomem *port, void *buf, unsigned long count)
+{
+	unsigned short *p = buf;
+	while (count >= 2) {
+		writew(*p++, port);
+		count -= 2;
+	}
+}
+
+static inline void iowrite32_rep(void __iomem *port, void *buf, unsigned long count)
+{
+	unsigned int *p = buf;
+	while (count >= 4) {
+		writel(*p++, port);
+		count -= 4;
+	}
+}
+
+/*
+ * Convert a physical pointer to a virtual kernel pointer for /dev/mem
+ * access
+ */
+#define xlate_dev_mem_ptr(p)	__va(p)
+
+/*
+ * Convert a virtual cached pointer to an uncached pointer
+ */
+#define xlate_dev_kmem_ptr(p)	p
+
+
+/* Create a virtual mapping cookie for an IO port range */
+extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
+extern void ioport_unmap(void __iomem *);
+
+/* __iomem accessors
+ *
+ * These accessors work on __iomem cookies and the recommended means of
+ * doing MMIO access for OpenRISC.  The current assumption for OpenRISC
+ * is that the Wishbone bus is the only bus with memory mapped peripherals
+ * and that the bus endianess (and device endianess) is the same as that
+ * of the CPU.
+ */
+
+#define ioread8(addr)           wb_ioread8(addr)
+#define ioread16(addr)          wb_ioread16(addr)
+#define ioread32(addr)          wb_ioread32(addr)
+
+#define iowrite8(v, addr)       wb_iowrite8((v),(addr))
+#define iowrite16(v, addr)      wb_iowrite16((v),(addr))
+#define iowrite32(v, addr)      wb_iowrite32((v),(addr))
+
+#endif
diff --git a/arch/openrisc/include/asm/linkage.h b/arch/openrisc/include/asm/linkage.h
new file mode 100644
index 0000000..e263875
--- /dev/null
+++ b/arch/openrisc/include/asm/linkage.h
@@ -0,0 +1,25 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_LINKAGE_H
+#define __ASM_OPENRISC_LINKAGE_H
+
+#define __ALIGN      .align 0
+#define __ALIGN_STR ".align 0"
+
+#endif /* __ASM_OPENRISC_LINKAGE_H */
diff --git a/arch/openrisc/include/asm/mutex.h b/arch/openrisc/include/asm/mutex.h
new file mode 100644
index 0000000..b85a0cf
--- /dev/null
+++ b/arch/openrisc/include/asm/mutex.h
@@ -0,0 +1,27 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * Pull in the generic implementation for the mutex fastpath.
+ *
+ * TODO: implement optimized primitives instead, or leave the generic
+ * implementation in place, or pick the atomic_xchg() based generic
+ * implementation. (see asm-generic/mutex-xchg.h for details)
+ */
+
+#include <asm-generic/mutex-dec.h>
diff --git a/arch/openrisc/include/asm/param.h b/arch/openrisc/include/asm/param.h
new file mode 100644
index 0000000..c39a336
--- /dev/null
+++ b/arch/openrisc/include/asm/param.h
@@ -0,0 +1,26 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_PARAM_H
+#define __ASM_OPENRISC_PARAM_H
+
+#define EXEC_PAGESIZE	8192
+
+#include <asm-generic/param.h>
+
+#endif /* __ASM_OPENRISC_PARAM_H */
diff --git a/arch/openrisc/include/asm/pci.h b/arch/openrisc/include/asm/pci.h
new file mode 100644
index 0000000..47c3e45
--- /dev/null
+++ b/arch/openrisc/include/asm/pci.h
@@ -0,0 +1,28 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_PCI_H
+#define __ASM_OPENRISC_PCI_H
+
+#include <asm-generic/pci.h>
+
+/*
+ * no PCI support yet implemented for OpenRISC
+ */
+
+#endif /* __ASM_OPENRISC_PCI_H */
diff --git a/arch/openrisc/include/asm/processor.h b/arch/openrisc/include/asm/processor.h
new file mode 100644
index 0000000..c856f78
--- /dev/null
+++ b/arch/openrisc/include/asm/processor.h
@@ -0,0 +1,117 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_PROCESSOR_H
+#define __ASM_OPENRISC_PROCESSOR_H
+
+#include <asm/spr_defs.h>
+#include <asm/page.h>
+#include <asm/ptrace.h>
+#define STACK_TOP       TASK_SIZE
+#define STACK_TOP_MAX	STACK_TOP
+/* Kernel and user SR register setting */
+#define KERNEL_SR (SPR_SR_DME | SPR_SR_IME | SPR_SR_ICE | SPR_SR_DCE | SPR_SR_SM)
+#define USER_SR   (SPR_SR_DME | SPR_SR_IME | SPR_SR_ICE | SPR_SR_DCE | SPR_SR_IEE | SPR_SR_TEE)
+/*
+ * Default implementation of macro that returns current
+ * instruction pointer ("program counter").
+ */
+#define current_text_addr() ({ __label__ _l; _l: &&_l;})
+
+/*
+ * User space process size. This is hardcoded into a few places,
+ * so don't change it unless you know what you are doing.
+ */
+
+#define TASK_SIZE       (0x80000000UL)
+
+/* This decides where the kernel will search for a free chunk of vm
+ * space during mmap's.
+ */
+#define TASK_UNMAPPED_BASE      (TASK_SIZE / 8 * 3)
+
+#ifndef __ASSEMBLY__
+
+struct task_struct;
+
+struct thread_struct {
+#if 0
+	unsigned long  usp;     /* user space pointer */
+	unsigned long  ksp;     /* kernel stack pointer */
+	struct pt_regs *regs;   /* pointer to saved register state */
+        mm_segment_t   fs;      /* for get_fs() validation */
+	signed long    last_syscall;
+#endif
+};
+
+/*
+ * At user->kernel entry, the pt_regs struct is stacked on the top of the
+ * kernel-stack.  This macro allows us to find those regs for a task.
+ * Notice that subsequent pt_regs stackings, like recursive interrupts
+ * occurring while we're in the kernel, won't affect this - only the first
+ * user->kernel transition registers are reached by this (i.e. not regs
+ * for running signal handler)
+ */
+#define user_regs(thread_info) (((struct pt_regs *)((unsigned long)(thread_info) + THREAD_SIZE - STACK_FRAME_OVERHEAD)) - 1)
+
+/*
+ * Dito but for the currently running task
+ */
+
+#define task_pt_regs(task) user_regs(task_thread_info(task))
+#define current_regs() user_regs(current_thread_info())
+
+extern inline void prepare_to_copy(struct task_struct *tsk)
+{
+}
+
+#define INIT_SP         (sizeof(init_stack) + (unsigned long) &init_stack)
+
+#define INIT_THREAD  { }
+
+
+#define KSTK_EIP(tsk)   (task_pt_regs(tsk)->pc);
+#define KSTK_ESP(tsk)   (task_pt_regs(tsk)->sp);
+
+
+extern int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
+
+void start_thread(struct pt_regs *regs, unsigned long nip, unsigned long sp);
+void release_thread(struct task_struct *);
+unsigned long get_wchan(struct task_struct *p);
+
+/*
+ * Free current thread data structures etc..
+ */
+
+extern inline void exit_thread(void)
+{
+         /* Nothing needs to be done.  */
+}
+
+/*
+ * Return saved PC of a blocked thread. For now, this is the "user" PC
+ */
+extern unsigned long thread_saved_pc(struct task_struct *t);
+
+#define init_stack      (init_thread_union.stack)
+
+#define cpu_relax()     do { } while (0)
+
+#endif /* __ASSEMBLY__ */
+#endif /* __ASM_OPENRISC_PROCESSOR_H */
diff --git a/arch/openrisc/include/asm/serial.h b/arch/openrisc/include/asm/serial.h
new file mode 100644
index 0000000..270a452
--- /dev/null
+++ b/arch/openrisc/include/asm/serial.h
@@ -0,0 +1,36 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_SERIAL_H
+#define __ASM_OPENRISC_SERIAL_H
+
+#ifdef __KERNEL__
+
+#include <asm/cpuinfo.h>
+
+/* There's a generic version of this file, but it assumes a 1.8MHz UART clk...
+ * this, on the other hand, assumes the UART clock is tied to the system
+ * clock... 8250_early.c (early 8250 serial console) actually uses this, so
+ * it needs to be correct to get the early console working.
+ */
+
+#define BASE_BAUD (cpuinfo.clock_frequency/16)
+
+#endif /* __KERNEL__ */
+
+#endif /* __ASM_OPENRISC_SERIAL_H */
diff --git a/arch/openrisc/include/asm/smp.h b/arch/openrisc/include/asm/smp.h
new file mode 100644
index 0000000..fadff1e
--- /dev/null
+++ b/arch/openrisc/include/asm/smp.h
@@ -0,0 +1,22 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_SMP_H
+#define __ASM_OPENRISC_SMP_H
+
+#endif
diff --git a/arch/openrisc/include/asm/spinlock.h b/arch/openrisc/include/asm/spinlock.h
new file mode 100644
index 0000000..fd00a3a
--- /dev/null
+++ b/arch/openrisc/include/asm/spinlock.h
@@ -0,0 +1,24 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_SPINLOCK_H
+#define __ASM_OPENRISC_SPINLOCK_H
+
+#error "or32 doesn't do SMP yet"
+
+#endif
diff --git a/arch/openrisc/include/asm/spr_defs.h b/arch/openrisc/include/asm/spr_defs.h
new file mode 100644
index 0000000..9d72c8a
--- /dev/null
+++ b/arch/openrisc/include/asm/spr_defs.h
@@ -0,0 +1,604 @@
+/*
+ * OpenRISC Linux
+ *
+ * SPR Definitions
+ *
+ * Copyright (C) 2000 Damjan Lampret
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2008, 2010 Embecosm Limited
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This file is part of OpenRISC 1000 Architectural Simulator.
+ */
+
+#ifndef SPR_DEFS__H
+#define SPR_DEFS__H
+
+/* Definition of special-purpose registers (SPRs). */
+
+#define MAX_GRPS (32)
+#define MAX_SPRS_PER_GRP_BITS (11)
+#define MAX_SPRS_PER_GRP (1 << MAX_SPRS_PER_GRP_BITS)
+#define MAX_SPRS (0x10000)
+
+/* Base addresses for the groups */
+#define SPRGROUP_SYS	(0<< MAX_SPRS_PER_GRP_BITS)
+#define SPRGROUP_DMMU	(1<< MAX_SPRS_PER_GRP_BITS)
+#define SPRGROUP_IMMU	(2<< MAX_SPRS_PER_GRP_BITS)
+#define SPRGROUP_DC	(3<< MAX_SPRS_PER_GRP_BITS)
+#define SPRGROUP_IC	(4<< MAX_SPRS_PER_GRP_BITS)
+#define SPRGROUP_MAC	(5<< MAX_SPRS_PER_GRP_BITS)
+#define SPRGROUP_D	(6<< MAX_SPRS_PER_GRP_BITS)
+#define SPRGROUP_PC	(7<< MAX_SPRS_PER_GRP_BITS)
+#define SPRGROUP_PM	(8<< MAX_SPRS_PER_GRP_BITS)
+#define SPRGROUP_PIC	(9<< MAX_SPRS_PER_GRP_BITS)
+#define SPRGROUP_TT	(10<< MAX_SPRS_PER_GRP_BITS)
+#define SPRGROUP_FP	(11<< MAX_SPRS_PER_GRP_BITS)
+
+/* System control and status group */
+#define SPR_VR		(SPRGROUP_SYS + 0)
+#define SPR_UPR		(SPRGROUP_SYS + 1)
+#define SPR_CPUCFGR	(SPRGROUP_SYS + 2)
+#define SPR_DMMUCFGR	(SPRGROUP_SYS + 3)
+#define SPR_IMMUCFGR	(SPRGROUP_SYS + 4)
+#define SPR_DCCFGR	(SPRGROUP_SYS + 5)
+#define SPR_ICCFGR	(SPRGROUP_SYS + 6)
+#define SPR_DCFGR	(SPRGROUP_SYS + 7)
+#define SPR_PCCFGR	(SPRGROUP_SYS + 8)
+#define SPR_NPC         (SPRGROUP_SYS + 16)  /* CZ 21/06/01 */
+#define SPR_SR		(SPRGROUP_SYS + 17)  /* CZ 21/06/01 */
+#define SPR_PPC         (SPRGROUP_SYS + 18)  /* CZ 21/06/01 */
+#define SPR_FPCSR       (SPRGROUP_SYS + 20)  /* CZ 21/06/01 */
+#define SPR_EPCR_BASE	(SPRGROUP_SYS + 32)  /* CZ 21/06/01 */
+#define SPR_EPCR_LAST	(SPRGROUP_SYS + 47)  /* CZ 21/06/01 */
+#define SPR_EEAR_BASE	(SPRGROUP_SYS + 48)
+#define SPR_EEAR_LAST	(SPRGROUP_SYS + 63)
+#define SPR_ESR_BASE	(SPRGROUP_SYS + 64)
+#define SPR_ESR_LAST	(SPRGROUP_SYS + 79)
+#define SPR_GPR_BASE	(SPRGROUP_SYS + 1024)
+
+/* Data MMU group */
+#define SPR_DMMUCR	(SPRGROUP_DMMU + 0)
+#define SPR_DTLBEIR	(SPRGROUP_DMMU + 2)
+#define SPR_DTLBMR_BASE(WAY)	(SPRGROUP_DMMU + 0x200 + (WAY) * 0x100)
+#define SPR_DTLBMR_LAST(WAY)	(SPRGROUP_DMMU + 0x27f + (WAY) * 0x100)
+#define SPR_DTLBTR_BASE(WAY)	(SPRGROUP_DMMU + 0x280 + (WAY) * 0x100)
+#define SPR_DTLBTR_LAST(WAY)	(SPRGROUP_DMMU + 0x2ff + (WAY) * 0x100)
+
+/* Instruction MMU group */
+#define SPR_IMMUCR	(SPRGROUP_IMMU + 0)
+#define SPR_ITLBEIR	(SPRGROUP_IMMU + 2)
+#define SPR_ITLBMR_BASE(WAY)	(SPRGROUP_IMMU + 0x200 + (WAY) * 0x100)
+#define SPR_ITLBMR_LAST(WAY)	(SPRGROUP_IMMU + 0x27f + (WAY) * 0x100)
+#define SPR_ITLBTR_BASE(WAY)	(SPRGROUP_IMMU + 0x280 + (WAY) * 0x100)
+#define SPR_ITLBTR_LAST(WAY)	(SPRGROUP_IMMU + 0x2ff + (WAY) * 0x100)
+
+/* Data cache group */
+#define SPR_DCCR	(SPRGROUP_DC + 0)
+#define SPR_DCBPR	(SPRGROUP_DC + 1)
+#define SPR_DCBFR	(SPRGROUP_DC + 2)
+#define SPR_DCBIR	(SPRGROUP_DC + 3)
+#define SPR_DCBWR	(SPRGROUP_DC + 4)
+#define SPR_DCBLR	(SPRGROUP_DC + 5)
+#define SPR_DCR_BASE(WAY)	(SPRGROUP_DC + 0x200 + (WAY) * 0x200)
+#define SPR_DCR_LAST(WAY)	(SPRGROUP_DC + 0x3ff + (WAY) * 0x200)
+
+/* Instruction cache group */
+#define SPR_ICCR	(SPRGROUP_IC + 0)
+#define SPR_ICBPR	(SPRGROUP_IC + 1)
+#define SPR_ICBIR	(SPRGROUP_IC + 2)
+#define SPR_ICBLR	(SPRGROUP_IC + 3)
+#define SPR_ICR_BASE(WAY)	(SPRGROUP_IC + 0x200 + (WAY) * 0x200)
+#define SPR_ICR_LAST(WAY)	(SPRGROUP_IC + 0x3ff + (WAY) * 0x200)
+
+/* MAC group */
+#define SPR_MACLO 	(SPRGROUP_MAC + 1)
+#define SPR_MACHI 	(SPRGROUP_MAC + 2)
+
+/* Debug group */
+#define SPR_DVR(N)	(SPRGROUP_D + (N))
+#define SPR_DCR(N)	(SPRGROUP_D + 8 + (N))
+#define SPR_DMR1	(SPRGROUP_D + 16)
+#define SPR_DMR2	(SPRGROUP_D + 17)
+#define SPR_DWCR0	(SPRGROUP_D + 18)
+#define SPR_DWCR1	(SPRGROUP_D + 19)
+#define SPR_DSR		(SPRGROUP_D + 20)
+#define SPR_DRR		(SPRGROUP_D + 21)
+
+/* Performance counters group */
+#define SPR_PCCR(N)	(SPRGROUP_PC + (N))
+#define SPR_PCMR(N)	(SPRGROUP_PC + 8 + (N))
+
+/* Power management group */
+#define SPR_PMR (SPRGROUP_PM + 0)
+
+/* PIC group */
+#define SPR_PICMR (SPRGROUP_PIC + 0)
+#define SPR_PICPR (SPRGROUP_PIC + 1)
+#define SPR_PICSR (SPRGROUP_PIC + 2)
+
+/* Tick Timer group */
+#define SPR_TTMR (SPRGROUP_TT + 0)
+#define SPR_TTCR (SPRGROUP_TT + 1)
+
+/*
+ * Bit definitions for the Version Register
+ *
+ */
+#define SPR_VR_VER	0xff000000  /* Processor version */
+#define SPR_VR_CFG	0x00ff0000  /* Processor configuration */
+#define SPR_VR_RES	0x0000ffc0  /* Reserved */
+#define SPR_VR_REV	0x0000003f  /* Processor revision */
+
+#define SPR_VR_VER_OFF	24
+#define SPR_VR_CFG_OFF	16
+#define SPR_VR_REV_OFF	0
+
+/*
+ * Bit definitions for the Unit Present Register
+ *
+ */
+#define SPR_UPR_UP	   0x00000001  /* UPR present */
+#define SPR_UPR_DCP	   0x00000002  /* Data cache present */
+#define SPR_UPR_ICP	   0x00000004  /* Instruction cache present */
+#define SPR_UPR_DMP	   0x00000008  /* Data MMU present */
+#define SPR_UPR_IMP	   0x00000010  /* Instruction MMU present */
+#define SPR_UPR_MP	   0x00000020  /* MAC present */
+#define SPR_UPR_DUP	   0x00000040  /* Debug unit present */
+#define SPR_UPR_PCUP	   0x00000080  /* Performance counters unit present */
+#define SPR_UPR_PMP	   0x00000100  /* Power management present */
+#define SPR_UPR_PICP	   0x00000200  /* PIC present */
+#define SPR_UPR_TTP	   0x00000400  /* Tick timer present */
+#define SPR_UPR_RES	   0x00fe0000  /* Reserved */
+#define SPR_UPR_CUP	   0xff000000  /* Context units present */
+
+/*
+ * JPB: Bit definitions for the CPU configuration register
+ *
+ */
+#define SPR_CPUCFGR_NSGF   0x0000000f  /* Number of shadow GPR files */
+#define SPR_CPUCFGR_CGF	   0x00000010  /* Custom GPR file */
+#define SPR_CPUCFGR_OB32S  0x00000020  /* ORBIS32 supported */
+#define SPR_CPUCFGR_OB64S  0x00000040  /* ORBIS64 supported */
+#define SPR_CPUCFGR_OF32S  0x00000080  /* ORFPX32 supported */
+#define SPR_CPUCFGR_OF64S  0x00000100  /* ORFPX64 supported */
+#define SPR_CPUCFGR_OV64S  0x00000200  /* ORVDX64 supported */
+#define SPR_CPUCFGR_RES	   0xfffffc00  /* Reserved */
+
+/*
+ * JPB: Bit definitions for the Debug configuration register and other
+ * constants.
+ *
+ */
+
+#define SPR_DCFGR_NDP      0x00000007  /* Number of matchpoints mask */
+#define SPR_DCFGR_NDP1     0x00000000  /* One matchpoint supported */
+#define SPR_DCFGR_NDP2     0x00000001  /* Two matchpoints supported */
+#define SPR_DCFGR_NDP3     0x00000002  /* Three matchpoints supported */
+#define SPR_DCFGR_NDP4     0x00000003  /* Four matchpoints supported */
+#define SPR_DCFGR_NDP5     0x00000004  /* Five matchpoints supported */
+#define SPR_DCFGR_NDP6     0x00000005  /* Six matchpoints supported */
+#define SPR_DCFGR_NDP7     0x00000006  /* Seven matchpoints supported */
+#define SPR_DCFGR_NDP8     0x00000007  /* Eight matchpoints supported */
+#define SPR_DCFGR_WPCI     0x00000008  /* Watchpoint counters implemented */
+
+#define MATCHPOINTS_TO_NDP(n) (1 == n ? SPR_DCFGR_NDP1 : \
+                               2 == n ? SPR_DCFGR_NDP2 : \
+                               3 == n ? SPR_DCFGR_NDP3 : \
+                               4 == n ? SPR_DCFGR_NDP4 : \
+                               5 == n ? SPR_DCFGR_NDP5 : \
+                               6 == n ? SPR_DCFGR_NDP6 : \
+                               7 == n ? SPR_DCFGR_NDP7 : SPR_DCFGR_NDP8)
+#define MAX_MATCHPOINTS  8
+#define MAX_WATCHPOINTS  (MAX_MATCHPOINTS + 2)
+
+/*
+ * Bit definitions for the Supervision Register
+ *
+ */
+#define SPR_SR_SM          0x00000001  /* Supervisor Mode */
+#define SPR_SR_TEE         0x00000002  /* Tick timer Exception Enable */
+#define SPR_SR_IEE         0x00000004  /* Interrupt Exception Enable */
+#define SPR_SR_DCE         0x00000008  /* Data Cache Enable */
+#define SPR_SR_ICE         0x00000010  /* Instruction Cache Enable */
+#define SPR_SR_DME         0x00000020  /* Data MMU Enable */
+#define SPR_SR_IME         0x00000040  /* Instruction MMU Enable */
+#define SPR_SR_LEE         0x00000080  /* Little Endian Enable */
+#define SPR_SR_CE          0x00000100  /* CID Enable */
+#define SPR_SR_F           0x00000200  /* Condition Flag */
+#define SPR_SR_CY          0x00000400  /* Carry flag */
+#define SPR_SR_OV          0x00000800  /* Overflow flag */
+#define SPR_SR_OVE         0x00001000  /* Overflow flag Exception */
+#define SPR_SR_DSX         0x00002000  /* Delay Slot Exception */
+#define SPR_SR_EPH         0x00004000  /* Exception Prefix High */
+#define SPR_SR_FO          0x00008000  /* Fixed one */
+#define SPR_SR_SUMRA       0x00010000  /* Supervisor SPR read access */
+#define SPR_SR_RES         0x0ffe0000  /* Reserved */
+#define SPR_SR_CID         0xf0000000  /* Context ID */
+
+/*
+ * Bit definitions for the Data MMU Control Register
+ *
+ */
+#define SPR_DMMUCR_P2S	   0x0000003e  /* Level 2 Page Size */
+#define SPR_DMMUCR_P1S	   0x000007c0  /* Level 1 Page Size */
+#define SPR_DMMUCR_VADDR_WIDTH	0x0000f800  /* Virtual ADDR Width */
+#define SPR_DMMUCR_PADDR_WIDTH	0x000f0000  /* Physical ADDR Width */
+
+/*
+ * Bit definitions for the Instruction MMU Control Register
+ *
+ */
+#define SPR_IMMUCR_P2S	   0x0000003e  /* Level 2 Page Size */
+#define SPR_IMMUCR_P1S	   0x000007c0  /* Level 1 Page Size */
+#define SPR_IMMUCR_VADDR_WIDTH	0x0000f800  /* Virtual ADDR Width */
+#define SPR_IMMUCR_PADDR_WIDTH	0x000f0000  /* Physical ADDR Width */
+
+/*
+ * Bit definitions for the Data TLB Match Register
+ *
+ */
+#define SPR_DTLBMR_V	   0x00000001  /* Valid */
+#define SPR_DTLBMR_PL1	   0x00000002  /* Page Level 1 (if 0 then PL2) */
+#define SPR_DTLBMR_CID	   0x0000003c  /* Context ID */
+#define SPR_DTLBMR_LRU	   0x000000c0  /* Least Recently Used */
+#define SPR_DTLBMR_VPN	   0xfffff000  /* Virtual Page Number */
+
+/*
+ * Bit definitions for the Data TLB Translate Register
+ *
+ */
+#define SPR_DTLBTR_CC	   0x00000001  /* Cache Coherency */
+#define SPR_DTLBTR_CI	   0x00000002  /* Cache Inhibit */
+#define SPR_DTLBTR_WBC	   0x00000004  /* Write-Back Cache */
+#define SPR_DTLBTR_WOM	   0x00000008  /* Weakly-Ordered Memory */
+#define SPR_DTLBTR_A	   0x00000010  /* Accessed */
+#define SPR_DTLBTR_D	   0x00000020  /* Dirty */
+#define SPR_DTLBTR_URE	   0x00000040  /* User Read Enable */
+#define SPR_DTLBTR_UWE	   0x00000080  /* User Write Enable */
+#define SPR_DTLBTR_SRE	   0x00000100  /* Supervisor Read Enable */
+#define SPR_DTLBTR_SWE	   0x00000200  /* Supervisor Write Enable */
+#define SPR_DTLBTR_PPN	   0xfffff000  /* Physical Page Number */
+
+/*
+ * Bit definitions for the Instruction TLB Match Register
+ *
+ */
+#define SPR_ITLBMR_V	   0x00000001  /* Valid */
+#define SPR_ITLBMR_PL1	   0x00000002  /* Page Level 1 (if 0 then PL2) */
+#define SPR_ITLBMR_CID	   0x0000003c  /* Context ID */
+#define SPR_ITLBMR_LRU	   0x000000c0  /* Least Recently Used */
+#define SPR_ITLBMR_VPN	   0xfffff000  /* Virtual Page Number */
+
+/*
+ * Bit definitions for the Instruction TLB Translate Register
+ *
+ */
+#define SPR_ITLBTR_CC	   0x00000001  /* Cache Coherency */
+#define SPR_ITLBTR_CI	   0x00000002  /* Cache Inhibit */
+#define SPR_ITLBTR_WBC	   0x00000004  /* Write-Back Cache */
+#define SPR_ITLBTR_WOM	   0x00000008  /* Weakly-Ordered Memory */
+#define SPR_ITLBTR_A	   0x00000010  /* Accessed */
+#define SPR_ITLBTR_D	   0x00000020  /* Dirty */
+#define SPR_ITLBTR_SXE	   0x00000040  /* User Read Enable */
+#define SPR_ITLBTR_UXE	   0x00000080  /* User Write Enable */
+#define SPR_ITLBTR_PPN	   0xfffff000  /* Physical Page Number */
+
+/*
+ * Bit definitions for Data Cache Control register
+ *
+ */
+#define SPR_DCCR_EW	   0x000000ff  /* Enable ways */
+
+/*
+ * Bit definitions for Insn Cache Control register
+ *
+ */
+#define SPR_ICCR_EW	   0x000000ff  /* Enable ways */
+
+/*
+ * Bit definitions for Data Cache Configuration Register
+ *
+ */
+
+#define SPR_DCCFGR_NCW		0x00000007
+#define SPR_DCCFGR_NCS		0x00000078
+#define SPR_DCCFGR_CBS		0x00000080
+#define SPR_DCCFGR_CWS		0x00000100
+#define SPR_DCCFGR_CCRI		0x00000200
+#define SPR_DCCFGR_CBIRI	0x00000400
+#define SPR_DCCFGR_CBPRI	0x00000800
+#define SPR_DCCFGR_CBLRI	0x00001000
+#define SPR_DCCFGR_CBFRI	0x00002000
+#define SPR_DCCFGR_CBWBRI	0x00004000
+
+#define SPR_DCCFGR_NCW_OFF      0
+#define SPR_DCCFGR_NCS_OFF      3
+#define SPR_DCCFGR_CBS_OFF	7
+
+/*
+ * Bit definitions for Instruction Cache Configuration Register
+ *
+ */
+#define SPR_ICCFGR_NCW		0x00000007
+#define SPR_ICCFGR_NCS		0x00000078
+#define SPR_ICCFGR_CBS		0x00000080
+#define SPR_ICCFGR_CCRI		0x00000200
+#define SPR_ICCFGR_CBIRI	0x00000400
+#define SPR_ICCFGR_CBPRI	0x00000800
+#define SPR_ICCFGR_CBLRI	0x00001000
+
+#define SPR_ICCFGR_NCW_OFF      0
+#define SPR_ICCFGR_NCS_OFF      3
+#define SPR_ICCFGR_CBS_OFF	7
+
+/*
+ * Bit definitions for Data MMU Configuration Register
+ *
+ */
+
+#define SPR_DMMUCFGR_NTW	0x00000003
+#define SPR_DMMUCFGR_NTS	0x0000001C
+#define SPR_DMMUCFGR_NAE	0x000000E0
+#define SPR_DMMUCFGR_CRI	0x00000100
+#define SPR_DMMUCFGR_PRI        0x00000200
+#define SPR_DMMUCFGR_TEIRI	0x00000400
+#define SPR_DMMUCFGR_HTR	0x00000800
+
+#define SPR_DMMUCFGR_NTW_OFF	0
+#define SPR_DMMUCFGR_NTS_OFF	2
+
+/*
+ * Bit definitions for Instruction MMU Configuration Register
+ *
+ */
+
+#define SPR_IMMUCFGR_NTW	0x00000003
+#define SPR_IMMUCFGR_NTS	0x0000001C
+#define SPR_IMMUCFGR_NAE	0x000000E0
+#define SPR_IMMUCFGR_CRI	0x00000100
+#define SPR_IMMUCFGR_PRI	0x00000200
+#define SPR_IMMUCFGR_TEIRI	0x00000400
+#define SPR_IMMUCFGR_HTR	0x00000800
+
+#define SPR_IMMUCFGR_NTW_OFF	0
+#define SPR_IMMUCFGR_NTS_OFF	2
+
+/*
+ * Bit definitions for Debug Control registers
+ *
+ */
+#define SPR_DCR_DP	0x00000001  /* DVR/DCR present */
+#define SPR_DCR_CC	0x0000000e  /* Compare condition */
+#define SPR_DCR_SC	0x00000010  /* Signed compare */
+#define SPR_DCR_CT	0x000000e0  /* Compare to */
+
+/* Bit results with SPR_DCR_CC mask */
+#define SPR_DCR_CC_MASKED 0x00000000
+#define SPR_DCR_CC_EQUAL  0x00000002
+#define SPR_DCR_CC_LESS   0x00000004
+#define SPR_DCR_CC_LESSE  0x00000006
+#define SPR_DCR_CC_GREAT  0x00000008
+#define SPR_DCR_CC_GREATE 0x0000000a
+#define SPR_DCR_CC_NEQUAL 0x0000000c
+
+/* Bit results with SPR_DCR_CT mask */
+#define SPR_DCR_CT_DISABLED 0x00000000
+#define SPR_DCR_CT_IFEA     0x00000020
+#define SPR_DCR_CT_LEA      0x00000040
+#define SPR_DCR_CT_SEA      0x00000060
+#define SPR_DCR_CT_LD       0x00000080
+#define SPR_DCR_CT_SD       0x000000a0
+#define SPR_DCR_CT_LSEA     0x000000c0
+#define SPR_DCR_CT_LSD	    0x000000e0
+/* SPR_DCR_CT_LSD doesn't seem to be implemented anywhere in or1ksim. 2004-1-30 HP */
+
+/*
+ * Bit definitions for Debug Mode 1 register
+ *
+ */
+#define SPR_DMR1_CW       0x000fffff  /* Chain register pair data */
+#define SPR_DMR1_CW0_AND  0x00000001
+#define SPR_DMR1_CW0_OR   0x00000002
+#define SPR_DMR1_CW0  	  (SPR_DMR1_CW0_AND | SPR_DMR1_CW0_OR)
+#define SPR_DMR1_CW1_AND  0x00000004
+#define SPR_DMR1_CW1_OR   0x00000008
+#define SPR_DMR1_CW1  	  (SPR_DMR1_CW1_AND | SPR_DMR1_CW1_OR)
+#define SPR_DMR1_CW2_AND  0x00000010
+#define SPR_DMR1_CW2_OR   0x00000020
+#define SPR_DMR1_CW2  	  (SPR_DMR1_CW2_AND | SPR_DMR1_CW2_OR)
+#define SPR_DMR1_CW3_AND  0x00000040
+#define SPR_DMR1_CW3_OR   0x00000080
+#define SPR_DMR1_CW3  	  (SPR_DMR1_CW3_AND | SPR_DMR1_CW3_OR)
+#define SPR_DMR1_CW4_AND  0x00000100
+#define SPR_DMR1_CW4_OR   0x00000200
+#define SPR_DMR1_CW4  	  (SPR_DMR1_CW4_AND | SPR_DMR1_CW4_OR)
+#define SPR_DMR1_CW5_AND  0x00000400
+#define SPR_DMR1_CW5_OR   0x00000800
+#define SPR_DMR1_CW5  	  (SPR_DMR1_CW5_AND | SPR_DMR1_CW5_OR)
+#define SPR_DMR1_CW6_AND  0x00001000
+#define SPR_DMR1_CW6_OR   0x00002000
+#define SPR_DMR1_CW6  	  (SPR_DMR1_CW6_AND | SPR_DMR1_CW6_OR)
+#define SPR_DMR1_CW7_AND  0x00004000
+#define SPR_DMR1_CW7_OR   0x00008000
+#define SPR_DMR1_CW7  	  (SPR_DMR1_CW7_AND | SPR_DMR1_CW7_OR)
+#define SPR_DMR1_CW8_AND  0x00010000
+#define SPR_DMR1_CW8_OR   0x00020000
+#define SPR_DMR1_CW8  	  (SPR_DMR1_CW8_AND | SPR_DMR1_CW8_OR)
+#define SPR_DMR1_CW9_AND  0x00040000
+#define SPR_DMR1_CW9_OR   0x00080000
+#define SPR_DMR1_CW9  	  (SPR_DMR1_CW9_AND | SPR_DMR1_CW9_OR)
+#define SPR_DMR1_RES1      0x00300000  /* Reserved */
+#define SPR_DMR1_ST	  0x00400000  /* Single-step trace*/
+#define SPR_DMR1_BT	  0x00800000  /* Branch trace */
+#define SPR_DMR1_RES2	  0xff000000  /* Reserved */
+
+/*
+ * Bit definitions for Debug Mode 2 register. AWTC and WGB corrected by JPB
+ *
+ */
+#define SPR_DMR2_WCE0	   0x00000001  /* Watchpoint counter 0 enable */
+#define SPR_DMR2_WCE1	   0x00000002  /* Watchpoint counter 0 enable */
+#define SPR_DMR2_AWTC	   0x00000ffc  /* Assign watchpoints to counters */
+#define SPR_DMR2_AWTC_OFF           2  /* Bit offset to AWTC field */
+#define SPR_DMR2_WGB	   0x003ff000  /* Watchpoints generating breakpoint */
+#define SPR_DMR2_WGB_OFF           12  /* Bit offset to WGB field */
+#define SPR_DMR2_WBS	   0xffc00000  /* JPB: Watchpoint status */
+#define SPR_DMR2_WBS_OFF           22  /* Bit offset to WBS field */
+
+/*
+ * Bit definitions for Debug watchpoint counter registers
+ *
+ */
+#define SPR_DWCR_COUNT	    0x0000ffff  /* Count */
+#define SPR_DWCR_MATCH	    0xffff0000  /* Match */
+#define SPR_DWCR_MATCH_OFF          16  /* Match bit offset */
+
+/*
+ * Bit definitions for Debug stop register
+ *
+ */
+#define SPR_DSR_RSTE	0x00000001  /* Reset exception */
+#define SPR_DSR_BUSEE	0x00000002  /* Bus error exception */
+#define SPR_DSR_DPFE	0x00000004  /* Data Page Fault exception */
+#define SPR_DSR_IPFE	0x00000008  /* Insn Page Fault exception */
+#define SPR_DSR_TTE	0x00000010  /* Tick Timer exception */
+#define SPR_DSR_AE	0x00000020  /* Alignment exception */
+#define SPR_DSR_IIE	0x00000040  /* Illegal Instruction exception */
+#define SPR_DSR_IE	0x00000080  /* Interrupt exception */
+#define SPR_DSR_DME	0x00000100  /* DTLB miss exception */
+#define SPR_DSR_IME	0x00000200  /* ITLB miss exception */
+#define SPR_DSR_RE	0x00000400  /* Range exception */
+#define SPR_DSR_SCE	0x00000800  /* System call exception */
+#define SPR_DSR_FPE     0x00001000  /* Floating Point Exception */
+#define SPR_DSR_TE	0x00002000  /* Trap exception */
+
+/*
+ * Bit definitions for Debug reason register
+ *
+ */
+#define SPR_DRR_RSTE	0x00000001  /* Reset exception */
+#define SPR_DRR_BUSEE	0x00000002  /* Bus error exception */
+#define SPR_DRR_DPFE	0x00000004  /* Data Page Fault exception */
+#define SPR_DRR_IPFE	0x00000008  /* Insn Page Fault exception */
+#define SPR_DRR_TTE	0x00000010  /* Tick Timer exception */
+#define SPR_DRR_AE	0x00000020  /* Alignment exception */
+#define SPR_DRR_IIE	0x00000040  /* Illegal Instruction exception */
+#define SPR_DRR_IE	0x00000080  /* Interrupt exception */
+#define SPR_DRR_DME	0x00000100  /* DTLB miss exception */
+#define SPR_DRR_IME	0x00000200  /* ITLB miss exception */
+#define SPR_DRR_RE	0x00000400  /* Range exception */
+#define SPR_DRR_SCE	0x00000800  /* System call exception */
+#define SPR_DRR_FPE     0x00001000  /* Floating Point Exception */
+#define SPR_DRR_TE	0x00002000  /* Trap exception */
+
+/*
+ * Bit definitions for Performance counters mode registers
+ *
+ */
+#define SPR_PCMR_CP	0x00000001  /* Counter present */
+#define SPR_PCMR_UMRA	0x00000002  /* User mode read access */
+#define SPR_PCMR_CISM	0x00000004  /* Count in supervisor mode */
+#define SPR_PCMR_CIUM	0x00000008  /* Count in user mode */
+#define SPR_PCMR_LA	0x00000010  /* Load access event */
+#define SPR_PCMR_SA	0x00000020  /* Store access event */
+#define SPR_PCMR_IF	0x00000040  /* Instruction fetch event*/
+#define SPR_PCMR_DCM	0x00000080  /* Data cache miss event */
+#define SPR_PCMR_ICM	0x00000100  /* Insn cache miss event */
+#define SPR_PCMR_IFS	0x00000200  /* Insn fetch stall event */
+#define SPR_PCMR_LSUS	0x00000400  /* LSU stall event */
+#define SPR_PCMR_BS	0x00000800  /* Branch stall event */
+#define SPR_PCMR_DTLBM	0x00001000  /* DTLB miss event */
+#define SPR_PCMR_ITLBM	0x00002000  /* ITLB miss event */
+#define SPR_PCMR_DDS	0x00004000  /* Data dependency stall event */
+#define SPR_PCMR_WPE	0x03ff8000  /* Watchpoint events */
+
+/*
+ * Bit definitions for the Power management register
+ *
+ */
+#define SPR_PMR_SDF	0x0000000f  /* Slow down factor */
+#define SPR_PMR_DME	0x00000010  /* Doze mode enable */
+#define SPR_PMR_SME	0x00000020  /* Sleep mode enable */
+#define SPR_PMR_DCGE	0x00000040  /* Dynamic clock gating enable */
+#define SPR_PMR_SUME	0x00000080  /* Suspend mode enable */
+
+/*
+ * Bit definitions for PICMR
+ *
+ */
+#define SPR_PICMR_IUM	0xfffffffc  /* Interrupt unmask */
+
+/*
+ * Bit definitions for PICPR
+ *
+ */
+#define SPR_PICPR_IPRIO	0xfffffffc  /* Interrupt priority */
+
+/*
+ * Bit definitions for PICSR
+ *
+ */
+#define SPR_PICSR_IS	0xffffffff  /* Interrupt status */
+
+/*
+ * Bit definitions for Tick Timer Control Register
+ *
+ */
+
+#define SPR_TTCR_CNT	0xffffffff  /* Count, time period */
+#define SPR_TTMR_TP	0x0fffffff  /* Time period */
+#define SPR_TTMR_IP	0x10000000  /* Interrupt Pending */
+#define SPR_TTMR_IE	0x20000000  /* Interrupt Enable */
+#define SPR_TTMR_DI	0x00000000  /* Disabled */
+#define SPR_TTMR_RT	0x40000000  /* Restart tick */
+#define SPR_TTMR_SR     0x80000000  /* Single run */
+#define SPR_TTMR_CR     0xc0000000  /* Continuous run */
+#define SPR_TTMR_M      0xc0000000  /* Tick mode */
+
+/*
+ * Bit definitions for the FP Control Status Register
+ *
+ */
+#define SPR_FPCSR_FPEE  0x00000001  /* Floating Point Exception Enable */
+#define SPR_FPCSR_RM    0x00000006  /* Rounding Mode */
+#define SPR_FPCSR_OVF   0x00000008  /* Overflow Flag */
+#define SPR_FPCSR_UNF   0x00000010  /* Underflow Flag */
+#define SPR_FPCSR_SNF   0x00000020  /* SNAN Flag */
+#define SPR_FPCSR_QNF   0x00000040  /* QNAN Flag */
+#define SPR_FPCSR_ZF    0x00000080  /* Zero Flag */
+#define SPR_FPCSR_IXF   0x00000100  /* Inexact Flag */
+#define SPR_FPCSR_IVF   0x00000200  /* Invalid Flag */
+#define SPR_FPCSR_INF   0x00000400  /* Infinity Flag */
+#define SPR_FPCSR_DZF   0x00000800  /* Divide By Zero Flag */
+#define SPR_FPCSR_ALLF (SPR_FPCSR_OVF | SPR_FPCSR_UNF | SPR_FPCSR_SNF | \
+			SPR_FPCSR_QNF | SPR_FPCSR_ZF | SPR_FPCSR_IXF |  \
+			SPR_FPCSR_IVF | SPR_FPCSR_INF | SPR_FPCSR_DZF)
+
+#define FPCSR_RM_RN (0<<1)
+#define FPCSR_RM_RZ (1<<1)
+#define FPCSR_RM_RIP (2<<1)
+#define FPCSR_RM_RIN (3<<1)
+
+/*
+ * l.nop constants
+ *
+ */
+#define NOP_NOP          0x0000      /* Normal nop instruction */
+#define NOP_EXIT         0x0001      /* End of simulation */
+#define NOP_REPORT       0x0002      /* Simple report */
+/*#define NOP_PRINTF       0x0003       Simprintf instruction (obsolete)*/
+#define NOP_PUTC         0x0004      /* JPB: Simputc instruction */
+#define NOP_CNT_RESET    0x0005	     /* Reset statistics counters */
+#define NOP_GET_TICKS    0x0006	     /* JPB: Get # ticks running */
+#define NOP_GET_PS       0x0007      /* JPB: Get picosecs/cycle */
+#define NOP_REPORT_FIRST 0x0400      /* Report with number */
+#define NOP_REPORT_LAST  0x03ff      /* Report with number */
+
+#endif	/* SPR_DEFS__H */
diff --git a/arch/openrisc/include/asm/string.h b/arch/openrisc/include/asm/string.h
new file mode 100644
index 0000000..6b41da1
--- /dev/null
+++ b/arch/openrisc/include/asm/string.h
@@ -0,0 +1,34 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_STRING_H
+#define __ASM_OPENRISC_STRING_H
+
+/* TODO: Implement optimized version of memcpy and memset */
+
+#if 0
+
+#define __HAVE_ARCH_MEMCPY
+extern void *memcpy(void *, const void *, size_t);
+
+#define __HAVE_ARCH_MEMSET
+extern void *memset(void *, int, size_t);
+
+#endif
+
+#endif
diff --git a/arch/openrisc/include/asm/system.h b/arch/openrisc/include/asm/system.h
new file mode 100644
index 0000000..567bd5a
--- /dev/null
+++ b/arch/openrisc/include/asm/system.h
@@ -0,0 +1,56 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_SYSTEM_H
+#define __ASM_OPENRISC_SYSTEM_H
+
+#include <asm-generic/system.h>
+
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+
+#define mtspr(_spr, _val) __asm__ __volatile__ ( 		\
+	"l.mtspr r0,%1,%0"					\
+	:: "K" (_spr), "r" (_val))
+#define mtspr_off(_spr, _off, _val) __asm__ __volatile__ ( 	\
+	"l.mtspr %0,%1,%2"					\
+	:: "r" (_off), "r" (_val), "K" (_spr))
+
+static inline unsigned long mfspr(unsigned long add)
+{
+	unsigned long ret;
+	__asm__ __volatile__ ("l.mfspr %0,r0,%1" : "=r" (ret) : "K" (add));
+	return ret;
+}
+
+static inline unsigned long mfspr_off(unsigned long add, unsigned long offset)
+{
+	unsigned long ret;
+	__asm__ __volatile__ ("l.mfspr %0,%1,%2" : "=r" (ret)
+						 : "r" (offset), "K" (add));
+	return ret;
+}
+
+/* We probably need this definition, but the generic system.h provides it
+ * and it's not used on our arch anyway...
+ */
+/*#define nop() __asm__ __volatile__ ("l.nop"::)*/
+
+#endif /* __ASSEMBLY__ */
+#endif /* __KERNEL__ */
+#endif /* __ASM_OPENRISC_SYSTEM_H */
diff --git a/arch/openrisc/include/asm/unaligned.h b/arch/openrisc/include/asm/unaligned.h
new file mode 100644
index 0000000..1141cbd
--- /dev/null
+++ b/arch/openrisc/include/asm/unaligned.h
@@ -0,0 +1,51 @@
+/*
+ * OpenRISC Linux
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * OpenRISC implementation:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ * et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __ASM_OPENRISC_UNALIGNED_H
+#define __ASM_OPENRISC_UNALIGNED_H
+
+/*
+ * This is copied from the generic implementation and the C-struct
+ * variant replaced with the memmove variant.  The GCC compiler
+ * for the OR32 arch optimizes too aggressively for the C-struct
+ * variant to work, so use the memmove variant instead.
+ *
+ * It may be worth considering implementing the unaligned access
+ * exception handler and allowing unaligned accesses (access_ok.h)...
+ * not sure if it would be much of a performance win without further
+ * investigation.
+ */
+#include <asm/byteorder.h>
+
+#if defined(__LITTLE_ENDIAN)
+# include <linux/unaligned/le_memmove.h>
+# include <linux/unaligned/be_byteshift.h>
+# include <linux/unaligned/generic.h>
+# define get_unaligned	__get_unaligned_le
+# define put_unaligned	__put_unaligned_le
+#elif defined(__BIG_ENDIAN)
+# include <linux/unaligned/be_memmove.h>
+# include <linux/unaligned/le_byteshift.h>
+# include <linux/unaligned/generic.h>
+# define get_unaligned	__get_unaligned_be
+# define put_unaligned	__put_unaligned_be
+#else
+# error need to define endianess
+#endif
+
+#endif /* __ASM_OPENRISC_UNALIGNED_H */
-- 
1.7.4.1


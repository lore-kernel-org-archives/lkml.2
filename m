Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab1H3TOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:14:40 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42265 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab1H3TOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:14:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6454"; a="113874894"
Message-Id: <20110830190759.910117438@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Aug 2011 14:07:31 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Cc: Linas Vepstas <linas@codeaurora.org>
Subject: [patch v2 02/35] Hexagon: Core arch-specific header files
References: <20110830190729.923334292@codeaurora.org>
Content-Disposition: inline; filename=basic-asm-headers.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Linas Vepstas <linas@codeaurora.org>

---
 arch/hexagon/include/asm/byteorder.h  |   28 ++++
 arch/hexagon/include/asm/elf.h        |  222 ++++++++++++++++++++++++++++++++++
 arch/hexagon/include/asm/fpu.h        |    4 
 arch/hexagon/include/asm/futex.h      |  137 ++++++++++++++++++++
 arch/hexagon/include/asm/linkage.h    |   25 +++
 arch/hexagon/include/asm/module.h     |   26 +++
 arch/hexagon/include/asm/param.h      |   26 +++
 arch/hexagon/include/asm/perf_event.h |   24 +++
 arch/hexagon/include/asm/string.h     |   32 ++++
 arch/hexagon/include/asm/suspend.h    |   27 ++++
 arch/hexagon/include/asm/swab.h       |   24 +++
 arch/hexagon/include/asm/timex.h      |   37 +++++
 12 files changed, 612 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/byteorder.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/byteorder.h	2011-08-24 18:45:48.063877043 -0500
@@ -0,0 +1,28 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_BYTEORDER_H
+#define _ASM_BYTEORDER_H
+
+#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#  define __BYTEORDER_HAS_U64__
+#endif
+
+#include <linux/byteorder/little_endian.h>
+
+#endif /* _ASM_BYTEORDER_H */
Index: linux-hexagon-kernel/arch/hexagon/include/asm/elf.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/elf.h	2011-08-24 18:45:48.063877043 -0500
@@ -0,0 +1,222 @@
+/*
+ * ELF definitions for the Hexagon architecture
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef __ASM_ELF_H
+#define __ASM_ELF_H
+
+#include <asm/ptrace.h>
+#include <asm/user.h>
+
+/*
+ * This should really be in linux/elf-em.h.
+ */
+#define EM_HEXAGON	164   /* QUALCOMM Hexagon */
+
+struct elf32_hdr;
+
+/*
+ * ELF header e_flags defines.
+ */
+
+/*  should have stuff like "CPU type" and maybe "ABI version", etc  */
+
+/* Hexagon relocations */
+  /* V2 */
+#define R_HEXAGON_NONE           0
+#define R_HEXAGON_B22_PCREL      1
+#define R_HEXAGON_B15_PCREL      2
+#define R_HEXAGON_B7_PCREL       3
+#define R_HEXAGON_LO16           4
+#define R_HEXAGON_HI16           5
+#define R_HEXAGON_32             6
+#define R_HEXAGON_16             7
+#define R_HEXAGON_8              8
+#define R_HEXAGON_GPREL16_0      9
+#define R_HEXAGON_GPREL16_1     10
+#define R_HEXAGON_GPREL16_2     11
+#define R_HEXAGON_GPREL16_3     12
+#define R_HEXAGON_HL16          13
+  /* V3 */
+#define R_HEXAGON_B13_PCREL     14
+  /* V4 */
+#define R_HEXAGON_B9_PCREL      15
+  /* V4 (extenders) */
+#define R_HEXAGON_B32_PCREL_X   16
+#define R_HEXAGON_32_6_X        17
+  /* V4 (extended) */
+#define R_HEXAGON_B22_PCREL_X   18
+#define R_HEXAGON_B15_PCREL_X   19
+#define R_HEXAGON_B13_PCREL_X   20
+#define R_HEXAGON_B9_PCREL_X    21
+#define R_HEXAGON_B7_PCREL_X    22
+#define R_HEXAGON_16_X          23
+#define R_HEXAGON_12_X          24
+#define R_HEXAGON_11_X          25
+#define R_HEXAGON_10_X          26
+#define R_HEXAGON_9_X           27
+#define R_HEXAGON_8_X           28
+#define R_HEXAGON_7_X           29
+#define R_HEXAGON_6_X           30
+  /* V2 PIC */
+#define R_HEXAGON_32_PCREL      31
+#define R_HEXAGON_COPY          32
+#define R_HEXAGON_GLOB_DAT      33
+#define R_HEXAGON_JMP_SLOT      34
+#define R_HEXAGON_RELATIVE      35
+#define R_HEXAGON_PLT_B22_PCREL 36
+#define R_HEXAGON_GOTOFF_LO16   37
+#define R_HEXAGON_GOTOFF_HI16   38
+#define R_HEXAGON_GOTOFF_32     39
+#define R_HEXAGON_GOT_LO16      40
+#define R_HEXAGON_GOT_HI16      41
+#define R_HEXAGON_GOT_32        42
+#define R_HEXAGON_GOT_16        43
+
+/*
+ * ELF register definitions..
+ */
+typedef unsigned long elf_greg_t;
+
+/*  May need an ELF_NGREG later down the line  */
+typedef struct user_regs_struct elf_gregset_t;
+
+/*  Placeholder  */
+typedef unsigned long elf_fpregset_t;
+
+/*
+ * Bypass the whole "regsets" thing for now and use the define.
+ */
+
+#define ELF_CORE_COPY_REGS(DEST, REGS)	\
+do {					\
+	DEST.r0 = REGS->r00;		\
+	DEST.r1 = REGS->r01;		\
+	DEST.r2 = REGS->r02;		\
+	DEST.r3 = REGS->r03;		\
+	DEST.r4 = REGS->r04;		\
+	DEST.r5 = REGS->r05;		\
+	DEST.r6 = REGS->r06;		\
+	DEST.r7 = REGS->r07;		\
+	DEST.r8 = REGS->r08;		\
+	DEST.r9 = REGS->r09;		\
+	DEST.r10 = REGS->r10;		\
+	DEST.r11 = REGS->r11;		\
+	DEST.r12 = REGS->r12;		\
+	DEST.r13 = REGS->r13;		\
+	DEST.r14 = REGS->r14;		\
+	DEST.r15 = REGS->r15;		\
+	DEST.r16 = REGS->r16;		\
+	DEST.r17 = REGS->r17;		\
+	DEST.r18 = REGS->r18;		\
+	DEST.r19 = REGS->r19;		\
+	DEST.r20 = REGS->r20;		\
+	DEST.r21 = REGS->r21;		\
+	DEST.r22 = REGS->r22;		\
+	DEST.r23 = REGS->r23;		\
+	DEST.r24 = REGS->r24;		\
+	DEST.r25 = REGS->r25;		\
+	DEST.r26 = REGS->r26;		\
+	DEST.r27 = REGS->r27;		\
+	DEST.r28 = REGS->r28;		\
+	DEST.r29 = pt_psp(REGS);	\
+	DEST.r30 = REGS->r30;		\
+	DEST.r31 = REGS->r31;		\
+	DEST.gp = REGS->gp;		\
+	DEST.ugp = REGS->ugp;		\
+	DEST.sa0 = REGS->sa0;		\
+	DEST.lc0 = REGS->lc0;		\
+	DEST.sa1 = REGS->sa1;		\
+	DEST.lc1 = REGS->lc1;		\
+	DEST.m0 = REGS->m0;		\
+	DEST.m1 = REGS->m1;		\
+	DEST.p3_0 = REGS->preds;	\
+	DEST.pc = pt_elr(REGS);	\
+	DEST.cause = pt_cause(REGS);	\
+	DEST.badva = pt_badva(REGS);	\
+} while (0);
+
+
+
+/*
+ * This is used to ensure we don't load something for the wrong architecture.
+ * Checks the machine and ABI type.
+ */
+#define elf_check_arch(hdr)	((hdr)->e_machine == EM_HEXAGON)
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#define ELF_CLASS	ELFCLASS32
+#define ELF_DATA	ELFDATA2LSB
+#define ELF_ARCH	EM_HEXAGON
+
+#ifdef CONFIG_HEXAGON_ARCH_V2
+#define ELF_CORE_EFLAGS 0x1
+#endif
+
+#ifdef CONFIG_HEXAGON_ARCH_V3
+#define ELF_CORE_EFLAGS 0x2
+#endif
+
+#ifdef CONFIG_HEXAGON_ARCH_V4
+#define ELF_CORE_EFLAGS 0x3
+#endif
+
+/*
+ * Some architectures have ld.so set up a pointer to a function
+ * to be registered using atexit, to facilitate cleanup.  So that
+ * static executables will be well-behaved, we would null the register
+ * in question here, in the pt_regs structure passed.  For now,
+ * leave it a null macro.
+ */
+#define ELF_PLAT_INIT(regs, load_addr) do { } while (0)
+
+#define USE_ELF_CORE_DUMP
+#define ELF_FDPIC_CORE_EFLAGS	0x0
+
+/* Hrm is this going to cause problems for changing PAGE_SIZE?  */
+#define ELF_EXEC_PAGESIZE	4096
+
+/*
+ * This is the location that an ET_DYN program is loaded if exec'ed.  Typical
+ * use of this is to invoke "./ld.so someprog" to test out a new version of
+ * the loader.  We need to make sure that it is out of the way of the program
+ * that it will "exec", and that there is sufficient room for the brk.
+ */
+#define ELF_ET_DYN_BASE         0x08000000UL
+
+/*
+ * This yields a mask that user programs can use to figure out what
+ * instruction set this cpu supports.
+ */
+#define ELF_HWCAP	(0)
+
+/*
+ * This yields a string that ld.so will use to load implementation
+ * specific libraries for optimization.  This is more specific in
+ * intent than poking at uname or /proc/cpuinfo.
+ */
+#define ELF_PLATFORM  (NULL)
+
+#ifdef __KERNEL__
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
+#endif
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/fpu.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/fpu.h	2011-08-24 18:45:48.063877043 -0500
@@ -0,0 +1,4 @@
+/*
+ * If the FPU is used inside the kernel,
+ * kernel_fpu_end() will be defined here.
+ */
Index: linux-hexagon-kernel/arch/hexagon/include/asm/futex.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/futex.h	2011-08-24 18:45:48.063877043 -0500
@@ -0,0 +1,137 @@
+#ifndef _ASM_HEXAGON_FUTEX_H
+#define _ASM_HEXAGON_FUTEX_H
+
+#ifdef __KERNEL__
+
+#include <linux/futex.h>
+#include <linux/uaccess.h>
+#include <asm/errno.h>
+
+/* XXX TODO-- need to add sync barriers! */
+
+#define __futex_atomic_op(insn, ret, oldval, uaddr, oparg) \
+	__asm__ __volatile( \
+	"1: %0 = memw_locked(%3);\n" \
+	    /* For example: %1 = %4 */ \
+	    insn \
+	"2: memw_locked(%3,p2) = %1;\n" \
+	"   if !p2 jump 1b;\n" \
+	"   %1 = #0;\n" \
+	"3:\n" \
+	".section .fixup,\"ax\"\n" \
+	"4: %1 = #%5;\n" \
+	"   jump 3b\n" \
+	".previous\n" \
+	".section __ex_table,\"a\"\n" \
+	".long 1b,4b,2b,4b\n" \
+	".previous\n" \
+	: "=&r" (oldval), "=&r" (ret), "+m" (*uaddr) \
+	: "r" (uaddr), "r" (oparg), "i" (-EFAULT) \
+	: "p2", "memory")
+
+
+static inline int
+futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
+{
+	int op = (encoded_op >> 28) & 7;
+	int cmp = (encoded_op >> 24) & 15;
+	int oparg = (encoded_op << 8) >> 20;
+	int cmparg = (encoded_op << 20) >> 20;
+	int oldval = 0, ret;
+	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
+		oparg = 1 << oparg;
+
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
+		return -EFAULT;
+
+	pagefault_disable();
+
+	switch (op) {
+	case FUTEX_OP_SET:
+		__futex_atomic_op("%1 = %4\n", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_ADD:
+		__futex_atomic_op("%1 = add(%0,%4)\n", ret, oldval, uaddr,
+				  oparg);
+		break;
+	case FUTEX_OP_OR:
+		__futex_atomic_op("%1 = or(%0,%4)\n", ret, oldval, uaddr,
+				  oparg);
+		break;
+	case FUTEX_OP_ANDN:
+		__futex_atomic_op("%1 = not(%4); %1 = and(%0,%1)\n", ret,
+				  oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_XOR:
+		__futex_atomic_op("%1 = xor(%0,%4)\n", ret, oldval, uaddr,
+				  oparg);
+		break;
+	default:
+		ret = -ENOSYS;
+	}
+
+	pagefault_enable();
+
+	if (!ret) {
+		switch (cmp) {
+		case FUTEX_OP_CMP_EQ:
+			ret = (oldval == cmparg);
+			break;
+		case FUTEX_OP_CMP_NE:
+			ret = (oldval != cmparg);
+			break;
+		case FUTEX_OP_CMP_LT:
+			ret = (oldval < cmparg);
+			break;
+		case FUTEX_OP_CMP_GE:
+			ret = (oldval >= cmparg);
+			break;
+		case FUTEX_OP_CMP_LE:
+			ret = (oldval <= cmparg);
+			break;
+		case FUTEX_OP_CMP_GT:
+			ret = (oldval > cmparg);
+			break;
+		default:
+			ret = -ENOSYS;
+		}
+	}
+	return ret;
+}
+
+static inline int
+futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr, u32 oldval,
+			      u32 newval)
+{
+	int prev;
+	int ret;
+
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
+		return -EFAULT;
+
+	__asm__ __volatile__ (
+	"1: %1 = memw_locked(%3)\n"
+	"   {\n"
+	"      p2 = cmp.eq(%1,%4)\n"
+	"      if !p2.new jump:NT 3f\n"
+	"   }\n"
+	"2: memw_locked(%3,p2) = %5\n"
+	"   if !p2 jump 1b\n"
+	"3:\n"
+	".section .fixup,\"ax\"\n"
+	"4: %0 = #%6\n"
+	"   jump 3b\n"
+	".previous\n"
+	".section __ex_table,\"a\"\n"
+	".long 1b,4b,2b,4b\n"
+	".previous\n"
+	: "+r" (ret), "=&r" (prev), "+m" (*uaddr)
+	: "r" (uaddr), "r" (oldval), "r" (newval), "i"(-EFAULT)
+	: "p2", "memory");
+
+	*uval = prev;
+	return ret;
+}
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_HEXAGON_FUTEX_H */
Index: linux-hexagon-kernel/arch/hexagon/include/asm/linkage.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/linkage.h	2011-08-24 18:45:48.063877043 -0500
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef __ASM_LINKAGE_H
+#define __ASM_LINKAGE_H
+
+#define __ALIGN		.align 4
+#define __ALIGN_STR	".align 4"
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/module.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/module.h	2011-08-24 18:45:48.063877043 -0500
@@ -0,0 +1,26 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_MODULE_H
+#define _ASM_MODULE_H
+
+#include <asm-generic/module.h>
+
+#define MODULE_ARCH_VERMAGIC __stringify(PROCESSOR_MODEL_NAME) " "
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/param.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/param.h	2011-08-24 18:45:48.063877043 -0500
@@ -0,0 +1,26 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_PARAM_H
+#define _ASM_PARAM_H
+
+#define EXEC_PAGESIZE	16384
+
+#include <asm-generic/param.h>
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/string.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/string.h	2011-08-24 18:45:48.063877043 -0500
@@ -0,0 +1,32 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_STRING_H_
+#define _ASM_STRING_H_
+
+#ifdef __KERNEL__
+#define __HAVE_ARCH_MEMCPY
+extern void *memcpy(void *__to, __const__ void *__from, size_t __n);
+
+/*  ToDo:  use dczeroa, accelerate the compiler-constant zero case  */
+#define __HAVE_ARCH_MEMSET
+extern void *memset(void *__to, int c, size_t __n);
+#endif
+
+
+#endif /* _ASM_STRING_H_ */
Index: linux-hexagon-kernel/arch/hexagon/include/asm/suspend.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/suspend.h	2011-08-24 18:45:48.063877043 -0500
@@ -0,0 +1,27 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_SUSPEND_H
+#define _ASM_SUSPEND_H
+
+static inline int arch_prepare_suspend(void)
+{
+	return 0;
+}
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/swab.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/swab.h	2011-08-24 18:45:48.063877043 -0500
@@ -0,0 +1,24 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_SWAB_H
+#define _ASM_SWAB_H
+
+#define __SWAB_64_THRU_32__
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/timex.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/timex.h	2011-08-24 18:45:48.063877043 -0500
@@ -0,0 +1,37 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_TIMEX_H
+#define _ASM_TIMEX_H
+
+#include <asm-generic/timex.h>
+#include <asm/timer-regs.h>
+
+/* Using TCX0 as our clock.  CLOCK_TICK_RATE scheduled to be removed. */
+#define CLOCK_TICK_RATE              TCX0_CLK_RATE
+
+#define ARCH_HAS_READ_CURRENT_TIMER
+
+static inline int read_current_timer(unsigned long *timer_val)
+{
+	*timer_val = (unsigned long) __vmgettime();
+	return 0;
+}
+
+#endif
+
Index: linux-hexagon-kernel/arch/hexagon/include/asm/perf_event.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/perf_event.h	2011-08-24 18:45:48.063877043 -0500
@@ -0,0 +1,24 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_PERF_EVENT_H
+#define _ASM_PERF_EVENT_H
+
+#define PERF_EVENT_INDEX_OFFSET	0
+
+#endif /* _ASM_PERF_EVENT_H */

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


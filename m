Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511Ab2GFVJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:09:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33603 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429Ab2GFVG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:06:59 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 34/36] AArch64: Miscellaneous header files
Date: Fri,  6 Jul 2012 22:06:15 +0100
Message-Id: <1341608777-12982-35-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 06 Jul 2012 21:07:41.0385 (UTC) FILETIME=[61590B90:01CD5BBB]
X-MC-Unique: 112070622064602401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q66L9tXu005379

This patch introduces a few AArch64-specific header files together with
Kbuild entries for generic headers.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/aarch64/include/asm/Kbuild        |   50 +++++++++
 arch/aarch64/include/asm/barrier.h     |   53 +++++++++
 arch/aarch64/include/asm/bitsperlong.h |   24 ++++
 arch/aarch64/include/asm/byteorder.h   |   22 ++++
 arch/aarch64/include/asm/cmpxchg.h     |  181 ++++++++++++++++++++++++++++++++
 arch/aarch64/include/asm/compiler.h    |   31 ++++++
 arch/aarch64/include/asm/exception.h   |   24 ++++
 arch/aarch64/include/asm/exec.h        |   24 ++++
 arch/aarch64/include/asm/fcntl.h       |   30 +++++
 arch/aarch64/include/asm/system_misc.h |   59 ++++++++++
 10 files changed, 498 insertions(+), 0 deletions(-)
 create mode 100644 arch/aarch64/include/asm/Kbuild
 create mode 100644 arch/aarch64/include/asm/barrier.h
 create mode 100644 arch/aarch64/include/asm/bitsperlong.h
 create mode 100644 arch/aarch64/include/asm/byteorder.h
 create mode 100644 arch/aarch64/include/asm/cmpxchg.h
 create mode 100644 arch/aarch64/include/asm/compiler.h
 create mode 100644 arch/aarch64/include/asm/exception.h
 create mode 100644 arch/aarch64/include/asm/exec.h
 create mode 100644 arch/aarch64/include/asm/fcntl.h
 create mode 100644 arch/aarch64/include/asm/system_misc.h

diff --git a/arch/aarch64/include/asm/Kbuild b/arch/aarch64/include/asm/Kbuild
new file mode 100644
index 0000000..683a025
--- /dev/null
+++ b/arch/aarch64/include/asm/Kbuild
@@ -0,0 +1,50 @@
+include include/asm-generic/Kbuild.asm
+
+header-y += hwcap.h
+
+generic-y += bug.h
+generic-y += bugs.h
+generic-y += checksum.h
+generic-y += cputime.h
+generic-y += current.h
+generic-y += delay.h
+generic-y += div64.h
+generic-y += dma.h
+generic-y += emergency-restart.h
+generic-y += errno.h
+generic-y += ftrace.h
+generic-y += hw_irq.h
+generic-y += ioctl.h
+generic-y += ioctls.h
+generic-y += ipcbuf.h
+generic-y += irq_regs.h
+generic-y += kdebug.h
+generic-y += kmap_types.h
+generic-y += linkage.h
+generic-y += local.h
+generic-y += local64.h
+generic-y += mman.h
+generic-y += msgbuf.h
+generic-y += pci.h
+generic-y += percpu.h
+generic-y += poll.h
+generic-y += posix_types.h
+generic-y += resource.h
+generic-y += scatterlist.h
+generic-y += sections.h
+generic-y += segment.h
+generic-y += sembuf.h
+generic-y += serial.h
+generic-y += shmbuf.h
+generic-y += sizes.h
+generic-y += socket.h
+generic-y += sockios.h
+generic-y += string.h
+generic-y += switch_to.h
+generic-y += swab.h
+generic-y += termbits.h
+generic-y += termios.h
+generic-y += topology.h
+generic-y += types.h
+generic-y += unaligned.h
+generic-y += user.h
diff --git a/arch/aarch64/include/asm/barrier.h b/arch/aarch64/include/asm/barrier.h
new file mode 100644
index 0000000..654e6b6
--- /dev/null
+++ b/arch/aarch64/include/asm/barrier.h
@@ -0,0 +1,53 @@
+/*
+ * Based on arch/arm/include/asm/barrier.h
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASM_BARRIER_H
+#define __ASM_BARRIER_H
+
+#ifndef __ASSEMBLY__
+
+#define sev()		asm volatile("sev" : : : "memory")
+#define wfe()		asm volatile("wfe" : : : "memory")
+#define wfi()		asm volatile("wfi" : : : "memory")
+
+#define isb()		asm volatile("isb" : : : "memory")
+#define dsb()		asm volatile("dsb sy" : : : "memory")
+
+#define mb()		dsb()
+#define rmb()		asm volatile("dsb ld" : : : "memory")
+#define wmb()		asm volatile("dsb st" : : : "memory")
+
+#ifndef CONFIG_SMP
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#else
+#define smp_mb()	asm volatile("dmb ish" : : : "memory")
+#define smp_rmb()	asm volatile("dmb ishld" : : : "memory")
+#define smp_wmb()	asm volatile("dmb ishst" : : : "memory")
+#endif
+
+#define read_barrier_depends()		do { } while(0)
+#define smp_read_barrier_depends()	do { } while(0)
+
+#define set_mb(var, value)	do { var = value; smp_mb(); } while (0)
+#define nop()		asm volatile("nop");
+
+#endif	/* __ASSEMBLY__ */
+
+#endif	/* __ASM_BARRIER_H */
diff --git a/arch/aarch64/include/asm/bitsperlong.h b/arch/aarch64/include/asm/bitsperlong.h
new file mode 100644
index 0000000..8d8bf63
--- /dev/null
+++ b/arch/aarch64/include/asm/bitsperlong.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASM_BITSPERLONG_H
+#define __ASM_BITSPERLONG_H
+
+#define __BITS_PER_LONG 64
+
+#include <asm-generic/bitsperlong.h>
+
+#endif	/* __ASM_BITSPERLONG_H */
diff --git a/arch/aarch64/include/asm/byteorder.h b/arch/aarch64/include/asm/byteorder.h
new file mode 100644
index 0000000..ddefcc0
--- /dev/null
+++ b/arch/aarch64/include/asm/byteorder.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASM_BYTEORDER_H
+#define __ASM_BYTEORDER_H
+
+#include <linux/byteorder/little_endian.h>
+
+#endif	/* __ASM_BYTEORDER_H */
diff --git a/arch/aarch64/include/asm/cmpxchg.h b/arch/aarch64/include/asm/cmpxchg.h
new file mode 100644
index 0000000..06a4fd3
--- /dev/null
+++ b/arch/aarch64/include/asm/cmpxchg.h
@@ -0,0 +1,181 @@
+/*
+ * Based on arch/arm/include/asm/cmpxchg.h
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASM_CMPXCHG_H
+#define __ASM_CMPXCHG_H
+
+#include <linux/irqflags.h>
+#include <asm/barrier.h>
+
+static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size)
+{
+	extern void __bad_xchg(volatile void *, int);
+	unsigned long ret, tmp;
+
+	switch (size) {
+	case 1:
+		asm volatile("//	__xchg1\n"
+		"1:	ldaxrb	%w0, [%3]\n"
+		"	stlxrb	%w1, %w2, [%3]\n"
+		"	cbnz	%w1, 1b\n"
+			: "=&r" (ret), "=&r" (tmp)
+			: "r" (x), "r" (ptr)
+			: "memory", "cc");
+		break;
+	case 2:
+		asm volatile("//	__xchg2\n"
+		"1:	ldaxrh	%w0, [%3]\n"
+		"	stlxrh	%w1, %w2, [%3]\n"
+		"	cbnz	%w1, 1b\n"
+			: "=&r" (ret), "=&r" (tmp)
+			: "r" (x), "r" (ptr)
+			: "memory", "cc");
+		break;
+	case 4:
+		asm volatile("//	__xchg4\n"
+		"1:	ldaxr	%w0, [%3]\n"
+		"	stlxr	%w1, %w2, [%3]\n"
+		"	cbnz	%w1, 1b\n"
+			: "=&r" (ret), "=&r" (tmp)
+			: "r" (x), "r" (ptr)
+			: "memory", "cc");
+		break;
+	case 8:
+		asm volatile("//	__xchg8\n"
+		"1:	ldaxr	%0, [%3]\n"
+		"	stlxr	%w1, %2, [%3]\n"
+		"	cbnz	%w1, 1b\n"
+			: "=&r" (ret), "=&r" (tmp)
+			: "r" (x), "r" (ptr)
+			: "memory", "cc");
+		break;
+	default:
+		__bad_xchg(ptr, size), ret = 0;
+		break;
+	}
+
+	return ret;
+}
+
+#define xchg(ptr,x) \
+	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
+
+/*
+ * cmpxchg operations.
+ */
+extern void __bad_cmpxchg(volatile void *ptr, int size);
+
+static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
+				      unsigned long new, int size)
+{
+	unsigned long oldval, res;
+
+	switch (size) {
+	case 1:
+		do {
+			asm volatile("// __cmpxchg1\n"
+			"	ldxrb	%w1, [%2]\n"
+			"	mov	%w0, #0\n"
+			"	cmp	%w1, %w3\n"
+			"	b.ne	1f\n"
+			"	stxrb	%w0, %w4, [%2]\n"
+			"1:\n"
+				: "=&r" (res), "=&r" (oldval)
+				: "r" (ptr), "Ir" (old), "r" (new)
+				: "cc");
+		} while (res);
+		break;
+
+	case 2:
+		do {
+			asm volatile("// __cmpxchg2\n"
+			"	ldxrh	%w1, [%2]\n"
+			"	mov	%w0, #0\n"
+			"	cmp	%w1, %w3\n"
+			"	b.ne	1f\n"
+			"	stxrh	%w0, %w4, [%2]\n"
+			"1:\n"
+				: "=&r" (res), "=&r" (oldval)
+				: "r" (ptr), "Ir" (old), "r" (new)
+				: "memory", "cc");
+		} while (res);
+		break;
+
+	case 4:
+		do {
+			asm volatile("// __cmpxchg4\n"
+			"	ldxr	%w1, [%2]\n"
+			"	mov	%w0, #0\n"
+			"	cmp	%w1, %w3\n"
+			"	b.ne	1f\n"
+			"	stxr	%w0, %w4, [%2]\n"
+			"1:\n"
+				: "=&r" (res), "=&r" (oldval)
+				: "r" (ptr), "Ir" (old), "r" (new)
+				: "cc");
+		} while (res);
+		break;
+
+	case 8:
+		do {
+			asm volatile("// __cmpxchg8\n"
+			"	ldxr	%1, [%2]\n"
+			"	mov	%w0, #0\n"
+			"	cmp	%1, %3\n"
+			"	b.ne	1f\n"
+			"	stxr	%w0, %4, [%2]\n"
+			"1:\n"
+				: "=&r" (res), "=&r" (oldval)
+				: "r" (ptr), "Ir" (old), "r" (new)
+				: "cc");
+		} while (res);
+		break;
+
+	default:
+		__bad_cmpxchg(ptr, size);
+		oldval = 0;
+	}
+
+	return oldval;
+}
+
+static inline unsigned long __cmpxchg_mb(volatile void *ptr, unsigned long old,
+					 unsigned long new, int size)
+{
+	unsigned long ret;
+
+	smp_mb();
+	ret = __cmpxchg(ptr, old, new, size);
+	smp_mb();
+
+	return ret;
+}
+
+#define cmpxchg(ptr,o,n)						\
+	((__typeof__(*(ptr)))__cmpxchg_mb((ptr),			\
+					  (unsigned long)(o),		\
+					  (unsigned long)(n),		\
+					  sizeof(*(ptr))))
+
+#define cmpxchg_local(ptr,o,n)						\
+	((__typeof__(*(ptr)))__cmpxchg((ptr),				\
+				       (unsigned long)(o),		\
+				       (unsigned long)(n),		\
+				       sizeof(*(ptr))))
+
+#endif	/* __ASM_CMPXCHG_H */
diff --git a/arch/aarch64/include/asm/compiler.h b/arch/aarch64/include/asm/compiler.h
new file mode 100644
index 0000000..9d4c242
--- /dev/null
+++ b/arch/aarch64/include/asm/compiler.h
@@ -0,0 +1,31 @@
+/*
+ * Based on arch/arm/include/asm/compiler.h
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASM_COMPILER_H
+#define __ASM_COMPILER_H
+
+/*
+ * This is used to ensure the compiler did actually allocate the register we
+ * asked it for some inline assembly sequences.  Apparently we can't trust the
+ * compiler from one version to another so a bit of paranoia won't hurt.  This
+ * string is meant to be concatenated with the inline asm string and will
+ * cause compilation to stop on mismatch.  (for details, see gcc PR 15089)
+ */
+#define __asmeq(x, y)  ".ifnc " x "," y " ; .err ; .endif\n\t"
+
+#endif	/* __ASM_COMPILER_H */
diff --git a/arch/aarch64/include/asm/exception.h b/arch/aarch64/include/asm/exception.h
new file mode 100644
index 0000000..d9d441b
--- /dev/null
+++ b/arch/aarch64/include/asm/exception.h
@@ -0,0 +1,24 @@
+/*
+ * Based on arch/arm/include/asm/exception.h
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASM_EXCEPTION_H
+#define __ASM_EXCEPTION_H
+
+#define __exception	__attribute__((section(".exception.text")))
+
+#endif	/* __ASM_EXCEPTION_H */
diff --git a/arch/aarch64/include/asm/exec.h b/arch/aarch64/include/asm/exec.h
new file mode 100644
index 0000000..654c1f2
--- /dev/null
+++ b/arch/aarch64/include/asm/exec.h
@@ -0,0 +1,24 @@
+/*
+ * Based on arch/arm/include/asm/exec.h
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASM_EXEC_H
+#define __ASM_EXEC_H
+
+extern unsigned long arch_align_stack(unsigned long sp);
+
+#endif	/* __ASM_EXEC_H */
diff --git a/arch/aarch64/include/asm/fcntl.h b/arch/aarch64/include/asm/fcntl.h
new file mode 100644
index 0000000..46399c8
--- /dev/null
+++ b/arch/aarch64/include/asm/fcntl.h
@@ -0,0 +1,30 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASM_FCNTL_H
+#define __ASM_FCNTL_H
+
+/*
+ * Using our own definitions for AArch32 (compat) support.
+ */
+#define O_DIRECTORY	 040000	/* must be a directory */
+#define O_NOFOLLOW	0100000	/* don't follow links */
+#define O_DIRECT	0200000	/* direct disk access hint - currently ignored */
+#define O_LARGEFILE	0400000
+
+#include <asm-generic/fcntl.h>
+
+#endif
diff --git a/arch/aarch64/include/asm/system_misc.h b/arch/aarch64/include/asm/system_misc.h
new file mode 100644
index 0000000..98c9d03
--- /dev/null
+++ b/arch/aarch64/include/asm/system_misc.h
@@ -0,0 +1,59 @@
+/*
+ * Based on arch/arm/include/asm/system_misc.h
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASM_SYSTEM_MISC_H
+#define __ASM_SYSTEM_MISC_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <linux/irqflags.h>
+
+struct pt_regs;
+
+void die(const char *msg, struct pt_regs *regs, int err);
+
+struct siginfo;
+void aarch64_notify_die(const char *str, struct pt_regs *regs,
+			struct siginfo *info, int err);
+
+void hook_debug_fault_code(int nr, int (*fn)(unsigned long, unsigned int,
+					     struct pt_regs *),
+			   int sig, int code, const char *name);
+
+struct mm_struct;
+extern void show_pte(struct mm_struct *mm, unsigned long addr);
+extern void __show_regs(struct pt_regs *);
+
+extern void cpu_init(void);
+
+void soft_restart(unsigned long);
+extern void (*pm_restart)(const char *cmd);
+
+#define UDBG_UNDEFINED	(1 << 0)
+#define UDBG_SYSCALL	(1 << 1)
+#define UDBG_BADABORT	(1 << 2)
+#define UDBG_SEGV	(1 << 3)
+#define UDBG_BUS	(1 << 4)
+
+extern unsigned int user_debug;
+
+#endif	/* __ASSEMBLY__ */
+
+#endif	/* __ASM_SYSTEM_MISC_H */


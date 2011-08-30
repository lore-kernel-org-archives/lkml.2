Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab1H3TOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:14:47 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19410 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab1H3TOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:14:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6454"; a="114068123"
Message-Id: <20110830190759.813984525@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Aug 2011 14:07:30 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: [patch v2 01/35] Hexagon: Add generic headers
References: <20110830190729.923334292@codeaurora.org>
Content-Disposition: inline; filename=generic-asm-headers.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reworked to use the Kbuild generic headers mechanism.

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

---
 arch/hexagon/include/asm/Kbuild        |   59 ++++++++++++++++++++++++
 arch/hexagon/include/asm/bitsperlong.h |   26 ++++++++++
 arch/hexagon/include/asm/mutex.h       |    8 +++
 arch/hexagon/include/asm/setup.h       |   29 ++++++++++++
 arch/hexagon/include/asm/user.h        |   79 +++++++++++++++++++++++++++++++++
 5 files changed, 201 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/Kbuild
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/Kbuild	2011-08-24 18:45:48.053877034 -0500
@@ -0,0 +1,59 @@
+include include/asm-generic/Kbuild.asm
+
+header-y += registers.h
+header-y += ucontext.h
+
+generic-y += auxvec.h
+generic-y += bug.h
+generic-y += bugs.h
+generic-y += cpumask.h
+generic-y += cputime.h
+generic-y += current.h
+generic-y += device.h
+generic-y += div64.h
+generic-y += emergency-restart.h
+generic-y += errno.h
+generic-y += fb.h
+generic-y += fcntl.h
+generic-y += ftrace.h
+generic-y += hardirq.h
+generic-y += hw_irq.h
+generic-y += ioctl.h
+generic-y += ioctls.h
+generic-y += iomap.h
+generic-y += ipcbuf.h
+generic-y += ipc.h
+generic-y += irq_regs.h
+generic-y += kdebug.h
+generic-y += kmap_types.h
+generic-y += local64.h
+generic-y += local.h
+generic-y += local.h
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
+generic-y += shmbuf.h
+generic-y += shmparam.h
+generic-y += siginfo.h
+generic-y += socket.h
+generic-y += sockios.h
+generic-y += statfs.h
+generic-y += stat.h
+generic-y += termbits.h
+generic-y += termios.h
+generic-y += topology.h
+generic-y += types.h
+generic-y += ucontext.h
+generic-y += unaligned.h
+generic-y += xor.h
+
+
+
Index: linux-hexagon-kernel/arch/hexagon/include/asm/bitsperlong.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/bitsperlong.h	2011-08-24 18:45:48.053877034 -0500
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
+#ifndef __ASM_HEXAGON_BITSPERLONG_H
+#define __ASM_HEXAGON_BITSPERLONG_H
+
+#define __BITS_PER_LONG 32
+
+#include <asm-generic/bitsperlong.h>
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/mutex.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/mutex.h	2011-08-24 18:45:48.053877034 -0500
@@ -0,0 +1,8 @@
+/*
+ * Pull in the generic implementation for the mutex fastpath.
+ *
+ * TODO: implement optimized primitives instead, or leave the generic
+ * implementation in place, or pick the atomic_xchg() based generic
+ * implementation. (see asm-generic/mutex-xchg.h for details)
+ */
+#include <asm-generic/mutex-xchg.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/setup.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/setup.h	2011-08-24 18:45:48.053877034 -0500
@@ -0,0 +1,29 @@
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
+#ifndef _ASM_SETUP_H
+#define _ASM_SETUP_H
+
+#include <linux/init.h>
+#include <asm-generic/setup.h>
+
+extern char external_cmdline_buffer;
+
+void __init setup_arch_memory(void);
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/user.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/user.h	2011-08-24 18:45:48.053877034 -0500
@@ -0,0 +1,79 @@
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
+#ifndef HEXAGON_ASM_USER_H
+#define HEXAGON_ASM_USER_H
+
+#include <asm-generic/user.h>
+
+/*
+ * Layout for registers passed in elf core dumps to userspace.
+ *
+ * Basically a rearranged subset of "pt_regs".
+ *
+ * Interested parties:  libc, gdb...
+ */
+
+struct user_regs_struct {
+	unsigned long r0;
+	unsigned long r1;
+	unsigned long r2;
+	unsigned long r3;
+	unsigned long r4;
+	unsigned long r5;
+	unsigned long r6;
+	unsigned long r7;
+	unsigned long r8;
+	unsigned long r9;
+	unsigned long r10;
+	unsigned long r11;
+	unsigned long r12;
+	unsigned long r13;
+	unsigned long r14;
+	unsigned long r15;
+	unsigned long r16;
+	unsigned long r17;
+	unsigned long r18;
+	unsigned long r19;
+	unsigned long r20;
+	unsigned long r21;
+	unsigned long r22;
+	unsigned long r23;
+	unsigned long r24;
+	unsigned long r25;
+	unsigned long r26;
+	unsigned long r27;
+	unsigned long r28;
+	unsigned long r29;
+	unsigned long r30;
+	unsigned long r31;
+	unsigned long gp;
+	unsigned long ugp;
+	unsigned long sa0;
+	unsigned long lc0;
+	unsigned long sa1;
+	unsigned long lc1;
+	unsigned long m0;
+	unsigned long m1;
+	unsigned long p3_0;
+	unsigned long pc;
+	unsigned long cause;
+	unsigned long badva;
+};
+
+#endif

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


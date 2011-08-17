Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab1HQROE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:14:04 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61481 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab1HQRF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:05:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6440"; a="110806959"
Message-Id: <20110817163519.957524170@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Wed, 17 Aug 2011 11:34:58 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: [patch 01/36] Hexagon: Add generic headers
References: <20110817163457.878854582@codeaurora.org>
Content-Disposition: inline; filename=generic-asm-headers.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

---
 arch/hexagon/include/asm/Kbuild              |    4 +
 arch/hexagon/include/asm/bitsperlong.h       |   26 ++++++++
 arch/hexagon/include/asm/bug.h               |    1 
 arch/hexagon/include/asm/cpumask.h           |    1 
 arch/hexagon/include/asm/cputime.h           |    1 
 arch/hexagon/include/asm/device.h            |    1 
 arch/hexagon/include/asm/div64.h             |    1 
 arch/hexagon/include/asm/emergency-restart.h |    1 
 arch/hexagon/include/asm/errno.h             |    1 
 arch/hexagon/include/asm/fb.h                |    1 
 arch/hexagon/include/asm/fcntl.h             |    1 
 arch/hexagon/include/asm/ioctl.h             |    1 
 arch/hexagon/include/asm/ioctls.h            |    1 
 arch/hexagon/include/asm/ipc.h               |    1 
 arch/hexagon/include/asm/ipcbuf.h            |    1 
 arch/hexagon/include/asm/irq_regs.h          |    1 
 arch/hexagon/include/asm/kdebug.h            |    1 
 arch/hexagon/include/asm/kmap_types.h        |    1 
 arch/hexagon/include/asm/local.h             |    1 
 arch/hexagon/include/asm/local64.h           |    1 
 arch/hexagon/include/asm/mman.h              |    1 
 arch/hexagon/include/asm/msgbuf.h            |    1 
 arch/hexagon/include/asm/mutex.h             |    8 ++
 arch/hexagon/include/asm/percpu.h            |    1 
 arch/hexagon/include/asm/poll.h              |    1 
 arch/hexagon/include/asm/posix_types.h       |    8 ++
 arch/hexagon/include/asm/resource.h          |    1 
 arch/hexagon/include/asm/scatterlist.h       |    1 
 arch/hexagon/include/asm/sections.h          |    3 +
 arch/hexagon/include/asm/sembuf.h            |    1 
 arch/hexagon/include/asm/setup.h             |   29 +++++++++
 arch/hexagon/include/asm/shmbuf.h            |    1 
 arch/hexagon/include/asm/shmparam.h          |    1 
 arch/hexagon/include/asm/siginfo.h           |    1 
 arch/hexagon/include/asm/socket.h            |    1 
 arch/hexagon/include/asm/sockios.h           |    1 
 arch/hexagon/include/asm/statfs.h            |    1 
 arch/hexagon/include/asm/termbits.h          |    1 
 arch/hexagon/include/asm/termios.h           |    1 
 arch/hexagon/include/asm/topology.h          |    1 
 arch/hexagon/include/asm/types.h             |    1 
 arch/hexagon/include/asm/ucontext.h          |    1 
 arch/hexagon/include/asm/unaligned.h         |    1 
 arch/hexagon/include/asm/user.h              |   79 +++++++++++++++++++++++++++
 arch/hexagon/include/asm/xor.h               |    1 
 45 files changed, 195 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/Kbuild
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/Kbuild	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1,4 @@
+include include/asm-generic/Kbuild.asm
+
+header-y += registers.h
+header-y += ucontext.h
Index: linux-hexagon-kernel/arch/hexagon/include/asm/bitsperlong.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/bitsperlong.h	2011-07-20 15:19:33.095154861 -0500
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
Index: linux-hexagon-kernel/arch/hexagon/include/asm/bug.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/bug.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/bug.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/cpumask.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/cpumask.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/cpumask.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/cputime.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/cputime.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/cputime.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/device.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/device.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/device.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/div64.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/div64.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/div64.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/emergency-restart.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/emergency-restart.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/emergency-restart.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/errno.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/errno.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/errno.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/fb.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/fb.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/fb.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/fcntl.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/fcntl.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/fcntl.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/ioctl.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/ioctl.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/ioctl.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/ioctls.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/ioctls.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/ioctls.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/ipc.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/ipc.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/ipc.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/ipcbuf.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/ipcbuf.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/ipcbuf.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/irq_regs.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/irq_regs.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/irq_regs.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/kdebug.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/kdebug.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/kmap_types.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/kmap_types.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/kmap_types.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/local.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/local.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/mman.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/mman.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/mman.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/msgbuf.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/msgbuf.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/msgbuf.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/mutex.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/mutex.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1,8 @@
+/*
+ * Pull in the generic implementation for the mutex fastpath.
+ *
+ * TODO: implement optimized primitives instead, or leave the generic
+ * implementation in place, or pick the atomic_xchg() based generic
+ * implementation. (see asm-generic/mutex-xchg.h for details)
+ */
+#include <asm-generic/mutex-xchg.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/percpu.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/percpu.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/percpu.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/poll.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/poll.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/poll.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/posix_types.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/posix_types.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1,8 @@
+/*  These header guards are here for uClibc's protection.  */
+
+#ifndef _ASM_POSIX_TYPES_H
+#define _ASM_POSIX_TYPES_H
+
+#include <asm-generic/posix_types.h>
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/resource.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/resource.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/resource.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/scatterlist.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/scatterlist.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/scatterlist.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/sections.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/sections.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1,3 @@
+#ifndef __ASSEMBLY__
+#include <asm-generic/sections.h>
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/sembuf.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/sembuf.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/sembuf.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/setup.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/setup.h	2011-07-20 15:19:33.095154861 -0500
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
Index: linux-hexagon-kernel/arch/hexagon/include/asm/shmbuf.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/shmbuf.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/shmbuf.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/shmparam.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/shmparam.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/shmparam.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/siginfo.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/siginfo.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/siginfo.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/socket.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/socket.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/socket.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/sockios.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/sockios.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/sockios.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/statfs.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/statfs.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/statfs.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/termbits.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/termbits.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/termbits.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/termios.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/termios.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/termios.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/topology.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/topology.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/topology.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/types.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/types.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/types.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/ucontext.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/ucontext.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/ucontext.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/unaligned.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/unaligned.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/unaligned.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/user.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/user.h	2011-07-20 15:19:33.095154861 -0500
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
Index: linux-hexagon-kernel/arch/hexagon/include/asm/xor.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/xor.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/xor.h>
Index: linux-hexagon-kernel/arch/hexagon/include/asm/local64.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/local64.h	2011-07-20 15:19:33.095154861 -0500
@@ -0,0 +1 @@
+#include <asm-generic/local64.h>

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


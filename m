Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab1KAARS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:17:18 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58529 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab1KAARR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:17:17 -0400
Message-Id: <e97c6e$3uaavh@wolverine02.qualcomm.com>
X-IronPort-AV: E=McAfee;i="5400,1158,6516"; a="132459505"
From: Richard Kuo <rkuo@codeaurora.org>
Date: Mon, 31 Oct 2011 18:26:34 -0500
Subject: [PATCH v5 01/36] Hexagon: Add generic headers
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Linas Vepstas <linas@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/hexagon/include/asm/Kbuild        |   59 +++++++++++++++++++++++
 arch/hexagon/include/asm/bitsperlong.h |   26 ++++++++++
 arch/hexagon/include/asm/mutex.h       |    8 +++
 arch/hexagon/include/asm/setup.h       |   29 +++++++++++
 arch/hexagon/include/asm/user.h        |   81 ++++++++++++++++++++++++++++++++
 5 files changed, 203 insertions(+), 0 deletions(-)
 create mode 100644 arch/hexagon/include/asm/Kbuild
 create mode 100644 arch/hexagon/include/asm/bitsperlong.h
 create mode 100644 arch/hexagon/include/asm/mutex.h
 create mode 100644 arch/hexagon/include/asm/setup.h
 create mode 100644 arch/hexagon/include/asm/user.h

diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
new file mode 100644
index 0000000..6219617
--- /dev/null
+++ b/arch/hexagon/include/asm/Kbuild
@@ -0,0 +1,59 @@
+include include/asm-generic/Kbuild.asm
+
+header-y += registers.h
+header-y += ucontext.h
+header-y += user.h
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
+generic-y += rwsem.h
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
diff --git a/arch/hexagon/include/asm/bitsperlong.h b/arch/hexagon/include/asm/bitsperlong.h
new file mode 100644
index 0000000..2701cae
--- /dev/null
+++ b/arch/hexagon/include/asm/bitsperlong.h
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
diff --git a/arch/hexagon/include/asm/mutex.h b/arch/hexagon/include/asm/mutex.h
new file mode 100644
index 0000000..58b52de
--- /dev/null
+++ b/arch/hexagon/include/asm/mutex.h
@@ -0,0 +1,8 @@
+/*
+ * Pull in the generic implementation for the mutex fastpath.
+ *
+ * TODO: implement optimized primitives instead, or leave the generic
+ * implementation in place, or pick the atomic_xchg() based generic
+ * implementation. (see asm-generic/mutex-xchg.h for details)
+ */
+#include <asm-generic/mutex-xchg.h>
diff --git a/arch/hexagon/include/asm/setup.h b/arch/hexagon/include/asm/setup.h
new file mode 100644
index 0000000..3b754c5
--- /dev/null
+++ b/arch/hexagon/include/asm/setup.h
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
diff --git a/arch/hexagon/include/asm/user.h b/arch/hexagon/include/asm/user.h
new file mode 100644
index 0000000..3a55078
--- /dev/null
+++ b/arch/hexagon/include/asm/user.h
@@ -0,0 +1,81 @@
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
+	unsigned long sa0;
+	unsigned long lc0;
+	unsigned long sa1;
+	unsigned long lc1;
+	unsigned long m0;
+	unsigned long m1;
+	unsigned long usr;
+	unsigned long p3_0;
+	unsigned long gp;
+	unsigned long ugp;
+	unsigned long pc;
+	unsigned long cause;
+	unsigned long badva;
+	unsigned long pad1;  /* pad out to 48 words total */
+	unsigned long pad2;  /* pad out to 48 words total */
+	unsigned long pad3;  /* pad out to 48 words total */
+};
+
+#endif
-- 
1.7.1


--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

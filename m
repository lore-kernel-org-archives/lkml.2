Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab2KGJuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:50:01 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:53880 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab2KGJs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:58 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 27/31] ARC: Last bits (stubs) to get to a running kernel with UART
Date: Wed,  7 Nov 2012 10:47:50 +0100
Message-Id: <1352281674-2186-28-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=========================>8=============================
Linux version 3.7.0-rc3+ (vineetg@vineetg-Latitude) (gcc version 4.4.7
(ARCompact elf32 toolchain (built 20120928)) ) #5 Tue Nov 6 17:05:37 CET
2012
[plat-arcfpga]: registering early dev resources
bootconsole [early_ARCuart0] enabled
pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
pcpu-alloc: [0] 0
Built 1 zonelists in Zone order, mobility grouping on.  Total pages:
32624
Kernel command line: print-fatal-signals=1
PID hash table entries: 1024 (order: -1, 4096 bytes)
Dentry cache hash table entries: 32768 (order: 4, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 3, 65536 bytes)
Memory Available: 248M / 256M (1219K code, 412K data, 4192K init, 1400K
reserv)
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
NR_IRQS:16
Device [ARC Timer0] clockevent mode now [1]
Device [ARC Timer0] clockevent mode now [2]
Console: colour dummy device 80x25
Calibrating delay loop... 39.73 BogoMIPS (lpj=198656)
pid_max: default: 4096 minimum: 301
Mount-cache hash table entries: 1024
devtmpfs: initialized
[plat-arcfpga]: registering device resources
bio: create slab <bio-0> at 0
Switching to clocksource ARC Timer1
Device [ARC Timer0] clockevent mode now [3]
io scheduler noop registered (default)
arc-uart.0: ttyARC0 at MMIO 0xc0fc1000 (irq = 5) is a arc-uart
console [ttyARC0] enabled, bootconsole disabled
console [ttyARC0] enabled, bootconsole disabled
Warning: unable to open an initial console.
Freeing unused kernel memory: 4192k [80002000] to [8041a000]
Mounting proc
Mounting sysfs
Mounting devpts
Setting hostname to ARCLinux
Starting System logger (syslogd)
Bringing up loopback device
ifconfig: socket: Function not implemented
route: socket: Function not implemented
Disk not detected !
Mounting tmpfs
/etc/init.d/rcS: line 76: can't create /proc/sys/kernel/msgmni:
nonexistent directory

Please press Enter to activate this console.
***********************************************************************
                        Welcome to ARCLinux
***********************************************************************
[ARCLinux]$

=========================>8=============================

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/kernel/ptrace.c       |   26 ++++++++++++++++++++++++
 arch/arc/kernel/stacktrace.c   |   43 ++++++++++++++++++++++++++++++++++++++++
 arch/arc/kernel/troubleshoot.c |   17 +++++++++++++++
 3 files changed, 86 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/kernel/ptrace.c
 create mode 100644 arch/arc/kernel/stacktrace.c
 create mode 100644 arch/arc/kernel/troubleshoot.c

diff --git a/arch/arc/kernel/ptrace.c b/arch/arc/kernel/ptrace.c
new file mode 100644
index 0000000..1cf944a
--- /dev/null
+++ b/arch/arc/kernel/ptrace.c
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/ptrace.h>
+
+void ptrace_disable(struct task_struct *child)
+{
+}
+
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
+{
+	int ret = -EIO;
+	return ret;
+}
+
+
+const struct user_regset_view *task_user_regset_view(struct task_struct *task)
+{
+	return (const struct user_regset_view *)NULL;
+}
diff --git a/arch/arc/kernel/stacktrace.c b/arch/arc/kernel/stacktrace.c
new file mode 100644
index 0000000..b9d1646
--- /dev/null
+++ b/arch/arc/kernel/stacktrace.c
@@ -0,0 +1,43 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/ptrace.h>
+#include <linux/export.h>
+
+/*-------------------------------------------------------------------------
+ *              APIs expected by various kernel sub-systems
+ *-------------------------------------------------------------------------
+ */
+
+noinline void show_stacktrace(struct task_struct *tsk, struct pt_regs *regs)
+{
+	pr_info("\nStack Trace: NOT Available\n");
+}
+EXPORT_SYMBOL(show_stacktrace);
+
+/* Expected by sched Code */
+void show_stack(struct task_struct *tsk, unsigned long *sp)
+{
+	show_stacktrace(tsk, NULL);
+}
+
+/* Expected by Rest of kernel code */
+void dump_stack(void)
+{
+	show_stacktrace(NULL, NULL);
+}
+EXPORT_SYMBOL(dump_stack);
+
+/* Another API expected by schedular, shows up in "ps" as Wait Channel
+ * Ofcourse just returning schedule( ) would be pointless so unwind until
+ * the function is not in schedular code
+ */
+unsigned int get_wchan(struct task_struct *tsk)
+{
+	return 0;
+}
diff --git a/arch/arc/kernel/troubleshoot.c b/arch/arc/kernel/troubleshoot.c
new file mode 100644
index 0000000..80bfe2a
--- /dev/null
+++ b/arch/arc/kernel/troubleshoot.c
@@ -0,0 +1,17 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ */
+
+#include <linux/ptrace.h>
+
+void show_regs(struct pt_regs *regs)
+{
+}
+
+void show_kernel_fault_diag(const char *str, struct pt_regs *regs,
+			    unsigned long address, unsigned long cause_reg)
+{
+}
-- 
1.7.4.1


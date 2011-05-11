Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab1EKVHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:07:08 -0400
Received: from c-76-97-164-112.hsd1.ga.comcast.net ([76.97.164.112]:55110 "EHLO
	deneb.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756176Ab1EKVG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:06:56 -0400
X-Greylist: delayed 3155 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 17:06:39 EDT
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 09/16] C6X: add kernel files
Date: Wed, 11 May 2011 16:13:56 -0400
Message-Id: <1305144843-5058-10-git-send-email-msalter@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1305144843-5058-9-git-send-email-msalter@redhat.com>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
 <1305144843-5058-2-git-send-email-msalter@redhat.com>
 <1305144843-5058-3-git-send-email-msalter@redhat.com>
 <1305144843-5058-4-git-send-email-msalter@redhat.com>
 <1305144843-5058-5-git-send-email-msalter@redhat.com>
 <1305144843-5058-6-git-send-email-msalter@redhat.com>
 <1305144843-5058-7-git-send-email-msalter@redhat.com>
 <1305144843-5058-8-git-send-email-msalter@redhat.com>
 <1305144843-5058-9-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/kernel/Makefile       |   13 +
 arch/c6x/kernel/asm-offsets.c  |  127 ++++++
 arch/c6x/kernel/c6x_ksyms.c    |   75 ++++
 arch/c6x/kernel/clkdev.c       |  192 +++++++++
 arch/c6x/kernel/early_printk.c |   81 ++++
 arch/c6x/kernel/entry.S        |  851 ++++++++++++++++++++++++++++++++++++++++
 arch/c6x/kernel/head.S         |  127 ++++++
 arch/c6x/kernel/irq.c          |  119 ++++++
 arch/c6x/kernel/module.c       |  249 ++++++++++++
 arch/c6x/kernel/process.c      |  349 ++++++++++++++++
 arch/c6x/kernel/ptrace.c       |  284 +++++++++++++
 arch/c6x/kernel/setup.c        |  550 ++++++++++++++++++++++++++
 arch/c6x/kernel/signal.c       |  384 ++++++++++++++++++
 arch/c6x/kernel/switch_to.S    |   67 ++++
 arch/c6x/kernel/sys_c6x.c      |  111 ++++++
 arch/c6x/kernel/tags.c         |   98 +++++
 arch/c6x/kernel/tags.h         |   82 ++++
 arch/c6x/kernel/time.c         |   55 +++
 arch/c6x/kernel/traps.c        |  416 ++++++++++++++++++++
 arch/c6x/kernel/vectors.S      |   81 ++++
 arch/c6x/kernel/vmlinux.lds.S  |  205 ++++++++++
 21 files changed, 4516 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/kernel/Makefile
 create mode 100644 arch/c6x/kernel/asm-offsets.c
 create mode 100644 arch/c6x/kernel/c6x_ksyms.c
 create mode 100644 arch/c6x/kernel/clkdev.c
 create mode 100644 arch/c6x/kernel/early_printk.c
 create mode 100644 arch/c6x/kernel/entry.S
 create mode 100644 arch/c6x/kernel/head.S
 create mode 100644 arch/c6x/kernel/irq.c
 create mode 100644 arch/c6x/kernel/module.c
 create mode 100644 arch/c6x/kernel/process.c
 create mode 100644 arch/c6x/kernel/ptrace.c
 create mode 100644 arch/c6x/kernel/setup.c
 create mode 100644 arch/c6x/kernel/signal.c
 create mode 100644 arch/c6x/kernel/switch_to.S
 create mode 100644 arch/c6x/kernel/sys_c6x.c
 create mode 100644 arch/c6x/kernel/tags.c
 create mode 100644 arch/c6x/kernel/tags.h
 create mode 100644 arch/c6x/kernel/time.c
 create mode 100644 arch/c6x/kernel/traps.c
 create mode 100644 arch/c6x/kernel/vectors.S
 create mode 100644 arch/c6x/kernel/vmlinux.lds.S

diff --git a/arch/c6x/kernel/Makefile b/arch/c6x/kernel/Makefile
new file mode 100644
index 0000000..25cdded
--- /dev/null
+++ b/arch/c6x/kernel/Makefile
@@ -0,0 +1,13 @@
+#
+# Makefile for arch/c6x/kernel/
+#
+
+extra-y	 := head.o vmlinux.lds
+
+obj-y 	 := process.o traps.o irq.o signal.o ptrace.o \
+	    setup.o sys_c6x.o time.o \
+            switch_to.o entry.o vectors.o c6x_ksyms.o tags.o
+
+obj-$(CONFIG_MODULES)          += module.o
+obj-$(CONFIG_COMMON_CLKDEV)    += clkdev.o
+obj-$(CONFIG_EARLY_PRINTK)     += early_printk.o
diff --git a/arch/c6x/kernel/asm-offsets.c b/arch/c6x/kernel/asm-offsets.c
new file mode 100644
index 0000000..52fca25
--- /dev/null
+++ b/arch/c6x/kernel/asm-offsets.c
@@ -0,0 +1,127 @@
+/*
+ * Generate definitions needed by assembly language modules.
+ * This code generates raw asm output which is post-processed
+ * to extract and format the required data.
+ */
+
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/dma-mapping.h>
+#include <linux/thread_info.h>
+#include <asm/procinfo.h>
+#include <linux/kbuild.h>
+#include <linux/unistd.h>
+
+void foo(void)
+{
+	OFFSET(REGS_A16,	pt_regs, a16);
+	OFFSET(REGS_A17,	pt_regs, a17);
+	OFFSET(REGS_A18,	pt_regs, a18);
+	OFFSET(REGS_A19,	pt_regs, a19);
+	OFFSET(REGS_A20,	pt_regs, a20);
+	OFFSET(REGS_A21,	pt_regs, a21);
+	OFFSET(REGS_A22,	pt_regs, a22);
+	OFFSET(REGS_A23,	pt_regs, a23);
+	OFFSET(REGS_A24,	pt_regs, a24);
+	OFFSET(REGS_A25,	pt_regs, a25);
+	OFFSET(REGS_A26,	pt_regs, a26);
+	OFFSET(REGS_A27,	pt_regs, a27);
+	OFFSET(REGS_A28,	pt_regs, a28);
+	OFFSET(REGS_A29,	pt_regs, a29);
+	OFFSET(REGS_A30,	pt_regs, a30);
+	OFFSET(REGS_A31,	pt_regs, a31);
+
+	OFFSET(REGS_B16,	pt_regs, b16);
+	OFFSET(REGS_B17,	pt_regs, b17);
+	OFFSET(REGS_B18,	pt_regs, b18);
+	OFFSET(REGS_B19,	pt_regs, b19);
+	OFFSET(REGS_B20,	pt_regs, b20);
+	OFFSET(REGS_B21,	pt_regs, b21);
+	OFFSET(REGS_B22,	pt_regs, b22);
+	OFFSET(REGS_B23,	pt_regs, b23);
+	OFFSET(REGS_B24,	pt_regs, b24);
+	OFFSET(REGS_B25,	pt_regs, b25);
+	OFFSET(REGS_B26,	pt_regs, b26);
+	OFFSET(REGS_B27,	pt_regs, b27);
+	OFFSET(REGS_B28,	pt_regs, b28);
+	OFFSET(REGS_B29,	pt_regs, b29);
+	OFFSET(REGS_B30,	pt_regs, b30);
+	OFFSET(REGS_B31,	pt_regs, b31);
+
+	OFFSET(REGS_A0,		pt_regs, a0);
+	OFFSET(REGS_A1,		pt_regs, a1);
+	OFFSET(REGS_A2,		pt_regs, a2);
+	OFFSET(REGS_A3,		pt_regs, a3);
+	OFFSET(REGS_A4,		pt_regs, a4);
+	OFFSET(REGS_A5,		pt_regs, a5);
+	OFFSET(REGS_A6,		pt_regs, a6);
+	OFFSET(REGS_A7,		pt_regs, a7);
+	OFFSET(REGS_A8,		pt_regs, a8);
+	OFFSET(REGS_A9,		pt_regs, a9);
+	OFFSET(REGS_A10,	pt_regs, a10);
+	OFFSET(REGS_A11,	pt_regs, a11);
+	OFFSET(REGS_A12,	pt_regs, a12);
+	OFFSET(REGS_A13,	pt_regs, a13);
+	OFFSET(REGS_A14,	pt_regs, a14);
+	OFFSET(REGS_A15,	pt_regs, a15);
+
+	OFFSET(REGS_B0,		pt_regs, b0);
+	OFFSET(REGS_B1,		pt_regs, b1);
+	OFFSET(REGS_B2,		pt_regs, b2);
+	OFFSET(REGS_B3,		pt_regs, b3);
+	OFFSET(REGS_B4,		pt_regs, b4);
+	OFFSET(REGS_B5,		pt_regs, b5);
+	OFFSET(REGS_B6,		pt_regs, b6);
+	OFFSET(REGS_B7,		pt_regs, b7);
+	OFFSET(REGS_B8,		pt_regs, b8);
+	OFFSET(REGS_B9,		pt_regs, b9);
+	OFFSET(REGS_B10,	pt_regs, b10);
+	OFFSET(REGS_B11,	pt_regs, b11);
+	OFFSET(REGS_B12,	pt_regs, b12);
+	OFFSET(REGS_B13,	pt_regs, b13);
+	OFFSET(REGS_DP,		pt_regs, dp);
+	OFFSET(REGS_SP,		pt_regs, sp);
+
+	OFFSET(REGS_TSR,	pt_regs, tsr);
+	OFFSET(REGS_ORIG_A4,	pt_regs, orig_a4);
+
+	DEFINE(REGS__END,	sizeof(struct pt_regs));
+	BLANK();
+
+	OFFSET(THREAD_PC,	thread_struct, pc);
+	OFFSET(THREAD_B15_14,	thread_struct, b15_14);
+	OFFSET(THREAD_A15_14,	thread_struct, a15_14);
+	OFFSET(THREAD_B13_12,	thread_struct, b13_12);
+	OFFSET(THREAD_A13_12,	thread_struct, a13_12);
+	OFFSET(THREAD_B11_10,	thread_struct, b11_10);
+	OFFSET(THREAD_A11_10,	thread_struct, a11_10);
+	OFFSET(THREAD_RICL_ICL,	thread_struct, ricl_icl);
+	BLANK();
+
+	OFFSET(TASK_STATE,	task_struct, state);
+	BLANK();
+
+	OFFSET(THREAD_INFO_FLAGS,	thread_info, flags);
+	OFFSET(THREAD_INFO_PREEMPT_COUNT, thread_info, preempt_count);
+	BLANK();
+
+	/* These would be unneccessary if we ran asm files
+	 * through the preprocessor.
+	 */
+	DEFINE(KTHREAD_SIZE, THREAD_SIZE);
+	DEFINE(KTHREAD_SHIFT, THREAD_SHIFT);
+	DEFINE(KTHREAD_START_SP, THREAD_START_SP);
+	DEFINE(ENOSYS_, ENOSYS);
+	DEFINE(NR_SYSCALLS_, __NR_syscalls);
+
+	DEFINE(_TIF_SYSCALL_TRACE, (1<<TIF_SYSCALL_TRACE));
+	DEFINE(_TIF_NOTIFY_RESUME, (1<<TIF_NOTIFY_RESUME));
+	DEFINE(_TIF_SIGPENDING, (1<<TIF_SIGPENDING));
+	DEFINE(_TIF_NEED_RESCHED, (1<<TIF_NEED_RESCHED));
+	DEFINE(_TIF_POLLING_NRFLAG, (1<<TIF_POLLING_NRFLAG));
+
+	DEFINE(_TIF_ALLWORK_MASK, TIF_ALLWORK_MASK);
+	DEFINE(_TIF_WORK_MASK, TIF_WORK_MASK);
+}
+
diff --git a/arch/c6x/kernel/c6x_ksyms.c b/arch/c6x/kernel/c6x_ksyms.c
new file mode 100644
index 0000000..8ee8a93
--- /dev/null
+++ b/arch/c6x/kernel/c6x_ksyms.c
@@ -0,0 +1,75 @@
+/*
+ *  linux/arch/c6x/kernel/c6x_ksyms.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+#include <linux/module.h>
+#include <asm/checksum.h>
+#include <linux/io.h>
+
+/*
+ * libgcc functions - used internally by the compiler...
+ */
+extern int __c6xabi_divi(int dividend, int divisor);
+EXPORT_SYMBOL(__c6xabi_divi);
+
+extern unsigned __c6xabi_divu(unsigned	dividend, unsigned divisor);
+EXPORT_SYMBOL(__c6xabi_divu);
+
+extern int __c6xabi_remi(int dividend, int divisor);
+EXPORT_SYMBOL(__c6xabi_remi);
+
+extern unsigned __c6xabi_remu(unsigned	dividend, unsigned divisor);
+EXPORT_SYMBOL(__c6xabi_remu);
+
+extern int __c6xabi_divremi(int dividend, int divisor);
+EXPORT_SYMBOL(__c6xabi_divremi);
+
+extern unsigned __c6xabi_divremu(unsigned  dividend, unsigned divisor);
+EXPORT_SYMBOL(__c6xabi_divremu);
+
+extern unsigned long long __c6xabi_mpyll(unsigned long long src1,
+					 unsigned long long src2);
+EXPORT_SYMBOL(__c6xabi_mpyll);
+
+extern unsigned long long __c6xabi_divull(unsigned long long n,
+					  unsigned long long d);
+EXPORT_SYMBOL(__c6xabi_divull);
+
+extern long long __c6xabi_negll(long long src);
+EXPORT_SYMBOL(__c6xabi_negll);
+
+extern unsigned long long __c6xabi_llshl(unsigned long long src1, uint src2);
+EXPORT_SYMBOL(__c6xabi_llshl);
+
+extern long long __c6xabi_llshr(long long src1, uint src2);
+EXPORT_SYMBOL(__c6xabi_llshr);
+
+extern unsigned long long __c6xabi_llshru(unsigned long long src1, uint src2);
+EXPORT_SYMBOL(__c6xabi_llshru);
+
+extern void __c6xabi_strasgi(int *dst, const int *src, unsigned cnt);
+EXPORT_SYMBOL(__c6xabi_strasgi);
+
+extern void __c6xabi_push_rts(void);
+EXPORT_SYMBOL(__c6xabi_push_rts);
+
+extern void __c6xabi_pop_rts(void);
+EXPORT_SYMBOL(__c6xabi_pop_rts);
+
+extern void __c6xabi_strasgi_64plus(int *dst, const int *src, unsigned cnt);
+EXPORT_SYMBOL(__c6xabi_strasgi_64plus);
+
+/* lib functions */
+EXPORT_SYMBOL(memcpy);
+EXPORT_SYMBOL(csum_partial);
+EXPORT_SYMBOL(ip_fast_csum);
+
diff --git a/arch/c6x/kernel/clkdev.c b/arch/c6x/kernel/clkdev.c
new file mode 100644
index 0000000..747c316
--- /dev/null
+++ b/arch/c6x/kernel/clkdev.c
@@ -0,0 +1,192 @@
+/*
+ *  arch/c6x/kernel/clkdev.c
+ *
+ *  Copyright (C) 2010 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  Original code from: arch/arm/common/clkdev.c
+ *
+ *  Copyright (C) 2008 Russell King.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Helper for the clk API to assist looking up a struct clk.
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/clk.h>
+
+#include <asm/clkdev.h>
+
+static LIST_HEAD(clocks);
+static DEFINE_MUTEX(clocks_mutex);
+
+
+int __weak __clk_get(struct clk *clk)
+{
+	return 1;
+}
+
+void __weak __clk_put(struct clk *clk)
+{
+}
+
+/*
+ * Find the correct struct clk for the device and connection ID.
+ * We do slightly fuzzy matching here:
+ *  An entry with a NULL ID is assumed to be a wildcard.
+ *  If an entry has a device ID, it must match
+ *  If an entry has a connection ID, it must match
+ * Then we take the most specific entry - with the following
+ * order of precedence: dev+con > dev only > con only.
+ */
+static struct clk *clk_find(const char *dev_id, const char *con_id)
+{
+	struct clk_lookup *p;
+	struct clk *clk = NULL;
+	int match, best = 0;
+
+	list_for_each_entry(p, &clocks, node) {
+		match = 0;
+		if (p->dev_id) {
+			if (!dev_id || strcmp(p->dev_id, dev_id))
+				continue;
+			match += 2;
+		}
+		if (p->con_id) {
+			if (!con_id || strcmp(p->con_id, con_id))
+				continue;
+			match += 1;
+		}
+		if (match == 0)
+			continue;
+
+		if (match > best) {
+			clk = p->clk;
+			best = match;
+		}
+	}
+	return clk;
+}
+
+struct clk *clk_get_sys(const char *dev_id, const char *con_id)
+{
+	struct clk *clk;
+
+	mutex_lock(&clocks_mutex);
+	clk = clk_find(dev_id, con_id);
+	if (clk && !__clk_get(clk))
+		clk = NULL;
+	mutex_unlock(&clocks_mutex);
+
+	return clk ? clk : ERR_PTR(-ENOENT);
+}
+EXPORT_SYMBOL(clk_get_sys);
+
+struct clk *clk_get(struct device *dev, const char *con_id)
+{
+	const char *dev_id = dev ? dev_name(dev) : NULL;
+
+	return clk_get_sys(dev_id, con_id);
+}
+EXPORT_SYMBOL(clk_get);
+
+void clk_put(struct clk *clk)
+{
+	__clk_put(clk);
+}
+EXPORT_SYMBOL(clk_put);
+
+void clkdev_add(struct clk_lookup *cl)
+{
+	mutex_lock(&clocks_mutex);
+	list_add_tail(&cl->node, &clocks);
+	mutex_unlock(&clocks_mutex);
+}
+EXPORT_SYMBOL(clkdev_add);
+
+void __init clkdev_add_table(struct clk_lookup *cl, size_t num)
+{
+	mutex_lock(&clocks_mutex);
+	while (num--) {
+		list_add_tail(&cl->node, &clocks);
+		cl++;
+	}
+	mutex_unlock(&clocks_mutex);
+}
+
+#define MAX_DEV_ID	20
+#define MAX_CON_ID	16
+
+struct clk_lookup_alloc {
+	struct clk_lookup cl;
+	char	dev_id[MAX_DEV_ID];
+	char	con_id[MAX_CON_ID];
+};
+
+struct clk_lookup *clkdev_alloc(struct clk *clk, const char *con_id,
+	const char *dev_fmt, ...)
+{
+	struct clk_lookup_alloc *cla;
+
+	cla = kzalloc(sizeof(*cla), GFP_KERNEL);
+	if (!cla)
+		return NULL;
+
+	cla->cl.clk = clk;
+	if (con_id) {
+		strlcpy(cla->con_id, con_id, sizeof(cla->con_id));
+		cla->cl.con_id = cla->con_id;
+	}
+
+	if (dev_fmt) {
+		va_list ap;
+
+		va_start(ap, dev_fmt);
+		vscnprintf(cla->dev_id, sizeof(cla->dev_id), dev_fmt, ap);
+		cla->cl.dev_id = cla->dev_id;
+		va_end(ap);
+	}
+
+	return &cla->cl;
+}
+EXPORT_SYMBOL(clkdev_alloc);
+
+int clk_add_alias(const char *alias, const char *alias_dev_name, char *id,
+	struct device *dev)
+{
+	struct clk *r = clk_get(dev, id);
+	struct clk_lookup *l;
+
+	if (IS_ERR(r))
+		return PTR_ERR(r);
+
+	l = clkdev_alloc(r, alias, alias_dev_name);
+	clk_put(r);
+	if (!l)
+		return -ENODEV;
+	clkdev_add(l);
+	return 0;
+}
+EXPORT_SYMBOL(clk_add_alias);
+
+/*
+ * clkdev_drop - remove a clock dynamically allocated
+ */
+void clkdev_drop(struct clk_lookup *cl)
+{
+	mutex_lock(&clocks_mutex);
+	list_del(&cl->node);
+	mutex_unlock(&clocks_mutex);
+	kfree(cl);
+}
+EXPORT_SYMBOL(clkdev_drop);
diff --git a/arch/c6x/kernel/early_printk.c b/arch/c6x/kernel/early_printk.c
new file mode 100644
index 0000000..06a72fd
--- /dev/null
+++ b/arch/c6x/kernel/early_printk.c
@@ -0,0 +1,81 @@
+/*
+ *  linux/arch/c6x/kernel/early_printk.c
+ *
+ *  Copyright (C) 2011 Texas Instruments Incoporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/console.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <asm/setup.h>
+
+
+static void (*early_write)(const char *s, unsigned n);
+
+static int __initdata keep_early;
+
+static void early_console_write(struct console *con, const char *s, unsigned n)
+{
+	early_write(s, n);
+}
+
+static struct console early_console = {
+	.write =	early_console_write,
+	.flags =	CON_PRINTBUFFER,
+	.index =	-1,
+};
+
+void early_printk(const char *fmt, ...)
+{
+	char buf[512];
+	int n;
+	va_list ap;
+
+	va_start(ap, fmt);
+	n = vscnprintf(buf, sizeof(buf), fmt, ap);
+	early_write(buf, n);
+	va_end(ap);
+}
+
+static int __init setup_early_printk(char *str)
+{
+	if (!str)
+		return 0;
+
+	if (early_write != NULL)
+		return 0;
+
+#ifdef CONFIG_HVC_C6X
+	if (!strncmp(str, "hvc", 3)) {
+		str += 3;
+		early_write = hvc_c6x_early_puts;
+		strcpy(early_console.name, "early_hvc");
+	}
+#endif
+
+	if (strncmp(str, ",keep", 5) == 0)
+		keep_early = 1;
+
+	if (likely(early_write)) {
+
+		if (keep_early)
+			early_console.flags &= ~CON_BOOT;
+		else
+			early_console.flags |= CON_BOOT;
+
+		register_console(&early_console);
+		printk(KERN_INFO "early printk enabled on %s%d\n",
+			early_console.name,
+			early_console.index);
+	}
+
+	return 0;
+}
+early_param("earlyprintk", setup_early_printk);
+
diff --git a/arch/c6x/kernel/entry.S b/arch/c6x/kernel/entry.S
new file mode 100644
index 0000000..e35dd2d
--- /dev/null
+++ b/arch/c6x/kernel/entry.S
@@ -0,0 +1,851 @@
+;
+;  linux/arch/c6x/kernel/entry.s
+;
+;  Port on Texas Instruments TMS320C6x architecture
+;
+;  Copyright (C) 2004, 2005, 2006, 2009, 2010, 2011 Texas Instruments Incorporated
+;  Author: Aurelien Jacquiot (aurelien.jacquiot@virtuallogix.com)
+;  Updated for 2.6.34: Mark Salter <msalter@redhat.com>
+;
+;  This program is free software; you can redistribute it and/or modify
+;  it under the terms of the GNU General Public License version 2 as
+;  published by the Free Software Foundation.
+;
+
+	.altmacro
+#define _DEFINE_MACRO(name,args...) .macro name args
+
+#include <linux/sys.h>
+#include <linux/linkage.h>
+#include <asm/thread_info.h>
+#include <asm/asm-offsets.h>
+#include <asm/unistd.h>
+#include <asm/errno.h>
+
+; Registers naming
+#define DP	B14
+#define SP	B15
+
+#ifndef CONFIG_PREEMPT
+#define resume_kernel restore_all
+#endif
+
+	;; Entry management functions
+		.global	ret_from_exception
+		.global	ret_from_interrupt
+
+	;; Interrupt handlers
+		.global	_int4_handler
+		.global	_int5_handler
+		.global	_int6_handler
+		.global	_int7_handler
+		.global	_int8_handler
+		.global	_int9_handler
+		.global	_int10_handler
+		.global	_int11_handler
+		.global	_int12_handler
+		.global	_int13_handler
+		.global	_int14_handler
+		.global	_int15_handler
+		.global	_bad_interrupt
+		.global	_nmi_handler
+
+	;;
+	;;  This defines the normal kernel pt_regs layout.
+	;;
+_DEFINE_MACRO(SAVE_ALL,__rp,__tsr)
+	STW	.D2T2	B0,*SP--[2]		; save original B0
+	MVKL	.S2	current_ksp,B0
+	MVKH	.S2	current_ksp,B0
+	LDW	.D2T2	*B0,B1			; KSP
+
+	NOP	3
+	STW	.D2T2	B1,*+SP[1]		; save original B1
+	XOR	.D2	SP,B1,B0		; (SP ^ KSP)
+	LDW	.D2T2	*+SP[1],B1		; restore B0/B1
+	LDW	.D2T2	*++SP[2],B0
+	SHR	.S2	B0,THREAD_SHIFT,B0	; 0 if already using kernel stack
+
+  [B0]	STDW	.D2T2	SP:DP,*--B1[1]		; user: save user sp/dp on kernel stack
+  [B0]	MV	.S2	B1,SP			;    and switch to kernel stack
+||[!B0] STDW	.D2T2	SP:DP,*--SP[1]		; kernel: save on current stack
+
+	SUBAW	.D2	SP,2,SP
+
+	ADD	.D1X	SP,-8,A15
+ ||	STDW	.D2T1	A15:A14,*SP--[16]	; save A15:A14
+
+	STDW	.D2T2	B13:B12,*SP--[1]
+ ||	STDW	.D1T1	A13:A12,*A15--[1]
+ ||	MVC	.S2	__rp,B13
+
+	STDW	.D2T2	B11:B10,*SP--[1]
+ ||	STDW	.D1T1	A11:A10,*A15--[1]
+ ||	MVC	.S2	CSR,B12
+
+	STDW	.D2T2	B9:B8,*SP--[1]
+ ||	STDW	.D1T1	A9:A8,*A15--[1]
+ ||	MVC	.S2	RILC,B11
+	STDW	.D2T2	B7:B6,*SP--[1]
+ ||	STDW	.D1T1	A7:A6,*A15--[1]
+ ||	MVC	.S2	ILC,B10
+
+	STDW	.D2T2	B5:B4,*SP--[1]
+ ||	STDW	.D1T1	A5:A4,*A15--[1]
+
+	STDW	.D2T2	B3:B2,*SP--[1]
+ ||	STDW	.D1T1	A3:A2,*A15--[1]
+ ||	MVC	.S2	__tsr,B5
+
+	STDW	.D2T2	B1:B0,*SP--[1]
+ ||	STDW	.D1T1	A1:A0,*A15--[1]
+ ||	MV	.S1X	B5,A5
+
+	STDW	.D2T2	B31:B30,*SP--[1]
+ ||	STDW	.D1T1	A31:A30,*A15--[1]
+	STDW	.D2T2	B29:B28,*SP--[1]
+ ||	STDW	.D1T1	A29:A28,*A15--[1]
+	STDW	.D2T2	B27:B26,*SP--[1]
+ ||	STDW	.D1T1	A27:A26,*A15--[1]
+	STDW	.D2T2	B25:B24,*SP--[1]
+ ||	STDW	.D1T1	A25:A24,*A15--[1]
+	STDW	.D2T2	B23:B22,*SP--[1]
+ ||	STDW	.D1T1	A23:A22,*A15--[1]
+	STDW	.D2T2	B21:B20,*SP--[1]
+ ||	STDW	.D1T1	A21:A20,*A15--[1]
+	STDW	.D2T2	B19:B18,*SP--[1]
+ ||	STDW	.D1T1	A19:A18,*A15--[1]
+	STDW	.D2T2	B17:B16,*SP--[1]
+ ||	STDW	.D1T1	A17:A16,*A15--[1]
+
+	STDW	.D2T2	B13:B12,*SP--[1]	; save PC and CSR
+
+	STDW	.D2T2	B11:B10,*SP--[1]	; save RILC and ILC
+	STDW	.D2T1	A5:A4,*SP--[1]		; save TSR and orig A4
+
+	;; We left an unused word on the stack just above pt_regs.
+	;; It is used to save whether or not this frame is due to
+	;; a syscall. It is cleared here, but the syscall handler
+	;; sets it to a non-zero value.
+	MVK	.L2	0,B1
+	STW	.D2T2	B1,*+SP(REGS__END+8)	; clear syscall flag
+	.endm
+
+_DEFINE_MACRO(SAVE_ALL_EXCEPT)
+	SAVE_ALL NRP,NTSR
+	.endm
+
+_DEFINE_MACRO(SAVE_ALL_INT)
+	SAVE_ALL IRP,ITSR
+	.endm
+
+_DEFINE_MACRO(RESTORE_ALL,__rp,__tsr)
+
+	LDDW	.D2T2	*++SP[1],B9:B8		; get TSR (B9)
+	LDDW	.D2T2	*++SP[1],B11:B10	; get RILC (B11) and ILC (B10)
+	LDDW	.D2T2	*++SP[1],B13:B12	; get PC (B13) and CSR (B12)
+
+	ADDAW	.D1X	SP,30,A15
+
+	LDDW	.D1T1	*++A15[1],A17:A16
+ ||	LDDW	.D2T2	*++SP[1],B17:B16
+	LDDW	.D1T1	*++A15[1],A19:A18
+ ||	LDDW	.D2T2	*++SP[1],B19:B18
+	LDDW	.D1T1	*++A15[1],A21:A20
+ ||	LDDW	.D2T2	*++SP[1],B21:B20
+	LDDW	.D1T1	*++A15[1],A23:A22
+ ||	LDDW	.D2T2	*++SP[1],B23:B22
+	LDDW	.D1T1	*++A15[1],A25:A24
+ ||	LDDW	.D2T2	*++SP[1],B25:B24
+	LDDW	.D1T1	*++A15[1],A27:A26
+ ||	LDDW	.D2T2	*++SP[1],B27:B26
+	LDDW	.D1T1	*++A15[1],A29:A28
+ ||	LDDW	.D2T2	*++SP[1],B29:B28
+	LDDW	.D1T1	*++A15[1],A31:A30
+ ||	LDDW	.D2T2	*++SP[1],B31:B30
+
+	LDDW	.D1T1	*++A15[1],A1:A0
+ ||	LDDW	.D2T2	*++SP[1],B1:B0
+
+	LDDW	.D1T1	*++A15[1],A3:A2
+ ||	LDDW	.D2T2	*++SP[1],B3:B2
+ ||	MVC	.S2	B9,__tsr
+	LDDW	.D1T1	*++A15[1],A5:A4
+ ||	LDDW	.D2T2	*++SP[1],B5:B4
+ ||	MVC	.S2	B11,RILC
+	LDDW	.D1T1	*++A15[1],A7:A6
+ ||	LDDW	.D2T2	*++SP[1],B7:B6
+ ||	MVC	.S2	B10,ILC
+
+	LDDW	.D1T1	*++A15[1],A9:A8
+ ||	LDDW	.D2T2	*++SP[1],B9:B8
+ ||	MVC	.S2	B13,__rp
+
+	LDDW	.D1T1	*++A15[1],A11:A10
+ ||	LDDW	.D2T2	*++SP[1],B11:B10
+ ||	MVC	.S2	B12,CSR
+
+	LDDW	.D1T1	*++A15[1],A13:A12
+ ||	LDDW	.D2T2	*++SP[1],B13:B12
+
+	MV	.D2X	A15,SP
+ ||	MVKL	.S1	current_ksp,A15
+	MVKH	.S1	current_ksp,A15
+ ||	ADDAW	.D1X	SP,6,A14
+	STW	.D1T1	A14,*A15	; save kernel stack pointer
+
+	LDDW	.D2T1	*++SP[1],A15:A14
+
+	B	.S2	__rp		; return from interruption
+	LDDW	.D2T2	*+SP[1],SP:DP
+	NOP	4
+	.endm
+
+_DEFINE_MACRO(RESTORE_ALL_EXCEPT)
+	RESTORE_ALL NRP,NTSR
+	.endm
+
+_DEFINE_MACRO(RESTORE_ALL_INT)
+	RESTORE_ALL IRP,ITSR
+	.endm
+
+_DEFINE_MACRO(MASK_SYSCALL)
+	.endm
+
+_DEFINE_MACRO(UNMASK_SYSCALL)
+	.endm
+
+_DEFINE_MACRO(MASK_INT,reg)
+	MVC	.S2	CSR,reg
+	CLR	.S2	reg,0,0,reg
+	MVC	.S2	reg,CSR
+	.endm
+
+	;; Enable interrupts
+_DEFINE_MACRO(UNMASK_INT,reg)
+	MVC	.S2	CSR,reg
+	SET	.S2	reg,0,0,reg
+	MVC	.S2	reg,CSR
+	.endm
+
+	;;
+	;; Call c6x_do_IRQ with the corresponding int number and regs
+	;;
+_DEFINE_MACRO(CALL_INT,int)
+#ifdef CONFIG_BIG_KERNEL
+	MVKL	.S1	c6x_do_IRQ,A0
+	MVKH	.S1	c6x_do_IRQ,A0
+	BNOP	.S2X	A0,1
+	MVK	.S1	int,A4
+	ADDAW	.D2	SP,2,B4
+	MVKL	.S2	ret_from_interrupt,B3
+	MVKH	.S2	ret_from_interrupt,B3
+#else
+	CALLP   .S2	c6x_do_IRQ,B3
+ ||	MVK	.S1	int,A4
+ ||	ADDAW	.D2	SP,2,B4
+	B	.S1	ret_from_interrupt
+	NOP	5
+#endif
+	.endm
+
+_DEFINE_MACRO(GET_THREAD_INFO,reg)
+	SHR	.S1X	SP,THREAD_SHIFT,reg
+	SHL	.S1	reg,THREAD_SHIFT,reg
+	.endm
+
+	.sect	".data"
+
+	.global	current_ksp
+current_ksp:
+	.word	init_thread_union + THREAD_START_SP
+
+	.sect	".text"
+
+	;;
+	;; Jump to schedule() then return to ret_from_exception
+	;;
+_reschedule:
+#ifdef CONFIG_BIG_KERNEL
+	MVKL	.S1	schedule,A0
+	MVKH	.S1	schedule,A0
+	B	.S2X	A0
+#else
+	B	.S1	schedule
+#endif
+	ADDKPC	.S2	ret_from_exception,B3,4
+
+	;;
+	;; Called before syscall handler when process is being debugged
+	;;
+tracesys_on:
+#ifdef CONFIG_BIG_KERNEL
+	MVKL	.S1	syscall_trace_entry,A0
+	MVKH	.S1	syscall_trace_entry,A0
+	B	.S2X	A0
+#else
+	B	.S1	syscall_trace_entry
+#endif
+	ADDKPC	.S2	ret_from_syscall_trace,B3,3
+	ADD	.S1X	8,SP,A4
+
+ret_from_syscall_trace:
+	;; tracing returns (possibly new) syscall number
+	MV	.D2X	A4,B0
+ ||	MVK	.S2	__NR_syscalls,B1
+	CMPLTU	.L2	B0,B1,B1
+
+ [!B1]	BNOP	.S2	ret_from_syscall_function,5
+ ||	MVK	.S1	-ENOSYS,A4
+
+	;; reload syscall args from (possibly modified) stack frame
+	LDW	.D2T2	*+SP(REGS_B4+8),B4
+	LDW	.D2T1	*+SP(REGS_A6+8),A6
+	LDW	.D2T2	*+SP(REGS_B6+8),B6
+	LDW	.D2T1	*+SP(REGS_A8+8),A8
+	LDW	.D2T2	*+SP(REGS_B8+8),B8
+
+	;; Get syscall handler addr from sys_call_table:
+	MVKL	.S2	sys_call_table,B1
+	MVKH	.S2	sys_call_table,B1
+	LDW	.D2T2	*+B1[B0],B0		; B0 = sys_call_table[__NR_*]
+	MVKL	.S2	ret_from_syscall_function,B3
+	MVKH	.S2	ret_from_syscall_function,B3
+	NOP	2
+	BNOP	.S2	B0,5			; branch to syscall handler
+ ||	LDW	.D2T1	*+SP(REGS_ORIG_A4+8),A4
+
+syscall_exit_work:
+	AND	.D1	_TIF_SYSCALL_TRACE,A2,A0
+ [!A0]	BNOP	.S1	work_pending,5
+ [A0]	B	.S2	syscall_trace_exit
+	ADDKPC	.S2	resume_userspace,B3,1
+	MVC	.S2	CSR,B1
+	SET	.S2	B1,0,0,B1
+	MVC	.S2	B1,CSR		; enable ints
+
+work_pending:
+	AND	.D1	_TIF_NEED_RESCHED,A2,A0
+ [!A0]	BNOP	.S1	work_notifysig,5
+
+work_resched:
+#ifdef CONFIG_BIG_KERNEL
+	MVKL	.S1	schedule,A1
+	MVKH	.S1	schedule,A1
+	B	.S2X	A1
+#else
+	B	.S2	schedule
+#endif
+	ADDKPC	.S2	work_rescheduled,B3,4
+work_rescheduled:
+	;; make sure we don't miss an interrupt setting need_resched or
+	;; sigpending between sampling and the rti
+	MASK_INT B2
+	GET_THREAD_INFO A12
+	LDW	.D1T1	*+A12(THREAD_INFO_FLAGS),A2
+	MVK	.S1	_TIF_WORK_MASK,A1
+	MVK	.S1	_TIF_NEED_RESCHED,A3
+	NOP	2
+	AND	.D1	A1,A2,A0
+ ||	AND	.S1	A3,A2,A1
+ [!A0]	BNOP	.S1	restore_all,5
+ [A1]	BNOP	.S1	work_resched,5
+
+work_notifysig:
+	B	.S2	do_notify_resume
+	LDW	.D2T1	*+SP(REGS__END+8),A6 ; syscall flag
+	ADDKPC	.S2	resume_userspace,B3,1
+	ADD	.S1X	8,SP,A4		; pt_regs pointer is first arg
+	MV	.D2X	A2,B4		; thread_info flags is second arg
+
+ret_from_exception:
+#ifdef CONFIG_PREEMPT
+	MASK_INT B2
+#endif
+	;;
+	;; On C64x+, the return way from exception and interrupt
+	;; is a little bit different
+	;;
+ret_from_interrupt:
+	;;
+	;; Check if we are comming from user mode.
+	;;
+	LDW	.D2T2	*+SP(REGS_TSR+8),B0
+	MVK	.S2	0x40,B1
+	NOP	3
+	AND	.D2	B0,B1,B0
+ [!B0]	BNOP	.S2	resume_kernel,5
+
+resume_userspace:
+	;; make sure we don't miss an interrupt setting need_resched or
+	;; sigpending between sampling and the rti
+	MASK_INT B2
+	GET_THREAD_INFO A12
+	LDW	.D1T1	*+A12(THREAD_INFO_FLAGS),A2
+	MVK	.S1	_TIF_WORK_MASK,A1
+	MVK	.S1	_TIF_NEED_RESCHED,A3
+	NOP	2
+	AND	.D1	A1,A2,A0
+ [A0]	BNOP	.S1	work_pending,5
+	BNOP	.S1	restore_all,5
+
+	;;
+	;; System call handling
+	;; B0 = syscall number (in sys_call_table)
+	;; A4,B4,A6,B6,A8,B8 = arguments of the syscall function
+	;; A4 is the return value register
+	;;
+system_call_saved:
+	MVK	.L2	1,B2
+	STW	.D2T2	B2,*+SP(REGS__END+8)	; set syscall flag
+	MVC	.S2	B2,ECR			; acknowledge the software exception
+
+	UNMASK_INT B2			; re-enable global IT
+
+system_call_saved_noack:
+	;; Check system call number
+	MVK	.S2	__NR_syscalls,B1
+#ifdef CONFIG_BIG_KERNEL
+ ||	MVKL	.S1	sys_ni_syscall,A0
+#endif
+	CMPLTU	.L2	B0,B1,B1
+#ifdef CONFIG_BIG_KERNEL
+ ||	MVKH	.S1	sys_ni_syscall,A0
+#endif
+
+	;; Check for ptrace
+	GET_THREAD_INFO A12
+
+#ifdef CONFIG_BIG_KERNEL
+ [!B1]	B	.S2X	A0
+#else
+ [!B1]	B	.S2	sys_ni_syscall
+#endif
+ [!B1]	ADDKPC	.S2	ret_from_syscall_function,B3,4
+
+	;; Get syscall handler addr from sys_call_table:
+	MVKL	.S2	sys_call_table,B1
+	MVKH	.S2	sys_call_table,B1
+	LDW	.D2T2	*+B1[B0],B0		; B0 = _sys_call_table[__NR_*]
+ ||	LDW	.D1T1	*+A12(THREAD_INFO_FLAGS),A2
+	NOP	4
+	AND	.D1	_TIF_SYSCALL_TRACE,A2,A2 ; check for TIF_SYSCALL_TRACE flag
+ [A2]	BNOP	.S1	tracesys_on,5		 ; call syscall_trace_entry before syscall function
+
+	;; Branch to the corresponding syscall
+	B	.S2	B0
+	ADDKPC	.S2	ret_from_syscall_function,B3,4
+
+ret_from_syscall_function:
+	STW	.D2T1	A4,*+SP(REGS_A4+8)	; save return value in A4
+						; original A4 is in orig_A4
+syscall_exit:
+	;; make sure we don't miss an interrupt setting need_resched or
+	;; sigpending between sampling and the rti
+	MASK_INT B2
+	LDW	.D1T1	*+A12(THREAD_INFO_FLAGS),A2
+	MVK	.S1	_TIF_ALLWORK_MASK,A1
+	NOP	3
+	AND	.D1	A1,A2,A2 ; check for work to do
+ [A2]	BNOP	.S1	syscall_exit_work,5
+
+restore_all:
+	RESTORE_ALL_EXCEPT
+
+	;;
+	;; After a fork we jump here directly from resume,
+	;; so that A4 contains the previous task structure.
+	;;
+	.global	ret_from_fork
+ret_from_fork:
+#ifdef CONFIG_BIG_KERNEL
+	MVKL	.S1	schedule_tail,A0
+	MVKH	.S1	schedule_tail,A0
+	B	.S2X	A0
+#else
+	B	.S2	schedule_tail
+#endif
+	ADDKPC	.S2	ret_from_fork_2,B3,4
+ret_from_fork_2:
+	;; return 0 in A4 for child process
+	GET_THREAD_INFO A12
+	BNOP	.S2	syscall_exit,3
+	MVK	.L2	0,B0
+	STW	.D2T2	B0,*+SP(REGS_A4+8)
+
+	;;
+	;; These are the interrupt handlers, responsible for calling __do_IRQ()
+	;; int6 is used for syscalls (see _system_call entry)
+	;;
+_int4_handler:
+	SAVE_ALL_INT
+	MASK_SYSCALL
+	CALL_INT 4
+
+_int5_handler:
+	SAVE_ALL_INT
+	MASK_SYSCALL
+	CALL_INT 5
+
+_int6_handler:
+	SAVE_ALL_INT
+	MASK_SYSCALL
+	CALL_INT 6
+
+_int7_handler:
+	SAVE_ALL_INT
+	MASK_SYSCALL
+	CALL_INT 7
+
+_int8_handler:
+	SAVE_ALL_INT
+	MASK_SYSCALL
+	CALL_INT 8
+
+_int9_handler:
+	SAVE_ALL_INT
+	MASK_SYSCALL
+	CALL_INT 9
+
+_int10_handler:
+	SAVE_ALL_INT
+	MASK_SYSCALL
+	CALL_INT 10
+
+_int11_handler:
+	SAVE_ALL_INT
+	MASK_SYSCALL
+	CALL_INT 11
+
+_int12_handler:
+	SAVE_ALL_INT
+	MASK_SYSCALL
+	CALL_INT 12
+
+_int13_handler:
+	SAVE_ALL_INT
+	MASK_SYSCALL
+	CALL_INT 13
+
+_int14_handler:
+	SAVE_ALL_INT
+	MASK_SYSCALL
+	CALL_INT 14
+
+_int15_handler:
+	SAVE_ALL_INT
+	MASK_SYSCALL
+	CALL_INT 15
+
+	;;
+	;; Handler for uninitialized and spurious interrupts
+	;;
+	.global _bad_interrupt
+_bad_interrupt:
+	B	.S2	IRP
+	NOP	5
+
+	;;
+	;; Handler for NMI (C6x) and exceptions (C64x+)
+	;;
+	.global _nmi_handler
+_nmi_handler:
+	SAVE_ALL_EXCEPT
+
+	MVC	.S2	EFR,B2
+	CMPEQ	.L2	1,B2,B2
+ ||	MVC	.S2	TSR,B1
+	CLR	.S2	B1,10,10,B1
+	MVC	.S2	B1,TSR
+#ifdef CONFIG_BIG_KERNEL
+ [!B2]	MVKL	.S1	process_exception,A0
+ [!B2]	MVKH	.S1	process_exception,A0
+ [!B2]	B	.S2X	A0
+#else
+ [!B2]	B	.S2	process_exception
+#endif
+ [B2]	B	.S2	system_call_saved
+ [!B2]	ADDAW	.D2	SP,2,B1
+ [!B2]	MV	.D1X	B1,A4
+	ADDKPC	.S2	ret_from_trap,B3,2
+
+ret_from_trap:
+	MV	.D2X	A4,B0
+ [!B0]	BNOP	.S2	ret_from_exception,5
+
+#ifdef CONFIG_BIG_KERNEL
+	MVKL	.S2	system_call_saved_noack,B3
+	MVKH	.S2	system_call_saved_noack,B3
+#endif
+
+	LDW	.D2T2	*+SP(REGS_B0+8),B0
+	LDW	.D2T1	*+SP(REGS_A4+8),A4
+	LDW	.D2T2	*+SP(REGS_B4+8),B4
+	LDW	.D2T1	*+SP(REGS_A6+8),A6
+	LDW	.D2T2	*+SP(REGS_B6+8),B6
+	LDW	.D2T1	*+SP(REGS_A8+8),A8
+#ifdef CONFIG_BIG_KERNEL
+ ||	B	.S2	B3
+#else
+ ||	B	.S2	system_call_saved_noack
+#endif
+	LDW	.D2T2	*+SP(REGS_B8+8),B8
+	NOP	4
+
+	;;
+	;; Jump to schedule() then return to ret_from_isr
+	;;
+#ifdef	CONFIG_PREEMPT
+irq_reschedule:
+#ifdef CONFIG_BIG_KERNEL
+	MVKL	.S1	schedule,A0
+	MVKH	.S1	schedule,A0
+	B	.S2X	A0
+#else
+	B	.S2	schedule
+#endif
+	ADDKPC	.S2	ret_from_interrupt,B3,4
+
+resume_kernel:
+	GET_THREAD_INFO A12
+	LDW	.D1T1	*+A12(THREAD_INFO_PREEMPT_COUNT),A1
+	NOP	4
+ [A1]	BNOP	.S2	restore_all,5
+
+preempt_schedule:
+	GET_THREAD_INFO A2
+	LDW	.D1T1	*+A2(THREAD_INFO_FLAGS),A1
+#ifdef CONFIG_BIG_KERNEL
+	MVKL	.S2	preempt_schedule_irq,B0
+	MVKH	.S2	preempt_schedule_irq,B0
+	NOP	2
+#else
+	NOP	4
+#endif
+	AND	.D1	_TIF_NEED_RESCHED,A1,A1	; check for TIF_NEED_RESCHED flag
+ [!A1]	BNOP	.S2	restore_all,5
+#ifdef CONFIG_BIG_KERNEL
+	B	.S2	B0
+#else
+	B	.S2	preempt_schedule_irq
+#endif
+	ADDKPC	.S2	preempt_schedule,B3,4
+#endif
+
+	.global enable_exception
+enable_exception:
+	DINT
+	MVC	.S2	TSR,B0
+	MVC	.S2	B3,NRP
+	MVK	.L2	0xc,B1
+	OR	.D2	B0,B1,B0
+	MVC	.S2	B0,TSR			;  Set GEE and XEN in TSR
+	B	.S2	NRP
+	NOP	5
+
+	.global sys_sigaltstack
+sys_sigaltstack:
+#ifdef CONFIG_BIG_KERNEL
+	MVKL	.S1	do_sigaltstack,A0	; branch to do_sigaltstack
+	MVKH	.S1	do_sigaltstack,A0
+	B	.S2X	A0
+#else
+	B	.S2	do_sigaltstack
+#endif
+	LDW	.D2T1	*+SP(REGS_SP+8),A6
+	NOP	4
+
+	;; kernel_execve
+	.global kernel_execve
+kernel_execve:
+	MVK	.S2	__NR_execve,B0
+	SWE
+	BNOP	.S2	B3,5
+
+	;;
+	;; Special system calls
+	;; return address is in B3
+	;;
+	.global sys_clone
+sys_clone:
+	ADD	.D1X	SP,8,A4
+#ifdef CONFIG_BIG_KERNEL
+ ||	MVKL	.S1	c6x_clone,A0
+	MVKH	.S1	c6x_clone,A0
+	BNOP	.S2X	A0,5
+#else
+ ||	B	.S2	c6x_clone
+	NOP	5
+#endif
+
+	.global sys_vfork
+sys_vfork:
+	ADD	.D1X	SP,8,A4
+#ifdef CONFIG_BIG_KERNEL
+ ||	MVKL	.S1	c6x_vfork,A0		; branch to _c6x_vfork(struct pt_regs *regs)
+	MVKH	.S1	c6x_vfork,A0
+	BNOP	.S2X	A0,5
+#else
+ ||	B	.S2	c6x_vfork
+	NOP	5
+#endif
+
+	.global sys_rt_sigreturn
+sys_rt_sigreturn:
+	ADD	.D1X	SP,8,A4
+#ifdef CONFIG_BIG_KERNEL
+ ||	MVKL	.S1	do_rt_sigreturn,A0	; branch to _do_rt_sigreturn
+	MVKH	.S1	do_rt_sigreturn,A0
+	BNOP	.S2X	A0,5
+#else
+ ||	B	.S2	do_rt_sigreturn
+	NOP	5
+#endif
+
+	.global sys_execve
+sys_execve:
+	ADDAW	.D2	SP,2,B6			; put regs addr in 4th parameter
+						; & adjust regs stack addr
+	LDW	.D2T2	*+SP(REGS_B4+8),B4
+
+	;; c6x_execve(char *name, char **argv, char **envp, struct pt_regs *regs)
+#ifdef CONFIG_BIG_KERNEL
+ ||	MVKL	.S1	c6x_execve,A0
+	MVKH	.S1	c6x_execve,A0
+	B	.S2X	A0
+#else
+ ||	B	.S2	c6x_execve
+#endif
+	STW	.D2T2	B3,*SP--[2]
+	ADDKPC	.S2	ret_from_c6x_execve,B3,3
+
+ret_from_c6x_execve:
+	LDW	.D2T2	*++SP[2],B3
+	NOP	4
+	BNOP	.S2	B3,5
+
+	.global sys_pread_c6x
+sys_pread_c6x:
+	MV	.D2X	A8,B7
+#ifdef CONFIG_BIG_KERNEL
+ ||	MVKL	.S1	sys_pread64,A0
+	MVKH	.S1	sys_pread64,A0
+	BNOP	.S2X	A0,5
+#else
+ ||	B	.S2	sys_pread64
+	NOP	5
+#endif
+
+	.global sys_pwrite_c6x
+sys_pwrite_c6x:
+	MV	.D2X	A8,B7
+#ifdef CONFIG_BIG_KERNEL
+ ||	MVKL	.S1	sys_pwrite64,A0
+	MVKH	.S1	sys_pwrite64,A0
+	BNOP	.S2X	A0,5
+#else
+ ||	B	.S2	sys_pwrite64
+	NOP	5
+#endif
+
+	.global sys_truncate64_c6x
+sys_truncate64_c6x:
+	MV	.D2X	A6,B5
+#ifdef CONFIG_BIG_KERNEL
+ ||	MVKL	.S1	sys_truncate64,A0
+	MVKH	.S1	sys_truncate64,A0
+	BNOP	.S2X	A0,5
+#else
+ ||	B	.S2	sys_truncate64
+	NOP	5
+#endif
+
+	.global sys_ftruncate64_c6x
+sys_ftruncate64_c6x:
+	MV	.D2X	A6,B5
+#ifdef CONFIG_BIG_KERNEL
+ ||	MVKL	.S1	sys_ftruncate64,A0
+	MVKH	.S1	sys_ftruncate64,A0
+	BNOP	.S2X	A0,5
+#else
+ ||	B	.S2	sys_ftruncate64
+	NOP	5
+#endif
+
+#ifdef __ARCH_WANT_SYSCALL_OFF_T
+;; On Entry
+;;   A4 - fd
+;;   B4 - offset_lo (LE), offset_hi (BE)
+;;   A6 - offset_lo (BE), offset_hi (LE)
+;;   B6 - len
+;;   A8 - advice
+	.global sys_fadvise64_c6x
+sys_fadvise64_c6x:
+#ifdef CONFIG_BIG_KERNEL
+	MVKL	.S1	sys_fadvise64,A0
+	MVKH	.S1	sys_fadvise64,A0
+	BNOP	.S2X	A0,2
+#else
+	B	.S2	sys_fadvise64
+	NOP	2
+#endif
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	MV	.L2	B4,B5
+ ||	MV	.D2X	A6,B4
+#else
+	MV	.D2X	A6,B5
+#endif
+	MV	.D1X	B6,A6
+	MV	.D2X	A8,B6
+#endif
+
+;; On Entry
+;;   A4 - fd
+;;   B4 - offset_lo (LE), offset_hi (BE)
+;;   A6 - offset_lo (BE), offset_hi (LE)
+;;   B6 - len_lo (LE), len_hi (BE)
+;;   A8 - len_lo (BE), len_hi (LE)
+;;   B8 - advice
+	.global sys_fadvise64_64_c6x
+sys_fadvise64_64_c6x:
+#ifdef CONFIG_BIG_KERNEL
+	MVKL	.S1	sys_fadvise64_64,A0
+	MVKH	.S1	sys_fadvise64_64,A0
+	BNOP	.S2X	A0,2
+#else
+	B	.S2	sys_fadvise64_64
+	NOP	2
+#endif
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	MV	.L2	B4,B5
+ ||	MV	.D2X	A6,B4
+	MV	.L1	A8,A6
+ ||	MV	.D1X	B6,A7
+#else
+	MV	.D2X	A6,B5
+	MV	.L1	A8,A7
+ ||	MV	.D1X	B6,A6
+#endif
+	MV	.L2	B8,B6
+
+;; On Entry
+;;   A4 - fd
+;;   B4 - mode
+;;   A6 - offset_hi
+;;   B6 - offset_lo
+;;   A8 - len_hi
+;;   B8 - len_lo
+	.global sys_fallocate_c6x
+sys_fallocate_c6x:
+#ifdef CONFIG_BIG_KERNEL
+	MVKL	.S1	sys_fallocate,A0
+	MVKH	.S1	sys_fallocate,A0
+	BNOP	.S2X	A0,1
+#else
+	B	.S2	sys_fallocate
+	NOP
+#endif
+	MV	.D1	A6,A7
+	MV	.D1X	B6,A6
+	MV	.D2X	A8,B7
+	MV	.D2	B8,B6
diff --git a/arch/c6x/kernel/head.S b/arch/c6x/kernel/head.S
new file mode 100644
index 0000000..af1934c
--- /dev/null
+++ b/arch/c6x/kernel/head.S
@@ -0,0 +1,127 @@
+;
+;  linux/arch/c6x/kernel/head.s
+;
+;  Port on Texas Instruments TMS320C6x architecture
+;
+;  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+;  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+;
+;  This program is free software; you can redistribute it and/or modify
+;  it under the terms of the GNU General Public License version 2 as
+;  published by the Free Software Foundation.
+;
+
+#include "tags.h"
+
+	.global	_c_int00
+_c_int00:
+	;; Save tag magic and pointer
+	MV	.S1	A4,A10
+	MV	.S2	B4,B10
+
+#ifdef CONFIG_XIP_KERNEL
+	;; Setup a temporary stack to use when calling C code to
+	;; relocate XIP data.
+	MVKL	.S2	_end,B15
+	MVKH	.S2	_end,B15
+	ADDAW	.D2     B15,4096,B15
+	AND	.D2	~7,B15,B15
+#ifdef CONFIG_BIG_KERNEL
+	MVKL	.S2	c6x_relocate_xip_data,B0
+	MVKH	.S2	c6x_relocate_xip_data,B0
+	B	.S2	B0
+	ADDKPC	.S2	_ret_from_reloc,B3,4
+_ret_from_reloc:
+#else
+	CALLP   .S2	c6x_relocate_xip_data,B3
+#endif
+#else
+	;; Set the stack pointer
+	MVKL	.S2	current_ksp,B0
+	MVKH	.S2	current_ksp,B0
+	LDW	.D2T2	*B0,B15
+	NOP	4
+	AND	.D2	~7,B15,B15
+#endif
+
+#ifdef CONFIG_MTD_UCLINUX
+#ifdef CONFIG_BIG_KERNEL
+	MVKL	.S2	c6x_mtd_early_init,B0
+	MVKH	.S2	c6x_mtd_early_init,B0
+	B	.S2	B0
+	ADDKPC	.S2	_ret_from_mtd_early_init,B3,4
+_ret_from_mtd_early_init:
+#else
+	CALLP	.S2	c6x_mtd_early_init,B3
+#endif
+#endif
+
+	;; Set global page pointer in B14
+	MVKL	.S2	__bss_start,B14
+	MVKH	.S2	__bss_start,B14
+
+	;; Clear bss area
+	MVKL	.S1	__bss_start,A4
+	MVKH	.S1	__bss_start,A4
+	MVKL	.S1	__bss_stop,A6
+	MVKH	.S1	__bss_stop,A6
+
+	CMPLTU	.L1	A4,A6,A1
+ [!A1]	B	.S1	__bss_done
+	ZERO	.L2	B4
+	SUB	.L1	A6,A4,A5
+	SHR	.S1	A5,2,A3
+	NOP	2
+
+	SUB	.L2X	A3,1,B0
+  ||	MV	.L1X	B4,A3
+
+__bss_loop:
+	STW	.D1T1	A3,*A4++
+|| [B0]	BNOP	.S1	__bss_loop,5
+|| [B0]	SUB	.L2	B0,1,B0
+
+__bss_done:
+
+	;; Clear GIE and PGIE
+	MVC	.S2	CSR,B2
+	CLR	.S2	B2,0,1,B2
+	MVC	.S2	B2,CSR
+	MVC	.S2	TSR,B2
+	CLR	.S2	B2,0,1,B2
+	MVC	.S2	B2,TSR
+	MVC	.S2	ITSR,B2
+	CLR	.S2	B2,0,1,B2
+	MVC	.S2	B2,ITSR
+	MVC	.S2	NTSR,B2
+	CLR	.S2	B2,0,1,B2
+	MVC	.S2	B2,NTSR
+
+#ifdef CONFIG_XIP_KERNEL
+	;; Set the stack pointer
+	MVKL	.S2	current_ksp,B0
+	MVKH	.S2	current_ksp,B0
+	LDW	.D2T2	*B0,B15
+	NOP	4
+	AND	.D2	~7,B15,B15
+#endif
+
+	MVKL	.S2	TAGS_MAGIC,B0
+	MVKH	.S2	TAGS_MAGIC,B0
+	CMPEQ	.L1	A10,A0,A0
+	MVKL	.S2	c6x_tags_pointer,B1
+	MVKH	.S2	c6x_tags_pointer,B1
+  [!A0] MVK	.S2	0,B10
+	STW	.D2T2	B10,*B1
+
+	;; Jump to Linux init
+#ifdef CONFIG_BIG_KERNEL
+	MVKL	.S1	start_kernel,A0
+	MVKH	.S1	start_kernel,A0
+	B	.S2X	A0
+#else
+	B	.S2	start_kernel
+#endif
+	NOP	5
+L1:	BNOP	.S2	L1,5
+
diff --git a/arch/c6x/kernel/irq.c b/arch/c6x/kernel/irq.c
new file mode 100644
index 0000000..323d119
--- /dev/null
+++ b/arch/c6x/kernel/irq.c
@@ -0,0 +1,119 @@
+/*
+ *  linux/arch/c6x/kernel/irq.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2006, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  C6x general interrupt handling code.
+ */
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/kernel_stat.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/hardirq.h>
+#include <linux/seq_file.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/io.h>
+
+#include <asm/system.h>
+#include <asm/irq.h>
+#include <asm/traps.h>
+#include <asm/page.h>
+#include <asm/hardirq.h>
+#include <asm/hardware.h>
+
+DECLARE_PER_CPU(struct kernel_stat, kstat);
+
+unsigned long irq_err_count;
+
+#ifndef hw_to_kernel_irq
+#define hw_to_kernel_irq(hw) (hw)
+#endif
+
+static void mask_core_irq(struct irq_data *data)
+{
+	BUG_ON(data->irq >= NR_SYS_IRQS);
+	and_creg(IER, ~(1 << data->irq));
+}
+
+static void unmask_core_irq(struct irq_data *data)
+{
+	BUG_ON(data->irq >= NR_SYS_IRQS);
+	or_creg(IER, 1 << data->irq);
+}
+
+static struct irq_chip core_irq_chip = {
+	.name		= "C64x+",
+	.irq_mask	= mask_core_irq,
+	.irq_unmask	= unmask_core_irq,
+};
+
+void ack_bad_irq(int irq)
+{
+	printk(KERN_ERR "IRQ: spurious interrupt %d\n", irq);
+	irq_err_count++;
+}
+
+asmlinkage void c6x_do_IRQ(unsigned int prio, struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	irq_enter();
+
+	BUG_ON(prio >= NR_SYS_IRQS);
+
+	generic_handle_irq(hw_to_kernel_irq(prio));
+
+	irq_exit();
+
+	set_irq_regs(old_regs);
+}
+
+void __init init_IRQ(void)
+{
+	int i;
+
+	/* Mask all general IRQs */
+	and_creg(IER, ~0xfff0);
+
+	for (i = 0; i < NR_SYS_IRQS; i++)
+		irq_set_chip_and_handler(i, &core_irq_chip, handle_level_irq);
+
+#ifdef CONFIG_PIC_C64XPLUS
+	init_pic_c64xplus();
+#endif
+
+	/* Clear all general IRQ flags */
+	set_creg(ICR, 0xfff0);
+}
+
+/* This is only necessary to squelch some warning about
+ * IRQs being enabled early. radix_tree_init() leaves
+ * interrupts enabled during early boot when they should
+ * be disabled. None of the individual bits in IER are
+ * enabled so we don't actually get interrupts, just the
+ * warning from init/main.c boot code.
+ */
+int __init __weak arch_early_irq_init(void)
+{
+	/* clear interrupt flags */
+	set_creg(ICR, 0xfff0);
+	local_irq_disable();
+	return 0;
+}
+
+int arch_show_interrupts(struct seq_file *p, int prec)
+{
+	seq_printf(p, "%*s: %10lu\n", prec, "Err", irq_err_count);
+	return 0;
+}
+
diff --git a/arch/c6x/kernel/module.c b/arch/c6x/kernel/module.c
new file mode 100644
index 0000000..8356f99
--- /dev/null
+++ b/arch/c6x/kernel/module.c
@@ -0,0 +1,249 @@
+/*
+ *  linux/arch/c6x/kernel/module.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2005, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Thomas Charleux (thomas.charleux@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This file handles the architecture-dependent parts of process handling.
+ */
+#include <linux/moduleloader.h>
+#include <linux/elf.h>
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/bug.h>
+#include <asm/byteorder.h>
+
+#if 0
+#define DEBUGP(fmt...) printk(KERN_INFO fmt)
+#else
+#define DEBUGP(fmt...)
+#endif
+
+void *module_alloc(unsigned long size)
+{
+	if (size == 0)
+		return NULL;
+	return vmalloc_exec(size);
+}
+
+
+/* Free memory returned from module_alloc */
+void module_free(struct module *mod, void *module_region)
+{
+	vfree(module_region);
+	/* FIXME: If module_region == mod->init_region, trim exception
+	   table entries. */
+}
+
+/*
+ * finish loading the module
+ */
+int module_finalize(const Elf_Ehdr *hdr,
+		    const Elf_Shdr *sechdrs,
+		    struct module *me)
+{
+	return 0;
+}
+
+/*
+ * finish clearing the module
+ */
+void module_arch_cleanup(struct module *mod)
+{
+	module_bug_cleanup(mod);
+}
+
+
+/* We don't need anything special. */
+int module_frob_arch_sections(Elf_Ehdr *hdr,
+			      Elf_Shdr *sechdrs,
+			      char *secstrings,
+			      struct module *mod)
+{
+	return 0;
+}
+
+static inline int fixup_pcr(u32 *ip, Elf32_Addr dest, u32 maskbits, int shift)
+{
+	u32 opcode;
+	long ep = (long)ip & ~31;
+	long delta = ((long)dest - ep) >> 2;
+	long mask = (1 << maskbits) - 1;
+
+	if ((delta >> (maskbits - 1)) == 0 ||
+	    (delta >> (maskbits - 1)) == -1) {
+		opcode = *ip;
+		opcode &= ~(mask << shift);
+		opcode |= ((delta & mask) << shift);
+		*ip = opcode;
+
+		DEBUGP("REL PCR_S%d[%p] dest[0p] opcode[%08x]\n",
+		       maskbits, ip, (void *)dest, opcode);
+
+		return 0;
+	}
+	printk(KERN_ERR "PCR_S%d reloc %p -> %p out of range!\n",
+	       maskbits, ip, (void *)dest);
+
+	return -1;
+}
+
+/*
+ * apply a REL relocation
+ */
+int apply_relocate(Elf32_Shdr *sechdrs,
+		   const char *strtab,
+		   unsigned int symindex,
+		   unsigned int relsec,
+		   struct module *me)
+{
+	Elf32_Rel *rel = (void *) sechdrs[relsec].sh_addr;
+	Elf_Sym *sym;
+	u32 *location;
+	unsigned int i;
+	Elf32_Addr v;
+	Elf_Addr offset = 0;
+
+	DEBUGP("Applying relocate section %u to %u with offset[0x%x]\n", relsec,
+	       sechdrs[relsec].sh_info, offset);
+
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
+		/* This is where to make the change */
+		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
+			+ rel[i].r_offset - offset;
+
+		/* This is the symbol it is referring to.  Note that all
+		   undefined symbols have been resolved.  */
+		sym = (Elf_Sym *)sechdrs[symindex].sh_addr
+			+ ELF32_R_SYM(rel[i].r_info);
+
+		/* this is the adjustment to be made */
+		v = sym->st_value;
+
+		switch (ELF32_R_TYPE(rel[i].r_info)) {
+		case R_C6000_ABS32:
+			DEBUGP("REL ABS32: [%p] = 0x%x\n", location, v);
+			*location = v;
+			break;
+		case R_C6000_ABS16:
+			DEBUGP("REL ABS16: [%p] = 0x%x\n", location, v);
+			*(u16 *)location = v;
+			break;
+		case R_C6000_ABS8:
+			DEBUGP("REL ABS8: [%p] = 0x%x\n", location, v);
+			*(u8 *)location = v;
+			break;
+		case R_C6000_PCR_S21:
+			if (fixup_pcr(location, v, 21, 7))
+				return -ENOEXEC;
+			break;
+		case R_C6000_PCR_S12:
+			if (fixup_pcr(location, v, 12, 16))
+				return -ENOEXEC;
+			break;
+		case R_C6000_PCR_S10:
+			if (fixup_pcr(location, v, 10, 13))
+				return -ENOEXEC;
+			break;
+		default:
+			printk(KERN_ERR "module %s: Unknown REL relocation: %u\n",
+			       me->name, ELF32_R_TYPE(rel[i].r_info));
+			return -ENOEXEC;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * apply a RELA relocation
+ */
+int apply_relocate_add(Elf32_Shdr *sechdrs,
+		       const char *strtab,
+		       unsigned int symindex,
+		       unsigned int relsec,
+		       struct module *me)
+{
+	Elf32_Rela *rel = (void *) sechdrs[relsec].sh_addr;
+	Elf_Sym *sym;
+	u32 *location, opcode;
+	unsigned int i;
+	Elf32_Addr v;
+	Elf_Addr offset = 0;
+
+	DEBUGP("Applying relocate section %u to %u with offset 0x%x\n", relsec,
+	       sechdrs[relsec].sh_info, offset);
+
+	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
+		/* This is where to make the change */
+		location = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
+			+ rel[i].r_offset - offset;
+
+		/* This is the symbol it is referring to.  Note that all
+		   undefined symbols have been resolved.  */
+		sym = (Elf_Sym *)sechdrs[symindex].sh_addr
+			+ ELF32_R_SYM(rel[i].r_info);
+
+		/* this is the adjustment to be made */
+		v = sym->st_value + rel[i].r_addend;
+
+		switch (ELF32_R_TYPE(rel[i].r_info)) {
+		case R_C6000_ABS32:
+			DEBUGP("RELA ABS32: [%p] = 0x%x\n", location, v);
+			*location = v;
+			break;
+		case R_C6000_ABS16:
+			DEBUGP("RELA ABS16: [%p] = 0x%x\n", location, v);
+			*(u16 *)location = v;
+			break;
+		case R_C6000_ABS8:
+			DEBUGP("RELA ABS8: [%p] = 0x%x\n", location, v);
+			*(u8 *)location = v;
+			break;
+		case R_C6000_ABS_L16:
+			opcode = *location;
+			opcode &= ~0x7fff80;
+			opcode |= ((v & 0xffff) << 7);
+			DEBUGP("RELA ABS_L16[%p] v[0x%x] opcode[0x%x]\n",
+			       location, v, opcode);
+			*location = opcode;
+			break;
+		case R_C6000_ABS_H16:
+			opcode = *location;
+			opcode &= ~0x7fff80;
+			opcode |= ((v >> 9) & 0x7fff80);
+			DEBUGP("RELA ABS_H16[%p] v[0x%x] opcode[0x%x]\n",
+			       location, v, opcode);
+			*location = opcode;
+			break;
+		case R_C6000_PCR_S21:
+			if (fixup_pcr(location, v, 21, 7))
+				return -ENOEXEC;
+			break;
+		case R_C6000_PCR_S12:
+			if (fixup_pcr(location, v, 12, 16))
+				return -ENOEXEC;
+			break;
+		case R_C6000_PCR_S10:
+			if (fixup_pcr(location, v, 10, 13))
+				return -ENOEXEC;
+			break;
+		default:
+			printk(KERN_ERR "module %s: Unknown RELA relocation: %u\n",
+			       me->name, ELF32_R_TYPE(rel[i].r_info));
+			return -ENOEXEC;
+		}
+	}
+
+	return 0;
+}
+
diff --git a/arch/c6x/kernel/process.c b/arch/c6x/kernel/process.c
new file mode 100644
index 0000000..3aea8b8
--- /dev/null
+++ b/arch/c6x/kernel/process.c
@@ -0,0 +1,349 @@
+/*
+ *  linux/arch/c6x/kernel/process.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2006, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This file handles the architecture-dependent parts of process handling.
+ */
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/stddef.h>
+#include <linux/unistd.h>
+#include <linux/ptrace.h>
+#include <linux/slab.h>
+#include <linux/user.h>
+#include <linux/reboot.h>
+#include <linux/init_task.h>
+#include <linux/mqueue.h>
+#include <linux/stddef.h>
+#include <linux/module.h>
+#include <linux/tick.h>
+#include <linux/sched.h>
+
+#include <asm/uaccess.h>
+#include <asm/system.h>
+#include <asm/traps.h>
+#include <asm/setup.h>
+#include <asm/pgtable.h>
+#include <asm/pm.h>
+#include <asm/string.h>
+#include <asm/syscalls.h>
+
+#include <mach/board.h>  /* for c6x_arch_idle_led() */
+
+static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
+static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
+/*
+ * Initial thread structure.
+ *
+ * We need to make sure that this is THREAD_SIZE aligned due to the
+ * way process stacks are handled. This is done by having a special
+ * "init_task" linker map entry..
+ */
+union thread_union init_thread_union __init_task_data =	{
+	INIT_THREAD_INFO(init_task)
+};
+
+/*
+ * Initial task structure.
+ *
+ * All other task structs will be allocated on slabs in fork.c
+ */
+struct task_struct init_task = INIT_TASK(init_task);
+EXPORT_SYMBOL(init_task);
+
+extern asmlinkage void ret_from_fork(void);
+
+/*
+ * power off function, if any
+ */
+void (*pm_power_off)(void);
+EXPORT_SYMBOL(pm_power_off);
+
+/*
+ * power management idle function, if any..
+ */
+void (*pm_idle)(void);
+EXPORT_SYMBOL(pm_idle);
+
+static void default_idle(void)
+{
+#if defined(CONFIG_PM)
+	pwrd_set(PWRD_PD1A);
+#endif
+#ifndef CONFIG_ARCH_SIM
+	do_idle(); /* do nothing until interrupt */
+#endif
+}
+
+/*
+ * The idle loop for C64x
+ */
+void cpu_idle(void)
+{
+	/* endless idle loop with no priority at all */
+	while (1) {
+#ifdef CONFIG_TICK_ONESHOT
+		tick_nohz_stop_sched_tick(1);
+#endif
+		while (!need_resched()) {
+			void (*idle)(void);
+
+			smp_rmb();
+			idle = pm_idle;
+			if (!idle)
+				idle = default_idle;
+			idle();
+		}
+#ifdef CONFIG_TICK_ONESHOT
+		tick_nohz_restart_sched_tick();
+#endif
+		preempt_enable_no_resched();
+		schedule();
+		preempt_disable();
+	}
+}
+
+void machine_restart(char *__unused)
+{
+	while (1)
+		;
+}
+
+void machine_halt(void)
+{
+	while (1)
+		;
+}
+
+void machine_power_off(void)
+{
+	while (1)
+		;
+}
+
+void show_regs(struct pt_regs *regs)
+{
+	printk(KERN_INFO "\n");
+	printk(KERN_INFO "PC: %08lx SP: %08lx\n",
+	       regs->pc, regs->sp);
+	printk(KERN_INFO "Status: %08lx ORIG_A4: %08lx\n",
+	       regs->csr, regs->orig_a4);
+	printk(KERN_INFO "A0: %08lx  B0: %08lx\n",
+	       regs->a0, regs->b0);
+	printk(KERN_INFO "A1: %08lx  B1: %08lx\n",
+	       regs->a1, regs->b1);
+	printk(KERN_INFO "A2: %08lx  B2: %08lx\n",
+	       regs->a2, regs->b2);
+	printk(KERN_INFO "A3: %08lx  B3: %08lx\n",
+	       regs->a3, regs->b3);
+	printk(KERN_INFO "A4: %08lx  B4: %08lx\n",
+	       regs->a4, regs->b4);
+	printk(KERN_INFO "A5: %08lx  B5: %08lx\n",
+	       regs->a5, regs->b5);
+	printk(KERN_INFO "A6: %08lx  B6: %08lx\n",
+	       regs->a6, regs->b6);
+	printk(KERN_INFO "A7: %08lx  B7: %08lx\n",
+	       regs->a7, regs->b7);
+	printk(KERN_INFO "A8: %08lx  B8: %08lx\n",
+	       regs->a8, regs->b8);
+	printk(KERN_INFO "A9: %08lx  B9: %08lx\n",
+	       regs->a9, regs->b9);
+	printk(KERN_INFO "A10: %08lx  B10: %08lx\n",
+	       regs->a10, regs->b10);
+	printk(KERN_INFO "A11: %08lx  B11: %08lx\n",
+	       regs->a11, regs->b11);
+	printk(KERN_INFO "A12: %08lx  B12: %08lx\n",
+	       regs->a12, regs->b12);
+	printk(KERN_INFO "A13: %08lx  B13: %08lx\n",
+	       regs->a13, regs->b13);
+	printk(KERN_INFO "A14: %08lx  B14: %08lx\n",
+	       regs->a14, regs->dp);
+	printk(KERN_INFO "A15: %08lx  B15: %08lx\n",
+	       regs->a15, regs->sp);
+	printk(KERN_INFO "A16: %08lx  B16: %08lx\n",
+	       regs->a16, regs->b16);
+	printk(KERN_INFO "A17: %08lx  B17: %08lx\n",
+	       regs->a17, regs->b17);
+	printk(KERN_INFO "A18: %08lx  B18: %08lx\n",
+	       regs->a18, regs->b18);
+	printk(KERN_INFO "A19: %08lx  B19: %08lx\n",
+	       regs->a19, regs->b19);
+	printk(KERN_INFO "A20: %08lx  B20: %08lx\n",
+	       regs->a20, regs->b20);
+	printk(KERN_INFO "A21: %08lx  B21: %08lx\n",
+	       regs->a21, regs->b21);
+	printk(KERN_INFO "A22: %08lx  B22: %08lx\n",
+	       regs->a22, regs->b22);
+	printk(KERN_INFO "A23: %08lx  B23: %08lx\n",
+	       regs->a23, regs->b23);
+	printk(KERN_INFO "A24: %08lx  B24: %08lx\n",
+	       regs->a24, regs->b24);
+	printk(KERN_INFO "A25: %08lx  B25: %08lx\n",
+	       regs->a25, regs->b25);
+	printk(KERN_INFO "A26: %08lx  B26: %08lx\n",
+	       regs->a26, regs->b26);
+	printk(KERN_INFO "A27: %08lx  B27: %08lx\n",
+	       regs->a27, regs->b27);
+	printk(KERN_INFO "A28: %08lx  B28: %08lx\n",
+	       regs->a28, regs->b28);
+	printk(KERN_INFO "A29: %08lx  B29: %08lx\n",
+	       regs->a29, regs->b29);
+	printk(KERN_INFO "A30: %08lx  B30: %08lx\n",
+	       regs->a30, regs->b30);
+	printk(KERN_INFO "A31: %08lx  B31: %08lx\n",
+	       regs->a31, regs->b31);
+}
+
+
+static void kernel_thread_helper(int dummy, void *arg, int (*fn)(void *))
+{
+	do_exit(fn(arg));
+}
+
+/*
+ * Create a kernel thread
+ */
+int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
+{
+	struct pt_regs regs;
+
+	/*
+	 * copy_thread sets a4 to zero (child return from fork)
+	 * so we can't just set things up to directly return to
+	 * fn.
+	 */
+	memset(&regs, 0, sizeof(regs));
+	regs.b4 = (unsigned long) arg;
+	regs.a6 = (unsigned long) fn;
+	regs.pc = (unsigned long) kernel_thread_helper;
+	local_save_flags(regs.csr);
+	regs.csr |= 1;
+	regs.tsr = 5; /* Set GEE and GIE in TSR */
+
+	/* Ok, create the new process.. */
+	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, -1, &regs, 0, NULL, NULL);
+}
+EXPORT_SYMBOL(kernel_thread);
+
+void flush_thread(void)
+{
+}
+
+void exit_thread(void)
+{
+}
+
+/*
+ * vfork syscall is deprecated but uClibc tests for _NR_vfork as a check
+ * for __libc_vfork() existence. So we provide the syscall even though
+ * __libc_vfork() actually uses the clone syscall.
+ */
+asmlinkage int c6x_vfork(struct pt_regs *regs)
+{
+	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->sp, regs, 0, NULL, NULL);
+}
+
+asmlinkage int c6x_clone(struct pt_regs *regs)
+{
+	unsigned long clone_flags;
+	unsigned long newsp;
+
+	/* syscall puts clone_flags in A4 and usp in B4 */
+	clone_flags = regs->orig_a4;
+	if (regs->b4)
+		newsp = regs->b4;
+	else
+		newsp = regs->sp;
+
+	return do_fork(clone_flags, newsp, regs, 0, (int __user *)regs->a6, (int __user *)regs->b6);
+}
+
+/*
+ * Do necessary setup to start up a newly executed thread.
+ */
+void start_thread(struct pt_regs *regs, unsigned int pc, unsigned long usp)
+{
+	/*
+	 * The binfmt loader will setup a "full" stack, but the C6X
+	 * operates an "empty" stack. So we adjust the usp so that
+	 * argc doesn't get destroyed if an interrupt is taken before
+	 * it is read from the stack.
+	 *
+	 * NB: Library startup code needs to match this.
+	 */
+	usp -= 8;
+
+	set_fs(USER_DS);
+	regs->pc  = pc;
+	regs->sp  = usp;
+	regs->tsr |= 0x40; /* set user mode */
+	current->thread.usp = usp;
+}
+
+/*
+ * Copy a new thread context in its stack.
+ */
+int copy_thread(unsigned long clone_flags, unsigned long usp,
+		unsigned long ustk_size,
+		struct task_struct *p, struct pt_regs *regs)
+{
+	struct pt_regs *childregs;
+
+	childregs = task_pt_regs(p);
+
+	*childregs = *regs;
+	childregs->a4 = 0;
+
+	if (usp == -1)
+		/* case of  __kernel_thread: we return to supervisor space */
+		childregs->sp = (unsigned long)(childregs + 1);
+	else
+		/* Otherwise use the given stack */
+		childregs->sp = usp;
+
+	/* Set usp/ksp */
+	p->thread.usp = childregs->sp;
+	/* switch_to uses stack to save/restore 14 callee-saved regs */
+	thread_saved_ksp(p) = (unsigned long)childregs - 8;
+	p->thread.pc = (unsigned int) ret_from_fork;
+	p->thread.wchan	= (unsigned long) ret_from_fork;
+	return 0;
+}
+
+/*
+ * c6x_execve() executes a new program.
+ */
+asmlinkage long c6x_execve(const char __user *name,
+			   const char __user *const __user *argv,
+			   const char __user *const __user *envp,
+			   struct pt_regs *regs)
+{
+	int error;
+	char *filename;
+
+	filename = getname(name);
+	error = PTR_ERR(filename);
+	if (IS_ERR(filename))
+		goto out;
+
+	error = do_execve(filename, argv, envp, regs);
+	putname(filename);
+out:
+	return error;
+}
+
+unsigned long get_wchan(struct task_struct *p)
+{
+	return p->thread.wchan;
+}
diff --git a/arch/c6x/kernel/ptrace.c b/arch/c6x/kernel/ptrace.c
new file mode 100644
index 0000000..fd38463
--- /dev/null
+++ b/arch/c6x/kernel/ptrace.c
@@ -0,0 +1,284 @@
+/*
+ *  linux/arch/c6x/kernel/ptrace.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2006, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  Updated for 2.6.34: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/string.h>
+#include <linux/signal.h>
+#include <linux/mm.h>
+#include <linux/errno.h>
+#include <linux/ptrace.h>
+#include <linux/user.h>
+#include <linux/timer.h>
+#include <linux/security.h>
+#include <linux/tracehook.h>
+#include <linux/uaccess.h>
+
+#include <asm/segment.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+#include <asm/system.h>
+#include <asm/atomic.h>
+#include <asm/cacheflush.h>
+
+/*
+ * does not yet catch signals sent when the child dies.
+ * in exit.c or in signal.c.
+ */
+
+/* Find the stack offset for a register */
+#define PT_REG(reg)	  ((int)&((struct pt_regs *)0)->reg)
+#define PT_REG_SIZE	  (sizeof(struct pt_regs))
+
+#ifdef _BIG_ENDIAN
+#define PT_REGPAIR(odd, even) PT_REG(odd), PT_REG(even)
+#else
+#define PT_REGPAIR(odd, even) PT_REG(even), PT_REG(odd)
+#endif
+
+/* Mapping from PT_xxx to the stack offset at which the register is
+   saved.  Notice that usp has no stack-slot and needs to be treated
+   specially (see get_reg/put_reg below). */
+
+static int regoff[] = {
+	PT_REGPAIR(tsr, orig_a4),
+	PT_REGPAIR(rilc, ilc),
+	PT_REGPAIR(pc, csr),
+
+	PT_REGPAIR(b17, b16),
+	PT_REGPAIR(b19, b18),
+	PT_REGPAIR(b21, b20),
+	PT_REGPAIR(b23, b22),
+	PT_REGPAIR(b25, b24),
+	PT_REGPAIR(b27, b26),
+	PT_REGPAIR(b29, b28),
+	PT_REGPAIR(b31, b30),
+
+	PT_REGPAIR(b1, b0),
+	PT_REGPAIR(b3, b2),
+	PT_REGPAIR(b5, b4),
+	PT_REGPAIR(b7, b6),
+	PT_REGPAIR(b9, b8),
+	PT_REGPAIR(b11, b10),
+	PT_REGPAIR(b13, b12),
+
+	PT_REGPAIR(a17, a16),
+	PT_REGPAIR(a19, a18),
+	PT_REGPAIR(a21, a20),
+	PT_REGPAIR(a23, a22),
+	PT_REGPAIR(a25, a24),
+	PT_REGPAIR(a27, a26),
+	PT_REGPAIR(a29, a28),
+	PT_REGPAIR(a31, a30),
+
+	PT_REGPAIR(a1, a0),
+	PT_REGPAIR(a3, a2),
+	PT_REGPAIR(a5, a4),
+	PT_REGPAIR(a7, a6),
+	PT_REGPAIR(a9, a8),
+	PT_REGPAIR(a11, a10),
+	PT_REGPAIR(a13, a12),
+
+	PT_REGPAIR(a15, a14),
+	PT_REGPAIR(sp, dp),
+};
+
+/*
+ * Get a register number from live pt_regs for the specified task.
+ */
+static inline long get_reg(struct task_struct *task, int regno)
+{
+	unsigned long  *addr;
+	struct pt_regs *regs = task_pt_regs(task);
+
+	if (regno < sizeof(regoff)/sizeof(regoff[0]))
+		addr = (unsigned long *) ((unsigned long) regs + regoff[regno]);
+	else
+		return 0;
+	return *addr;
+}
+
+/*
+ * Write contents of register REGNO in task TASK.
+ */
+static inline int put_reg(struct task_struct *task,
+			  int regno,
+			  unsigned long data)
+{
+	unsigned long *addr;
+	struct pt_regs *regs = task_pt_regs(task);
+
+	if (regno < sizeof(regoff)/sizeof(regoff[0]))
+		addr = (unsigned long *)((unsigned long) regs + regoff[regno]);
+	else
+		return -1;
+	*addr = data;
+	return 0;
+}
+
+static inline int read_long(struct task_struct *tsk,
+			    unsigned long addr,
+			    unsigned long *result)
+{
+	*result = *(unsigned long *)addr;
+	return 0;
+}
+
+static inline int write_long(struct task_struct *tsk,
+			     unsigned long addr,
+			     unsigned long data)
+{
+	*(unsigned long *) addr = data;
+	return 0;
+}
+
+/*
+ * Called by kernel/ptrace.c when detaching.
+ */
+void ptrace_disable(struct task_struct *child)
+{
+	/* nothing to do */
+}
+
+/*
+ * Read the word at offset "off" into the user area.  We
+ * actually access the pt_regs stored on the kernel stack.
+ */
+static int ptrace_read_user(struct task_struct *tsk, unsigned long off,
+			    unsigned long __user *ret)
+{
+	unsigned long tmp;
+	unsigned long index = off/sizeof(unsigned long);
+
+	if (off & 3)
+		return -EIO;
+
+
+	tmp = 0;
+	if (off < PT_REG_SIZE)
+		tmp = get_reg(tsk, index);
+	else
+		return -EIO;
+
+	return put_user(tmp, ret);
+}
+
+/*
+ * Perform ptrace request
+ */
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
+{
+	struct pt_regs *regs, newregs;
+	unsigned long tmp;
+	int ret = 0;
+
+	switch (request) {
+		/*
+		 * read word at location "addr" in the child process.
+		 */
+	case PTRACE_PEEKTEXT:
+	case PTRACE_PEEKDATA:
+		ret = read_long(child, addr, &tmp);
+		if (!ret)
+			ret = put_user(tmp, (unsigned long __user *) data);
+		break;
+
+		/*
+		 * read the word at location "addr" in the user registers.
+		 */
+	case PTRACE_PEEKUSR:
+		ret = ptrace_read_user(child, addr, (unsigned long __user *) data);
+		break;
+
+		/*
+		 * write the word at location addr.
+		 */
+	case PTRACE_POKETEXT:
+		ret = write_long(child, addr, data);
+		flush_icache_range(addr, addr + 4);
+		break;
+
+	case PTRACE_POKEDATA:
+		ret = write_long(child, addr, data);
+		break;
+
+		/*
+		 * write the word at location addr in the user registers.
+		 */
+	case PTRACE_POKEUSR:
+		ret = -EIO;
+		if (addr & 3 || addr < 0)
+			break;
+
+		if (addr < PT_REG_SIZE)
+			ret = put_reg(child, (int)addr >> 2, data);
+		break;
+
+		/*
+		 * get all gp regs from the child.
+		 */
+	case PTRACE_GETREGS:
+		regs = task_pt_regs(child);
+		if (copy_to_user((void __user *)data, regs,
+				 sizeof(struct pt_regs)))
+			ret = -EFAULT;
+		break;
+
+		/*
+		 * set all gp regs in the child.
+		 */
+	case PTRACE_SETREGS:
+		ret = -EFAULT;
+		if (copy_from_user(&newregs, (void __user *)data,
+				   sizeof(struct pt_regs)) == 0) {
+			regs = task_pt_regs(child);
+			*regs = newregs;
+			ret = 0;
+		}
+		break;
+
+	default:
+		ret = ptrace_request(child, request, addr, data);
+		break;
+	}
+
+	return ret;
+}
+
+/*
+ * handle tracing of system call entry
+ * - return the revised system call number or ULONG_MAX to cause ENOSYS
+ */
+asmlinkage unsigned long syscall_trace_entry(struct pt_regs *regs)
+{
+	if (tracehook_report_syscall_entry(regs))
+		/* tracing decided this syscall should not happen, so
+		 * We'll return a bogus call number to get an ENOSYS
+		 * error, but leave the original number in
+		 * regs->orig_a4
+		 */
+		return ULONG_MAX;
+
+	return regs->b0;
+}
+
+/*
+ * handle tracing of system call exit
+ */
+asmlinkage void syscall_trace_exit(struct pt_regs *regs)
+{
+	tracehook_report_syscall_exit(regs, 0);
+}
diff --git a/arch/c6x/kernel/setup.c b/arch/c6x/kernel/setup.c
new file mode 100644
index 0000000..8da373e
--- /dev/null
+++ b/arch/c6x/kernel/setup.c
@@ -0,0 +1,550 @@
+/*
+ *  linux/arch/c6x/kernel/setup.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2006, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This file handles the architecture-dependent parts of system setup
+ */
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/fs.h>
+#include <linux/fb.h>
+#include <linux/genhd.h>
+#include <linux/errno.h>
+#include <linux/console.h>
+#include <linux/string.h>
+#include <linux/delay.h>
+#include <linux/bootmem.h>
+#include <linux/seq_file.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/cache.h>
+#include <linux/pm.h>
+#include <linux/dma-mapping.h>
+
+#ifdef CONFIG_MTD_UCLINUX
+#include <linux/mtd/map.h>
+#include <linux/ext2_fs.h>
+#include <linux/cramfs_fs.h>
+#include <linux/romfs_fs.h>
+#endif
+
+#include <asm/setup.h>
+#include <asm/irq.h>
+#include <asm/hardware.h>
+#include <asm/sections.h>
+
+#include <mach/board.h>
+
+#ifdef CONFIG_BLK_DEV_INITRD
+#include <linux/initrd.h>
+#include <asm/pgtable.h>
+#endif
+
+#include "tags.h"
+
+unsigned long memory_start;
+unsigned long memory_end;
+
+static char c6x_command_line[COMMAND_LINE_SIZE];
+static const char default_command_line[COMMAND_LINE_SIZE] __section(.cmdline) =
+	CONFIG_CMDLINE;
+static const char *cpu_name, *cpu_voltage, *mmu, *fpu, *soc_rev;
+static char __cpu_rev[5], *cpu_rev;
+static size_t initrd_size = CONFIG_BLK_DEV_RAM_SIZE*1024;
+static unsigned int core_id;
+
+#if defined(CONFIG_MTD_PLATRAM) || defined(CONFIG_MTD_PLATRAM_MODULE)
+unsigned int c6x_platram_start;
+unsigned int c6x_platram_size;
+#endif
+
+#if defined(CONFIG_VGA_CONSOLE)
+struct screen_info screen_info;
+#endif
+
+/*
+ * Mach dep functions
+ */
+
+struct tag_header *c6x_tags_pointer __initdata;
+
+unsigned int ticks_per_ns_scaled;
+EXPORT_SYMBOL(ticks_per_ns_scaled);
+
+unsigned int c6x_core_freq;
+EXPORT_SYMBOL(c6x_core_freq);
+
+static void __init get_cpuinfo(void)
+{
+	unsigned cpu_id, rev_id, csr;
+	struct clk *coreclk = clk_get_sys(NULL, "core");
+	unsigned long core_khz;
+
+	if (!IS_ERR(coreclk))
+		c6x_core_freq = clk_get_rate(coreclk);
+	else {
+		printk(KERN_WARNING
+		       "Cannot find core clock frequency. Using 700MHz\n");
+		c6x_core_freq = 700000000;
+	}
+
+	core_khz = c6x_core_freq / 1000;
+
+	ticks_per_ns_scaled =
+		((uint64_t)core_khz << C6X_NDELAY_SCALE) / 1000000;
+
+	csr = get_creg(CSR);
+	cpu_id = csr >> 24;
+	rev_id = (csr >> 16) & 0xff;
+
+	mmu         = "none";
+	cpu_voltage = "unknown";
+
+	switch (cpu_id) {
+	case 0:
+		cpu_name = "C67x";
+		fpu = "yes";
+		break;
+	case 2:
+		cpu_name = "C62x";
+		fpu = "none";
+		break;
+	case 8:
+		cpu_name = "C64x";
+		fpu = "none";
+		break;
+	case 12:
+		cpu_name = "C64x";
+		fpu = "none";
+		break;
+	case 16:
+		cpu_name = "C64x+";
+		cpu_voltage = "1.2";
+		fpu = "none";
+		break;
+	default:
+		cpu_name = "unknown";
+		fpu = "none";
+	}
+
+	if (cpu_id < 16) {
+		switch (rev_id) {
+		case 0x1:
+			if (cpu_id > 8) {
+				cpu_rev = "DM640/DM641/DM642/DM643";
+				cpu_voltage = "1.2 - 1.4";
+			} else {
+				cpu_rev = "C6201";
+				cpu_voltage = "2.5";
+			}
+			break;
+		case 0x2:
+			cpu_rev = "C6201B/C6202/C6211";
+			cpu_voltage = "1.8";
+			break;
+		case 0x3:
+			cpu_rev = "C6202B/C6203/C6204/C6205";
+			cpu_voltage = "1.5";
+			break;
+		case 0x201:
+			cpu_rev = "C6701 revision 0 (early CPU)";
+			cpu_voltage = "1.8";
+			break;
+		case 0x202:
+			cpu_rev = "C6701/C6711/C6712";
+			cpu_voltage = "1.8";
+			break;
+		case 0x801:
+			cpu_rev = "C64x";
+			cpu_voltage = "1.5";
+			break;
+		default:
+			cpu_rev = "unknown";
+		}
+	} else {
+		cpu_rev = __cpu_rev;
+		snprintf(__cpu_rev, sizeof(__cpu_rev), "0x%x", cpu_id);
+	}
+
+	core_id = get_coreid();
+
+	printk(KERN_INFO "CPU%d: %s rev %s, %s volts, %uMHz\n",
+	       core_id, cpu_name, cpu_rev,
+	       cpu_voltage, c6x_core_freq / 1000000);
+#ifdef C6X_SOC_HAS_CORE_REV
+	soc_rev = arch_compute_silicon_rev(arch_get_silicon_rev());
+#else
+	soc_rev = "unknown";
+#endif
+}
+
+#ifdef CONFIG_TMS320C6X_CACHES_ON
+/*
+ * L1 and L2 caches configuration
+ */
+static void cache_init(void)
+{
+	/* Set L2 caches on the the whole L2 SRAM memory */
+	L2_cache_set_mode(L2MODE_SIZE);
+
+	/* Enable L1 */
+	L1_cache_on();
+}
+#endif /* CONFIG_TMS320C6X_CACHES_ON */
+
+static void cache_set(unsigned int start, unsigned int end)
+{
+#ifdef CONFIG_XIP_KERNEL
+	unsigned long _data_len = (unsigned long)__init_end -
+		(unsigned long)_sdata - 1;
+#endif
+
+	/* Set the whole external memory as non-cacheable */
+	disable_caching(RAM_MEMORY_START,
+			RAM_MEMORY_START + BOARD_RAM_SIZE - 1);
+	/*
+	 * Then set the external memory used by this Linux instance cacheable.
+	 * DMA coherent memory region will be set as non-cacheable later.
+	 */
+	enable_caching(CACHE_REGION_START(start),
+		       CACHE_REGION_START(end - 1));
+
+#ifdef CONFIG_XIP_KERNEL
+	/* Also for XIP, make kernel code cacheable if in RAM */
+	if (CONFIG_XIP_KERNEL_TEXT_ADDR >= RAM_MEMORY_START &&
+	    CONFIG_XIP_KERNEL_TEXT_ADDR < (RAM_MEMORY_START + BOARD_RAM_SIZE))
+		enable_caching(CACHE_REGION_START(CONFIG_XIP_KERNEL_TEXT_ADDR),
+			       CACHE_REGION_START((unsigned long)_data_lma +
+						  _data_len));
+#endif
+}
+
+#ifdef CONFIG_XIP_KERNEL
+void __init c6x_relocate_xip_data(void)
+{
+	memcpy(_sdata, _data_lma,
+	       (unsigned long)__init_end - (unsigned long)_sdata);
+}
+#endif
+
+/*
+ * Early parsing of the command line
+ */
+static int userdef __initdata;
+
+/* "mem=" parsing. */
+static int __init early_mem(char *p)
+{
+	u32 mem_size;
+
+	if (!p)
+		return -EINVAL;
+
+	mem_size = memparse(p, &p);
+	/* don't remove all of memory when handling "mem={invalid}" */
+	if (mem_size == 0)
+		return -EINVAL;
+
+	userdef = 1;
+	memory_end = PAGE_ALIGN(PAGE_OFFSET + mem_size);
+
+	return 0;
+}
+early_param("mem", early_mem);
+
+/* "memdma=" parsing. */
+static int __init early_memdma(char *p)
+{
+	if (!p)
+		return -EINVAL;
+
+	dma_memory_size = memparse(p, &p);
+	if (*p == '@')
+		dma_memory_start = memparse(p, &p);
+
+	return 0;
+}
+early_param("memdma", early_memdma);
+
+#ifdef CONFIG_BLK_DEV_INITRD
+/* "initrd=" parsing. */
+static int __init early_initrd(char *p)
+{
+	if (!p)
+		return -EINVAL;
+
+	initrd_start = memparse(p, &p);
+	if (*p == ',')
+		initrd_size = memparse(p + 1, &p);
+
+	return 0;
+}
+early_param("initrd", early_initrd);
+#endif /* CONFIG_BLK_DEV_INITRD */
+
+#if defined(CONFIG_MTD_PLATRAM) || defined(CONFIG_MTD_PLATRAM_MODULE)
+/* "platram=" parsing. */
+static int __init early_platram(char *p)
+{
+	if (!p)
+		return -EINVAL;
+
+	c6x_platram_start = memparse(p, &p);
+	if (*p == ',')
+		c6x_platram_size = memparse(p + 1, &p);
+
+	return 0;
+}
+early_param("platram", early_platram);
+#endif
+
+#ifdef CONFIG_MTD_UCLINUX
+static unsigned long get_romfs_size(void *addr)
+{
+#ifdef CONFIG_ROMFS_FS
+	if ((*((unsigned long *)addr) == ROMSB_WORD0) &&
+	    (*((unsigned long *)addr + 1) == ROMSB_WORD1))
+		return PAGE_ALIGN(be32_to_cpu(*((unsigned long *)addr + 2)));
+#endif
+
+#ifdef CONFIG_CRAMFS
+	if (*((unsigned long *)addr) == CRAMFS_MAGIC)
+		return PAGE_ALIGN(*((unsigned long *)addr + 1));
+#endif
+
+#if defined(CONFIG_EXT2_FS) || defined(CONFIG_EXT3_FS)
+	if (le16_to_cpu(*((unsigned short *)addr + 0x21c)) == EXT2_SUPER_MAGIC)
+		return PAGE_ALIGN(le32_to_cpu((*((unsigned long *)addr +
+						 0x101))) * 1024);
+#endif
+
+	return 0;
+}
+
+/*
+ * This is called just before .bss is cleared so that any MTD_UCLINUX
+ * filesystem located in bss can be moved out of the way first.
+ */
+void __init c6x_mtd_early_init(void)
+{
+	unsigned int romfs_size;
+
+	romfs_size = PAGE_ALIGN(get_romfs_size((unsigned *)&__bss_start));
+
+	/* Move ROMFS out of BSS */
+	if (romfs_size)
+		memmove(&_ebss, (int *)&__bss_start, romfs_size);
+}
+
+#endif /* CONFIG_MTD_UCLINUX */
+
+void __init setup_arch(char **cmdline_p)
+{
+	int bootmap_size;
+	struct tag_cmdline *tcmd;
+#if defined(CONFIG_MTD_UCLINUX)
+	unsigned long romfs_size;
+#endif
+
+	if (!c6x_tags_are_valid(c6x_tags_pointer))
+		c6x_tags_pointer = NULL;
+
+	/* interrupts must be masked */
+	local_irq_disable();
+
+	/*
+	 * Set the Interrupt Service Table (IST) to the beginning of the
+	 * vector table.
+	 */
+	set_ist(_vectors_start);
+
+#ifdef CONFIG_TMS320C6X_CACHES_ON
+	/* Perform caches initialization */
+	cache_init();
+#endif
+
+	/* Initialise C6x IRQs */
+	set_creg(IER, 2);
+
+	/* Set peripheral power-down */
+#ifdef CONFIG_PM
+	pwr_pdctl_set(PWR_PDCTL_ALL);
+#endif
+
+	/* Call SOC configuration function */
+	c6x_soc_setup_arch();
+
+	/* Call board configuration function */
+	c6x_board_setup_arch();
+
+	/* Get CPU info */
+	get_cpuinfo();
+
+	/* Memory management */
+	printk(KERN_INFO "Initializing kernel\n");
+
+#if defined(CONFIG_MTD_UCLINUX)
+	romfs_size = get_romfs_size(&_ebss);
+	memory_start = PAGE_ALIGN(((unsigned int) &_ebss) + romfs_size);
+
+	uclinux_ram_map.phys = (unsigned long)&_ebss;
+	uclinux_ram_map.size = romfs_size;
+#else
+	memory_start = PAGE_ALIGN((unsigned int) &_end);
+#endif
+
+	memory_end   = PAGE_ALIGN(RAM_MEMORY_START + BOARD_RAM_SIZE);
+
+	init_mm.start_code = (unsigned long) &_stext;
+	init_mm.end_code   = (unsigned long) &_etext;
+#if defined(CONFIG_MTD_UCLINUX)
+	init_mm.end_data   = (unsigned long) (((unsigned long) &_ebss) +
+					      romfs_size);
+	init_mm.brk        = (unsigned long) (((unsigned long) &_ebss) +
+					      romfs_size);
+#else
+	init_mm.end_data   = (unsigned long) &_edata;
+	init_mm.brk        = (unsigned long) &_end;
+#endif
+
+	/* Initialize command line */
+	strlcpy(c6x_command_line, default_command_line, COMMAND_LINE_SIZE);
+	*cmdline_p = c6x_command_line;
+
+	/* Let cmdline passed through tag array override CONFIG_CMDLINE */
+	tcmd = c6x_tag_find(c6x_tags_pointer, TAG_CMDLINE);
+	if (tcmd)
+		strlcpy(c6x_command_line, tcmd->cmdline, COMMAND_LINE_SIZE);
+
+	/* parse_early_param needs a boot_command_line */
+	strlcpy(boot_command_line, c6x_command_line, COMMAND_LINE_SIZE);
+
+	parse_early_param();
+
+	if (userdef)
+		printk(KERN_INFO "Physical RAM map changed by user\n");
+
+	/* Set caching of external RAM used by Linux */
+	cache_set(PAGE_OFFSET, memory_end);
+
+	/* Initialize the coherent memory */
+	coherent_mem_init();
+
+	/*
+	 * Give all the memory to the bootmap allocator,  tell it to put the
+	 * boot mem_map at the start of memory
+	 */
+	bootmap_size = init_bootmem_node(NODE_DATA(0),
+					 memory_start >> PAGE_SHIFT,
+					 PAGE_OFFSET >> PAGE_SHIFT,
+					 memory_end >> PAGE_SHIFT);
+
+	/*
+	 * Free the usable memory,  we have to make sure we do not free
+	 * the bootmem bitmap so we then reserve it after freeing it :-)
+	 */
+	free_bootmem(memory_start, memory_end - memory_start);
+	reserve_bootmem(memory_start, bootmap_size, BOOTMEM_DEFAULT);
+
+	max_low_pfn = PFN_DOWN(memory_end);
+	min_low_pfn = PFN_UP(memory_start);
+	max_mapnr = max_low_pfn - min_low_pfn;
+
+#if defined(CONFIG_MTD_PLATRAM) || defined(CONFIG_MTD_PLATRAM_MODULE)
+	if (c6x_platram_size) {
+		if (c6x_platram_start < (memory_start + bootmap_size) ||
+		    (c6x_platram_start + c6x_platram_size) > memory_end) {
+			printk(KERN_ERR "Invalid platram= argument. "
+			       "Out of range %p - %p!\n",
+			       (void *)memory_start, (void *)memory_end);
+			c6x_platram_size = 0;
+		} else
+			reserve_bootmem(c6x_platram_start, c6x_platram_size,
+					BOOTMEM_DEFAULT);
+	}
+#endif
+
+#ifdef CONFIG_BLK_DEV_INITRD
+	if (initrd_start) {
+		if (initrd_start >= memory_start &&
+		    (initrd_start + initrd_size) <= memory_end) {
+			reserve_bootmem(initrd_start, initrd_size,
+					BOOTMEM_DEFAULT);
+			initrd_end = initrd_start+initrd_size;
+		} else {
+			printk(KERN_ERR
+			       "initrd is not contained in normal memory\n"
+			       "initrd=(0x%08lx:0x%08lx) normal_mem=(%p:%p)\n"
+			       "disabling initrd\n",
+			       initrd_start, initrd_start + initrd_size,
+			       (void *)memory_start, (void *)memory_end);
+			initrd_start = 0;
+		}
+	} else
+		printk(KERN_INFO "no initrd specified\n");
+#endif
+
+	/* Get kmalloc into gear */
+	paging_init();
+
+#if defined(CONFIG_VT) && defined(CONFIG_DUMMY_CONSOLE)
+	conswitchp = &dummy_con;
+#endif
+}
+
+static int show_cpuinfo(struct seq_file *m, void *v)
+{
+	seq_printf(m,
+		   "CPU:\t\t%s\n"
+		   "Core revision:\t%s\n"
+		   "Core voltage:\t%s\n"
+		   "Core id:\t%d\n"
+		   "SoC cores:\t%d\n"
+		   "MMU:\t\t%s\n"
+		   "FPU:\t\t%s\n"
+		   "Silicon rev:\t%s\n"
+		   "Clocking:\t%uMHz\n"
+		   "BogoMips:\t%lu.%02lu\n"
+		   "Calibration:\t%lu loops\n",
+		   cpu_name, cpu_rev, cpu_voltage, core_id, CORE_NUM, mmu, fpu,
+		   soc_rev, (c6x_core_freq + 500000) / 1000000,
+		   (loops_per_jiffy/(500000/HZ)),
+		   (loops_per_jiffy/(5000/HZ))%100,
+		   loops_per_jiffy);
+
+	return 0;
+}
+
+static void *c_start(struct seq_file *m, loff_t *pos)
+{
+	return *pos < 1 ? (void *)1 : NULL;
+}
+static void *c_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	++*pos;
+	return NULL;
+}
+static void c_stop(struct seq_file *m, void *v)
+{
+}
+
+const struct seq_operations cpuinfo_op = {
+	c_start,
+	c_stop,
+	c_next,
+	show_cpuinfo
+};
+
diff --git a/arch/c6x/kernel/signal.c b/arch/c6x/kernel/signal.c
new file mode 100644
index 0000000..252c9ec
--- /dev/null
+++ b/arch/c6x/kernel/signal.c
@@ -0,0 +1,384 @@
+/*
+ *  linux/arch/c6x/kernel/signal.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2006, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  Updated for 2.6.34: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/kernel.h>
+#include <linux/signal.h>
+#include <linux/errno.h>
+#include <linux/wait.h>
+#include <linux/ptrace.h>
+#include <linux/unistd.h>
+#include <linux/stddef.h>
+#include <linux/highuid.h>
+#include <linux/personality.h>
+#include <linux/tracehook.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+
+#include <asm/setup.h>
+#include <asm/segment.h>
+#include <asm/ucontext.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
+#include <asm/traps.h>
+#include <asm/cacheflush.h>
+
+#define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
+
+/*
+ * Do a signal return, undo the signal stack.
+ */
+
+#define RETCODE_SIZE (9 << 2)	/* 9 instructions = 36 bytes */
+
+struct rt_sigframe {
+	struct siginfo __user *pinfo;
+	void __user *puc;
+	struct siginfo info;
+	struct ucontext uc;
+	unsigned long retcode[RETCODE_SIZE >> 2];
+};
+
+static int restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
+{
+	int err = 0;
+
+#define COPY(x)  (err |= __get_user(regs->x, &sc->sc_##x))
+
+	COPY(sp); COPY(a4); COPY(b4); COPY(a6); COPY(b6); COPY(a8); COPY(b8);
+	COPY(a0); COPY(a1); COPY(a2); COPY(a3); COPY(a5); COPY(a7); COPY(a9);
+	COPY(b0); COPY(b1); COPY(b2); COPY(b3); COPY(b5); COPY(b7); COPY(b9);
+
+	COPY(a16); COPY(a17); COPY(a18); COPY(a19);
+	COPY(a20); COPY(a21); COPY(a22); COPY(a23);
+	COPY(a24); COPY(a25); COPY(a26); COPY(a27);
+	COPY(a28); COPY(a29); COPY(a30); COPY(a31);
+	COPY(b16); COPY(b17); COPY(b18); COPY(b19);
+	COPY(b20); COPY(b21); COPY(b22); COPY(b23);
+	COPY(b24); COPY(b25); COPY(b26); COPY(b27);
+	COPY(b28); COPY(b29); COPY(b30); COPY(b31);
+
+	COPY(csr); COPY(pc);
+
+#undef COPY
+
+	return err;
+}
+
+asmlinkage int do_rt_sigreturn(struct pt_regs *regs)
+{
+	struct rt_sigframe __user *frame;
+	sigset_t set;
+
+	/*
+	 * Since we stacked the signal on a dword boundary,
+	 * then 'sp' should be dword aligned here.  If it's
+	 * not, then the user is trying to mess with us.
+	 */
+	if (regs->sp & 7)
+		goto badframe;
+
+	frame = (struct rt_sigframe __user *) ((unsigned long) regs->sp + 8);
+
+	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
+		goto badframe;
+	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
+		goto badframe;
+
+	sigdelsetmask(&set, ~_BLOCKABLE);
+	spin_lock_irq(&current->sighand->siglock);
+	current->blocked = set;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+
+	if (restore_sigcontext(regs, &frame->uc.uc_mcontext))
+		goto badframe;
+
+	return regs->a4;
+
+badframe:
+	force_sig(SIGSEGV, current);
+	return 0;
+}
+
+static int
+setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs,
+		 unsigned long mask)
+{
+	int err = 0;
+
+	err |= __put_user(mask, &sc->sc_mask);
+
+#define COPY(x) (err |= __put_user(regs->x, &sc->sc_##x))
+
+	COPY(sp); COPY(a4); COPY(b4); COPY(a6); COPY(b6); COPY(a8); COPY(b8);
+	COPY(a0); COPY(a1); COPY(a2); COPY(a3); COPY(a5); COPY(a7); COPY(a9);
+	COPY(b0); COPY(b1); COPY(b2); COPY(b3); COPY(b5); COPY(b7); COPY(b9);
+
+	COPY(a16); COPY(a17); COPY(a18); COPY(a19);
+	COPY(a20); COPY(a21); COPY(a22); COPY(a23);
+	COPY(a24); COPY(a25); COPY(a26); COPY(a27);
+	COPY(a28); COPY(a29); COPY(a30); COPY(a31);
+	COPY(b16); COPY(b17); COPY(b18); COPY(b19);
+	COPY(b20); COPY(b21); COPY(b22); COPY(b23);
+	COPY(b24); COPY(b25); COPY(b26); COPY(b27);
+	COPY(b28); COPY(b29); COPY(b30); COPY(b31);
+
+	COPY(csr); COPY(pc);
+
+#undef COPY
+
+	return err;
+}
+
+static inline void __user *get_sigframe(struct k_sigaction *ka,
+					struct pt_regs *regs,
+					unsigned long framesize)
+{
+	unsigned long sp = regs->sp;
+
+	/*
+	 * This is the X/Open sanctioned signal stack switching.
+	 */
+	if ((ka->sa.sa_flags & SA_ONSTACK) && sas_ss_flags(sp) == 0)
+		sp = current->sas_ss_sp + current->sas_ss_size;
+
+	/*
+	 * No matter what happens, 'sp' must be dword
+	 * aligned otherwise nasty things will happen
+	 */
+	return (void __user *)((sp - framesize) & ~7);
+}
+
+static int setup_rt_frame(int signr, struct k_sigaction *ka, siginfo_t *info,
+			   sigset_t *set, struct pt_regs *regs)
+{
+	struct rt_sigframe __user *frame;
+	unsigned long __user *retcode;
+	int err = 0;
+
+	frame = get_sigframe(ka, regs, sizeof(*frame));
+
+	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
+		goto segv_and_exit;
+
+	err |= __put_user(&frame->info, &frame->pinfo);
+	err |= __put_user(&frame->uc, &frame->puc);
+	err |= copy_siginfo_to_user(&frame->info, info);
+
+	/* Clear all the bits of the ucontext we don't use.  */
+	err |= __clear_user(&frame->uc, offsetof(struct ucontext, uc_mcontext));
+
+	err |= setup_sigcontext(&frame->uc.uc_mcontext,	regs, set->sig[0]);
+	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
+	/* Set up to return from userspace */
+	retcode = (unsigned long __user *) &frame->retcode;
+	err |= put_user(0x0000002AUL | (__NR_rt_sigreturn << 7), retcode++);
+						  /* MVK __NR_rt_sigreturn,B0 */
+	err |= put_user(0x10000000UL, retcode++); /* SWE */
+	err |= put_user(0x00006000UL, retcode++); /* NOP 4 */
+	err |= put_user(0x00006000UL, retcode++); /* NOP 4 */
+	err |= put_user(0x00006000UL, retcode++); /* NOP 4 */
+	err |= put_user(0x00006000UL, retcode++); /* NOP 4 */
+	err |= put_user(0x00006000UL, retcode++); /* NOP 4 */
+	err |= put_user(0x00006000UL, retcode++); /* NOP 4 */
+	err |= put_user(0x00006000UL, retcode++); /* NOP 4 */
+
+	if (err)
+		goto segv_and_exit;
+
+	flush_icache_range((unsigned long) &frame->retcode,
+			   (unsigned long) &frame->retcode + RETCODE_SIZE);
+
+	retcode = (unsigned long __user *) &frame->retcode;
+
+	/* Change user context to branch to signal handler */
+	regs->sp = (unsigned long) frame - 8;
+	regs->b3 = (unsigned long) retcode;
+	regs->pc = (unsigned long) ka->sa.sa_handler;
+
+	/* Give the signal number to the handler */
+	regs->a4 = signr;
+
+	/*
+	 * For realtime signals we must also set the second and third
+	 * arguments for the signal handler.
+	 *   -- Peter Maydell <pmaydell@chiark.greenend.org.uk> 2000-12-06
+	 */
+	regs->b4 = (unsigned long)&frame->info;
+	regs->a6 = (unsigned long)&frame->uc;
+
+	return 0;
+
+segv_and_exit:
+	force_sig(SIGSEGV, current);
+	return -EFAULT;
+}
+
+static inline void
+handle_restart(struct pt_regs *regs, struct k_sigaction *ka, int has_handler)
+{
+	switch (regs->a4) {
+	case -ERESTARTNOHAND:
+		if (!has_handler)
+			goto do_restart;
+		regs->a4 = -EINTR;
+		break;
+
+	case -ERESTARTSYS:
+		if (has_handler && !(ka->sa.sa_flags & SA_RESTART)) {
+			regs->a4 = -EINTR;
+			break;
+		}
+	/* fallthrough */
+	case -ERESTARTNOINTR:
+do_restart:
+		regs->a4 = regs->orig_a4;
+		regs->pc -= 4;
+		break;
+	}
+}
+
+/*
+ * handle the actual delivery of a signal to userspace
+ */
+static int handle_signal(int sig,
+			 siginfo_t *info, struct k_sigaction *ka,
+			 sigset_t *oldset, struct pt_regs *regs,
+			 int syscall)
+{
+	int ret;
+
+	/* Are we from a system call? */
+	if (syscall) {
+		/* If so, check system call restarting.. */
+		switch (regs->a4) {
+		case -ERESTART_RESTARTBLOCK:
+		case -ERESTARTNOHAND:
+			regs->a4 = -EINTR;
+			break;
+
+		case -ERESTARTSYS:
+			if (!(ka->sa.sa_flags & SA_RESTART)) {
+				regs->a4 = -EINTR;
+				break;
+			}
+
+			/* fallthrough */
+		case -ERESTARTNOINTR:
+			regs->a4 = regs->orig_a4;
+			regs->pc -= 4;
+		}
+	}
+
+	/* Set up the stack frame */
+	ret = setup_rt_frame(sig, ka, info, oldset, regs);
+	if (ret == 0) {
+		spin_lock_irq(&current->sighand->siglock);
+		sigorsets(&current->blocked, &current->blocked,
+			  &ka->sa.sa_mask);
+		if (!(ka->sa.sa_flags & SA_NODEFER))
+			sigaddset(&current->blocked, sig);
+		recalc_sigpending();
+		spin_unlock_irq(&current->sighand->siglock);
+	}
+
+	return ret;
+}
+
+/*
+ * handle a potential signal
+ */
+static void do_signal(struct pt_regs *regs, int syscall)
+{
+	struct k_sigaction ka;
+	siginfo_t info;
+	sigset_t *oldset;
+	int signr;
+
+	/* we want the common case to go fast, which is why we may in certain
+	 * cases get here from kernel mode */
+	if (!user_mode(regs))
+		return;
+
+	if (test_thread_flag(TIF_RESTORE_SIGMASK))
+		oldset = &current->saved_sigmask;
+	else
+		oldset = &current->blocked;
+
+	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
+	if (signr > 0) {
+		if (handle_signal(signr, &info, &ka, oldset,
+				  regs, syscall) == 0) {
+			/* a signal was successfully delivered; the saved
+			 * sigmask will have been stored in the signal frame,
+			 * and will be restored by sigreturn, so we can simply
+			 * clear the TIF_RESTORE_SIGMASK flag */
+			if (test_thread_flag(TIF_RESTORE_SIGMASK))
+				clear_thread_flag(TIF_RESTORE_SIGMASK);
+
+			tracehook_signal_handler(signr, &info, &ka, regs, 0);
+		}
+
+		return;
+	}
+
+	/* did we come from a system call? */
+	if (syscall) {
+		/* restart the system call - no handlers present */
+		switch (regs->a4) {
+		case -ERESTARTNOHAND:
+		case -ERESTARTSYS:
+		case -ERESTARTNOINTR:
+			regs->a4 = regs->orig_a4;
+			regs->pc -= 4;
+			break;
+
+		case -ERESTART_RESTARTBLOCK:
+			regs->a4 = regs->orig_a4;
+			regs->b0 = __NR_restart_syscall;
+			regs->pc -= 4;
+			break;
+		}
+	}
+
+	/* if there's no signal to deliver, we just put the saved sigmask
+	 * back */
+	if (test_thread_flag(TIF_RESTORE_SIGMASK)) {
+		clear_thread_flag(TIF_RESTORE_SIGMASK);
+		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
+	}
+}
+
+/*
+ * notification of userspace execution resumption
+ * - triggered by current->work.notify_resume
+ */
+asmlinkage void do_notify_resume(struct pt_regs *regs, u32 thread_info_flags,
+				 int syscall)
+{
+	/* deal with pending signal delivery */
+	if (thread_info_flags & ((1 << TIF_SIGPENDING) |
+				 (1 << TIF_RESTORE_SIGMASK)))
+		do_signal(regs, syscall);
+
+	if (thread_info_flags & (1 << TIF_NOTIFY_RESUME)) {
+		clear_thread_flag(TIF_NOTIFY_RESUME);
+		tracehook_notify_resume(regs);
+		if (current->replacement_session_keyring)
+			key_replace_session_keyring();
+	}
+}
diff --git a/arch/c6x/kernel/switch_to.S b/arch/c6x/kernel/switch_to.S
new file mode 100644
index 0000000..06a41bb
--- /dev/null
+++ b/arch/c6x/kernel/switch_to.S
@@ -0,0 +1,67 @@
+/*
+ *  Copyright (C) 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter (msalter@redhat.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <asm/asm-offsets.h>
+
+#define SP	B15
+
+	/*
+	 * void __switch_to(struct thread_info *prev,
+	 *      	    struct thread_info *next,
+	 *		    struct task_struct *tsk) ;
+	 */
+	.global __switch_to
+__switch_to:
+
+	LDDW	.D2T2	*+B4(THREAD_B15_14),B7:B6
+ ||	MV	.L2X	A4,B5	; prev
+ ||	MV	.L1X	B4,A5	; next
+ ||	MVC	.S2	RILC,B1
+
+	STW	.D2T2	B3,*+B5(THREAD_PC)
+ ||	STDW	.D1T1	A13:A12,*+A4(THREAD_A13_12)
+ ||	MVC	.S2	ILC,B0
+
+	LDW	.D2T2	*+B4(THREAD_PC),B3
+ ||	LDDW	.D1T1	*+A5(THREAD_A13_12),A13:A12
+
+	STDW	.D1T1	A11:A10,*+A4(THREAD_A11_10)
+ ||	STDW	.D2T2	B1:B0,*+B5(THREAD_RICL_ICL)
+ ||	MVKL	.S2	current_ksp,B1
+
+	STDW	.D2T2	B15:B14,*+B5(THREAD_B15_14)
+ ||	STDW	.D1T1	A15:A14,*+A4(THREAD_A15_14)
+ ||	MVKH	.S2	current_ksp,B1
+
+	;; Switch to next SP
+	MV	.S2	B7,SP
+ ||	STW	.D2T2	B7,*B1
+ ||	MV	.L2	B6,B14
+ ||	LDDW	.D1T1	*+A5(THREAD_RICL_ICL),A1:A0
+
+	STDW	.D2T2	B11:B10,*+B5(THREAD_B11_10)
+ ||	LDDW	.D1T1	*+A5(THREAD_A15_14),A15:A14
+
+	STDW	.D2T2	B13:B12,*+B5(THREAD_B13_12)
+ ||	LDDW	.D1T1	*+A5(THREAD_A11_10),A11:A10
+
+	B	.S2	B3		; return in next E1
+ ||	LDDW	.D2T2	*+B4(THREAD_B13_12),B13:B12
+
+	LDDW	.D2T2	*+B4(THREAD_B11_10),B11:B10
+	NOP
+
+	MV	.L2X	A0,B0
+ ||	MV	.S1	A6,A4
+
+	MVC	.S2	B0,ILC
+ ||	MV	.L2X	A1,B1
+
+	MVC	.S2	B1,RILC
+
diff --git a/arch/c6x/kernel/sys_c6x.c b/arch/c6x/kernel/sys_c6x.c
new file mode 100644
index 0000000..5d0ee49
--- /dev/null
+++ b/arch/c6x/kernel/sys_c6x.c
@@ -0,0 +1,111 @@
+/*
+ *  linux/arch/c6x/kernel/sys_c6x.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This file contains various random system calls that
+ *  have a non-standard calling sequence on the C6x platform.
+ */
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/sem.h>
+#include <linux/msg.h>
+#include <linux/shm.h>
+#include <linux/stat.h>
+#include <linux/slab.h>
+#include <linux/mman.h>
+#include <linux/file.h>
+#include <linux/utsname.h>
+#include <linux/module.h>
+#include <linux/syscalls.h>
+#include <linux/mtd/map.h>
+#include <linux/stringify.h>
+#include <linux/uaccess.h>
+
+#include <asm/setup.h>
+#include <asm/segment.h>
+#include <asm/traps.h>
+#include <asm/page.h>
+#include <asm/syscalls.h>
+
+#ifdef CONFIG_ACCESS_CHECK
+int _access_ok(unsigned long addr, unsigned long size)
+{
+	if (!size)
+		return 1;
+
+	if (!addr || addr > (0xffffffffUL - (size - 1)))
+		goto _bad_access;
+
+	if (segment_eq(get_fs(), KERNEL_DS))
+		return 1;
+
+	if (memory_start <= addr && (addr + size - 1) < memory_end)
+		return 1;
+
+_bad_access:
+#if 0
+	printk(KERN_CRIT "**Bad access attempt: pid[%d] addr[%p] size[0x%x]\n",
+	       current->pid, addr, size);
+#endif
+	return 0;
+}
+EXPORT_SYMBOL(_access_ok);
+#endif
+
+/* sys_cache_sync -- sync caches over given range */
+asmlinkage int sys_cache_sync(unsigned long s, unsigned long e)
+{
+	/* FIXME. Add range checks */
+
+	L1D_cache_block_writeback_invalidate(s, e);
+	L1P_cache_block_invalidate(s, e);
+
+	return 0;
+}
+
+asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
+			 unsigned long prot, unsigned long flags,
+			 unsigned long fd, off_t offset)
+{
+	if (offset & ~PAGE_MASK)
+		return -EINVAL;
+	return sys_mmap_pgoff(addr, len, prot, flags, fd, offset >> PAGE_SHIFT);
+}
+
+/* Provide the actual syscall number to call mapping. */
+#undef __SYSCALL
+#define __SYSCALL(nr, call) [nr] = (call),
+
+/*
+ * Use trampolines
+ */
+#define sys_pread64		sys_pread_c6x
+#define sys_pwrite64		sys_pwrite_c6x
+#define sys_truncate64		sys_truncate64_c6x
+#define sys_ftruncate64		sys_ftruncate64_c6x
+#define sys_fadvise64		sys_fadvise64_c6x
+#define sys_fadvise64_64	sys_fadvise64_64_c6x
+#define sys_fallocate		sys_fallocate_c6x
+
+/* Use sys_mmap_pgoff directly */
+#define sys_mmap2 sys_mmap_pgoff
+
+/*
+ * Note that we can't include <linux/unistd.h> here since the header
+ * guard will defeat us; <asm/unistd.h> checks for __SYSCALL as well.
+ */
+void *sys_call_table[__NR_syscalls] = {
+	[0 ... __NR_syscalls-1] = sys_ni_syscall,
+#include <asm/unistd.h>
+};
+
diff --git a/arch/c6x/kernel/tags.c b/arch/c6x/kernel/tags.c
new file mode 100644
index 0000000..bb1064a
--- /dev/null
+++ b/arch/c6x/kernel/tags.c
@@ -0,0 +1,98 @@
+/*
+ * tags.c
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * Author: Mark Salter <msalter@redhat.com>
+ *
+ * GPLv2 LICENSE SUMMARY
+ *
+ * Copyright (C) 2010 Texas Instruments Incorporated
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * BSD LICENSE
+ *
+ * Copyright (C) 2010 Texas Instruments Incorporated
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Texas Instruments nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+#include <linux/types.h>
+
+#include "tags.h"
+
+#define TAG_NEXT(p) \
+	((struct tag_header *)((char *)p + (((struct tag_header *)p)->size) \
+			       + sizeof(struct tag_header)))
+
+struct tag_header *c6x_tag_next(struct tag_header *atag)
+{
+	if (atag->tag == TAG_EOL)
+		return NULL;
+
+	atag = TAG_NEXT(atag);
+	if (atag->tag == TAG_EOL)
+		return NULL;
+
+	return atag;
+}
+
+void *c6x_tag_find(struct tag_header *atag, unsigned int tag)
+{
+	while (atag && atag->tag != TAG_EOL && atag->tag != tag)
+		atag = c6x_tag_next(atag);
+	if (atag && atag->tag == tag)
+		return (void *)((unsigned long)atag + sizeof(*atag));
+	return NULL;
+}
+
+int c6x_tags_are_valid(struct tag_header *atag)
+{
+	if (!atag)
+		return 0;
+
+	if (atag->tag != TAG_SOL || atag->size)
+		return 0;
+
+	return 1;
+}
+
+
diff --git a/arch/c6x/kernel/tags.h b/arch/c6x/kernel/tags.h
new file mode 100644
index 0000000..9c4496d
--- /dev/null
+++ b/arch/c6x/kernel/tags.h
@@ -0,0 +1,82 @@
+/*
+ * tags.h
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * Author: Mark Salter <msalter@redhat.com>
+ *
+ * GPLv2 LICENSE SUMMARY
+ *
+ * Copyright (C) 2010 Texas Instruments Incorporated
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * BSD LICENSE
+ *
+ * Copyright (C) 2010 Texas Instruments Incorporated
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Texas Instruments nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#define TAGS_MAGIC	0x54694265
+
+/* The list must start with an TAG_SOL */
+#define TAG_SOL		0x64000001
+
+/* The list must end with an TAG_EOL */
+#define TAG_EOL		0x64000002
+
+#define TAG_CMDLINE	0x64000003
+
+#ifndef __ASSEMBLY__
+struct tag_header {
+	unsigned int size;
+	unsigned int tag;
+};
+
+struct tag_cmdline {
+	char	cmdline[0];
+};
+
+extern int c6x_tags_are_valid(struct tag_header *atag);
+extern struct tag_header *c6x_tag_next(struct tag_header *atag);
+extern void *c6x_tag_find(struct tag_header *atag, unsigned int tag);
+#endif
diff --git a/arch/c6x/kernel/time.c b/arch/c6x/kernel/time.c
new file mode 100644
index 0000000..d969b48
--- /dev/null
+++ b/arch/c6x/kernel/time.c
@@ -0,0 +1,55 @@
+/*
+ *  linux/arch/c6x/kernel/time.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+
+#include <asm/segment.h>
+#include <linux/io.h>
+#include <asm/irq.h>
+#include <asm/timer.h>
+
+#include <linux/timex.h>
+#include <linux/profile.h>
+
+static u32 sched_clock_multiplier;
+#define SCHED_CLOCK_SHIFT 16
+
+/*
+ * scheduler clock - returns current time in nanosec units.
+ */
+u64 sched_clock(void)
+{
+	u64 tsc;
+
+	/* read the TSC value
+	 */
+	tsc = get_cycles();
+
+	return (tsc * sched_clock_multiplier) >> SCHED_CLOCK_SHIFT;
+}
+
+void time_init(void)
+{
+	sched_clock_multiplier = ((u64)NSEC_PER_SEC << SCHED_CLOCK_SHIFT) /
+		c6x_core_freq;
+
+	c6x_arch_init_clocksource();
+	c6x_arch_init_clockevents();
+}
+
diff --git a/arch/c6x/kernel/traps.c b/arch/c6x/kernel/traps.c
new file mode 100644
index 0000000..ddb78da
--- /dev/null
+++ b/arch/c6x/kernel/traps.c
@@ -0,0 +1,416 @@
+/*
+ *  linux/arch/c6x/kernel/traps.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2004, 2006, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  Sets up all exception vectors
+ */
+#include <linux/sched.h>
+#include <linux/signal.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/types.h>
+#include <linux/user.h>
+#include <linux/string.h>
+#include <linux/linkage.h>
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kallsyms.h>
+#include <linux/ptrace.h>
+#include <linux/bug.h>
+
+#include <asm/setup.h>
+#include <asm/system.h>
+#include <asm/segment.h>
+#include <asm/traps.h>
+#include <asm/pgtable.h>
+#include <linux/bitops.h>
+#include <asm/irq.h>
+
+void __init trap_init(void)
+{
+	ack_exception(EXCEPT_TYPE_NXF);
+	ack_exception(EXCEPT_TYPE_EXC);
+	ack_exception(EXCEPT_TYPE_IXF);
+	ack_exception(EXCEPT_TYPE_SXF);
+	enable_exception();
+}
+
+void dump_stack(void)
+{
+	unsigned long stack;
+
+	show_stack(current, &stack);
+}
+EXPORT_SYMBOL(dump_stack);
+
+
+void die(char *str, struct pt_regs *fp, int nr)
+{
+	console_verbose();
+	printk(KERN_ERR "%s: %08x\n", str, nr);
+	show_regs(fp);
+
+	if (*((unsigned long *) (PAGE_SIZE + (unsigned long) current))
+	    != STACK_MAGIC)
+		printk(KERN_ERR "Corrupted stack page\n");
+	printk(KERN_ERR "Process %s (pid: %d, stackpage=%08lx)\n",
+	       current->comm, current->pid, (PAGE_SIZE +
+					     (unsigned long) current));
+
+	dump_stack();
+	while (1)
+		;
+}
+
+static void die_if_kernel(char *str, struct pt_regs *fp, int nr)
+{
+	if (user_mode(fp))
+		return;
+
+	die(str, fp, nr);
+}
+
+
+/* Internal exceptions */
+static struct exception_info iexcept_table[10] = {
+	{ "Oops - instruction fetch", SIGBUS, BUS_ADRERR },
+	{ "Oops - fetch packet", SIGBUS, BUS_ADRERR },
+	{ "Oops - execute packet", SIGILL, ILL_ILLOPC },
+	{ "Oops - undefined instruction", SIGILL, ILL_ILLOPC },
+	{ "Oops - resource conflict", SIGILL, ILL_ILLOPC },
+	{ "Oops - resource access", SIGILL, ILL_PRVREG },
+	{ "Oops - privilege", SIGILL, ILL_PRVOPC },
+	{ "Oops - loops buffer", SIGILL, ILL_ILLOPC },
+	{ "Oops - software exception", SIGILL, ILL_ILLTRP },
+	{ "Oops - unknown exception", SIGILL, ILL_ILLOPC }
+};
+
+/* External exceptions */
+static struct exception_info eexcept_table[128] = {
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - external exception", SIGBUS, BUS_ADRERR },
+	{ "Oops - CPU memory protection fault", SIGSEGV, SEGV_ACCERR },
+	{ "Oops - CPU memory protection fault in L1P", SIGSEGV, SEGV_ACCERR },
+	{ "Oops - DMA memory protection fault in L1P", SIGSEGV, SEGV_ACCERR },
+	{ "Oops - CPU memory protection fault in L1D", SIGSEGV, SEGV_ACCERR },
+	{ "Oops - DMA memory protection fault in L1D", SIGSEGV, SEGV_ACCERR },
+	{ "Oops - CPU memory protection fault in L2", SIGSEGV, SEGV_ACCERR },
+	{ "Oops - DMA memory protection fault in L2", SIGSEGV, SEGV_ACCERR },
+	{ "Oops - EMC CPU memory protection fault", SIGSEGV, SEGV_ACCERR },
+	{ "Oops - EMC bus error", SIGBUS, BUS_ADRERR }
+};
+
+static void do_trap(struct exception_info *except_info, struct pt_regs *regs)
+{
+	unsigned long addr = instruction_pointer(regs);
+	siginfo_t info;
+
+	if (except_info->code != TRAP_BRKPT)
+		printk(KERN_DEBUG "TRAP: %s PC[0x%lx] signo[%d] code[%d]\n",
+		       except_info->kernel_str, regs->pc,
+		       except_info->signo, except_info->code);
+
+	die_if_kernel(except_info->kernel_str, regs, addr);
+
+	info.si_signo = except_info->signo;
+	info.si_errno = 0;
+	info.si_code  = except_info->code;
+	info.si_addr  = (void __user *)addr;
+
+	force_sig_info(except_info->signo, &info, current);
+}
+
+/*
+ * Process an internal exception (non maskable)
+ */
+static int process_iexcept(struct pt_regs *regs)
+{
+	unsigned int iexcept_report = get_iexcept();
+	unsigned int iexcept_num;
+
+	ack_exception(EXCEPT_TYPE_IXF);
+
+	printk(KERN_ERR "IEXCEPT: PC[0x%lx]\n", regs->pc);
+
+	while (iexcept_report) {
+		iexcept_num = __ffs(iexcept_report);
+		iexcept_report &= ~(1 << iexcept_num);
+		set_iexcept(iexcept_report);
+		if (*(unsigned int *)regs->pc == BKPT_OPCODE) {
+			/* This is a breakpoint */
+			struct exception_info bkpt_exception = {
+				"Oops - undefined instruction",
+				  SIGTRAP, TRAP_BRKPT
+			};
+			do_trap(&bkpt_exception, regs);
+			iexcept_report &= ~(0xFF);
+			set_iexcept(iexcept_report);
+			continue;
+		}
+
+		do_trap(&iexcept_table[iexcept_num], regs);
+	}
+	return 0;
+}
+
+/*
+ * Process an external exception (maskable)
+ */
+static void process_eexcept(struct pt_regs *regs)
+{
+	unsigned int eexcept_num;
+	unsigned int bank = 0;
+	int i;
+
+	printk(KERN_ERR "EEXCEPT: PC[0x%lx]\n", regs->pc);
+
+	for (i = 0; i <= 3; i++) {
+		while (IC_MEXPMASK[i]) {
+			__dint();
+			eexcept_num = __ffs(IC_MEXPMASK[i]);
+			IC_MEXPMASK[i] &= ~(1 << eexcept_num); /* ack the external exception */
+			__rint();
+			do_trap(&eexcept_table[eexcept_num +
+					       (bank << 5)], regs);
+		}
+		bank++;
+	}
+
+	ack_exception(EXCEPT_TYPE_EXC);
+}
+
+void (*mach_nmi_handler)(struct pt_regs *regs);
+
+/*
+ * Main exception processing
+ */
+asmlinkage int process_exception(struct pt_regs *regs)
+{
+	unsigned int type;
+	unsigned int type_num;
+	unsigned int ie_num = 9; /* default is unknown exception */
+
+	while ((type = get_except_type()) != 0) {
+		type_num = fls(type) - 1;
+
+		switch (type_num) {
+		case EXCEPT_TYPE_NXF:
+			ack_exception(EXCEPT_TYPE_NXF);
+			die("Oops - NMI detected", regs,
+			    instruction_pointer(regs));
+			break;
+
+		case EXCEPT_TYPE_IXF:
+			if (process_iexcept(regs))
+				return 1;
+			break;
+
+		case EXCEPT_TYPE_EXC:
+			process_eexcept(regs);
+			break;
+
+		case EXCEPT_TYPE_SXF:
+			ie_num = 8;
+		default:
+			ack_exception(type_num);
+			do_trap(&iexcept_table[ie_num], regs);
+			break;
+		}
+	}
+	return 0;
+}
+
+static int kstack_depth_to_print = 48;
+
+static void show_trace(unsigned long *stack, unsigned long *endstack)
+{
+	unsigned long addr;
+	int i;
+
+	printk(KERN_DEBUG "Call trace:");
+	i = 0;
+	while (stack + 1 <= endstack) {
+		addr = *stack++;
+		/*
+		 * If the address is either in the text segment of the
+		 * kernel, or in the region which contains vmalloc'ed
+		 * memory, it *may* be the address of a calling
+		 * routine; if so, print it so that someone tracing
+		 * down the cause of the crash will be able to figure
+		 * out the call path that was taken.
+		 */
+		if (__kernel_text_address(addr)) {
+#ifndef CONFIG_KALLSYMS
+			if (i % 5 == 0)
+				printk(KERN_DEBUG "\n	    ");
+#endif
+			printk(KERN_DEBUG " [<%08lx>]", addr);
+			print_symbol(" %s\n", addr);
+			i++;
+		}
+	}
+	printk(KERN_DEBUG "\n");
+}
+
+void show_stack(struct task_struct *task, unsigned long *stack)
+{
+	unsigned long *p, *endstack;
+	int i;
+
+	if (!stack) {
+		if (task && task != current)
+			/* We know this is a kernel stack,
+			   so this is the start/end */
+			stack = (unsigned long *)thread_saved_ksp(task);
+		else
+			stack = (unsigned long *)&stack;
+	}
+	endstack = (unsigned long *)(((unsigned long)stack + THREAD_SIZE - 1)
+				     & -THREAD_SIZE);
+
+	printk(KERN_DEBUG "Stack from %08lx:", (unsigned long)stack);
+	for (i = 0, p = stack; i < kstack_depth_to_print; i++) {
+		if (p + 1 > endstack)
+			break;
+		if (i % 8 == 0)
+			printk(KERN_CONT "\n	    ");
+		printk(KERN_CONT " %08lx", *p++);
+	}
+	printk(KERN_CONT "\n");
+	show_trace(stack, endstack);
+}
+
+int is_valid_bugaddr(unsigned long addr)
+{
+	return __kernel_text_address(addr);
+}
+
diff --git a/arch/c6x/kernel/vectors.S b/arch/c6x/kernel/vectors.S
new file mode 100644
index 0000000..8e65550
--- /dev/null
+++ b/arch/c6x/kernel/vectors.S
@@ -0,0 +1,81 @@
+;
+;  linux/arch/c6x/kernel/vector.s
+;
+;  Port on Texas Instruments TMS320C6x architecture
+;
+;  Copyright (C) 2004, 2006, 2009, 2010, 2011 Texas Instruments Incorporated
+;  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+;
+;  This program is free software; you can redistribute it and/or modify
+;  it under the terms of the GNU General Public License version 2 as
+;  published by the Free Software Foundation.
+;
+;  This section handles all the interrupt vector routines.
+;  At RESET the processor sets up the DRAM timing parameters and
+;  branches to the label _c_int00 which handles initialization for the C code.
+;
+
+#define ALIGNMENT 5
+
+#ifdef CONFIG_BIG_KERNEL
+	.macro IRQVEC name, handler
+	.align ALIGNMENT
+	.global \name
+\name:	STW	.D2T1	A0,*B15--[2]
+ ||	MVKL	.S1	\handler,A0
+	MVKH	.S1	\handler,A0
+	B	.S2X	A0
+	LDW	.D2T1	*++B15[2],A0
+	NOP	4
+	NOP
+	NOP
+	.endm
+#else /* CONFIG_BIG_KERNEL */
+	.macro IRQVEC name, handler
+	.align ALIGNMENT
+	.global \name
+\name:	B	.S2	\handler
+	NOP
+	NOP
+	NOP
+	NOP
+	NOP
+	NOP
+	NOP
+	.endm
+#endif /* CONFIG_BIG_KERNEL */
+
+	   .sect ".vectors","ax"
+	   .align ALIGNMENT
+#ifdef CONFIG_BIG_KERNEL
+RESET:	   MVKL	.S1	_c_int00,A0		; branch to _c_int00
+	   MVKH	.S1	_c_int00,A0
+	   B	.S2X	A0
+#else
+RESET:	   B	.S2	_c_int00
+	   NOP
+	   NOP
+#endif
+	   NOP
+	   NOP
+	   NOP
+	   NOP
+	   NOP
+
+
+	   IRQVEC NMI,_nmi_handler		; NMI interrupt
+	   IRQVEC AINT,_bad_interrupt		; reserved
+	   IRQVEC MSGINT,_bad_interrupt		; reserved
+
+	   IRQVEC INT4,_int4_handler
+	   IRQVEC INT5,_int5_handler
+	   IRQVEC INT6,_int6_handler
+	   IRQVEC INT7,_int7_handler
+	   IRQVEC INT8,_int8_handler
+	   IRQVEC INT9,_int9_handler
+	   IRQVEC INT10,_int10_handler
+	   IRQVEC INT11,_int11_handler
+	   IRQVEC INT12,_int12_handler
+	   IRQVEC INT13,_int13_handler
+	   IRQVEC INT14,_int14_handler
+	   IRQVEC INT15,_int15_handler
diff --git a/arch/c6x/kernel/vmlinux.lds.S b/arch/c6x/kernel/vmlinux.lds.S
new file mode 100644
index 0000000..10e6177
--- /dev/null
+++ b/arch/c6x/kernel/vmlinux.lds.S
@@ -0,0 +1,205 @@
+/*
+ * ld script for the c6x kernel
+ *
+ *  Copyright (C) 2010, 2011 Texas Instruments Incorporated
+ *  Mark Salter <msalter@redhat.com>
+ */
+#define __VMLINUX_LDS__
+#include <asm-generic/vmlinux.lds.h>
+#include <asm/thread_info.h>
+#include <asm/page.h>
+#include <mach/board.h>
+
+
+ENTRY(_c_int00)
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+jiffies = jiffies_64 + 4;
+#else
+jiffies = jiffies_64;
+#endif
+
+SECTIONS
+{
+#ifdef CONFIG_XIP_KERNEL
+	. = CONFIG_XIP_KERNEL_TEXT_ADDR;
+#else
+	. = PAGE_OFFSET;
+#endif
+
+	.vectors :
+	{
+		VMLINUX_SYMBOL(_vectors_start) = .;
+		*(.vectors)
+		VMLINUX_SYMBOL(_vectors_end) = .;
+	}
+
+#ifdef CONFIG_XIP_KERNEL
+	. = CONFIG_XIP_KERNEL_TEXT_ADDR + 0x400;
+#else
+	. = PAGE_OFFSET + 0x400;
+#endif
+	. = ALIGN(0x1000);
+	.cmdline : { *(.cmdline) }
+
+	/* read-only */
+	.text :
+	{
+		VMLINUX_SYMBOL(_stext) = .;
+		VMLINUX_SYMBOL(_text) = .;
+		TEXT_TEXT
+		SCHED_TEXT
+		LOCK_TEXT
+		IRQENTRY_TEXT
+		KPROBES_TEXT
+#if defined(CONFIG_XIP_KERNEL) || !defined(CONFIG_BIG_KERNEL)
+		VMLINUX_SYMBOL(_sinittext) = .;
+		INIT_TEXT
+		VMLINUX_SYMBOL(_einittext) = .;
+		EXIT_TEXT
+#endif
+		*(.fixup)
+		*(.gnu.warning)
+	}
+
+	EXCEPTION_TABLE(16)
+	NOTES
+
+	RO_DATA_SECTION(32)
+	.rodata_c6x :
+	{
+		*(.const)
+		*(.switch)
+	}
+	. = ALIGN(8);
+	.dynamic :
+	{
+		*(.dynamic)
+	}
+	. = ALIGN(128);
+	VMLINUX_SYMBOL(_rodata_end) = .;
+
+	VMLINUX_SYMBOL(_etext) = .;
+
+#ifdef CONFIG_XIP_KERNEL
+	. = PAGE_OFFSET;
+	.bss : AT(VMLINUX_SYMBOL(_rodata_end))
+#else
+	.bss :
+#endif
+	{
+		VMLINUX_SYMBOL(__bss_start) = .;
+		*(.bss .bss.*)
+		*(COMMON)
+		*(.far)
+		. = ALIGN(128);
+		VMLINUX_SYMBOL(__bss_stop) = .;
+		VMLINUX_SYMBOL(__bss_stop) = .;
+	}
+
+#ifdef CONFIG_XIP_KERNEL
+	.data : AT(LOADADDR(.bss) + SIZEOF(.bss))
+#else
+	.data :
+#endif
+	{
+		VMLINUX_SYMBOL(_sdata) = .;
+		INIT_TASK_DATA(THREAD_SIZE)
+		NOSAVE_DATA
+		PAGE_ALIGNED_DATA(PAGE_SIZE)
+		CACHELINE_ALIGNED_DATA(128)
+		READ_MOSTLY_DATA(128)
+		DATA_DATA
+		CONSTRUCTORS
+		*(.data1)
+		*(.fardata .fardata.*)
+		. = ALIGN(8);
+	}
+#ifdef CONFIG_XIP_KERNEL
+	.neardata : AT(LOADADDR(.data) + SIZEOF(.data))
+#else
+	.neardata :
+#endif
+	{
+		*(.neardata .neardata.* .gnu.linkonce.s.*)
+#ifdef CONFIG_XIP_KERNEL
+		/* The init section should be last, so when we free it, it goes into
+		 * the general memory pool, and (hopefully) will decrease fragmentation
+		 * a tiny bit. The init section has a _requirement_ that it be
+		 * PAGE_SIZE aligned
+		 */
+		. = ALIGN(PAGE_SIZE);
+#endif
+	}
+
+	VMLINUX_SYMBOL(_edata) = .;
+	VMLINUX_SYMBOL(_data_lma) = LOADADDR(.data);
+
+	VMLINUX_SYMBOL(__init_begin) = .;
+
+#ifndef CONFIG_XIP_KERNEL
+#ifdef CONFIG_BIG_KERNEL
+	INIT_TEXT_SECTION(PAGE_SIZE)
+
+	/* We have to discard exit text and such at runtime, not link time, to
+	 * handle embedded cross-section references (alt instructions, bug
+	 * table, eh_frame, etc...).  We need all of our .text up front and
+	 * .data after it for PCREL call issues.
+	 */
+	.exit.text :
+	{
+		EXIT_TEXT
+	}
+	. = ALIGN(16);
+#endif
+	INIT_DATA_SECTION(16)
+	PERCPU(128,PAGE_SIZE)
+
+	.exit.data :
+	{
+		EXIT_DATA
+	}
+#else
+	.init.data : AT(LOADADDR(.neardata) + SIZEOF(.neardata))
+	{
+		VMLINUX_SYMBOL(_sinitdata) = .;
+		INIT_DATA
+		INIT_SETUP(16)
+		INIT_CALLS
+		CON_INITCALL
+		SECURITY_INITCALL
+		INIT_RAM_FS
+		. = ALIGN(8);
+		VMLINUX_SYMBOL(__per_cpu_load) = .;
+		VMLINUX_SYMBOL(__per_cpu_start) = .;
+		*(.data.percpu.first)
+		*(.data.percpu.page_aligned)
+		*(.data.percpu)
+		*(.data.percpu.shared_aligned)
+		VMLINUX_SYMBOL(__per_cpu_end) = .;
+
+		EXIT_DATA
+
+		. = ALIGN(8);
+	}
+#endif
+	. = ALIGN(PAGE_SIZE);
+
+	VMLINUX_SYMBOL(__init_end) = .;
+
+	/*
+	 * _ebss is used solely for CONFIG_MTD_UCLINUX support.
+	 * Traditionally, _ebss (end of .bss) would be the end of a kernel
+	 * image where a ROMFS could be appended. In this case, .bss is
+	 * elsewhere but we define _ebss at the end.
+	 */
+	VMLINUX_SYMBOL(_ebss) = .;
+
+	VMLINUX_SYMBOL(_end) = . ;
+
+	STABS_DEBUG
+
+	DWARF_DEBUG
+
+	DISCARDS
+}
-- 
1.6.2.5


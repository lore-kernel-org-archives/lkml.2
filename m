Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab2ECJHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:07:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:49932 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab2ECJC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:02:56 -0400
Message-Id: <20120503085034.816195285@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:02:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch V2 15/31] m68k: Use generic init_task
References: <20120503083859.991965503@linutronix.de>
Content-Disposition: inline; filename=m68k-use-generic-init-task.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig            |    1 +
 arch/m68k/kernel/Makefile    |    2 +-
 arch/m68k/kernel/init_task.c |   35 -----------------------------------
 3 files changed, 2 insertions(+), 36 deletions(-)

Index: tip/arch/m68k/Kconfig
===================================================================
--- tip.orig/arch/m68k/Kconfig
+++ tip/arch/m68k/Kconfig
@@ -8,6 +8,7 @@ config M68K
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select GENERIC_CPU_DEVICES
 	select FPU if MMU
+	select HAVE_GENERIC_INIT_TASK
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
Index: tip/arch/m68k/kernel/Makefile
===================================================================
--- tip.orig/arch/m68k/kernel/Makefile
+++ tip/arch/m68k/kernel/Makefile
@@ -13,7 +13,7 @@ extra-$(CONFIG_SUN3X)	:= head.o
 extra-$(CONFIG_SUN3)	:= sun3-head.o
 extra-y			+= vmlinux.lds
 
-obj-y	:= entry.o init_task.o irq.o m68k_ksyms.o module.o process.o ptrace.o
+obj-y	:= entry.o irq.o m68k_ksyms.o module.o process.o ptrace.o
 obj-y	+= setup.o signal.o sys_m68k.o syscalltable.o time.o traps.o
 
 obj-$(CONFIG_MMU_MOTOROLA) += ints.o vectors.o
Index: tip/arch/m68k/kernel/init_task.c
===================================================================
--- tip.orig/arch/m68k/kernel/init_task.c
+++ /dev/null
@@ -1,35 +0,0 @@
-/*
- *  linux/arch/m68knommu/kernel/init_task.c
- */
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/init_task.h>
-#include <linux/fs.h>
-#include <linux/mqueue.h>
-
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-/*
- * Initial task structure.
- *
- * All other task structs will be allocated on slabs in fork.c
- */
-struct task_struct init_task = INIT_TASK(init_task);
-
-EXPORT_SYMBOL(init_task);
-
-/*
- * Initial thread structure.
- *
- * We need to make sure that this is THREAD size aligned due to the
- * way process stacks are handled. This is done by having a special
- * "init_task" linker map entry..
- */
-union thread_union init_thread_union __init_task_data =
-	{ INIT_THREAD_INFO(init_task) };
-



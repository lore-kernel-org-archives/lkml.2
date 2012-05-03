Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2ECJDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:03:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:49991 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab2ECJDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:03:02 -0400
Message-Id: <20120503085035.804059531@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:03:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Zankel <chris@zankel.net>
Subject: [patch V2 30/31] xtensa: Use generic init_task
References: <20120503083859.991965503@linutronix.de>
Content-Disposition: inline; filename=xtensa-use-generic-init-task.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/Kconfig            |    1 +
 arch/xtensa/kernel/Makefile    |    2 +-
 arch/xtensa/kernel/init_task.c |   31 -------------------------------
 3 files changed, 2 insertions(+), 32 deletions(-)

Index: tip/arch/xtensa/Kconfig
===================================================================
--- tip.orig/arch/xtensa/Kconfig
+++ tip/arch/xtensa/Kconfig
@@ -10,6 +10,7 @@ config XTENSA
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
+	select HAVE_GENERIC_INIT_TASK
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
Index: tip/arch/xtensa/kernel/Makefile
===================================================================
--- tip.orig/arch/xtensa/kernel/Makefile
+++ tip/arch/xtensa/kernel/Makefile
@@ -6,7 +6,7 @@ extra-y := head.o vmlinux.lds
 
 obj-y := align.o entry.o irq.o coprocessor.o process.o ptrace.o \
 	 setup.o signal.o syscall.o time.o traps.o vectors.o platform.o  \
-	 pci-dma.o init_task.o io.o
+	 pci-dma.o io.o
 
 obj-$(CONFIG_KGDB) += xtensa-stub.o
 obj-$(CONFIG_PCI) += pci.o
Index: tip/arch/xtensa/kernel/init_task.c
===================================================================
--- tip.orig/arch/xtensa/kernel/init_task.c
+++ /dev/null
@@ -1,31 +0,0 @@
-/*
- * arch/xtensa/kernel/init_task.c
- *
- * Xtensa Processor version.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2007 Tensilica Inc.
- *
- * Chris Zankel <chris@zankel.net>
- */
-
-#include <linux/mm.h>
-#include <linux/fs.h>
-#include <linux/init.h>
-#include <linux/init_task.h>
-#include <linux/module.h>
-#include <linux/mqueue.h>
-
-#include <asm/uaccess.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-union thread_union init_thread_union __init_task_data =
-	{ INIT_THREAD_INFO(init_task) };
-
-struct task_struct init_task = INIT_TASK(init_task);
-
-EXPORT_SYMBOL(init_task);



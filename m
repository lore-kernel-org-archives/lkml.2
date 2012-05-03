Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab2ECJHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:07:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:49936 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247Ab2ECJC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:02:56 -0400
Message-Id: <20120503085034.881532838@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:02:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michal Simek <monstr@monstr.eu>
Subject: [patch V2 16/31] microblaze: Use generic init_task
References: <20120503083859.991965503@linutronix.de>
Content-Disposition: inline; filename=microblaze-use-generic-init-task.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/Kconfig            |    1 +
 arch/microblaze/kernel/Makefile    |    2 +-
 arch/microblaze/kernel/init_task.c |   26 --------------------------
 3 files changed, 2 insertions(+), 27 deletions(-)

Index: tip/arch/microblaze/Kconfig
===================================================================
--- tip.orig/arch/microblaze/Kconfig
+++ tip/arch/microblaze/Kconfig
@@ -22,6 +22,7 @@ config MICROBLAZE
 	select GENERIC_PCI_IOMAP
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
+	select HAVE_GENERIC_INIT_TASK
 
 config SWAP
 	def_bool n
Index: tip/arch/microblaze/kernel/Makefile
===================================================================
--- tip.orig/arch/microblaze/kernel/Makefile
+++ tip/arch/microblaze/kernel/Makefile
@@ -16,7 +16,7 @@ endif
 extra-y := head.o vmlinux.lds
 
 obj-y += dma.o exceptions.o \
-	hw_exception_handler.o init_task.o intc.o irq.o \
+	hw_exception_handler.o intc.o irq.o \
 	process.o prom.o prom_parse.o ptrace.o \
 	reset.o setup.o signal.o sys_microblaze.o timer.o traps.o unwind.o
 
Index: tip/arch/microblaze/kernel/init_task.c
===================================================================
--- tip.orig/arch/microblaze/kernel/init_task.c
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
- * Copyright (C) 2009 Michal Simek <monstr@monstr.eu>
- * Copyright (C) 2009 PetaLogix
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/init_task.h>
-#include <linux/fs.h>
-#include <linux/mqueue.h>
-
-#include <asm/pgtable.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-
-union thread_union init_thread_union __init_task_data =
-	{ INIT_THREAD_INFO(init_task) };
-
-struct task_struct init_task = INIT_TASK(init_task);
-EXPORT_SYMBOL(init_task);



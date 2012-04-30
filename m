Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab2D3UW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:22:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:35712 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793Ab2D3UPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:15:55 -0400
Message-Id: <20120430194845.793312898@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 30 Apr 2012 20:15:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: [patch 04/29] avr32: Use generic init_task
References: <20120430194725.763322463@linutronix.de>
Content-Disposition: inline; filename=avr32-use-generic-init-task.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
---
 arch/avr32/Kconfig            |    1 +
 arch/avr32/kernel/Makefile    |    2 +-
 arch/avr32/kernel/init_task.c |   31 -------------------------------
 3 files changed, 2 insertions(+), 32 deletions(-)

Index: tip/arch/avr32/Kconfig
===================================================================
--- tip.orig/arch/avr32/Kconfig
+++ tip/arch/avr32/Kconfig
@@ -12,6 +12,7 @@ config AVR32
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select HAVE_GENERIC_INIT_TASK
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
Index: tip/arch/avr32/kernel/Makefile
===================================================================
--- tip.orig/arch/avr32/kernel/Makefile
+++ tip/arch/avr32/kernel/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_SUBARCH_AVR32B)	+= entry-av
 obj-y				+= syscall_table.o syscall-stubs.o irq.o
 obj-y				+= setup.o traps.o ocd.o ptrace.o
 obj-y				+= signal.o sys_avr32.o process.o time.o
-obj-y				+= init_task.o switch_to.o cpu.o
+obj-y				+= switch_to.o cpu.o
 obj-$(CONFIG_MODULES)		+= module.o avr32_ksyms.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
Index: tip/arch/avr32/kernel/init_task.c
===================================================================
--- tip.orig/arch/avr32/kernel/init_task.c
+++ /dev/null
@@ -1,31 +0,0 @@
-/*
- * Copyright (C) 2004-2006 Atmel Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#include <linux/module.h>
-#include <linux/fs.h>
-#include <linux/sched.h>
-#include <linux/init_task.h>
-#include <linux/mqueue.h>
-
-#include <asm/pgtable.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-/*
- * Initial thread structure. Must be aligned on an 8192-byte boundary.
- */
-union thread_union init_thread_union __init_task_data =
-	{ INIT_THREAD_INFO(init_task) };
-
-/*
- * Initial task structure.
- *
- * All other task structs will be allocated on slabs in fork.c
- */
-struct task_struct init_task = INIT_TASK(init_task);
-
-EXPORT_SYMBOL(init_task);



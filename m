Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab2ECJGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:06:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:49944 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285Ab2ECJC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:02:57 -0400
Message-Id: <20120503085035.011270394@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:02:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch V2 18/31] mn10300: Use generic init_task
References: <20120503083859.991965503@linutronix.de>
Content-Disposition: inline; filename=mn10300-use-generic-init-task.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same code. Use the generic version. The special Makefile treatment is
pointless anyway as init_task.o contains only data which is handled by
the linker script. So no point on being treated like head text.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
---
 arch/mn10300/Kconfig            |    1 +
 arch/mn10300/Makefile           |    2 +-
 arch/mn10300/kernel/Makefile    |    2 +-
 arch/mn10300/kernel/init_task.c |   39 ---------------------------------------
 4 files changed, 3 insertions(+), 41 deletions(-)

Index: tip/arch/mn10300/Kconfig
===================================================================
--- tip.orig/arch/mn10300/Kconfig
+++ tip/arch/mn10300/Kconfig
@@ -6,6 +6,7 @@ config MN10300
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_KGDB
 	select HAVE_NMI_WATCHDOG if MN10300_WD_TIMER
+	select HAVE_GENERIC_INIT_TASK
 
 config AM33_2
 	def_bool n
Index: tip/arch/mn10300/Makefile
===================================================================
--- tip.orig/arch/mn10300/Makefile
+++ tip/arch/mn10300/Makefile
@@ -51,7 +51,7 @@ UNIT		:= asb2364
 endif
 
 
-head-y		:= arch/mn10300/kernel/head.o arch/mn10300/kernel/init_task.o
+head-y		:= arch/mn10300/kernel/head.o
 
 core-y		+= arch/mn10300/kernel/ arch/mn10300/mm/
 
Index: tip/arch/mn10300/kernel/Makefile
===================================================================
--- tip.orig/arch/mn10300/kernel/Makefile
+++ tip/arch/mn10300/kernel/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for the MN10300-specific core kernel code
 #
-extra-y := head.o init_task.o vmlinux.lds
+extra-y := head.o vmlinux.lds
 
 fpu-obj-y := fpu-nofpu.o fpu-nofpu-low.o
 fpu-obj-$(CONFIG_FPU) := fpu.o fpu-low.o
Index: tip/arch/mn10300/kernel/init_task.c
===================================================================
--- tip.orig/arch/mn10300/kernel/init_task.c
+++ /dev/null
@@ -1,39 +0,0 @@
-/* MN10300 Initial task definitions
- *
- * Copyright (C) 2007 Matsushita Electric Industrial Co., Ltd.
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/init_task.h>
-#include <linux/fs.h>
-#include <linux/mqueue.h>
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-/*
- * Initial thread structure.
- *
- * We need to make sure that this is THREAD_SIZE aligned due to the
- * way process stacks are handled. This is done by having a special
- * "init_task" linker map entry..
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
-EXPORT_SYMBOL(init_task);



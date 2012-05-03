Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab2ECJJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:09:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:49914 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab2ECJCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:02:53 -0400
Message-Id: <20120503085034.475552133@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:02:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [patch V2 10/31] cris: Use generic init_task
References: <20120503083859.991965503@linutronix.de>
Content-Disposition: inline; filename=cris-use-generic-idle-task.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/Kconfig          |    1 +
 arch/cris/kernel/process.c |   28 ----------------------------
 2 files changed, 1 insertion(+), 28 deletions(-)

Index: tip/arch/cris/Kconfig
===================================================================
--- tip.orig/arch/cris/Kconfig
+++ tip/arch/cris/Kconfig
@@ -50,6 +50,7 @@ config CRIS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD if ETRAX_ARCH_V32
+	select HAVE_GENERIC_INIT_TASK
 
 config HZ
 	int
Index: tip/arch/cris/kernel/process.c
===================================================================
--- tip.orig/arch/cris/kernel/process.c
+++ tip/arch/cris/kernel/process.c
@@ -29,34 +29,6 @@
 //#define DEBUG
 
 /*
- * Initial task structure. Make this a per-architecture thing,
- * because different architectures tend to have different
- * alignment requirements and potentially different initial
- * setup.
- */
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-/*
- * Initial thread structure.
- *
- * We need to make sure that this is 8192-byte aligned due to the
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
-
-EXPORT_SYMBOL(init_task);
-
-/*
  * The hlt_counter, disable_hlt and enable_hlt is just here as a hook if
  * there would ever be a halt sequence (for power save when idle) with
  * some largish delay when halting or resuming *and* a driver that can't



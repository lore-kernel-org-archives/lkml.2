Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab2ECJKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:10:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:49892 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903Ab2ECJCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:02:51 -0400
Message-Id: <20120503085034.162634519@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:02:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Matt Turner <mattst88@gmail.com>
Subject: [patch V2 05/31] alpha: Use generic init_task
References: <20120503083859.991965503@linutronix.de>
Content-Disposition: inline; filename=alpha-use-generic-init-task.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Identical code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/Kconfig            |    1 +
 arch/alpha/kernel/Makefile    |    2 +-
 arch/alpha/kernel/init_task.c |   17 -----------------
 3 files changed, 2 insertions(+), 18 deletions(-)

Index: tip/arch/alpha/Kconfig
===================================================================
--- tip.orig/arch/alpha/Kconfig
+++ tip/arch/alpha/Kconfig
@@ -16,6 +16,7 @@ config ALPHA
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
Index: tip/arch/alpha/kernel/Makefile
===================================================================
--- tip.orig/arch/alpha/kernel/Makefile
+++ tip/arch/alpha/kernel/Makefile
@@ -6,7 +6,7 @@ extra-y		:= head.o vmlinux.lds
 asflags-y	:= $(KBUILD_CFLAGS)
 ccflags-y	:= -Wno-sign-compare
 
-obj-y    := entry.o traps.o process.o init_task.o osf_sys.o irq.o \
+obj-y    := entry.o traps.o process.o osf_sys.o irq.o \
 	    irq_alpha.o signal.o setup.o ptrace.o time.o \
 	    alpha_ksyms.o systbls.o err_common.o io.o
 
Index: tip/arch/alpha/kernel/init_task.c
===================================================================
--- tip.orig/arch/alpha/kernel/init_task.c
+++ /dev/null
@@ -1,17 +0,0 @@
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/init_task.h>
-#include <linux/fs.h>
-#include <linux/mqueue.h>
-#include <asm/uaccess.h>
-
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct task_struct init_task = INIT_TASK(init_task);
-EXPORT_SYMBOL(init_task);
-
-union thread_union init_thread_union __init_task_data =
-	{ INIT_THREAD_INFO(init_task) };



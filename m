Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab2ECJEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:04:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:49971 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab2ECJDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:03:00 -0400
Message-Id: <20120503085035.332320547@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:02:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Subject: [patch V2 23/31] score: Use generic init_task
References: <20120503083859.991965503@linutronix.de>
Content-Disposition: inline; filename=score-use-generic-init-task.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/Kconfig            |    1 
 arch/score/kernel/Makefile    |    2 -
 arch/score/kernel/init_task.c |   46 ------------------------------------------
 3 files changed, 2 insertions(+), 47 deletions(-)

Index: tip/arch/score/Kconfig
===================================================================
--- tip.orig/arch/score/Kconfig
+++ tip/arch/score/Kconfig
@@ -9,6 +9,7 @@ config SCORE
        select HAVE_MEMBLOCK_NODE_MAP
        select ARCH_DISCARD_MEMBLOCK
        select GENERIC_CPU_DEVICES
+       select HAVE_GENERIC_INIT_TASK
 
 choice
 	prompt "System type"
Index: tip/arch/score/kernel/Makefile
===================================================================
--- tip.orig/arch/score/kernel/Makefile
+++ tip/arch/score/kernel/Makefile
@@ -4,7 +4,7 @@
 
 extra-y	:= head.o vmlinux.lds
 
-obj-y += entry.o init_task.o irq.o process.o ptrace.o \
+obj-y += entry.o irq.o process.o ptrace.o \
 	setup.o signal.o sys_score.o time.o traps.o \
 	sys_call_table.o
 
Index: tip/arch/score/kernel/init_task.c
===================================================================
--- tip.orig/arch/score/kernel/init_task.c
+++ /dev/null
@@ -1,46 +0,0 @@
-/*
- * arch/score/kernel/init_task.c
- *
- * Score Processor version.
- *
- * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see the file COPYING, or write
- * to the Free Software Foundation, Inc.,
- * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-#include <linux/init_task.h>
-#include <linux/mqueue.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-
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



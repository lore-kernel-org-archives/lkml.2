Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab2D3UQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:16:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:35792 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab2D3UQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:16:04 -0400
Message-Id: <20120430194846.989528598@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 30 Apr 2012 20:16:03 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [patch 23/29] sparc: Use generic init_task
References: <20120430194725.763322463@linutronix.de>
Content-Disposition: inline; filename=sparc-use-generic-init-task.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
---
 arch/sparc/Kconfig            |    1 +
 arch/sparc/kernel/init_task.c |   22 ----------------------
 2 files changed, 1 insertion(+), 22 deletions(-)

Index: tip/arch/sparc/Kconfig
===================================================================
--- tip.orig/arch/sparc/Kconfig
+++ tip/arch/sparc/Kconfig
@@ -31,6 +31,7 @@ config SPARC
 	select GENERIC_PCI_IOMAP
 	select HAVE_NMI_WATCHDOG if SPARC64
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 
 config SPARC32
 	def_bool !64BIT
Index: tip/arch/sparc/kernel/init_task.c
===================================================================
--- tip.orig/arch/sparc/kernel/init_task.c
+++ /dev/null
@@ -1,22 +0,0 @@
-#include <linux/mm.h>
-#include <linux/fs.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/init_task.h>
-#include <linux/mqueue.h>
-
-#include <asm/pgtable.h>
-#include <asm/uaccess.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-struct task_struct init_task = INIT_TASK(init_task);
-EXPORT_SYMBOL(init_task);
-
-/* .text section in head.S is aligned at 8k boundary and this gets linked
- * right after that so that the init_thread_union is aligned properly as well.
- * If this is not aligned on a 8k boundary, then you should change code
- * in etrap.S which assumes it.
- */
-union thread_union init_thread_union __init_task_data =
-	{ INIT_THREAD_INFO(init_task) };



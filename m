Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab2ECJEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:04:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:49975 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab2ECJDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:03:00 -0400
Message-Id: <20120503085035.463573011@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:02:59 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: [patch V2 25/31] sparc: Use generic init_task
References: <20120503083859.991965503@linutronix.de>
Content-Disposition: inline; filename=sparc-use-generic-init-task.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: "David S. Miller" <davem@davemloft.net>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/sparc/Kconfig            |    1 +
 arch/sparc/Makefile           |    1 -
 arch/sparc/kernel/Makefile    |    1 -
 arch/sparc/kernel/init_task.c |   22 ----------------------
 4 files changed, 1 insertion(+), 24 deletions(-)

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
Index: tip/arch/sparc/Makefile
===================================================================
--- tip.orig/arch/sparc/Makefile
+++ tip/arch/sparc/Makefile
@@ -62,7 +62,6 @@ endif
 endif
 
 head-y                 := arch/sparc/kernel/head_$(BITS).o
-head-y                 += arch/sparc/kernel/init_task.o
 
 core-y                 += arch/sparc/kernel/
 core-y                 += arch/sparc/mm/ arch/sparc/math-emu/
Index: tip/arch/sparc/kernel/Makefile
===================================================================
--- tip.orig/arch/sparc/kernel/Makefile
+++ tip/arch/sparc/kernel/Makefile
@@ -6,7 +6,6 @@ asflags-y := -ansi
 ccflags-y := -Werror
 
 extra-y     := head_$(BITS).o
-extra-y     += init_task.o
 
 # Undefine sparc when processing vmlinux.lds - it is used
 # And teach CPP we are doing $(BITS) builds (for this case)
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



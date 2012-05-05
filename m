Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2EETL0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:11:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54745 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab2EETLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:11:25 -0400
Date: Sat, 5 May 2012 12:11:08 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-e4d59621923ba6c42f30a9d74c7c78d101c2f7aa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        chris@zankel.net, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, chris@zankel.net
In-Reply-To: <20120503085035.804059531@linutronix.de>
References: <20120503085035.804059531@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] xtensa: Use generic init_task
Git-Commit-ID: e4d59621923ba6c42f30a9d74c7c78d101c2f7aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 12:11:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4d59621923ba6c42f30a9d74c7c78d101c2f7aa
Gitweb:     http://git.kernel.org/tip/e4d59621923ba6c42f30a9d74c7c78d101c2f7aa
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:03:01 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:26 +0200

xtensa: Use generic init_task

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Zankel <chris@zankel.net>
Link: http://lkml.kernel.org/r/20120503085035.804059531@linutronix.de
---
 arch/xtensa/Kconfig            |    1 +
 arch/xtensa/kernel/Makefile    |    2 +-
 arch/xtensa/kernel/init_task.c |   31 -------------------------------
 3 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 8a3f835..d0ab5bb 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -10,6 +10,7 @@ config XTENSA
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
+	select HAVE_GENERIC_INIT_TASK
 	help
 	  Xtensa processors are 32-bit RISC machines designed by Tensilica
 	  primarily for embedded systems.  These processors are both
diff --git a/arch/xtensa/kernel/Makefile b/arch/xtensa/kernel/Makefile
index 2d2728b..59fc3fe 100644
--- a/arch/xtensa/kernel/Makefile
+++ b/arch/xtensa/kernel/Makefile
@@ -6,7 +6,7 @@ extra-y := head.o vmlinux.lds
 
 obj-y := align.o entry.o irq.o coprocessor.o process.o ptrace.o \
 	 setup.o signal.o syscall.o time.o traps.o vectors.o platform.o  \
-	 pci-dma.o init_task.o io.o
+	 pci-dma.o io.o
 
 obj-$(CONFIG_KGDB) += xtensa-stub.o
 obj-$(CONFIG_PCI) += pci.o
diff --git a/arch/xtensa/kernel/init_task.c b/arch/xtensa/kernel/init_task.c
deleted file mode 100644
index cd122fb..0000000
--- a/arch/xtensa/kernel/init_task.c
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

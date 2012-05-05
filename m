Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab2EES7l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:59:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54439 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2EES7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:59:40 -0400
Date: Sat, 5 May 2012 11:59:29 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-16caadb8c8f8461b853bd3a310d7730cf5a0aec4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        monstr@monstr.eu, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        monstr@monstr.eu, tglx@linutronix.de
In-Reply-To: <20120503085034.881532838@linutronix.de>
References: <20120503085034.881532838@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] microblaze: Use generic init_task
Git-Commit-ID: 16caadb8c8f8461b853bd3a310d7730cf5a0aec4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 11:59:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16caadb8c8f8461b853bd3a310d7730cf5a0aec4
Gitweb:     http://git.kernel.org/tip/16caadb8c8f8461b853bd3a310d7730cf5a0aec4
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:55 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:24 +0200

microblaze: Use generic init_task

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Michal Simek <monstr@monstr.eu>
Link: http://lkml.kernel.org/r/20120503085034.881532838@linutronix.de
---
 arch/microblaze/Kconfig            |    1 +
 arch/microblaze/kernel/Makefile    |    2 +-
 arch/microblaze/kernel/init_task.c |   26 --------------------------
 3 files changed, 2 insertions(+), 27 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index ac22dc7..21ccba6 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -22,6 +22,7 @@ config MICROBLAZE
 	select GENERIC_PCI_IOMAP
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
+	select HAVE_GENERIC_INIT_TASK
 
 config SWAP
 	def_bool n
diff --git a/arch/microblaze/kernel/Makefile b/arch/microblaze/kernel/Makefile
index 494b63b..928c950 100644
--- a/arch/microblaze/kernel/Makefile
+++ b/arch/microblaze/kernel/Makefile
@@ -16,7 +16,7 @@ endif
 extra-y := head.o vmlinux.lds
 
 obj-y += dma.o exceptions.o \
-	hw_exception_handler.o init_task.o intc.o irq.o \
+	hw_exception_handler.o intc.o irq.o \
 	process.o prom.o prom_parse.o ptrace.o \
 	reset.o setup.o signal.o sys_microblaze.o timer.o traps.o unwind.o
 
diff --git a/arch/microblaze/kernel/init_task.c b/arch/microblaze/kernel/init_task.c
deleted file mode 100644
index b5d711f..0000000
--- a/arch/microblaze/kernel/init_task.c
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

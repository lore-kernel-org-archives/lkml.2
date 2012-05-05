Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab2EESwL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:52:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54317 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab2EESwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:52:09 -0400
Date: Sat, 5 May 2012 11:51:58 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-29b2501bd8bb55822dcdd0b1ad82fe44d44eaa73@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        hskinnemoen@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hskinnemoen@gmail.com, tglx@linutronix.de
In-Reply-To: <20120503085034.281527118@linutronix.de>
References: <20120503085034.281527118@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] avr32: Use generic init_task
Git-Commit-ID: 29b2501bd8bb55822dcdd0b1ad82fe44d44eaa73
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 11:52:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29b2501bd8bb55822dcdd0b1ad82fe44d44eaa73
Gitweb:     http://git.kernel.org/tip/29b2501bd8bb55822dcdd0b1ad82fe44d44eaa73
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:51 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:22 +0200

avr32: Use generic init_task

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Link: http://lkml.kernel.org/r/20120503085034.281527118@linutronix.de
---
 arch/avr32/Kconfig            |    1 +
 arch/avr32/kernel/Makefile    |    2 +-
 arch/avr32/kernel/init_task.c |   31 -------------------------------
 3 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 3dea7231..f4289ca 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -12,6 +12,7 @@ config AVR32
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select HAVE_GENERIC_INIT_TASK
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
diff --git a/arch/avr32/kernel/Makefile b/arch/avr32/kernel/Makefile
index 18229d0..9e2c465 100644
--- a/arch/avr32/kernel/Makefile
+++ b/arch/avr32/kernel/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_SUBARCH_AVR32B)	+= entry-avr32b.o
 obj-y				+= syscall_table.o syscall-stubs.o irq.o
 obj-y				+= setup.o traps.o ocd.o ptrace.o
 obj-y				+= signal.o sys_avr32.o process.o time.o
-obj-y				+= init_task.o switch_to.o cpu.o
+obj-y				+= switch_to.o cpu.o
 obj-$(CONFIG_MODULES)		+= module.o avr32_ksyms.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
diff --git a/arch/avr32/kernel/init_task.c b/arch/avr32/kernel/init_task.c
deleted file mode 100644
index 6b2343e..0000000
--- a/arch/avr32/kernel/init_task.c
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

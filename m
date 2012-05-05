Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab2EES4X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:56:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54395 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab2EES4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:56:21 -0400
Date: Sat, 5 May 2012 11:56:09 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-a3b3aa3d9d5d482ac68477c69fc08cadbc43e074@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, ysato@users.sourceforge.jp
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, ysato@users.sourceforge.jp
In-Reply-To: <20120503085034.623666760@linutronix.de>
References: <20120503085034.623666760@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] h8300-use-generic-init_task
Git-Commit-ID: a3b3aa3d9d5d482ac68477c69fc08cadbc43e074
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 11:56:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3b3aa3d9d5d482ac68477c69fc08cadbc43e074
Gitweb:     http://git.kernel.org/tip/a3b3aa3d9d5d482ac68477c69fc08cadbc43e074
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:53 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:23 +0200

h8300-use-generic-init_task

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Link: http://lkml.kernel.org/r/20120503085034.623666760@linutronix.de
---
 arch/h8300/Kconfig            |    1 +
 arch/h8300/kernel/Makefile    |    2 +-
 arch/h8300/kernel/init_task.c |   36 ------------------------------------
 3 files changed, 2 insertions(+), 37 deletions(-)

diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 56e890d..5fac425 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -5,6 +5,7 @@ config H8300
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
+	select HAVE_GENERIC_INIT_TASK
 
 config SYMBOL_PREFIX
 	string
diff --git a/arch/h8300/kernel/Makefile b/arch/h8300/kernel/Makefile
index 8d4d2a5..1cc57f8 100644
--- a/arch/h8300/kernel/Makefile
+++ b/arch/h8300/kernel/Makefile
@@ -6,7 +6,7 @@ extra-y := vmlinux.lds
 
 obj-y := process.o traps.o ptrace.o irq.o \
 	 sys_h8300.o time.o signal.o \
-         setup.o gpio.o init_task.o syscalls.o \
+         setup.o gpio.o syscalls.o \
 	 entry.o timer/
 
 obj-$(CONFIG_MODULES) += module.o h8300_ksyms.o 
diff --git a/arch/h8300/kernel/init_task.c b/arch/h8300/kernel/init_task.c
deleted file mode 100644
index 54c1062..0000000
--- a/arch/h8300/kernel/init_task.c
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- *  linux/arch/h8300/kernel/init_task.c
- */
-#include <linux/mm.h>
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/init_task.h>
-#include <linux/fs.h>
-#include <linux/mqueue.h>
-
-#include <asm/uaccess.h>
-#include <asm/pgtable.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-/*
- * Initial task structure.
- *
- * All other task structs will be allocated on slabs in fork.c
- */
-__asm__(".align 4");
-struct task_struct init_task = INIT_TASK(init_task);
-
-EXPORT_SYMBOL(init_task);
-
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

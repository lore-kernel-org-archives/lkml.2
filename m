Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab2EETDv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:03:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54605 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab2EETDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:03:50 -0400
Date: Sat, 5 May 2012 12:03:38 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-b0ce50aa89edd82aaadc57e8c774f714ede6101d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        benh@kernel.crashing.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, tglx@linutronix.de
In-Reply-To: <20120503085035.211123184@linutronix.de>
References: <20120503085035.211123184@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] powerpc: Use generic init_task
Git-Commit-ID: b0ce50aa89edd82aaadc57e8c774f714ede6101d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 12:03:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0ce50aa89edd82aaadc57e8c774f714ede6101d
Gitweb:     http://git.kernel.org/tip/b0ce50aa89edd82aaadc57e8c774f714ede6101d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:57 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:25 +0200

powerpc: Use generic init_task

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Link: http://lkml.kernel.org/r/20120503085035.211123184@linutronix.de
---
 arch/powerpc/Kconfig            |    1 +
 arch/powerpc/kernel/Makefile    |    2 +-
 arch/powerpc/kernel/init_task.c |   29 -----------------------------
 3 files changed, 2 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index c815535..946e881 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -145,6 +145,7 @@ config PPC
 	select HAVE_ARCH_JUMP_LABEL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 
 config EARLY_PRINTK
 	bool
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index f5808a3..83afacd 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -28,7 +28,7 @@ endif
 
 obj-y				:= cputable.o ptrace.o syscalls.o \
 				   irq.o align.o signal_32.o pmc.o vdso.o \
-				   init_task.o process.o systbl.o idle.o \
+				   process.o systbl.o idle.o \
 				   signal.o sysfs.o cacheinfo.o time.o \
 				   prom.o traps.o setup-common.o \
 				   udbg.o misc.o io.o dma.o \
diff --git a/arch/powerpc/kernel/init_task.c b/arch/powerpc/kernel/init_task.c
deleted file mode 100644
index d076d46..0000000
--- a/arch/powerpc/kernel/init_task.c
+++ /dev/null
@@ -1,29 +0,0 @@
-#include <linux/mm.h>
-#include <linux/export.h>
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/init_task.h>
-#include <linux/fs.h>
-#include <linux/mqueue.h>
-#include <asm/uaccess.h>
-
-static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
-static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
-/*
- * Initial thread structure.
- *
- * We need to make sure that this is 16384-byte aligned due to the
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

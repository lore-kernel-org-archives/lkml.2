Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab2EESu3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:50:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54281 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2EESu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:50:28 -0400
Date: Sat, 5 May 2012 11:50:18 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-5dced29d71c2ad9b6e69a4af360bd2fd1b3c4950@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mattst88@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mattst88@gmail.com, tglx@linutronix.de
In-Reply-To: <20120503085034.162634519@linutronix.de>
References: <20120503085034.162634519@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] alpha: Use generic init_task
Git-Commit-ID: 5dced29d71c2ad9b6e69a4af360bd2fd1b3c4950
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 11:50:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5dced29d71c2ad9b6e69a4af360bd2fd1b3c4950
Gitweb:     http://git.kernel.org/tip/5dced29d71c2ad9b6e69a4af360bd2fd1b3c4950
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:50 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:21 +0200

alpha: Use generic init_task

Identical code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Matt Turner <mattst88@gmail.com>
Link: http://lkml.kernel.org/r/20120503085034.162634519@linutronix.de

---
 arch/alpha/Kconfig            |    1 +
 arch/alpha/kernel/Makefile    |    2 +-
 arch/alpha/kernel/init_task.c |   17 -----------------
 3 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 991b8bb..74d0004 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -16,6 +16,7 @@ config ALPHA
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_INIT_TASK
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
diff --git a/arch/alpha/kernel/Makefile b/arch/alpha/kernel/Makefile
index 7a6d908..84ec46b 100644
--- a/arch/alpha/kernel/Makefile
+++ b/arch/alpha/kernel/Makefile
@@ -6,7 +6,7 @@ extra-y		:= head.o vmlinux.lds
 asflags-y	:= $(KBUILD_CFLAGS)
 ccflags-y	:= -Wno-sign-compare
 
-obj-y    := entry.o traps.o process.o init_task.o osf_sys.o irq.o \
+obj-y    := entry.o traps.o process.o osf_sys.o irq.o \
 	    irq_alpha.o signal.o setup.o ptrace.o time.o \
 	    alpha_ksyms.o systbls.o err_common.o io.o
 
diff --git a/arch/alpha/kernel/init_task.c b/arch/alpha/kernel/init_task.c
deleted file mode 100644
index 6f80ca4..0000000
--- a/arch/alpha/kernel/init_task.c
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

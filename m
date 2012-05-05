Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2EETFb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:05:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54647 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab2EETF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:05:28 -0400
Date: Sat, 5 May 2012 12:05:17 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-842d7b1ccaefb6668cad193dcc894959ad756f3f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, liqin.chen@sunplusct.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, liqin.chen@sunplusct.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20120503085035.332320547@linutronix.de>
References: <20120503085035.332320547@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] score: Use generic init_task
Git-Commit-ID: 842d7b1ccaefb6668cad193dcc894959ad756f3f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 12:05:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  842d7b1ccaefb6668cad193dcc894959ad756f3f
Gitweb:     http://git.kernel.org/tip/842d7b1ccaefb6668cad193dcc894959ad756f3f
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 3 May 2012 09:02:58 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 5 May 2012 13:00:25 +0200

score: Use generic init_task

Same code. Use the generic version.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Link: http://lkml.kernel.org/r/20120503085035.332320547@linutronix.de

---
 arch/score/Kconfig            |    1 +
 arch/score/kernel/Makefile    |    2 +-
 arch/score/kernel/init_task.c |   46 -----------------------------------------
 3 files changed, 2 insertions(+), 47 deletions(-)

diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 4b28577..c760bcc 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -9,6 +9,7 @@ config SCORE
        select HAVE_MEMBLOCK_NODE_MAP
        select ARCH_DISCARD_MEMBLOCK
        select GENERIC_CPU_DEVICES
+       select HAVE_GENERIC_INIT_TASK
 
 choice
 	prompt "System type"
diff --git a/arch/score/kernel/Makefile b/arch/score/kernel/Makefile
index f218673..fb1802b 100644
--- a/arch/score/kernel/Makefile
+++ b/arch/score/kernel/Makefile
@@ -4,7 +4,7 @@
 
 extra-y	:= head.o vmlinux.lds
 
-obj-y += entry.o init_task.o irq.o process.o ptrace.o \
+obj-y += entry.o irq.o process.o ptrace.o \
 	setup.o signal.o sys_score.o time.o traps.o \
 	sys_call_table.o
 
diff --git a/arch/score/kernel/init_task.c b/arch/score/kernel/init_task.c
deleted file mode 100644
index baa03ee..0000000
--- a/arch/score/kernel/init_task.c
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

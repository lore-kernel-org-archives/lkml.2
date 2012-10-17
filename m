Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab2JQGGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:06:51 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39141 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754701Ab2JQGGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:06:48 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay@vrfy.org>
Subject: [PATCH 01/23] printk: Move to separate directory for easier modification
Date: Tue, 16 Oct 2012 23:06:05 -0700
Message-Id: <0516e0d737ba769c5414abb2a6840d9d6dda9779.1350449851.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350449851.git.joe@perches.com>
References: <cover.1350449851.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it easier to break up printk into bite-sized chunks.

Remove printk path/filename from comment.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/Makefile              |    3 ++-
 kernel/printk/Makefile       |    1 +
 kernel/{ => printk}/printk.c |    2 --
 3 files changed, 3 insertions(+), 3 deletions(-)
 create mode 100644 kernel/printk/Makefile
 rename kernel/{ => printk}/printk.c (99%)

diff --git a/kernel/Makefile b/kernel/Makefile
index 0dfeca4..d53980d 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y     = fork.o exec_domain.o panic.o printk.o \
+obj-y     = fork.o exec_domain.o panic.o \
 	    cpu.o exit.o itimer.o time.o softirq.o resource.o \
 	    sysctl.o sysctl_binary.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o task_work.o \
@@ -24,6 +24,7 @@ endif
 
 obj-y += sched/
 obj-y += power/
+obj-y += printk/
 
 ifeq ($(CONFIG_CHECKPOINT_RESTORE),y)
 obj-$(CONFIG_X86) += kcmp.o
diff --git a/kernel/printk/Makefile b/kernel/printk/Makefile
new file mode 100644
index 0000000..36d306d
--- /dev/null
+++ b/kernel/printk/Makefile
@@ -0,0 +1 @@
+obj-y	= printk.o
diff --git a/kernel/printk.c b/kernel/printk/printk.c
similarity index 99%
rename from kernel/printk.c
rename to kernel/printk/printk.c
index 2d607f4..1950ecf 100644
--- a/kernel/printk.c
+++ b/kernel/printk/printk.c
@@ -1,6 +1,4 @@
 /*
- *  linux/kernel/printk.c
- *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *
  * Modified to make sys_syslog() more flexible: added commands to
-- 
1.7.10.4


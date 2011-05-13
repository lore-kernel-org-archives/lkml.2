Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab1EMXZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 19:25:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:26532 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758272Ab1EMXY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 19:24:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,366,1301900400"; 
   d="scan'208";a="435890991"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: libc-alpha@sourceware.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/5] Move max_threads variable declaration into include file
Date: Fri, 13 May 2011 16:24:16 -0700
Message-Id: <1305329059-2017-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Multiple files have a private extern for the max_threads variable
defined in fork.c. Declare it in linux/sched.h and remove the
special externs.

Needed for followon patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/sched.h |    1 +
 kernel/kmod.c         |    2 --
 kernel/sysctl.c       |    1 -
 3 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 781abd1..34b487b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -134,6 +134,7 @@ extern void get_avenrun(unsigned long *loads, unsigned long offset, int shift);
 
 extern unsigned long total_forks;
 extern int nr_threads;
+extern int max_threads;
 DECLARE_PER_CPU(unsigned long, process_counts);
 extern int nr_processes(void);
 extern unsigned long nr_running(void);
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 9cd0591..3c12d13 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -39,8 +39,6 @@
 
 #include <trace/events/module.h>
 
-extern int max_threads;
-
 static struct workqueue_struct *khelper_wq;
 
 #ifdef CONFIG_MODULES
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c0bb324..ece9b94 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -88,7 +88,6 @@
 /* External variables not in a header file. */
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
-extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
 extern char core_pattern[];
-- 
1.7.4.4


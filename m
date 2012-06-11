Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab2FKJMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:12:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56750 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2FKJM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:12:28 -0400
Date: Mon, 11 Jun 2012 02:12:08 -0700
From: tip-bot for Charles Wang <muming.wq@gmail.com>
Message-ID: <tip-106c1cead7c5c073f375de21760a64f97d9fdd6c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        muming.wq@taobao.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        muming.wq@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        muming.wq@taobao.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        muming.wq@gmail.com
In-Reply-To: <1339395269-4803-1-git-send-email-muming.wq@taobao.com>
References: <1339395269-4803-1-git-send-email-muming.wq@taobao.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove unused parameter 'ticks'
  from calc_global_load()
Git-Commit-ID: 106c1cead7c5c073f375de21760a64f97d9fdd6c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 11 Jun 2012 02:12:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  106c1cead7c5c073f375de21760a64f97d9fdd6c
Gitweb:     http://git.kernel.org/tip/106c1cead7c5c073f375de21760a64f97d9fdd6c
Author:     Charles Wang <muming.wq@gmail.com>
AuthorDate: Mon, 11 Jun 2012 14:14:29 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Jun 2012 10:40:40 +0200

sched: Remove unused parameter 'ticks' from calc_global_load()

Parameter "ticks" is not used in calc_global_load() anymore,
so remove it.

( calc_load_account_active() is called from update_cpu_load_active()
  instead. )

Signed-off-by: Charles Wang <muming.wq@taobao.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1339395269-4803-1-git-send-email-muming.wq@taobao.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h     |    2 +-
 kernel/sched/core.c       |    4 ++--
 kernel/time/timekeeping.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4059c0f..a368976 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -144,7 +144,7 @@ extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
 
 
-extern void calc_global_load(unsigned long ticks);
+extern void calc_global_load(void);
 extern void update_cpu_load_nohz(void);
 
 extern unsigned long get_parent_ip(unsigned long addr);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d5594a4..dfe673d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2367,7 +2367,7 @@ void get_avenrun(unsigned long *loads, unsigned long offset, int shift)
  * calc_load - update the avenrun load estimates 10 ticks after the
  * CPUs have updated calc_load_tasks.
  */
-void calc_global_load(unsigned long ticks)
+void calc_global_load(void)
 {
 	long active;
 
@@ -2395,7 +2395,7 @@ void calc_global_load(unsigned long ticks)
 }
 
 /*
- * Called from update_cpu_load() to periodically update this CPU's
+ * Called from update_cpu_load_active() to periodically update this CPU's
  * active count.
  */
 static void calc_load_account_active(struct rq *this_rq)
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 6f46a00..87be8c2 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1223,7 +1223,7 @@ void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
 	update_wall_time();
-	calc_global_load(ticks);
+	calc_global_load();
 }
 
 /**

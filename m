Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab2FKGPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 02:15:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38176 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab2FKGPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 02:15:35 -0400
From: Charles Wang <muming.wq@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Charles Wang <muming.wq@taobao.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] sched: parameter "ticks" no longer needed
Date: Mon, 11 Jun 2012 14:14:29 +0800
Message-Id: <1339395269-4803-1-git-send-email-muming.wq@taobao.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parameter "ticks" is not used in calc_global_load now,
so remove it.
calc_load_account_active is called from update_cpu_load_active now.

Signed-off-by: Charles Wang <muming.wq@taobao.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@redhat.com>
---

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 503511f..db4c715 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -145,7 +145,7 @@ extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
 
 
-extern void calc_global_load(unsigned long ticks);
+extern void calc_global_load(void);
 extern void update_cpu_load_nohz(void);
 
 extern unsigned long get_parent_ip(unsigned long addr);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 98d7da4..ca07ee0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2368,7 +2368,7 @@ void get_avenrun(unsigned long *loads, unsigned long offset, int shift)
  * calc_load - update the avenrun load estimates 10 ticks after the
  * CPUs have updated calc_load_tasks.
  */
-void calc_global_load(unsigned long ticks)
+void calc_global_load(void)
 {
 	long active;
 
@@ -2396,7 +2396,7 @@ void calc_global_load(unsigned long ticks)
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
-- 
1.7.9.5


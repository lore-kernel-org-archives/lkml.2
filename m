Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181Ab1INUF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:05:58 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:2260 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140Ab1INUF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:05:56 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: xemul@parallels.com, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, mingo@elte.hu, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH 3/9] Include nice values in cpuacct
Date: Wed, 14 Sep 2011 17:04:49 -0300
Message-Id: <1316030695-19826-4-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316030695-19826-1-git-send-email-glommer@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides user and system.

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 kernel/sched.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8fd3f8b..93aa666 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1446,6 +1446,7 @@ static const u32 prio_to_wmult[40] = {
 /* Time spent by the tasks of the cpu accounting group executing in ... */
 enum cpuacct_stat_index {
 	CPUACCT_STAT_USER,	/* ... user mode */
+	CPUACCT_STAT_NICE,	/* ... user nice */
 	CPUACCT_STAT_SYSTEM,	/* ... kernel mode */
 
 	CPUACCT_STAT_NSTATS,
@@ -3758,6 +3759,7 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 		       cputime_t cputime_scaled)
 {
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	int stat = CPUACCT_STAT_USER;
 	cputime64_t tmp;
 
 	/* Add user time to process. */
@@ -3767,12 +3769,13 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 
 	/* Add user time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
-	if (TASK_NICE(p) > 0)
+	if (TASK_NICE(p) > 0) {
 		cpustat->nice = cputime64_add(cpustat->nice, tmp);
-	else
+		stat = CPUACCT_STAT_NICE;
+	} else
 		cpustat->user = cputime64_add(cpustat->user, tmp);
 
-	cpuacct_update_stats(p, CPUACCT_STAT_USER, cputime);
+	cpuacct_update_stats(p, stat, cputime);
 	/* Account for user time used */
 	acct_update_integrals(p);
 }
-- 
1.7.6


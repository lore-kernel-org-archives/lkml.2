Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab1INUGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:06:11 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:30436 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933140Ab1INUGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:06:08 -0400
From: Glauber Costa <glommer@parallels.com>
To: linux-kernel@vger.kernel.org
Cc: xemul@parallels.com, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, mingo@elte.hu, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, Glauber Costa <glommer@parallels.com>
Subject: [PATCH 5/9] Include guest fields in cpuacct
Date: Wed, 14 Sep 2011 17:04:51 -0300
Message-Id: <1316030695-19826-6-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316030695-19826-1-git-send-email-glommer@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Glauber Costa <glommer@parallels.com>
---
 kernel/sched.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index a36d995..f0309a0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1450,6 +1450,8 @@ enum cpuacct_stat_index {
 	CPUACCT_STAT_SYSTEM,	/* ... kernel mode */
 	CPUACCT_STAT_IRQ,	/* ... irq ticks */
 	CPUACCT_STAT_SOFTIRQ,	/* ... softirq ticks */
+	CPUACCT_STAT_GUEST,	/* ... guest mode */
+	CPUACCT_STAT_GUEST_NICE,	/* ... guest nice */
 
 	CPUACCT_STAT_NSTATS,
 };
@@ -3793,6 +3795,8 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 {
 	cputime64_t tmp;
 	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	int stat = CPUACCT_STAT_NICE;
+	int statnice = CPUACCT_STAT_GUEST_NICE;
 
 	tmp = cputime_to_cputime64(cputime);
 
@@ -3809,7 +3813,12 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 	} else {
 		cpustat->user = cputime64_add(cpustat->user, tmp);
 		cpustat->guest = cputime64_add(cpustat->guest, tmp);
+		stat = CPUACCT_STAT_USER;
+		statnice = CPUACCT_STAT_GUEST;
 	}
+
+	cpuacct_update_stats(p, stat, tmp);
+	cpuacct_update_stats(p, statnice, tmp);
 }
 
 /*
-- 
1.7.6


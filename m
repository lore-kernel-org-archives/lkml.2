Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab1DTUwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:52:15 -0400
Received: from smtp-out.google.com ([74.125.121.67]:47360 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab1DTUv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:51:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=fy+AY/dGcyR082rHodD/sz0dHiKOII+WTMambT7x30KxcVvtzBcr9GH/yi63ltqTX
	TYFyN22RiscKuXovNgNJg==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [RFC][Patch 12/18] sched: Update update_sd_lb_stats() to use u64
Date: Wed, 20 Apr 2011 13:51:31 -0700
Message-Id: <1303332697-16426-13-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update update_sd_lb_stats() and helper functions to use u64/s64 for weight
calculations.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched_fair.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index d5b1276..12b25b7 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2308,23 +2308,23 @@ static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
  * 		during load balancing.
  */
 struct sd_lb_stats {
-	struct sched_group *busiest; /* Busiest group in this sd */
-	struct sched_group *this;  /* Local group in this sd */
-	unsigned long total_load;  /* Total load of all groups in sd */
-	unsigned long total_pwr;   /*	Total power of all groups in sd */
-	unsigned long avg_load;	   /* Average load across all groups in sd */
+	struct sched_group *busiest;	/* Busiest group in this sd */
+	struct sched_group *this;	/* Local group in this sd */
+	u64 total_load;			/* Total load of all groups in sd */
+	unsigned long total_pwr;	/* Total power of all groups in sd */
+	u64 avg_load;			/* Avg load across all groups in sd */
 
 	/** Statistics of this group */
-	unsigned long this_load;
-	unsigned long this_load_per_task;
+	u64 this_load;
+	u64 this_load_per_task;
 	unsigned long this_nr_running;
 	unsigned long this_has_capacity;
 	unsigned int  this_idle_cpus;
 
 	/* Statistics of the busiest group */
 	unsigned int  busiest_idle_cpus;
-	unsigned long max_load;
-	unsigned long busiest_load_per_task;
+	u64 max_load;
+	u64 busiest_load_per_task;
 	unsigned long busiest_nr_running;
 	unsigned long busiest_group_capacity;
 	unsigned long busiest_has_capacity;
@@ -2461,8 +2461,8 @@ static inline void update_sd_power_savings_stats(struct sched_group *group,
 	     group_first_cpu(group) > group_first_cpu(sds->group_min))) {
 		sds->group_min = group;
 		sds->min_nr_running = sgs->sum_nr_running;
-		sds->min_load_per_task = sgs->sum_weighted_load /
-						sgs->sum_nr_running;
+		sds->min_load_per_task = div_u64(sgs->sum_weighted_load,
+						 sgs->sum_nr_running);
 	}
 
 	/*
-- 
1.7.3.1


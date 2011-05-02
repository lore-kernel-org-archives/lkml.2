Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab1EBBVG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 21:21:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54601 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab1EBBUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 21:20:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=ecNrwZ/1y/gKMtHb74u94S2mwF04YWBkLFfEADZPo1VO6jVX4cX+vFN9phuZJIS+B
	YVnutXzoXCxo7gRSk1fuQ==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>,
        Nikhil Rao <ncrao@google.com>
Subject: [PATCH v1 12/19] sched: Update update_sd_lb_stats() to use u64
Date: Sun,  1 May 2011 18:19:10 -0700
Message-Id: <1304299157-25769-13-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1304299157-25769-1-git-send-email-ncrao@google.com>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
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
index 992b9f4..152b472 100644
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


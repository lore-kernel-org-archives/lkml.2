Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1BWME6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:04:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:56397 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab1BWME5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:04:57 -0500
Date: Wed, 23 Feb 2011 12:04:26 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ncrao@google.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu,
        venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, ncrao@google.com, efault@gmx.de,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu,
        venki@google.com
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Clean up some f_b_g() comments
Message-ID: <tip-cc57aa8f4b3bece8c26c7929728edcc5fa6b5aed@git.kernel.org>
Git-Commit-ID: cc57aa8f4b3bece8c26c7929728edcc5fa6b5aed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 12:04:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc57aa8f4b3bece8c26c7929728edcc5fa6b5aed
Gitweb:     http://git.kernel.org/tip/cc57aa8f4b3bece8c26c7929728edcc5fa6b5aed
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 21 Feb 2011 18:55:32 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Feb 2011 11:33:56 +0100

sched: Clean up some f_b_g() comments

The existing comment tends to grow state (as it already has), split it
up and place it near the actual tests.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nikhil Rao <ncrao@google.com>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index cd18600..03496eb 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3113,19 +3113,9 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	 */
 	update_sd_lb_stats(sd, this_cpu, idle, cpus, balance, &sds);
 
-	/* Cases where imbalance does not exist from POV of this_cpu */
-	/* 1) this_cpu is not the appropriate cpu to perform load balancing
-	 *    at this level.
-	 * 2) There is no busy sibling group to pull from.
-	 * 3) This group is the busiest group.
-	 * 4) This group is more busy than the avg busieness at this
-	 *    sched_domain.
-	 * 5) The imbalance is within the specified limit.
-	 *
-	 * Note: when doing newidle balance, if the local group has excess
-	 * capacity (i.e. nr_running < group_capacity) and the busiest group
-	 * does not have any capacity, we force a load balance to pull tasks
-	 * to the local group. In this case, we skip past checks 3, 4 and 5.
+	/*
+	 * this_cpu is not the appropriate cpu to perform load balancing at
+	 * this level.
 	 */
 	if (!(*balance))
 		goto ret;
@@ -3134,19 +3124,27 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	    check_asym_packing(sd, &sds, this_cpu, imbalance))
 		return sds.busiest;
 
+	/* There is no busy sibling group to pull tasks from */
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;
 
-	/*  SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
+	/* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
 	if (idle == CPU_NEWLY_IDLE && sds.this_has_capacity &&
 			!sds.busiest_has_capacity)
 		goto force_balance;
 
+	/*
+	 * If the local group is more busy than the selected busiest group
+	 * don't try and pull any tasks.
+	 */
 	if (sds.this_load >= sds.max_load)
 		goto out_balanced;
 
+	/*
+	 * Don't pull any tasks if this group is already above the domain
+	 * average load.
+	 */
 	sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
-
 	if (sds.this_load >= sds.avg_load)
 		goto out_balanced;
 

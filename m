Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab2ASQi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:38:56 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49615 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab2ASQiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:38:55 -0500
Subject: [PATCH] sched/stats: Keep legacy array expiration field to zero.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Jan 2012 22:37:22 +0600
Message-ID: <1326991042.6107.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 A patch (https://lkml.org/lkml/2012/1/12/224) was sent previously to update scheduler stat documentation to address array expiration field's use. Then Ingo suggest that, we should also make sure that we're exporting a value of zero. So, this patch does those accordingly.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/Documentation/scheduler/sched-stats.txt b/Documentation/scheduler/sched-stats.txt
index 1cd5d51..8259b34 100644
--- a/Documentation/scheduler/sched-stats.txt
+++ b/Documentation/scheduler/sched-stats.txt
@@ -38,7 +38,8 @@ First field is a sched_yield() statistic:
      1) # of times sched_yield() was called
 
 Next three are schedule() statistics:
-     2) # of times we switched to the expired queue and reused it
+     2) This field is a legacy array expiration count field used in the O(1)
+	scheduler. We kept it for ABI compatibility, but it is always set to zero.
      3) # of times schedule() was called
      4) # of times schedule() left the processor idle
 
diff --git a/kernel/sched/stats.c b/kernel/sched/stats.c
index 2a581ba..903ffa9e 100644
--- a/kernel/sched/stats.c
+++ b/kernel/sched/stats.c
@@ -32,9 +32,9 @@ static int show_schedstat(struct seq_file *seq, void *v)
 
 		/* runqueue-specific stats */
 		seq_printf(seq,
-		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
+		    "cpu%d %u 0 %u %u %u %u %llu %llu %lu",
 		    cpu, rq->yld_count,
-		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
+		    rq->sched_count, rq->sched_goidle,
 		    rq->ttwu_count, rq->ttwu_local,
 		    rq->rq_cpu_time,
 		    rq->rq_sched_info.run_delay, rq->rq_sched_info.pcount);



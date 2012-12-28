Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab2L1UiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:38:06 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63821 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab2L1Ugk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 15:36:40 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/24] blkcg: s/blkg_rwstat_sum()/blkg_rwstat_total()/
Date: Fri, 28 Dec 2012 12:35:40 -0800
Message-Id: <1356726946-26037-19-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename blkg_rwstat_sum() to blkg_rwstat_total().  sum will be used for
summing up stats from multiple blkgs.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.h  | 4 ++--
 block/cfq-iosched.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 678e89e..586c0ac 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -461,14 +461,14 @@ static inline struct blkg_rwstat blkg_rwstat_read(struct blkg_rwstat *rwstat)
 }
 
 /**
- * blkg_rwstat_sum - read the total count of a blkg_rwstat
+ * blkg_rwstat_total - read the total count of a blkg_rwstat
  * @rwstat: blkg_rwstat to read
  *
  * Return the total count of @rwstat regardless of the IO direction.  This
  * function can be called without synchronization and takes care of u64
  * atomicity.
  */
-static inline uint64_t blkg_rwstat_sum(struct blkg_rwstat *rwstat)
+static inline uint64_t blkg_rwstat_total(struct blkg_rwstat *rwstat)
 {
 	struct blkg_rwstat tmp = blkg_rwstat_read(rwstat);
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e8f3106..d43145cc 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -536,7 +536,7 @@ static void cfqg_stats_set_start_empty_time(struct cfq_group *cfqg)
 {
 	struct cfqg_stats *stats = &cfqg->stats;
 
-	if (blkg_rwstat_sum(&stats->queued))
+	if (blkg_rwstat_total(&stats->queued))
 		return;
 
 	/*
@@ -580,7 +580,7 @@ static void cfqg_stats_update_avg_queue_size(struct cfq_group *cfqg)
 	struct cfqg_stats *stats = &cfqg->stats;
 
 	blkg_stat_add(&stats->avg_queue_size_sum,
-		      blkg_rwstat_sum(&stats->queued));
+		      blkg_rwstat_total(&stats->queued));
 	blkg_stat_add(&stats->avg_queue_size_samples, 1);
 	cfqg_stats_update_group_wait_time(stats);
 }
-- 
1.8.0.2


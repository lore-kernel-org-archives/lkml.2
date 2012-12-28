Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab2L1UkC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:40:02 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:38247 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab2L1UgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 15:36:09 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/24] cfq-iosched: Rename few functions related to selecting workload
Date: Fri, 28 Dec 2012 12:35:26 -0800
Message-Id: <1356726946-26037-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

choose_service_tree() selects/sets both wl_class and wl_type.  Rename it to
choose_wl_class_and_type() to make it very clear.

cfq_choose_wl() only selects and sets wl_type. It is easy to confuse
it with choose_st(). So rename it to cfq_choose_wl_type() to make
it clear what does it do.

Just renaming. No functionality change.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/cfq-iosched.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index db4a1a5..e34e142 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2490,7 +2490,7 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
 	}
 }
 
-static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
+static enum wl_type_t cfq_choose_wl_type(struct cfq_data *cfqd,
 			struct cfq_group *cfqg, enum wl_class_t wl_class)
 {
 	struct cfq_queue *queue;
@@ -2513,7 +2513,8 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 	return cur_best;
 }
 
-static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
+static void
+choose_wl_class_and_type(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	unsigned slice;
 	unsigned count;
@@ -2551,7 +2552,7 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 
 new_workload:
 	/* otherwise select new workload type */
-	cfqd->serving_wl_type = cfq_choose_wl(cfqd, cfqg,
+	cfqd->serving_wl_type = cfq_choose_wl_type(cfqd, cfqg,
 					cfqd->serving_wl_class);
 	st = st_for(cfqg, cfqd->serving_wl_class, cfqd->serving_wl_type);
 	count = st->count;
@@ -2621,7 +2622,7 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
 	} else
 		cfqd->workload_expires = jiffies - 1;
 
-	choose_service_tree(cfqd, cfqg);
+	choose_wl_class_and_type(cfqd, cfqg);
 }
 
 /*
-- 
1.8.0.2


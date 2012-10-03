Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab2JCU5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 16:57:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440Ab2JCU5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 16:57:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: vgoyal@redhat.com, jmoyer@redhat.com, tj@kernel.org
Subject: [PATCH 4/6] cfq-iosched: Rename few functions related to selecting workload
Date: Wed,  3 Oct 2012 16:56:59 -0400
Message-Id: <1349297821-30078-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1349297821-30078-1-git-send-email-vgoyal@redhat.com>
References: <1349297821-30078-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

choose_service_tree() selects/sets both wl_class and wl_type.  Rename it to
choose_wl_class_and_type() to make it very clear.

cfq_choose_wl() only selects and sets wl_type. It is easy to confuse
it with choose_st(). So rename it to cfq_choose_wl_type() to make
it clear what does it do.

Just renaming. No functionality change.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
---
 block/cfq-iosched.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1d45eea..6e6e00f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2489,7 +2489,7 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
 	}
 }
 
-static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
+static enum wl_type_t cfq_choose_wl_type(struct cfq_data *cfqd,
 			struct cfq_group *cfqg, enum wl_class_t wl_class)
 {
 	struct cfq_queue *queue;
@@ -2512,7 +2512,8 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 	return cur_best;
 }
 
-static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
+static void
+choose_wl_class_and_type(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	unsigned slice;
 	unsigned count;
@@ -2550,7 +2551,7 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 
 new_workload:
 	/* otherwise select new workload type */
-	cfqd->serving_wl_type = cfq_choose_wl(cfqd, cfqg,
+	cfqd->serving_wl_type = cfq_choose_wl_type(cfqd, cfqg,
 					cfqd->serving_wl_class);
 	st = st_for(cfqg, cfqd->serving_wl_class, cfqd->serving_wl_type);
 	count = st->count;
@@ -2620,7 +2621,7 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
 	} else
 		cfqd->workload_expires = jiffies - 1;
 
-	choose_service_tree(cfqd, cfqg);
+	choose_wl_class_and_type(cfqd, cfqg);
 }
 
 /*
-- 
1.7.7.6


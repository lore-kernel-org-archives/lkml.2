Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab2JATeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:34:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025Ab2JATdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:33:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: tj@kernel.org, cgroups@vger.kernel.org, vgoyal@redhat.com
Subject: [PATCH 04/15] cfq-iosched: Rename few functions related to selecting workload
Date: Mon,  1 Oct 2012 15:32:45 -0400
Message-Id: <1349119976-26837-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

choose_st() selects/sets both wl_class and wl_type.  Rename it to
choose_wl_class_and_type() to make it very clear.

cfq_choose_wl() only selects and sets wl_type. It is easy to confuse
it with choose_st(). So rename it to cfq_choose_wl_type() to make
it clear what does it do.

Just renaming. No functionality change.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5eb3ed2..9657924 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2486,7 +2486,7 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
 	}
 }
 
-static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
+static enum wl_type_t cfq_choose_wl_type(struct cfq_data *cfqd,
 			struct cfq_group *cfqg, enum wl_class_t wl_class)
 {
 	struct cfq_queue *queue;
@@ -2509,7 +2509,8 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 	return cur_best;
 }
 
-static void choose_st(struct cfq_data *cfqd, struct cfq_group *cfqg)
+static void
+choose_wl_class_and_type(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	unsigned slice;
 	unsigned count;
@@ -2547,7 +2548,7 @@ static void choose_st(struct cfq_data *cfqd, struct cfq_group *cfqg)
 
 new_workload:
 	/* otherwise select new workload type */
-	cfqd->wl_type = cfq_choose_wl(cfqd, cfqg, cfqd->wl_class);
+	cfqd->wl_type = cfq_choose_wl_type(cfqd, cfqg, cfqd->wl_class);
 	st = st_for(cfqg, cfqd->wl_class, cfqd->wl_type);
 	count = st->count;
 
@@ -2616,7 +2617,7 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
 	} else
 		cfqd->workload_expires = jiffies - 1;
 
-	choose_st(cfqd, cfqg);
+	choose_wl_class_and_type(cfqd, cfqg);
 }
 
 /*
-- 
1.7.7.6


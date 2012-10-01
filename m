Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab2JATdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:33:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207Ab2JATdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:33:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: tj@kernel.org, cgroups@vger.kernel.org, vgoyal@redhat.com
Subject: [PATCH 08/15] cfq-iosched: Make cfq_scale_slice() usable for both queues and groups
Date: Mon,  1 Oct 2012 15:32:49 -0400
Message-Id: <1349119976-26837-9-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make cfq_scale_slice() usable both for queues and groups by taking in
weight as a parameter.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7a65e12..a929e2d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -856,12 +856,12 @@ cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	return cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio);
 }
 
-static inline u64 cfq_scale_slice(unsigned long delta, struct cfq_group *cfqg)
+static inline u64 cfq_scale_slice(unsigned long delta, unsigned int weight)
 {
 	u64 d = delta << CFQ_SERVICE_SHIFT;
 
 	d = d * CFQ_WEIGHT_DEFAULT;
-	do_div(d, cfqg->weight);
+	do_div(d, weight);
 	return d;
 }
 
@@ -1302,7 +1302,7 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 
 	/* Can't update vdisktime while group is on service tree */
 	cfq_group_st_del(st, cfqg);
-	cfqg->vdisktime += cfq_scale_slice(charge, cfqg);
+	cfqg->vdisktime += cfq_scale_slice(charge, cfqg->weight);
 	/* If a new weight was requested, update now, off tree */
 	cfq_group_st_add(st, cfqg);
 
-- 
1.7.7.6


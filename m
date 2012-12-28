Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2L1Ul7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:41:59 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:37300 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab2L1Ul4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 15:41:56 -0500
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Dec 2012 15:41:56 EST
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/24] cfq-iosched: Get rid of unnecessary local variable
Date: Fri, 28 Dec 2012 12:35:27 -0800
Message-Id: <1356726946-26037-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

Use of local varibale "n" seems to be unnecessary. Remove it. This brings
it inline with function __cfq_group_st_add(), which is also doing the
similar operation of adding a group to a rb tree.

No functionality change here.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/cfq-iosched.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e34e142..5ad4cae 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1658,8 +1658,6 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfqq->service_tree = st;
 	p = &st->rb.rb_node;
 	while (*p) {
-		struct rb_node **n;
-
 		parent = *p;
 		__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
 
@@ -1667,13 +1665,11 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		 * sort by key, that represents service time.
 		 */
 		if (time_before(rb_key, __cfqq->rb_key))
-			n = &(*p)->rb_left;
+			p = &parent->rb_left;
 		else {
-			n = &(*p)->rb_right;
+			p = &parent->rb_right;
 			left = 0;
 		}
-
-		p = n;
 	}
 
 	if (left)
-- 
1.8.0.2


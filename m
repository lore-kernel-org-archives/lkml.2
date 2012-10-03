Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab2JCU5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 16:57:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab2JCU5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 16:57:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: vgoyal@redhat.com, jmoyer@redhat.com, tj@kernel.org
Subject: [PATCH 5/6] cfq-iosched: Get rid of unnecessary local variable
Date: Wed,  3 Oct 2012 16:57:00 -0400
Message-Id: <1349297821-30078-6-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1349297821-30078-1-git-send-email-vgoyal@redhat.com>
References: <1349297821-30078-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of local varibale "n" seems to be unnecessary. Remove it. This brings
it inline with function __cfq_group_st_add(), which is also doing the
similar operation of adding a group to a rb tree.

No functionality change here.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
---
 block/cfq-iosched.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6e6e00f..7dc5a49 100644
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
1.7.7.6


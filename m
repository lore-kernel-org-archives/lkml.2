Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab2JATgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:36:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab2JATdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:33:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: tj@kernel.org, cgroups@vger.kernel.org, vgoyal@redhat.com
Subject: [PATCH 05/15] cfq-iosched: Get rid of unnecessary local variable
Date: Mon,  1 Oct 2012 15:32:46 -0400
Message-Id: <1349119976-26837-6-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of local varibale "n" seems to be unnecessary. Remove it. This brings
it inline with function __cfq_group_st_add(), which is also doing the
similar operation of adding a group to a rb tree.

No functionality change here.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9657924..573e668 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1655,8 +1655,6 @@ static void cfq_st_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfqq->st = st;
 	p = &st->rb.rb_node;
 	while (*p) {
-		struct rb_node **n;
-
 		parent = *p;
 		__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
 
@@ -1664,13 +1662,11 @@ static void cfq_st_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
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


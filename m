Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab2JATdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:33:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab2JATdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:33:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: tj@kernel.org, cgroups@vger.kernel.org, vgoyal@redhat.com
Subject: [PATCH 09/15] cfq-iosched: make new_cfqq variable bool
Date: Mon,  1 Oct 2012 15:32:50 -0400
Message-Id: <1349119976-26837-10-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make new_cfqq bool. Also set the variable in the beginning of function.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a929e2d..76f020f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1622,7 +1622,7 @@ static void cfq_st_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	unsigned long rb_key;
 	struct cfq_rb_root *st;
 	int left;
-	int new_cfqq = 1;
+	bool new_cfqq = RB_EMPTY_NODE(&cfqq->rb_node);
 
 	st = st_for(cfqq->cfqg, cfqq_class(cfqq), cfqq_type(cfqq));
 	if (cfq_class_idle(cfqq)) {
@@ -1649,8 +1649,7 @@ static void cfq_st_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		rb_key += __cfqq ? __cfqq->rb_key : jiffies;
 	}
 
-	if (!RB_EMPTY_NODE(&cfqq->rb_node)) {
-		new_cfqq = 0;
+	if (!new_cfqq) {
 		/*
 		 * same position, nothing more to do
 		 */
-- 
1.7.7.6


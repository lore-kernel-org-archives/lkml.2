Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1ARS6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 13:58:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab1ARS6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 13:58:12 -0500
Date: Tue, 18 Jan 2011 13:58:08 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH] cfq: rename a function to give it more appropriate name
Message-ID: <20110118185808.GI27946@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Rename a function to give it more approprate name. We are calculating
  cfq queue slice and function name gives the impression as if cfq group
  slice length is being calculated.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/block/cfq-iosched.c
===================================================================
--- linux-2.6.orig/block/cfq-iosched.c	2011-01-17 15:56:09.000000000 -0500
+++ linux-2.6/block/cfq-iosched.c	2011-01-18 13:42:54.113273067 -0500
@@ -599,7 +599,7 @@ cfq_group_slice(struct cfq_data *cfqd, s
 }
 
 static inline unsigned
-cfq_scaled_group_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+cfq_scaled_cfqq_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
 	if (cfqd->cfq_latency) {
@@ -631,7 +631,7 @@ cfq_scaled_group_slice(struct cfq_data *
 static inline void
 cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
-	unsigned slice = cfq_scaled_group_slice(cfqd, cfqq);
+	unsigned slice = cfq_scaled_cfqq_slice(cfqd, cfqq);
 
 	cfqq->slice_start = jiffies;
 	cfqq->slice_end = jiffies + slice;
@@ -1671,7 +1671,7 @@ __cfq_slice_expired(struct cfq_data *cfq
 	 */
 	if (timed_out) {
 		if (cfq_cfqq_slice_new(cfqq))
-			cfqq->slice_resid = cfq_scaled_group_slice(cfqd, cfqq);
+			cfqq->slice_resid = cfq_scaled_cfqq_slice(cfqd, cfqq);
 		else
 			cfqq->slice_resid = cfqq->slice_end - jiffies;
 		cfq_log_cfqq(cfqd, cfqq, "resid=%ld", cfqq->slice_resid);

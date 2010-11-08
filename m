Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab0KHCHR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 21:07:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:19120 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab0KHCHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 21:07:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,311,1286175600"; 
   d="scan'208";a="571193569"
Subject: [patch 1/3]cfq-iosched: do cleanup
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, vgoyal@redhat.com, czoccolo@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 10:07:13 +0800
Message-ID: <1289182033.23014.189.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

some random fixes for cfq-iosched. My last post seems lost, so repost
them.

Thanks,
Shaohua


Some functions should return boolean.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/cfq-iosched.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2010-11-01 13:34:53.000000000 +0800
+++ linux/block/cfq-iosched.c	2010-11-08 09:54:32.000000000 +0800
@@ -646,11 +646,11 @@ cfq_set_prio_slice(struct cfq_data *cfqd
 static inline bool cfq_slice_used(struct cfq_queue *cfqq)
 {
 	if (cfq_cfqq_slice_new(cfqq))
-		return 0;
+		return false;
 	if (time_before(jiffies, cfqq->slice_end))
-		return 0;
+		return false;
 
-	return 1;
+	return true;
 }
 
 /*
@@ -1901,10 +1901,10 @@ static bool cfq_should_idle(struct cfq_d
 	 * in their service tree.
 	 */
 	if (service_tree->count == 1 && cfq_cfqq_sync(cfqq))
-		return 1;
+		return true;
 	cfq_log_cfqq(cfqd, cfqq, "Not idling. st->count:%d",
 			service_tree->count);
-	return 0;
+	return false;
 }
 
 static void cfq_arm_slice_timer(struct cfq_data *cfqd)
@@ -2367,12 +2367,12 @@ static inline bool cfq_slice_used_soon(s
 {
 	/* the queue hasn't finished any request, can't estimate */
 	if (cfq_cfqq_slice_new(cfqq))
-		return 1;
+		return true;
 	if (time_after(jiffies + cfqd->cfq_slice_idle * cfqq->dispatched,
 		cfqq->slice_end))
-		return 1;
+		return true;
 
-	return 0;
+	return false;
 }
 
 static bool cfq_may_dispatch(struct cfq_data *cfqd, struct cfq_queue *cfqq)




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220Ab1IZCZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 22:25:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:56370 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab1IZCZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 22:25:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="56345247"
Subject: [patch]cfq-iosched: delete dead code --resend
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 10:30:24 +0800
Message-ID: <1317004224.29510.171.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below check is obsoleted. Currently requests in a queue are not
sync/async mixed (except oom queue, but it's rare case)

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 block/cfq-iosched.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2011-09-22 12:54:06.000000000 +0800
+++ linux/block/cfq-iosched.c	2011-09-22 12:56:47.000000000 +0800
@@ -681,9 +681,6 @@ cfq_choose_req(struct cfq_data *cfqd, st
 	if (rq2 == NULL)
 		return rq1;
 
-	if (rq_is_sync(rq1) != rq_is_sync(rq2))
-		return rq_is_sync(rq1) ? rq1 : rq2;
-
 	if ((rq1->cmd_flags ^ rq2->cmd_flags) & REQ_PRIO)
 		return rq1->cmd_flags & REQ_PRIO ? rq1 : rq2;
 



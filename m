Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab1HPCtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:49:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:32024 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542Ab1HPCtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:49:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="38753843"
Subject: [patch]cfq-iosched: delete dead code
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Aug 2011 10:50:04 +0800
Message-ID: <1313463004.27321.24.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below check is obsoleted. Currently requests in a queue are not
sync/async mixed (except oom queue, but it's rare case)

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1f96ad6..a7d51c1 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -679,9 +679,6 @@ cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2,
 	if (rq2 == NULL)
 		return rq1;
 
-	if (rq_is_sync(rq1) != rq_is_sync(rq2))
-		return rq_is_sync(rq1) ? rq1 : rq2;
-
 	s1 = blk_rq_pos(rq1);
 	s2 = blk_rq_pos(rq2);
 



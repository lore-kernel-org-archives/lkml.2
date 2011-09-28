Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab1I1DGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 23:06:36 -0400
Received: from mga14.intel.com ([143.182.124.37]:16176 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab1I1DGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 23:06:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,453,1312182000"; 
   d="scan'208";a="21316316"
Subject: [patch 2/2]block: add missed trace_block_plug
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 11:11:30 +0800
Message-ID: <1317179490.22361.12.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After flush plug list, the list has no request, so we need
add a trace_block_plug.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 block/blk-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/block/blk-core.c
===================================================================
--- linux.orig/block/blk-core.c	2011-09-28 11:05:22.000000000 +0800
+++ linux/block/blk-core.c	2011-09-28 11:05:42.000000000 +0800
@@ -1307,8 +1307,10 @@ get_rq:
 				if (__rq->q != q)
 					plug->should_sort = 1;
 			}
-			if (request_count >= BLK_MAX_REQUEST_COUNT)
+			if (request_count >= BLK_MAX_REQUEST_COUNT) {
 				blk_flush_plug_list(plug, false);
+				trace_block_plug(q);
+			}
 		}
 		list_add_tail(&req->queuelist, &plug->list);
 		drive_stat_acct(req, 1);



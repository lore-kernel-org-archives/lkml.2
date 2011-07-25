Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab1GYLDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 07:03:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32191 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab1GYLDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 07:03:31 -0400
X-AuditID: cbfee61b-b7c3dae000002cb8-f5-4e2d4d8107d4
Date: Mon, 25 Jul 2011 20:03:19 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH] block: use the logical OR condition at	blk_flush_complete_seq
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Message-id: <20110725110319.GA31362@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 25 Jul 2011 11:03:50.0574 (UTC)
 FILETIME=[88C2C4E0:01CC4ABA]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

Even though the meaning is same, use the logical OR condition instead ORing.

seq	blk_kick_flush(q)	queued
1	1			0		=> true
2	0			1		=> true
8	0			0		=> false

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/block/blk-flush.c b/block/blk-flush.c
index bb21e4c..66e0acb 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -187,7 +187,7 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 		BUG();
 	}
 
-	return blk_kick_flush(q) | queued;
+	return blk_kick_flush(q) || queued;
 }
 
 static void flush_end_io(struct request *flush_rq, int error)

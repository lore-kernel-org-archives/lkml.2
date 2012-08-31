Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab2HaIY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 04:24:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45333 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab2HaIYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 04:24:24 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-02-504074b667d6
Message-id: <504074AD.2010309@samsung.com>
Date: Fri, 31 Aug 2012 17:24:13 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Cc: axboe@kernel.dk, Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] block: remove the duplicated setting for congestion_threshold
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t9jAd1tJQ4BBs2t2haXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj1US3gkVsFdsX32VqYFzM2sXIySEhYCJx9tNmNghbTOLCvfVA
	NheHkMAiRond//8wQjhdTBJTjm4Fq+IV0JL4uvYLM4jNIqAqse/zMyYQm01AR2L7t+NgtqhA
	iMT1PRsYIeoFJX5MvscCYosIqEvs7voCVsMsYCfxb8pBMFtYwE/i6bPTzBBxHYn9rdPYIGx5
	ic1r3jJPYOSbhWTULCRls5CULWBkXsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHFDPpHcw
	rmqwOMQowMGoxMPbucs+QIg1say4MvcQowQHs5IIr12RQ4AQb0piZVVqUX58UWlOavEhRmkO
	FiVxXqdzdgFCAumJJanZqakFqUUwWSYOTqkGRibboh83/YxyF8xPWyaW77+Sc2HI7rl14ufY
	JmxzDCuJ6BKfdfMup+/e6KvJE5Qz1jjv5nTgttBawi1h0HvP0qaidKWze5CxvWQX50mXO/1u
	b3z+T3bPEpfs6VOwT0y7a8TMa/kuwXnL6nZu+3Xv3z92SijZmP/uPqfl0uo1Kq43pikkmYgp
	sRRnJBpqMRcVJwIAR2iVrCQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before call the blk_queue_congestion_threshold(),
the blk_queue_congestion_threshold() is already called at blk_queue_make_rquest().
Because this code is the duplicated, it has removed.

Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 block/blk-core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b4dbdf..a418249 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -713,8 +713,6 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	if (elevator_init(q, NULL))
 		return NULL;
 
-	blk_queue_congestion_threshold(q);
-
 	/* all done, end the initial bypass */
 	blk_queue_bypass_end(q);
 	return q;
-- 
1.7.4.1

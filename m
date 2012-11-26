Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab2KZRBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:01:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47127 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab2KZRBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:01:35 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jens Axboe <axboe@kernel.dk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 029/270] block: remove the duplicated setting for congestion_threshold
Date: Mon, 26 Nov 2012 14:55:19 -0200
Message-Id: <1353949160-26803-30-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaehoon Chung <jh80.chung@samsung.com>

commit e32463b2f7801d6561887c01db37b34958504635 upstream.

Before call the blk_queue_congestion_threshold(),
the blk_queue_congestion_threshold() is already called at blk_queue_make_rquest().
Because this code is the duplicated, it has removed.

Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ herton: only a cleanup, but allows clean application of commit 749fefe ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 block/blk-core.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 93eb3e4..ad39394 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -703,8 +703,6 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	if (elevator_init(q, NULL))
 		return NULL;
 
-	blk_queue_congestion_threshold(q);
-
 	/* all done, end the initial bypass */
 	blk_queue_bypass_end(q);
 	return q;
-- 
1.7.9.5


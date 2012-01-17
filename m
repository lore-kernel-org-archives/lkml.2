Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab2AQBXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 20:23:43 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62587 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab2AQBX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 20:23:28 -0500
X-AuditID: 9c930179-b7b98ae000000791-9f-4f14cd8df567
From: Namhyung Kim <namhyung.kim@lge.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: [PATCH 3/3] block: don't export block_bio_complete tracepoint
Date: Tue, 17 Jan 2012 10:32:08 +0900
Message-Id: <1326763928-1972-3-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9.rc1.dirty
In-Reply-To: <1326763928-1972-1-git-send-email-namhyung.kim@lge.com>
References: <1326763928-1972-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now bio_endio() contains the tracepoint in it, so we don't
need to have it twice in DM. Plus, as the only external user
of the tracepoint was the DM, we can unexport the symbol.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: dm-devel@redhat.com
---
 block/blk-core.c |    1 -
 drivers/md/dm.c  |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1b4fd93af2c0..399c128f516c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -37,7 +37,6 @@
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
-EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
 
 DEFINE_IDA(blk_queue_ida);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4720f68f817e..01185fa0eb74 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -648,7 +648,6 @@ static void dec_pending(struct dm_io *io, int error)
 			queue_io(md, bio);
 		} else {
 			/* done with normal IO or empty flush */
-			trace_block_bio_complete(md->queue, bio, io_error);
 			bio_endio(bio, io_error);
 		}
 	}
-- 
1.7.9.rc1.dirty


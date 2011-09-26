Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186Ab1IZEnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 00:43:40 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:56406 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab1IZEni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 00:43:38 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: [PATCH 2/2] block: don't export block_bio_complete tracepoint
Date: Mon, 26 Sep 2011 13:43:30 +0900
Message-Id: <1317012210-4309-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1317012210-4309-1-git-send-email-namhyung@gmail.com>
References: <1317012210-4309-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now bio_endio() contains the tracepoint in it, so we don't
need to have it twice in DM. Plus, as the only external user
of the tracepoint was the DM, we can unexport the symbol.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: dm-devel@redhat.com
---
 block/blk-core.c |    1 -
 drivers/md/dm.c  |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d8005ffc480d..5c81ef057e6a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -36,7 +36,6 @@
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
-EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);
 
 /*
  * For the allocated request tables
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7b986e77b75e..a8223d92a52b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -636,7 +636,6 @@ static void dec_pending(struct dm_io *io, int error)
 			queue_io(md, bio);
 		} else {
 			/* done with normal IO or empty flush */
-			trace_block_bio_complete(md->queue, bio, io_error);
 			bio_endio(bio, io_error);
 		}
 	}
-- 
1.7.6


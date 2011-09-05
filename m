Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1IELtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:49:46 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59865 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab1IELqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:01 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 24/54] drbd: drbd_send_ack_ex(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:15 +0200
Message-Id: <1315223145-20640-25-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c   |    8 ++++----
 drivers/block/drbd/drbd_worker.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a5371fb..c120977 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1299,10 +1299,10 @@ int drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
 int drbd_send_ack_ex(struct drbd_conf *mdev, enum drbd_packet cmd,
 		     sector_t sector, int blksize, u64 block_id)
 {
-	return !_drbd_send_ack(mdev, cmd,
-			       cpu_to_be64(sector),
-			       cpu_to_be32(blksize),
-			       cpu_to_be64(block_id));
+	return _drbd_send_ack(mdev, cmd,
+			      cpu_to_be64(sector),
+			      cpu_to_be32(blksize),
+			      cpu_to_be64(block_id));
 }
 
 int drbd_send_drequest(struct drbd_conf *mdev, int cmd,
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 69db6de..9b74086 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1163,8 +1163,8 @@ int w_e_end_ov_reply(struct drbd_work *w, int cancel)
 	else
 		ov_oos_print(mdev);
 
-	ok = drbd_send_ack_ex(mdev, P_OV_RESULT, sector, size,
-			      eq ? ID_IN_SYNC : ID_OUT_OF_SYNC);
+	ok = !drbd_send_ack_ex(mdev, P_OV_RESULT, sector, size,
+			       eq ? ID_IN_SYNC : ID_OUT_OF_SYNC);
 
 	dec_unacked(mdev);
 
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab1IELsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:48:25 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60226 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1IELqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:13 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 51/54] drbd: drbd_may_do_local_read(): Use bool/true/false
Date: Mon,  5 Sep 2011 13:45:42 +0200
Message-Id: <1315223145-20640-52-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_req.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index f91f9c9..3430dab 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -671,17 +671,16 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
  *   since size may be bigger than BM_BLOCK_SIZE,
  *   we may need to check several bits.
  */
-static int drbd_may_do_local_read(struct drbd_conf *mdev, sector_t sector, int size)
+static bool drbd_may_do_local_read(struct drbd_conf *mdev, sector_t sector, int size)
 {
 	unsigned long sbnr, ebnr;
 	sector_t esector, nr_sectors;
 
 	if (mdev->state.disk == D_UP_TO_DATE)
-		return 1;
+		return true;
 	if (mdev->state.disk != D_INCONSISTENT)
-		return 0;
+		return false;
 	esector = sector + (size >> 9) - 1;
-
 	nr_sectors = drbd_get_capacity(mdev->this_bdev);
 	D_ASSERT(sector  < nr_sectors);
 	D_ASSERT(esector < nr_sectors);
@@ -689,7 +688,7 @@ static int drbd_may_do_local_read(struct drbd_conf *mdev, sector_t sector, int s
 	sbnr = BM_SECT_TO_BIT(sector);
 	ebnr = BM_SECT_TO_BIT(esector);
 
-	return 0 == drbd_bm_count_bits(mdev, sbnr, ebnr);
+	return drbd_bm_count_bits(mdev, sbnr, ebnr) == 0;
 }
 
 /*
-- 
1.7.4.1


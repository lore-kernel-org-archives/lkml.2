Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab1HYPi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:38:57 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32955 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab1HYPJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:01 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 005/118] drbd: Endianness convert the constants instead of the variables
Date: Thu, 25 Aug 2011 17:07:01 +0200
Message-Id: <1314284934-17999-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Converting the constants happens at compile time.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |    2 +-
 drivers/block/drbd/drbd_main.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index cf0e63d..0eb17d3 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -407,7 +407,7 @@ static int drbd_al_read_tr(struct drbd_conf *mdev,
 	if (!drbd_md_sync_page_io(mdev, bdev, sector, READ))
 		return -1;
 
-	rv = (be32_to_cpu(b->magic) == DRBD_MAGIC);
+	rv = (b->magic == cpu_to_be32(DRBD_MAGIC));
 
 	for (i = 0; i < AL_EXTENTS_PT + 1; i++)
 		xor_sum ^= be32_to_cpu(b->updates[i].extent);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 2cd132a..f65b8c5 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3729,7 +3729,7 @@ int drbd_md_read(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 		goto err;
 	}
 
-	if (be32_to_cpu(buffer->magic) != DRBD_MD_MAGIC) {
+	if (buffer->magic != cpu_to_be32(DRBD_MD_MAGIC)) {
 		dev_err(DEV, "Error while reading metadata, magic not found.\n");
 		rv = ERR_MD_INVALID;
 		goto err;
-- 
1.7.4.1


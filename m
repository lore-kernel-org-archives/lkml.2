Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab1IGQut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:50:49 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48574 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab1IGQp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:45:59 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/14] drbd: Make _drbd_send_bitmap() static
Date: Wed,  7 Sep 2011 16:17:31 +0200
Message-Id: <1315405061-1473-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
References: <1315405061-1473-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    1 -
 drivers/block/drbd/drbd_main.c |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 1aec096..077aa0c 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1201,7 +1201,6 @@ extern int drbd_send_drequest_csum(struct drbd_conf *mdev, sector_t sector,
 extern int drbd_send_ov_request(struct drbd_conf *mdev,sector_t sector,int size);
 
 extern int drbd_send_bitmap(struct drbd_conf *mdev);
-extern int _drbd_send_bitmap(struct drbd_conf *mdev);
 extern void drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode);
 extern int conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode);
 extern void drbd_free_bc(struct drbd_backing_dev *ldev);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 34627ae..53e887d 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1182,7 +1182,7 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev,
 }
 
 /* See the comment at receive_bitmap() */
-int _drbd_send_bitmap(struct drbd_conf *mdev)
+static int _drbd_send_bitmap(struct drbd_conf *mdev)
 {
 	struct bm_xfer_ctx c;
 	struct p_header *p;
-- 
1.7.4.1


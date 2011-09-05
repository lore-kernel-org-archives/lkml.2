Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab1IELu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:50:56 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60165 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab1IELqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:03 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 34/54] drbd: drbd_send_short_cmd(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:25 +0200
Message-Id: <1315223145-20640-35-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h    |    2 +-
 drivers/block/drbd/drbd_worker.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index d10505e..24d3202 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1937,7 +1937,7 @@ static inline int drbd_send_short_cmd(struct drbd_conf *mdev,
 				      enum drbd_packet cmd)
 {
 	struct p_header h;
-	return !drbd_send_cmd(mdev, &mdev->tconn->data, cmd, &h, sizeof(h));
+	return drbd_send_cmd(mdev, &mdev->tconn->data, cmd, &h, sizeof(h));
 }
 
 static inline int drbd_send_ping(struct drbd_tconn *tconn)
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 81ddf1c..81d71c7 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1227,7 +1227,7 @@ int w_send_write_hint(struct drbd_work *w, int cancel)
 	struct drbd_conf *mdev = w->mdev;
 	if (cancel)
 		return 1;
-	return drbd_send_short_cmd(mdev, P_UNPLUG_REMOTE);
+	return !drbd_send_short_cmd(mdev, P_UNPLUG_REMOTE);
 }
 
 int w_send_oos(struct drbd_work *w, int cancel)
-- 
1.7.4.1


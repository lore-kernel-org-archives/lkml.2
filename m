Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab1HYPYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:24:07 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34634 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab1HYPJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:38 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 064/118] drbd: Moved code
Date: Thu, 25 Aug 2011 17:08:00 +0200
Message-Id: <1314284934-17999-65-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_worker.c |   43 ++++++++++++++++++-------------------
 1 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 0dbd20c..28925d3 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -707,28 +707,6 @@ static int w_make_ov_request(struct drbd_conf *mdev, struct drbd_work *w, int ca
 	return 1;
 }
 
-
-void start_resync_timer_fn(unsigned long data)
-{
-	struct drbd_conf *mdev = (struct drbd_conf *) data;
-
-	drbd_queue_work(&mdev->tconn->data.work, &mdev->start_resync_work);
-}
-
-int w_start_resync(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
-{
-	if (atomic_read(&mdev->unacked_cnt) || atomic_read(&mdev->rs_pending_cnt)) {
-		dev_warn(DEV, "w_start_resync later...\n");
-		mdev->start_resync_timer.expires = jiffies + HZ/10;
-		add_timer(&mdev->start_resync_timer);
-		return 1;
-	}
-
-	drbd_start_resync(mdev, C_SYNC_SOURCE);
-	clear_bit(AHEAD_TO_SYNC_SOURCE, &mdev->current_epoch->flags);
-	return 1;
-}
-
 int w_ov_finished(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 {
 	kfree(w);
@@ -1462,6 +1440,27 @@ void drbd_rs_controller_reset(struct drbd_conf *mdev)
 	spin_unlock(&mdev->peer_seq_lock);
 }
 
+void start_resync_timer_fn(unsigned long data)
+{
+	struct drbd_conf *mdev = (struct drbd_conf *) data;
+
+	drbd_queue_work(&mdev->tconn->data.work, &mdev->start_resync_work);
+}
+
+int w_start_resync(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
+{
+	if (atomic_read(&mdev->unacked_cnt) || atomic_read(&mdev->rs_pending_cnt)) {
+		dev_warn(DEV, "w_start_resync later...\n");
+		mdev->start_resync_timer.expires = jiffies + HZ/10;
+		add_timer(&mdev->start_resync_timer);
+		return 1;
+	}
+
+	drbd_start_resync(mdev, C_SYNC_SOURCE);
+	clear_bit(AHEAD_TO_SYNC_SOURCE, &mdev->current_epoch->flags);
+	return 1;
+}
+
 /**
  * drbd_start_resync() - Start the resync process
  * @mdev:	DRBD device.
-- 
1.7.4.1


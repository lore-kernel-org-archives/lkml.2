Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab1HaPNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:13:11 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59928 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab1HaPLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:11:15 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/16] drbd: Remove left-over function prototypes
Date: Wed, 31 Aug 2011 17:11:00 +0200
Message-Id: <1314803468-1201-9-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
References: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    2 --
 drivers/block/drbd/drbd_receiver.c |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index c7b9fc9..e065985 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1534,7 +1534,6 @@ extern void drbd_csum_bio(struct drbd_conf *, struct crypto_hash *, struct bio *
 extern void drbd_csum_ee(struct drbd_conf *, struct crypto_hash *,
 			 struct drbd_peer_request *, void *);
 /* worker callbacks */
-extern int w_req_cancel_conflict(struct drbd_work *, int);
 extern int w_read_retry_remote(struct drbd_work *, int);
 extern int w_e_end_data_req(struct drbd_work *, int);
 extern int w_e_end_rsdata_req(struct drbd_work *, int);
@@ -1543,7 +1542,6 @@ extern int w_e_end_ov_reply(struct drbd_work *, int);
 extern int w_e_end_ov_req(struct drbd_work *, int);
 extern int w_ov_finished(struct drbd_work *, int);
 extern int w_resync_timer(struct drbd_work *, int);
-extern int w_resume_next_sg(struct drbd_work *, int);
 extern int w_send_write_hint(struct drbd_work *, int);
 extern int w_send_dblock(struct drbd_work *, int);
 extern int w_send_barrier(struct drbd_work *, int);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index d78ab6e..88552e1 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4012,7 +4012,6 @@ static int drbd_disconnected(int vnr, void *p, void *data)
 
 	del_timer(&mdev->request_timer);
 
-	/* make sure syncer is stopped and w_resume_next_sg queued */
 	del_timer_sync(&mdev->resync_timer);
 	resync_timer_fn((unsigned long)mdev);
 
-- 
1.7.4.1


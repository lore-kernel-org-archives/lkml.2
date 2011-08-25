Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab1HYPZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:25:38 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34470 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab1HYPJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:35 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 059/118] drbd: Update some comments
Date: Thu, 25 Aug 2011 17:07:55 +0200
Message-Id: <1314284934-17999-60-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    4 ++--
 drivers/block/drbd/drbd_main.c     |    2 +-
 drivers/block/drbd/drbd_receiver.c |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index f39c279..2cebdd6 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -727,7 +727,7 @@ enum {
 	 * we need to resubmit without the barrier flag. */
 	__EE_RESUBMITTED,
 
-	/* we may have several bios per epoch entry.
+	/* we may have several bios per peer request.
 	 * if any of those fail, we set this flag atomically
 	 * from the endio callback */
 	__EE_WAS_ERROR,
@@ -1422,7 +1422,7 @@ extern void drbd_bm_unlock(struct drbd_conf *mdev);
 /* drbd_main.c */
 
 extern struct kmem_cache *drbd_request_cache;
-extern struct kmem_cache *drbd_ee_cache;	/* epoch entries */
+extern struct kmem_cache *drbd_ee_cache;	/* peer requests */
 extern struct kmem_cache *drbd_bm_ext_cache;	/* bitmap extents */
 extern struct kmem_cache *drbd_al_ext_cache;	/* activity log extents */
 extern mempool_t *drbd_request_mempool;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 9e8cc1c..964f76e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -135,7 +135,7 @@ struct drbd_conf **minor_table;
 struct list_head drbd_tconns;  /* list of struct drbd_tconn */
 
 struct kmem_cache *drbd_request_cache;
-struct kmem_cache *drbd_ee_cache;	/* epoch entries */
+struct kmem_cache *drbd_ee_cache;	/* peer requests */
 struct kmem_cache *drbd_bm_ext_cache;	/* bitmap extents */
 struct kmem_cache *drbd_al_ext_cache;	/* activity log extents */
 mempool_t *drbd_request_mempool;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 7829656..5c4c260 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1089,7 +1089,7 @@ void drbd_bump_write_ordering(struct drbd_conf *mdev, enum write_ordering_e wo)
 /**
  * drbd_submit_ee()
  * @mdev:	DRBD device.
- * @e:		epoch entry
+ * @e:		peer request
  * @rw:		flag field, see bio->bi_rw
  *
  * May spread the pages to multiple bios,
@@ -1186,7 +1186,7 @@ static void drbd_remove_epoch_entry_interval(struct drbd_conf *mdev,
 	drbd_remove_interval(&mdev->write_requests, i);
 	drbd_clear_interval(i);
 
-	/* Wake up any processes waiting for this epoch entry to complete.  */
+	/* Wake up any processes waiting for this peer request to complete.  */
 	if (i->waiting)
 		wake_up(&mdev->misc_wait);
 }
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab1I2ITT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:19:19 -0400
Received: from mail09.linbit.com ([212.69.161.110]:43419 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab1I2IPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:15:34 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/12] drbd: drbd_init_ee() no longer exists
Date: Thu, 29 Sep 2011 10:15:22 +0200
Message-Id: <1317284131-17464-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317284131-17464-1-git-send-email-philipp.reisner@linbit.com>
References: <1317284131-17464-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c     |    4 ----
 drivers/block/drbd/drbd_receiver.c |    1 -
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 6afcfab..f759a7e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2006,10 +2006,6 @@ void drbd_mdev_cleanup(struct drbd_conf *mdev)
 	drbd_free_resources(mdev);
 	clear_bit(AL_SUSPENDED, &mdev->flags);
 
-	/*
-	 * currently we drbd_init_ee only on module load, so
-	 * we may do drbd_release_ee only on module unload!
-	 */
 	D_ASSERT(list_empty(&mdev->active_ee));
 	D_ASSERT(list_empty(&mdev->sync_ee));
 	D_ASSERT(list_empty(&mdev->done_ee));
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index cd2586b..b4ab05e 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -309,7 +309,6 @@ You need to hold the req_lock:
 You must not have the req_lock:
  drbd_free_ee()
  drbd_alloc_ee()
- drbd_init_ee()
  drbd_release_ee()
  drbd_ee_fix_bhs()
  drbd_process_done_ee()
-- 
1.7.4.1


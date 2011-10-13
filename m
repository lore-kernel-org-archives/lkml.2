Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab1JMKcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:32:46 -0400
Received: from mail09.linbit.com ([212.69.161.110]:58157 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab1JMKcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:32:21 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/10] drbd: Eliminated the "notified peer" messages
Date: Thu, 13 Oct 2011 12:32:16 +0200
Message-Id: <1318501936-11689-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318501936-11689-1-git-send-email-philipp.reisner@linbit.com>
References: <1318501936-11689-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index fe46a8b..5319130 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1333,9 +1333,7 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 				"ASSERT FAILED: disk is %s during detach\n",
 				drbd_disk_str(mdev->state.disk));
 
-		if (!drbd_send_state(mdev))
-			dev_info(DEV, "Notified peer that I am detaching my disk\n");
-
+		drbd_send_state(mdev);
 		drbd_rs_cancel_all(mdev);
 
 		/* In case we want to get something to stable storage still,
@@ -1363,8 +1361,7 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
                 mdev->rs_failed = 0;
                 atomic_set(&mdev->rs_pending_cnt, 0);
 
-		if (!drbd_send_state(mdev))
-			dev_info(DEV, "Notified peer that I'm now diskless.\n");
+		drbd_send_state(mdev);
 		/* corresponding get_ldev in __drbd_set_state
 		 * this may finally trigger drbd_ldev_destroy. */
 		put_ldev(mdev);
-- 
1.7.4.1


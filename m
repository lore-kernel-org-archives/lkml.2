Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab1JMKcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:32:22 -0400
Received: from mail09.linbit.com ([212.69.161.110]:58083 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1JMKcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:32:19 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/10] drbd: downgraded error printk to info
Date: Thu, 13 Oct 2011 12:32:08 +0200
Message-Id: <1318501936-11689-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318501936-11689-1-git-send-email-philipp.reisner@linbit.com>
References: <1318501936-11689-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 1da97e0..1be92e5 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1305,9 +1305,7 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 				drbd_disk_str(mdev->state.disk));
 
 		if (!drbd_send_state(mdev))
-			dev_warn(DEV, "Notified peer that I am detaching my disk\n");
-		else
-			dev_err(DEV, "Sending state for detaching disk failed\n");
+			dev_info(DEV, "Notified peer that I am detaching my disk\n");
 
 		drbd_rs_cancel_all(mdev);
 
@@ -1337,7 +1335,7 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
                 atomic_set(&mdev->rs_pending_cnt, 0);
 
 		if (!drbd_send_state(mdev))
-			dev_warn(DEV, "Notified peer that I'm now diskless.\n");
+			dev_info(DEV, "Notified peer that I'm now diskless.\n");
 		/* corresponding get_ldev in __drbd_set_state
 		 * this may finally trigger drbd_ldev_destroy. */
 		put_ldev(mdev);
-- 
1.7.4.1


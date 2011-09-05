Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab1IELtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:49:21 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60137 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab1IELp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:58 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 19/54] drbd: drbd_send_sr_reply(): Return void: the result is never used
Date: Mon,  5 Sep 2011 13:45:10 +0200
Message-Id: <1315223145-20640-20-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h  |    2 +-
 drivers/block/drbd/drbd_main.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index a375133..b2e7c75 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1204,7 +1204,7 @@ extern int drbd_send_ov_request(struct drbd_conf *mdev,sector_t sector,int size)
 
 extern int drbd_send_bitmap(struct drbd_conf *mdev);
 extern int _drbd_send_bitmap(struct drbd_conf *mdev);
-extern int drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode);
+extern void drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode);
 extern int conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode);
 extern void drbd_free_bc(struct drbd_backing_dev *ldev);
 extern void drbd_mdev_cleanup(struct drbd_conf *mdev);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 93713da..d18030a 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -998,13 +998,13 @@ int _conn_send_state_req(struct drbd_tconn *tconn, int vnr, enum drbd_packet cmd
 	return conn_send_cmd(tconn, vnr, &tconn->data, cmd, &p.head, sizeof(p));
 }
 
-int drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode)
+void drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode)
 {
 	struct p_req_state_reply p;
 
 	p.retcode    = cpu_to_be32(retcode);
 
-	return !drbd_send_cmd(mdev, &mdev->tconn->meta, P_STATE_CHG_REPLY, &p.head, sizeof(p));
+	drbd_send_cmd(mdev, &mdev->tconn->meta, P_STATE_CHG_REPLY, &p.head, sizeof(p));
 }
 
 int conn_send_sr_reply(struct drbd_tconn *tconn, enum drbd_state_rv retcode)
-- 
1.7.4.1


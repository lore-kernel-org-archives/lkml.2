Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab1IGQq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:46:27 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48578 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab1IGQqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:46:00 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/14] drbd: Move drbd_send_ping() and drbd_send_ping_ack() to drbd_main.c
Date: Wed,  7 Sep 2011 16:17:30 +0200
Message-Id: <1315405061-1473-4-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h  |   13 ++-----------
 drivers/block/drbd/drbd_main.c |   12 ++++++++++++
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 72df107..1aec096 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1939,17 +1939,8 @@ static inline int drbd_send_short_cmd(struct drbd_conf *mdev,
 	return drbd_send_cmd(mdev, &mdev->tconn->data, cmd, &h, sizeof(h));
 }
 
-static inline int drbd_send_ping(struct drbd_tconn *tconn)
-{
-	struct p_header h;
-	return !conn_send_cmd(tconn, 0, &tconn->meta, P_PING, &h, sizeof(h));
-}
-
-static inline int drbd_send_ping_ack(struct drbd_tconn *tconn)
-{
-	struct p_header h;
-	return !conn_send_cmd(tconn, 0, &tconn->meta, P_PING_ACK, &h, sizeof(h));
-}
+extern int drbd_send_ping(struct drbd_tconn *tconn);
+extern int drbd_send_ping_ack(struct drbd_tconn *tconn);
 
 static inline int drbd_send_state_req(struct drbd_conf *mdev,
 				      union drbd_state mask, union drbd_state val)
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 0028b60ca..34627ae 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -765,6 +765,18 @@ int conn_send_cmd2(struct drbd_tconn *tconn, enum drbd_packet cmd, char *data,
 	return err;
 }
 
+int drbd_send_ping(struct drbd_tconn *tconn)
+{
+	struct p_header h;
+	return !conn_send_cmd(tconn, 0, &tconn->meta, P_PING, &h, sizeof(h));
+}
+
+int drbd_send_ping_ack(struct drbd_tconn *tconn)
+{
+	struct p_header h;
+	return !conn_send_cmd(tconn, 0, &tconn->meta, P_PING_ACK, &h, sizeof(h));
+}
+
 int drbd_send_sync_param(struct drbd_conf *mdev)
 {
 	struct p_rs_param_95 *p;
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab1IELvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:51:46 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59839 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab1IELpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:55 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 16/54] drbd: _conn_send_state_req(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:07 +0200
Message-Id: <1315223145-20640-17-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h  |    4 ++--
 drivers/block/drbd/drbd_main.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index a375133..bf2eb2e 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1955,14 +1955,14 @@ static inline int drbd_send_ping_ack(struct drbd_tconn *tconn)
 static inline int drbd_send_state_req(struct drbd_conf *mdev,
 				      union drbd_state mask, union drbd_state val)
 {
-	return _conn_send_state_req(mdev->tconn, mdev->vnr, P_STATE_CHG_REQ, mask, val);
+	return !_conn_send_state_req(mdev->tconn, mdev->vnr, P_STATE_CHG_REQ, mask, val);
 }
 
 static inline int conn_send_state_req(struct drbd_tconn *tconn,
 				      union drbd_state mask, union drbd_state val)
 {
 	enum drbd_packet cmd = tconn->agreed_pro_version < 100 ? P_STATE_CHG_REQ : P_CONN_ST_CHG_REQ;
-	return _conn_send_state_req(tconn, 0, cmd, mask, val);
+	return !_conn_send_state_req(tconn, 0, cmd, mask, val);
 }
 
 static inline void drbd_thread_stop(struct drbd_thread *thi)
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index e3b54ce..93713da 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -995,7 +995,7 @@ int _conn_send_state_req(struct drbd_tconn *tconn, int vnr, enum drbd_packet cmd
 	p.mask    = cpu_to_be32(mask.i);
 	p.val     = cpu_to_be32(val.i);
 
-	return !conn_send_cmd(tconn, vnr, &tconn->data, cmd, &p.head, sizeof(p));
+	return conn_send_cmd(tconn, vnr, &tconn->data, cmd, &p.head, sizeof(p));
 }
 
 int drbd_send_sr_reply(struct drbd_conf *mdev, enum drbd_state_rv retcode)
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab1IELwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:52:06 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60098 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab1IELp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:57 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 18/54] drbd: drbd_send_state_req(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:09 +0200
Message-Id: <1315223145-20640-19-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h   |    2 +-
 drivers/block/drbd/drbd_state.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 14c54bf..a375133 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1955,7 +1955,7 @@ static inline int drbd_send_ping_ack(struct drbd_tconn *tconn)
 static inline int drbd_send_state_req(struct drbd_conf *mdev,
 				      union drbd_state mask, union drbd_state val)
 {
-	return !_conn_send_state_req(mdev->tconn, mdev->vnr, P_STATE_CHG_REQ, mask, val);
+	return _conn_send_state_req(mdev->tconn, mdev->vnr, P_STATE_CHG_REQ, mask, val);
 }
 
 static inline int conn_send_state_req(struct drbd_tconn *tconn,
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 7c548bd..46fee12 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -198,7 +198,7 @@ drbd_req_state(struct drbd_conf *mdev, union drbd_state mask,
 			goto abort;
 		}
 
-		if (!drbd_send_state_req(mdev, mask, val)) {
+		if (drbd_send_state_req(mdev, mask, val)) {
 			rv = SS_CW_FAILED_BY_PEER;
 			if (f & CS_VERBOSE)
 				print_st_err(mdev, os, ns, rv);
-- 
1.7.4.1


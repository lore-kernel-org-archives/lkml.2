Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1IELwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:52:00 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59852 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab1IELp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:57 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 17/54] drbd: conn_send_state_req(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:08 +0200
Message-Id: <1315223145-20640-18-git-send-email-philipp.reisner@linbit.com>
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
index bf2eb2e..14c54bf 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1962,7 +1962,7 @@ static inline int conn_send_state_req(struct drbd_tconn *tconn,
 				      union drbd_state mask, union drbd_state val)
 {
 	enum drbd_packet cmd = tconn->agreed_pro_version < 100 ? P_STATE_CHG_REQ : P_CONN_ST_CHG_REQ;
-	return !_conn_send_state_req(tconn, 0, cmd, mask, val);
+	return _conn_send_state_req(tconn, 0, cmd, mask, val);
 }
 
 static inline void drbd_thread_stop(struct drbd_thread *thi)
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index f1a55d8..7c548bd 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1440,7 +1440,7 @@ conn_cl_wide(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state v
 	spin_unlock_irq(&tconn->req_lock);
 	mutex_lock(&tconn->cstate_mutex);
 
-	if (!conn_send_state_req(tconn, mask, val)) {
+	if (conn_send_state_req(tconn, mask, val)) {
 		rv = SS_CW_FAILED_BY_PEER;
 		/* if (f & CS_VERBOSE)
 		   print_st_err(mdev, os, ns, rv); */
-- 
1.7.4.1


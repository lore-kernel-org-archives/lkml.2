Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933545Ab1IILRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 07:17:43 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45664 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758712Ab1IILRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 07:17:41 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 07/11] drbd: Implemented conn_lowest_conn()
Date: Fri,  9 Sep 2011 13:17:32 +0200
Message-Id: <1315567056-32314-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315567056-32314-1-git-send-email-philipp.reisner@linbit.com>
References: <1315567056-32314-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c |   12 ++++++++++++
 drivers/block/drbd/drbd_state.h |    1 +
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index cfd923e..e441d1f 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -115,6 +115,18 @@ enum drbd_disk_state conn_highest_pdsk(struct drbd_tconn *tconn)
 	return ds;
 }
 
+enum drbd_disk_state conn_lowest_conn(struct drbd_tconn *tconn)
+{
+	enum drbd_conns conn = C_MASK;
+	struct drbd_conf *mdev;
+	int vnr;
+
+	idr_for_each_entry(&tconn->volumes, mdev, vnr)
+		conn = min_t(enum drbd_conns, conn, mdev->state.conn);
+
+	return conn;
+}
+
 /**
  * cl_wide_st_chg() - true if the state change is a cluster wide one
  * @mdev:	DRBD device.
diff --git a/drivers/block/drbd/drbd_state.h b/drivers/block/drbd/drbd_state.h
index 0f8441d..e554537 100644
--- a/drivers/block/drbd/drbd_state.h
+++ b/drivers/block/drbd/drbd_state.h
@@ -154,5 +154,6 @@ enum drbd_role conn_highest_role(struct drbd_tconn *tconn);
 enum drbd_role conn_highest_peer(struct drbd_tconn *tconn);
 enum drbd_disk_state conn_highest_disk(struct drbd_tconn *tconn);
 enum drbd_disk_state conn_highest_pdsk(struct drbd_tconn *tconn);
+enum drbd_disk_state conn_lowest_conn(struct drbd_tconn *tconn);
 
 #endif
-- 
1.7.4.1


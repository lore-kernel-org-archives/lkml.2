Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774Ab1IILTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 07:19:18 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45682 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933276Ab1IILRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 07:17:42 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/11] drbd: Implemented conn_lowest_disk()
Date: Fri,  9 Sep 2011 13:17:33 +0200
Message-Id: <1315567056-32314-9-git-send-email-philipp.reisner@linbit.com>
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
index e441d1f..5db514e 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -103,6 +103,18 @@ enum drbd_disk_state conn_highest_disk(struct drbd_tconn *tconn)
 	return ds;
 }
 
+enum drbd_disk_state conn_lowest_disk(struct drbd_tconn *tconn)
+{
+	enum drbd_disk_state ds = D_MASK;
+	struct drbd_conf *mdev;
+	int vnr;
+
+	idr_for_each_entry(&tconn->volumes, mdev, vnr)
+		ds = min_t(enum drbd_disk_state, ds, mdev->state.disk);
+
+	return ds;
+}
+
 enum drbd_disk_state conn_highest_pdsk(struct drbd_tconn *tconn)
 {
 	enum drbd_disk_state ds = D_DISKLESS;
diff --git a/drivers/block/drbd/drbd_state.h b/drivers/block/drbd/drbd_state.h
index e554537..72e2053 100644
--- a/drivers/block/drbd/drbd_state.h
+++ b/drivers/block/drbd/drbd_state.h
@@ -153,6 +153,7 @@ static inline int drbd_request_state(struct drbd_conf *mdev,
 enum drbd_role conn_highest_role(struct drbd_tconn *tconn);
 enum drbd_role conn_highest_peer(struct drbd_tconn *tconn);
 enum drbd_disk_state conn_highest_disk(struct drbd_tconn *tconn);
+enum drbd_disk_state conn_lowest_disk(struct drbd_tconn *tconn);
 enum drbd_disk_state conn_highest_pdsk(struct drbd_tconn *tconn);
 enum drbd_disk_state conn_lowest_conn(struct drbd_tconn *tconn);
 
-- 
1.7.4.1


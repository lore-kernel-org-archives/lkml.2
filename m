Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab1HYPZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:25:40 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34374 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab1HYPJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:34 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 058/118] drbd: Clean up some left-overs
Date: Thu, 25 Aug 2011 17:07:54 +0200
Message-Id: <1314284934-17999-59-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 37b3488..f39c279 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -668,15 +668,6 @@ struct drbd_tl_epoch {
 	int n_writes;	/* number of requests attached before this barrier */
 };
 
-struct drbd_request;
-
-/* These Tl_epoch_entries may be in one of 6 lists:
-   active_ee .. data packet being written
-   sync_ee   .. syncer block being written
-   done_ee   .. block written, need to send P_WRITE_ACK
-   read_ee   .. [RS]P_DATA_REQUEST being read
-*/
-
 struct drbd_epoch {
 	struct list_head list;
 	unsigned int barrier_nr;
@@ -1041,8 +1032,8 @@ struct drbd_conf {
 	enum write_ordering_e write_ordering;
 	struct list_head active_ee; /* IO in progress (P_DATA gets written to disk) */
 	struct list_head sync_ee;   /* IO in progress (P_RS_DATA_REPLY gets written to disk) */
-	struct list_head done_ee;   /* send ack */
-	struct list_head read_ee;   /* IO in progress (any read) */
+	struct list_head done_ee;   /* need to send P_WRITE_ACK */
+	struct list_head read_ee;   /* [RS]P_DATA_REQUEST being read */
 	struct list_head net_ee;    /* zero-copy network send in progress */
 
 	int next_barrier_nr;
-- 
1.7.4.1


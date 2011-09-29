Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab1I2IQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:16:27 -0400
Received: from mail09.linbit.com ([212.69.161.110]:43464 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab1I2IPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:15:37 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/12] drbd: Rename drbd_{ ee -> peer_req }_has_active_page
Date: Thu, 29 Sep 2011 10:15:27 +0200
Message-Id: <1317284131-17464-9-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317284131-17464-1-git-send-email-philipp.reisner@linbit.com>
References: <1317284131-17464-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_receiver.c |    2 +-
 drivers/block/drbd/drbd_worker.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 53d6dc3..d64aaf3 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1594,7 +1594,7 @@ static inline int drbd_bio_has_active_page(struct bio *bio)
 	return 0;
 }
 
-static inline int drbd_ee_has_active_page(struct drbd_peer_request *peer_req)
+static inline int drbd_peer_req_has_active_page(struct drbd_peer_request *peer_req)
 {
 	struct page *page = peer_req->pages;
 	page_chain_for_each(page) {
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 0eda1f0..8b73589 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -208,7 +208,7 @@ static void reclaim_finished_net_peer_reqs(struct drbd_conf *mdev,
 
 	list_for_each_safe(le, tle, &mdev->net_ee) {
 		peer_req = list_entry(le, struct drbd_peer_request, w.list);
-		if (drbd_ee_has_active_page(peer_req))
+		if (drbd_peer_req_has_active_page(peer_req))
 			break;
 		list_move(le, to_be_freed);
 	}
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index d2317c7..2a80563 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -890,7 +890,7 @@ out:
 /* helper */
 static void move_to_net_ee_or_free(struct drbd_conf *mdev, struct drbd_peer_request *peer_req)
 {
-	if (drbd_ee_has_active_page(peer_req)) {
+	if (drbd_peer_req_has_active_page(peer_req)) {
 		/* This might happen if sendpage() has not finished */
 		int i = (peer_req->i.size + PAGE_SIZE -1) >> PAGE_SHIFT;
 		atomic_add(i, &mdev->pp_in_use_by_net);
-- 
1.7.4.1


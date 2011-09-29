Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab1I2IPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:15:43 -0400
Received: from mail09.linbit.com ([212.69.161.110]:43519 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab1I2IPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:15:39 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 12/12] drbd: Rename drbd_pp_free() to drbd_free_pages()
Date: Thu, 29 Sep 2011 10:15:31 +0200
Message-Id: <1317284131-17464-13-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_receiver.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index eeeedeb..06c6152 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -283,7 +283,7 @@ struct page *drbd_alloc_pages(struct drbd_conf *mdev, unsigned int number,
  * Is also used from inside an other spin_lock_irq(&mdev->tconn->req_lock);
  * Either links the page chain back to the global pool,
  * or returns all pages to the system. */
-static void drbd_pp_free(struct drbd_conf *mdev, struct page *page, int is_net)
+static void drbd_free_pages(struct drbd_conf *mdev, struct page *page, int is_net)
 {
 	atomic_t *a = is_net ? &mdev->pp_in_use_by_net : &mdev->pp_in_use;
 	int i;
@@ -370,7 +370,7 @@ void __drbd_free_peer_req(struct drbd_conf *mdev, struct drbd_peer_request *peer
 {
 	if (peer_req->flags & EE_HAS_DIGEST)
 		kfree(peer_req->digest);
-	drbd_pp_free(mdev, peer_req->pages, is_net);
+	drbd_free_pages(mdev, peer_req->pages, is_net);
 	D_ASSERT(atomic_read(&peer_req->pending_bios) == 0);
 	D_ASSERT(drbd_interval_empty(&peer_req->i));
 	mempool_free(peer_req, drbd_ee_mempool);
@@ -1438,7 +1438,7 @@ static int drbd_drain_block(struct drbd_conf *mdev, int data_size)
 		data_size -= len;
 	}
 	kunmap(page);
-	drbd_pp_free(mdev, page, 0);
+	drbd_free_pages(mdev, page, 0);
 	return err;
 }
 
-- 
1.7.4.1


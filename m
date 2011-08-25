Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab1HYPJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:09:05 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32910 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab1HYPI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:08:59 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 001/118] drbd: Get rid of req_validator_fn typedef
Date: Thu, 25 Aug 2011 17:06:57 +0200
Message-Id: <1314284934-17999-2-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_receiver.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 43beaca..d499aa6 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4270,11 +4270,9 @@ static struct drbd_request *_ack_id_to_req(struct drbd_conf *mdev,
 	return NULL;
 }
 
-typedef struct drbd_request *(req_validator_fn)
-	(struct drbd_conf *mdev, u64 id, sector_t sector);
-
 static int validate_req_change_req_state(struct drbd_conf *mdev,
-	u64 id, sector_t sector, req_validator_fn validator,
+	u64 id, sector_t sector,
+	struct drbd_request *(*validator)(struct drbd_conf *, u64, sector_t),
 	const char *func, enum drbd_req_event what)
 {
 	struct drbd_request *req;
-- 
1.7.4.1


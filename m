Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab1IHMtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:49:36 -0400
Received: from mail09.linbit.com ([212.69.161.110]:37535 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab1IHMpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:45:41 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/16] drbd: Do not segfault if a sync dependency reaches a diskless device
Date: Thu,  8 Sep 2011 14:45:26 +0200
Message-Id: <1315485937-18989-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
References: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_worker.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index ed12cdf..829a2ce 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1321,6 +1321,8 @@ static int _drbd_may_sync_now(struct drbd_conf *mdev)
 	struct drbd_conf *odev = mdev;
 
 	while (1) {
+		if (!odev->ldev)
+			return 1;
 		if (odev->ldev->dc.resync_after == -1)
 			return 1;
 		odev = minor_to_mdev(odev->ldev->dc.resync_after);
-- 
1.7.4.1


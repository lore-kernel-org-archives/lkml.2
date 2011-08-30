Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1H3JI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 05:08:27 -0400
Received: from mail09.linbit.com ([212.69.161.110]:38211 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab1H3JFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:05:53 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/15] drbd: simplify condition in drbd_may_do_local_read()
Date: Tue, 30 Aug 2011 11:05:39 +0200
Message-Id: <1314695149-387-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
References: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

fold
	if (x >= (N+1))
		return 0;
	if (x < N)
		return 0;
into
	if (x != N)
		return 0;

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_req.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 48d313d..7332198 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -663,9 +663,7 @@ static int drbd_may_do_local_read(struct drbd_conf *mdev, sector_t sector, int s
 
 	if (mdev->state.disk == D_UP_TO_DATE)
 		return 1;
-	if (mdev->state.disk >= D_OUTDATED)
-		return 0;
-	if (mdev->state.disk <  D_INCONSISTENT)
+	if (mdev->state.disk != D_INCONSISTENT)
 		return 0;
 	esector = sector + (size >> 9) - 1;
 
-- 
1.7.4.1


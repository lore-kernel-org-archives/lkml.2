Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab1JLM1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:27:40 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33898 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab1JLM1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:27:38 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/13] drbd: Lower log priority for an event that is definitely not an error
Date: Wed, 12 Oct 2011 14:27:23 +0200
Message-Id: <1318422455-17539-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
References: <1318422455-17539-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 9611303..4ba0972 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1084,7 +1084,7 @@ static void drbd_flush(struct drbd_conf *mdev)
 		rv = blkdev_issue_flush(mdev->ldev->backing_bdev, GFP_KERNEL,
 					NULL);
 		if (rv) {
-			dev_err(DEV, "local disk flush failed with status %d\n", rv);
+			dev_info(DEV, "local disk flush failed with status %d\n", rv);
 			/* would rather check on EOPNOTSUPP, but that is not reliable.
 			 * don't try again for ANY return value != 0
 			 * if (rv == -EOPNOTSUPP) */
-- 
1.7.4.1


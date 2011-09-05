Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab1IELuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:50:11 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59870 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab1IELqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:02 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 27/54] drbd: drbd_send_oos(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:18 +0200
Message-Id: <1315223145-20640-28-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_main.c   |    2 +-
 drivers/block/drbd/drbd_worker.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 1e19f2e..c887ff7 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1642,7 +1642,7 @@ int drbd_send_oos(struct drbd_conf *mdev, struct drbd_request *req)
 	p.sector  = cpu_to_be64(req->i.sector);
 	p.blksize = cpu_to_be32(req->i.size);
 
-	return !drbd_send_cmd(mdev, &mdev->tconn->data, P_OUT_OF_SYNC, &p.head, sizeof(p));
+	return drbd_send_cmd(mdev, &mdev->tconn->data, P_OUT_OF_SYNC, &p.head, sizeof(p));
 }
 
 /*
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index e4874ae..a64cb99 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1241,7 +1241,7 @@ int w_send_oos(struct drbd_work *w, int cancel)
 		return 1;
 	}
 
-	ok = drbd_send_oos(mdev, req);
+	ok = !drbd_send_oos(mdev, req);
 	req_mod(req, OOS_HANDED_TO_NETWORK);
 
 	return ok;
-- 
1.7.4.1


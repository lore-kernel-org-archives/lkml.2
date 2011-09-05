Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab1IELqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:46:45 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60098 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab1IELqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:10 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 46/54] drbd: drbd_bm_read() never returns a positive value through drbd_bitmap_io()
Date: Mon,  5 Sep 2011 13:45:37 +0200
Message-Id: <1315223145-20640-47-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_nl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index fe4b106..e6a76ec 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1514,7 +1514,7 @@ int drbd_adm_attach(struct sk_buff *skb, struct genl_info *info)
 		}
 	} else {
 		if (drbd_bitmap_io(mdev, &drbd_bm_read,
-			"read from attaching", BM_LOCKED_MASK) < 0) {
+			"read from attaching", BM_LOCKED_MASK)) {
 			retcode = ERR_IO_MD_DISK;
 			goto force_diskless_dec;
 		}
-- 
1.7.4.1


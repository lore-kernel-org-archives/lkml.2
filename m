Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0DAI5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 04:57:20 -0400
Received: from mail09.linbit.com ([212.69.161.110]:39277 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab0DAI5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 04:57:04 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@lists.linbit.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drbd: lc_element_by_index() never returns NULL
Date: Thu,  1 Apr 2010 10:56:40 +0200
Message-Id: <1270112219-15836-1-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <9736574BB1380E.7050404@linbit.com>
References: <9736574BB1380E.7050404@linbit.com>
In-Reply-To: <9736574BB1380E.7050404@linbit.com>
References: <9736574BB1380E.7050404@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 43e57f3..df01899 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -1336,7 +1336,7 @@ int drbd_rs_del_all(struct drbd_conf *mdev)
 		/* ok, ->resync is there. */
 		for (i = 0; i < mdev->resync->nr_elements; i++) {
 			e = lc_element_by_index(mdev->resync, i);
-			bm_ext = e ? lc_entry(e, struct bm_extent, lce) : NULL;
+			bm_ext = lc_entry(e, struct bm_extent, lce);
 			if (bm_ext->lce.lc_number == LC_FREE)
 				continue;
 			if (bm_ext->lce.lc_number == mdev->resync_wenr) {
-- 
1.6.3.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab1HYPJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:09:37 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33400 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab1HYPJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:20 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 041/118] drbd: Do not access tconn after it was freed
Date: Thu, 25 Aug 2011 17:07:37 +0200
Message-Id: <1314284934-17999-42-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index f464cfa..a9dea6d 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3260,10 +3260,6 @@ static void drbd_delete_device(unsigned int minor)
 	kfree(mdev->p_uuid);
 	/* mdev->p_uuid = NULL; */
 
-	kfree(mdev->tconn->int_dig_out);
-	kfree(mdev->tconn->int_dig_in);
-	kfree(mdev->tconn->int_dig_vv);
-
 	/* cleanup the rest that has been
 	 * allocated from drbd_new_device
 	 * and actually free the mdev itself */
@@ -3377,6 +3373,9 @@ void drbd_free_tconn(struct drbd_tconn *tconn)
 	write_unlock_irq(&global_state_lock);
 
 	kfree(tconn->name);
+	kfree(tconn->int_dig_out);
+	kfree(tconn->int_dig_in);
+	kfree(tconn->int_dig_vv);
 	kfree(tconn);
 }
 
-- 
1.7.4.1


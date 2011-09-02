Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481Ab1IBKDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 06:03:53 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33041 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933009Ab1IBKAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 06:00:51 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/16] drbd: Allow two diskless minors to be connected
Date: Fri,  2 Sep 2011 12:00:35 +0200
Message-Id: <1314957648-13242-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
References: <1314957648-13242-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the context of drbd-8.4 it no longer makes sense to
dissalow that.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 1c83a12..4eeba8f 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3133,12 +3133,6 @@ static int receive_sizes(struct drbd_conf *mdev, enum drbd_packet cmd,
 	p_size = be64_to_cpu(p->d_size);
 	p_usize = be64_to_cpu(p->u_size);
 
-	if (p_size == 0 && mdev->state.disk == D_DISKLESS) {
-		dev_err(DEV, "some backing storage is needed\n");
-		drbd_force_state(mdev, NS(conn, C_DISCONNECTING));
-		return false;
-	}
-
 	/* just store the peer's disk size for now.
 	 * we still need to figure out whether we accept that. */
 	mdev->p_size = p_size;
-- 
1.7.4.1


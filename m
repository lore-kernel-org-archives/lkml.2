Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1HYP3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:29:24 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33986 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab1HYPJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:26 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 045/118] drbd: Initialize the sequence number sent over the network even when not used
Date: Thu, 25 Aug 2011 17:07:41 +0200
Message-Id: <1314284934-17999-46-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 32e44e3..fbd3f04 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2753,7 +2753,7 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
 	prepare_header(mdev, &p.head, cmd, sizeof(p) - sizeof(struct p_header80) + dgs + e->i.size);
 	p.sector   = cpu_to_be64(e->i.sector);
 	p.block_id = e->block_id;
-	/* p.seq_num  = 0;    No sequence numbers here.. */
+	p.seq_num = 0;  /* unused */
 
 	/* Only called by our kernel thread.
 	 * This one may be interrupted by DRBD_SIG and/or DRBD_SIGKILL
-- 
1.7.4.1


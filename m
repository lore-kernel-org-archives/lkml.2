Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965435Ab1JGLaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:30:12 -0400
Received: from mail09.linbit.com ([212.69.161.110]:35852 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759898Ab1JGL1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:27:50 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/12] drbd: Make broadcast events return NO_ERROR
Date: Fri,  7 Oct 2011 13:27:37 +0200
Message-Id: <1317986865-3706-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
References: <1317986865-3706-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Instead of returning a ret_code outside of the range of enum
drbd_ret_code, use NO_ERROR to indicate success.  This way,
ret_code has the same meaning in all packets.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 70f7dd8..caa8ba2 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -3229,7 +3229,7 @@ void drbd_bcast_event(struct drbd_conf *mdev, const struct sib_info *sib)
 	if (!d_out) /* cannot happen, but anyways. */
 		goto nla_put_failure;
 	d_out->minor = mdev_to_minor(mdev);
-	d_out->ret_code = 0;
+	d_out->ret_code = NO_ERROR;
 
 	pr_info("event: minor=%u, conn=%s\n", d_out->minor, mdev->tconn->name);
 
-- 
1.7.4.1


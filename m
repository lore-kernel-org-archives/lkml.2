Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465Ab1JNV7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 17:59:45 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60877 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab1JNV54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 17:57:56 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 06/11] drbd: Allow to create devices with a minor number > minor_count
Date: Fri, 14 Oct 2011 23:57:47 +0200
Message-Id: <1318629472-11110-7-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318629472-11110-1-git-send-email-philipp.reisner@linbit.com>
References: <1318629472-11110-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

The minor_count module/kernel parameter serves to scale the size of drbd's
internal memory pool, but it is no longer a limit for the number of minors or
the minor number.  (Minor numbers can be arbitrarily high within the allowed
limit of 2^20.)

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 3250c8f..4e0c914 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -3086,8 +3086,7 @@ int drbd_adm_add_minor(struct sk_buff *skb, struct genl_info *info)
 	if (retcode != NO_ERROR)
 		goto out;
 
-	/* FIXME drop minor_count parameter, limit to MINORMASK */
-	if (dh->minor >= minor_count) {
+	if (dh->minor > MINORMASK) {
 		drbd_msg_put_info("requested minor out of range");
 		retcode = ERR_INVALID_REQUEST;
 		goto out;
-- 
1.7.4.1


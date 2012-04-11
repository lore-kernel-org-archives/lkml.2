Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336Ab2DKUcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:32:17 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35690 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2DKUcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:32:15 -0400
From: Philippe De Swert <philippedeswert@gmail.com>
To: philippedeswert@gmail.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, john.calixto@modsystems.com,
        prakity@marvell.com, cjb@laptop.org
Subject: [PATCH 1/2] mmc: Avoid null pointer dereference
Date: Wed, 11 Apr 2012 23:31:45 +0300
Message-Id: <1334176305-6183-1-git-send-email-philippedeswert@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the null check on md the code jumped to cmd_done, which then
will dereference md in mmc_blk_put. This patch avoids the possible
null pointer dereference in that case.

Signed-off-by: Philippe De Swert <philippedeswert@gmail.com>
---
 drivers/mmc/card/block.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index b180965..4bed186 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -384,7 +384,7 @@ static int mmc_blk_ioctl_cmd(struct block_device *bdev,
 	md = mmc_blk_get(bdev->bd_disk);
 	if (!md) {
 		err = -EINVAL;
-		goto cmd_done;
+		goto cmd_err;
 	}
 
 	card = md->queue.card;
@@ -483,6 +483,7 @@ cmd_rel_host:
 
 cmd_done:
 	mmc_blk_put(md);
+cmd_err:
 	kfree(idata->buf);
 	kfree(idata);
 	return err;
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab2IGHEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:04:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41049 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab2IGHEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 03:04:05 -0400
MIME-Version: 1.0
Date: Fri, 7 Sep 2012 15:04:05 +0800
Message-ID: <CAPgLHd_T_ApNEibN_VYHzs9fA9YahFwjkfj2T4+UYtPdhzC3zA@mail.gmail.com>
Subject: [PATCH] block: move the dereference below the NULL test
From: Wei Yongjun <weiyj.lk@gmail.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

spatch with a semantic match is used to found this.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/block/swim3.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 89ddab1..25a522d 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -1090,13 +1090,14 @@ static const struct block_device_operations floppy_fops = {
 static void swim3_mb_event(struct macio_dev* mdev, int mb_state)
 {
 	struct floppy_state *fs = macio_get_drvdata(mdev);
-	struct swim3 __iomem *sw = fs->swim3;
+	struct swim3 __iomem *sw;
 
 	if (!fs)
 		return;
 	if (mb_state != MB_FD)
 		return;
 
+	sw = fs->swim3;
 	/* Clear state */
 	out_8(&sw->intr_enable, 0);
 	in_8(&sw->intr);


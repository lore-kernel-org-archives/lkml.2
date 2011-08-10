Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab1HJFm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 01:42:26 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42683 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab1HJFmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 01:42:23 -0400
From: Julia Lawall <julia@diku.dk>
To: Jiandong Zheng <jdzheng@broadcom.com>
Cc: kernel-janitors@vger.kernel.org, Scott Branden <sbranden@broadcom.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/mtd/nand/bcm_umi_nand.c: add missing kfree/ioremap
Date: Wed, 10 Aug 2011 07:42:15 +0200
Message-Id: <1312954935-14592-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The error handling code under the #if should be the same as elsewhere in
the function.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/mtd/nand/bcm_umi_nand.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/bcm_umi_nand.c b/drivers/mtd/nand/bcm_umi_nand.c
index a8ae898..72e8ec2 100644
--- a/drivers/mtd/nand/bcm_umi_nand.c
+++ b/drivers/mtd/nand/bcm_umi_nand.c
@@ -433,8 +433,11 @@ static int __devinit bcm_umi_nand_probe(struct platform_device *pdev)
 
 #if USE_DMA
 	err = nand_dma_init();
-	if (err != 0)
+	if (err != 0) {
+		iounmap(bcm_umi_io_base);
+		kfree(board_mtd);
 		return err;
+	}
 #endif
 
 	/* Figure out the size of the device that we have.


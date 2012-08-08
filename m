Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445Ab2HHNmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:42:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42127 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758211Ab2HHNmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:42:21 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <mtd@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH] mtd: nand: omap: Trivial warn fix
Date: Wed, 8 Aug 2012 19:12:14 +0530
Message-ID: <1344433334-10313-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value is not propagated in some of the error
paths. Fix the same by passing the value to err.

  CC      drivers/mtd/nand/omap2.o
drivers/mtd/nand/omap2.c: In function 'omap_nand_probe':
drivers/mtd/nand/omap2.c:1154: warning: 'err' may be used uninitialized in this function
  LD      drivers/mtd/nand/built-in.o

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/mtd/nand/omap2.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index e9309b3..29a32e5 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1258,6 +1258,7 @@ static int __devinit omap_nand_probe(struct platform_device *pdev)
 			if (rc) {
 				dev_err(&pdev->dev, "DMA engine slave config failed: %d\n",
 					rc);
+				err = rc;
 				goto out_release_mem_region;
 			}
 			info->nand.read_buf   = omap_read_buf_dma_pref;
-- 
1.7.5.4


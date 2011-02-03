Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab1BCENg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:13:36 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:40971 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537Ab1BCENe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:13:34 -0500
Date: Wed, 2 Feb 2011 20:13:31 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 11/19] tc6393xb: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110202201331.31fd0694@queued.net>
In-Reply-To: <20110202195417.228e2656@queued.net>
References: <20110202195417.228e2656@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No need to explicitly set the cell's platform_data/data_size.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/tc6393xb.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index 9a23863..4080a79 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -694,26 +694,8 @@ static int __devinit tc6393xb_probe(struct platform_device *dev)
 	}
 
 	tc6393xb_cells[TC6393XB_CELL_NAND].driver_data = tcpd->nand_data;
-	tc6393xb_cells[TC6393XB_CELL_NAND].platform_data =
-		&tc6393xb_cells[TC6393XB_CELL_NAND];
-	tc6393xb_cells[TC6393XB_CELL_NAND].data_size =
-		sizeof(tc6393xb_cells[TC6393XB_CELL_NAND]);
-
-	tc6393xb_cells[TC6393XB_CELL_MMC].platform_data =
-		&tc6393xb_cells[TC6393XB_CELL_MMC];
-	tc6393xb_cells[TC6393XB_CELL_MMC].data_size =
-		sizeof(tc6393xb_cells[TC6393XB_CELL_MMC]);
-
-	tc6393xb_cells[TC6393XB_CELL_OHCI].platform_data =
-		&tc6393xb_cells[TC6393XB_CELL_OHCI];
-	tc6393xb_cells[TC6393XB_CELL_OHCI].data_size =
-		sizeof(tc6393xb_cells[TC6393XB_CELL_OHCI]);
 
 	tc6393xb_cells[TC6393XB_CELL_FB].driver_data = tcpd->fb_data;
-	tc6393xb_cells[TC6393XB_CELL_FB].platform_data =
-		&tc6393xb_cells[TC6393XB_CELL_FB];
-	tc6393xb_cells[TC6393XB_CELL_FB].data_size =
-		sizeof(tc6393xb_cells[TC6393XB_CELL_FB]);
 
 	ret = mfd_add_devices(&dev->dev, dev->id,
 			tc6393xb_cells, ARRAY_SIZE(tc6393xb_cells),
-- 
1.7.2.3


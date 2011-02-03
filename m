Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab1BCEJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:09:15 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:49330 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab1BCEJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:09:14 -0500
Date: Wed, 2 Feb 2011 20:09:11 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 08/19] t7166xb: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110202200911.150bb58a@queued.net>
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
 drivers/mfd/t7l66xb.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
index 9caeb4a..b9c1e4c 100644
--- a/drivers/mfd/t7l66xb.c
+++ b/drivers/mfd/t7l66xb.c
@@ -384,15 +384,6 @@ static int t7l66xb_probe(struct platform_device *dev)
 	t7l66xb_attach_irq(dev);
 
 	t7l66xb_cells[T7L66XB_CELL_NAND].driver_data = pdata->nand_data;
-	t7l66xb_cells[T7L66XB_CELL_NAND].platform_data =
-		&t7l66xb_cells[T7L66XB_CELL_NAND];
-	t7l66xb_cells[T7L66XB_CELL_NAND].data_size =
-		sizeof(t7l66xb_cells[T7L66XB_CELL_NAND]);
-
-	t7l66xb_cells[T7L66XB_CELL_MMC].platform_data =
-		&t7l66xb_cells[T7L66XB_CELL_MMC];
-	t7l66xb_cells[T7L66XB_CELL_MMC].data_size =
-		sizeof(t7l66xb_cells[T7L66XB_CELL_MMC]);
 
 	ret = mfd_add_devices(&dev->dev, dev->id,
 			      t7l66xb_cells, ARRAY_SIZE(t7l66xb_cells),
-- 
1.7.2.3


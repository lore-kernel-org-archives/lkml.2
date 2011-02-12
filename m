Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab1BLCQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 21:16:18 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:58305 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab1BLCQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 21:16:17 -0500
Date: Fri, 11 Feb 2011 18:16:14 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 14/17] tc6387xb: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110211181614.3500a295@queued.net>
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
 drivers/mfd/tc6387xb.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/tc6387xb.c b/drivers/mfd/tc6387xb.c
index 6315f63..6bf1775 100644
--- a/drivers/mfd/tc6387xb.c
+++ b/drivers/mfd/tc6387xb.c
@@ -190,11 +190,6 @@ static int __devinit tc6387xb_probe(struct platform_device *dev)
 
 	printk(KERN_INFO "Toshiba tc6387xb initialised\n");
 
-	tc6387xb_cells[TC6387XB_CELL_MMC].platform_data =
-		&tc6387xb_cells[TC6387XB_CELL_MMC];
-	tc6387xb_cells[TC6387XB_CELL_MMC].data_size =
-		sizeof(tc6387xb_cells[TC6387XB_CELL_MMC]);
-
 	ret = mfd_add_devices(&dev->dev, dev->id, tc6387xb_cells,
 			      ARRAY_SIZE(tc6387xb_cells), iomem, irq);
 
-- 
1.7.2.3


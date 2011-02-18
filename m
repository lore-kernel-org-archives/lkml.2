Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab1BRDMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:12:41 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51853 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab1BRDIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:08:06 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/29] tc6387xb: mfd_cell is now implicitly available to drivers
Date: Thu, 17 Feb 2011 19:07:21 -0800
Message-Id: <1297998456-7615-15-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
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


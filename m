Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab1BCEEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:04:21 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48081 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab1BCEEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:04:20 -0500
Date: Wed, 2 Feb 2011 20:04:17 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Phil Blundell <pb@handhelds.org>
Subject: [PATCH 05/19] asic3: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110202200417.019f42ca@queued.net>
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
 drivers/mfd/asic3.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 6a1f940..71d2901 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -810,9 +810,6 @@ static int __init asic3_mfd_probe(struct platform_device *pdev,
 	ds1wm_resources[0].start >>= asic->bus_shift;
 	ds1wm_resources[0].end   >>= asic->bus_shift;
 
-	asic3_cell_ds1wm.platform_data = &asic3_cell_ds1wm;
-	asic3_cell_ds1wm.data_size = sizeof(asic3_cell_ds1wm);
-
 	/* MMC */
 	asic->tmio_cnf = ioremap((ASIC3_SD_CONFIG_BASE >> asic->bus_shift) +
 				 mem_sdio->start, 0x400 >> asic->bus_shift);
@@ -824,9 +821,6 @@ static int __init asic3_mfd_probe(struct platform_device *pdev,
 	asic3_mmc_resources[0].start >>= asic->bus_shift;
 	asic3_mmc_resources[0].end   >>= asic->bus_shift;
 
-	asic3_cell_mmc.platform_data = &asic3_cell_mmc;
-	asic3_cell_mmc.data_size = sizeof(asic3_cell_mmc);
-
 	ret = mfd_add_devices(&pdev->dev, pdev->id,
 			&asic3_cell_ds1wm, 1, mem, asic->irq_base);
 	if (ret < 0)
-- 
1.7.2.3


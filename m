Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab1BRDNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:13:24 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51816 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab1BRDH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:07:58 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/29] htc-pasic3: mfd_cell is now implicitly available to drivers
Date: Thu, 17 Feb 2011 19:07:14 -0800
Message-Id: <1297998456-7615-8-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to explicitly set the cell's platform_data/data_size.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/htc-pasic3.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/htc-pasic3.c b/drivers/mfd/htc-pasic3.c
index 7bc7522..079d396 100644
--- a/drivers/mfd/htc-pasic3.c
+++ b/drivers/mfd/htc-pasic3.c
@@ -165,8 +165,6 @@ static int __init pasic3_probe(struct platform_device *pdev)
 		ds1wm_pdata.clock_rate = pdata->clock_rate;
 		/* the first 5 PASIC3 registers control the DS1WM */
 		ds1wm_resources[0].end = (5 << asic->bus_shift) - 1;
-		ds1wm_cell.platform_data = &ds1wm_cell;
-		ds1wm_cell.data_size = sizeof(ds1wm_cell);
 		ret = mfd_add_devices(&pdev->dev, pdev->id,
 				&ds1wm_cell, 1, r, irq);
 		if (ret < 0)
@@ -175,8 +173,6 @@ static int __init pasic3_probe(struct platform_device *pdev)
 
 	if (pdata && pdata->led_pdata) {
 		led_cell.driver_data = pdata->led_pdata;
-		led_cell.platform_data = &led_cell;
-		led_cell.data_size = sizeof(ds1wm_cell);
 		ret = mfd_add_devices(&pdev->dev, pdev->id, &led_cell, 1, r, 0);
 		if (ret < 0)
 			dev_warn(dev, "failed to register LED device\n");
-- 
1.7.2.3


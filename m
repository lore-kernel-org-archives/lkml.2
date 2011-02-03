Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab1BCEFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:05:32 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48085 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065Ab1BCEFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:05:31 -0500
Date: Wed, 2 Feb 2011 20:05:28 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 06/19] htc-pasic3: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110202200528.169e978f@queued.net>
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


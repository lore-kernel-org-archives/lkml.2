Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab1BLCCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 21:02:55 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:44001 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab1BLCCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 21:02:54 -0500
Date: Fri, 11 Feb 2011 18:02:50 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 03/17] jz4740: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110211180250.483936cc@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No need to explicitly set the cell's platform_data/data_size.

Modify clients to use mfd_get_cell helper function instead of
accessing platform_data directly.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/hwmon/jz4740-hwmon.c   |    2 +-
 drivers/mfd/jz4740-adc.c       |    4 ----
 drivers/power/jz4740-battery.c |    2 +-
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/jz4740-hwmon.c b/drivers/hwmon/jz4740-hwmon.c
index 1c8b3d9..40f106d 100644
--- a/drivers/hwmon/jz4740-hwmon.c
+++ b/drivers/hwmon/jz4740-hwmon.c
@@ -112,7 +112,7 @@ static int __devinit jz4740_hwmon_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	hwmon->cell = pdev->dev.platform_data;
+	hwmon->cell = mfd_get_cell(pdev);
 
 	hwmon->irq = platform_get_irq(pdev, 0);
 	if (hwmon->irq < 0) {
diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index 0cc5979..aa518b9 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -232,8 +232,6 @@ const struct mfd_cell jz4740_adc_cells[] = {
 		.name = "jz4740-hwmon",
 		.num_resources = ARRAY_SIZE(jz4740_hwmon_resources),
 		.resources = jz4740_hwmon_resources,
-		.platform_data = (void *)&jz4740_adc_cells[0],
-		.data_size = sizeof(struct mfd_cell),
 
 		.enable = jz4740_adc_cell_enable,
 		.disable = jz4740_adc_cell_disable,
@@ -243,8 +241,6 @@ const struct mfd_cell jz4740_adc_cells[] = {
 		.name = "jz4740-battery",
 		.num_resources = ARRAY_SIZE(jz4740_battery_resources),
 		.resources = jz4740_battery_resources,
-		.platform_data = (void *)&jz4740_adc_cells[1],
-		.data_size = sizeof(struct mfd_cell),
 
 		.enable = jz4740_adc_cell_enable,
 		.disable = jz4740_adc_cell_disable,
diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index 02414db..0938650 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -258,7 +258,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	jz_battery->cell = pdev->dev.platform_data;
+	jz_battery->cell = mfd_get_cell(pdev);
 
 	jz_battery->irq = platform_get_irq(pdev, 0);
 	if (jz_battery->irq < 0) {
-- 
1.7.2.3


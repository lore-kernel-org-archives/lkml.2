Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab1BOWZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 17:25:56 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48960 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756311Ab1BOWZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 17:25:41 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        Florian Fainelli <florian@openwrt.org>, linux-watchdog@vger.kernel.org
Subject: [PATCH 8/9] rdc321x-southbridge: use mfd_data instead of driver_data
Date: Tue, 15 Feb 2011 14:25:28 -0800
Message-Id: <1297808729-21110-9-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297808729-21110-1-git-send-email-dilinger@queued.net>
References: <1297808729-21110-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mfd_data for passing information from mfd drivers to soc
clients.  The mfd_cell's driver_data field is being phased out.

Clients that were using driver_data now access .mfd_data
via mfd_get_data().

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/gpio/rdc321x-gpio.c       |    2 +-
 drivers/mfd/rdc321x-southbridge.c |    4 ++--
 drivers/watchdog/rdc321x_wdt.c    |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/rdc321x-gpio.c b/drivers/gpio/rdc321x-gpio.c
index 897e057..5ecc9e1 100644
--- a/drivers/gpio/rdc321x-gpio.c
+++ b/drivers/gpio/rdc321x-gpio.c
@@ -135,7 +135,7 @@ static int __devinit rdc321x_gpio_probe(struct platform_device *pdev)
 	struct rdc321x_gpio *rdc321x_gpio_dev;
 	struct rdc321x_gpio_pdata *pdata;
 
-	pdata = platform_get_drvdata(pdev);
+	pdata = mfd_get_data(pdev);
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform data supplied\n");
 		return -ENODEV;
diff --git a/drivers/mfd/rdc321x-southbridge.c b/drivers/mfd/rdc321x-southbridge.c
index 5092297..193c940 100644
--- a/drivers/mfd/rdc321x-southbridge.c
+++ b/drivers/mfd/rdc321x-southbridge.c
@@ -61,12 +61,12 @@ static struct mfd_cell rdc321x_sb_cells[] = {
 		.name		= "rdc321x-wdt",
 		.resources	= rdc321x_wdt_resource,
 		.num_resources	= ARRAY_SIZE(rdc321x_wdt_resource),
-		.driver_data	= &rdc321x_wdt_pdata,
+		.mfd_data	= &rdc321x_wdt_pdata,
 	}, {
 		.name		= "rdc321x-gpio",
 		.resources	= rdc321x_gpio_resources,
 		.num_resources	= ARRAY_SIZE(rdc321x_gpio_resources),
-		.driver_data	= &rdc321x_gpio_pdata,
+		.mfd_data	= &rdc321x_gpio_pdata,
 	},
 };
 
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index 3939e53..9fd382d 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -231,7 +231,7 @@ static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
 	struct resource *r;
 	struct rdc321x_wdt_pdata *pdata;
 
-	pdata = platform_get_drvdata(pdev);
+	pdata = mfd_get_data(pdev);
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform data supplied\n");
 		return -ENODEV;
-- 
1.7.2.3


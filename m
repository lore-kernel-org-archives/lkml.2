Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab2KMNv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:51:56 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7154 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2KMNvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:51:53 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 13 Nov 2012 05:51:50 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <grant.likely@secretlab.ca>,
        <linus.walleij@linaro.org>, <broonie@opensource.wolfsonmicro.com>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH RESEND 2/3] mfd: tps6586x: add irq io-resource for rtc sub driver
Date: Tue, 13 Nov 2012 19:18:06 +0530
Message-ID: <1352814487-25886-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1352814487-25886-1-git-send-email-ldewangan@nvidia.com>
References: <1352814487-25886-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add IRQ IORESOURCE for rtc sub driver of this device.
The rtc driver can get the irq by calling platform_get_irq().

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
Reposting in case of patch missed.
Also added Reviewed by Mark as he already reviewed the patches.

 drivers/mfd/tps6586x.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 2cdf1e6..c11539a 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -96,12 +96,22 @@ static const struct tps6586x_irq_data tps6586x_irqs[] = {
 	[TPS6586X_INT_RTC_ALM2] = TPS6586X_IRQ(TPS6586X_INT_MASK4, 1 << 1),
 };
 
+static struct resource tps6586x_rtc_resources[] = {
+	{
+		.start  = TPS6586X_INT_RTC_ALM1,
+		.end	= TPS6586X_INT_RTC_ALM1,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
 static struct mfd_cell tps6586x_cell[] = {
 	{
 		.name = "tps6586x-gpio",
 	},
 	{
 		.name = "tps6586x-rtc",
+		.num_resources = ARRAY_SIZE(tps6586x_rtc_resources),
+		.resources = &tps6586x_rtc_resources[0],
 	},
 	{
 		.name = "tps6586x-onkey",
@@ -562,7 +572,7 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 
 	ret = mfd_add_devices(tps6586x->dev, -1,
 			      tps6586x_cell, ARRAY_SIZE(tps6586x_cell),
-			      NULL, 0, NULL);
+			      NULL, 0, tps6586x->irq_domain);
 	if (ret < 0) {
 		dev_err(&client->dev, "mfd_add_devices failed: %d\n", ret);
 		goto err_mfd_add;
-- 
1.7.1.1


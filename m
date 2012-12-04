Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab2LDCcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 21:32:19 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:47298 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab2LDCcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 21:32:18 -0500
Message-ID: <1354588325.16068.1.camel@phoenix>
Subject: [PATCH] regulator: gpio-regulator: Add ifdef CONFIG_OF guard for
 regulator_gpio_of_match
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Frank Li <Frank.Li@freescale.com>, Lee Jones <lee.jones@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2012 10:32:05 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of_match_ptr and add ifdef CONFIG_OF guard for regulator_gpio_of_match.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/gpio-regulator.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 3ee79c8..2cfd9d3 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -364,10 +364,12 @@ static int gpio_regulator_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#if defined(CONFIG_OF)
 static const struct of_device_id regulator_gpio_of_match[] __devinitconst = {
 	{ .compatible = "regulator-gpio", },
 	{},
 };
+#endif
 
 static struct platform_driver gpio_regulator_driver = {
 	.probe		= gpio_regulator_probe,
@@ -375,7 +377,7 @@ static struct platform_driver gpio_regulator_driver = {
 	.driver		= {
 		.name		= "gpio-regulator",
 		.owner		= THIS_MODULE,
-		.of_match_table = regulator_gpio_of_match,
+		.of_match_table = of_match_ptr(regulator_gpio_of_match),
 	},
 };
 
-- 
1.7.9.5




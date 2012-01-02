Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367Ab2ABFw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 00:52:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:23892 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2ABFvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 00:51:53 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-6a-4f0145f8faab
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, patches@linaro.org
Subject: [RFC][PATCH 3/4] ARM: Exynos: Remove platform data of platform-lcd
 driver
Date: Mon, 02 Jan 2012 11:24:34 +0530
Message-id: <1325483675-21908-4-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1325483675-21908-3-git-send-email-thomas.abraham@linaro.org>
References: <1325483675-21908-1-git-send-email-thomas.abraham@linaro.org>
 <1325483675-21908-2-git-send-email-thomas.abraham@linaro.org>
 <1325483675-21908-3-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the platform data for platform-lcd driver and add platform data for
Hydis hv070wsa lcd panel.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 arch/arm/mach-exynos/mach-origen.c |   25 ++++---------------------
 1 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-exynos/mach-origen.c b/arch/arm/mach-exynos/mach-origen.c
index 23fc5cb..0f08113 100644
--- a/arch/arm/mach-exynos/mach-origen.c
+++ b/arch/arm/mach-exynos/mach-origen.c
@@ -554,31 +554,14 @@ static struct platform_device origen_device_gpiokeys = {
 	},
 };
 
-static void lcd_hv070wsa_set_power(struct plat_lcd_data *pd, unsigned int power)
-{
-	int ret;
-
-	if (power)
-		ret = gpio_request_one(EXYNOS4_GPE3(4),
-					GPIOF_OUT_INIT_HIGH, "GPE3_4");
-	else
-		ret = gpio_request_one(EXYNOS4_GPE3(4),
-					GPIOF_OUT_INIT_LOW, "GPE3_4");
-
-	gpio_free(EXYNOS4_GPE3(4));
-
-	if (ret)
-		pr_err("failed to request gpio for LCD power: %d\n", ret);
-}
-
-static struct plat_lcd_data origen_lcd_hv070wsa_data = {
-	.set_power = lcd_hv070wsa_set_power,
+static struct plat_lcd_hydis_hv070wsa_pdata hv070wsa_pdata = {
+	.gpio		= EXYNOS4_GPE3(4),
 };
 
 static struct platform_device origen_lcd_hv070wsa = {
-	.name			= "platform-lcd",
+	.name			= "hv070wsa",
 	.dev.parent		= &s5p_device_fimd0.dev,
-	.dev.platform_data	= &origen_lcd_hv070wsa_data,
+	.dev.platform_data	= &hv070wsa_pdata,
 };
 
 static struct s3c_fb_pd_win origen_fb_win0 = {
-- 
1.6.6.rc2


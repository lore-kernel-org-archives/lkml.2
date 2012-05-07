Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab2EGRTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:19:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38217 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757530Ab2EGRTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:19:50 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: wm831x-dcdc: Convert to gpio_request_one()
Date: Mon,  7 May 2012 18:19:42 +0100
Message-Id: <1336411182-13466-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336411182-13466-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336411182-13466-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-dcdc.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index f2ab926..13c71c6 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -403,23 +403,17 @@ static __devinit void wm831x_buckv_dvs_init(struct wm831x_dcdc *dcdc,
 	if (!pdata || !pdata->dvs_gpio)
 		return;
 
-	ret = gpio_request(pdata->dvs_gpio, "DCDC DVS");
-	if (ret < 0) {
-		dev_err(wm831x->dev, "Failed to get %s DVS GPIO: %d\n",
-			dcdc->name, ret);
-		return;
-	}
-
 	/* gpiolib won't let us read the GPIO status so pick the higher
 	 * of the two existing voltages so we take it as platform data.
 	 */
 	dcdc->dvs_gpio_state = pdata->dvs_init_state;
 
-	ret = gpio_direction_output(pdata->dvs_gpio, dcdc->dvs_gpio_state);
+	ret = gpio_request_one(pdata->dvs_gpio,
+			       dcdc->dvs_gpio_state ? GPIOF_INIT_HIGH : 0,
+			       "DCDC DVS");
 	if (ret < 0) {
-		dev_err(wm831x->dev, "Failed to enable %s DVS GPIO: %d\n",
+		dev_err(wm831x->dev, "Failed to get %s DVS GPIO: %d\n",
 			dcdc->name, ret);
-		gpio_free(pdata->dvs_gpio);
 		return;
 	}
 
-- 
1.7.10


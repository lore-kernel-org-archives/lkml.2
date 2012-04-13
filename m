Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab2DMIRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:17:17 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:56450 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757329Ab2DMIQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:16:15 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>,
        <linux-kernel@vger.kernel.org>
Cc: Karl Komierowski <karl.komierowski@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arun Murthy <arun.murthy@stericsson.com>
Subject: [PATCH 2/3] power/ab8500_btemp: harden platform data check
Date: Fri, 13 Apr 2012 10:16:06 +0200
Message-ID: <1334304966-18342-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

If no platform data at all is supplied the driver crashes,
extend the checks to be more careful so we can compile in the
driver and boot also without platform data present.

Cc: Arun Murthy <arun.murthy@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/power/ab8500_btemp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index d8bb993..e266f03 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -978,12 +978,12 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 
 	/* get btemp specific platform data */
 	plat_data = pdev->dev.platform_data;
-	di->pdata = plat_data->btemp;
-	if (!di->pdata) {
+	if (!plat_data || !plat_data->btemp) {
 		dev_err(di->dev, "no btemp platform data supplied\n");
 		ret = -EINVAL;
 		goto free_device_info;
 	}
+	di->pdata = plat_data->btemp;
 
 	/* get battery specific platform data */
 	di->bat = plat_data->battery;
-- 
1.7.9.2


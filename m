Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab0EEW5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 18:57:13 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:59623 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807Ab0EEW5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 18:57:06 -0400
From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, bryan.wu@canonical.com,
       amit.kucheria@canonical.com, Jun.Li@freescale.com,
       xiao-lizhang@freescale.com, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv1 2.6.34-rc6 1/3] mxc: gadget: remove 60mhz clock requirement for freescale mx51 usb core
Date: Wed,  5 May 2010 17:56:09 -0500
Message-Id: <1273100171-3235-2-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1273100171-3235-1-git-send-email-Dinh.Nguyen@freescale.com>
References: <1273100171-3235-1-git-send-email-Dinh.Nguyen@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for mx51, usb core is clocked from sources that are not 60mhz.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 drivers/usb/gadget/fsl_mx3_udc.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/fsl_mx3_udc.c b/drivers/usb/gadget/fsl_mx3_udc.c
index 20a802e..d0b8bde 100644
--- a/drivers/usb/gadget/fsl_mx3_udc.c
+++ b/drivers/usb/gadget/fsl_mx3_udc.c
@@ -50,12 +50,14 @@ int fsl_udc_clk_init(struct platform_device *pdev)
 		goto egusb;
 	}
 
-	freq = clk_get_rate(mxc_usb_clk);
-	if (pdata->phy_mode != FSL_USB2_PHY_ULPI &&
-	    (freq < 59999000 || freq > 60001000)) {
-		dev_err(&pdev->dev, "USB_CLK=%lu, should be 60MHz\n", freq);
-		ret = -EINVAL;
-		goto eclkrate;
+	if (!cpu_is_mx51()) {
+		freq = clk_get_rate(mxc_usb_clk);
+		if (pdata->phy_mode != FSL_USB2_PHY_ULPI &&
+		    (freq < 59999000 || freq > 60001000)) {
+			dev_err(&pdev->dev, "USB_CLK=%lu, should be 60MHz\n", freq);
+			ret = -EINVAL;
+			goto eclkrate;
+		}
 	}
 
 	ret = clk_enable(mxc_usb_clk);
-- 
1.6.0.4


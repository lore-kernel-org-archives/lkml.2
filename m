Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031024Ab2B2OUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:20:48 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61345 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030974Ab2B2OUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:20:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of festevam@gmail.com designates 10.236.175.36 as permitted sender) smtp.mail=festevam@gmail.com; dkim=pass header.i=festevam@gmail.com
From: Fabio Estevam <festevam@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com, vinod.koul@intel.com, kernel@pengutronix.de,
        shawn.guo@freescale.com, Fabio Estevam <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 1/2] dma: imx-sdma: Let the driver be probed even if no firware is found
Date: Wed, 29 Feb 2012 11:20:37 -0300
Message-Id: <1330525238-25420-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the device tree case the code bails out when the firmware name cannot be found
or if the firmware fails to be requested.

Fix this behaviour as the SDMA engine can still operate with the built-in
ROM scripts.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/dma/imx-sdma.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index bf736ad..130b994 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1397,15 +1397,12 @@ static int __init sdma_probe(struct platform_device *pdev)
 		 */
 		ret = of_property_read_string(np, "fsl,sdma-ram-script-name",
 					      &fw_name);
-		if (ret) {
+		if (ret)
 			dev_err(&pdev->dev, "failed to get firmware name\n");
-			goto err_init;
-		}
-
-		ret = sdma_get_firmware(sdma, fw_name);
-		if (ret) {
-			dev_err(&pdev->dev, "failed to get firmware\n");
-			goto err_init;
+		else {
+			ret = sdma_get_firmware(sdma, fw_name);
+			if (ret)
+				dev_err(&pdev->dev, "failed to get firmware\n");
 		}
 	}
 
-- 
1.7.1


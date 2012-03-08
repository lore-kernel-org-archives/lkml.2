Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab2CHM1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 07:27:00 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:40425
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756370Ab2CHM0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 07:26:55 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <vinod.koul@intel.com>, <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] dma: imx-sdma: Treat firmware messages as warnings instead of erros
Date: Thu, 8 Mar 2012 09:26:39 -0300
Message-ID: <1331209599-23802-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the SDMA controller can operate without an external firmware being loaded,
treat the firmware related messages as warnings rather than errors.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/dma/imx-sdma.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index c495882..3b7ebd4 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1389,7 +1389,7 @@ static int __init sdma_probe(struct platform_device *pdev)
 	if (pdata) {
 		ret = sdma_get_firmware(sdma, pdata->fw_name);
 		if (ret)
-			dev_err(&pdev->dev, "failed to get firmware from platform data\n");
+			dev_warn(&pdev->dev, "failed to get firmware from platform data\n");
 	} else {
 		/*
 		 * Because that device tree does not encode ROM script address,
@@ -1399,11 +1399,11 @@ static int __init sdma_probe(struct platform_device *pdev)
 		ret = of_property_read_string(np, "fsl,sdma-ram-script-name",
 					      &fw_name);
 		if (ret)
-			dev_err(&pdev->dev, "failed to get firmware name\n");
+			dev_warn(&pdev->dev, "failed to get firmware name\n");
 		else {
 			ret = sdma_get_firmware(sdma, fw_name);
 			if (ret)
-				dev_err(&pdev->dev, "failed to get firmware from device tree\n");
+				dev_warn(&pdev->dev, "failed to get firmware from device tree\n");
 		}
 	}
 
-- 
1.7.1



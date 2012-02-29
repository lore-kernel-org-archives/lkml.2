Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031038Ab2B2OUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:20:51 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53252 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030974Ab2B2OUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:20:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of festevam@gmail.com designates 10.236.125.130 as permitted sender) smtp.mail=festevam@gmail.com; dkim=pass header.i=festevam@gmail.com
From: Fabio Estevam <festevam@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com, vinod.koul@intel.com, kernel@pengutronix.de,
        shawn.guo@freescale.com, Fabio Estevam <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 2/2] dma: imx-sdma: Print a message when firmare fails to be requested
Date: Wed, 29 Feb 2012 11:20:38 -0300
Message-Id: <1330525238-25420-2-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1330525238-25420-1-git-send-email-festevam@gmail.com>
References: <1330525238-25420-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print a message when firmare fails to be requested in the case of platform data being used.

While at it, distinguish between the error messages of the device tree and platform data cases.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/dma/imx-sdma.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 130b994..f0bfc0e 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1388,7 +1388,9 @@ static int __init sdma_probe(struct platform_device *pdev)
 		sdma_add_scripts(sdma, pdata->script_addrs);
 
 	if (pdata) {
-		sdma_get_firmware(sdma, pdata->fw_name);
+		ret = sdma_get_firmware(sdma, pdata->fw_name);
+		if (ret)
+			dev_err(&pdev->dev, "failed to get firmware from platform data\n");
 	} else {
 		/*
 		 * Because that device tree does not encode ROM script address,
@@ -1402,7 +1404,7 @@ static int __init sdma_probe(struct platform_device *pdev)
 		else {
 			ret = sdma_get_firmware(sdma, fw_name);
 			if (ret)
-				dev_err(&pdev->dev, "failed to get firmware\n");
+				dev_err(&pdev->dev, "failed to get firmware from device tree\n");
 		}
 	}
 
-- 
1.7.1


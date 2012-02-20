Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab2BTQuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:50:00 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58404 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab2BTQt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:49:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of festevam@gmail.com designates 10.100.84.20 as permitted sender) smtp.mail=festevam@gmail.com; dkim=pass header.i=festevam@gmail.com
From: Fabio Estevam <festevam@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel@pengutronix.de, shawn.guo@freescale.com, vinod.koul@intel.com,
        dan.j.williams@intel.com, Fabio Estevam <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] dma: imx-sdma: Add error check on sdma_get_firmware
Date: Mon, 20 Feb 2012 14:49:50 -0200
Message-Id: <1329756590-19993-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add error check on sdma_get_firmware for the pdata case.

While at it, distinguish the error message between the pdata and dt cases.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/dma/imx-sdma.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index bf736ad..52a4e6a 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1388,7 +1388,11 @@ static int __init sdma_probe(struct platform_device *pdev)
 		sdma_add_scripts(sdma, pdata->script_addrs);
 
 	if (pdata) {
-		sdma_get_firmware(sdma, pdata->fw_name);
+		ret = sdma_get_firmware(sdma, pdata->fw_name);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to get firmware from pdata\n");
+			goto err_init;
+		}
 	} else {
 		/*
 		 * Because that device tree does not encode ROM script address,
@@ -1404,7 +1408,7 @@ static int __init sdma_probe(struct platform_device *pdev)
 
 		ret = sdma_get_firmware(sdma, fw_name);
 		if (ret) {
-			dev_err(&pdev->dev, "failed to get firmware\n");
+			dev_err(&pdev->dev, "failed to get firmware from DT\n");
 			goto err_init;
 		}
 	}
-- 
1.7.1


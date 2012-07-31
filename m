Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab2GaGfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 02:35:46 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:37315 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752433Ab2GaGfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 02:35:44 -0400
From: Chao Xie <xiechao.mail@gmail.com>
To: haojian.zhuang@gmail.com, cjb@laptop.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Chao Xie <chao.xie@marvell.com>, Chao Xie <xiechao.mail@gmail.com>
Subject: [PATCH] mmc: sdhci: fix the clock APIs for pxav2 and pxav3 driver
Date: Tue, 31 Jul 2012 14:35:25 +0800
Message-Id: <1343716525-7962-1-git-send-email-xiechao.mail@gmail.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 31 Jul 2012 06:35:20.0565 (UTC) FILETIME=[A81D7A50:01CD6EE6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

Signed-off-by: Chao Xie <xiechao.mail@gmail.com>
---
 drivers/mmc/host/sdhci-pxav2.c |    6 +++---
 drivers/mmc/host/sdhci-pxav3.c |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pxav2.c b/drivers/mmc/host/sdhci-pxav2.c
index dbb75bf..4d10159 100644
--- a/drivers/mmc/host/sdhci-pxav2.c
+++ b/drivers/mmc/host/sdhci-pxav2.c
@@ -150,7 +150,7 @@ static int __devinit sdhci_pxav2_probe(struct platform_device *pdev)
 		goto err_clk_get;
 	}
 	pltfm_host->clk = clk;
-	clk_enable(clk);
+	clk_prepare_enable(clk);
 
 	host->quirks = SDHCI_QUIRK_BROKEN_ADMA
 		| SDHCI_QUIRK_BROKEN_TIMEOUT_VAL
@@ -188,7 +188,7 @@ static int __devinit sdhci_pxav2_probe(struct platform_device *pdev)
 	return 0;
 
 err_add_host:
-	clk_disable(clk);
+	clk_disable_unprepare(clk);
 	clk_put(clk);
 err_clk_get:
 	sdhci_pltfm_free(pdev);
@@ -204,7 +204,7 @@ static int __devexit sdhci_pxav2_remove(struct platform_device *pdev)
 
 	sdhci_remove_host(host, 1);
 
-	clk_disable(pltfm_host->clk);
+	clk_disable_unprepare(pltfm_host->clk);
 	clk_put(pltfm_host->clk);
 	sdhci_pltfm_free(pdev);
 	kfree(pxa);
diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index f296956..0f8f698 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -186,14 +186,14 @@ static int __devinit sdhci_pxav3_probe(struct platform_device *pdev)
 	pltfm_host = sdhci_priv(host);
 	pltfm_host->priv = pxa;
 
-	clk = clk_get(dev, "PXA-SDHCLK");
+	clk = clk_get(dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(dev, "failed to get io clock\n");
 		ret = PTR_ERR(clk);
 		goto err_clk_get;
 	}
 	pltfm_host->clk = clk;
-	clk_enable(clk);
+	clk_prepare_enable(clk);
 
 	host->quirks = SDHCI_QUIRK_BROKEN_TIMEOUT_VAL
 		| SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC
@@ -234,7 +234,7 @@ static int __devinit sdhci_pxav3_probe(struct platform_device *pdev)
 	return 0;
 
 err_add_host:
-	clk_disable(clk);
+	clk_disable_unprepare(clk);
 	clk_put(clk);
 err_clk_get:
 	sdhci_pltfm_free(pdev);
@@ -250,7 +250,7 @@ static int __devexit sdhci_pxav3_remove(struct platform_device *pdev)
 
 	sdhci_remove_host(host, 1);
 
-	clk_disable(pltfm_host->clk);
+	clk_disable_unprepare(pltfm_host->clk);
 	clk_put(pltfm_host->clk);
 	sdhci_pltfm_free(pdev);
 	kfree(pxa);
-- 
1.7.0.4


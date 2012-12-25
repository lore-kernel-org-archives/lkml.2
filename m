Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab2LYO7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 09:59:09 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:55869 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab2LYO7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 09:59:00 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 2/3] staging: drm/imx: several bug fixes
Date: Tue, 25 Dec 2012 15:58:38 +0100
Message-Id: <62e9552fa6c829732eef0fce6151acc8f7f286c9.1356447103.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <56060bcfc2aa06b884380d07af72fc5db6ef9685.1356447103.git.LW@KARO-electronics.de>
References: <56060bcfc2aa06b884380d07af72fc5db6ef9685.1356447103.git.LW@KARO-electronics.de>
In-Reply-To: <56060bcfc2aa06b884380d07af72fc5db6ef9685.1356447103.git.LW@KARO-electronics.de>
References: <56060bcfc2aa06b884380d07af72fc5db6ef9685.1356447103.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- convert bogus IS_ERR_OR_NULL() to IS_ERR()
- fix copy/paste error
- check return value of ipu_crtc_init()

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/staging/imx-drm/ipuv3-crtc.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/imx-drm/ipuv3-crtc.c b/drivers/staging/imx-drm/ipuv3-crtc.c
index 1892006..4b3a019 100644
--- a/drivers/staging/imx-drm/ipuv3-crtc.c
+++ b/drivers/staging/imx-drm/ipuv3-crtc.c
@@ -452,7 +452,7 @@ static int ipu_get_resources(struct ipu_crtc *ipu_crtc,
 	int ret;
 
 	ipu_crtc->ipu_ch = ipu_idmac_get(ipu, pdata->dma[0]);
-	if (IS_ERR_OR_NULL(ipu_crtc->ipu_ch)) {
+	if (IS_ERR(ipu_crtc->ipu_ch)) {
 		ret = PTR_ERR(ipu_crtc->ipu_ch);
 		goto err_out;
 	}
@@ -472,7 +472,7 @@ static int ipu_get_resources(struct ipu_crtc *ipu_crtc,
 	if (pdata->dp >= 0) {
 		ipu_crtc->dp = ipu_dp_get(ipu, pdata->dp);
 		if (IS_ERR(ipu_crtc->dp)) {
-			ret = PTR_ERR(ipu_crtc->ipu_ch);
+			ret = PTR_ERR(ipu_crtc->dp);
 			goto err_out;
 		}
 	}
@@ -548,6 +548,8 @@ static int ipu_drm_probe(struct platform_device *pdev)
 	ipu_crtc->dev = &pdev->dev;
 
 	ret = ipu_crtc_init(ipu_crtc, pdata);
+	if (ret)
+		return ret;
 
 	platform_set_drvdata(pdev, ipu_crtc);
 
-- 
1.7.2.5


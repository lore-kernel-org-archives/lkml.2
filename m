Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab2LRReU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:34:20 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:59455 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab2LRReM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:34:12 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: kernel-janitors@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-media@vger.kernel.org
Subject: [PATCH RESEND 4/6] clk: s5p-tv: Fix incorrect usage of IS_ERR_OR_NULL
Date: Wed, 19 Dec 2012 06:34:06 +1300
Message-Id: <1355852048-23188-5-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz>
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend to include mailing lists.

Replace IS_ERR_OR_NULL with IS_ERR on clk_get results.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
CC: Kyungmin Park <kyungmin.park@samsung.com>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-media@vger.kernel.org
---
 drivers/media/platform/s5p-tv/hdmi_drv.c  |   10 +++++-----
 drivers/media/platform/s5p-tv/mixer_drv.c |   10 +++++-----
 drivers/media/platform/s5p-tv/sdo_drv.c   |   10 +++++-----
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 8a9cf43..1c48ca5 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -781,27 +781,27 @@ static int hdmi_resources_init(struct hdmi_device *hdev)
 	/* get clocks, power */
 
 	res->hdmi = clk_get(dev, "hdmi");
-	if (IS_ERR_OR_NULL(res->hdmi)) {
+	if (IS_ERR(res->hdmi)) {
 		dev_err(dev, "failed to get clock 'hdmi'\n");
 		goto fail;
 	}
 	res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
-	if (IS_ERR_OR_NULL(res->sclk_hdmi)) {
+	if (IS_ERR(res->sclk_hdmi)) {
 		dev_err(dev, "failed to get clock 'sclk_hdmi'\n");
 		goto fail;
 	}
 	res->sclk_pixel = clk_get(dev, "sclk_pixel");
-	if (IS_ERR_OR_NULL(res->sclk_pixel)) {
+	if (IS_ERR(res->sclk_pixel)) {
 		dev_err(dev, "failed to get clock 'sclk_pixel'\n");
 		goto fail;
 	}
 	res->sclk_hdmiphy = clk_get(dev, "sclk_hdmiphy");
-	if (IS_ERR_OR_NULL(res->sclk_hdmiphy)) {
+	if (IS_ERR(res->sclk_hdmiphy)) {
 		dev_err(dev, "failed to get clock 'sclk_hdmiphy'\n");
 		goto fail;
 	}
 	res->hdmiphy = clk_get(dev, "hdmiphy");
-	if (IS_ERR_OR_NULL(res->hdmiphy)) {
+	if (IS_ERR(res->hdmiphy)) {
 		dev_err(dev, "failed to get clock 'hdmiphy'\n");
 		goto fail;
 	}
diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
index ca0f297..c1b2e0e 100644
--- a/drivers/media/platform/s5p-tv/mixer_drv.c
+++ b/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -240,27 +240,27 @@ static int mxr_acquire_clocks(struct mxr_device *mdev)
 	struct device *dev = mdev->dev;
 
 	res->mixer = clk_get(dev, "mixer");
-	if (IS_ERR_OR_NULL(res->mixer)) {
+	if (IS_ERR(res->mixer)) {
 		mxr_err(mdev, "failed to get clock 'mixer'\n");
 		goto fail;
 	}
 	res->vp = clk_get(dev, "vp");
-	if (IS_ERR_OR_NULL(res->vp)) {
+	if (IS_ERR(res->vp)) {
 		mxr_err(mdev, "failed to get clock 'vp'\n");
 		goto fail;
 	}
 	res->sclk_mixer = clk_get(dev, "sclk_mixer");
-	if (IS_ERR_OR_NULL(res->sclk_mixer)) {
+	if (IS_ERR(res->sclk_mixer)) {
 		mxr_err(mdev, "failed to get clock 'sclk_mixer'\n");
 		goto fail;
 	}
 	res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
-	if (IS_ERR_OR_NULL(res->sclk_hdmi)) {
+	if (IS_ERR(res->sclk_hdmi)) {
 		mxr_err(mdev, "failed to get clock 'sclk_hdmi'\n");
 		goto fail;
 	}
 	res->sclk_dac = clk_get(dev, "sclk_dac");
-	if (IS_ERR_OR_NULL(res->sclk_dac)) {
+	if (IS_ERR(res->sclk_dac)) {
 		mxr_err(mdev, "failed to get clock 'sclk_dac'\n");
 		goto fail;
 	}
diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index ad68bbe..269d246 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -341,25 +341,25 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 
 	/* acquire clocks */
 	sdev->sclk_dac = clk_get(dev, "sclk_dac");
-	if (IS_ERR_OR_NULL(sdev->sclk_dac)) {
+	if (IS_ERR(sdev->sclk_dac)) {
 		dev_err(dev, "failed to get clock 'sclk_dac'\n");
 		ret = -ENXIO;
 		goto fail;
 	}
 	sdev->dac = clk_get(dev, "dac");
-	if (IS_ERR_OR_NULL(sdev->dac)) {
+	if (IS_ERR(sdev->dac)) {
 		dev_err(dev, "failed to get clock 'dac'\n");
 		ret = -ENXIO;
 		goto fail_sclk_dac;
 	}
 	sdev->dacphy = clk_get(dev, "dacphy");
-	if (IS_ERR_OR_NULL(sdev->dacphy)) {
+	if (IS_ERR(sdev->dacphy)) {
 		dev_err(dev, "failed to get clock 'dacphy'\n");
 		ret = -ENXIO;
 		goto fail_dac;
 	}
 	sclk_vpll = clk_get(dev, "sclk_vpll");
-	if (IS_ERR_OR_NULL(sclk_vpll)) {
+	if (IS_ERR(sclk_vpll)) {
 		dev_err(dev, "failed to get clock 'sclk_vpll'\n");
 		ret = -ENXIO;
 		goto fail_dacphy;
@@ -367,7 +367,7 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	clk_set_parent(sdev->sclk_dac, sclk_vpll);
 	clk_put(sclk_vpll);
 	sdev->fout_vpll = clk_get(dev, "fout_vpll");
-	if (IS_ERR_OR_NULL(sdev->fout_vpll)) {
+	if (IS_ERR(sdev->fout_vpll)) {
 		dev_err(dev, "failed to get clock 'fout_vpll'\n");
 		goto fail_dacphy;
 	}
-- 
1.7.9.5


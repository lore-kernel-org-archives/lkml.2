Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab2LRReO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:34:14 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:64537 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab2LRReM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:34:12 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: kernel-janitors@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>, Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH RESEND 3/6] clk: exynos: Fix incorrect usage of IS_ERR_OR_NULL
Date: Wed, 19 Dec 2012 06:34:05 +1300
Message-Id: <1355852048-23188-4-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz>
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend to include mailing lists.

Replace IS_ERR_OR_NULL with IS_ERR on clk_get results.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
CC: Inki Dae <inki.dae@samsung.com>
CC: Joonyoung Shim <jy0922.shim@samsung.com>
CC: Seung-Woo Kim <sw0312.kim@samsung.com>
CC: Kyungmin Park <kyungmin.park@samsung.com>
CC: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/exynos/exynos_hdmi.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 2c115f8..557ef2f 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -2167,27 +2167,27 @@ static int __devinit hdmi_resources_init(struct hdmi_context *hdata)
 
 	/* get clocks, power */
 	res->hdmi = clk_get(dev, "hdmi");
-	if (IS_ERR_OR_NULL(res->hdmi)) {
+	if (IS_ERR(res->hdmi)) {
 		DRM_ERROR("failed to get clock 'hdmi'\n");
 		goto fail;
 	}
 	res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
-	if (IS_ERR_OR_NULL(res->sclk_hdmi)) {
+	if (IS_ERR(res->sclk_hdmi)) {
 		DRM_ERROR("failed to get clock 'sclk_hdmi'\n");
 		goto fail;
 	}
 	res->sclk_pixel = clk_get(dev, "sclk_pixel");
-	if (IS_ERR_OR_NULL(res->sclk_pixel)) {
+	if (IS_ERR(res->sclk_pixel)) {
 		DRM_ERROR("failed to get clock 'sclk_pixel'\n");
 		goto fail;
 	}
 	res->sclk_hdmiphy = clk_get(dev, "sclk_hdmiphy");
-	if (IS_ERR_OR_NULL(res->sclk_hdmiphy)) {
+	if (IS_ERR(res->sclk_hdmiphy)) {
 		DRM_ERROR("failed to get clock 'sclk_hdmiphy'\n");
 		goto fail;
 	}
 	res->hdmiphy = clk_get(dev, "hdmiphy");
-	if (IS_ERR_OR_NULL(res->hdmiphy)) {
+	if (IS_ERR(res->hdmiphy)) {
 		DRM_ERROR("failed to get clock 'hdmiphy'\n");
 		goto fail;
 	}
-- 
1.7.9.5


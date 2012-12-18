Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab2LRReR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:34:17 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:60912 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab2LRReM (ORCPT
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
Subject: [PATCH RESEND 2/6] clk: exynos: Fix incorrect usage of IS_ERR_OR_NULL
Date: Wed, 19 Dec 2012 06:34:04 +1300
Message-Id: <1355852048-23188-3-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz>
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend to include mailing lists.

Replace IS_ERR_OR_NULL with IS_ERR on clk_get results.

In the fail: path of mixer_resources_init() and vp_resources_init()
the first clk tested cannot be NULL either, so IS_ERR_OR_NULL is
removed from these as well. Other clocks may still be NULL as they
haven't been clk_get'd yet.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
CC: Inki Dae <inki.dae@samsung.com>
CC: Joonyoung Shim <jy0922.shim@samsung.com>
CC: Seung-Woo Kim <sw0312.kim@samsung.com>
CC: Kyungmin Park <kyungmin.park@samsung.com>
CC: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/exynos/exynos_mixer.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_mixer.c b/drivers/gpu/drm/exynos/exynos_mixer.c
index e7fbb82..dbd97c0 100644
--- a/drivers/gpu/drm/exynos/exynos_mixer.c
+++ b/drivers/gpu/drm/exynos/exynos_mixer.c
@@ -972,14 +972,14 @@ static int __devinit mixer_resources_init(struct exynos_drm_hdmi_context *ctx,
 	spin_lock_init(&mixer_res->reg_slock);
 
 	mixer_res->mixer = clk_get(dev, "mixer");
-	if (IS_ERR_OR_NULL(mixer_res->mixer)) {
+	if (IS_ERR(mixer_res->mixer)) {
 		dev_err(dev, "failed to get clock 'mixer'\n");
 		ret = -ENODEV;
 		goto fail;
 	}
 
 	mixer_res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
-	if (IS_ERR_OR_NULL(mixer_res->sclk_hdmi)) {
+	if (IS_ERR(mixer_res->sclk_hdmi)) {
 		dev_err(dev, "failed to get clock 'sclk_hdmi'\n");
 		ret = -ENODEV;
 		goto fail;
@@ -1019,7 +1019,7 @@ static int __devinit mixer_resources_init(struct exynos_drm_hdmi_context *ctx,
 fail:
 	if (!IS_ERR_OR_NULL(mixer_res->sclk_hdmi))
 		clk_put(mixer_res->sclk_hdmi);
-	if (!IS_ERR_OR_NULL(mixer_res->mixer))
+	if (!IS_ERR(mixer_res->mixer))
 		clk_put(mixer_res->mixer);
 	return ret;
 }
@@ -1034,19 +1034,19 @@ static int __devinit vp_resources_init(struct exynos_drm_hdmi_context *ctx,
 	int ret;
 
 	mixer_res->vp = clk_get(dev, "vp");
-	if (IS_ERR_OR_NULL(mixer_res->vp)) {
+	if (IS_ERR(mixer_res->vp)) {
 		dev_err(dev, "failed to get clock 'vp'\n");
 		ret = -ENODEV;
 		goto fail;
 	}
 	mixer_res->sclk_mixer = clk_get(dev, "sclk_mixer");
-	if (IS_ERR_OR_NULL(mixer_res->sclk_mixer)) {
+	if (IS_ERR(mixer_res->sclk_mixer)) {
 		dev_err(dev, "failed to get clock 'sclk_mixer'\n");
 		ret = -ENODEV;
 		goto fail;
 	}
 	mixer_res->sclk_dac = clk_get(dev, "sclk_dac");
-	if (IS_ERR_OR_NULL(mixer_res->sclk_dac)) {
+	if (IS_ERR(mixer_res->sclk_dac)) {
 		dev_err(dev, "failed to get clock 'sclk_dac'\n");
 		ret = -ENODEV;
 		goto fail;
@@ -1077,7 +1077,7 @@ fail:
 		clk_put(mixer_res->sclk_dac);
 	if (!IS_ERR_OR_NULL(mixer_res->sclk_mixer))
 		clk_put(mixer_res->sclk_mixer);
-	if (!IS_ERR_OR_NULL(mixer_res->vp))
+	if (!IS_ERR(mixer_res->vp))
 		clk_put(mixer_res->vp);
 	return ret;
 }
-- 
1.7.9.5


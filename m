Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2JGN4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 09:56:50 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:37092 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2JGN4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 09:56:45 -0400
MIME-Version: 1.0
Date: Sun, 7 Oct 2012 21:56:45 +0800
Message-ID: <CAPgLHd901d8BTm--jrfyLkRSd0BTCvAuEy-DUs+SSzt+WBWzJw@mail.gmail.com>
Subject: [PATCH] gma500: medfield: fix potential NULL pointer dereference in mdfld_dsi_output_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: airlied@linux.ie
Cc: yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference should be moved below the NULL test.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/gma500/mdfld_dsi_output.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/gma500/mdfld_dsi_output.c b/drivers/gpu/drm/gma500/mdfld_dsi_output.c
index 32dba2a..f92932f 100644
--- a/drivers/gpu/drm/gma500/mdfld_dsi_output.c
+++ b/drivers/gpu/drm/gma500/mdfld_dsi_output.c
@@ -500,17 +500,18 @@ void mdfld_dsi_output_init(struct drm_device *dev,
 	struct mdfld_dsi_connector *dsi_connector;
 	struct drm_connector *connector;
 	struct mdfld_dsi_encoder *encoder;
-	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct drm_psb_private *dev_priv;
 	struct panel_info dsi_panel_info;
 	u32 width_mm, height_mm;
 
-	dev_dbg(dev->dev, "init DSI output on pipe %d\n", pipe);
-
 	if (!dev || ((pipe != 0) && (pipe != 2))) {
 		DRM_ERROR("Invalid parameter\n");
 		return;
 	}
 
+	dev_dbg(dev->dev, "init DSI output on pipe %d\n", pipe);
+	dev_priv = dev->dev_private;
+
 	/*create a new connetor*/
 	dsi_connector = kzalloc(sizeof(struct mdfld_dsi_connector), GFP_KERNEL);
 	if (!dsi_connector) {


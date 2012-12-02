Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab2LBNfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 08:35:54 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:54522 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2LBNfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 08:35:53 -0500
MIME-Version: 1.0
Date: Sun, 2 Dec 2012 08:35:52 -0500
Message-ID: <CAPgLHd_=F+YE-a2_MKV+Od655JiVMmymhKmhQZ1wTvQrfnjWVw@mail.gmail.com>
Subject: [PATCH -next] gma500: medfield: fix potential NULL pointer
 dereference in mdfld_dsi_brightness_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: airlied@linux.ie
Cc: yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference to 'sender' should be moved below the NULL test.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/gma500/mdfld_dsi_output.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/gma500/mdfld_dsi_output.c b/drivers/gpu/drm/gma500/mdfld_dsi_output.c
index 637dd84..478f8b9 100644
--- a/drivers/gpu/drm/gma500/mdfld_dsi_output.c
+++ b/drivers/gpu/drm/gma500/mdfld_dsi_output.c
@@ -92,8 +92,8 @@ void mdfld_dsi_brightness_init(struct mdfld_dsi_config *dsi_config, int pipe)
 {
 	struct mdfld_dsi_pkg_sender *sender =
 				mdfld_dsi_get_pkg_sender(dsi_config);
-	struct drm_device *dev = sender->dev;
-	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct drm_device *dev;
+	struct drm_psb_private *dev_priv;
 	u32 gen_ctrl_val;
 
 	if (!sender) {
@@ -101,6 +101,8 @@ void mdfld_dsi_brightness_init(struct mdfld_dsi_config *dsi_config, int pipe)
 		return;
 	}
 
+	dev = sender->dev;
+	dev_priv = dev->dev_private;
 	/* Set default display backlight value to 85% (0xd8)*/
 	mdfld_dsi_send_mcs_short(sender, write_display_brightness, 0xd8, 1,
 				true);



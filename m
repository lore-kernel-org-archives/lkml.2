Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161120Ab2KNKap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:30:45 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52764 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab2KNKao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:30:44 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Clark <rob@ti.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 04/16] staging/omapdrm: Fix spacing coding style in omap_drv.c
Date: Wed, 14 Nov 2012 19:30:38 +0900
Message-Id: <1352889038-14852-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
References: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings fixed.
- WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/omapdrm/omap_drv.c |   36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_drv.c b/drivers/staging/omapdrm/omap_drv.c
index 6ae2f76..d4823fd 100644
--- a/drivers/staging/omapdrm/omap_drv.c
+++ b/drivers/staging/omapdrm/omap_drv.c
@@ -51,9 +51,8 @@ static void omap_fb_output_poll_changed(struct drm_device *dev)
 {
 	struct omap_drm_private *priv = dev->dev_private;
 	DBG("dev=%p", dev);
-	if (priv->fbdev) {
+	if (priv->fbdev)
 		drm_fb_helper_hotplug_event(priv->fbdev);
-	}
 }
 
 static const struct drm_mode_config_funcs omap_mode_config_funcs = {
@@ -85,9 +84,9 @@ static int omap_drm_notifier(struct notifier_block *nb,
 	case OMAP_DSS_HOTPLUG_DISCONNECT: {
 		struct drm_device *dev = drm_device;
 		DBG("hotplug event: evt=%d, dev=%p", evt, dev);
-		if (dev) {
+		if (dev)
 			drm_sysfs_hotplug_event(dev);
-		}
+
 		return NOTIFY_OK;
 	}
 	default:  /* don't care about other events for now */
@@ -211,9 +210,9 @@ static int create_crtc(struct drm_device *dev, struct omap_overlay *ovl,
 			struct drm_encoder *encoder =
 				omap_connector_attached_encoder(
 						priv->connectors[*j]);
-			if (encoder) {
+			if (encoder)
 				mgr = omap_encoder_get_manager(encoder);
-			}
+
 		}
 		(*j)++;
 	}
@@ -232,9 +231,9 @@ static int create_crtc(struct drm_device *dev, struct omap_overlay *ovl,
 			struct drm_encoder *encoder =
 				omap_connector_attached_encoder(
 						priv->connectors[idx]);
-			if (encoder) {
+			if (encoder)
 				mgr = omap_encoder_get_manager(encoder);
-			}
+
 		}
 		(*j)++;
 	}
@@ -353,9 +352,8 @@ static int omap_modeset_init(struct drm_device *dev)
 		 */
 		int max_overlays = min(omap_dss_get_num_overlays(), num_crtc);
 
-		for (i = 0; i < omap_dss_get_num_overlay_managers(); i++) {
+		for (i = 0; i < omap_dss_get_num_overlay_managers(); i++)
 			create_encoder(dev, omap_dss_get_overlay_manager(i));
-		}
 
 		for_each_dss_dev(dssdev) {
 			create_connector(dev, dssdev);
@@ -468,15 +466,13 @@ static int ioctl_gem_cpu_prep(struct drm_device *dev, void *data,
 	VERB("%p:%p: handle=%d, op=%x", dev, file_priv, args->handle, args->op);
 
 	obj = drm_gem_object_lookup(dev, file_priv, args->handle);
-	if (!obj) {
+	if (!obj)
 		return -ENOENT;
-	}
 
 	ret = omap_gem_op_sync(obj, args->op);
 
-	if (!ret) {
+	if (!ret)
 		ret = omap_gem_op_start(obj, args->op);
-	}
 
 	drm_gem_object_unreference_unlocked(obj);
 
@@ -493,16 +489,14 @@ static int ioctl_gem_cpu_fini(struct drm_device *dev, void *data,
 	VERB("%p:%p: handle=%d", dev, file_priv, args->handle);
 
 	obj = drm_gem_object_lookup(dev, file_priv, args->handle);
-	if (!obj) {
+	if (!obj)
 		return -ENOENT;
-	}
 
 	/* XXX flushy, flushy */
 	ret = 0;
 
-	if (!ret) {
+	if (!ret)
 		ret = omap_gem_op_finish(obj, args->op);
-	}
 
 	drm_gem_object_unreference_unlocked(obj);
 
@@ -519,9 +513,8 @@ static int ioctl_gem_info(struct drm_device *dev, void *data,
 	DBG("%p:%p: handle=%d", dev, file_priv, args->handle);
 
 	obj = drm_gem_object_lookup(dev, file_priv, args->handle);
-	if (!obj) {
+	if (!obj)
 		return -ENOENT;
-	}
 
 	args->size = omap_gem_mmap_size(obj);
 	args->offset = omap_gem_mmap_offset(obj);
@@ -595,9 +588,8 @@ static int dev_load(struct drm_device *dev, unsigned long flags)
 	drm_kms_helper_poll_init(dev);
 
 	ret = drm_vblank_init(dev, priv->num_crtcs);
-	if (ret) {
+	if (ret)
 		dev_warn(dev->dev, "could not init vblank\n");
-	}
 
 	return 0;
 }
-- 
1.7.9.5


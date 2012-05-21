Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab2EUHY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:24:59 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53935 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab2EUHY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:24:57 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        Matthew Garrett <mjg@redhat.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Lars-Peter Clausen <lars@metafoo.de>, Axel Lin <axel.lin@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-fbdev@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-omap@vger.kernel.org
Subject: [PATCH] backlight: initialize  struct backlight_properties properly
Date: Mon, 21 May 2012 09:24:35 +0200
Message-Id: <1337585085-4891-1-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In all these files, the .power field was never correctly initialized.

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/gpu/drm/i915/intel_panel.c              |    1 +
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    1 +
 drivers/platform/x86/toshiba_acpi.c             |    1 +
 drivers/video/backlight/da903x_bl.c             |    1 +
 drivers/video/backlight/pcf50633-backlight.c    |    1 +
 drivers/video/backlight/wm831x_bl.c             |    1 +
 drivers/video/omap2/displays/panel-acx565akm.c  |    1 +
 7 files changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index 48177ec..ec4a1e0 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -342,6 +342,7 @@ int intel_panel_setup_backlight(struct drm_device *dev)
 	else
 		return -ENODEV;
 
+	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = intel_panel_get_max_backlight(dev);
 	dev_priv->backlight =
diff --git a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
index 42db254..a0c8222 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -369,6 +369,7 @@ void radeon_legacy_backlight_init(struct radeon_encoder *radeon_encoder,
 		goto error;
 	}
 
+	memset(&props, 0, sizeof(props));
 	props.max_brightness = MAX_RADEON_LEVEL;
 	props.type = BACKLIGHT_RAW;
 	bd = backlight_device_register("radeon_bl", &drm_connector->kdev,
diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index bde32de..d680bb2 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -1095,6 +1095,7 @@ static int __devinit toshiba_acpi_setup_backlight(struct toshiba_acpi_dev *dev)
 	ret = get_tr_backlight_status(dev, &enabled);
 	dev->tr_backlight_supported = !ret;
 
+	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
 
diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index 30e1968..573c7ec 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -136,6 +136,7 @@ static int da903x_backlight_probe(struct platform_device *pdev)
 		da903x_write(data->da903x_dev, DA9034_WLED_CONTROL2,
 				DA9034_WLED_ISET(pdata->output_current));
 
+	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = max_brightness;
 	bl = backlight_device_register(pdev->name, data->da903x_dev, data,
diff --git a/drivers/video/backlight/pcf50633-backlight.c b/drivers/video/backlight/pcf50633-backlight.c
index c65853c..c092159 100644
--- a/drivers/video/backlight/pcf50633-backlight.c
+++ b/drivers/video/backlight/pcf50633-backlight.c
@@ -111,6 +111,7 @@ static int __devinit pcf50633_bl_probe(struct platform_device *pdev)
 	if (!pcf_bl)
 		return -ENOMEM;
 
+	memset(&bl_props, 0, sizeof(bl_props));
 	bl_props.type = BACKLIGHT_RAW;
 	bl_props.max_brightness = 0x3f;
 	bl_props.power = FB_BLANK_UNBLANK;
diff --git a/drivers/video/backlight/wm831x_bl.c b/drivers/video/backlight/wm831x_bl.c
index 5d365de..9e5517a 100644
--- a/drivers/video/backlight/wm831x_bl.c
+++ b/drivers/video/backlight/wm831x_bl.c
@@ -194,6 +194,7 @@ static int wm831x_backlight_probe(struct platform_device *pdev)
 	data->current_brightness = 0;
 	data->isink_reg = isink_reg;
 
+	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = max_isel;
 	bl = backlight_device_register("wm831x", &pdev->dev, data,
diff --git a/drivers/video/omap2/displays/panel-acx565akm.c b/drivers/video/omap2/displays/panel-acx565akm.c
index d26f37a..74e7cf0 100644
--- a/drivers/video/omap2/displays/panel-acx565akm.c
+++ b/drivers/video/omap2/displays/panel-acx565akm.c
@@ -532,6 +532,7 @@ static int acx_panel_probe(struct omap_dss_device *dssdev)
 
 	/*------- Backlight control --------*/
 
+	memset(&props, 0, sizeof(props));
 	props.fb_blank = FB_BLANK_UNBLANK;
 	props.power = FB_BLANK_UNBLANK;
 	props.type = BACKLIGHT_RAW;
-- 
1.7.9.5


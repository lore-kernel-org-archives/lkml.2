Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab1GHIxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:53:01 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40004 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab1GHIw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:52:59 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 03/12] gma500: psb_intel_lvds style
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 08 Jul 2011 09:43:29 +0100
Message-ID: <20110708084326.19581.94514.stgit@localhost.localdomain>
In-Reply-To: <20110708084053.19581.81711.stgit@localhost.localdomain>
References: <20110708084053.19581.81711.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Fixed some stylistic uglies noticed while fixing the previous bug

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_intel_lvds.c |   49 +++++++++++++++----------------
 1 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index 1e1e788..c4111b5 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -30,10 +30,7 @@
 #include "power.h"
 #include <linux/pm_runtime.h>
 
-u32 CoreClock;
-u32 PWMControlRegFreq;
-
-/**
+/*
  * LVDS I2C backlight control macros
  */
 #define BRIGHTNESS_MAX_LEVEL 100
@@ -51,7 +48,7 @@ u32 PWMControlRegFreq;
 #define PSB_BACKLIGHT_PWM_POLARITY_BIT_CLEAR (0xFFFE)
 
 struct psb_intel_lvds_priv {
-	/**
+	/*
 	 * Saved LVDO output states
 	 */
 	uint32_t savePP_ON;
@@ -64,9 +61,8 @@ struct psb_intel_lvds_priv {
 	uint32_t saveBLC_PWM_CTL;
 };
 
-/* MRST defines end */
 
-/**
+/*
  * Returns the maximum level of the backlight duty cycle field.
  */
 static u32 psb_intel_lvds_get_max_backlight(struct drm_device *dev)
@@ -161,7 +157,7 @@ static int psb_lvds_pwm_set_brightness(struct drm_device *dev, int level)
 	return 0;
 }
 
-/**
+/*
  * Set LVDS backlight level either by I2C or PWM
  */
 void psb_intel_lvds_set_brightness(struct drm_device *dev, int level)
@@ -183,10 +179,10 @@ void psb_intel_lvds_set_brightness(struct drm_device *dev, int level)
 		psb_lvds_pwm_set_brightness(dev, level);
 }
 
-/**
+/*
  * Sets the backlight level.
  *
- * \param level backlight level, from 0 to psb_intel_lvds_get_max_backlight().
+ * level: backlight level, from 0 to psb_intel_lvds_get_max_backlight().
  */
 static void psb_intel_lvds_set_backlight(struct drm_device *dev, int level)
 {
@@ -208,7 +204,7 @@ static void psb_intel_lvds_set_backlight(struct drm_device *dev, int level)
 	}
 }
 
-/**
+/*
  * Sets the power state for the panel.
  */
 static void psb_intel_lvds_set_power(struct drm_device *dev,
@@ -501,7 +497,7 @@ static void psb_intel_lvds_mode_set(struct drm_encoder *encoder,
 	REG_WRITE(PFIT_CONTROL, pfit_control);
 }
 
-/**
+/*
  * Detect the LVDS connection.
  *
  * This always returns CONNECTOR_STATUS_CONNECTED.
@@ -514,7 +510,7 @@ static enum drm_connector_status psb_intel_lvds_detect(struct drm_connector
 	return connector_status_connected;
 }
 
-/**
+/*
  * Return the list of DDC modes if available, or the BIOS fixed mode otherwise.
  */
 static int psb_intel_lvds_get_modes(struct drm_connector *connector)
@@ -575,18 +571,18 @@ int psb_intel_lvds_set_property(struct drm_connector *connector,
 {
 	struct drm_encoder *encoder = connector->encoder;
 	struct drm_psb_private *dev_priv;
-	
+
 	if (!encoder)
-	        return -1;
+		return -1;
 
 	dev_priv = encoder->dev->dev_private;
 
 	if (!strcmp(property->name, "scaling mode")) {
-		struct psb_intel_crtc *pPsbCrtc =
+		struct psb_intel_crtc *crtc =
 					to_psb_intel_crtc(encoder->crtc);
 		uint64_t curValue;
 
-		if (!pPsbCrtc)
+		if (!crtc)
 			goto set_prop_error;
 
 		switch (value) {
@@ -613,10 +609,10 @@ int psb_intel_lvds_set_property(struct drm_connector *connector,
 							value))
 			goto set_prop_error;
 
-		if (pPsbCrtc->saved_mode.hdisplay != 0 &&
-		    pPsbCrtc->saved_mode.vdisplay != 0) {
+		if (crtc->saved_mode.hdisplay != 0 &&
+		    crtc->saved_mode.vdisplay != 0) {
 			if (!drm_crtc_helper_set_mode(encoder->crtc,
-						      &pPsbCrtc->saved_mode,
+						      &crtc->saved_mode,
 						      encoder->crtc->x,
 						      encoder->crtc->y,
 						      encoder->crtc->fb))
@@ -629,11 +625,12 @@ int psb_intel_lvds_set_property(struct drm_connector *connector,
 			goto set_prop_error;
 		else {
 #ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
-			struct backlight_device *bd = dev_priv->backlight_device;
+			struct backlight_device *bd =
+					dev_priv->backlight_device;
 			if (bd) {
-        			bd->props.brightness = value;
-	        		backlight_update_status(bd);
-                        }
+				bd->props.brightness = value;
+				backlight_update_status(bd);
+			}
 #endif
 		}
 	} else if (!strcmp(property->name, "DPMS")) {
@@ -749,7 +746,7 @@ void psb_intel_lvds_init(struct drm_device *dev,
 				      dev_priv->backlight_property,
 				      BRIGHTNESS_MAX_LEVEL);
 
-	/**
+	/*
 	 * Set up I2C bus
 	 * FIXME: distroy i2c_bus when exit
 	 */
@@ -797,7 +794,7 @@ void psb_intel_lvds_init(struct drm_device *dev,
 		}
 	}
 
-	/* Failed to get EDID, what about VBT? do we need this?*/
+	/* Failed to get EDID, what about VBT? do we need this? */
 	if (mode_dev->vbt_mode)
 		mode_dev->panel_fixed_mode =
 		    drm_mode_duplicate(dev, mode_dev->vbt_mode);


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab1C3JSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:18:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51161 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932176Ab1C3JSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:18:08 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 03/18] gma500: Make some of the lvds operations non-static
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 30 Mar 2011 09:59:25 +0100
Message-ID: <20110330085923.5897.30219.stgit@localhost.localdomain>
In-Reply-To: <20110330085539.5897.67919.stgit@localhost.localdomain>
References: <20110330085539.5897.67919.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need these as they are also used by the Moorestown LVDS display support.
Make the various needed symbols visible in the headers

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.h           |   15 +++++++++++++++
 drivers/staging/gma500/psb_intel_display.c |    4 ----
 drivers/staging/gma500/psb_intel_lvds.c    |    8 ++++----
 3 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index e7507b1..6de1c8a 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -948,6 +948,21 @@ int psb_set_brightness(struct backlight_device *bd);
 int psb_get_brightness(struct backlight_device *bd);
 struct backlight_device * psb_get_backlight_device(void);
 
+/* mrst_crtc.c */
+extern const struct drm_crtc_helper_funcs mrst_helper_funcs;
+
+/* mrst_lvds.c */
+extern void mrst_lvds_init(struct drm_device *dev,
+		    struct psb_intel_mode_device *mode_dev);
+
+/* psb_intel_lvds.c */
+extern void psb_intel_lvds_prepare(struct drm_encoder *encoder);
+extern void psb_intel_lvds_commit(struct drm_encoder *encoder);
+extern const struct drm_connector_helper_funcs
+					psb_intel_lvds_connector_helper_funcs;
+extern const struct drm_connector_funcs psb_intel_lvds_connector_funcs;
+
+
 /*
  *Debug print bits setting
  */
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index 917d37e..92b423d 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -1335,10 +1335,6 @@ static const struct drm_crtc_helper_funcs psb_intel_helper_funcs = {
 	.commit = psb_intel_crtc_commit,
 };
 
-static const struct drm_crtc_helper_funcs mrst_helper_funcs;
-static const struct drm_crtc_helper_funcs mdfld_helper_funcs;
-const struct drm_crtc_funcs mdfld_intel_crtc_funcs;
-
 const struct drm_crtc_funcs psb_intel_crtc_funcs = {
 	.save = psb_intel_crtc_save,
 	.restore = psb_intel_crtc_restore,
diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index 2de0524..1e07f41 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -449,7 +449,7 @@ bool psb_intel_lvds_mode_fixup(struct drm_encoder *encoder,
 	return true;
 }
 
-static void psb_intel_lvds_prepare(struct drm_encoder *encoder)
+void psb_intel_lvds_prepare(struct drm_encoder *encoder)
 {
 	struct drm_device *dev = encoder->dev;
 	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
@@ -470,7 +470,7 @@ static void psb_intel_lvds_prepare(struct drm_encoder *encoder)
 	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
 }
 
-static void psb_intel_lvds_commit(struct drm_encoder *encoder)
+void psb_intel_lvds_commit(struct drm_encoder *encoder)
 {
 	struct drm_device *dev = encoder->dev;
 	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
@@ -673,14 +673,14 @@ static const struct drm_encoder_helper_funcs psb_intel_lvds_helper_funcs = {
 	.commit = psb_intel_lvds_commit,
 };
 
-static const struct drm_connector_helper_funcs
+const struct drm_connector_helper_funcs
 				psb_intel_lvds_connector_helper_funcs = {
 	.get_modes = psb_intel_lvds_get_modes,
 	.mode_valid = psb_intel_lvds_mode_valid,
 	.best_encoder = psb_intel_best_encoder,
 };
 
-static const struct drm_connector_funcs psb_intel_lvds_connector_funcs = {
+const struct drm_connector_funcs psb_intel_lvds_connector_funcs = {
 	.dpms = drm_helper_connector_dpms,
 	.save = psb_intel_lvds_save,
 	.restore = psb_intel_lvds_restore,


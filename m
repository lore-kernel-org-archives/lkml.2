Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172Ab2LMOMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:12:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44899 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157Ab2LMOMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:12:15 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 185/241] drm/nouveau: silence modesetting spam on pre-gf8 chipsets
Date: Thu, 13 Dec 2012 11:59:10 -0200
Message-Id: <1355407206-17100-186-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit cee59f15a60cc6269a25e3f6fbf1a577d6ab8115 upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/nouveau/nv04_dac.c |   16 ++++++++--------
 drivers/gpu/drm/nouveau/nv04_dfp.c |   14 +++++++-------
 drivers/gpu/drm/nouveau/nv04_tv.c  |    9 ++++-----
 3 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nv04_dac.c b/drivers/gpu/drm/nouveau/nv04_dac.c
index 8300266..9203b7a 100644
--- a/drivers/gpu/drm/nouveau/nv04_dac.c
+++ b/drivers/gpu/drm/nouveau/nv04_dac.c
@@ -210,7 +210,7 @@ out:
 	NVWriteVgaCrtc(dev, 0, NV_CIO_CR_MODE_INDEX, saved_cr_mode);
 
 	if (blue == 0x18) {
-		NV_INFO(dev, "Load detected on head A\n");
+		NV_DEBUG(dev, "Load detected on head A\n");
 		return connector_status_connected;
 	}
 
@@ -323,8 +323,8 @@ nv17_dac_detect(struct drm_encoder *encoder, struct drm_connector *connector)
 
 	if (nv17_dac_sample_load(encoder) &
 	    NV_PRAMDAC_TEST_CONTROL_SENSEB_ALLHI) {
-		NV_INFO(dev, "Load detected on output %c\n",
-			'@' + ffs(dcb->or));
+		NV_DEBUG(dev, "Load detected on output %c\n",
+			 '@' + ffs(dcb->or));
 		return connector_status_connected;
 	} else {
 		return connector_status_disconnected;
@@ -398,9 +398,9 @@ static void nv04_dac_commit(struct drm_encoder *encoder)
 
 	helper->dpms(encoder, DRM_MODE_DPMS_ON);
 
-	NV_INFO(dev, "Output %s is running on CRTC %d using output %c\n",
-		drm_get_connector_name(&nouveau_encoder_connector_get(nv_encoder)->base),
-		nv_crtc->index, '@' + ffs(nv_encoder->dcb->or));
+	NV_DEBUG(dev, "Output %s is running on CRTC %d using output %c\n",
+		 drm_get_connector_name(&nouveau_encoder_connector_get(nv_encoder)->base),
+		 nv_crtc->index, '@' + ffs(nv_encoder->dcb->or));
 }
 
 void nv04_dac_update_dacclk(struct drm_encoder *encoder, bool enable)
@@ -447,8 +447,8 @@ static void nv04_dac_dpms(struct drm_encoder *encoder, int mode)
 		return;
 	nv_encoder->last_dpms = mode;
 
-	NV_INFO(dev, "Setting dpms mode %d on vga encoder (output %d)\n",
-		     mode, nv_encoder->dcb->index);
+	NV_DEBUG(dev, "Setting dpms mode %d on vga encoder (output %d)\n",
+		 mode, nv_encoder->dcb->index);
 
 	nv04_dac_update_dacclk(encoder, mode == DRM_MODE_DPMS_ON);
 }
diff --git a/drivers/gpu/drm/nouveau/nv04_dfp.c b/drivers/gpu/drm/nouveau/nv04_dfp.c
index 2258746..11c9a1a 100644
--- a/drivers/gpu/drm/nouveau/nv04_dfp.c
+++ b/drivers/gpu/drm/nouveau/nv04_dfp.c
@@ -476,9 +476,9 @@ static void nv04_dfp_commit(struct drm_encoder *encoder)
 
 	helper->dpms(encoder, DRM_MODE_DPMS_ON);
 
-	NV_INFO(dev, "Output %s is running on CRTC %d using output %c\n",
-		drm_get_connector_name(&nouveau_encoder_connector_get(nv_encoder)->base),
-		nv_crtc->index, '@' + ffs(nv_encoder->dcb->or));
+	NV_DEBUG(dev, "Output %s is running on CRTC %d using output %c\n",
+		 drm_get_connector_name(&nouveau_encoder_connector_get(nv_encoder)->base),
+		 nv_crtc->index, '@' + ffs(nv_encoder->dcb->or));
 }
 
 static void nv04_dfp_update_backlight(struct drm_encoder *encoder, int mode)
@@ -519,8 +519,8 @@ static void nv04_lvds_dpms(struct drm_encoder *encoder, int mode)
 		return;
 	nv_encoder->last_dpms = mode;
 
-	NV_INFO(dev, "Setting dpms mode %d on lvds encoder (output %d)\n",
-		     mode, nv_encoder->dcb->index);
+	NV_DEBUG(dev, "Setting dpms mode %d on lvds encoder (output %d)\n",
+		 mode, nv_encoder->dcb->index);
 
 	if (was_powersaving && is_powersaving_dpms(mode))
 		return;
@@ -564,8 +564,8 @@ static void nv04_tmds_dpms(struct drm_encoder *encoder, int mode)
 		return;
 	nv_encoder->last_dpms = mode;
 
-	NV_INFO(dev, "Setting dpms mode %d on tmds encoder (output %d)\n",
-		     mode, nv_encoder->dcb->index);
+	NV_DEBUG(dev, "Setting dpms mode %d on tmds encoder (output %d)\n",
+		 mode, nv_encoder->dcb->index);
 
 	nv04_dfp_update_backlight(encoder, mode);
 	nv04_dfp_update_fp_control(encoder, mode);
diff --git a/drivers/gpu/drm/nouveau/nv04_tv.c b/drivers/gpu/drm/nouveau/nv04_tv.c
index 3eb605d..886231b 100644
--- a/drivers/gpu/drm/nouveau/nv04_tv.c
+++ b/drivers/gpu/drm/nouveau/nv04_tv.c
@@ -69,8 +69,8 @@ static void nv04_tv_dpms(struct drm_encoder *encoder, int mode)
 	struct nv04_mode_state *state = &dev_priv->mode_reg;
 	uint8_t crtc1A;
 
-	NV_INFO(dev, "Setting dpms mode %d on TV encoder (output %d)\n",
-		mode, nv_encoder->dcb->index);
+	NV_DEBUG(dev, "Setting dpms mode %d on TV encoder (output %d)\n",
+		 mode, nv_encoder->dcb->index);
 
 	state->pllsel &= ~(PLLSEL_TV_CRTC1_MASK | PLLSEL_TV_CRTC2_MASK);
 
@@ -162,9 +162,8 @@ static void nv04_tv_commit(struct drm_encoder *encoder)
 
 	helper->dpms(encoder, DRM_MODE_DPMS_ON);
 
-	NV_INFO(dev, "Output %s is running on CRTC %d using output %c\n",
-		      drm_get_connector_name(&nouveau_encoder_connector_get(nv_encoder)->base), nv_crtc->index,
-		      '@' + ffs(nv_encoder->dcb->or));
+	NV_DEBUG(dev, "Output %s is running on CRTC %d using output %c\n",
+		 drm_get_connector_name(&nouveau_encoder_connector_get(nv_encoder)->base), nv_crtc->index, '@' + ffs(nv_encoder->dcb->or));
 }
 
 static void nv04_tv_destroy(struct drm_encoder *encoder)
-- 
1.7.9.5


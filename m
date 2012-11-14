Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab2KNGLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:11:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54910 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710Ab2KNFt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:49:56 -0500
Message-Id: <20121114053934.215871322@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:36 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 03/82] drm/nouveau: silence modesetting spam on pre-gf8 chipsets
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit cee59f15a60cc6269a25e3f6fbf1a577d6ab8115 upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/nouveau/nv04_dac.c | 8 ++++----
 drivers/gpu/drm/nouveau/nv04_dfp.c | 6 +++---
 drivers/gpu/drm/nouveau/nv04_tv.c  | 4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nv04_dac.c b/drivers/gpu/drm/nouveau/nv04_dac.c
index 38f1947..09ac275 100644
--- a/drivers/gpu/drm/nouveau/nv04_dac.c
+++ b/drivers/gpu/drm/nouveau/nv04_dac.c
@@ -210,7 +210,7 @@ out:
 	NVWriteVgaCrtc(dev, 0, NV_CIO_CR_MODE_INDEX, saved_cr_mode);
 
 	if (blue == 0x18) {
-		NV_INFO(dev, "Load detected on head A\n");
+		NV_DEBUG(dev, "Load detected on head A\n");
 		return connector_status_connected;
 	}
 
@@ -323,7 +323,7 @@ nv17_dac_detect(struct drm_encoder *encoder, struct drm_connector *connector)
 
 	if (nv17_dac_sample_load(encoder) &
 	    NV_PRAMDAC_TEST_CONTROL_SENSEB_ALLHI) {
-		NV_INFO(dev, "Load detected on output %c\n",
+		NV_DEBUG(dev, "Load detected on output %c\n",
 			'@' + ffs(dcb->or));
 		return connector_status_connected;
 	} else {
@@ -398,7 +398,7 @@ static void nv04_dac_commit(struct drm_encoder *encoder)
 
 	helper->dpms(encoder, DRM_MODE_DPMS_ON);
 
-	NV_INFO(dev, "Output %s is running on CRTC %d using output %c\n",
+	NV_DEBUG(dev, "Output %s is running on CRTC %d using output %c\n",
 		drm_get_connector_name(&nouveau_encoder_connector_get(nv_encoder)->base),
 		nv_crtc->index, '@' + ffs(nv_encoder->dcb->or));
 }
@@ -447,7 +447,7 @@ static void nv04_dac_dpms(struct drm_encoder *encoder, int mode)
 		return;
 	nv_encoder->last_dpms = mode;
 
-	NV_INFO(dev, "Setting dpms mode %d on vga encoder (output %d)\n",
+	NV_DEBUG(dev, "Setting dpms mode %d on vga encoder (output %d)\n",
 		     mode, nv_encoder->dcb->index);
 
 	nv04_dac_update_dacclk(encoder, mode == DRM_MODE_DPMS_ON);
diff --git a/drivers/gpu/drm/nouveau/nv04_dfp.c b/drivers/gpu/drm/nouveau/nv04_dfp.c
index c267562..89640f2 100644
--- a/drivers/gpu/drm/nouveau/nv04_dfp.c
+++ b/drivers/gpu/drm/nouveau/nv04_dfp.c
@@ -476,7 +476,7 @@ static void nv04_dfp_commit(struct drm_encoder *encoder)
 
 	helper->dpms(encoder, DRM_MODE_DPMS_ON);
 
-	NV_INFO(dev, "Output %s is running on CRTC %d using output %c\n",
+	NV_DEBUG(dev, "Output %s is running on CRTC %d using output %c\n",
 		drm_get_connector_name(&nouveau_encoder_connector_get(nv_encoder)->base),
 		nv_crtc->index, '@' + ffs(nv_encoder->dcb->or));
 }
@@ -519,7 +519,7 @@ static void nv04_lvds_dpms(struct drm_encoder *encoder, int mode)
 		return;
 	nv_encoder->last_dpms = mode;
 
-	NV_INFO(dev, "Setting dpms mode %d on lvds encoder (output %d)\n",
+	NV_DEBUG(dev, "Setting dpms mode %d on lvds encoder (output %d)\n",
 		     mode, nv_encoder->dcb->index);
 
 	if (was_powersaving && is_powersaving_dpms(mode))
@@ -564,7 +564,7 @@ static void nv04_tmds_dpms(struct drm_encoder *encoder, int mode)
 		return;
 	nv_encoder->last_dpms = mode;
 
-	NV_INFO(dev, "Setting dpms mode %d on tmds encoder (output %d)\n",
+	NV_DEBUG(dev, "Setting dpms mode %d on tmds encoder (output %d)\n",
 		     mode, nv_encoder->dcb->index);
 
 	nv04_dfp_update_backlight(encoder, mode);
diff --git a/drivers/gpu/drm/nouveau/nv04_tv.c b/drivers/gpu/drm/nouveau/nv04_tv.c
index 3eb605d..4de1fbe 100644
--- a/drivers/gpu/drm/nouveau/nv04_tv.c
+++ b/drivers/gpu/drm/nouveau/nv04_tv.c
@@ -69,7 +69,7 @@ static void nv04_tv_dpms(struct drm_encoder *encoder, int mode)
 	struct nv04_mode_state *state = &dev_priv->mode_reg;
 	uint8_t crtc1A;
 
-	NV_INFO(dev, "Setting dpms mode %d on TV encoder (output %d)\n",
+	NV_DEBUG(dev, "Setting dpms mode %d on TV encoder (output %d)\n",
 		mode, nv_encoder->dcb->index);
 
 	state->pllsel &= ~(PLLSEL_TV_CRTC1_MASK | PLLSEL_TV_CRTC2_MASK);
@@ -162,7 +162,7 @@ static void nv04_tv_commit(struct drm_encoder *encoder)
 
 	helper->dpms(encoder, DRM_MODE_DPMS_ON);
 
-	NV_INFO(dev, "Output %s is running on CRTC %d using output %c\n",
+	NV_DEBUG(dev, "Output %s is running on CRTC %d using output %c\n",
 		      drm_get_connector_name(&nouveau_encoder_connector_get(nv_encoder)->base), nv_crtc->index,
 		      '@' + ffs(nv_encoder->dcb->or));
 }



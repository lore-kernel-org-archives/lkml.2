Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1I0GMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:12:09 -0400
Received: from home.keithp.com ([63.227.221.253]:55067 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab1I0GMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:12:07 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 2/9] drm/i915: Use DRM_DEBUG_KMS for all messages in intel_bios.c
Date: Mon, 26 Sep 2011 23:11:39 -0700
Message-Id: <1317103906-4649-3-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317103906-4649-1-git-send-email-keithp@keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com>
 <1317103906-4649-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are all KMS related anyways, so don't hide them under other
debug levels.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_bios.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index 4c530fa..dcbc839 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -309,6 +309,11 @@ parse_general_features(struct drm_i915_private *dev_priv,
 		dev_priv->lvds_use_ssc = general->enable_ssc;
 		dev_priv->lvds_ssc_freq =
 			intel_bios_ssc_frequency(dev, general->ssc_freq);
+		DRM_DEBUG_KMS("BDB_GENERAL_FEATURES int_tv_support %d int_crt_support %d lvds_use_ssc %d lvds_ssc_freq %d\n",
+			      dev_priv->int_tv_support,
+			      dev_priv->int_crt_support,
+			      dev_priv->lvds_use_ssc,
+			      dev_priv->lvds_ssc_freq);
 	}
 }
 
@@ -610,7 +615,7 @@ init_vbt_defaults(struct drm_i915_private *dev_priv)
 	/* Default to using SSC */
 	dev_priv->lvds_use_ssc = 1;
 	dev_priv->lvds_ssc_freq = intel_bios_ssc_frequency(dev, 1);
-	DRM_DEBUG("Set default to SSC at %dMHz\n", dev_priv->lvds_ssc_freq);
+	DRM_DEBUG_KMS("Set default to SSC at %dMHz\n", dev_priv->lvds_ssc_freq);
 
 	/* eDP data */
 	dev_priv->edp.bpp = 18;
@@ -639,7 +644,7 @@ intel_parse_bios(struct drm_device *dev)
 	if (dev_priv->opregion.vbt) {
 		struct vbt_header *vbt = dev_priv->opregion.vbt;
 		if (memcmp(vbt->signature, "$VBT", 4) == 0) {
-			DRM_DEBUG_DRIVER("Using VBT from OpRegion: %20s\n",
+			DRM_DEBUG_KMS("Using VBT from OpRegion: %20s\n",
 					 vbt->signature);
 			bdb = (struct bdb_header *)((char *)vbt + vbt->bdb_offset);
 		} else
-- 
1.7.6.3


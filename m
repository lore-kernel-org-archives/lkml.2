Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1I0GMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:12:06 -0400
Received: from home.keithp.com ([63.227.221.253]:55053 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab1I0GME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:12:04 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 5/9] drm/i915: Allow SSC parameter to override VBT value
Date: Mon, 26 Sep 2011 23:11:42 -0700
Message-Id: <1317103906-4649-6-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317103906-4649-1-git-send-email-keithp@keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com>
 <1317103906-4649-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow SSC to be enabled even when the BIOS disables it for testing SSC paths.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_drv.c      |    4 ++--
 drivers/gpu/drm/i915/intel_display.c |    4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index f07e425..58480de 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -79,11 +79,11 @@ MODULE_PARM_DESC(lvds_downclock,
 		"Use panel (LVDS/eDP) downclocking for power savings "
 		"(default: false)");
 
-unsigned int i915_panel_use_ssc __read_mostly = 1;
+unsigned int i915_panel_use_ssc __read_mostly = -1;
 module_param_named(lvds_use_ssc, i915_panel_use_ssc, int, 0600);
 MODULE_PARM_DESC(lvds_use_ssc,
 		"Use Spread Spectrum Clock with panels [LVDS/eDP] "
-		"(default: true)");
+		"(default: auto from VBT)");
 
 int i915_vbt_sdvo_panel_type __read_mostly = -1;
 module_param_named(vbt_sdvo_panel_type, i915_vbt_sdvo_panel_type, int, 0600);
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 04411ad..6039496 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4584,7 +4584,9 @@ static void intel_update_watermarks(struct drm_device *dev)
 
 static inline bool intel_panel_use_ssc(struct drm_i915_private *dev_priv)
 {
-	return dev_priv->lvds_use_ssc && i915_panel_use_ssc
+	if (i915_panel_use_ssc >= 0)
+		return i915_panel_use_ssc != 0;
+	return dev_priv->lvds_use_ssc
 		&& !(dev_priv->quirks & QUIRK_LVDS_SSC_DISABLE);
 }
 
-- 
1.7.6.3


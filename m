Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab1I0GMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:12:30 -0400
Received: from home.keithp.com ([63.227.221.253]:55091 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab1I0GMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:12:12 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 7/9] drm/i915: Use CK505 as non-SSC source where available
Date: Mon, 26 Sep 2011 23:11:44 -0700
Message-Id: <1317103906-4649-8-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317103906-4649-1-git-send-email-keithp@keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com>
 <1317103906-4649-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This eliminates VGA shimmer on some Ironlake machines which have a
CK505 clock source.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_display.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index f999935..66cd351 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5137,8 +5137,10 @@ static void ironlake_update_pch_refclk(struct drm_device *dev)
 			break;
 		}
 	}
-	DRM_DEBUG_KMS("has_panel %d has_lvds %d has_pch_edp %d has_cpu_edp %d\n",
-		      has_panel, has_lvds, has_pch_edp, has_cpu_edp);
+
+	DRM_DEBUG_KMS("has_panel %d has_lvds %d has_pch_edp %d has_cpu_edp %d has_ck505 %d\n",
+		      has_panel, has_lvds, has_pch_edp, has_cpu_edp,
+		      dev_priv->display_clock_mode);  
 
 	/* Ironlake: try to setup display ref clock before DPLL
 	 * enabling. This is only under driver's control after
@@ -5148,7 +5150,11 @@ static void ironlake_update_pch_refclk(struct drm_device *dev)
 	temp = I915_READ(PCH_DREF_CONTROL);
 	/* Always enable nonspread source */
 	temp &= ~DREF_NONSPREAD_SOURCE_MASK;
-	temp |= DREF_NONSPREAD_SOURCE_ENABLE;
+
+	if (dev_priv->display_clock_mode)
+		temp |= DREF_NONSPREAD_CK505_ENABLE;
+	else
+		temp |= DREF_NONSPREAD_SOURCE_ENABLE;
 
 	if (has_panel) {
 		temp &= ~DREF_SSC_SOURCE_MASK;
-- 
1.7.6.3


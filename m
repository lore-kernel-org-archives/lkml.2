Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab1I3BKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:10:30 -0400
Received: from home.keithp.com ([63.227.221.253]:49873 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500Ab1I3BK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:10:28 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 16/21] drm/i915: edp_panel_on does not need to return a bool
Date: Thu, 29 Sep 2011 18:09:48 -0700
Message-Id: <1317344993-24945-17-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317344993-24945-1-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value was unused, so just stop doing that.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 02b5162..56146a2 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -886,14 +886,14 @@ static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp)
 }
 
 /* Returns true if the panel was already on when called */
-static bool ironlake_edp_panel_on (struct intel_dp *intel_dp)
+static void ironlake_edp_panel_on (struct intel_dp *intel_dp)
 {
 	struct drm_device *dev = intel_dp->base.base.dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32 pp, idle_on_mask = PP_ON | PP_SEQUENCE_STATE_ON_IDLE;
 
 	if (I915_READ(PCH_PP_STATUS) & PP_ON)
-		return true;
+		return;
 
 	pp = I915_READ(PCH_PP_CONTROL);
 	pp &= ~PANEL_UNLOCK_MASK;
@@ -916,8 +916,6 @@ static bool ironlake_edp_panel_on (struct intel_dp *intel_dp)
 	pp |= PANEL_POWER_RESET; /* restore panel reset bit */
 	I915_WRITE(PCH_PP_CONTROL, pp);
 	POSTING_READ(PCH_PP_CONTROL);
-
-	return false;
 }
 
 static void ironlake_edp_panel_off(struct drm_encoder *encoder)
-- 
1.7.6.3


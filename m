Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab1I3BL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:11:56 -0400
Received: from home.keithp.com ([63.227.221.253]:49879 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756466Ab1I3BK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:10:26 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 12/21] drm/i915: Ensure eDP powered up during DP_SET_POWER operation in dp_prepare
Date: Thu, 29 Sep 2011 18:09:44 -0700
Message-Id: <1317344993-24945-13-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317344993-24945-1-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any call to intel_dp_sink_dpms must ensure that the panel has power so
that the DP_SET_POWER operation will be correctly received. The only
one missing this was in intel_dp_prepare.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 414aef7..a091a18 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1028,7 +1028,9 @@ static void intel_dp_prepare(struct drm_encoder *encoder)
 	struct drm_device *dev = encoder->dev;
 
 	/* Wake up the sink first */
+	ironlake_edp_panel_vdd_on(intel_dp);
 	intel_dp_sink_dpms(intel_dp, DRM_MODE_DPMS_ON);
+	ironlake_edp_panel_vdd_off(intel_dp);
 
 	if (is_edp(intel_dp)) {
 		ironlake_edp_backlight_off(dev);
-- 
1.7.6.3


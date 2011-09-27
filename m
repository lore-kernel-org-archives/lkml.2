Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1I0GMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:12:50 -0400
Received: from home.keithp.com ([63.227.221.253]:55081 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313Ab1I0GMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:12:09 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 8/9] drm/i915: All PCH refclks are 120MHz
Date: Mon, 26 Sep 2011 23:11:45 -0700
Message-Id: <1317103906-4649-9-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317103906-4649-1-git-send-email-keithp@keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com>
 <1317103906-4649-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't find any reference clocks which run at 96MHz as seems to be
indicated from the comments in this code.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_display.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 66cd351..919db79 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5271,16 +5271,10 @@ static int ironlake_crtc_mode_set(struct drm_crtc *crtc,
 		num_connectors++;
 	}
 
-	if (is_lvds && intel_panel_use_ssc(dev_priv) && num_connectors < 2) {
-		refclk = dev_priv->lvds_ssc_freq * 1000;
-		DRM_DEBUG_KMS("using SSC reference clock of %d MHz\n",
-			      refclk / 1000);
-	} else {
-		refclk = 96000;
-		if (!has_edp_encoder ||
-		    intel_encoder_is_pch_edp(&has_edp_encoder->base))
-			refclk = 120000; /* 120Mhz refclk */
-	}
+	/*
+	 * Every reference clock in a PCH system is 120MHz
+	 */
+	refclk = 120000;
 
 	/*
 	 * Returns a set of divisors for the desired target clock with the given
-- 
1.7.6.3


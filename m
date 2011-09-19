Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845Ab1ISWYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:24:22 -0400
Received: from home.keithp.com ([63.227.221.253]:41866 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756713Ab1ISWWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:22:19 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 2/9] drm/i915: Remove extra 300ms delay during eDP mode setting
Date: Mon, 19 Sep 2011 15:21:56 -0700
Message-Id: <1316470923-27832-3-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1316470923-27832-1-git-send-email-keithp@keithp.com>
References: <1316470923-27832-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason to enforce a 300ms delay during eDP mode setting.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 44fef5e..f0cfb6b 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -903,13 +903,6 @@ static void ironlake_edp_backlight_on (struct drm_device *dev)
 	u32 pp;
 
 	DRM_DEBUG_KMS("\n");
-	/*
-	 * If we enable the backlight right away following a panel power
-	 * on, we may see slight flicker as the panel syncs with the eDP
-	 * link.  So delay a bit to make sure the image is solid before
-	 * allowing it to appear.
-	 */
-	msleep(300);
 	pp = I915_READ(PCH_PP_CONTROL);
 	pp |= EDP_BLC_ENABLE;
 	I915_WRITE(PCH_PP_CONTROL, pp);
-- 
1.7.6.3


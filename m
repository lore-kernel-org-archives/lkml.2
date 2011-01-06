Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1AFBC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 20:02:26 -0500
Received: from kroah.org ([198.145.64.141]:35407 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763Ab1AFA2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:28:55 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:57 2011
Message-Id: <20110106002257.831239560@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:21:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Anholt <eric@anholt.net>, Chris Wilson <chris@chris-wilson.co.uk>
Subject: [012/152] drm/i915: Always set the DP transcoder config to 8BPC.
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Anholt <eric@anholt.net>

commit 220cad3cbf553f893432919b458da36489373fc6 upstream.

The pipe is always set to 8BPC, but here we were leaving whatever
previous bits were set by the BIOS in place.

Signed-off-by: Eric Anholt <eric@anholt.net>
Tested-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_reg.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2953,6 +2953,7 @@
 #define  TRANS_DP_10BPC		(1<<9)
 #define  TRANS_DP_6BPC		(2<<9)
 #define  TRANS_DP_12BPC		(3<<9)
+#define  TRANS_DP_BPC_MASK	(3<<9)
 #define  TRANS_DP_VSYNC_ACTIVE_HIGH	(1<<4)
 #define  TRANS_DP_VSYNC_ACTIVE_LOW	0
 #define  TRANS_DP_HSYNC_ACTIVE_HIGH	(1<<3)
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2044,9 +2044,11 @@ static void ironlake_crtc_dpms(struct dr
 
 				reg = I915_READ(trans_dp_ctl);
 				reg &= ~(TRANS_DP_PORT_SEL_MASK |
-					 TRANS_DP_SYNC_MASK);
+					 TRANS_DP_SYNC_MASK |
+					 TRANS_DP_BPC_MASK);
 				reg |= (TRANS_DP_OUTPUT_ENABLE |
 					TRANS_DP_ENH_FRAMING);
+				reg |= TRANS_DP_8BPC;
 
 				if (crtc->mode.flags & DRM_MODE_FLAG_PHSYNC)
 				      reg |= TRANS_DP_HSYNC_ACTIVE_HIGH;



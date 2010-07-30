Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951Ab0G3SDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:03:46 -0400
Received: from kroah.org ([198.145.64.141]:59329 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932666Ab0G3R6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:58:05 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:52 2010
Message-Id: <20100730175152.324169827@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: [203/205] drm/i915: add PANEL_UNLOCK_REGS definition
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 4a655f043160eeae447efd3be297b6b4c397a640 upstream.

In some cases, unlocking the panel regs is safe and can help us avoid a
flickery, full mode set sequence.  So define the unlock key and use it.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_reg.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |    6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2687,6 +2687,7 @@
 
 #define PCH_PP_STATUS		0xc7200
 #define PCH_PP_CONTROL		0xc7204
+#define  PANEL_UNLOCK_REGS	(0xabcd << 16)
 #define  EDP_FORCE_VDD		(1 << 3)
 #define  EDP_BLC_ENABLE		(1 << 2)
 #define  PANEL_POWER_RESET	(1 << 1)
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3950,7 +3950,8 @@ static void intel_increase_pllclock(stru
 		DRM_DEBUG_DRIVER("upclocking LVDS\n");
 
 		/* Unlock panel regs */
-		I915_WRITE(PP_CONTROL, I915_READ(PP_CONTROL) | (0xabcd << 16));
+		I915_WRITE(PP_CONTROL, I915_READ(PP_CONTROL) |
+			   PANEL_UNLOCK_REGS);
 
 		dpll &= ~DISPLAY_RATE_SELECT_FPA1;
 		I915_WRITE(dpll_reg, dpll);
@@ -3993,7 +3994,8 @@ static void intel_decrease_pllclock(stru
 		DRM_DEBUG_DRIVER("downclocking LVDS\n");
 
 		/* Unlock panel regs */
-		I915_WRITE(PP_CONTROL, I915_READ(PP_CONTROL) | (0xabcd << 16));
+		I915_WRITE(PP_CONTROL, I915_READ(PP_CONTROL) |
+			   PANEL_UNLOCK_REGS);
 
 		dpll |= DISPLAY_RATE_SELECT_FPA1;
 		I915_WRITE(dpll_reg, dpll);



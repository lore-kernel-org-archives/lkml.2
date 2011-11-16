Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab1KPNaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 08:30:12 -0500
Received: from mga03.intel.com ([143.182.124.21]:23087 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605Ab1KPN3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 08:29:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,521,1315206000"; 
   d="scan'208";a="75649617"
Message-Id: <20111116132221.122617033@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 16 Nov 2011 21:20:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
cc: Takashi Iwai <tiwai@suse.de>, Wu Fengguang <fengguang.wu@intel.com>
cc: dri-devel@lists.freedesktop.org
cc: intel-gfx@lists.freedesktop.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] drm/i915: fix ELD writing for SandyBridge
References: <20111116132004.299754849@intel.com>
Content-Disposition: inline; filename=sandybridge-eld-fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SandyBridge should be using the same register addresses as IvyBridge.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/gpu/drm/i915/i915_reg.h      |    6 +++---
 drivers/gpu/drm/i915/intel_display.c |   10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

--- linux.orig/drivers/gpu/drm/i915/i915_reg.h	2011-11-09 13:17:19.000000000 +0800
+++ linux/drivers/gpu/drm/i915/i915_reg.h	2011-11-09 13:18:39.000000000 +0800
@@ -3543,8 +3543,8 @@
 #define GEN5_ELD_VALIDB			(1 << 0)
 #define GEN5_CP_READYB			(1 << 1)
 
-#define GEN7_HDMIW_HDMIEDID_A		0xE5050
-#define GEN7_AUD_CNTRL_ST_A		0xE50B4
-#define GEN7_AUD_CNTRL_ST2		0xE50C0
+#define GEN6_HDMIW_HDMIEDID_A		0xE5050
+#define GEN6_AUD_CNTL_ST_A		0xE50B4
+#define GEN6_AUD_CNTRL_ST2		0xE50C0
 
 #endif /* _I915_REG_H_ */
--- linux.orig/drivers/gpu/drm/i915/intel_display.c	2011-11-09 13:19:28.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_display.c	2011-11-09 13:20:02.000000000 +0800
@@ -5857,14 +5857,14 @@ static void ironlake_write_eld(struct dr
 	int aud_cntl_st;
 	int aud_cntrl_st2;
 
-	if (IS_IVYBRIDGE(connector->dev)) {
-		hdmiw_hdmiedid = GEN7_HDMIW_HDMIEDID_A;
-		aud_cntl_st = GEN7_AUD_CNTRL_ST_A;
-		aud_cntrl_st2 = GEN7_AUD_CNTRL_ST2;
-	} else {
+	if (IS_GEN5(connector->dev)) {
 		hdmiw_hdmiedid = GEN5_HDMIW_HDMIEDID_A;
 		aud_cntl_st = GEN5_AUD_CNTL_ST_A;
 		aud_cntrl_st2 = GEN5_AUD_CNTL_ST2;
+	} else {
+		hdmiw_hdmiedid = GEN6_HDMIW_HDMIEDID_A;
+		aud_cntl_st = GEN6_AUD_CNTL_ST_A;
+		aud_cntrl_st2 = GEN6_AUD_CNTRL_ST2;
 	}
 
 	i = to_intel_crtc(crtc)->pipe;



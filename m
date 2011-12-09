Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab1LINBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 08:01:22 -0500
Received: from mga03.intel.com ([143.182.124.21]:34808 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1LIM76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 07:59:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="83996289"
Message-Id: <20111209124555.840337563@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Dec 2011 20:42:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
cc: Takashi Iwai <tiwai@suse.de>, Wu Fengguang <fengguang.wu@intel.com>
Cc: Sander Jansen <s.jansen@gmail.com>,
        Christopher White <c.white@pulseforce.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Pierre-louis Bossart " <pierre-louis.bossart@intel.com>,
        "Zhenyu Wang" <zhenyu.z.wang@intel.com>,
        Jeremy Bush <contractfrombelow@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] drm/i915: rename audio ELD registers
References: <20111209124216.701131933@intel.com>
Content-Disposition: inline; filename=sandybridge-eld-reg-rename
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the definitions from GEN5 to IBX as they aren't in the CPU and
some SNB systems actually shipped with IBX chipsets (or, at least that's
a supported configuration).

The GEN7_* register addresses actually take effect since GEN6 and should
be prefixed by CPT, the PCH code name.

Suggested-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/gpu/drm/i915/i915_reg.h      |   22 +++++++++++-----------
 drivers/gpu/drm/i915/intel_display.c |   22 +++++++++++-----------
 2 files changed, 22 insertions(+), 22 deletions(-)

--- linux.orig/drivers/gpu/drm/i915/i915_reg.h	2011-11-29 19:50:27.000000000 +0800
+++ linux/drivers/gpu/drm/i915/i915_reg.h	2011-11-29 19:51:38.000000000 +0800
@@ -3534,17 +3534,17 @@
 #define G4X_ELD_ACK			(1 << 4)
 #define G4X_HDMIW_HDMIEDID		0x6210C
 
-#define GEN5_HDMIW_HDMIEDID_A		0xE2050
-#define GEN5_AUD_CNTL_ST_A		0xE20B4
-#define GEN5_ELD_BUFFER_SIZE		(0x1f << 10)
-#define GEN5_ELD_ADDRESS		(0x1f << 5)
-#define GEN5_ELD_ACK			(1 << 4)
-#define GEN5_AUD_CNTL_ST2		0xE20C0
-#define GEN5_ELD_VALIDB			(1 << 0)
-#define GEN5_CP_READYB			(1 << 1)
+#define IBX_HDMIW_HDMIEDID_A		0xE2050
+#define IBX_AUD_CNTL_ST_A		0xE20B4
+#define IBX_ELD_BUFFER_SIZE		(0x1f << 10)
+#define IBX_ELD_ADDRESS			(0x1f << 5)
+#define IBX_ELD_ACK			(1 << 4)
+#define IBX_AUD_CNTL_ST2		0xE20C0
+#define IBX_ELD_VALIDB			(1 << 0)
+#define IBX_CP_READYB			(1 << 1)
 
-#define GEN7_HDMIW_HDMIEDID_A		0xE5050
-#define GEN7_AUD_CNTRL_ST_A		0xE50B4
-#define GEN7_AUD_CNTRL_ST2		0xE50C0
+#define CPT_HDMIW_HDMIEDID_A		0xE5050
+#define CPT_AUD_CNTL_ST_A		0xE50B4
+#define CPT_AUD_CNTRL_ST2		0xE50C0
 
 #endif /* _I915_REG_H_ */
--- linux.orig/drivers/gpu/drm/i915/intel_display.c	2011-11-29 19:51:28.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_display.c	2011-11-29 19:52:01.000000000 +0800
@@ -5858,13 +5858,13 @@ static void ironlake_write_eld(struct dr
 	int aud_cntrl_st2;
 
 	if (HAS_PCH_IBX(connector->dev)) {
-		hdmiw_hdmiedid = GEN5_HDMIW_HDMIEDID_A;
-		aud_cntl_st = GEN5_AUD_CNTL_ST_A;
-		aud_cntrl_st2 = GEN5_AUD_CNTL_ST2;
+		hdmiw_hdmiedid = IBX_HDMIW_HDMIEDID_A;
+		aud_cntl_st = IBX_AUD_CNTL_ST_A;
+		aud_cntrl_st2 = IBX_AUD_CNTL_ST2;
 	} else {
-		hdmiw_hdmiedid = GEN7_HDMIW_HDMIEDID_A;
-		aud_cntl_st = GEN7_AUD_CNTRL_ST_A;
-		aud_cntrl_st2 = GEN7_AUD_CNTRL_ST2;
+		hdmiw_hdmiedid = CPT_HDMIW_HDMIEDID_A;
+		aud_cntl_st = CPT_AUD_CNTL_ST_A;
+		aud_cntrl_st2 = CPT_AUD_CNTRL_ST2;
 	}
 
 	i = to_intel_crtc(crtc)->pipe;
@@ -5878,12 +5878,12 @@ static void ironlake_write_eld(struct dr
 	if (!i) {
 		DRM_DEBUG_DRIVER("Audio directed to unknown port\n");
 		/* operate blindly on all ports */
-		eldv = GEN5_ELD_VALIDB;
-		eldv |= GEN5_ELD_VALIDB << 4;
-		eldv |= GEN5_ELD_VALIDB << 8;
+		eldv = IBX_ELD_VALIDB;
+		eldv |= IBX_ELD_VALIDB << 4;
+		eldv |= IBX_ELD_VALIDB << 8;
 	} else {
 		DRM_DEBUG_DRIVER("ELD on port %c\n", 'A' + i);
-		eldv = GEN5_ELD_VALIDB << ((i - 1) * 4);
+		eldv = IBX_ELD_VALIDB << ((i - 1) * 4);
 	}
 
 	i = I915_READ(aud_cntrl_st2);
@@ -5899,7 +5899,7 @@ static void ironlake_write_eld(struct dr
 	}
 
 	i = I915_READ(aud_cntl_st);
-	i &= ~GEN5_ELD_ADDRESS;
+	i &= ~IBX_ELD_ADDRESS;
 	I915_WRITE(aud_cntl_st, i);
 
 	len = min_t(uint8_t, eld[2], 21);	/* 84 bytes of hw ELD buffer */



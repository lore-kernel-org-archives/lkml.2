Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab2FHFZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:25:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43165 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760838Ab2FHFHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:17 -0400
Message-Id: <20120608041842.897261609@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:18:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Keith Packard <keithp@keithp.com>
Subject: [ 15/82] drm/i915: Update GEN6_RP_CONTROL definitions
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Widawsky <ben@bwidawsk.net>

commit 6ed55ee7da15329476174bc5821dbc723f671f44 upstream.

This matches the modern specs more accurately.

This will be used by the following patch to fix the way we display RC
status.

Signed-off-by: Ben Widawsky <ben@bwidawsk.net>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_reg.h      |    6 +++++-
 drivers/gpu/drm/i915/intel_display.c |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 3ae2c7c..583e8c7 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3502,7 +3502,11 @@
 #define   GEN6_CAGF_MASK			(0x7f << GEN6_CAGF_SHIFT)
 #define GEN6_RP_CONTROL				0xA024
 #define   GEN6_RP_MEDIA_TURBO			(1<<11)
-#define   GEN6_RP_USE_NORMAL_FREQ		(1<<9)
+#define   GEN6_RP_MEDIA_MODE_MASK		(3<<9)
+#define   GEN6_RP_MEDIA_HW_TURBO_MODE		(3<<9)
+#define   GEN6_RP_MEDIA_HW_NORMAL_MODE		(2<<9)
+#define   GEN6_RP_MEDIA_HW_MODE			(1<<9)
+#define   GEN6_RP_MEDIA_SW_MODE			(0<<9)
 #define   GEN6_RP_MEDIA_IS_GFX			(1<<8)
 #define   GEN6_RP_ENABLE			(1<<7)
 #define   GEN6_RP_UP_IDLE_MIN			(0x1<<3)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 55a5b4c..cb21d5b 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8043,7 +8043,7 @@ void gen6_enable_rps(struct drm_i915_private *dev_priv)
 	I915_WRITE(GEN6_RP_IDLE_HYSTERSIS, 10);
 	I915_WRITE(GEN6_RP_CONTROL,
 		   GEN6_RP_MEDIA_TURBO |
-		   GEN6_RP_USE_NORMAL_FREQ |
+		   GEN6_RP_MEDIA_HW_MODE |
 		   GEN6_RP_MEDIA_IS_GFX |
 		   GEN6_RP_ENABLE |
 		   GEN6_RP_UP_BUSY_AVG |



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab1KHAHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 19:07:09 -0500
Received: from gabe.freedesktop.org ([131.252.210.177]:39870 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab1KHAHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 19:07:08 -0500
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: keithp@keithp.com, Eric Anholt <eric@anholt.net>, stable@kernel.org
Subject: [PATCH 2/2] drm/i915: Turn on another required clock gating bit on gen6.
Date: Mon,  7 Nov 2011 16:07:05 -0800
Message-Id: <1320710825-3408-2-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320710825-3408-1-git-send-email-eric@anholt.net>
References: <1320710825-3408-1-git-send-email-eric@anholt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike the previous one, I don't have known testcases it fixes.  I'd
rather not go through the same debug cycle on whatever testcases those
might be.

Signed-off-by: Eric Anholt <eric@anholt.net>
Cc: stable@kernel.org
---
 drivers/gpu/drm/i915/i915_reg.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 6ba7ea6..5a25e75 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3399,6 +3399,7 @@
 
 #define GEN6_UCGCTL2				0x9404
 # define GEN6_RCPBUNIT_CLOCK_GATE_DISABLE		(1 << 12)
+# define GEN6_RCCUNIT_CLOCK_GATE_DISABLE		(1 << 11)
 
 #define GEN6_RPNSWREQ				0xA008
 #define   GEN6_TURBO_DISABLE			(1<<31)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index fde7c42..82595a3 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7856,8 +7856,13 @@ static void gen6_init_clock_gating(struct drm_device *dev)
 	 * some amount of runtime in the Mesa "fire" demo, and Unigine
 	 * Sanctuary and Tropics, and apparently anything else with
 	 * alpha test or pixel discard.
+	 *
+	 * According to the spec, bit 11 (RCCUNIT) must also be set,
+	 * but we didn't debug actual testcases to find it out.
 	 */
-	I915_WRITE(GEN6_UCGCTL2, GEN6_RCPBUNIT_CLOCK_GATE_DISABLE);
+	I915_WRITE(GEN6_UCGCTL2,
+		   GEN6_RCPBUNIT_CLOCK_GATE_DISABLE |
+		   GEN6_RCCUNIT_CLOCK_GATE_DISABLE);
 
 	/*
 	 * According to the spec the following bits should be
-- 
1.7.7


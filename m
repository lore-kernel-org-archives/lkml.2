Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab1HFRyb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 13:54:31 -0400
Received: from home.keithp.com ([63.227.221.253]:41209 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756598Ab1HFRyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 13:54:22 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 4/4] drm/i915: Remove unused 'reg' argument to dp_pipe_enabled
Date: Sat,  6 Aug 2011 10:54:08 -0700
Message-Id: <1312653248-3487-5-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1312653248-3487-1-git-send-email-keithp@keithp.com>
References: <1312653248-3487-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just an extra parameter which isn't actually needed.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_display.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 4c4c903..f6f18c7 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -980,8 +980,8 @@ static void assert_transcoder_disabled(struct drm_i915_private *dev_priv,
 	     pipe_name(pipe));
 }
 
-static bool dp_pipe_enabled(struct drm_i915_private *dev_priv, enum pipe pipe,
-			    int reg, u32 port_sel, u32 val)
+static bool dp_pipe_enabled(struct drm_i915_private *dev_priv,
+			    enum pipe pipe, u32 port_sel, u32 val)
 {
 	if ((val & DP_PORT_EN) == 0)
 		return false;
@@ -1049,7 +1049,7 @@ static void assert_pch_dp_disabled(struct drm_i915_private *dev_priv,
 				   enum pipe pipe, int reg, u32 port_sel)
 {
 	u32 val = I915_READ(reg);
-	WARN(dp_pipe_enabled(dev_priv, pipe, reg, port_sel, val),
+	WARN(dp_pipe_enabled(dev_priv, pipe, port_sel, val),
 	     "PCH DP (0x%08x) enabled on transcoder %c, should be disabled\n",
 	     reg, pipe_name(pipe));
 }
@@ -1407,7 +1407,7 @@ static void disable_pch_dp(struct drm_i915_private *dev_priv,
 			   enum pipe pipe, int reg, u32 port_sel)
 {
 	u32 val = I915_READ(reg);
-	if (dp_pipe_enabled(dev_priv, pipe, reg, port_sel, val)) {
+	if (dp_pipe_enabled(dev_priv, pipe, port_sel, val)) {
 		DRM_DEBUG_KMS("Disabling pch dp %x on pipe %d\n", reg, pipe);
 		I915_WRITE(reg, val & ~DP_PORT_EN);
 	}
-- 
1.7.5.4


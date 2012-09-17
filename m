Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab2IQAue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33380 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753049Ab2IQAtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:39 -0400
Message-Id: <20120917003628.009636083@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Xu, Anhua" <anhua.xu@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Schroeder <sec@dschroeder.info>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 013/135] drm/i915: fix wrong order of parameters in port checking functions
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Xu, Anhua" <anhua.xu@intel.com>

commit b70ad586162609141f0aa9eb34790f31a8954f89 upstream.

Wrong order of parameters passed-in when calling hdmi/adpa
/lvds_pipe_enabled(), 2nd and 3rd parameters are reversed.

This bug was indroduced by

commit 1519b9956eb4b4180fa3f47c73341463cdcfaa37
Author: Keith Packard <keithp@keithp.com>
Date:   Sat Aug 6 10:35:34 2011 -0700

    drm/i915: Fix PCH port pipe select in CPT disable paths

The reachable tag for this commit is v3.1-rc1-3-g1519b99

Signed-off-by: Anhua Xu <anhua.xu@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=44876
Tested-by: Daniel Schroeder <sec@dschroeder.info>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1072,7 +1072,7 @@ static void assert_pch_hdmi_disabled(str
 				     enum pipe pipe, int reg)
 {
 	u32 val = I915_READ(reg);
-	WARN(hdmi_pipe_enabled(dev_priv, val, pipe),
+	WARN(hdmi_pipe_enabled(dev_priv, pipe, val),
 	     "PCH HDMI (0x%08x) enabled on transcoder %c, should be disabled\n",
 	     reg, pipe_name(pipe));
 }
@@ -1089,13 +1089,13 @@ static void assert_pch_ports_disabled(st
 
 	reg = PCH_ADPA;
 	val = I915_READ(reg);
-	WARN(adpa_pipe_enabled(dev_priv, val, pipe),
+	WARN(adpa_pipe_enabled(dev_priv, pipe, val),
 	     "PCH VGA enabled on transcoder %c, should be disabled\n",
 	     pipe_name(pipe));
 
 	reg = PCH_LVDS;
 	val = I915_READ(reg);
-	WARN(lvds_pipe_enabled(dev_priv, val, pipe),
+	WARN(lvds_pipe_enabled(dev_priv, pipe, val),
 	     "PCH LVDS enabled on transcoder %c, should be disabled\n",
 	     pipe_name(pipe));
 
@@ -1437,7 +1437,7 @@ static void disable_pch_hdmi(struct drm_
 			     enum pipe pipe, int reg)
 {
 	u32 val = I915_READ(reg);
-	if (hdmi_pipe_enabled(dev_priv, val, pipe)) {
+	if (hdmi_pipe_enabled(dev_priv, pipe, val)) {
 		DRM_DEBUG_KMS("Disabling pch HDMI %x on pipe %d\n",
 			      reg, pipe);
 		I915_WRITE(reg, val & ~PORT_ENABLE);
@@ -1459,12 +1459,12 @@ static void intel_disable_pch_ports(stru
 
 	reg = PCH_ADPA;
 	val = I915_READ(reg);
-	if (adpa_pipe_enabled(dev_priv, val, pipe))
+	if (adpa_pipe_enabled(dev_priv, pipe, val))
 		I915_WRITE(reg, val & ~ADPA_DAC_ENABLE);
 
 	reg = PCH_LVDS;
 	val = I915_READ(reg);
-	if (lvds_pipe_enabled(dev_priv, val, pipe)) {
+	if (lvds_pipe_enabled(dev_priv, pipe, val)) {
 		DRM_DEBUG_KMS("disable lvds on pipe %d val 0x%08x\n", pipe, val);
 		I915_WRITE(reg, val & ~LVDS_PORT_EN);
 		POSTING_READ(reg);



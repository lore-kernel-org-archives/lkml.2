Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965511Ab2I1TXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:23:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030455Ab2I1TDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:03:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Anhua Xu <anhua.xu@intel.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Schroeder <sec@dschroeder.info>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 198/262] drm/i915: fix wrong order of parameters in port checking functions
Date: Fri, 28 Sep 2012 11:52:07 -0700
Message-Id: <20120928183021.465404270@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_display.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1238,7 +1238,7 @@ static void assert_pch_hdmi_disabled(str
 				     enum pipe pipe, int reg)
 {
 	u32 val = I915_READ(reg);
-	WARN(hdmi_pipe_enabled(dev_priv, val, pipe),
+	WARN(hdmi_pipe_enabled(dev_priv, pipe, val),
 	     "PCH HDMI (0x%08x) enabled on transcoder %c, should be disabled\n",
 	     reg, pipe_name(pipe));
 }
@@ -1255,13 +1255,13 @@ static void assert_pch_ports_disabled(st
 
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
 
@@ -1723,7 +1723,7 @@ static void disable_pch_hdmi(struct drm_
 			     enum pipe pipe, int reg)
 {
 	u32 val = I915_READ(reg);
-	if (hdmi_pipe_enabled(dev_priv, val, pipe)) {
+	if (hdmi_pipe_enabled(dev_priv, pipe, val)) {
 		DRM_DEBUG_KMS("Disabling pch HDMI %x on pipe %d\n",
 			      reg, pipe);
 		I915_WRITE(reg, val & ~PORT_ENABLE);
@@ -1745,12 +1745,12 @@ static void intel_disable_pch_ports(stru
 
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



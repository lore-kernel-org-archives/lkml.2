Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031793Ab2CITxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:53:25 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64616 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031633Ab2CITxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:53:17 -0500
Message-Id: <20120309190218.416459900@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Kenneth Graunke <kenneth@whitecape.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 43/68] drm/i915: gen7: Disable the RHWO optimization as it can cause GPU hangs.
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenneth Graunke <kenneth@whitecape.org>

commit d71de14ddf423ccc9a2e3f7e37553c99ead20d7c upstream.

The BSpec Workarounds page states that bits 10 and 26 must be set to
avoid 3D ring hangs.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=41353
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=44610
Tested-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Kenneth Graunke <kenneth@whitecape.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h      |    3 +++
 drivers/gpu/drm/i915/intel_display.c |    4 ++++
 2 files changed, 7 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2848,6 +2848,9 @@
 #define  DISP_FBC_WM_DIS		(1<<15)
 
 /* GEN7 chicken */
+#define GEN7_COMMON_SLICE_CHICKEN1		0x7010
+# define GEN7_CSC1_RHWO_OPT_DISABLE_IN_RCC	((1<<10) | (1<<26))
+
 #define GEN7_L3CNTLREG1				0xB01C
 #define  GEN7_WA_FOR_GEN7_L3_CONTROL			0x3C4FFF8C
 
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7464,6 +7464,10 @@ static void ivybridge_init_clock_gating(
 
 	I915_WRITE(ILK_DSPCLK_GATE, IVB_VRHUNIT_CLK_GATE);
 
+	/* Apply the WaDisableRHWOOptimizationForRenderHang workaround. */
+	I915_WRITE(GEN7_COMMON_SLICE_CHICKEN1,
+		   GEN7_CSC1_RHWO_OPT_DISABLE_IN_RCC);
+
 	/* WaApplyL3ControlAndL3ChickenMode requires those two on Ivy Bridge */
 	I915_WRITE(GEN7_L3CNTLREG1,
 			GEN7_WA_FOR_GEN7_L3_CONTROL);



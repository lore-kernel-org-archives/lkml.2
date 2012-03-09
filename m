Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031786Ab2CIUCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:02:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64616 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031744Ab2CITxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:53:07 -0500
Message-Id: <20120309190218.174955032@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Kenneth Graunke <kenneth@whitecape.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 40/68] drm/i915: gen7: implement rczunit workaround
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugeni Dodonov <eugeni.dodonov@intel.com>

commit eae66b50c760233fad526edf4a0d327be17a055d upstream.

This is yet another workaround related to clock gating which we need on
Ivy Bridge.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=41353
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=44610
Tested-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Kenneth Graunke <kenneth@whitecape.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |    5 +++++
 2 files changed, 6 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3371,6 +3371,7 @@
 #define  GT_FIFO_FREE_ENTRIES			0x120008
 
 #define GEN6_UCGCTL2				0x9404
+# define GEN6_RCZUNIT_CLOCK_GATE_DISABLE		(1 << 13)
 # define GEN6_RCPBUNIT_CLOCK_GATE_DISABLE		(1 << 12)
 # define GEN6_RCCUNIT_CLOCK_GATE_DISABLE		(1 << 11)
 
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7457,6 +7457,11 @@ static void ivybridge_init_clock_gating(
 	I915_WRITE(WM2_LP_ILK, 0);
 	I915_WRITE(WM1_LP_ILK, 0);
 
+	/* According to the spec, bit 13 (RCZUNIT) must be set on IVB.
+	 * This implements the WaDisableRCZUnitClockGating workaround.
+	 */
+	I915_WRITE(GEN6_UCGCTL2, GEN6_RCZUNIT_CLOCK_GATE_DISABLE);
+
 	I915_WRITE(ILK_DSPCLK_GATE, IVB_VRHUNIT_CLK_GATE);
 
 	for_each_pipe(pipe)



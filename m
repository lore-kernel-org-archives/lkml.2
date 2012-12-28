Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab2L1Te4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:34:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55470 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932134Ab2L1TTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:07 -0500
Message-Id: <20121228190345.474011072@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Damien Lespiau <damien.lespiau@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 073/173] drm/i915: make the panel fitter work on pipes B and C on IVB
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Zanoni <paulo.r.zanoni@intel.com>

commit 13888d78c664a1f61d7b09d282f5916993827a40 upstream.

I actually found this problem on Haswell, but then discovered Ivy
Bridge also has it by reading the spec.

I don't have the hardware to test this.

Signed-off-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_reg.h      |    2 ++
 drivers/gpu/drm/i915/intel_display.c |    6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 5aba146..97fbd9d 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3339,6 +3339,8 @@
 #define _PFA_CTL_1               0x68080
 #define _PFB_CTL_1               0x68880
 #define  PF_ENABLE              (1<<31)
+#define  PF_PIPE_SEL_MASK_IVB	(3<<29)
+#define  PF_PIPE_SEL_IVB(pipe)	((pipe)<<29)
 #define  PF_FILTER_MASK		(3<<23)
 #define  PF_FILTER_PROGRAMMED	(0<<23)
 #define  PF_FILTER_MED_3x3	(1<<23)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index e233541..c2ef6cd 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3387,7 +3387,11 @@ static void ironlake_crtc_enable(struct drm_crtc *crtc)
 		 * as some pre-programmed values are broken,
 		 * e.g. x201.
 		 */
-		I915_WRITE(PF_CTL(pipe), PF_ENABLE | PF_FILTER_MED_3x3);
+		if (IS_IVYBRIDGE(dev))
+			I915_WRITE(PF_CTL(pipe), PF_ENABLE | PF_FILTER_MED_3x3 |
+						 PF_PIPE_SEL_IVB(pipe));
+		else
+			I915_WRITE(PF_CTL(pipe), PF_ENABLE | PF_FILTER_MED_3x3);
 		I915_WRITE(PF_WIN_POS(pipe), dev_priv->pch_pf_pos);
 		I915_WRITE(PF_WIN_SZ(pipe), dev_priv->pch_pf_size);
 	}



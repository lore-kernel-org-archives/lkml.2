Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0HXP4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:56:22 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:36076 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab0HXP4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:56:20 -0400
Date: Tue, 24 Aug 2010 16:56:16 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: intel-gfx@lists.freedesktop.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: [PATCH 2/2] drm/i915: Revert extra intel_wait_for_vblank to
	prevent stalls.
Message-ID: <20100824155616.GC10473@sucs.org>
References: <20100823233551.GA31920@sucs.org> <89kc63$hrmse5@fmsmga002.fm.intel.com> <20100824075741.GA11000@sucs.org> <8u3s8d$jcg467@orsmga001.jf.intel.com> <20100824084902.GA27569@sucs.org> <89kc63$hrqoho@fmsmga002.fm.intel.com> <20100824095535.GA14020@sucs.org> <20100824155359.GB10473@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100824155359.GB10473@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the extra intel_wait_for_vblank added in commit
9d0498a2bf7455159b317f19531a3e5db2ecc9c4 periodic stalls were being
triggered (which were detected by i915_hangcheck_elapsed). Partially
revert this change for now.

Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
---
 drivers/gpu/drm/i915/intel_display.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 116d938..534f1fa 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2379,8 +2379,10 @@ static void i9xx_crtc_dpms(struct drm_crtc *crtc, int mode)
 			I915_READ(dspbase_reg);
 		}
 
-		/* Wait for vblank for the disable to take effect */
-		intel_wait_for_vblank_off(dev, pipe);
+		if (!IS_I9XX(dev)) {
+			/* Wait for vblank for the disable to take effect */
+			intel_wait_for_vblank_off(dev, pipe);
+		}
 
 		/* Don't disable pipe A or pipe A PLLs if needed */
 		if (pipeconf_reg == PIPEACONF &&
-- 
1.7.1


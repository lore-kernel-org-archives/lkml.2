Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab0KCU2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 16:28:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34706 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab0KCU2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 16:28:02 -0400
Date: Wed, 3 Nov 2010 16:27:57 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i915: reprogram power monitoring registers on resume
Message-ID: <20101103202757.GJ8332@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Fixes issue where i915_gfx_val was reporting values several
orders of magnitude higher than physically possible (without
leaving scorch marks on my thighs at least.)

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/drm/i915/i915_suspend.c |    4 +++-
 drivers/gpu/drm/i915/intel_drv.h    |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_suspend.c b/drivers/gpu/drm/i915/i915_suspend.c
index 989c19d..454c064 100644
--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -862,8 +862,10 @@ int i915_restore_state(struct drm_device *dev)
 	/* Clock gating state */
 	intel_init_clock_gating(dev);
 
-	if (HAS_PCH_SPLIT(dev))
+	if (HAS_PCH_SPLIT(dev)) {
 		ironlake_enable_drps(dev);
+		intel_init_emon(dev);
+	}
 
 	/* Cache mode state */
 	I915_WRITE (CACHE_MODE_0, dev_priv->saveCACHE_MODE_0 | 0xffff0000);
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 9af9f86..21551fe 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -296,6 +296,7 @@ extern void intel_crtc_fb_gamma_get(struct drm_crtc *crtc, u16 *red, u16 *green,
 extern void intel_init_clock_gating(struct drm_device *dev);
 extern void ironlake_enable_drps(struct drm_device *dev);
 extern void ironlake_disable_drps(struct drm_device *dev);
+extern void intel_init_emon(struct drm_device *dev);
 
 extern int intel_pin_and_fence_fb_obj(struct drm_device *dev,
 				      struct drm_gem_object *obj,
-- 
1.7.3.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab0LHBCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:02:41 -0500
Received: from kroah.org ([198.145.64.141]:33495 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932488Ab0LHBCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:39 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:40 2010
Message-Id: <20101208005740.096172793@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kyle McMartin <kyle@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [186/289] i915: reprogram power monitoring registers on resume
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kyle McMartin <kyle@redhat.com>

commit 48fcfc888b48ad49dd83faa107264bbfb0089cad upstream.

Fixes issue where i915_gfx_val was reporting values several
orders of magnitude higher than physically possible (without
leaving scorch marks on my thighs at least.)

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_suspend.c |    4 +++-
 drivers/gpu/drm/i915/intel_drv.h    |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -862,8 +862,10 @@ int i915_restore_state(struct drm_device
 	/* Clock gating state */
 	intel_init_clock_gating(dev);
 
-	if (HAS_PCH_SPLIT(dev))
+	if (HAS_PCH_SPLIT(dev)) {
 		ironlake_enable_drps(dev);
+		intel_init_emon(dev);
+	}
 
 	/* Cache mode state */
 	I915_WRITE (CACHE_MODE_0, dev_priv->saveCACHE_MODE_0 | 0xffff0000);
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -250,6 +250,7 @@ extern void intel_crtc_fb_gamma_get(stru
 extern void intel_init_clock_gating(struct drm_device *dev);
 extern void ironlake_enable_drps(struct drm_device *dev);
 extern void ironlake_disable_drps(struct drm_device *dev);
+extern void intel_init_emon(struct drm_device *dev);
 
 extern int intel_pin_and_fence_fb_obj(struct drm_device *dev,
 				      struct drm_gem_object *obj);



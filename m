Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab1GVOCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:02:53 -0400
Received: from hylle02.itea.ntnu.no ([129.241.56.101]:40116 "EHLO
	hylle02.itea.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab1GVOCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:02:52 -0400
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jul 2011 10:02:52 EDT
Date: Fri, 22 Jul 2011 15:56:01 +0200
From: Ole Henrik Jahren <olehenja@alumni.ntnu.no>
To: keithp@keithp.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/i915: Fix typo in DRM_I915_OVERLAY_PUT_IMAGE ioctl define
Message-ID: <20110722135601.GA17512@siv.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of a typo, calling ioctl with DRM_IOCTL_I915_OVERLAY_PUT_IMAGE
is broken if the macro is used directly. When using libdrm the bug is
not hit, since libdrm handles the ioctl encoding internally.

The typo also leads to the .cmd and .cmd_drv fields of the drm_ioctl
structure for DRM_I915_OVERLAY_PUT_IMAGE having inconsistent content.

Signed-off-by: Ole Henrik Jahren <olehenja@alumni.ntnu.no>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 include/drm/i915_drm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/drm/i915_drm.h b/include/drm/i915_drm.h
index c4d6dbf..28c0d11 100644
--- a/include/drm/i915_drm.h
+++ b/include/drm/i915_drm.h
@@ -237,7 +237,7 @@ typedef struct _drm_i915_sarea {
 #define DRM_IOCTL_I915_GEM_GET_APERTURE	DRM_IOR  (DRM_COMMAND_BASE + DRM_I915_GEM_GET_APERTURE, struct drm_i915_gem_get_aperture)
 #define DRM_IOCTL_I915_GET_PIPE_FROM_CRTC_ID DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_GET_PIPE_FROM_CRTC_ID, struct drm_i915_get_pipe_from_crtc_id)
 #define DRM_IOCTL_I915_GEM_MADVISE	DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_GEM_MADVISE, struct drm_i915_gem_madvise)
-#define DRM_IOCTL_I915_OVERLAY_PUT_IMAGE	DRM_IOW(DRM_COMMAND_BASE + DRM_IOCTL_I915_OVERLAY_ATTRS, struct drm_intel_overlay_put_image)
+#define DRM_IOCTL_I915_OVERLAY_PUT_IMAGE	DRM_IOW(DRM_COMMAND_BASE + DRM_I915_OVERLAY_PUT_IMAGE, struct drm_intel_overlay_put_image)
 #define DRM_IOCTL_I915_OVERLAY_ATTRS	DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_OVERLAY_ATTRS, struct drm_intel_overlay_attrs)
 
 /* Allow drivers to submit batchbuffers directly to hardware, relying
-- 
1.7.6


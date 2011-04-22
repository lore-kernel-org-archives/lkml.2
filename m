Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1DVBeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 21:34:46 -0400
Received: from hylle01.itea.ntnu.no ([129.241.56.100]:54144 "EHLO
	hylle01.itea.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab1DVBep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 21:34:45 -0400
Date: Fri, 22 Apr 2011 03:36:24 +0200
From: Ole Henrik Jahren <olehenja@alumni.ntnu.no>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915: Fix typo in DRM_I915_OVERLAY_PUT_IMAGE ioctl define
Message-ID: <20110422013624.GA25852@siv.localdomain>
References: <20110412041018.GC17720@siv.localdomain>
 <BANLkTimwL1yrT9xbsfnh_sH6HSiv1txMXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BANLkTimwL1yrT9xbsfnh_sH6HSiv1txMXA@mail.gmail.com>
X-PGP-Key: http://folk.ntnu.no/olehenja/files/pubkey.asc
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling ioctl with DRM_IOCTL_I915_OVERLAY_PUT_IMAGE is broken if the
macro is used directly, because the define contains a typo. When using
libdrm you do not hit the bug, since libdrm handles the ioctl encoding
internally.

The typo also leads to the .cmd and .cmd_drv fields of the drm_ioctl
structure for DRM_I915_OVERLAY_PUT_IMAGE having inconsistent content.

Signed-off-by: Ole Henrik Jahren <olehenja@alumni.ntnu.no>
Cc: Chris Wilson <chris at chris-wilson.co.uk>
Acked-by: Daniel Vetter <daniel.vetter at ffwll.ch>
---

Included a bit more explanation about the problem. The impact of the
inconsistency between .cmd and .cmd_drv does not seem to have any impact,
since the only thing .cmd_drv seems to be used for is calculating the
size of the copy_from_user() buffer. It incidentally result in the same
size both with and without this patch (at least on 64bit).

 include/drm/i915_drm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/drm/i915_drm.h b/include/drm/i915_drm.h
index 0039f1f..ca7b8af 100644
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
1.7.5.rc1


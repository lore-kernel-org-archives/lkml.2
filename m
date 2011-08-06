Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab1HFAMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:12:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964811Ab1HFAMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:12:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:16 2011
Message-Id: <20110806000416.641329353@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:04:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ole Henrik Jahren <olehenja@alumni.ntnu.no>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Keith Packard <keithp@keithp.com>
Subject: [50/50] drm/i915: Fix typo in DRM_I915_OVERLAY_PUT_IMAGE ioctl
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------
 define

From: Ole Henrik Jahren <olehenja@alumni.ntnu.no>

commit 842d452985300f4ec14c68cb86046e8a1a3b7251 upstream.

Because of a typo, calling ioctl with DRM_IOCTL_I915_OVERLAY_PUT_IMAGE
is broken if the macro is used directly. When using libdrm the bug is
not hit, since libdrm handles the ioctl encoding internally.

The typo also leads to the .cmd and .cmd_drv fields of the drm_ioctl
structure for DRM_I915_OVERLAY_PUT_IMAGE having inconsistent content.

Signed-off-by: Ole Henrik Jahren <olehenja@alumni.ntnu.no>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/drm/i915_drm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/drm/i915_drm.h
+++ b/include/drm/i915_drm.h
@@ -227,7 +227,7 @@ typedef struct _drm_i915_sarea {
 #define DRM_IOCTL_I915_GEM_GET_APERTURE	DRM_IOR  (DRM_COMMAND_BASE + DRM_I915_GEM_GET_APERTURE, struct drm_i915_gem_get_aperture)
 #define DRM_IOCTL_I915_GET_PIPE_FROM_CRTC_ID DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_GET_PIPE_FROM_CRTC_ID, struct drm_i915_get_pipe_from_crtc_id)
 #define DRM_IOCTL_I915_GEM_MADVISE	DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_GEM_MADVISE, struct drm_i915_gem_madvise)
-#define DRM_IOCTL_I915_OVERLAY_PUT_IMAGE	DRM_IOW(DRM_COMMAND_BASE + DRM_IOCTL_I915_OVERLAY_ATTRS, struct drm_intel_overlay_put_image)
+#define DRM_IOCTL_I915_OVERLAY_PUT_IMAGE	DRM_IOW(DRM_COMMAND_BASE + DRM_I915_OVERLAY_PUT_IMAGE, struct drm_intel_overlay_put_image)
 #define DRM_IOCTL_I915_OVERLAY_ATTRS	DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_OVERLAY_ATTRS, struct drm_intel_overlay_attrs)
 
 /* Allow drivers to submit batchbuffers directly to hardware, relying



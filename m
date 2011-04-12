Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1DLNQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 09:16:09 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60315 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1DLNQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 09:16:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ffwll.ch; s=google;
        h=mime-version:sender:x-originating-ip:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CAkyLCCP2ERg6EDjOko33TfoooXMlzfPm19CL190VqzCBXP5iJG+POoCMfJoN8BrJ6
         B3PIw8G4WdQN3tJ0/kYU5Nbv0qdrPwftgu+Silp4v9Cft0tj3Gn5JGzNL0FYWQIAdwh3
         ZiT2nqGS0YAEt3JorZNIdn2zvFVWLQHXwYmLA=
MIME-Version: 1.0
X-Originating-IP: [212.120.32.74]
In-Reply-To: <20110412041018.GC17720@siv.localdomain>
References: <20110412041018.GC17720@siv.localdomain>
Date: Tue, 12 Apr 2011 15:16:05 +0200
X-Google-Sender-Auth: 10oHVpxiUim3DsFbjCHcgwB-Fhs
Message-ID: <BANLkTimwL1yrT9xbsfnh_sH6HSiv1txMXA@mail.gmail.com>
Subject: Re: [PATCH] Fix typo in include/drm/i915_drm.h
From: Daniel Vetter <daniel@ffwll.ch>
To: Ole Henrik Jahren <olehenja@alumni.ntnu.no>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indeed, good catch. Luckily never ever used (libdrm takes care of it
internally) in the drmCommand(Write|Read) functions.

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

On Tue, Apr 12, 2011 at 6:10 AM, Ole Henrik Jahren
<olehenja@alumni.ntnu.no> wrote:
> Signed-off-by: Ole Henrik Jahren <olehenja@alumni.ntnu.no>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> ---
>
> While adding DRM ioctl decoding support to strace, I noticed something
> that looks very much like a typo. If it is intended this way, sorry
> about the noise.
>
>  include/drm/i915_drm.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/drm/i915_drm.h b/include/drm/i915_drm.h
> index 0039f1f..ca7b8af 100644
> --- a/include/drm/i915_drm.h
> +++ b/include/drm/i915_drm.h
> @@ -237,7 +237,7 @@ typedef struct _drm_i915_sarea {
>  #define DRM_IOCTL_I915_GEM_GET_APERTURE        DRM_IOR  (DRM_COMMAND_BASE + DRM_I915_GEM_GET_APERTURE, struct drm_i915_gem_get_aperture)
>  #define DRM_IOCTL_I915_GET_PIPE_FROM_CRTC_ID DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_GET_PIPE_FROM_CRTC_ID, struct drm_i915_get_pipe_from_crtc_id)
>  #define DRM_IOCTL_I915_GEM_MADVISE     DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_GEM_MADVISE, struct drm_i915_gem_madvise)
> -#define DRM_IOCTL_I915_OVERLAY_PUT_IMAGE       DRM_IOW(DRM_COMMAND_BASE + DRM_IOCTL_I915_OVERLAY_ATTRS, struct drm_intel_overlay_put_image)
> +#define DRM_IOCTL_I915_OVERLAY_PUT_IMAGE       DRM_IOW(DRM_COMMAND_BASE + DRM_I915_OVERLAY_PUT_IMAGE, struct drm_intel_overlay_put_image)
>  #define DRM_IOCTL_I915_OVERLAY_ATTRS   DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_OVERLAY_ATTRS, struct drm_intel_overlay_attrs)
>
>  /* Allow drivers to submit batchbuffers directly to hardware, relying
> --
> 1.7.5.rc1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>



-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch

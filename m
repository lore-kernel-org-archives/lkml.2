Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750895Ab1HINcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 09:32:18 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:44723 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab1HINcR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 09:32:17 -0400
MIME-Version: 1.0
In-Reply-To: <1312788155-8451-1-git-send-email-amwang@redhat.com>
References: <1312788155-8451-1-git-send-email-amwang@redhat.com>
Date: Tue, 9 Aug 2011 09:32:16 -0400
Message-ID: <CADnq5_O=69Q2HQCoQ0XSXCi85LYzCcx7wbqGH4UmD89hmiVHfA@mail.gmail.com>
Subject: Re: [PATCH] drm: add missing header file <linuc/types.h>
From: Alex Deucher <alexdeucher@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 3:22 AM, Amerigo Wang <amwang@redhat.com> wrote:
> This patch fixes the following 'make headers_check' errors:
>
> linux-2.6/usr/include/drm/drm_mode.h:85: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux-2.6/usr/include/drm/i915_drm.h:120: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux-2.6/usr/include/drm/mga_drm.h:260: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux-2.6/usr/include/drm/radeon_drm.h:758: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux-2.6/usr/include/drm/via_drm.h:117: found __[us]{8,16,32,64} type without #include <linux/types.h>
>

These files are shared with BSD, and they get the linux/types.h from drm.h.

Alex

> Signed-off-by: WANG Cong <amwang@redhat.com>
>
> ---
> diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
> index c4961ea..fe8005f 100644
> --- a/include/drm/drm_mode.h
> +++ b/include/drm/drm_mode.h
> @@ -81,6 +81,8 @@
>  #define DRM_MODE_DIRTY_ON       1
>  #define DRM_MODE_DIRTY_ANNOTATE 2
>
> +#include <linux/types.h>
> +
>  struct drm_mode_modeinfo {
>        __u32 clock;
>        __u16 hdisplay, hsync_start, hsync_end, htotal, hskew;
> diff --git a/include/drm/i915_drm.h b/include/drm/i915_drm.h
> index 28c0d11..d7ddd33 100644
> --- a/include/drm/i915_drm.h
> +++ b/include/drm/i915_drm.h
> @@ -27,6 +27,7 @@
>  #ifndef _I915_DRM_H_
>  #define _I915_DRM_H_
>
> +#include <linux/types.h>
>  #include "drm.h"
>
>  /* Please note that modifications to all structs defined here are
> diff --git a/include/drm/mga_drm.h b/include/drm/mga_drm.h
> index fca8170..8058ce0 100644
> --- a/include/drm/mga_drm.h
> +++ b/include/drm/mga_drm.h
> @@ -35,6 +35,7 @@
>  #ifndef __MGA_DRM_H__
>  #define __MGA_DRM_H__
>
> +#include <linux/types.h>
>  #include "drm.h"
>
>  /* WARNING: If you change any of these defines, make sure to change the
> diff --git a/include/drm/radeon_drm.h b/include/drm/radeon_drm.h
> index b65be60..f0be4c7 100644
> --- a/include/drm/radeon_drm.h
> +++ b/include/drm/radeon_drm.h
> @@ -33,6 +33,7 @@
>  #ifndef __RADEON_DRM_H__
>  #define __RADEON_DRM_H__
>
> +#include <linux/types.h>
>  #include "drm.h"
>
>  /* WARNING: If you change any of these defines, make sure to change the
> diff --git a/include/drm/via_drm.h b/include/drm/via_drm.h
> index fd11a5b..23880b0 100644
> --- a/include/drm/via_drm.h
> +++ b/include/drm/via_drm.h
> @@ -24,6 +24,7 @@
>  #ifndef _VIA_DRM_H_
>  #define _VIA_DRM_H_
>
> +#include <linux/types.h>
>  #include "drm.h"
>
>  /* WARNING: These defines must be the same as what the Xserver uses.
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>

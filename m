Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab1APLHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 06:07:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:26259 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839Ab1APLHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 06:07:36 -0500
Message-Id: <0d30dc$kp159h@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,329,1291622400"; 
   d="scan'208";a="697341233"
Date: Sun, 16 Jan 2011 11:07:32 +0000
To: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drm: fixup headers_check
Cc: Felipe Balbi <balbi@ti.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
References: <1295174783-4099-1-git-send-email-balbi@ti.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <1295174783-4099-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Jan 2011 12:46:22 +0200, Felipe Balbi <balbi@ti.com> wrote:
> Drop the following headers_check errors:
> /linux-2.6/usr/include/drm/drm_mode.h:85: found
> __[us]{8,16,32,64} type without #include <linux/types.h>
> /linux-2.6/usr/include/drm/i915_drm.h:120: found
> __[us]{8,16,32,64} type without #include <linux/types.h>
> /linux-2.6/usr/include/drm/mga_drm.h:260: found
> __[us]{8,16,32,64} type without #include <linux/types.h>
> /linux-2.6/usr/include/drm/radeon_drm.h:758: found
> __[us]{8,16,32,64} type without #include <linux/types.h>
> /linux-2.6/usr/include/drm/via_drm.h:117: found
> __[us]{8,16,32,64} type without #include <linux/types.h>
> 
> Cc: David Airlie <airlied@linux.ie>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  include/drm/drm_mode.h   |    2 ++
>  include/drm/i915_drm.h   |    1 +
>  include/drm/mga_drm.h    |    1 +
>  include/drm/radeon_drm.h |    1 +
>  include/drm/via_drm.h    |    1 +
>  5 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
> index 0fc7397..1678d7b 100644
> --- a/include/drm/drm_mode.h
> +++ b/include/drm/drm_mode.h
> @@ -27,6 +27,8 @@
>  #ifndef _DRM_MODE_H
>  #define _DRM_MODE_H
>  
> +#include <linux/types.h>
> +

Would

#if 0
#include <linux/types.h> /* silence make header_check */
#endif

be an acceptable compromise?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

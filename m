Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab2AQQdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:33:46 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:55775 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab2AQQdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:33:45 -0500
Date: Tue, 17 Jan 2012 17:33:39 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Use kcalloc instead of kzalloc to allocate
 array
Message-ID: <20120117163339.GR4093@phenom.ffwll.local>
Mail-Followup-To: Thomas Meyer <thomas@m3y3r.de>, airlied@linux.ie,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1322600880.1534.297.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322600880.1534.297.camel@localhost.localdomain>
X-Operating-System: Linux phenom 3.2.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 10:08:00PM +0100, Thomas Meyer wrote:
> The advantage of kcalloc is, that will prevent integer overflows which could
> result from the multiplication of number of elements and size and it is also
> a bit nicer to read.
> 
> The semantic patch that makes this change is available
> in https://lkml.org/lkml/2011/11/25/107
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Queued for -next, thanks for the patch.
-Daniel

> ---
> 
> diff -u -p a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
> --- a/drivers/gpu/drm/i915/intel_bios.c 2011-11-13 11:07:23.820113543 +0100
> +++ b/drivers/gpu/drm/i915/intel_bios.c 2011-11-28 19:49:51.443206904 +0100
> @@ -572,7 +572,7 @@ parse_device_mapping(struct drm_i915_pri
>  		DRM_DEBUG_KMS("no child dev is parsed from VBT\n");
>  		return;
>  	}
> -	dev_priv->child_dev = kzalloc(sizeof(*p_child) * count, GFP_KERNEL);
> +	dev_priv->child_dev = kcalloc(count, sizeof(*p_child), GFP_KERNEL);
>  	if (!dev_priv->child_dev) {
>  		DRM_DEBUG_KMS("No memory space for child device\n");
>  		return;
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606Ab2HJKYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 06:24:36 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:35071 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab2HJKYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 06:24:32 -0400
X-Originating-IP: 217.70.178.135
X-Originating-IP: 93.1.143.174
Message-ID: <5024E15D.4090102@gnu-log.net>
Date: Fri, 10 Aug 2012 12:24:29 +0200
From: Benoit Gschwind <gschwind@gnu-log.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120808 Thunderbird/10.0.6
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Francois Rigaut <frigaut@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Subject: Re: [PATCH] drm/i915: ingore eDP bpc settings
References: <1344589820-9753-1-git-send-email-daniel.vetter@ffwll.ch>
In-Reply-To: <1344589820-9753-1-git-send-email-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I confirm this patch work apply to kernel 3.6-rc1

Best regards

On 10/08/2012 11:10, Daniel Vetter wrote:
> This has originally been introduced to not oversubscribe the dp links
> in
> 
> commit 885a5fb5b120a5c7e0b3baad7b0feb5a89f76c18
> Author: Zhenyu Wang <zhenyuw@linux.intel.com>
> Date:   Tue Jan 12 05:38:31 2010 +0800
> 
>     drm/i915: fix pixel color depth setting on eDP
> 
> Since then we've fixed up the dp link bandwidth calculation code for
> code and should now automatically fall back to 6bpc dithering. So this
> is unnecessary.
> 
> Furthermore it seems to break the new MacbookPro with retina display,
> hence let's just rip this out.
> 
> Reported-by: Benoit Gschwind <gschwind@gnu-log.net>
> Cc: Benoit Gschwind <gschwind@gnu-log.net>
> Cc: Francois Rigaut <frigaut@gmail.com>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> --
> 
> Testing feedback highgly welcome, and thanks for Benoit for finding
> out that the bpc computations are busted.
> -Daniel
> ---
>  drivers/gpu/drm/i915/intel_display.c |   11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index bddb290..ddd4db3 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -3755,17 +3755,6 @@ static bool intel_choose_pipe_bpp_dither(struct drm_crtc *crtc,
>  			continue;
>  		}
>  
> -		if (intel_encoder->type == INTEL_OUTPUT_EDP) {
> -			/* Use VBT settings if we have an eDP panel */
> -			unsigned int edp_bpc = dev_priv->edp.bpp / 3;
> -
> -			if (edp_bpc < display_bpc) {
> -				DRM_DEBUG_KMS("clamping display bpc (was %d) to eDP (%d)\n", display_bpc, edp_bpc);
> -				display_bpc = edp_bpc;
> -			}
> -			continue;
> -		}
> -
>  		/* Not one of the known troublemakers, check the EDID */
>  		list_for_each_entry(connector, &dev->mode_config.connector_list,
>  				    head) {


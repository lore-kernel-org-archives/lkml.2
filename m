Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1DRXCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 19:02:30 -0400
Received: from expn.cat.pdx.edu ([131.252.208.110]:55495 "EHLO
	expn.cat.pdx.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab1DRXCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 19:02:17 -0400
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Apr 2011 19:02:17 EDT
Message-ID: <4DACC2B9.3020200@freedesktop.org>
Date: Mon, 18 Apr 2011 16:01:13 -0700
From: Ian Romanick <idr@freedesktop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: David Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 2/2] drm: Verify debug message arguments
References: <cover.1303097621.git.joe@perches.com> <c24620769d5864c0c0e460358b256acd0ada5c79.1303097621.git.joe@perches.com>
In-Reply-To: <c24620769d5864c0c0e460358b256acd0ada5c79.1303097621.git.joe@perches.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (expn.cat.pdx.edu [131.252.208.110]); Mon, 18 Apr 2011 16:01:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/17/2011 08:35 PM, Joe Perches wrote:
> Add __attribute__((format (printf, 4, 5))) to drm_ut_debug_printk
> and fix fallout.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Aside from the comment below about intel_bios.c,

Reviewed-by: Ian Romanick <ian.d.romanick@intel.com>

especially the changes in intel_display.c.  yikes...

> ---
>  drivers/gpu/drm/drm_irq.c               |    9 +++++----
>  drivers/gpu/drm/i915/intel_bios.c       |    6 +++---
>  drivers/gpu/drm/i915/intel_display.c    |    8 ++++----
>  drivers/gpu/drm/radeon/radeon_display.c |    5 +++--
>  include/drm/drmP.h                      |    3 ++-
>  5 files changed, 17 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
> index 741457b..62ced75 100644
> --- a/drivers/gpu/drm/drm_irq.c
> +++ b/drivers/gpu/drm/drm_irq.c
> @@ -684,10 +684,11 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct drm_device *dev, int crtc,
>  	 */
>  	*vblank_time = ns_to_timeval(timeval_to_ns(&raw_time) - delta_ns);
>  
> -	DRM_DEBUG("crtc %d : v %d p(%d,%d)@ %d.%d -> %d.%d [e %d us, %d rep]\n",
> -		  crtc, (int) vbl_status, hpos, vpos, raw_time.tv_sec,
> -		  raw_time.tv_usec, vblank_time->tv_sec, vblank_time->tv_usec,
> -		  (int) duration_ns/1000, i);
> +	DRM_DEBUG("crtc %d : v %d p(%d,%d)@ %ld.%ld -> %ld.%ld [e %d us, %d rep]\n",
> +		  crtc, (int)vbl_status, hpos, vpos,
> +		  (long)raw_time.tv_sec, (long)raw_time.tv_usec,
> +		  (long)vblank_time->tv_sec, (long)vblank_time->tv_usec,
> +		  (int)duration_ns/1000, i);
>  
>  	vbl_status = DRM_VBLANKTIME_SCANOUTPOS_METHOD;
>  	if (invbl)
> diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
> index fb5b4d4..927442a 100644
> --- a/drivers/gpu/drm/i915/intel_bios.c
> +++ b/drivers/gpu/drm/i915/intel_bios.c
> @@ -214,9 +214,9 @@ parse_lfp_panel_data(struct drm_i915_private *dev_priv,
>  	    i915_lvds_downclock) {
>  		dev_priv->lvds_downclock_avail = 1;
>  		dev_priv->lvds_downclock = temp_downclock;
> -		DRM_DEBUG_KMS("LVDS downclock is found in VBT. ",
> -				"Normal Clock %dKHz, downclock %dKHz\n",
> -				temp_downclock, panel_fixed_mode->clock);
> +		DRM_DEBUG_KMS("LVDS downclock is found in VBT. "
> +			      "Normal Clock %dKHz, downclock %dKHz\n",
> +			      temp_downclock, panel_fixed_mode->clock);
>  	}
>  	return;
>  }

Does this hunk only change white space, or am I missing something?

> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 432fc04..63bc2af 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -3497,11 +3497,11 @@ static unsigned long intel_calculate_wm(unsigned long clock_in_khz,
>  		1000;
>  	entries_required = DIV_ROUND_UP(entries_required, wm->cacheline_size);
>  
> -	DRM_DEBUG_KMS("FIFO entries required for mode: %d\n", entries_required);
> +	DRM_DEBUG_KMS("FIFO entries required for mode: %ld\n", entries_required);
>  
>  	wm_size = fifo_size - (entries_required + wm->guard_size);
>  
> -	DRM_DEBUG_KMS("FIFO watermark level: %d\n", wm_size);
> +	DRM_DEBUG_KMS("FIFO watermark level: %ld\n", wm_size);
>  
>  	/* Don't promote wm_size to unsigned... */
>  	if (wm_size > (long)wm->max_wm)
> @@ -3820,13 +3820,13 @@ static bool g4x_check_srwm(struct drm_device *dev,
>  		      display_wm, cursor_wm);
>  
>  	if (display_wm > display->max_wm) {
> -		DRM_DEBUG_KMS("display watermark is too large(%d), disabling\n",
> +		DRM_DEBUG_KMS("display watermark is too large(%d/%ld), disabling\n",
>  			      display_wm, display->max_wm);
>  		return false;
>  	}
>  
>  	if (cursor_wm > cursor->max_wm) {
> -		DRM_DEBUG_KMS("cursor watermark is too large(%d), disabling\n",
> +		DRM_DEBUG_KMS("cursor watermark is too large(%d/%ld), disabling\n",
>  			      cursor_wm, cursor->max_wm);
>  		return false;
>  	}
> diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
> index bdbab5c..0671934 100644
> --- a/drivers/gpu/drm/radeon/radeon_display.c
> +++ b/drivers/gpu/drm/radeon/radeon_display.c
> @@ -1087,8 +1087,9 @@ void radeon_compute_pll_legacy(struct radeon_pll *pll,
>  	*frac_fb_div_p = best_frac_feedback_div;
>  	*ref_div_p = best_ref_div;
>  	*post_div_p = best_post_div;
> -	DRM_DEBUG_KMS("%d %d, pll dividers - fb: %d.%d ref: %d, post %d\n",
> -		      freq, best_freq / 1000, best_feedback_div, best_frac_feedback_div,
> +	DRM_DEBUG_KMS("%lld %d, pll dividers - fb: %d.%d ref: %d, post %d\n",
> +		      (long long)freq,
> +		      best_freq / 1000, best_feedback_div, best_frac_feedback_div,
>  		      best_ref_div, best_post_div);
>  
>  }
> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
> index 22db51d..4ab866e 100644
> --- a/include/drm/drmP.h
> +++ b/include/drm/drmP.h
> @@ -122,7 +122,8 @@ struct drm_device;
>   * using the DRM_DEBUG_KMS and DRM_DEBUG.
>   */
>  
> -extern void drm_ut_debug_printk(unsigned int request_level,
> +extern __attribute__((format (printf, 4, 5)))
> +void drm_ut_debug_printk(unsigned int request_level,
>  				const char *prefix,
>  				const char *function_name,
>  				const char *format, ...);
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAk2swrgACgkQX1gOwKyEAw+b8wCfdNqYUGinwLaXk7PeNNu8ExXe
39EAoIWQPkZ3z8Au22tTM3cXOQlIuAH4
=4RWh
-----END PGP SIGNATURE-----

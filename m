Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab2FMTos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 15:44:48 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56198 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab2FMToo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 15:44:44 -0400
Date: Wed, 13 Jun 2012 21:46:15 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drm/i915: ignore pipe select bit when checking for
 LVDS register initialization
Message-ID: <20120613194614.GP4829@phenom.ffwll.local>
Mail-Followup-To: Seth Forshee <seth.forshee@canonical.com>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20120613162544.GJ4829@phenom.ffwll.local>
 <1339613218-4699-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339613218-4699-1-git-send-email-seth.forshee@canonical.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 01:46:58PM -0500, Seth Forshee wrote:
> The Lenovo Thinkpad T410 has the LVDS_PIPEB_SELECT bit set in the LVDS
> register when booted with the lid closed, even though the LVDS hasn't
> really been initialized. Ignore this bit so that the VBT value will be
> used instead.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Queued for -next, thanks for the patch. Chris had some reservations about
the sanity of this patch, but given that it works around bios-insanity I'm
gonna just take this chance to stab myself with lvds-machines blowing up
left and right ;-)
-Daniel
> ---
>  drivers/gpu/drm/i915/intel_display.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index e0aa064..ae17526 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -434,7 +434,7 @@ static bool is_dual_link_lvds(struct drm_i915_private *dev_priv,
>  		 * register is uninitialized.
>  		 */
>  		val = I915_READ(reg);
> -		if (!(val & ~LVDS_DETECTED))
> +		if (!(val & ~(LVDS_PIPE_MASK | LVDS_DETECTED)))
>  			val = dev_priv->bios_lvds_val;
>  		dev_priv->lvds_val = val;
>  	}
> -- 
> 1.7.9.5
> 

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

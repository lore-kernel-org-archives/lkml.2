Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab1EVP2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 11:28:17 -0400
Received: from waste.org ([173.11.57.241]:44811 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab1EVP2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 11:28:12 -0400
Subject: Re: Regression with i915 and suspend on Thinkpad x220
From: Matt Mackall <mpm@selenic.com>
To: Keith Packard <keithp@keithp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <yunlixz6yop.fsf@aiko.keithp.com>
References: <1306040157.3322.11.camel@calx>
	 <yunlixz6yop.fsf@aiko.keithp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 May 2011 10:28:09 -0500
Message-ID: <1306078089.4204.1.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-21 at 23:23 -0700, Keith Packard wrote:
> On Sat, 21 May 2011 23:55:57 -0500, Matt Mackall <mpm@selenic.com> wrote:
> 
> > I've got a new Thinkpad x220 which won't wake up from suspend with
> > 2.6.39, but works fine with 2.6.37.
> > 
> > I bisected it down to this cset:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4efe070896e1f7373c98a13713e659d1f5dee52a
> > 
> > drm/i915: make the blitter report buffer modifications to the FBC unit
> 
> For now, you should be able to disable FBC:
> 
> diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
> index c34a8dd..2a82895 100644
> --- a/drivers/gpu/drm/i915/i915_drv.c
> +++ b/drivers/gpu/drm/i915/i915_drv.c
> @@ -183,7 +183,7 @@ static const struct intel_device_info intel_sandybridge_d_info = {
>  static const struct intel_device_info intel_sandybridge_m_info = {
>  	.gen = 6, .is_mobile = 1,
>  	.need_gfx_hws = 1, .has_hotplug = 1,
> -	.has_fbc = 1,
> +	.has_fbc = 0,
>  	.has_bsd_ring = 1,
>  	.has_blt_ring = 1,
>  };

Appears to work, thanks.

-- 
Mathematics is the supreme nostalgia of our time.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab1EVQZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 12:25:26 -0400
Received: from waste.org ([173.11.57.241]:55353 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab1EVQZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 12:25:22 -0400
Subject: Re: Regression with i915 and suspend on Thinkpad x220
From: Matt Mackall <mpm@selenic.com>
To: Marek Otahal <markotahal@gmail.com>
Cc: Keith Packard <keithp@keithp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <201105221813.59862.markotahal@gmail.com>
References: <1306040157.3322.11.camel@calx>
	 <yunlixz6yop.fsf@aiko.keithp.com> <201105221813.59862.markotahal@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 May 2011 11:25:19 -0500
Message-ID: <1306081519.4204.5.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-22 at 18:13 +0200, Marek Otahal wrote:
> On Sunday 22 of May 2011 08:23:34 Keith Packard wrote:
> > On Sat, 21 May 2011 23:55:57 -0500, Matt Mackall <mpm@selenic.com> wrote:
> > > I've got a new Thinkpad x220 which won't wake up from suspend with
> > > 2.6.39, but works fine with 2.6.37.
> > > 
> > > I bisected it down to this cset:
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit
> > > ;h=4efe070896e1f7373c98a13713e659d1f5dee52a
> > > 
> > > drm/i915: make the blitter report buffer modifications to the FBC unit
> > 
> > For now, you should be able to disable FBC:
> > 
> > diff --git a/drivers/gpu/drm/i915/i915_drv.c
> > b/drivers/gpu/drm/i915/i915_drv.c index c34a8dd..2a82895 100644
> > --- a/drivers/gpu/drm/i915/i915_drv.c
> > +++ b/drivers/gpu/drm/i915/i915_drv.c
> > @@ -183,7 +183,7 @@ static const struct intel_device_info
> > intel_sandybridge_d_info = { static const struct intel_device_info
> > intel_sandybridge_m_info = { .gen = 6, .is_mobile = 1,
> >  	.need_gfx_hws = 1, .has_hotplug = 1,
> > -	.has_fbc = 1,
> > +	.has_fbc = 0,
> >  	.has_bsd_ring = 1,
> >  	.has_blt_ring = 1,
> >  };
> > 
> > Let us know if this works. There's a patch heading for 2.6.40 that
> > provides a module parameter to control FBC from the kernel command
> > line. We've got a couple X220s on order and I hope we'll be able to
> > reproduce (and fix) this issue -- FBC saves enough power that we'd like
> > to be able to leave it enabled on hardware that supports it.
> 
> Hello, 
> thanks for finding and working on this issue. 
> 
> I seem to be struck by the same bug, intel atom netbook, i915 graphics driver, 
> resume from suspend stopped working. 
> For details please see my bug reported at archlinux : 
> https://bugs.archlinux.org/24029
> 
> I tried suspending with the 2.6.37(.5) kernel as Matt suggested but it didn't 
> work for me either - Matt, could you tell me the last version you found 
> working? I'll try custom kernel with the patch provided when i have some time 
> for testing (is it working for you?). 

The last released kernel that worked for me was 2.6.37. Keith's patch
appears to work fine as well.

-- 
Mathematics is the supreme nostalgia of our time.



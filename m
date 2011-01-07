Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab1AGPwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:52:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab1AGPwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:52:04 -0500
Date: Fri, 7 Jan 2011 16:52:00 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: Linux 2.6.37
Message-ID: <20110107155200.GA3883@tiehlicka.suse.cz>
References: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com>
 <20110106104816.GA4026@tiehlicka.suse.cz>
 <AANLkTi=aTKFVO8Lx=fDUGrxVaQL73XrsxoOP7-qYKksb@mail.gmail.com>
 <1bdc18$j6a1ns@fmsmga002.fm.intel.com>
 <AANLkTinY5XysANA9Qd-h=U8wzDNjF4n0sSxMsXH4P+99@mail.gmail.com>
 <AANLkTinhiAfhnTsHwR48Gq5NLApy5iAAMwv830+SJDZU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinhiAfhnTsHwR48Gq5NLApy5iAAMwv830+SJDZU@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 06-01-11 22:08:46, Alex Riesen wrote:
> On Thu, Jan 6, 2011 at 21:55, Alex Riesen <raa.lkml@gmail.com> wrote:
> > On Thu, Jan 6, 2011 at 18:49, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >>
> >> My fear is that some machines have a dependency between the backlight
> >> and panel power status. The patch in question changed the timing between
> >> turning on the panel and adjusting the backlight which would be restore
> >> with:
> >>
> >> diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
> >> index aa23070..0b40b4f 100644
> >> --- a/drivers/gpu/drm/i915/intel_lvds.c
> >> +++ b/drivers/gpu/drm/i915/intel_lvds.c
> >> @@ -106,6 +106,12 @@ static void intel_lvds_enable(struct intel_lvds *intel_lvds)
> >> ?? ?? ?? ??I915_WRITE(ctl_reg, I915_READ(ctl_reg) | POWER_TARGET_ON);
> >> ?? ?? ?? ??POSTING_READ(lvds_reg);
> >>
> >> + ?? ?? ?? {
> >> + ?? ?? ?? ?? ?? ?? ?? u32 reg = HAS_PCH_SPLIT(dev) ? PCH_PP_STATUS : PPS_STATUS;
> ...
> > FWIW it does not compile:
> > ??CC ?? ?? ??drivers/gpu/drm/i915/intel_lvds.o
> > drivers/gpu/drm/i915/intel_lvds.c: In function ???intel_lvds_enable???:
> > drivers/gpu/drm/i915/intel_lvds.c:110: error: ???PPS_STATUS??? undeclared
> 
> Ah, I see. Should be PP_STATUS. Whatever. It does not help. The backlight
> stays off.

It didn't help in my case either

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

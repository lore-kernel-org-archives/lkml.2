Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab1AFVD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:03:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:20764 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab1AFVD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:03:26 -0500
Message-Id: <0d30dc$km57aq@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,285,1291622400"; 
   d="scan'208";a="694328666"
Date: Thu, 06 Jan 2011 21:03:22 +0000
To: Alex Riesen <raa.lkml@gmail.com>
Subject: Re: Linux 2.6.37
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
In-Reply-To: <AANLkTinY5XysANA9Qd-h=U8wzDNjF4n0sSxMsXH4P+99@mail.gmail.com>
References: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com> <20110106104816.GA4026@tiehlicka.suse.cz> <AANLkTi=aTKFVO8Lx=fDUGrxVaQL73XrsxoOP7-qYKksb@mail.gmail.com> <1bdc18$j6a1ns@fmsmga002.fm.intel.com> <AANLkTinY5XysANA9Qd-h=U8wzDNjF4n0sSxMsXH4P+99@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011 21:55:23 +0100, Alex Riesen <raa.lkml@gmail.com> wrote:
> On Thu, Jan 6, 2011 at 18:49, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> >
> > My fear is that some machines have a dependency between the backlight
> > and panel power status. The patch in question changed the timing between
> > turning on the panel and adjusting the backlight which would be restore
> > with:
> >
> > diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
> > index aa23070..0b40b4f 100644
> > --- a/drivers/gpu/drm/i915/intel_lvds.c
> > +++ b/drivers/gpu/drm/i915/intel_lvds.c
> > @@ -106,6 +106,12 @@ static void intel_lvds_enable(struct intel_lvds *intel_lvds)
> >        I915_WRITE(ctl_reg, I915_READ(ctl_reg) | POWER_TARGET_ON);
> >        POSTING_READ(lvds_reg);
> >
> > +       {
> > +               u32 reg = HAS_PCH_SPLIT(dev) ? PCH_PP_STATUS : PPS_STATUS;
> > +               if (wait_for(I915_READ(reg) & PP_ON, 1000))
> > +                       DRM_ERROR("timed out waiting for panel to power up\n");
> > +       }
> > +
> >        intel_panel_set_backlight(dev, dev_priv->backlight_level);
> >  }
> 
> FWIW it does not compile:
>   CC      drivers/gpu/drm/i915/intel_lvds.o
> drivers/gpu/drm/i915/intel_lvds.c: In function ‘intel_lvds_enable’:
> drivers/gpu/drm/i915/intel_lvds.c:110: error: ‘PPS_STATUS’ undeclared
> (first use in this function)
> drivers/gpu/drm/i915/intel_lvds.c:110: error: (Each undeclared
> identifier is reported only once
> drivers/gpu/drm/i915/intel_lvds.c:110: error: for each function it appears in.)
> make[4]: *** [drivers/gpu/drm/i915/intel_lvds.o] Error 1

Daniel quickly pointed out my typo: s/PPS_STATUS/PP_STATUS/

Apologies,
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab1AKK6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 05:58:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:13398 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab1AKK6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 05:58:44 -0500
Message-Id: <b7da2f$q3onue@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,306,1291622400"; 
   d="scan'208";a="876371918"
Date: Tue, 11 Jan 2011 10:58:39 +0000
To: Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] drm for rc1
Cc: Dave Airlie <airlied@linux.ie>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eric Anholt <eric@anholt.net>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
In-Reply-To: <AANLkTi=TSWj4TPVbPVxY6BNcnvUA24buZggjCy2xu_83@mail.gmail.com>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie> <AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com> <AANLkTim5oVZqMBtan5_TMOxaWbqkF=aDcBYFNYy55kt_@mail.gmail.com> <AANLkTi=TSWj4TPVbPVxY6BNcnvUA24buZggjCy2xu_83@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011 14:51:40 +1000, Dave Airlie <airlied@gmail.com> wrote:
> On Tue, Jan 11, 2011 at 2:48 PM, Dave Airlie <airlied@gmail.com> wrote:
> > On Tue, Jan 11, 2011 at 2:16 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >> On Mon, Jan 10, 2011 at 2:59 PM, Dave Airlie <airlied@linux.ie> wrote:
> >>> Highlights:
> >>> core/drivers: add support for high precision vblank timestamps
> >>> radeon: pageflipping support, Gen2 PCIE support
> >>> nouveau: reworked VRAM and VM support
> >>> intel: better ILK/SNB powersaving support, Full GTT support
> >>
> >> Lowlights: it's broken.
> >>
> >> I get millions of messages like:
> >>
> >>  ...
> >>  [ 8482.000414] [drm:i915_hangcheck_ring_idle] *ERROR* Hangcheck
> >> timer elapsed... render ring idle [waiting on 30938, at 30938], missed
> >> IRQ?
> >>  [ 8485.918124] [drm:i915_hangcheck_ring_idle] *ERROR* Hangcheck
> >> timer elapsed... render ring idle [waiting on 31068, at 31068], missed
> >> IRQ?
> >>  [ 8487.926963] [drm:i915_hangcheck_ring_idle] *ERROR* Hangcheck
> >> timer elapsed... render ring idle [waiting on 31129, at 31129], missed
> >> IRQ?
> >>  ...
> >>
> >> and everything is very choppy. I assume it's the power saving thing
> >> that broke again, but that's just a total random guess, I have nothing
> >> to actually back that up with.
> >>
> >> It worked fine after boot, but those problems began at 8287.139375
> >> (about two hours after boot - it may have coincided with screen saver,
> >> but who knows?)  and have been happening constantly since. The machine
> >> is not really usable, I'm writing this with annoying 2-second pauses
> >> every once in a while.
> >
> > Okay I'll try and reproduce and curse Chris and Jesse, does booting with
> > i915.powersave=0 help any?
> 
> I've also noticed Chris has some more patches in drm-intel-next I
> haven't got in this pull request.
> 
> I don't think he's sent me a pull request though so not telling how
> stable they are.

Yes, there are a few pending fixes. I've been waiting on feedback from
testing for some more before asking for a pull. In part because we have
some more eDP fixes, courtesy of Jesse, that makes everyone but Jim Getty
happy.

However, I've not seen anything like this so I doubt that d-i-n contains
the fix.

Dave, is yours related to the DMAR errors that is plaguing your systems?

Linus, is anything else kicked off upon powersaving? A screen saver or is
it just the blanking that triggers the mess?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

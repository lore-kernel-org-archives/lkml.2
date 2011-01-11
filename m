Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab1AKUFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 15:05:30 -0500
Received: from mga03.intel.com ([143.182.124.21]:61220 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465Ab1AKUF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 15:05:28 -0500
Message-Id: <849307$b3orev@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,308,1291622400"; 
   d="scan'208";a="373059039"
Date: Tue, 11 Jan 2011 20:05:23 +0000
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] drm for rc1
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
        Eric Anholt <eric@anholt.net>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
In-Reply-To: <20110111114505.0bd854c7@jbarnes-desktop>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie> <AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com> <AANLkTim5oVZqMBtan5_TMOxaWbqkF=aDcBYFNYy55kt_@mail.gmail.com> <0aea052d-70ff-41ea-8776-c6d974c10337@email.android.com> <AANLkTim0rn7Vem6YJM5tVKM0PX4YdnNmaeqmpS=Vp7rc@mail.gmail.com> <AANLkTi=eRHbgerpdPYdoOo45LruNTk0rNsWvOO-kYxyQ@mail.gmail.com> <20110111111203.279eae50@jbarnes-desktop> <AANLkTikMMG1S6qp0-jKnQUcR5DgC+WWVfgOo2PExFA2w@mail.gmail.com> <20110111114505.0bd854c7@jbarnes-desktop>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011 11:45:05 -0800, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Tue, 11 Jan 2011 11:25:39 -0800
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Tue, Jan 11, 2011 at 11:12 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > >
> > > Have you tried reproducing it using xset dpms force off or similar?
> > 
> > That doesn't seem to do anything bad.
> > 
> > In fact, I think the second time it happened the screen never went
> > black - just the random photo thing was on. But no, forcing the screen
> > saver on doesn't do it either (ie pressing the "lock screen" icon and
> > waiting for a few pictures to cycle).
> > 
> > Maybe the screen just has to be inactive for a longer time: do you do
> > some dynamic "let's power things down if nothing is changing"?
> 
> There are some timeouts, the FBC engine will recompress about once
> every 15s; the self-refresh timers are much smaller though so it should
> be active anytime the CPU enters a deep sleep state.  The clock
> frequency changes in millisecond time too, you can check the status of
> that in /sys/kernel/debug/dri/0/i915_drpc_status and i915_cur_delayinfo.
> 
> I wonder if re-enabling rc6 may have caused your issues?  That would be:
> 
> commit 29a15061ff5df5bf9bf49c05c17f41eb2807a55a
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Wed Jan 5 12:01:24 2011 -0800
> 
>     drm/i915: re-enable rc6 support for Ironlake+

We haven't actually got as far as that patch yet, that's waiting for a
suitable juncture to send the request. Now that the trees have converged I
can pick which patches need to go for rc1 and which can wait for -next.

Looking at the set of outstanding patch, my suspect would be the ring irq
refcounting which needed a fix and seems implicated by the error message.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

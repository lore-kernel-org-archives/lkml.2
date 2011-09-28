Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab1I1JJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 05:09:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:43733 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab1I1JJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 05:09:19 -0400
Message-Id: <aefc95$1m20sf@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="56689551"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 6/9] drm/i915: Fix PCH SSC reference clock settings
To: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
In-Reply-To: <yunr531981s.fsf@aiko.keithp.com>
References: <yunbou6lxb4.fsf@aiko.keithp.com> <1317103906-4649-1-git-send-email-keithp@keithp.com> <1317103906-4649-7-git-send-email-keithp@keithp.com> <e0d58a$1mfd94@orsmga002.jf.intel.com> <yunr531981s.fsf@aiko.keithp.com>
Date: Wed, 28 Sep 2011 10:09:13 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011 11:03:43 -0700, Keith Packard <keithp@keithp.com> wrote:
Non-text part: multipart/signed
> On Tue, 27 Sep 2011 17:47:10 +0100, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > On Mon, 26 Sep 2011 23:11:43 -0700, Keith Packard <keithp@keithp.com> wrote:
> > > The PCH refclk settings are global, so we need to look at all of the
> > > encoders, not just the current encoder when deciding how to configure
> > > it. Also, handle systems with more than one panel (any combination of
> > > PCH/non-PCH eDP and LVDS).
> > 
> > As I read it, this sets the refclk not on the active configuration, but
> > on all the hardware detected for the system whether enabled or not.
> 
> Correct. We cannot randomly turn ref clocks on/off without also
> disconnecting them from the PLLs that they drive.
> 
> What we could do is figure out which of the two clocks need to be
> enabled and modify the mode set code to turn them on when needed before
> setting the mode, and then turn them off after, when they aren't
> needed. This would leave them off until needed, which might be nice?
> 
> This will make changing the driver to not disable the panel at startup
> time harder; we'll need to switch the panel to the non-SSC reference,
> turn the SSC reference off, reconfigure it and then switch the panel
> back to the SSC reference. That's a project for a future change though.

My understanding was that we could not enable SSC at all if we had a VGA,
DVI/HDMI or TV output; DP may or may not work with SSC.

The patch says that we will want to enable SSC if we have an SSC capbable
LVDS or eDP, which is certainly true. And that we can always do so if we
remember to set a magic bit in refclk to prevent non-SSC capable outputs
from being upset. I have not seen anything to support that last statement,
but, then again, I have not seen anything that actually explains what CK505
is!

Having said that, this is an obvious improvement over the current
situation in that we do choose correctly in more circumstances and we do
not reprogram the refclk whilst active.

As an incremental improvement [in my understanding ;-]:
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

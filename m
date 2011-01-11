Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab1AKOPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:15:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:18011 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822Ab1AKOPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:15:00 -0500
Message-Id: <0d30dc$knd39a@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,307,1291622400"; 
   d="scan'208";a="695635242"
Date: Tue, 11 Jan 2011 14:14:52 +0000
To: Pavel Machek <pavel@ucw.cz>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] drm for rc1
Cc: Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
In-Reply-To: <20110111133329.GD10705@atrey.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie> <AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com> <AANLkTim5oVZqMBtan5_TMOxaWbqkF=aDcBYFNYy55kt_@mail.gmail.com> <0aea052d-70ff-41ea-8776-c6d974c10337@email.android.com> <20110111133329.GD10705@atrey.karlin.mff.cuni.cz>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011 14:33:29 +0100, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
> 
> > >>> Highlights:
> > >>> core/drivers: add support for high precision vblank timestamps
> > >>> radeon: pageflipping support, Gen2 PCIE support
> > >>> nouveau: reworked VRAM and VM support
> > >>> intel: better ILK/SNB powersaving support, Full GTT support
> > >>
> > >> Lowlights: it's broken.
> 
> Heh, at this point I expected Linus to complain about milion merges in
> changelog...

Applying bug fixes to one tree and pushing those to 2.6.37 and doing
feature work in another which also depend upon those same bug fixes...
The merges I felt were fairly infrequent, either after a pull request and
subsequent fast-forward of -fixes (so that -next was always a superset of
the current upstream rc) or I applied a patch to -fixes that would
conflict with -next. After those, I did an immediate merge to resolve the
conflict whilst the code was still fresh.

The whole point of trying to keep two trees intact is to be able to
perform continuous testing on both. No matter how hard I try not to, it
seems I always break Linus's machine.

> > Arg.  It's been ok on my ILK systems, but Chris has found some
> >issues with out watermarking code iirc; apparently we're underflowing
> >the display FIFO, causing all sorts of trouble.  If it works before
> >the pull of Dave's tree, can you bisect?
> 
> Watermarking code? What goes on there?

FIFO watermarks, they determine when the display fetches from the scanout
buffer to fill the pipe. If we run out of FIFO entries then the display
flickers at best, at worst we may hard hang the machine.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

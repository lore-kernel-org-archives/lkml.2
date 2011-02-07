Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab1BGVUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:20:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51559 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744Ab1BGVUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:20:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
Date: Mon, 7 Feb 2011 22:20:30 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Takashi Iwai <tiwai@suse.de>, Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com> <AANLkTinv=pfArgT4VFCUeY_bKb4q3KSREvU+L8V5k0G9@mail.gmail.com> <AANLkTim2czZfsbGaG=K-=dV5hENgUOUhjBpWoa+mTjyb@mail.gmail.com>
In-Reply-To: <AANLkTim2czZfsbGaG=K-=dV5hENgUOUhjBpWoa+mTjyb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102072220.30706.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 07, 2011, Jeff Chua wrote:
> On Mon, Feb 7, 2011 at 9:38 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> > On Mon, Feb 7, 2011 at 6:15 PM, Takashi Iwai <tiwai@suse.de> wrote:
> >>> Thanks, that looks good.  What about other files?  Did you change
> >>> (especially intel_drv.h) from Linus git tree?
> >
> > I will try again  from a fresh build tonight.
> >
> >>> I'll also check later to be sure (now I have no machine for testing).
> >> I don't see any problem with my machine (but running in 32bit).
> >>
> >> Are you sure that you are seeing the same CRTC?  There are two active
> >> CRTCs on Intel, and both are initialized and set up.
> >
> > I don't know about that. Even when I attempt to just the pointer
> > directly as in "static void intel_crtc_reset(struct intel_crtc
> > *intel_crtc)", it ended up getting a different value. Strange.
> >
> > intel_crtc ffff880239aa5800
> > intel_crtc ffff880239aa5000
> >
> >
> > I'm building everything fresh now.
> 
> Same issue encountered even after a fresh build.

So, can you confirm that on your machine the issue is 100% reproducible and
it goes away after reverting

commit 5d1d0cc87fc0887921993ea0742932e0c8adeda0
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Jan 24 15:02:15 2011 +0000

    drm/i915: Reset crtc after resume

?

Rafael

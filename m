Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2JFIYp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:24:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:11713 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab2JFIYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:24:41 -0400
Message-Id: <051c15$4i14fm@AZSMGA002.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,543,1344236400"; 
   d="scan'208";a="153129462"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: 3.5 regression on i915
To: Willy Tarreau <w@1wt.eu>, Dave Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org
In-Reply-To: <20121006075956.GF21163@1wt.eu>
References: <20121005234218.GC21163@1wt.eu> <CAPM=9txTo4agvvFnY8KbF82WoCxh0Pmb1HcoEP4ZUbauL5Ws8Q@mail.gmail.com> <20121005235845.GE21163@1wt.eu> <20121006072704.GA22465@1wt.eu> <CAPM=9twQb7BUe6cAD-5THBBP-eYAU56__V5UXNn2qfqdFkVwmA@mail.gmail.com> <20121006075956.GF21163@1wt.eu>
Date: Sat, 06 Oct 2012 09:24:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Oct 2012 09:59:56 +0200, Willy Tarreau <w@1wt.eu> wrote:
> On Sat, Oct 06, 2012 at 03:43:56AM -0400, Dave Airlie wrote:
> > On Sat, Oct 6, 2012 at 3:27 AM, Willy Tarreau <w@1wt.eu> wrote:
> > > On Sat, Oct 06, 2012 at 01:58:45AM +0200, Willy Tarreau wrote:
> > >> On Sat, Oct 06, 2012 at 09:48:57AM +1000, Dave Airlie wrote:
> > >> > Any reason you don't have KMS, you'll keep hitting these non-kms bugs
> > >> > since it has no users anymore really.
> > >> >
> > >> > Granted they'll get fixed, but I suspect its a losing battle over time.
> > >>
> > >> Well, back in old times every time I tried to enable it, I only ran into
> > >> problems so I got used to disable it, which made sense since it didn't
> > >> bring me any benefit.
> > >
> > > OK I found why in the end. When I enable KMS, my X server fails to start
> > > and segfaults in intel_drv.so. So I think that the comment in Kconfig
> > > below is quite appropriate :
> > 
> > Okay are you running a really old userspace? just wondering what could
> > cause this.
> 
> yes, my Xorg is 1.4.2 and xf86-video-intel is 2.7.1.
> 
> I have additional information, I retested with 3.4.12 with and without KMS :
> 
>    3.4.12, no KMS : X works fine
>    3.4.12, KMS    : X works fine but some garbage follows the mouse pointer
>                     on the external display
>    3.5.x   no KMS : kernel BUG
>    3.5.x   KMS    : X server segfaults in intel driver
> 
> So in fact, both the KMS/non-KMS confs have regressed in 3.5 on this setup.
> 
> It is possible that the commit which removed the list of pinned inactive
> objects (1b50247a) has uncovered another long-time bug.

More likely X is segfaulting for another reason altogether. Can you
please attach the stacktrace (with symbols!) and see if another
bisection is required?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

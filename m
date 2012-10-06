Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab2JFJEK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 05:04:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:25128 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145Ab2JFJEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 05:04:06 -0400
Message-Id: <275ffc$6skdfn@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,543,1344236400"; 
   d="scan'208";a="231355895"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: 3.5 regression on i915
To: Willy Tarreau <w@1wt.eu>
Cc: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20121006084258.GB22618@1wt.eu>
References: <20121005234218.GC21163@1wt.eu> <CAPM=9txTo4agvvFnY8KbF82WoCxh0Pmb1HcoEP4ZUbauL5Ws8Q@mail.gmail.com> <20121005235845.GE21163@1wt.eu> <20121006072704.GA22465@1wt.eu> <CAPM=9twQb7BUe6cAD-5THBBP-eYAU56__V5UXNn2qfqdFkVwmA@mail.gmail.com> <20121006075956.GF21163@1wt.eu> <051c15$4i14fm@AZSMGA002.ch.intel.com> <20121006084258.GB22618@1wt.eu>
Date: Sat, 06 Oct 2012 10:04:00 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Oct 2012 10:42:58 +0200, Willy Tarreau <w@1wt.eu> wrote:
> On Sat, Oct 06, 2012 at 09:24:35AM +0100, Chris Wilson wrote:
> > More likely X is segfaulting for another reason altogether. Can you
> > please attach the stacktrace (with symbols!) and see if another
> > bisection is required?
> 
> Yes, here it is.
> 
> (EE) intel(0): Failed to initialize kernel memory manager
> 
> Backtrace:
> 0: X(xf86SigHandler+0x7e) [0x80d8b5e]
> 1: [0xffffe400]
> 2: /usr/lib/xorg/modules/drivers//intel_drv.so(i830_allocator_init+0x332) [0xb73756e2]

Drat, that is:

commit 7bb6fb8dd958ae773ac205282e3c0b56c22e01ed
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Apr 24 08:22:52 2012 +0200

    drm/i915: disallow gem ums init ioctl for kms
    
    This ioctl used in a kms driver is only useful to create massive
    havoc.

Can't see just why -intel crashes, but I presume it is during the
i830_free_memory along that path.

Anyway, looks like that patch needs to be reverted.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370Ab0IGRiC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 13:38:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:20534 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267Ab0IGRh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 13:37:59 -0400
Message-Id: <8u3s94$geonkf@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,329,1280732400"; 
   d="scan'208";a="552361627"
Date: Tue, 07 Sep 2010 18:37:55 +0100
To: Eric Anholt <eric@anholt.net>, Andy Isaacson <adi@hexapodia.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [2.6.36-rc2 regression] X201s: resume-from-S2R hangs
Cc: Zou Nan hai <nanhai.zou@intel.com>
References: <20100906090536.GA12250@hexapodia.org> <87fwxlbhq5.fsf@pollan.anholt.net>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <87fwxlbhq5.fsf@pollan.anholt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Sep 2010 10:12:34 -0700, Eric Anholt <eric@anholt.net> wrote:
> On Mon, 6 Sep 2010 02:05:36 -0700, Andy Isaacson <adi@hexapodia.org> wrote:
> > I have a Thinkpad X201s on which suspend-to-RAM was quite reliable until
> > after 2.6.36-rc1; with problematic kernels, suspend seems to work OK
> > (the machine goes to sleep with the moon LED steadily lit) but on resume
> > the LCD never lights up (and it's not just the backlight, the screen
> > isn't drawing at all) and the keyboard and network are dead.  Nothing
> > makes it to syslog, either.  The moon LED is turned off though.
> > 
> > There seems to be some timing component to the problem -- some problem
> > kernels will suspend reliably 25% or 50% of the time and hang the rest.
> > There also seems to be some per-reboot state involved; one problem
> > kernel suspended successfully and survived 25 suspends in a row without
> > triggering a failure.  (But after a reboot, the first suspend hung...)
> > Other problem kernels fail on 4 out of 4 reboots.

We introduced a timing regression which should be fixed by 
http://cgit.freedesktop.org/~ickle/drm-intel/ drm-intel-fixes
[http://cgit.freedesktop.org/~ickle/drm-intel/commit/?id=300387c0b57d75e5218e2881d6ad2720657a8bcf]

> > Bisecting is pretty hard under these conditions, but it seems to point
> > to
> 
> Weird.  That's exactly the hardware that I tested RC6 on, and I haven't
> seen a single resume failure on mine.  Sounds like time to revert for
> this release.

At the moment we have a second resume regression that has been difficult to
reproduce, https://bugs.freedesktop.org/show_bug.cgi?id=29406 :

commit d1b851fc0d105caa6b6e3e7c92d2987dfb52cbe0
Author: Zou Nan hai <nanhai.zou@intel.com>
Date:   Fri May 21 09:08:57 2010 +0800

    drm/i915: implement BSD ring buffer V2

The workaround for this is to #define HAS_BSD(dev) 0 [i915_drv.h].

Andy, can you try the workaround to see if this is the same issue in a
different guise?

Alternatively, we can be optimistic that it is just a timing issue fixed
in drm-intel-next. :)

Otherwise we will revert that patch. Thanks.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre

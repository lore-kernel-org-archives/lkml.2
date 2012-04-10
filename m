Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab2DJIVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:21:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56920 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab2DJIVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:21:46 -0400
Date: Tue, 10 Apr 2012 01:21:42 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Shuah Khan <shuahkhan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, rpurdie@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] LEDS-One-Shot-Timer-Trigger-implementation
Message-ID: <20120410082142.GA19471@core.coreip.homeip.net>
References: <1333310039.2879.4.camel@lorien2>
 <20120406165353.ab667eb0.akpm@linux-foundation.org>
 <1333808024.2728.39.camel@lorien2>
 <20120407215641.GA4539@core.coreip.homeip.net>
 <20120409094219.57d321cb@notabene.brown>
 <20120409000646.GA24185@core.coreip.homeip.net>
 <20120410082506.51eaa64b@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410082506.51eaa64b@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 08:25:06AM +1000, NeilBrown wrote:
> On Sun, 8 Apr 2012 17:06:46 -0700 Dmitry Torokhov <dmitry.torokhov@gmail.com>
> wrote:
> 
> > On Mon, Apr 09, 2012 at 09:42:19AM +1000, NeilBrown wrote:
> 
> > > Also, I don't think 'ff' allows for "vibrate for N milliseconds".
> > > It appears that one uses the "rumble" effect and have to say "turn it on",
> > > then "turn it off".  Is that correct?
> > 
> > No, it is not.
> > 
> > > I found 'struct ff_replay' which has a 'length' which is a duration, but it
> > > doesn't seem to be used.
> > 
> > It does, see drivers/input/ff-memless.c where it us used to schedule
> > when effect starts and how long it should play. Non memoryless devices
> > (such as iforce) are supposed to schedule effects themselves.
> > 
> > > 
> > > How would you tell the force feedback framework to play the vibrator for
> > > 120ms, then stop?
> > 
> > By specifying replay->length = 120
> 
> You seem to make a convincing case.  I'll explore this some more and see what
> it is like in practice.
> 
> 
> Clipping from above:
> 
> > 
> > Well, if you consider "input" is really "hid" then FF is really
> > appropriate for iterfacing with a human.
> > 
> 
> A slightly related question.  My phone has accelerometers in it.  I want to
> use them entirely a human-interface-devices.  The device itself can detect
> inversions and taps and jerks and I want to report just those to user-space,
> preferably via the input (aka hid :-) subsystem.  However my understanding is
> that accelerometer drivers aren't welcome as input drivers.  Is that still
> true?
> There is nothing 'industrial' about these accelerometers so I would like to
> avoid 'iio'.  What are your thoughts about this?

I got convinced that 3-axis accelerometers should be included in input
devices, at least until we have a reliable bridge between iio and input.

If you take a look into drivers/input/misc you will find a few of them
there.

Thanks.

-- 
Dmitry

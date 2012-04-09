Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab2DIAGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 20:06:54 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:42561 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab2DIAGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 20:06:53 -0400
Date: Sun, 8 Apr 2012 17:06:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Shuah Khan <shuahkhan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, rpurdie@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] LEDS-One-Shot-Timer-Trigger-implementation
Message-ID: <20120409000646.GA24185@core.coreip.homeip.net>
References: <1333310039.2879.4.camel@lorien2>
 <20120406165353.ab667eb0.akpm@linux-foundation.org>
 <1333808024.2728.39.camel@lorien2>
 <20120407215641.GA4539@core.coreip.homeip.net>
 <20120409094219.57d321cb@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120409094219.57d321cb@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 09:42:19AM +1000, NeilBrown wrote:
> On Sat, 7 Apr 2012 14:56:41 -0700 Dmitry Torokhov <dmitry.torokhov@gmail.com>
> wrote:
> 
> > Hi Shuah,
> > 
> > On Sat, Apr 07, 2012 at 08:13:44AM -0600, Shuah Khan wrote:
> > > 
> > > > > +This feature will help implement vibrate functionality which requires one
> > > > > +time activation of vibrate mode without a continuous vibrate on/off cycles.
> > > > 
> > > > They make vibrating LED? ;)
> > > > 
> > > > What's going on here?  You're proposing to repurpose the LEDs code to
> > > > drive vibration devices?  Or some devices couple a LED with a vibration
> > > > device?
> > > 
> > > I owe you filling in the blanks type explanation. Let me describe the
> > > use-case I am trying to address first. Vibrater function on phones is
> > > implemented using PWM pins on SoC or PMIC. When there is no such
> > > hardware present, a software solution is needed. Currently two drivers
> > > timed-gpio and timed-output (under staging/android in Linux 3.3)
> > > together implement the software vibrate feature. The main functionality
> > > it implements is the one time enables of timer to prevent user space
> > > crashes leaving the phone in vibrate mode causing the battery to drain.
> > > leds as it is implemented currently, is not suitable to address this
> > > use-case as it doesn't support one time enables.
> > 
> > So why do not you use memoryless force feedback framework that other
> > devices use (see drivers/input/misc/*vibra.c drivers).
> > 
> > Thanks.
> > 
> 
> I don't see that using a "force feedback" "input" device to control a
> vibrator - which is neither "force feedback" nor "input", makes any more
> sense than using an "led" device to control something that isn't an LED.
> So we are even there.

Well, if you consider "input" is really "hid" then FF is really
appropriate for iterfacing with a human.

> 
> I think driving leds by writing to sysfs files is lot easier (for scripting
> languages particularly) than the ioctls or binary writes needed for managing
> input devices.
> 
> Of course, if the 'input' framework were used for controlling all LEDs -
> rather than just the LEDs on keyboard - then it might make sense...
> 
> Also, I don't think 'ff' allows for "vibrate for N milliseconds".
> It appears that one uses the "rumble" effect and have to say "turn it on",
> then "turn it off".  Is that correct?

No, it is not.

> I found 'struct ff_replay' which has a 'length' which is a duration, but it
> doesn't seem to be used.

It does, see drivers/input/ff-memless.c where it us used to schedule
when effect starts and how long it should play. Non memoryless devices
(such as iforce) are supposed to schedule effects themselves.

> 
> How would you tell the force feedback framework to play the vibrator for
> 120ms, then stop?

By specifying replay->length = 120

Thanks.

-- 
Dmitry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788Ab2DISqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:46:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54415 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757689Ab2DISqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:46:06 -0400
Date: Mon, 9 Apr 2012 11:45:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, neilb@suse.de,
        rpurdie@linux.intel.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] LEDS-One-Shot-Timer-Trigger-implementation
Message-ID: <20120409184558.GB18542@core.coreip.homeip.net>
References: <1333310039.2879.4.camel@lorien2>
 <20120406165353.ab667eb0.akpm@linux-foundation.org>
 <1333808024.2728.39.camel@lorien2>
 <20120407215641.GA4539@core.coreip.homeip.net>
 <1333990549.2871.10.camel@lorien2>
 <20120409173703.GA18542@core.coreip.homeip.net>
 <1333995365.2871.17.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333995365.2871.17.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 12:16:05PM -0600, Shuah Khan wrote:
> On Mon, 2012-04-09 at 10:37 -0700, Dmitry Torokhov wrote:
> > On Mon, Apr 09, 2012 at 10:55:49AM -0600, Shuah Khan wrote:
> > > On Sat, 2012-04-07 at 14:56 -0700, Dmitry Torokhov wrote:
> > > > Hi Shuah,
> > > > 
> > > > On Sat, Apr 07, 2012 at 08:13:44AM -0600, Shuah Khan wrote:
> > > > > 
> > > > > > > +This feature will help implement vibrate functionality which requires one
> > > > > > > +time activation of vibrate mode without a continuous vibrate on/off cycles.
> > > > > > 
> > > > > > They make vibrating LED? ;)
> > > > > > 
> > > > > > What's going on here?  You're proposing to repurpose the LEDs code to
> > > > > > drive vibration devices?  Or some devices couple a LED with a vibration
> > > > > > device?
> > > > > 
> > > > > I owe you filling in the blanks type explanation. Let me describe the
> > > > > use-case I am trying to address first. Vibrater function on phones is
> > > > > implemented using PWM pins on SoC or PMIC. When there is no such
> > > > > hardware present, a software solution is needed. Currently two drivers
> > > > > timed-gpio and timed-output (under staging/android in Linux 3.3)
> > > > > together implement the software vibrate feature. The main functionality
> > > > > it implements is the one time enables of timer to prevent user space
> > > > > crashes leaving the phone in vibrate mode causing the battery to drain.
> > > > > leds as it is implemented currently, is not suitable to address this
> > > > > use-case as it doesn't support one time enables.
> > > > 
> > > > So why do not you use memoryless force feedback framework that other
> > > > devices use (see drivers/input/misc/*vibra.c drivers).
> > > > 
> > > 
> > > Dimitry,
> > > 
> > > I took a look at these vibra* drivers. The three vibrate drivers are
> > > chip-set specific. The use-case I have is a non-chip set approach to
> > > address the use-case when vibrate hardware is not present. Are you
> > > envisioning a generic approach using ff-memoryless infrastructure?
> > 
> > Shuah,
> > 
> > I guess I am confused now. You need some form of hardware to make your
> > device to vibrate.
> > 
> > What exactly are you trying to do? Are you trying to:
> > 
> > 1. activate vibration on devices that can actually do it using LED
> >    interface, or
> > 
> > 2. use LEDs as an alternative to vibrate on devices that can't
> >    physically vibrate?
> > 
> > Thanks.
> 
> What I meant by generic approach is a higher level interface that is not
> tied too closely to the underlying hardware. Similar to the leds-pwm.c
> and leds-gpio.c handle gpio and pwm based leds. The vibrate hardware in
> my sue-case is a gpio based and could pwm based on some phones.

Ok, so you need to add drivers/input/misc/gpio-vibrate.c and pwm-vibrate.c
and then use FF to activate them. This way we have all vibrate
implementation use one subsystem instead of splitting between
input/led/whatever else people could come up with.

Thanks.

-- 
Dmitry

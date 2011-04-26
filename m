Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab1DZVGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:06:41 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57404 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756450Ab1DZVGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:06:30 -0400
Date: Tue, 26 Apr 2011 23:06:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, rpurdie@rpsys.net,
        lenz@cs.wisc.edu, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [RFC PATCH v2 1/3] PM / Core: suspend_again callback for
 device PM.
Message-ID: <20110426210627.GA28033@elf.ucw.cz>
References: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com>
 <201104261347.21811.rjw@sisk.pl>
 <20110426203543.GB27140@elf.ucw.cz>
 <201104262247.44113.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104262247.44113.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > "too heavy" (in fact it's much lighter weight than resuming all devices
> > > that your approach doesn't prevent from happening, so for example on my
> > > desktop/notebook machines I woulnd't mind at all if user space were
> > > thawed after all of the devices had been resumed).
> > 
> > Well, it would be behavior change for the user. I told the zaurus to
> > go s2ram, I do not expect it to wake up after 5 minutes because it
> > needed to check battery status.
> > 
> > I'd have to modify my userland to retry suspend again and again and
> > again...
> 
> And that's exactly what should be done.  Have a user space process controlling
> that, because avoiding to thaw user space doesn't buy us almost
> anything.

That makes Zaurus implement different user-kernel interface than PC
class machine, because of hardware quirk.

> Now, I know that it's probably easier to modify the kernel than to write
> a user space tool for that, test it and so on, but "easier" is not necessarily
> "better".

It is easier, allows us to keep same user-kernel interface on PC and
Zaurus, and is compatible with 2.6.38.

Heck, I'm used to typing "echo mem > /sys/power/state". I should not
have to learn different interface just because Zaurus does not have
proper hardware charger.

> > I'm not sure if we need to cover hibernation. Do you know any machine
> > that needs this for hibernation case?
> 
> Yes, any machine that "needs" it while suspended.  What's the difference,
> after all?  The only difference is that there's an image on permanent storage
> in the hibernation case.  You still can overheat a battery when charging it
> while hibernated, right?

No, you can not; not on Zaurus.

It can not really power down; it is always sleeping. s2ram is sleep in
operating system, hibernation or poweroff is sleep in bootloader.

Bootloader takes care of battery in that case.

> > > To conclude, I'm not sure about the approach.  In particular, I'm not sure
> > > if the benefit is worth the effort and the resulting complications (ie. the
> > > possibility of having to deal with wakeup signals not requested by user
> > > space) seem to be a bit too far reaching.
> > 
> > We already have platform-specific hacks to do exactly this at least on
> > Zaurus. Moving it to common code means that hacks are not duplicated..
> 
> Well, good to know they are there, but I'm still not sure what to do about
> that.  At the moment I feel like having too little information to really
> decide, so perhaps please point me to the code you're talking about for
> starters.

Ok, see the spitz_should_wakeup() function in arch/arm/mach-pxa/* and
should_wakeup() usage.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

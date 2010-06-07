Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab0FGMQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:16:45 -0400
Received: from ist.d-labs.de ([213.239.218.44]:39088 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab0FGMQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:16:43 -0400
Date: Mon, 7 Jun 2010 14:16:24 +0200
From: Florian Mickler <florian@mickler.org>
To: david@lang.hm
Cc: Vitaly Wool <vitalywool@gmail.com>, Brian Swetland <swetland@google.com>,
       Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
Message-ID: <20100607141624.3d004db2@schatten.dmk.lab>
In-Reply-To: <alpine.DEB.2.01.1006060410050.17462@asgard.lang.hm>
References: <20100603193045.GA7188@elte.hu>
	<AANLkTimH4ihf3QqtKFpfGXRKtO55PrUuff9JYtaEBG44@mail.gmail.com>
	<20100604083423.GD15181@elte.hu>
	<AANLkTinQyzzeF-NOAjrAqqQXqKjFJhx85nI4uyBGRtWd@mail.gmail.com>
	<1275653210.27810.39762.camel@twins>
	<AANLkTinyjBa0KYfFz3_EFbC65hoQFwFINlTDYjCe-wM3@mail.gmail.com>
	<1275731653.27810.41078.camel@twins>
	<20100605092851.6ee15f13@infradead.org>
	<AANLkTimEwznq9c_8lkuBMxEQ-42rdvpZEqA9Y71Cu-qC@mail.gmail.com>
	<AANLkTimKknOurmCffOpHjc1FjrP2MKf10pBwEEbLJPg_@mail.gmail.com>
	<AANLkTil1NCX91bWhpXHtC88Opr29mNjdhXD9RXQ6DI0y@mail.gmail.com>
	<AANLkTin1Za3GvfIKbcZdx6TzjIHzCvsg5uaY_Vk4nJIh@mail.gmail.com>
	<AANLkTilQ1k78dDCYadOa1Wiyjm2nsBcRpxwdpGvYcf8z@mail.gmail.com>
	<AANLkTin7oM3gVwHbIHWqYV8yeC6bbQ4q2jDDxAgz3DwQ@mail.gmail.com>
	<alpine.DEB.2.01.1006060305060.17462@asgard.lang.hm>
	<AANLkTinW-X5m85rUcqP-lrEdfBikVclJWgqiWDkpxnAc@mail.gmail.com>
	<20100606124949.539fa636@schatten.dmk.lab>
	<alpine.DEB.2.01.1006060410050.17462@asgard.lang.hm>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jun 2010 04:14:09 -0700 (PDT)
david@lang.hm wrote:

> On Sun, 6 Jun 2010, Florian Mickler wrote:
> 
> > On Sun, 6 Jun 2010 12:19:08 +0200
> > Vitaly Wool <vitalywool@gmail.com> wrote:
> >
> >> 2010/6/6  <david@lang.hm>:
> >>
> >>> as an example (taken from this thread).
> >>>
> >>> system A needs to wake up to get a battery reading, store it and go back to
> >>> sleep, It does so every 10 seconds. But when it does so it only runs the one
> >>> process and then goes back to sleep.
> >>>
> >>> system B has the same need, but wakes up every 10 minutes. but when it does
> >>> so it fully wakes up and this allows the mail app to power up the radio,
> >>> connect to the Internet and start checking for new mail before oppurtunistic
> >>> sleep shuts things down (causing the mail check to fail)
> >>>
> >>> System A will last considerably longer on a battery than System B.
> >>
> >> Exactly, thanks for pointing out the specific example :)
> >>
> >> ~Vitaly
> >
> > This does not affect suspend_blockers nor does suspend_blockers
> > interfere with that.
> >
> > Suspend_blockers allow the system to suspend ("mem">/sys/power/state
> > suspend), when the userspace decides that the device is not in use.
> >
> > So implementing suspend_blockers support does not impact any
> > optimizations done to either system A nor system B.
> 
> Actually, it does.
> 
> system A is what's being proposed by kernel developers, where the 
> untrusted stuff is in a different cgroup and what puts the system to sleep 
> is 'normal' power management. It doesn't sleep as long, but when it wakes 
> up the untrusted stuff is still frozen, so it doesn't stay awake long, or 
> do very much.
> 
> System B is suspend blockers where you are either awake or asleep, and 
> when you wake up you wake up fully, but oppertunistic sleep can interrupt 
> untrusted processes at any time. The system sleeps longer (as fewer things 
> can wake it), but when it wakes up it's fully awake.
> 
> David Lang

You say, that coming back from suspend takes the system to full power
(and everything runs) before it begins the descend into
runtime-low-power?
But are you referring to the fact that coming back
from suspend starts in the zero-idle-state (i.e. "consumes extra
power") or that all processes run when it is not suspended?

Because the latter would of course (theretically) profit from the
framework-controlled-cgroup-freeze/thaw (with and without
opportunistic suspend) while the former should be a problem that
both opportunistic suspend as well as suspend-from-idle have. Or not?

So, here is the question I'm asking myself: If System A were to be
complemented by suspend_blockers, wouldn't it still be better? 

With System A you could try to do a really sophisticated
power-management scheme and so on... but as soon as you allow 3rd-Party
Apps, how do you manage their cross-dependencies? I.e. you can not
automatically detect when App1 needs App2 to function. 
You need to allow all 3rd-Party apps to run as a group. 

So you can perhaps partition your software stack into "untrusted
applications" and different groups of software with audited
dependencies. 

If one group interacts with another group (as will be the case at least
with the "untrusted applications" group) you have to have them both
running at the same time.

This really gets pretty complex. Do you really think something like
this is better than a simple suspend? (I.e. suspend blockers or
having just one group)

Suppose you implement suspend blockers with a cgroup freeze... how do
you implement the freeze/thaw control? 

Cheers,
Flo

p.s.: do you see an possibility for any kind of "priority inheritance"
in the cgroup scheme? I don't.

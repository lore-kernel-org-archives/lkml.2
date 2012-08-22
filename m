Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab2HVMzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 08:55:01 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56848 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2HVMy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 08:54:57 -0400
Date: Wed, 22 Aug 2012 13:58:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@kernel.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120822135854.7f6bc14f@pyramind.ukuu.org.uk>
In-Reply-To: <20120822113352.GA28247@gmail.com>
References: <20120821094203.GB12385@gmail.com>
	<20120821113951.GA22436@srcf.ucam.org>
	<20120821151910.GA5359@gmail.com>
	<20120821152828.GB28241@srcf.ucam.org>
	<20120821155908.GA5499@gmail.com>
	<20120821161324.GA29665@srcf.ucam.org>
	<20120821182346.GA7325@gmail.com>
	<20120821195234.20c173bc@pyramind.ukuu.org.uk>
	<20120822090304.GA23336@gmail.com>
	<20120822120027.7d04fd3a@pyramind.ukuu.org.uk>
	<20120822113352.GA28247@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It can be more than an irrelevance if the CPU is saturated - say 
> a game running on a mobile device very commonly saturates the 
> CPU. A third of the energy is spent in the CPU, sometimes more.

If the CPU is saturated you already lost. What you going to do - the CPU
is saturated - slow it down, then it'll use more power.

> > You *can't* fix PM in one place. [...]
> 
> Preferably one project, not one place - but at least don't go 
> down the false path of:
> 
>  " Policy always belongs into user-space so the kernel can 
>    continue to do a shitty job even for pieces it could 
>    understand better ..."
> 
> My opinion is that it depends, and I also think that we are so 
> bad currently (on x86) that we can do little harm by trying to 
> do things better.

All the evidence I've seen says we are doing the kernel side stuff right.

> 
> > [...] Power management is a top to bottom thing. It starts in 
> > the hardware and propogates right to the top of the user space 
> > stack.
> 
> Partly because it's misdesigned: in practice there's very little 
> true user policy about power saving:

It's not about policy, its about code behaviour. You have to fix every
single piece of code.

> - On mobile devices I almost never tweak policy as a user - 
>   sometimes I override screen brightness but that's all (and 
>   it's trivial compared to all the many other things that go 
>   on).

Put a single badly broken app on an Android device and your battery life
will plough. That's despite Android having some highly active management
policies to minimise the effect. It works out of the box because someone
spent a huge amount of time with a power meter and monitoring tools
beating up whoever was top of the wakeup lists.

> it should all work. There arent millions of people out there 
> wanting to tweak the heck out of PM.

Don't confuse policy managed by the userspace and buttons for users to
tweak. Userspace understands things like "would it be better to drop
video quality or burn more power" and has access to info the kernel can't
even begin to evaluate.

> People prefer no knobs at all - they want good defaults and they 
> want at most a single, intuitive, actionable control to override 
> the automation in 1% of the usecases, such as screen brightness.

That's a different discussion.

> > A single stupid behaviour in a desktop app is all it needs to 
> > knock the odd hour or two off your battery life. Something is 
> > mundane as refreshing a bit of the display all the time 
> > keeping the GPU and CPU from sleeping well.
> 
> Even with highly powertop-optimized systems that have no such 
> app and have very low wakeup rates we still lag behind the 
> competition.

Actually we don't. Well not if your distro is put together properly,
and has the relevant SATA patches and the like merged. Stock Fedora may
be pants but if so that's a distro problem.

> So why not move most pieces into one well-informed code domain 
> (the kernel) and only expose high level controls, instead of 
> expecting user-space to get it all right.

Because the kernel doesn't have the information needed. You'd have to add
megabytes of code to the kernel - including things like video playback
engines.

> Then the 'only' job of user-space would be to not be silly when 
> implementing their functionality. (and there's nothing 
> intimately PM about that.)

That sounds like ignorance

> Kernel design decisions *matter*:

Of course they do but its a tiny part of the story. The power management
function mathematically has a large number of important inputs for which
the kernel cannot deduce the values without massive layering violations.

Also inconveniently for your worldview but as demonstrated in every case
and by everyone who has dug into it, you also have to fix all the wakeup
sources on each level. That's the reality. From the moment you wake for
an event that was not strictly needed you are essentially attempting to
mitigate a failure not trying to deal with the actual problem.

> Look for example how moving X lowlevel drivers from user-space 
> into kernel-space enabled GPU level power management to begin 
> with. With the old X method it was essentially impossible. Now 
> it's at least possible.

Actually it was perfectly possible before for what the cards of the time
could do. The kernel GPU stuff is for DMA and IRQ handling. It happens to
be a good place to do PM.

> Or look at how Android adding a high-level interface like 
> suspend blockers materially improved the power saving situation 
> for them.

Blockers are not policy. The blocking *policy* is managed elsewhere. They
are a tool for freezing stuff that is being rude.

> This learned helplessness that "the kernel can do nothing about 
> PM" is somewhat annoying :-)

Sorry was that a different thread I didn't read ?

The inability to learn from both the past and basic systems theory is
what I find rather more irritating. Plus your mistaken belief that we are
worse than the other OS's on this. We are not. If your system sucks then
instrument it, get the SATA patches into your kernel, run powertweak over
it and ask your distro folks why you had to change any of the settings
and why they hadn't shipped it that way.

Alan

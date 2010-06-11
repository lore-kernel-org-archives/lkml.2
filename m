Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760328Ab0FKOmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 10:42:11 -0400
Received: from netrider.rowland.org ([192.131.102.5]:35767 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756366Ab0FKOmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 10:42:09 -0400
Date: Fri, 11 Jun 2010 10:42:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Brian Swetland <swetland@google.com>, Pavel Machek <pavel@ucw.cz>,
       <tytso@mit.edu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Neil Brown <neilb@suse.de>, Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] suspend blockers & Android integration
In-Reply-To: <527264.20535.qm@web180316.mail.gq1.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.1006111036030.12006-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010, David Brownell wrote:

> This is a bit off the topic of Android
> flamage, but I thought it would be worth
> highlighting an example where the current
> frameworks may still have a deficiency...
> one that likewise relates to needing to
> block entry ot a system suspend state, but
> in this case user-space isn't very involved
> (just drivers coping with hardware).
> 
> The example I wanted to re-post (I've done so
> in the past) is one where drivers ouldn't really
> do the right thing, since driver.suspend() wasn't
> quite powerful enough as a programming interface.
> 
> The example works with USB on many ARM SoCs,
> and similar non-USB examples aren't rare.
> 
>  - Want to enter a system suspend state, with
>    some USB wakeup sources.  USB peripheral
>    waken up by the host, or vice versa.
> 
>    NOTE ASSUMPTION:  there are multiple suspend
>    states supported by the hardware, significantly
>    different in hardware configuration Linux should
>    be able to use more than one such state... (if
>    only because their power savings differ.)  This
> can mean driver-specific knowledge about those
> various states.
> 
>  - The wakeup requires a particular clock to be active, so the USB controller can detect that the
> wakeup should trigger,  then issue the right signals
> triggering the non-USB parts of the system.
> 
> Problem:  how does the device driver suspend()
>           method block entry to a suspend state
>           when it can't ensure that clock is
>           going to be active.  Magic return code?

At the moment, drivers aren't told what suspend state the system is
going into.  They know the difference between suspend and hibernate,
but the PM core doesn't tell drivers whether it's going into standby
vs. suspend.  (Strictly speaking, those terms apply mostly to ACPI
systems and not so much elsewhere.  What I'm talking about is the
/sys/power/state interface, where the user can write either "standby"
or "mem".  Drivers aren't told which was written.)

>  There are other issues here too.  (Is the target
>  system suspend state one of the ones which doesn't
> allow that clock to be active?  SoC-specific calls
> might suffice for this issue.

I imagine platforms have to answer all such questions when they decide 
exactly how they will implement "standby" and "mem".

> A number of years ago, this problem was insoluble
> with the then-current Linux PM and clock frameworks.
> I've been away from this issue for quite a while
> now, but don't recall seeing its sub-problems get
> solved ... If they're now solved, I'll be glad.
> (I know Kevin's recent OMAP stuff addresses similar
> issues, but It's OMAP-specific...) 
> 
> After all these thousands and thousands of emails...
> I'm not sure how much forward motion has happened.

I'm not aware of any progress.

Alan Stern


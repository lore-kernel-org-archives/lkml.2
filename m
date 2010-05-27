Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab0E0Wkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:40:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50254 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757680Ab0E0Wkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:40:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Fri, 28 May 2010 00:41:43 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org> <20100527174019.GA3187@srcf.ucam.org> <1274982447.27810.5684.camel@twins>
In-Reply-To: <1274982447.27810.5684.camel@twins>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005280041.43553.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010, Peter Zijlstra wrote:
> On Thu, 2010-05-27 at 18:40 +0100, Matthew Garrett wrote:
> > On Thu, May 27, 2010 at 07:34:40PM +0200, Peter Zijlstra wrote:
> > > > we still need to be able to enter suspend while the system isn't idle.
> > > 
> > > _WHY_!?
> > 
> > Because if I'm running a kernel build in a tmpfs and I hit the sleep 
> > key, I need to go to sleep. Blocking processes on driver access isn't 
> > sufficient.
> 
> But that's a whole different issue. I agree that a forced suspend for
> things like that make sense, just not for power managing a running
> system. PC style hardware like that doesn't wake up from suspend for
> funny things like a keypress either (good thing too).

In fact one of my PC test boxes does that. :-)

> Anyway all that already works (more or less), so I don't see the
> problem.

The whole idea behind the patchset is not to power manage a _running_ system.
It is based on the observation that for a good deal of time one doesn't need
the system to be running at all, which is quite pragmatic to me.  Given that,
the point is to figure out when the system doesn't need to run and effectively
shut it down at that point (memory is refreshed in that state so that the
system can go back to the working state relatively quickly).  From there, the
system can only be woken up by specific events (like pressing a power button).
However, it would be wasteful to shut it down knowing that the condition used
to make the decision to shut it down didn't hold any more.

The current mainline relies on the user to make that decision (and write
something to /sys/power/state), but in principle I don't see why it cannot be
made by software (either the kernel or the user space, or both in combination).
The question is how to "teach" the software to make that decision in a way
that's acceptable to the user and the Arve's approach is an attempt to give
an answer to it.

Of course, you may not like it, but the truth is it works in practice
reasonably well.  That may not be an argument for merging it, but then we
should at least tell the Android people what's fundamentally wrong with it
and how to do it in a different way so that their own requirements are met.

As long as we don't do that, we're rejecting it just because we don't like it.

Yes, Alan Cox said why he thought the approach was fundamentally wrong from
the technical standpoint and I appreciate that.  I don't think, though, that we
can give Google a serious advice how to achieve their goal (which is battery
life comparable to what they get with suspend blockers) in any different way.

The approach with user space power manager suggested by Dmitry and Alan Stern
may work, but it still assumes some kind of suspend blockers to be present in
the kernel.  If we reject that too, I wonder what approach Google is supposed
to use and still get the same battery life they get with suspend blockers.

Thanks,
Rafael

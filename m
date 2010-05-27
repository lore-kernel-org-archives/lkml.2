Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446Ab0E0SHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:07:01 -0400
Received: from www.tglx.de ([62.245.132.106]:37616 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757680Ab0E0SG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:06:57 -0400
Date: Thu, 27 May 2010 20:05:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100527173118.GE2468@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1005271959450.3032@localhost.localdomain>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org> <alpine.LFD.2.00.1005271915540.3032@localhost.localdomain> <20100527173118.GE2468@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Matthew Garrett wrote:

> On Thu, May 27, 2010 at 07:24:02PM +0200, Thomas Gleixner wrote:
> 
> > Oh no. They paper over a short coming. If there is a pending event,
> > the kernel knows that. It just does not make use of this
> > information. Blockers just paper over this by sprinkling
> > do_not_suspend() calls all over the place. What a sensible solution.
> 
> Even if we could use suspend-via-deep-idle-state on PCs, we still need 
> to be able to enter suspend while the system isn't idle. There's two 
> ways to do that:
> 
> 1) Force the system to be idle. Doing this race-free is difficult.
> 
> 2) Enter suspend even though the system isn't idle. Since we can't rely 
> on the scheduler, we need drivers to know whether userspace has consumed 
> all wakeup events before allowing the transition to occur. Doing so 
> requires either in-kernel suspend blockers or something that's almost 
> identical.

You're just not getting it. If user space has consumed the event is
not relevant at all.

What's relevant is whether the app has processed the event and reacted
accordingly. That's all that matters.

Emptying your input queue is just the wrong indicator.

And as I explained several times now: It does _NOT_ matter when the
app goes back in to blocked/idle state. You have to spend the CPU
cycles and power for that anyway.

And for the apps which do not use the user space blockers the queue
empty indicator is just bullshit, because after emptying the queue the
kernel can go into suspend w/o any guarantee that the event has been
processed.

The whole concept sucks, as it does not solve anything. Burning power
now or in 100ms is the same thing power consumption wise.

Thanks,

	tglx

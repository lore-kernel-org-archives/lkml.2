Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab0E0RYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:24:30 -0400
Received: from www.tglx.de ([62.245.132.106]:41337 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893Ab0E0RY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:24:27 -0400
Date: Thu, 27 May 2010 19:24:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Peter Zijlstra <peterz@infradead.org>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.1005271915540.3032@localhost.localdomain>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Alan Stern wrote:

> On Thu, 27 May 2010, Thomas Gleixner wrote:
> 
> > The whole notion of treating suspend to RAM any different than a plain
> > idle C-State is wrong. It's not different at all. You just use a
> > different mechanism which has longer takedown and wakeup latencies and
> > requires to shut down stuff and setup extra wakeup sources.
> 
> This is where you are wrong.  Maybe not wrong in principle, but wrong 
> in practice -- the kernel's present suspend-to-RAM (or just "suspend") 
> implementation is _very_ different from C-states (or just "idle").

Holy bouncing cow. I damned good know that the current implementation
is not doing that and that suspend is implemented in a totally
different way. That does not mean that this is written in stone. We
CAN change that and fix it to gain opportunistic suspend.
 
> The primary difference is that the kernel can be forced into suspend
> even when the system isn't idle.  In particular, it may be in the
> middle of processing a potential wakeup event -- and the current design
> gives the PM core no way to know if that is so.  This is a weakness
> that in-kernel suspend blockers fix.

Oh no. They paper over a short coming. If there is a pending event,
the kernel knows that. It just does not make use of this
information. Blockers just paper over this by sprinkling
do_not_suspend() calls all over the place. What a sensible solution.

> With C-states this can't happen.  If the CPU goes into a deeper C-state 
> then ipso facto it isn't busy processing anything, much less a wakeup 
> event.

And that's the whole point of doing the opportunistic suspend with the
help of the scheduler.

> Now maybe this difference is a bad thing, and the whole PM 
> suspend/hibernate infrastructure should be rewritten.  But the fact, 
> remains, that's how it works now.  And it can't be changed easily or 
> quickly.

So what you are saying is that we better paper over the shortcomings
of our current implementation with do_not_suspend() code sprinkled all
over the place instead of sitting down and making suspend from idle
work. It's more or less trivial depending on the platform, but not
rocket science.

Thanks,

	tglx

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab0CYNcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:32:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48572 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab0CYNcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:32:09 -0400
Date: Thu, 25 Mar 2010 14:32:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jesse.brandeburg@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near overflowing v2
Message-ID: <20100325133204.GP20695@one.firstfloor.org>
References: <20100324190150.GA18803@basil.fritz.box> <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain> <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain> <20100325003652.GG20695@one.firstfloor.org> <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain> <20100325093744.GH20695@one.firstfloor.org> <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain> <20100325121141.GO20695@one.firstfloor.org> <alpine.LFD.2.00.1003251338130.3147@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003251338130.3147@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Anyways if such a thing was done it would be a long term project
> > > > and that short term fix would be still needed.
> > > 
> > > Your patch is not a fix, It's a lousy, horrible and unreliable
> > > workaround. It's not fixing the root cause of the problem at hand.
> > 
> > It fixes the bug in a minimally intrusive way.
> 
> It papers over the problem. We already know that the NIC driver floods
> the machine with interrupts, so why are you insisting that we need to

Well in this case it's simply because it has 4 ports and they are all
active and have a lot of MSI-X vectors for each stream. 

Even if you had the perfect interrupt handler that ran in
one cycle, if you had enough of them in parallel from different ports
there could be still a stack overflow problem on individual CPUs.

> bandaid that problem ?

Because the system crashes otherwise on that test?

> The minimal intrusive way is a one liner in that very driver code and
> if it causes problems for that very driver then we don't fix them with
> adding a callback in the generic interrupt code path.

Ok.

> 
> The message which we would send out with applying that band aid would
> be simply: Go ahead driver writers and let your handlers run as long

Well it's simply the current state of affairs today. I'm merely
attempting to make the current state slightly safer without breaking
anything in the process.

> as they want, we'll safe you in 99.9% of the cases and we'll happily
> go and debug the 0.1% of completely undebuggable shit which will
> result out of that.

I'm not sure I fully understand your suggestion.

Is your suggestion to only set IRQF_DISABLED that one driver and ignore the 
other ones? (let's call that the "ostrich approach")

Or is your suggestion to set IRQF_DISABLED by default?

Or is it something else?

Thanks,

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

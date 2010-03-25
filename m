Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab0CYQ1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 12:27:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33511 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab0CYQ1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:27:47 -0400
Date: Thu, 25 Mar 2010 17:27:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
Message-ID: <20100325162737.GA5276@elte.hu>
References: <20100324190150.GA18803@basil.fritz.box>
 <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain>
 <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain>
 <20100325003652.GG20695@one.firstfloor.org>
 <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
 <20100325093744.GH20695@one.firstfloor.org>
 <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain>
 <alpine.LFD.2.00.1003250842240.3721@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003250842240.3721@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

[...]
>
> Now, it's also true that our IRQ infrastructure handlers _could_ be smarter, 
> and make the whole problem less likely to happen.
> 
> In particular, it's probably true that especially on modern hardware with 
> multiple cores, and especially when you do _not_ have irq sharing (which is 
> the common case these days for things like network drivers that can use 
> MSI), we really would be better off having the irq disabled over the whole 
> thing, and on some interrupt controllers it might even be worth it to do the 
> old optimization of not masking-and-acking, but just acking.

Yes.

> But see above. This is _not_ something that a driver can do any more. They 
> don't know whether the interrupt might end up being shared. Just blindly 
> setting IRAF_DISABLED in a driver is _not_ the answer. But being smarter in 
> the generic irq handler code might work.
> 
> And then, what we could do, is to mark the drivers that absolutely _must_ be 
> able to nest specially. Like the IDE driver when in PIO mode. Or maybe the 
> SCSI drivers, if they still depend on that timer interrupt happening while 
> they are busy.

I think the patch as posted solves a real problem, but also perpetuates a bad 
situation.

At minimum we should print a (one-time) warning that some badness occured. 
That would push us either in the direction of improving drivers, or towards 
improving the generic code.

Thanks,

	Ingo

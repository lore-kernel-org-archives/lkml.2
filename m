Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab2FMKXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 06:23:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:47991 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2FMKXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 06:23:12 -0400
Date: Wed, 13 Jun 2012 12:23:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] irq/core changes for v3.5
In-Reply-To: <CA+55aFxC0436vCDwX8nUnKNa3ZZi=ZhL0w6eMk0hM3oKTz4LJw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1206131127050.3086@ionos>
References: <20120522032554.GA11358@gmail.com> <Pine.LNX.4.64.1206121201130.6800@axis700.grange> <alpine.LFD.2.02.1206121639420.3086@ionos> <CA+55aFxNy2-DnWVDUiOuF+NncRBUC=frZN+CTLsJ+o2ofXtZYQ@mail.gmail.com> <alpine.LFD.2.02.1206121732230.3086@ionos>
 <CA+55aFxC0436vCDwX8nUnKNa3ZZi=ZhL0w6eMk0hM3oKTz4LJw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012, Linus Torvalds wrote:
> I relaize that the current drivers that rely on our old fast-and-loose
> behavior actually *work*, and I realize that apparently there aren't
> any shared irq issues in existence today, but I'd like our generic irq
> code to do the RightThing(tm), and I think that implies that it is the
> drivers that should be fixed, not the core irq layer that should work
> around the problem.

I don't see much of a difference between

  request_threaded_irq(irq, NULL, thread_handler, 0,...)

and

  request_threaded_irq(irq, NULL, thread_handler, IRQF_ONESHOT,...)

The NULL primary handler is a clear indicator for the intention. So
the innocent author of that *correct* driver will see in both cases
what's going on.

But that's a distinction without a difference which we can discuss
forever :)

> Driver authors that see the error should be able to easily fix their
> drivers, no?

No argument about that, though I prefer not to break working stuff
just to add another indicator for something which is obvious already
and requires to have such a weird device on a machine with shared
interrupts.

A 5th option would be to emit a warning in case the flag is not set,
fix it up for now and schedule it for removal in 3.6. Anything what's
not fixed by then is broken for good.

Your choice, really.

Thanks,

	tglx

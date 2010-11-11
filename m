Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab0KKWRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:17:30 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50740 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756625Ab0KKWR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:17:28 -0500
Subject: Re: [PATCH 04/10] tile: convert to use clocksource_register_hz
From: john stultz <johnstul@us.ibm.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <4CDC5E70.90102@tilera.com>
References: <1288642350-1599-1-git-send-email-johnstul@us.ibm.com>
	 <1288642350-1599-5-git-send-email-johnstul@us.ibm.com>
	 <4CDC5E70.90102@tilera.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 14:17:15 -0800
Message-ID: <1289513835.2742.62.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-11 at 16:21 -0500, Chris Metcalf wrote:
> On 11/1/2010 4:12 PM, John Stultz wrote:
> > Convert tile to use clocksource_register_hz.
> >
> > Untested. Help from maintainers would be appreciated.
> >
> > CC: Chris Metcalf <cmetcalf@tilera.com>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: John Stultz <johnstul@us.ibm.com>
> > ---
> >  arch/tile/kernel/time.c |    5 +----
> >  1 files changed, 1 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
> > index 6bed820..8c06cb2 100644
> > --- a/arch/tile/kernel/time.c
> > +++ b/arch/tile/kernel/time.c
> > @@ -76,7 +76,6 @@ static struct clocksource cycle_counter_cs = {
> >  	.rating = 300,
> >  	.read = clocksource_get_cycles,
> >  	.mask = CLOCKSOURCE_MASK(64),
> > -	.shift = 22,   /* typical value, e.g. x86 tsc uses this */
> >  	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
> >  };
> 
> We were using clocksource_calc_mult_shift() for a while to compute both
> this value and our sched_clock() value, and, like
> clocksource_register_hz(), it suggested that a shift value of 31 was best.
> 
> Perhaps unsurprisingly, we saw wraparound with sched_clock(), which is why
> we use a fixed shift value of "10" to avoid problems.  This is clearly
> required since sched_clock() values are fairly long-lived.

One more quick thing: I just reviewed the tile sched_clock code, and it
looks like its doing the right thing, calculating a mult/shift pair for
the sched_clock code itself, not directly using the timekeeping
clocksource's values.

So the clocksource_register_hz patch proposed here doesn't really affect
this issue and should still be fine to go in (assuming no other issues
are brought out by it :).

But Chris' point does still illustrate that we need better clarification
about what is expected from sched_clock and maybe some better reference
implementations to make sure arch maintainers don't trip on common
issues when implementing or modifying sched_clock.

thanks
-john



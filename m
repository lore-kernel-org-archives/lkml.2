Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab0CSKHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 06:07:14 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:54713 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab0CSKHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 06:07:12 -0400
Date: Fri, 19 Mar 2010 13:07:10 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: john stultz <johnstul@us.ibm.com>
Cc: Richard Henderson <rth@twiddle.net>, lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Matt Turner <mattst88@gmail.com>
Subject: Re: [RFC][PATCH] Convert alpha to use clocksource
Message-ID: <20100319100710.GA938@jurassic.park.msu.ru>
References: <1268877702-2236-1-git-send-email-johnstul@us.ibm.com> <4BA23974.5030503@twiddle.net> <1268934923.1855.8.camel@work-vm> <20100318214030.GA8934@jurassic.park.msu.ru> <1268950758.4171.51.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268950758.4171.51.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 03:19:18PM -0700, john stultz wrote:
> On Fri, 2010-03-19 at 00:40 +0300, Ivan Kokshaysky wrote:
> > Yeah, that looks cool. I'm typing this on the 800MHz UP1500 running
> > 2.6.34-rc1 plus your patch, and the timekeeping works fine so far.
> 
> Nice! Thanks for testing! Another benefit that I forgot to mention, is
> that NTP adjustments will be made directly against the counter, instead
> of being made against the tick. This avoids possible small errors at
> tick time if the intertick interval doesn't match the actual tick
> length.
> 
> 
> > Though, even after a glance over the clocksource code, I've not
> > gotten yet to how one could estimate the "shift" value...
> > Any hints?
> 
> Yea, selecting a good shift is obnoxious. You want to pick the largest
> value of shift, so that it can be finely adjusted by ntp, but that
> creates large mult values, which can cause overflows for large cycle
> intervals. 
> 
> A function to solve this was actually recently added, but simply I
> forgot to use it. :P

Understood. ;-)

> I actually should rework the register function so you just give it a
> clocksource and a freq and it sets up both mult and shift for you. 
> 
> 
> > And if I recall correctly, production alphas have been clocked
> > in the range of 60-1250 MHz.
> 
> Cool. The shift value I picked should be ok then. But below is an
> updated version that uses the self-calculated method.

Excellent. Thanks a lot!

> >From 078e91d14cb5e82a3fab00cf74faf45f44336590 Mon Sep 17 00:00:00 2001
> From: John Stultz <johnstul@us.ibm.com>
> Date: Wed, 17 Mar 2010 12:43:11 -0700
> Subject: [PATCH] Convert alpha to use clocksources instead of arch_gettimeoffset
> 
> Alpha has a tsc like rpcc counter that it uses to manage time.
> This can be converted to an actual clocksource instead of utilizing
> the arch_gettimeoffset method that is really only there for legacy
> systems with no continuous counter.
> 
> Further cleanups could be made if alpha converted to the clockevent model.
> 
> I've not tested or compiled this code. Any help from the maintainers would
> be greatly appreciated
> 
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Richard Henderson <rth@twiddle.net>
> CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> CC: Matt Turner <mattst88@gmail.com>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>

Acked-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Tested-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Ivan.

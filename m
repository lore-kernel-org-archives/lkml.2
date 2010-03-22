Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab0CVLRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:17:53 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:55640 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab0CVLRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:17:52 -0400
Date: Mon, 22 Mar 2010 12:17:44 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: john stultz <johnstul@us.ibm.com>, Richard Henderson <rth@twiddle.net>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Matt Turner <mattst88@gmail.com>
Subject: Re: [RFC][PATCH] Convert alpha to use clocksource
Message-ID: <20100322111744.GB10420@cmpxchg.org>
References: <1268877702-2236-1-git-send-email-johnstul@us.ibm.com> <4BA23974.5030503@twiddle.net> <1268934923.1855.8.camel@work-vm> <20100318214030.GA8934@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318214030.GA8934@jurassic.park.msu.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Mar 19, 2010 at 12:40:30AM +0300, Ivan Kokshaysky wrote:
> On Thu, Mar 18, 2010 at 10:55:23AM -0700, john stultz wrote:
> > On Thu, 2010-03-18 at 07:32 -0700, Richard Henderson wrote:
> > > On 03/17/2010 07:01 PM, John Stultz wrote:
> > > > Alpha has a tsc like rpcc counter that it uses to manage time.
> > > > This can be converted to an actual clocksource instead of utilizing
> > > > the arch_gettimeoffset method that is really only there for legacy
> > > > systems with no continuous counter.
> > > 
> > > With 8 seconds or less between roll-overs, do you actually consider
> > > this a continuous counter?  I don't.  I suggest this be left alone.
> > 
> > The timekeeping code handles this (although the shift value I picked may
> > need some adjustment - what is the expected counter freq range on
> > alpha?). The ACPI PM counter which is very common on x86 is only 24 bits
> > and rolls over in ~5 seconds. It works fine.
> 
> Yeah, that looks cool. I'm typing this on the 800MHz UP1500 running
> 2.6.34-rc1 plus your patch, and the timekeeping works fine so far.
> 
> Though, even after a glance over the clocksource code, I've not
> gotten yet to how one could estimate the "shift" value...
> Any hints?

I had the same problem with xtensa and added a comment about what I
did in there, maybe it helps:

	arch/xtensa/kernel/time.c

I took the upper bound of the multiplicator (nsecs per counter unit)
and subtracted its logarithm from my available 32 bits.  The result
is the highest possible shift value that works for the clocksource.

	HTH, Hannes

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab0CVQlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:41:49 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:36837 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031Ab0CVQls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:41:48 -0400
Date: Mon, 22 Mar 2010 17:41:37 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       john stultz <johnstul@us.ibm.com>, Richard Henderson <rth@twiddle.net>,
       lkml <linux-kernel@vger.kernel.org>, Matt Turner <mattst88@gmail.com>
Subject: Re: [RFC][PATCH] Convert alpha to use clocksource
Message-ID: <20100322164137.GA12625@cmpxchg.org>
References: <1268877702-2236-1-git-send-email-johnstul@us.ibm.com> <4BA23974.5030503@twiddle.net> <1268934923.1855.8.camel@work-vm> <20100318214030.GA8934@jurassic.park.msu.ru> <20100322111744.GB10420@cmpxchg.org> <alpine.LFD.2.00.1003221521440.3147@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003221521440.3147@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 03:22:12PM +0100, Thomas Gleixner wrote:
> On Mon, 22 Mar 2010, Johannes Weiner wrote:
> > > Though, even after a glance over the clocksource code, I've not
> > > gotten yet to how one could estimate the "shift" value...
> > > Any hints?
> > 
> > I had the same problem with xtensa and added a comment about what I
> > did in there, maybe it helps:
> > 
> > 	arch/xtensa/kernel/time.c
> > 
> > I took the upper bound of the multiplicator (nsecs per counter unit)
> > and subtracted its logarithm from my available 32 bits.  The result
> > is the highest possible shift value that works for the clocksource.
> 
> clocks_calc_mult_shift() is what you are looking for.

Oh, thanks!  That was not yet around at the time.

	Hannes


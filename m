Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0CVOWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:22:30 -0400
Received: from www.tglx.de ([62.245.132.106]:37821 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757Ab0CVOW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:22:28 -0400
Date: Mon, 22 Mar 2010 15:22:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       john stultz <johnstul@us.ibm.com>, Richard Henderson <rth@twiddle.net>,
       lkml <linux-kernel@vger.kernel.org>, Matt Turner <mattst88@gmail.com>
Subject: Re: [RFC][PATCH] Convert alpha to use clocksource
In-Reply-To: <20100322111744.GB10420@cmpxchg.org>
Message-ID: <alpine.LFD.2.00.1003221521440.3147@localhost.localdomain>
References: <1268877702-2236-1-git-send-email-johnstul@us.ibm.com> <4BA23974.5030503@twiddle.net> <1268934923.1855.8.camel@work-vm> <20100318214030.GA8934@jurassic.park.msu.ru> <20100322111744.GB10420@cmpxchg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Mar 2010, Johannes Weiner wrote:
> > Though, even after a glance over the clocksource code, I've not
> > gotten yet to how one could estimate the "shift" value...
> > Any hints?
> 
> I had the same problem with xtensa and added a comment about what I
> did in there, maybe it helps:
> 
> 	arch/xtensa/kernel/time.c
> 
> I took the upper bound of the multiplicator (nsecs per counter unit)
> and subtracted its logarithm from my available 32 bits.  The result
> is the highest possible shift value that works for the clocksource.

clocks_calc_mult_shift() is what you are looking for.

Thanks,

	tglx

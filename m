Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465Ab0GHThK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 15:37:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:58739 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755920Ab0GHThJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 15:37:09 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+vuQZFqQevReqjV/RsYLYbI9QJFvezlzNOxqsPcj
	el2Y46Jb2uC+Qz
Subject: Re: high power consumption in recent kernels
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Norbert Preining <preining@logic.at>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm <akpm@linux-foundation.org>,
       tglx <tglx@linutronix.de>
In-Reply-To: <1278595426.1900.130.camel@laptop>
References: <20100706164539.GA14783@gamma.logic.tuwien.ac.at>
	 <1278579992.1900.17.camel@laptop> <20100708045711.398d4e26@infradead.org>
	 <1278590303.1900.91.camel@laptop>
	 <20100708120421.GF20841@gamma.logic.tuwien.ac.at>
	 <1278591779.1900.97.camel@laptop>
	 <20100708124627.GA7754@gamma.logic.tuwien.ac.at>
	 <1278595426.1900.130.camel@laptop>
Content-Type: text/plain
Date: Thu, 08 Jul 2010 21:37:12 +0200
Message-Id: <1278617832.7498.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 15:23 +0200, Peter Zijlstra wrote:
> On Thu, 2010-07-08 at 21:46 +0900, Norbert Preining wrote:
> > Looks promising, reverting the old patch, adding that one, building,
> > running, unplugging ppower, powertop runs now since some time,
> > it seems that we are back to better situation: 
> 
> Hrmm, Mike seems you wrecked power usage.. 
> 
> So nohz_ratelimit() prevents us from entering NOHZ when the last attempt
> was less than 1/2 a jiffy ago (fwiw: NSEC_PER_SEC/HZ == TICK_NSEC).
> 
> Its either entering idle or irq_exit trying to enter nohz state, if we
> keep skipping it it means that we get enough interrupt activity to
> render nohz useless anyway.. so not quite sure how this wrecks things.

You can't win at this game.

I really don't like giving up anything, but thinking about it, if I were
the maintainer, I'd just revert the damn thing as being more trouble
than it's worth.

It makes a large difference at the extreme end of the spectrum when
scheduling cross cpu (which we now actively try to do to maximize ramp
throughput), but ever less as frequency diminishes.  I've yet to see a
load I can respect at close to max ctx frequency, where optimization
earns it's beans and biscuits.

Ego: If thine eye offends thee, pluck it out.

	-Mike


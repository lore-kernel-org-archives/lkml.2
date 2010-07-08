Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab0GHTkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 15:40:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:51385 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758494Ab0GHTkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 15:40:35 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19ap5w6BJ5aK0gd1Geb9wAUQbQROqWS7ktyzwFPtp
	EsNLFaAvVggEFJ
Subject: Re: high power consumption in recent kernels
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Norbert Preining <preining@logic.at>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, akpm <akpm@linux-foundation.org>,
       tglx <tglx@linutronix.de>
In-Reply-To: <1278604779.1900.157.camel@laptop>
References: <20100706164539.GA14783@gamma.logic.tuwien.ac.at>
	 <1278579992.1900.17.camel@laptop> <20100708045711.398d4e26@infradead.org>
	 <1278590303.1900.91.camel@laptop>
	 <20100708120421.GF20841@gamma.logic.tuwien.ac.at>
	 <1278591779.1900.97.camel@laptop>
	 <20100708124627.GA7754@gamma.logic.tuwien.ac.at>
	 <1278595426.1900.130.camel@laptop>  <1278604779.1900.157.camel@laptop>
Content-Type: text/plain
Date: Thu, 08 Jul 2010 21:40:40 +0200
Message-Id: <1278618040.7498.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 17:59 +0200, Peter Zijlstra wrote:
> On Thu, 2010-07-08 at 15:23 +0200, Peter Zijlstra wrote:
> > On Thu, 2010-07-08 at 21:46 +0900, Norbert Preining wrote:
> > > Looks promising, reverting the old patch, adding that one, building,
> > > running, unplugging ppower, powertop runs now since some time,
> > > it seems that we are back to better situation: 
> > 
> > Hrmm, Mike seems you wrecked power usage.. 
> > 
> > So nohz_ratelimit() prevents us from entering NOHZ when the last attempt
> > was less than 1/2 a jiffy ago (fwiw: NSEC_PER_SEC/HZ == TICK_NSEC).
> > 
> > Its either entering idle or irq_exit trying to enter nohz state, if we
> > keep skipping it it means that we get enough interrupt activity to
> > render nohz useless anyway.. so not quite sure how this wrecks things..
> 
> OK, so Arjan said the gain could come from tricking the idle governor
> into not using deeper C states. He also said he significantly cured said
> governor in .35.
> 
> Mike could you re-run your netperf tests that showed the 10% throughput
> gain? Hopefully the fixed governor will yield the same result and we can
> kill off this ratelimit thing.

The gain is (well was last time I checked), but as noted, I'd just call
it a misguided optimization and be done with it.

	-Mike


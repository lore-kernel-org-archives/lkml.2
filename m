Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab2HTIGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:06:17 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63080 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab2HTIGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:06:11 -0400
Date: Mon, 20 Aug 2012 10:06:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120820080606.GA6931@gmail.com>
References: <5028F12C.7080405@intel.com>
 <1345028738.31459.82.camel@twins>
 <502BA7DC.7060907@linux.intel.com>
 <1345041548.31459.90.camel@twins>
 <502BB5A3.5000403@linux.intel.com>
 <1345043096.31459.106.camel@twins>
 <502BE38D.9030405@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502BE38D.9030405@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> On 8/15/2012 8:04 AM, Peter Zijlstra wrote:
>
> > This all sounds far too complicated.. we're talking about 
> > simple spreading and packing balancers without deep arch 
> > knowledge and knobs, we couldn't possibly evaluate anything 
> > like that.
> > 
> > I was really more thinking of something useful for the 
> > laptops out there, when they pull the power cord it makes 
> > sense to try and keep CPUs asleep until the one that's awake 
> > is saturated.

s/CPU/core ?

> as long as you don't do that on machines with an Intel CPU.. 
> since that'd be the worst case behavior for tasks that run for 
> more than 100 usec. (e.g. not interrupts, but almost 
> everything else)

The question is, do we need to balance for 'power saving', on 
systems that care more about power use than they care about peak 
performance/throughput, at all?

If the answer is 'no' then things get rather simple.

If the answer is 'yes' then there's clear cases where the kernel 
(should) automatically know the events where we switch from 
balancing for performance to balancing for power:

 - the system boots up on battery

 - the system was on AC but the cord has been pulled and the 
   system is now on battery

 - the administrator configures the system on AC to be
   power-conscious.

( and the opposite direction events wants the scheduler to 
  switch from 'balancing for power' to 'balancing for 
  performance'. )

There's also cases where the kernel has insufficient information 
from the hardware and from the admin about the preferred 
characteristics/policy of the system - a tweakable fallback knob 
might be provided for that sad case.

The point is, that knob is not the policy setting and it's not 
the main mechanism. It's a fallback.

Thanks,

	Ingo


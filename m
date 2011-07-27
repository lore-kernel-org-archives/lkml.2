Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab1G0Rd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 13:33:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:60785 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1G0Rd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 13:33:26 -0400
Date: Wed, 27 Jul 2011 19:33:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux.com>
cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, eric.dumazet@gmail.com
Subject: Re: per-cpu operation madness vs validation
In-Reply-To: <alpine.DEB.2.00.1107271204260.13058@router.home>
Message-ID: <alpine.LFD.2.02.1107271919500.2660@ionos>
References: <1311714410.24752.404.camel@twins>  <alpine.DEB.2.00.1107261624210.10273@router.home>  <1311768693.24752.488.camel@twins>  <alpine.DEB.2.00.1107270904290.9418@router.home> <1311783616.5890.178.camel@twins>
 <alpine.DEB.2.00.1107271204260.13058@router.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011, Christoph Lameter wrote:
> On Wed, 27 Jul 2011, Peter Zijlstra wrote:
> > All this is simply about de-obfuscating all per-cpu assumptions. This is
> > about verification and traceability/debuggability.
> 
> Ok verification  and traceability are good but they should not
> be in the way of making core functionality high performance and low
> latency.
> 
> The key issue is that the -rt kernel has always had grave issues with
> performance when it comes to per cpu data access. Solving that by forcing
> the kernel to go slow it not the right approach.

Nobody want's the kernel to go slow. All we want and we consider that
also a benefit for mainline is: proper annotation of the per cpu data
access, like we have for RCU and for locking.

Right now everything else than the "atomic" this_cpu stuff needs
protection of some sort, but it's nowhere documented and we have no
way to prove the correctness.

That has absolutely nothing to do with -rt. We already had cases in
mainline where per cpu data structures were accessed without or with
wrong protections because the logic changed over time or people made
the wrong assumptions.

For -rt this lack of documentation and the lack of verification,
debugability and traceability is a major PITA, but that's true for
non-rt as well, just the PITA is gradually smaller and the bugs which
are there today are just extremly hard to trigger.

And Peters idea of per_cpu_lock*() annotations will boil down to the
exact same thing which is there today when you compile the kernel w/o
lockdep enabled for per_cpu data correctness. We don't want to change
anything or impose any slowness, we just want a proper way to document
and verify that maze. That's really not too much of a request.

Thanks,

	tglx


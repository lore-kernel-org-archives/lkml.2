Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489Ab2HQBUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 21:20:32 -0400
Received: from ozlabs.org ([203.10.76.45]:60368 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932672Ab2HQBUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 21:20:30 -0400
Message-ID: <1345166426.28806.0.camel@concordia>
Subject: Re: powerpc/perf: hw breakpoints return ENOSPC
From: Michael Ellerman <michael@ellerman.id.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        K Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Date: Fri, 17 Aug 2012 11:20:26 +1000
In-Reply-To: <1345126502.29668.36.camel@twins>
References: <28857.1345091034@neuling.org>
	 <1345102812.31459.114.camel@twins> <20344.1345115849@neuling.org>
	 <1345117498.29668.23.camel@twins> <1345125747.20062.12.camel@concordia>
	 <1345126502.29668.36.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 16:15 +0200, Peter Zijlstra wrote:
> On Fri, 2012-08-17 at 00:02 +1000, Michael Ellerman wrote:
> > You do want to guarantee that the task will always be subject to the
> > breakpoint, even if it moves cpus. So is there any way to guarantee that
> > other than reserving a breakpoint slot on every cpu ahead of time? 
> 
> That's not how regular perf works.. regular perf can overload hw
> resources at will and stuff is strictly per-cpu.
..
> For regular (!pinned) events, we'll RR the created events on the
> available hardware resources.

Yeah I know, but that isn't really the semantics you want for a
breakpoint. You don't want to sometimes have the breakpoint active and
sometimes not, it needs to be active at all times when the task is
running.

At the very least you want it to behave like a pinned event, ie. if it
can't be scheduled you get notified and can tell the user.

> HWBP does things completely different and reserves a slot over all CPUs
> for everything, thus stuff completely falls apart.

So it would seem :)

I guess my point was that reserving a slot on each cpu seems like a
reasonable way of guaranteeing that wherever the task goes we will be
able to install the breakpoint.

But obviously we need some way to make it play nice with perf.

cheers




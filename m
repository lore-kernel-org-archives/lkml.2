Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab1BXVDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:03:48 -0500
Received: from www.tglx.de ([62.245.132.106]:55440 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab1BXVDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:03:45 -0500
Date: Thu, 24 Feb 2011 22:03:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, amit.kucheria@linaro.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH V5 2/2] tracing, perf : add cpu hotplug trace events
In-Reply-To: <1298581112.5226.838.camel@laptop>
Message-ID: <alpine.LFD.2.00.1102242159300.2701@localhost6.localdomain6>
References: <AANLkTinkctQ6Nek98JV7vaos34gD4Qn8nsuBzt=_Jj6T@mail.gmail.com>  <1298573197.2428.457.camel@twins>  <20110224201124.138311ba@lxorguk.ukuu.org.uk>  <alpine.LFD.2.00.1102242115011.2701@localhost6.localdomain6>  <alpine.LFD.2.00.1102241522130.31831@xanadu.home>
  <1298579452.5226.834.camel@laptop>  <alpine.LFD.2.00.1102242130360.2701@localhost6.localdomain6> <1298581112.5226.838.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, Peter Zijlstra wrote:

> On Thu, 2011-02-24 at 21:47 +0100, Thomas Gleixner wrote:
> > On Thu, 24 Feb 2011, Peter Zijlstra wrote:
> > 
> > > On Thu, 2011-02-24 at 15:24 -0500, Nicolas Pitre wrote:
> > > 
> > > > Most SMP ARM processors are going to use it soon.  Powering down idle 
> > > > cores provides substantial power saving.
> > > 
> > > And why can't regular idle paths be used? CPU hotplug is a massively
> > > expensive operation.
> > 
> > To achieve the same result from idle, you need to exclude the core
> > from any unwanted wakeup. At the moment cpu unplug is the only way to
> > achieve that.
> 
> Right, everything is a nail because all we have is a hammer like.
> 
> > If you want to do the same from idle, then we need the isolation
> > features Frederic is working on for RT/HPC.
> > 
> > They allow us to isolate cores completely for totaly different
> > reasons, but it could be resused to provide full isolation of a core
> > in a very deep power state.
> 
> Exactly.
> 
> > That would solve the problem w/o going through kstompmachine
> 
> Right, kstopmachine is a large part of the problem, but cpu hotplug
> really does an insane amount of work if all you want is to idle the
> core.

As far as I can tell the isolation stuff covers lot's of the problems
including RCU, but there is still a way to go. And the good new is
that, when a cpu is idle it has not much state to preserve if its
properly isolated and the memory is not going away.

Thanks,

	tglx

 

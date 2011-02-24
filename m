Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab1BXVLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:11:25 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:33155 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab1BXVLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:11:23 -0500
Date: Thu, 24 Feb 2011 13:11:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, amit.kucheria@linaro.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH V5 2/2] tracing, perf : add cpu hotplug trace events
Message-ID: <20110224211117.GQ2264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTinkctQ6Nek98JV7vaos34gD4Qn8nsuBzt=_Jj6T@mail.gmail.com>
 <1298573197.2428.457.camel@twins>
 <20110224201124.138311ba@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.1102242115011.2701@localhost6.localdomain6>
 <alpine.LFD.2.00.1102241522130.31831@xanadu.home>
 <1298579452.5226.834.camel@laptop>
 <alpine.LFD.2.00.1102242130360.2701@localhost6.localdomain6>
 <1298581112.5226.838.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298581112.5226.838.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 09:58:32PM +0100, Peter Zijlstra wrote:
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

You do indeed need to know that the CPU will be powered off for quite
some time to be worth the extra work.  And a number of embedded devices
do have this level of foreknowledge -- for example, they might use the
second CPU only when the user is doing some computationally intensive
task, so that the device would normally be using only a single CPU.

							Thanx, Paul

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab1BXUuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 15:50:21 -0500
Received: from www.tglx.de ([62.245.132.106]:48384 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab1BXUuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 15:50:17 -0500
Date: Thu, 24 Feb 2011 21:49:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
cc: Peter Zijlstra <peterz@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, amit.kucheria@linaro.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH V5 2/2] tracing, perf : add cpu hotplug trace events
In-Reply-To: <alpine.LFD.2.00.1102241536120.31831@xanadu.home>
Message-ID: <alpine.LFD.2.00.1102242148400.2701@localhost6.localdomain6>
References: <AANLkTinkctQ6Nek98JV7vaos34gD4Qn8nsuBzt=_Jj6T@mail.gmail.com> <1298573197.2428.457.camel@twins> <20110224201124.138311ba@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1102242115011.2701@localhost6.localdomain6> <alpine.LFD.2.00.1102241522130.31831@xanadu.home>
 <1298579452.5226.834.camel@laptop> <alpine.LFD.2.00.1102241536120.31831@xanadu.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, Nicolas Pitre wrote:

> On Thu, 24 Feb 2011, Peter Zijlstra wrote:
> 
> > On Thu, 2011-02-24 at 15:24 -0500, Nicolas Pitre wrote:
> > 
> > > Most SMP ARM processors are going to use it soon.  Powering down idle 
> > > cores provides substantial power saving.
> > 
> > And why can't regular idle paths be used? CPU hotplug is a massively
> > expensive operation.
> 
> The idle path assumes that the CPU state is preserved.  We're talking 
> about cores completely going down with power pulled beneath them and 
> eventually rebooted dynamically here.

That's the equivalent of physical hotplug, but we still have all the
memory state around, so it is possible from idle, when we have the
full isolation features in place.

Thanks,

	tglx

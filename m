Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1BXUsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 15:48:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53480 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab1BXUs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 15:48:28 -0500
Subject: Re: [PATCH V5 2/2] tracing, perf : add cpu hotplug trace events
From: Peter Zijlstra <peterz@infradead.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, amit.kucheria@linaro.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.1102241536120.31831@xanadu.home>
References: <AANLkTinkctQ6Nek98JV7vaos34gD4Qn8nsuBzt=_Jj6T@mail.gmail.com>
	 <1298573197.2428.457.camel@twins>
	 <20110224201124.138311ba@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.1102242115011.2701@localhost6.localdomain6>
	 <alpine.LFD.2.00.1102241522130.31831@xanadu.home>
	 <1298579452.5226.834.camel@laptop>
	 <alpine.LFD.2.00.1102241536120.31831@xanadu.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 21:49:49 +0100
Message-ID: <1298580589.5226.836.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 15:40 -0500, Nicolas Pitre wrote:
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
> The idle path assumes that the CPU state is preserved. 

Not much of it,

>  We're talking 
> about cores completely going down with power pulled beneath them and 
> eventually rebooted dynamically here.

I think you can get away with actually pulling the power and re-initing
the cpu to idle from the idle path and the rest of the kernel not
caring.


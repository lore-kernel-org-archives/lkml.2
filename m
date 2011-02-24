Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab1BXVM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:12:56 -0500
Received: from www.tglx.de ([62.245.132.106]:35683 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab1BXVMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:12:54 -0500
Date: Thu, 24 Feb 2011 22:12:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, amit.kucheria@linaro.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH V5 2/2] tracing, perf : add cpu hotplug trace events
In-Reply-To: <20110224210431.7a6bba68@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.1102242206560.2701@localhost6.localdomain6>
References: <AANLkTinkctQ6Nek98JV7vaos34gD4Qn8nsuBzt=_Jj6T@mail.gmail.com> <1298573197.2428.457.camel@twins> <20110224201124.138311ba@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.1102242115011.2701@localhost6.localdomain6> <alpine.LFD.2.00.1102241522130.31831@xanadu.home>
 <1298579452.5226.834.camel@laptop> <alpine.LFD.2.00.1102241536120.31831@xanadu.home> <alpine.LFD.2.00.1102242148400.2701@localhost6.localdomain6> <20110224210431.7a6bba68@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, Alan Cox wrote:

> > That's the equivalent of physical hotplug, but we still have all the
> > memory state around, so it is possible from idle, when we have the
> 
> All sorts of other state goes walking as well though - on die device
> state for example like the GPU context may well also evaporate or
> disappear except for the minimum needed for scanout.
>
> It's not just about the CPU its a system (albeit a SoC in most cases)
> going to sleep lock stock and barrel except for IRQ notifications, and in
> some cases things like offloaded audio playback.

I guess we are talking about different things.

If you take down one core of a package then it does not take down the
whole SoC and does not take down devices either. Device take down is
or should be handled by explicit clock and power gating.

If you take down the whole SoC, then it's full S2RAM or some
equivilant thing. That's a different story and propably requires the
whole hotplug muck.

Thanks,

	tglx

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206Ab2BONik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 08:38:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:40729 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921Ab2BONif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 08:38:35 -0500
Message-ID: <1329313085.2293.106.camel@twins>
Subject: Re: [PATCH RFC 0/4] Scheduler idle notifiers and users
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Ingo Molnar <mingo@elte.hu>, linaro-kernel@lists.linaro.org,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Oleg Nesterov <oleg@redhat.com>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Chan <mike@android.com>, Dave Jones <davej@redhat.com>,
        Todd Poynor <toddpoynor@google.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org,
        Arjan Van De Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 15 Feb 2012 14:38:05 +0100
In-Reply-To: <4F3AEC4E.9000303@codeaurora.org>
References: <20120208013959.GA24535@panacea>
	 <1328670355.2482.68.camel@laptop> <20120208202314.GA28290@redhat.com>
	 <1328736834.2903.33.camel@pasglop> <20120209075106.GB18387@elte.hu>
	 <4F35DD3E.4020406@codeaurora.org> <20120211144530.GA497@elte.hu>
	 <4F3AEC4E.9000303@codeaurora.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 15:20 -0800, Saravana Kannan wrote:
> On 02/11/2012 06:45 AM, Ingo Molnar wrote:
> >
> > * Saravana Kannan<skannan@codeaurora.org>  wrote:
> >
> >> When you say accommodate all hardware, does it mean we will
> >> keep around CPUfreq and allow attempts at improving it? Or we
> >> will completely move to scheduler based CPU freq scaling, but
> >> won't try to force atomicity? Say, may be queue up a
> >> notification to a CPU driver to scale up the frequency as soon
> >> as it can?
> >
> > I don't think we should (or even could) force atomicity - we
> > adapt to whatever the hardware can do.
> 
> May be I misread the emails from Peter and you, but it sounded like the 
> idea being proposed was to directly do a freq change from the scheduler. 
> That would force the freq change API to be atomic (if it can be 
> implemented is another issue). That's what I was referring to when I 
> loosely used the terms "force atomicity".

Right, so we all agree cpufreq wants scheduler notifications because
polling sucks. The result is indeed you get to do cpufreq from atomic
context, because scheduling from the scheduler is 'interesting'.

> > But the design should be directed at systems where frequency
> > changes can be done in a reasonably fast manner. That is what he
> > future is - any change we initiate today takes years to reach
> > actual products/systems.
> 
> As long as the new design doesn't treat archs needing schedulable 
> context to set freq as a second class citizen, I think we would all be 
> happy.

I would really really like to do just that, if only to encourage
hardware people to just do the thing in hardware. Wanting both ultimate
power savings and crappy hardware just doesn't work -- and yes I'm
sticking to PMIC on i2c is shit as is having to manually sync up voltage
and freq changes.

>  Because it's not just a matter of it being old hardware. 
> Sometimes the decision to let the SW do the voltage scaling also comes 
> down to HW cost. Considering Linux runs on such a wide set of archs, I 
> think we shouldn't treat the need for schedulable context for freq 
> setting as "broken" or "not sane".

So you'd rather spend double the money on trying to get software working
on broken ass hardware?

A lot of these lets save 3 transistors, software can fix it up, hardware
feat^Wfailures end up in spending more than the savings on making the
software doing the fixup. I'm sure tglx can share a few stories here.

Now we could probably cludge something, and we might have to, but I'll
hate you guys for it.

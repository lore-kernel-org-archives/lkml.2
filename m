Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934222Ab1ESSKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:10:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57879 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934156Ab1ESSK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:10:29 -0400
Date: Thu, 19 May 2011 20:10:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [patch 4/7] clockevents: Provide combined configure and register
 function
Message-ID: <20110519181022.GE6139@elte.hu>
References: <20110518205713.947614271@linutronix.de>
 <20110518210136.331975870@linutronix.de>
 <20110519090849.GA6251@elte.hu>
 <alpine.LFD.2.02.1105191155170.3078@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105191155170.3078@ionos>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 19 May 2011, Ingo Molnar wrote:
> 
> > 
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > +extern void clockevents_config_and_register(struct clock_event_device *dev,
> > > +					    u32 freq, unsigned long min_delta,
> > > +					    unsigned long max_delta);
> > 
> > might be worth collecting these fields into a clocksource_params structure:
> > 
> > struct clocksource_params {
> > 	u32		freq;
> > 	unsigned long	min_delta;
> > 	unsigned long	max_delta;
> > };
> > 
> > That way the initialization API looks even more streamlined:
> > 
> > extern void
> > clockevents_config_and_register(struct clock_event_device *dev,
> > 				struct clocksource_params params);
> > 
> > and could be extended in the future, without having to update every single 
> > clocksource driver again.
> 
> Though it's unlikely that we have more params int the foreseeable
> future and it's more code in the clock events registration sites as
> you have to do:
> 
>     struct param par;
> 
>     par.freq = f;
>     par.min_delta = x;
>     par.max_delta = y;
>     clockevents_config_and_register(&dev, &p);
> 
> instead of having a single line.

Indeed that looks uglish.

> When the need arises we still can do
> 
> __clockevents_config_and_register(struct clock_event_device *dev,
>    	                          struct clocksource_params params);
> 
> and have the current function as a wrapper around it.

Okay, you are right.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab1ESKAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 06:00:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:40066 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab1ESKAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 06:00:16 -0400
Date: Thu, 19 May 2011 12:00:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [patch 4/7] clockevents: Provide combined configure and register
 function
In-Reply-To: <20110519090849.GA6251@elte.hu>
Message-ID: <alpine.LFD.2.02.1105191155170.3078@ionos>
References: <20110518205713.947614271@linutronix.de> <20110518210136.331975870@linutronix.de> <20110519090849.GA6251@elte.hu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011, Ingo Molnar wrote:

> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > +extern void clockevents_config_and_register(struct clock_event_device *dev,
> > +					    u32 freq, unsigned long min_delta,
> > +					    unsigned long max_delta);
> 
> might be worth collecting these fields into a clocksource_params structure:
> 
> struct clocksource_params {
> 	u32		freq;
> 	unsigned long	min_delta;
> 	unsigned long	max_delta;
> };
> 
> That way the initialization API looks even more streamlined:
> 
> extern void
> clockevents_config_and_register(struct clock_event_device *dev,
> 				struct clocksource_params params);
> 
> and could be extended in the future, without having to update every single 
> clocksource driver again.

Though it's unlikely that we have more params int the foreseeable
future and it's more code in the clock events registration sites as
you have to do:

    struct param par;

    par.freq = f;
    par.min_delta = x;
    par.max_delta = y;
    clockevents_config_and_register(&dev, &p);

instead of having a single line.

When the need arises we still can do

__clockevents_config_and_register(struct clock_event_device *dev,
   	                          struct clocksource_params params);

and have the current function as a wrapper around it.

Thanks,

	tglx

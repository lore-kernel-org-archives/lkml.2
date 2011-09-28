Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab1I1MsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 08:48:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab1I1MsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 08:48:23 -0400
Subject: Re: [PATCH v3 11/24] C6X: time management
From: Mark Salter <msalter@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 28 Sep 2011 08:48:10 -0400
In-Reply-To: <alpine.LFD.2.02.1109280130570.2711@ionos>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com>
	 <1317155405-26235-12-git-send-email-msalter@redhat.com>
	 <alpine.LFD.2.02.1109280130570.2711@ionos>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1317214091.2580.59.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 01:41 +0200, Thomas Gleixner wrote:
> On Tue, 27 Sep 2011, Mark Salter wrote:
> 
> > The C6X architecture includes a 64-bit free running core clock counter which
> > is used as the clocksource. The SoCs have a number of 64-bit programmable
> > timers. One of these is used as the clockevent timer.
> > 
> > + *  Port on Texas Instruments TMS320C6x architecture
> > + *
> > + *  Copyright (C) 2004, 2009, 2010, 2011 Texas Instruments Incorporated
> > + *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
> > + *
> > + *  Modified for 2.6.34: Mark Salter <msalter@redhat.com>
> 
> Hmm. Who wrote that code and who is assigned the authorship? If the
> original Author is Aurelian, then this patch is missing:
> 
>   - An extra From: ....
> 
>   - A SOB from the orginal author or an explnation why it's not
>     available.
> 
> If not, then this want's to be documented in a proper form.
> 
> Please do not attribute other peoples code to yourself w/o a fcking
> good reason. And porting forward itself is not considered to be one.
> 

Indeed not. I was focused on the code in putting the series together and
completely overlooked the proper attribution and CCs.

> > +/*
> > + * This should be close enough...
> 
> What's the point of that comment ?

None. It shouldn't be there.

> 
> > + */
> > +#define CLOCK_TICK_RATE ((1000 * 1000000UL) / 6)
> > +
> > +/* 64-bit timestamp */
> > +typedef unsigned long long cycles_t;
> 
> ...
> 
> > +static int next_event(unsigned long delta,
> > +		      struct clock_event_device *evt)
> > +{
> > +	soc_writel(soc_readl(&timer->tcr) & ~TCR_ENAMODELO_MASK, &timer->tcr);
> > +	soc_writel(delta - 1, &timer->prdlo);
> > +	soc_writel(0, &timer->cntlo);
> > +	soc_writel(soc_readl(&timer->tcr) | TCR_ENAMODELO_ONCE, &timer->tcr);
> > +
> > +	return 0;
> > +}
> > +
> > +static void set_clock_mode(enum clock_event_mode mode,
> > +			   struct clock_event_device *evt)
> > +{
> 
> So there is no way to disable that thing ?

I will check...

--Mark



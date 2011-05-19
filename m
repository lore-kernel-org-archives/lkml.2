Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab1ESJhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:37:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46905 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932901Ab1ESJhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:37:17 -0400
Date: Thu, 19 May 2011 11:37:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [patch 5/7] clockevents: Provide interface to reconfigure an
 active clock event device
Message-ID: <20110519093706.GE6251@elte.hu>
References: <20110518205713.947614271@linutronix.de>
 <20110518210136.437459958@linutronix.de>
 <20110519091024.GB6251@elte.hu>
 <alpine.LFD.2.02.1105191132260.3078@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105191132260.3078@ionos>
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
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> > > + */
> > > +int clockevents_reconfigure(struct clock_event_device *dev, u32 freq)
> > 
> > This too could use a struct clockevents_params perhaps - and would only use 
> > params.freq for now but might be extended in the future.
> > 
> > But i'm fine with this API as well:
> 
> I agree for the config_register interface, but here we really just
> want to update the frequency and not change any other parameter.

ok, fair enough - in that case i'd suggest making that property explicitly 
visible in the API name, via something like:

	int clockevents_set_freq(struct clock_event_device *dev, u32 freq)

That way it's obvious at first sight what this does:

	clockevents_set_freq(dev, 1000000);

Versus:

	clockevents_reconfigure(dev, 1000000);

Thanks,

	Ingo

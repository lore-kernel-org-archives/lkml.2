Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab2B1IaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:30:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57802 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756821Ab2B1IaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:30:19 -0500
Date: Tue, 28 Feb 2012 09:30:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/7] time: Condense timekeeper.xtime into xtime_sec
Message-ID: <20120228083014.GH21106@elte.hu>
References: <1330388974-27793-1-git-send-email-john.stultz@linaro.org>
 <1330388974-27793-2-git-send-email-john.stultz@linaro.org>
 <20120228080647.GC21106@elte.hu>
 <1330417040.2340.344.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330417040.2340.344.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* John Stultz <john.stultz@linaro.org> wrote:

> On Tue, 2012-02-28 at 09:06 +0100, Ingo Molnar wrote:
> > * John Stultz <john.stultz@linaro.org> wrote:
> > > +
> > > +static void timekeeper_set_xtime(struct timekeeper *tk,
> > > +					const struct timespec *ts)
> > 
> > Pointless (because ugly) line break.
> > 
> > > +{
> > > +	tk->xtime_sec = ts->tv_sec;
> > > +	tk->xtime_nsec = ts->tv_nsec << tk->shift;
> > > +}
> > > +
> > > +
> > > +static void timekeeper_xtime_add(struct timekeeper *tk,
> > > +					const struct timespec *ts)
> > 
> > Pointless (because ugly) line break.
> 
> Ack on your other comments, but I'm not sure I'm following you here.
> What would you rather see in this case?

Well, either not break the line really (it's just trivially 
above col80: it's 83 cols), or do a *sensible* line break - one 
of:

static void timekeeper_xtime_add(struct timekeeper *tk,
				 const struct timespec *ts)

(here the arguments align vertically)

Or:

static void
timekeeper_xtime_add(struct timekeeper *tk, const struct timespec *ts)

(here he return type is on a separate line)

Or, my favorite, just make the name shorter, because it's too 
long:

static void tk_xtime_add(struct timekeeper *tk, const struct timespec *ts)

Obviously this applies to other functions as well - the tk_*() 
method pattern should be applied consistently. Anyone reading 
time code will know that 'tk' is about the global timekeeper 
structure - no need to use the verbose name in methods.

Thanks,

	Ingo

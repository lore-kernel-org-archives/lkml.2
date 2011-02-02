Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab1BBJyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 04:54:13 -0500
Received: from www.tglx.de ([62.245.132.106]:48066 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab1BBJyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 04:54:11 -0500
Date: Wed, 2 Feb 2011 10:53:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 18/28] posix-timers: Convert timer_delete() to
 clockid_to_kclock()
In-Reply-To: <20110202082943.GC2747@riccoc20.at.omicron.at>
Message-ID: <alpine.LFD.2.00.1102021053350.31804@localhost6.localdomain6>
References: <20110201134320.688829863@linutronix.de> <20110201134419.198999420@linutronix.de> <20110202082943.GC2747@riccoc20.at.omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Feb 2011, Richard Cochran wrote:

> On Tue, Feb 01, 2011 at 01:52:07PM -0000, Thomas Gleixner wrote:
> > Index: linux-2.6-tip/kernel/posix-timers.c
> > ===================================================================
> > --- linux-2.6-tip.orig/kernel/posix-timers.c
> > +++ linux-2.6-tip/kernel/posix-timers.c
> > @@ -254,6 +254,7 @@ static __init int init_posix_timers(void
> >  		.timer_create	= common_timer_create,
> >  		.timer_set	= common_timer_set,
> >  		.timer_get	= common_timer_get,
> > +		.timer_del	= common_timer_del,
> >  	};
> >  	struct k_clock clock_monotonic = {
> >  		.clock_getres	= hrtimer_get_res,
> > @@ -263,6 +264,7 @@ static __init int init_posix_timers(void
> >  		.timer_create	= common_timer_create,
> >  		.timer_set	= common_timer_set,
> >  		.timer_get	= common_timer_get,
> > +		.timer_del	= common_timer_del,
> >  	};
> >  	struct k_clock clock_monotonic_raw = {
> >  		.clock_getres	= hrtimer_get_res,
> 
> The definition of common_timer_del() should not be "inline" since the
> address of the function is in these tables. The declaration is not
> inline, and gcc 4.2.4 gives a warning.
> 
> (But strangly, newer versions do not).

Will fix. Thanks.

     tglx

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab1LWKxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 05:53:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42779 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635Ab1LWKxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 05:53:40 -0500
Date: Fri, 23 Dec 2011 11:51:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>, Greg KH <greg@kroah.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lttng-dev@lists.lttng.org" <lttng-dev@lists.lttng.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [lttng-dev] [PATCH 09/11] sched: export task_prio to GPL modules
Message-ID: <20111223105128.GF4749@elte.hu>
References: <1322780830.4699.62.camel@twins>
 <20111201231751.GA4961@kroah.com>
 <20111205141749.GC28866@elte.hu>
 <20111206214446.GD1247@kroah.com>
 <20111208052354.GC9485@elte.hu>
 <20111208232709.GA19820@kroah.com>
 <20111219104915.GA19861@elte.hu>
 <20111219153053.GA21548@Krystal>
 <20111220110813.GA19105@elte.hu>
 <4EF10237.8040700@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF10237.8040700@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Rowand <frank.rowand@am.sony.com> wrote:

> On 12/20/11 03:08, Ingo Molnar wrote:
> > 
> > (Cc:-ing Arnaldo on this as well.)
> > 
> > * Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> > 
> 
> < snip >
> 
> > I think your concentration on ABIs is missing a very fundamental 
> > property of instrumentation:
> > 
> >   the life-time and persistence of instrumentation data is 
> >   typically very short ('days' is already an exception - typical 
> >   is minutes, at most hours), and for that reason we havent been 
> >   getting much pressure from users to maintain a perf.data ABI - 
> >   but we are doing it nevertheless.
> > 
> > Instrumentation is fundamentally about the 'here and now' and so 
> > it fundamentally differs from things like backup formats and 
> > database formats. An ABI does not hurt and we are maintaining 
> > it, but you are overrating its importance significantly.
> 
> Just to provide visibility to a different use case...
> 
> The life time of my data is typically weeks, months, or years 
> (though I am not likely to re-process year old raw data).

I'm not saying that it's absolutely never done: for example 
monitoring/logging on a production box and evaluating events 
only once per month would certainly qualify.

I just say that the overwhelming majority of usecases utilize 
traces on a short time-span and that we must keep the common 
usecase in mind when supporting not so common usecases.

It's the same deal as with -rt: compared to the 'normal' usage 
of Linux -rt is somewhat of a special case - yet it's still 
something very much worth doing, as long as the main usecase is 
always kept in mind.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab0KJTbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:31:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60780 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab0KJTbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:31:18 -0500
Date: Wed, 10 Nov 2010 20:30:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        akpm@linux-foundation.org, mchehab@redhat.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC/Requirements/Design] h/w error reporting
Message-ID: <20101110193034.GA9414@elte.hu>
References: <1289400056.12418.139.camel@gandalf.stny.rr.com>
 <1289400234.2191.129.camel@laptop>
 <1289401781.12418.145.camel@gandalf.stny.rr.com>
 <1289403019.2084.17.camel@laptop>
 <20101110174852.GB4001@elte.hu>
 <1289412329.12418.177.camel@gandalf.stny.rr.com>
 <1289413460.2084.27.camel@laptop>
 <20101110184105.GH22410@elte.hu>
 <1289415645.12418.180.camel@gandalf.stny.rr.com>
 <20101110191127.GA6190@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110191127.GA6190@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, Nov 10, 2010 at 02:00:45PM -0500, Steven Rostedt wrote:
> > On Wed, 2010-11-10 at 19:41 +0100, Ingo Molnar wrote:
> > 
> > > We'll need to embark on this incremental path instead of a rewrite-the-world 
> > > thing. As a maintainer my task is to say 'no' to rewrite-the-world approaches 
> > > - and we can and will do better here.
> > 
> > Thus you are saying that we stick to the status quo, and also ignore the fact 
> > that perf was a rewrite-the-world from ftrace to begin with.
> 
> Perhaps you and Mathieu can summarize your requirements here and then explain why 
> extending the current ABI wouldn't work. It's quite normal that people try to find 
> a solution fully backward compatible in the first place. If it's not possible, 
> fine, but then justify it.

Yeah, that's pretty much the only reasonable approach really. It also makes every 
single step testable and verifiable, and often optional as well:

 - How much do we win from more compressed records? Do we win? Do we want _larger_,
   less encoded records on some CPUs because their construction overhead and cache
   behavior is better there?

 - How much does splice() help?

 - How much do the sampling fast-path approaches help. How many apps will make use
   of them?

Those are all issues that are virtually undecidable individually if the approach is 
an all-or-nothing flag-day thing.

Fact is that the perf events based tool space is vibrant and alive, and new uses are 
popping up every week. We'd be utter fools to not embark on an iterative approach 
here. It does not even limit us in any way technically.

The days of full tracing subsystem rewrites are over Steve, i'm afraid it is time 
for us to grow up ;-)

Thanks,

	Ingo

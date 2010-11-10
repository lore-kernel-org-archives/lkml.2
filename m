Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab0KJSln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:41:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43545 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948Ab0KJSlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:41:42 -0500
Date: Wed, 10 Nov 2010 19:41:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Luck, Tony" <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, ying.huang@intel.com, bp@alien8.de,
        tglx@linutronix.de, akpm@linux-foundation.org, mchehab@redhat.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC/Requirements/Design] h/w error reporting
Message-ID: <20101110184105.GH22410@elte.hu>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
 <20101110101450.GA18481@elte.hu>
 <1289400056.12418.139.camel@gandalf.stny.rr.com>
 <1289400234.2191.129.camel@laptop>
 <1289401781.12418.145.camel@gandalf.stny.rr.com>
 <1289403019.2084.17.camel@laptop>
 <20101110174852.GB4001@elte.hu>
 <1289412329.12418.177.camel@gandalf.stny.rr.com>
 <1289413460.2084.27.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289413460.2084.27.camel@laptop>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2010-11-10 at 13:05 -0500, Steven Rostedt wrote:
> 
> > Peter said at LPC that the perf buffering system was not designed to handle high 
> > speed tracing. But he also said he does not like the way the ftrace buffering 
> > works.
> 
> You're not very good at listening, I said the perf infrastructure and event 
> handling mechanism isn't geared towards full throughput but instead on sampling.

Note that even that is an implementational detail that can be changed: even with a 
sampling model the sampling bits are in a flag word, so common combinations can be 
checked for quickly and open-coded into flat fall-through code - if the sample 
decoding ever shows up as overhead. (It doesnt even need any ABI changes.)

So it's a non-issue.

> There is lots of code between getting the event and landing it in the buffer. The 
> buffer itself is perfectly suited for high speed low overhead stuffs, the perf 
> data format possibly not because its not bitfield happy.

Even that can be tweaked via allowing more compressed records. I doubt it will help 
as much, but it's still an incremental change that can be validated carefully.

Fact is that we have an ABI, happy users, happy tools and happy developers, so going 
incrementally is important and allows us to validate and measure every step while 
still having a full tool-space in place - and it will help everyone, in addition to 
the ftrace/lttng usecases.

We'll need to embark on this incremental path instead of a rewrite-the-world thing. 
As a maintainer my task is to say 'no' to rewrite-the-world approaches - and we can 
and will do better here.

Thanks,

	Ingo

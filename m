Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357Ab0KQPD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:03:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34148 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419Ab0KQPD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:03:56 -0500
Date: Wed, 17 Nov 2010 16:03:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 1/5] [PATCH 1/5] events: Add EVENT_FS the event
 filesystem
Message-ID: <20101117150332.GA7603@elte.hu>
References: <20101117005357.024472450@goodmis.org>
 <20101117005939.600541101@goodmis.org>
 <20101117033242.GB31335@suse.de>
 <20101117103914.GA21976@elte.hu>
 <1289996753.30543.35.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289996753.30543.35.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Are these events now going to be labeled as stable?  Is every tracepoint we have, 
> much have the same data?  Linus specifically said at Kernel Summit that he wants 
> absolutely NO modules to have a stable tracepoint.

I think you are worrying about the wrong things.

I think Arjan's complaints at the KS stemmed from prior sporadic declarations on 
lkml that there is no tracepoint ABI _at all_, and that powertop/latencytop could 
break anytime.

But in reality i strongly disagree with such declarations, and tracepoint data that 
is used by PowerTop/timechart/latencytop or perf is and was an ABI, simple as that - 
and i've been enforcing that for two years. (We have so few good instrumentation 
tools that we _really_ dont want to break them.)

At that point, realizing that we have an ABI for existing tools, i think it's 
fundamentally misguided to go out on a limb trying to put barriers in the way of 
other tools that do not even exist to begin with ...

Our real problem with tracing is lack of relevance, lack of utility, lack of 
punch-through analytical power.

Trying to create a sandbox to _reduce utility_ is like the last step, and a really 
optional step, when we have such variety that we want some control over it. It's 
always expensive, it always reduces the tool space as collateral damage.

So please dont think of sysfs or eventfs as a tool to restrict. Think of it as a 
tool to _organize_.

Again, i'd _LOVE_ to have the 'problem' of us having so many tools that analyze 
application and kernel behavior in such a rich way that they use tracepoints that 
were not supposed to be 'stable'.

I simply dont see the 'problem' that is being solved here. We had a stable ABI and 
we didnt break sysprof or powertop/latencytop in the past and wont break it in the 
future either.

Thanks,

	Ingo

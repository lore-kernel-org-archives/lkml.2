Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934785Ab0KQPRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:17:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34400 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934755Ab0KQPRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:17:02 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=VINkOuZDQI4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=3h2OZVCpzC4U1w4x6DYA:9 a=KYynBsFCo3jxtKjpDUcA:7 a=PPmsoscCd3HbLgSX-Muqt4KpIJEA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 1/5] [PATCH 1/5] events: Add EVENT_FS the event
 filesystem
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
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
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Hellwig <hch@lst.de>
In-Reply-To: <20101117150332.GA7603@elte.hu>
References: <20101117005357.024472450@goodmis.org>
	 <20101117005939.600541101@goodmis.org> <20101117033242.GB31335@suse.de>
	 <20101117103914.GA21976@elte.hu>
	 <1289996753.30543.35.camel@gandalf.stny.rr.com>
	 <20101117150332.GA7603@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 17 Nov 2010 10:16:59 -0500
Message-ID: <1290007019.30543.65.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 16:03 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Are these events now going to be labeled as stable?  Is every tracepoint we have, 
> > much have the same data?  Linus specifically said at Kernel Summit that he wants 
> > absolutely NO modules to have a stable tracepoint.
> 
> I think you are worrying about the wrong things.
> 
> I think Arjan's complaints at the KS stemmed from prior sporadic declarations on 
> lkml that there is no tracepoint ABI _at all_, and that powertop/latencytop could 
> break anytime.
> 
> But in reality i strongly disagree with such declarations, and tracepoint data that 
> is used by PowerTop/timechart/latencytop or perf is and was an ABI, simple as that - 
> and i've been enforcing that for two years. (We have so few good instrumentation 
> tools that we _really_ dont want to break them.)
> 
> At that point, realizing that we have an ABI for existing tools, i think it's 
> fundamentally misguided to go out on a limb trying to put barriers in the way of 
> other tools that do not even exist to begin with ...
> 
> Our real problem with tracing is lack of relevance, lack of utility, lack of 
> punch-through analytical power.
> 
> Trying to create a sandbox to _reduce utility_ is like the last step, and a really 
> optional step, when we have such variety that we want some control over it. It's 
> always expensive, it always reduces the tool space as collateral damage.
> 
> So please dont think of sysfs or eventfs as a tool to restrict. Think of it as a 
> tool to _organize_.
> 
> Again, i'd _LOVE_ to have the 'problem' of us having so many tools that analyze 
> application and kernel behavior in such a rich way that they use tracepoints that 
> were not supposed to be 'stable'.
> 
> I simply dont see the 'problem' that is being solved here. We had a stable ABI and 
> we didnt break sysprof or powertop/latencytop in the past and wont break it in the 
> future either.

What about a tool that picks up tracepoints that were only used by a
developer for in-field debugging, and then that tracepoint disappears
because of a design change. Is it OK for that tool to break with it?

Do all tools that use tracepoints require a "check" feature?

I guess the problem is that creators of the tools to analyze the kernel
have no idea of what they can count on and what they can't. Do we need a
process to have these tool creators request to developers to "keep this
tracepoint"?


-- Steve



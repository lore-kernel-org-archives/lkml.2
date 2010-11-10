Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab0KJSFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:05:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38289 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab0KJSFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:05:33 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=2Zzf6Ss2cq4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=5zDFaqfdbTJGaCSBgWMA:9 a=vVzE5YQDUg2h0BS3l7r1m5ACaRAA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC/Requirements/Design] h/w error reporting
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        akpm@linux-foundation.org, mchehab@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20101110174852.GB4001@elte.hu>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
	 <20101110101450.GA18481@elte.hu>
	 <1289400056.12418.139.camel@gandalf.stny.rr.com>
	 <1289400234.2191.129.camel@laptop>
	 <1289401781.12418.145.camel@gandalf.stny.rr.com>
	 <1289403019.2084.17.camel@laptop>  <20101110174852.GB4001@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 10 Nov 2010 13:05:29 -0500
Message-ID: <1289412329.12418.177.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 18:48 +0100, Ingo Molnar wrote:

> Yep. The obvious direction is to extend the event buffering ABI we already have, 
> with whatever additions that are needed:
> 
>  - document that we already support flight recorder mode

I thought this was still broken?

> 
>  - a more compressed record format
> 
>  - NOP filler events up to page boundary, for better splice and for better flight 
>    recorder
> 
>  - splice support
> 
> etc. That's how it evolved until now and it's all very extensible.
> 
> Steve, could you please list the additions you have in mind, in order of priority?

A few of things that pop up quickly are:

1) lockless

2) as-fast-as possible

3) support all tasks / all CPUs and still have as-fast-as-possible

Peter said at LPC that the perf buffering system was not designed to
handle high speed tracing. But he also said he does not like the way the
ftrace buffering works.

I think if we take a step back, we can come up with a new buffering/ABI
system that can satisfy everyone. We will still support the current
method now, but I really don't think it is designed with everything we
had in mind. I do not envision that we can "envolve" to where we want to
be. We may have to bite the bullet, just like iptables did when they saw
the failures of ipchains, and redesign something new now that we
understand what the requirements are.

I do think we need to come up with something new but still support the
old methods. Thomas came up with this idea, and Peter, Frederic and
myself agreed.

-- Steve



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab0KJXrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:47:14 -0500
Received: from www.tglx.de ([62.245.132.106]:56654 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757325Ab0KJXrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:47:10 -0500
Date: Thu, 11 Nov 2010 00:45:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: Tracing Requirements (was: [RFC/Requirements/Design] h/w error
 reporting)
In-Reply-To: <1289431227.12418.211.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1011110025530.2900@localhost6.localdomain6>
References: <1289401781.12418.145.camel@gandalf.stny.rr.com>  <1289403019.2084.17.camel@laptop> <20101110174852.GB4001@elte.hu>  <1289412329.12418.177.camel@gandalf.stny.rr.com>  <1289413460.2084.27.camel@laptop> <20101110184105.GH22410@elte.hu> 
 <1289415645.12418.180.camel@gandalf.stny.rr.com>  <20101110191127.GA6190@nowhere> <20101110202316.GA32396@Krystal>  <987664A83D2D224EAE907B061CE93D5301649A71DC@orsmsx505.amr.corp.intel.com>  <20101110225115.GB9299@Krystal>  <alpine.LFD.2.00.1011110004520.2900@localhost6.localdomain6>
 <1289431227.12418.211.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010, Steven Rostedt wrote:

> On Thu, 2010-11-11 at 00:12 +0100, Thomas Gleixner wrote:
> 
> > Cramming both into the same session is just insane.
> 
> That just doubled the overhead of the tracer.
> 
> > 
> > The first rule is "Keep It Simple!".  Period.
> 
> It's not that complex. Both Mathieu and I have implemented it. Really,
> I've seen a lot more complex code. Just because it does not fit into the
> CS101 course does not mean that it is totally complex.

I know you have implemented it and it's not about CS101, it's about
the insanity of what we have in the ftrace ringbuffer code. It does
not fulfil in any way the "Keep it Simple" requirement. Period.

And as I said earlier on IRC, you are trying to create the

  ZeroImpactFilteringMultiSessionFlightRecorderOverwriteFifoSplicePerfMmapTracer

which is a nice wet dream, but completely unrealistic to achieve in
one go.

When I yelled at you folks in Boston last week and suggested to come
up with a syscall for buffers and the corresponding configuration
interfaces along with a unified record format, then I certainly did
not ask for the ZIFMSFROFSPMT thingy and a rewrite the world approach.

I told you back in 2008 that you need to think hard about the
interfaces and start with a reasonable simple implementation. Then
proceed from there.

The overall achievement so far is an ongoing ringbuffer pissing
contest, zero interfaces and lenghty explanations which kind of tracer
madness is preferred by whom.

I don't call this progress. If you did not get the message last week,
then you have it in writing now to digest as long as it takes:

 Get your gear together and come up with sensible gradual approaches
 which bring us to a better progress ratio than 0/year.

Thanks,

	tglx

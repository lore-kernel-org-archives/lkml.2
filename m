Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1DWNQl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 09:16:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58185 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab1DWNQk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 09:16:40 -0400
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        arun@sharma-home.net, Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <BANLkTi=pk7J1uqCQvJe+RrTPoi=K1Aa5QQ@mail.gmail.com>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
	 <20110422092322.GA1948@elte.hu>
	 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
	 <20110422105211.GB1948@elte.hu>
	 <20110422165007.GA18401@vps.sharma-home.net>
	 <20110422203022.GA20573@elte.hu> <20110422203222.GA21219@elte.hu>
	 <20110423000347.GC9328@tassilo.jf.intel.com>
	 <1303545012.2298.44.camel@twins>
	 <BANLkTi=pk7J1uqCQvJe+RrTPoi=K1Aa5QQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 23 Apr 2011 15:16:01 +0200
Message-ID: <1303564561.2298.62.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-23 at 14:06 +0200, Stephane Eranian wrote:
> On Sat, Apr 23, 2011 at 9:50 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2011-04-22 at 17:03 -0700, Andi Kleen wrote:
> >> > > Yes, and note that with instructions events we even have skid-less PEBS
> >> > > profiling so seeing the precise .
> >> >                                   - location of instructions is possible.
> >>
> >> It was better when it was eaten. PEBS does not actually eliminated
> >> skid unfortunately. The interrupt still occurs later, so the
> >> instruction location is off.
> >>
> >> PEBS merely gives you more information.
> >
> > You're so skilled at not actually saying anything useful. Are you
> > perchance referring to the fact that the IP reported in the PEBS data is
> > exactly _one_ instruction off? Something that is demonstrated to be
> > fixable?
> >
> > Or are you defining skid differently and not telling us your definition?
> >
> 
> PEBS is guaranteed to return an IP that is just after AN instruction that
> caused the event. However, that instruction is NOT the one at the end
> of your period. Let's take an example with INST_RETIRED, period=100000.
> Then, the IP you get is NOT after the 100,000th retired instruction. It's an
> instruction that is N cycles after that one. There is internal skid due to the
> way PEBS is implemented.
> 
> That is what Andi is referring to. The issue causes bias and thus impacts
> the quality of the samples. On SNB, there is a new INST_RETIRED:PREC_DIST
> event. PREC_DIST=precise distribution. It tries to correct for the skid
> on this event on INST_RETIRED with PEBS (look at Vol3b).

Sure, but who cares? So your period isn't exactly what you specified,
but the effective period will have an average and a fairly small stdev
(assuming the initial period is much larger than the relatively few
cycles it takes to arm the PEBS assist), therefore you still get a
fairly uniform spread.

I don't much get the obsession with precision here, its all a statistics
game anyway.

And while you keep saying the examples are too trivial and Andi keep
sprouting vague non-statements, neither of you actually provide anything
sensible to the discussion.

So stop f*cking whining and start talking sense or stop talking all
together.

I mean, you were in the room where Intel presented their research on
event correlations based on pathological micro-benches. That clearly
shows that exact event definitions simply don't matter.

Similarly all this precision wanking isn't _that_ important, the big
fish clearly stand out, its only when you start shaving off the last few
cycles that all that really comes in handy, before that its mostly: ooh
thinking is hard, lets go shopping.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab1DWMhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 08:37:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34105 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877Ab1DWMhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 08:37:21 -0400
Date: Sat, 23 Apr 2011 14:36:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <ak@linux.intel.com>,
        arun@sharma-home.net, Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [generalized cache events] Re: [PATCH 1/1] perf tools: Add
 missing user space support for config1/config2
Message-ID: <20110423123650.GA5147@elte.hu>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com>
 <20110422092322.GA1948@elte.hu>
 <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com>
 <20110422105211.GB1948@elte.hu>
 <20110422165007.GA18401@vps.sharma-home.net>
 <20110422203022.GA20573@elte.hu>
 <20110422203222.GA21219@elte.hu>
 <20110423000347.GC9328@tassilo.jf.intel.com>
 <1303545012.2298.44.camel@twins>
 <BANLkTi=pk7J1uqCQvJe+RrTPoi=K1Aa5QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=pk7J1uqCQvJe+RrTPoi=K1Aa5QQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Stephane Eranian <eranian@google.com> wrote:

> On Sat, Apr 23, 2011 at 9:50 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Fri, 2011-04-22 at 17:03 -0700, Andi Kleen wrote:
> >> > > Yes, and note that with instructions events we even have skid-less PEBS
> >> > > profiling so seeing the precise .
> >> >                                   - location of instructions is possible.
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
> caused the event. However, that instruction is NOT the one at the end of your 
> period. Let's take an example with INST_RETIRED, period=100000. Then, the IP 
> you get is NOT after the 100,000th retired instruction. It's an instruction 
> that is N cycles after that one. There is internal skid due to the way PEBS 
> is implemented.

You are really misapplying the common-sense definition of 'skid'.

Skid refers to the instruction causing a profiler hit being mis-identified. 
Google 'x86 pmu skid' and read the third entry: your own prior posting ;-)

What you are referring to here is not really classic skid but a small, mostly 
constant skew in the period length with some very small amount of variability. 
It's thus mostly immaterial - at most a second or third order effect with 
typical frequencies of sampling.

Thanks,

	Ingo

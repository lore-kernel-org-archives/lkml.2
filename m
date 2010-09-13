Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab0IMUAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:00:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55230 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab0IMUAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:00:38 -0400
Date: Mon, 13 Sep 2010 22:00:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] sched: Improve latencies under load by decreasing
 minimum scheduling granularity
Message-ID: <20100913200018.GA31186@elte.hu>
References: <1284383758.2275.283.camel@laptop>
 <20100913135621.GA13442@Krystal>
 <1284387398.2275.311.camel@laptop>
 <20100913161641.GA28707@Krystal>
 <AANLkTimB9CjH5SjeY9XmwhTp1tfFPwh-Q1Y4o918h7XD@mail.gmail.com>
 <20100913174533.GA15653@Krystal>
 <20100913180348.GA20171@elte.hu>
 <20100913181925.GA15107@Krystal>
 <20100913182355.GC20171@elte.hu>
 <AANLkTi=TfU6PxDce9WbcQA7tFcT0yY+FqCOUC_cbfj+e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=TfU6PxDce9WbcQA7tFcT0yY+FqCOUC_cbfj+e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2325]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Sep 13, 2010 at 11:23 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Linus, Mathieu, you can test the granularity reduction patch via:
> 
> Hmm. It's a bit hard to judge subjective feelings, especially when you 
> have expectations of improvement, but yes, I think this does improve 
> the the interactive feel when scroll-wheeling around in firefox or 
> chrome.

Yeah. Human perception generally notices the _gradient_ of behavior - 
i.e. the difference between the best-case and worst-case behavior. I.e. 
we notice the max latencies - and those came down distinctly in 
everyone's measurements.

Somewhat paradoxially, 'always slow' is generally felt as an improvement 
over 'sometimes fast, sometimes slow' - even though the latter has a 
better average. (as long as 'slow' is not 'intolerably slow')

> So on the whole I'd trust the actual latency benchmark numbers more, 
> but I _think_ it does translate into actually feeling better too.

Ok, great - would you like to have this in v2.6.36 (in which case feel 
free to pull it now), or v2.6.37?

I'm hopeful that the other patches in the works will give more 
improvements - i dont actually like the relatively high noise that the 
max latencies produce - i think we should be more 
deterministic/dependable there. But those changes are also more complex, 
so they will take a bit more time to finish - and it's definitely 
v2.6.37 fodder.

Thanks,

	Ingo

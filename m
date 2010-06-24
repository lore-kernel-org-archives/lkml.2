Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab0FXLXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 07:23:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47244 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968Ab0FXLXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 07:23:50 -0400
Date: Thu, 24 Jun 2010 13:23:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       "H.PeterA" <"nvin hpa"@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] irq_work
Message-ID: <20100624112340.GA13502@elte.hu>
References: <1277363069.3947.30.camel@yhuang-dev.sh.intel.com>
 <1277363993.1875.847.camel@laptop>
 <1277364453.3947.64.camel@yhuang-dev.sh.intel.com>
 <1277364727.1875.857.camel@laptop>
 <20100624102725.GA578@basil.fritz.box>
 <1277375409.1875.943.camel@laptop>
 <20100624105254.GB578@basil.fritz.box>
 <1277377121.1875.948.camel@laptop>
 <20100624110830.GC578@basil.fritz.box>
 <1277377852.1875.950.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277377852.1875.950.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4442]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2010-06-24 at 13:08 +0200, Andi Kleen wrote:
> > > And I really want hardirq context for perf callbacks, some code actually
> > > relies on it (I used to have the fallback in the timer softirq and that
> > 
> > Surely that could be fixed?  *requiring* hard irq context sounds weird.
> 
> possibly, but there is no reason what so ever to use softirq here.
> 
> > > broke thing at some point).
> > 
> > I have one case that needs to sleep (but only when interrupting user code)
> > They key thing in it really is to switch stacks back to process.
> 
> softirq can't sleep either, you need a trampoline anyway.

What might make sense is to offer two types of callbacks: one that is 
immediate whenever an event triggers - and another that is sleepable and is 
executed from process context.

Having an intermediate softirq level might be over-design indeed.

Thanks,

	Ingo

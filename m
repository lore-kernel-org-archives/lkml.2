Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab1FWMvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 08:51:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35203 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758170Ab1FWMvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 08:51:20 -0400
Date: Thu, 23 Jun 2011 14:51:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] sched: Distangle worker accounting from rq->lock
Message-ID: <20110623125107.GB15430@elte.hu>
References: <20110622174659.496793734@linutronix.de>
 <20110622174919.135236139@linutronix.de>
 <20110623083722.GF30101@htj.dyndns.org>
 <alpine.LFD.2.02.1106231139270.11814@ionos>
 <20110623101541.GL30101@htj.dyndns.org>
 <20110623104455.GA9274@elte.hu>
 <BANLkTi=SxzG_fonb008KQzbZk16tuxm7NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=SxzG_fonb008KQzbZk16tuxm7NA@mail.gmail.com>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Ingo.
> 
> On Thu, Jun 23, 2011 at 12:44 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Tejun Heo <tj@kernel.org> wrote:
> >
> >> The patch description is simply untrue.  It does affect how wq
> >> behaves under heavy CPU load.  The effect might be perfectly okay
> >> but more likely it will result in subtle suboptimal behaviors under
> >> certain load situations which would be difficult to characterize
> >> and track down.  Again, the trade off (mostly killing of
> >> ttwu_local) could be okay but you can't get away with just claiming
> >> "there's no harm".
> >
> > Well, either it can be measured or not. If you can suggest a specific
> > testing method to Thomas, please do.
> 
> Crafting a test case where the suggested change results in worse 
> behavior isn't difficult (it ends up waking/creating workers which 
> it doesn't have to between ttwu and actual execution); however, as 
> with any micro benchmark, the problem is with assessing whether and 
> how much it would matter in actual workloads (whatever that means) 
> and workqueue is used throughout the kernel with widely varying 
> patterns making drawing conclusion a bit tricky. [...]

Well, please suggest a workload where it *matters* - as i suspect any 
workload tglx will come up with will have another 90% of workloads 
that you could suggest: so it's much better if you suggest a testing 
method.

When someone comes to me with a scheduler change i can give them the 
workloads that they should double check. See the changelog of this 
recent commit for example:

  c8b281161dfa: sched: Increase SCHED_LOAD_SCALE resolution

So please suggest a testing method.

> [...] Given that, changing the behavior for the worse just for this 
> cleanup doesn't sound like too sweet a deal.  Is there any other 
> reason to change the behavior (latency, whatever) other than the 
> ttuw_local ugliness?

Well, the ugliness is one aspect of it, but my main concern is simply 
testability: any claim of speedup or slowdown ought to be testable, 
right? I mean, we'd like to drive people towards coming with patches 
and number like Nikhil Rao did in c8b281161dfa, right?

Thanks,

	Ingo

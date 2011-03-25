Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab1CYTwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 15:52:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42394 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab1CYTwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 15:52:02 -0400
Date: Fri, 25 Mar 2011 20:51:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
Message-ID: <20110325195136.GA7346@elte.hu>
References: <20110323153727.GB12003@htj.dyndns.org>
 <20110324094119.GD12038@htj.dyndns.org>
 <20110324094151.GE12038@htj.dyndns.org>
 <20110325033956.GB9313@home.goodmis.org>
 <AANLkTimO3b3D+SofYFLyh8Txk+e4Ke4ToKrBiatdFghr@mail.gmail.com>
 <1301058727.14261.174.camel@gandalf.stny.rr.com>
 <AANLkTi=BaRFeAL1mS1Rjq_QGgcMb1rOKkvf=ig+23jvP@mail.gmail.com>
 <1301061918.14261.188.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301061918.14261.188.camel@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 2011-03-25 at 16:50 +0300, Andrey Kuzmin wrote:
> > On Fri, Mar 25, 2011 at 4:12 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > > On Fri, 2011-03-25 at 14:13 +0300, Andrey Kuzmin wrote:
> > >> Turning try_lock into indefinitely spinning one breaks its semantics,
> > >> so deadlock is to be expected. But what's wrong in this scenario if
> > >> try_lock spins a bit before giving up?
> > >
> > > Because that will cause this scenario to spin that "little longer"
> > > always, and introduce latencies that did not exist before. Either the
> > > solution does not break this scenario, or it should not go in.
> > 
> > Broken semantics and extra latency are two separate issues. If the
> > former is fixed, the latter is easily handled by introducing new
> > mutex_trylock_spin call that lets one either stick to existing
> > behavior (try/fail) or choose a new one where latency penalty is
> > justified by locking patterns.
> > 
> 
> For those wanting a more RT deterministic OS, I will argue against
> latency penalties.

Later mails from Tejun suggest that the benchmark results are varied, and that 
it's not a clear win after all.

It's possible that if useless spinning is introduced then that might explain 
such workload variations. I.e. it's not really 'latencies' but 'unnecessary 
overhead spent spinning' - and also 'extra non-deterministic noise' - none of 
which help consistent performance.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab1DILvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 07:51:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49851 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab1DILvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 07:51:16 -0400
Date: Sat, 9 Apr 2011 13:51:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFT/PATCH v2 2/6] x86-64: Optimize vread_tsc's barriers
Message-ID: <20110409115102.GA21137@elte.hu>
References: <cover.1302137785.git.luto@mit.edu>
 <80b43d57d15f7b141799a7634274ee3bfe5a5855.1302137785.git.luto@mit.edu>
 <BANLkTi=RkeFMpcb36RrJ=+eYm-xk4B2zYw@mail.gmail.com>
 <20110407164245.GA21838@one.firstfloor.org>
 <BANLkTikdn+Y2pWoLH_=Q4xHTgT6XGfOuSg@mail.gmail.com>
 <20110407181523.GC21838@one.firstfloor.org>
 <BANLkTikhG9deEo0VvrUSXzn850GjBvYtiw@mail.gmail.com>
 <BANLkTi=kh+3HTsr4xGQY88T-qwbeCx5JVw@mail.gmail.com>
 <BANLkTimjiwxC8ryiLpmd=jCjBD62ZZ0G5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimjiwxC8ryiLpmd=jCjBD62ZZ0G5A@mail.gmail.com>
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


* Andrew Lutomirski <luto@mit.edu> wrote:

> > * Modulo errata, BIOS bugs, implementation bugs, etc.
> 
> As far as I can tell, on Sandy Bridge and Bloomfield, I can't get the 
> sequence lfence;rdtsc to violate the rule above.  That the case even if I 
> stick random arithmetic and branches right before the lfence.  If I remove 
> the lfence, though, it starts to fail.  (This is without the evil fake 
> barrier.)

It's not really evil, just too tricky and hence very vulnerable to entropy ;-)

> However, as expected, I can see stores getting reordered after lfence;rdtsc 
> and rdtscp but not mfence;rdtsc.

Is this lfence;rdtsc variant enough for your real usecase as well?

Basically, we are free to define whatever sensible semantics we find reasonable 
and fast - we are pretty free due to the fact that the whole TSC picture was 
such a mess for a decade or so, so apps did not make assumptions (because we 
could not make guarantees).

> So... do you think that the rule is sensible?

The barrier properties of this system call are flexible in the same sense so 
your proposal is sensible to me. I'd go for the weakest barrier that still 
works fine, that is the one that is the fastest and it also gives us the most 
options for the future.

> I'll post the test case somewhere when it's a little less ugly.  I'd like to 
> see test results on AMD.

That would be nice - we could test it on various Intel and AMD CPUs.

Thanks,

	Ingo

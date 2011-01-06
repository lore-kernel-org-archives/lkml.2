Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1AFXzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:55:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60395 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280Ab1AFXz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:55:27 -0500
Date: Fri, 7 Jan 2011 00:54:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU changes for v2.6.38
Message-ID: <20110106235457.GB15940@elte.hu>
References: <20110106090808.GA15170@elte.hu>
 <AANLkTikocAcVEAHXi3g7z2s+4y3mh5m0bs17iJnUWPhz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikocAcVEAHXi3g7z2s+4y3mh5m0bs17iJnUWPhz@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Jan 6, 2011 at 1:08 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Please pull the latest core-rcu-for-linus git tree from:
> 
> So I pulled, but I'm not convinced about the crazy busy-looping
> SRCU_SYNCHRONIZE_DELAY thing.
> 
> Why does it do a silly udelay(), instead of just looping over the
> srcu_readers_active_idx() for a few times? You're wasting CPU time
> anyway, why ask the user how many usecs to waste?
> 
> IOW, why isn't that "wait for no active readers" a nice helper
> function, and why doesn't it do
> 
>    for (i = 0; i < CONFIG_SRCU_SYNCHRONIZE_DELAY; i++) {
>       if (!srcu_readers_active_idx(sp, idx))
>          return;
>       udelay(1);
>    }
>    while (srcu_readers_active_idx(sp, idx))
>       schedule_timeout_interruptible(1);
> 
> instead? And is it really sane to ask the kernel configurator to come
> up with a random value (ie that "CONFIG_SRCU_SYNCHRONIZE_DELAY" is
> just stupid and wrong)?
> 
> Please fix this. And don't make people answer unanswerable questions.
> If YOU and Paul don't know the answer, why the hell do you expect
> somebody who does a "make config" to know the answer?
> 
> Either pick a number, or pick an algorithm that self-tunes.
> 
> Don't use the Kconfig system as a way to tell people that it's their
> fault when you made a bad decision. Really.

Fully agreed - we'll fix this.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab1AGIcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 03:32:45 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59874 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab1AGIco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 03:32:44 -0500
Date: Fri, 7 Jan 2011 00:32:41 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU changes for v2.6.38
Message-ID: <20110107083240.GN2506@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110106090808.GA15170@elte.hu>
 <AANLkTikocAcVEAHXi3g7z2s+4y3mh5m0bs17iJnUWPhz@mail.gmail.com>
 <20110106235457.GB15940@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106235457.GB15940@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 12:54:57AM +0100, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Thu, Jan 6, 2011 at 1:08 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > Please pull the latest core-rcu-for-linus git tree from:
> > 
> > So I pulled, but I'm not convinced about the crazy busy-looping
> > SRCU_SYNCHRONIZE_DELAY thing.
> > 
> > Why does it do a silly udelay(), instead of just looping over the
> > srcu_readers_active_idx() for a few times? You're wasting CPU time
> > anyway, why ask the user how many usecs to waste?
> > 
> > IOW, why isn't that "wait for no active readers" a nice helper
> > function, and why doesn't it do
> > 
> >    for (i = 0; i < CONFIG_SRCU_SYNCHRONIZE_DELAY; i++) {
> >       if (!srcu_readers_active_idx(sp, idx))
> >          return;
> >       udelay(1);
> >    }
> >    while (srcu_readers_active_idx(sp, idx))
> >       schedule_timeout_interruptible(1);
> > 
> > instead? And is it really sane to ask the kernel configurator to come
> > up with a random value (ie that "CONFIG_SRCU_SYNCHRONIZE_DELAY" is
> > just stupid and wrong)?
> > 
> > Please fix this. And don't make people answer unanswerable questions.
> > If YOU and Paul don't know the answer, why the hell do you expect
> > somebody who does a "make config" to know the answer?
> > 
> > Either pick a number, or pick an algorithm that self-tunes.
> > 
> > Don't use the Kconfig system as a way to tell people that it's their
> > fault when you made a bad decision. Really.
> 
> Fully agreed - we'll fix this.

I am on it!

							Thanx, Paul

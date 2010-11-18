Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab0KRINF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:13:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45217 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab0KRIND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:13:03 -0500
Date: Thu, 18 Nov 2010 09:12:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Marcus Meissner <meissner@suse.de>, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/time: Make /proc/timer_list mode 0400
Message-ID: <20101118081241.GA23481@elte.hu>
References: <20101117170822.GW20727@suse.de>
 <1290014312.2109.1065.camel@laptop>
 <20101117123039.d975aa70.akpm@linux-foundation.org>
 <alpine.LFD.2.00.1011172137040.2900@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011172137040.2900@localhost6.localdomain6>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 17 Nov 2010, Andrew Morton wrote:
> 
> > On Wed, 17 Nov 2010 18:18:32 +0100
> > Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > On Wed, 2010-11-17 at 18:08 +0100, Marcus Meissner wrote:
> > > > Hi,
> > > > 
> > > > /proc/timer_list contains kernel addresses, like e.g.:
> > > >  #0: <c000000001404158>, tick_sched_timer, S:01, .tick_nohz_restart_sched_tick, swapper/0
> > > >  ...
> > > > 
> > > > Avoid leaking them to user space to make writing kernel exploits a bit harder.
> > > > 
> > > > (I currently cannot think of a userland tool that uses this, this is
> > > > likely pretty much root-only.)
> > > 
> > > iirc powertop parses this..
> > 
> > I bet it doesn't look at the kernel address (why was that added in the
> > first place, anyway?)
> > 
> > I'd suggest that the risk of breakage would be much less if we left the
> > file permissions alone and arranged for those addresses to be
> > 0000000000000000 for non-root readers.
> 
> You beat me to it. Having the full information is quite helpful at
> times.

We should do something like:

	if (!capable(CAP_SYS_ADMIN))
		print_ptr = NULL;

	sprintf(s, "%p", print_ptr);

Thanks,

	Ingo

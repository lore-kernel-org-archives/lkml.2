Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab0GIHM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 03:12:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48086 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab0GIHM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 03:12:26 -0400
Date: Fri, 9 Jul 2010 09:11:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Shawn Starr <shawn.starr@rogers.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dave Airlie <airlied@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Patrick McHardy <kaber@trash.net>, Jens Axboe <axboe@kernel.dk>
Subject: Re: 2.6.35-rc4-git3: Reported regressions from 2.6.34
Message-ID: <20100709071131.GB10743@elte.hu>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
 <AANLkTiknnzWyVpqnPCpyiEVHLgkewd0zaGzLInABRe2G@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTiknnzWyVpqnPCpyiEVHLgkewd0zaGzLInABRe2G@mail.gmail.com>
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

> > Bug-Entry ? ? ? : http://bugzilla.kernel.org/show_bug.cgi?id=16346
> > Subject ? ? ? ? : 2.6.35-rc3-git8 - include/linux/fdtable.h:88 invoked rcu_dereference_check() without protection!
> > Submitter ? ? ? : Miles Lane <miles.lane@gmail.com>
> > Date ? ? ? ? ? ?: 2010-07-04 22:04 (5 days old)
> > Message-ID ? ? ?: <AANLkTinof0k28rk4rMr66aubxcRL2rFa5ZEArj1lqD3o@mail.gmail.com>
> > References ? ? ?: http://marc.info/?l=linux-kernel&m=127828107815930&w=2
> 
> I'm not entirely sure if these RCU proving things should count as 
> regressions.

Generally not - and we've delayed at least one more complex (cgroups) fix to 
v2.6.36 because the patch itself was riskier than the warning.

Still most of the warning fixes turned out to be simple, so we merged the 
very-low-risk ones and right now we seem to be on top of them.

But in general the default rule is that we delay these fixes to v2.6.36.

> Sure, the option to enable RCU proving is new, but the things it reports 
> about generally are not new - and they are usually not even bugs in the 
> sense that they necessarily cause any real problems.
> 
> That particular one is in the single-thread optimizated case for fget_light, ie
> 
>         if (likely((atomic_read(&files->count) == 1))) {
>                 file = fcheck_files(files, fd);
> 
> where I think it should be entirely safe in all ways without any locking. So 
> I think it's a false positive too.

Yeah, it's a bit like with lockdep (and it's a bit like with compiler warning 
fixes): we had to punch through a large stack of false positives that 
accumulated in the past 10 years.

( Because real bugs eventually get fixed, while false positives always just
  accumulate. So almost by definition we always start with a very assymetric
  collection of warnings and a large stack of false positives. )

Having said that, it appears we got most of the false positives and are 
beginning to be in a more representative equilibrium now. If v2.6.35 isnt 
going to be warning-free then v2.6.36 certainly will be and new warnings will 
have a much higher likelyhood of being real (and new) bugs (not just 
accumulated false-positives).

	Ingo

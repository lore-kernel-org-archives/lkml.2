Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab0EFGkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:40:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34938 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab0EFGkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:40:20 -0400
Date: Thu, 6 May 2010 08:39:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [GIT PULL] Additional RCU fixes for 2.6.34
Message-ID: <20100506063948.GG1172@elte.hu>
References: <20100506002838.GA31818@linux.vnet.ibm.com>
 <20100506062250.GC1172@elte.hu>
 <20100506062552.GN27497@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506062552.GN27497@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, May 06 2010, Ingo Molnar wrote:
> > 
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > Hello, Ingo,
> > > 
> > > Here are three more RCU-lockdep fixes for 2.6.34:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent
> > > 
> > > 							Thanx, Paul
> > > 
> > > ------------------>
> > > Vivek Goyal <vgoyal@redhat.com> (1)
> > > 	blk-cgroup: Fix RCU correctness warning in cfq_init_queue()
> > > 
> > > Paul E. McKenney <paulmck@linux.vnet.ibm.com> (2)
> > > 	vfs: fix RCU-lockdep false positive due to /proc access
> > > 	memcg: css_id() must be called under rcu_read_lock()
> > > 
> > >  block/cfq-iosched.c      |    2 ++
> > >  include/linux/fdtable.h  |    3 ++-
> > >  include/linux/rcupdate.h |   11 +++++++++++
> > >  kernel/rcupdate.c        |   11 +++++++++++
> > >  mm/memcontrol.c          |   21 ++++++++++++++++-----
> > >  5 files changed, 42 insertions(+), 6 deletions(-)
> > 
> > Pulled, thanks Paul!
> > 
> > Jens, is that blk-cgroup fix from Vivek fine to you via this route?
> 
> Sure, I did think it was a bit odd to funnel it through that route, but it's 
> no big deal.

I havent pushed the tree out yet, wanted to wait for your feedback before 
doing anything permanent. You can still apply it to the block tree.

You were Cc:-ed 3 days ago to this patch, when RCU fixes got posted. These are 
basically the leftover PROVE_RCU fix patches that didnt get picked up by 
subsystem trees.

Thanks,

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab0EFGyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:54:12 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58299 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab0EFGyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:54:11 -0400
Date: Thu, 6 May 2010 08:54:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [GIT PULL] Additional RCU fixes for 2.6.34
Message-ID: <20100506065409.GQ27497@kernel.dk>
References: <20100506002838.GA31818@linux.vnet.ibm.com> <20100506062250.GC1172@elte.hu> <20100506062552.GN27497@kernel.dk> <20100506063948.GG1172@elte.hu> <20100506064336.GP27497@kernel.dk> <20100506064959.GJ1172@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506064959.GJ1172@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06 2010, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Thu, May 06 2010, Ingo Molnar wrote:
> > > 
> > > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > > On Thu, May 06 2010, Ingo Molnar wrote:
> > > > > 
> > > > > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > > > 
> > > > > > Hello, Ingo,
> > > > > > 
> > > > > > Here are three more RCU-lockdep fixes for 2.6.34:
> > > > > > 
> > > > > > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent
> > > > > > 
> > > > > > 							Thanx, Paul
> > > > > > 
> > > > > > ------------------>
> > > > > > Vivek Goyal <vgoyal@redhat.com> (1)
> > > > > > 	blk-cgroup: Fix RCU correctness warning in cfq_init_queue()
> > > > > > 
> > > > > > Paul E. McKenney <paulmck@linux.vnet.ibm.com> (2)
> > > > > > 	vfs: fix RCU-lockdep false positive due to /proc access
> > > > > > 	memcg: css_id() must be called under rcu_read_lock()
> > > > > > 
> > > > > >  block/cfq-iosched.c      |    2 ++
> > > > > >  include/linux/fdtable.h  |    3 ++-
> > > > > >  include/linux/rcupdate.h |   11 +++++++++++
> > > > > >  kernel/rcupdate.c        |   11 +++++++++++
> > > > > >  mm/memcontrol.c          |   21 ++++++++++++++++-----
> > > > > >  5 files changed, 42 insertions(+), 6 deletions(-)
> > > > > 
> > > > > Pulled, thanks Paul!
> > > > > 
> > > > > Jens, is that blk-cgroup fix from Vivek fine to you via this route?
> > > > 
> > > > Sure, I did think it was a bit odd to funnel it through that route, but it's 
> > > > no big deal.
> > > 
> > > I havent pushed the tree out yet, wanted to wait for your feedback before 
> > > doing anything permanent. You can still apply it to the block tree.
> > > 
> > > You were Cc:-ed 3 days ago to this patch, when RCU fixes got posted. These are 
> > > basically the leftover PROVE_RCU fix patches that didnt get picked up by 
> > > subsystem trees.
> > 
> > Yes I read it then, and Paul said he'd applied it. So I didn't touch it, it 
> > was trivial enough that the path to the kernel wasn't that big of a problem. 
> > And it didn't cause me any merge issues, so no harm done.
> > 
> > I can easily pull it in since I have a fix or two for .34 left yet, but if 
> > you already have it stashed and ready to submit, lets just leave it there.
> 
> Yeah, please apply it to the block tree (i have just zapped it from my local 
> tree), we really want subsystem patches to go via their respective trees. I've 
> attached the latest patch below.
> 
> Thanks!

Done!

-- 
Jens Axboe


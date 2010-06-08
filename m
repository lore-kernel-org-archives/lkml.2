Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab0FHSH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 14:07:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33907 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab0FHSH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 14:07:27 -0400
Date: Tue, 8 Jun 2010 20:07:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, viro@zeniv.linux.org.uk,
       kosaki.motohiro@jp.fujitsu.com, benh@kernel.crashing.org,
       paulus@samba.org, sparse@chrisli.org
Subject: Re: [GIT PULL] rcu: finalize debugobjects, first round of RCU sparse
 pointer checks
Message-ID: <20100608180701.GJ11585@elte.hu>
References: <20100601165034.GA9522@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601165034.GA9522@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> Here are the final commits from Mathieu's debugobjects series and the
> first few from Arnd's RCU-pointer sparse series.  The first three remove
> RCU's (useless) initializations from mm, fs, and powerpc:
> 
> mm:	http://lkml.org/lkml/2010/5/18/562
> fs:	http://lkml.org/lkml/2010/5/18/500
> powerpc:http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg43510.html
> 
> Kosaki Motohiro agreed that the mm patch should go up -tip, and none of
> the other maintainers objected to the prospect of their patches going
> up -tip.
> 
> The fourth patch removes RCU's initialization definitions, and the final
> four patches provide the beginnings of Arnd's RCU-pointer sparse checks.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next
> 
> Or, if you prefer this against 2.6.34-rc7 without a merge record:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next-rc7
> 
> If you would rather me rebase this stack against 2.6.35-rc1, let me know!

I pulled the rcu/next-rc7 variant, thanks Paul!

New features are best done against stable kernels - i.e. v2.6.34. -rc7 was 
pretty stable too so it was fine to pull. .35-rc1 OTOH is something definitely 
more regression-prone than .34-rc7.

Except, of course, when we want to change code that is only in .35-rc1 - in 
that case merging to .35-rc1 (or later -rc's) is perfectly fine.

> Either way, once these commits reach mainline, I will submit the next 21
> commits to their respective trees.  The maintainers have been CCed on the
> earlier LKML patchsets (http://lkml.org/lkml/2010/5/12/372).  Once these
> 21 commits hit mainline, I will send you a pull request for the remaining
> two commits.
> 
> Then on to CONFIG_TINY_PREEMPT_RCU.
> 
> 							Thanx, Paul
> 
> ------------------>
>  Mathieu Desnoyers (2)
> 	 rcu head remove init
> 	 tree/tiny rcu: Add debug RCU head objects
> 
>  Paul E. McKenney (6)
> 	 powerpc: remove all rcu head initializations
> 	 fs: remove all rcu head initializations, except on_stack initializations
> 	 mm: remove all rcu head initializations
> 	 rcu: add an rcu_dereference_index_check()
> 	 rcu: add __rcu API for later sparse checking
> 	 lockdep: Add an in_workqueue_context() lockdep-based test function
> 
> 
>  arch/powerpc/mm/pgtable.c |    1 
>  fs/file.c                 |    3 
>  fs/fs-writeback.c         |   31 +++++++-
>  fs/partitions/check.c     |    1 
>  include/linux/compiler.h  |    2 
>  include/linux/rcupdate.h  |   88 ++++++++++++++++++++++-
>  include/linux/workqueue.h |    4 +
>  kernel/rcupdate.c         |  170 ++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/rcutiny.c          |    2 
>  kernel/rcutree.c          |    2 
>  kernel/workqueue.c        |   15 ++++
>  lib/Kconfig.debug         |    6 +
>  mm/backing-dev.c          |    1 
>  mm/slob.c                 |    1 
>  14 files changed, 309 insertions(+), 18 deletions(-)

Thanks Paul!

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746Ab0FBKer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 06:34:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42902 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab0FBKeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 06:34:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org
Subject: Re: [GIT PULL] rcu: finalize debugobjects, first round of RCU sparse pointer checks
Cc: kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, viro@zeniv.linux.org.uk, benh@kernel.crashing.org,
       paulus@samba.org, sparse@chrisli.org
In-Reply-To: <20100601165034.GA9522@linux.vnet.ibm.com>
References: <20100601165034.GA9522@linux.vnet.ibm.com>
Message-Id: <20100602192749.F512.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  2 Jun 2010 19:34:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Andrew, can we hear your opinion? I think this patch series have some
dependencies, then -tip is best place. If any code confliction occur,
I promise I'll solve it soon.

I think this rcu improvement makes developer happy.


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
> 
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




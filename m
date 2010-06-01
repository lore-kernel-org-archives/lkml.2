Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab0FAQuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 12:50:40 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46820 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915Ab0FAQui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 12:50:38 -0400
Date: Tue, 1 Jun 2010 09:50:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, viro@zeniv.linux.org.uk,
       kosaki.motohiro@jp.fujitsu.com, benh@kernel.crashing.org,
       paulus@samba.org, sparse@chrisli.org
Subject: [GIT PULL] rcu: finalize debugobjects, first round of RCU sparse
 pointer checks
Message-ID: <20100601165034.GA9522@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

Here are the final commits from Mathieu's debugobjects series and the
first few from Arnd's RCU-pointer sparse series.  The first three remove
RCU's (useless) initializations from mm, fs, and powerpc:

mm:	http://lkml.org/lkml/2010/5/18/562
fs:	http://lkml.org/lkml/2010/5/18/500
powerpc:http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg43510.html

Kosaki Motohiro agreed that the mm patch should go up -tip, and none of
the other maintainers objected to the prospect of their patches going
up -tip.

The fourth patch removes RCU's initialization definitions, and the final
four patches provide the beginnings of Arnd's RCU-pointer sparse checks.

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next

Or, if you prefer this against 2.6.34-rc7 without a merge record:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next-rc7

If you would rather me rebase this stack against 2.6.35-rc1, let me know!

Either way, once these commits reach mainline, I will submit the next 21
commits to their respective trees.  The maintainers have been CCed on the
earlier LKML patchsets (http://lkml.org/lkml/2010/5/12/372).  Once these
21 commits hit mainline, I will send you a pull request for the remaining
two commits.

Then on to CONFIG_TINY_PREEMPT_RCU.

							Thanx, Paul

------------------>
 Mathieu Desnoyers (2)
	 rcu head remove init
	 tree/tiny rcu: Add debug RCU head objects

 Paul E. McKenney (6)
	 powerpc: remove all rcu head initializations
	 fs: remove all rcu head initializations, except on_stack initializations
	 mm: remove all rcu head initializations
	 rcu: add an rcu_dereference_index_check()
	 rcu: add __rcu API for later sparse checking
	 lockdep: Add an in_workqueue_context() lockdep-based test function


 arch/powerpc/mm/pgtable.c |    1 
 fs/file.c                 |    3 
 fs/fs-writeback.c         |   31 +++++++-
 fs/partitions/check.c     |    1 
 include/linux/compiler.h  |    2 
 include/linux/rcupdate.h  |   88 ++++++++++++++++++++++-
 include/linux/workqueue.h |    4 +
 kernel/rcupdate.c         |  170 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/rcutiny.c          |    2 
 kernel/rcutree.c          |    2 
 kernel/workqueue.c        |   15 ++++
 lib/Kconfig.debug         |    6 +
 mm/backing-dev.c          |    1 
 mm/slob.c                 |    1 
 14 files changed, 309 insertions(+), 18 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630Ab0EMXG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 19:06:58 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33424 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756003Ab0EMXG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 19:06:56 -0400
Date: Thu, 13 May 2010 16:06:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: [GIT PULL] rcu: infrastructure for debugobjects checking
Message-ID: <20100513230651.GA24426@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

Here are the first three commits from Mathieu's debugobjects series
(http://lwn.net/Articles/387344/).  The first two provide the debugobjects
infrastructure and the RCU APIs, and the third applies these APIs to
the RCU implementation itself.

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next

Once these three reach mainline, I will submit the next six commits
to their respective trees (powerpc, block, staging, fs, mm, and selinux).
The maintainers have been CCed on the the earlier LKML patchsets.
Once these six commits reach mainline, I will send you a pull request
for the remaining two commits.

Then on to Arnd's "sparse" checks, which are still being refined.

							Thanx, Paul

------------------>
 Mathieu Desnoyers (2)
	 Debugobjects transition check
	 rcu head introduce rcu head init on stack

 Paul E. McKenney (1)
	 rcu: remove all rcu head initializations, except on_stack initializations

 include/linux/debugobjects.h |   11 ++++++++
 include/linux/init_task.h    |    1 -
 include/linux/rcupdate.h     |    8 +++++
 kernel/rcutiny.c             |    6 ++++
 kernel/rcutorture.c          |    2 +
 kernel/rcutree.c             |    4 +++
 kernel/rcutree_plugin.h      |    2 +
 lib/debugobjects.c           |   59 +++++++++++++++++++++++++++++++++++++++--
 8 files changed, 89 insertions(+), 4 deletions(-)

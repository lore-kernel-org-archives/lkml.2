Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab1GMPrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:47:00 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34520 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813Ab1GMPq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:46:58 -0400
Date: Wed, 13 Jul 2011 08:46:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, kernelmail.jms@gmail.com,
        kulkarni.ravi4@gmail.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: [GIT PULL rcu/urgent] Prevent RCU callbacks from executing during
 early boot
Message-ID: <20110713154638.GA5136@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This pull request is an update from https://lkml.org/lkml/2011/7/11/248.
It fixes a rare but real boot-time hang that is caused by RCU callbacks
being registered during early boot whose callback functions depend on
the scheduler being fully initialized.  This commit therefore defers
callback invocation until after the scheduler has spawned the first task.
In contrast, the earlier patch deferred only until the scheduler was
ready to spawn the first task, in particular, before the init task had
first entered schedule().  The former pull request fixed Ravi's hang,
but not Julie's.  This pull request addresses both hangs.

There was another hang from Konrad, but this hang turned out to be
unrelated.  Konrad's hang has been solved:  It was fixed by a patch from
Peter (https://lkml.org/lkml/2011/7/12/150).

I have Tested-by responses from all three (Julie, Ravi, and Konrad).

This commit is available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent

I believe that this commit (and Peter's patch, for that matter) should
be included in v3.0.

							Thanx, Paul

------------------->
Paul E. McKenney (1):
      rcu: Prevent RCU callbacks from executing before scheduler initialized

 kernel/rcutree.c        |   26 +++++++++++++++++++++++++-
 kernel/rcutree_plugin.h |   15 +++++++++++----
 2 files changed, 36 insertions(+), 5 deletions(-)

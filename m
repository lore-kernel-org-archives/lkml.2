Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab1FQAA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 20:00:27 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33168 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757372Ab1FQAAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 20:00:25 -0400
Date: Thu, 16 Jun 2011 17:00:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: [PATCH rcu/urgent] Banishing kthreads
Message-ID: <20110617000019.GA15881@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset banishes RCU kthreads from non-RCU_BOOST kernel threads.
The two patches are as follows:

1.	Minimal patch that #ifdefs out the kthread code.

2.	Code-movement patch that puts the code #ifdefed out above
	under existing #ifdefs in kernel/rcutree_plugin.h.

For a testing-only version of this patchset from git, please see the
following subject-to-rebase branch:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent

								Thanx, Paul

------------------------------------------------------------------------

 b/kernel/rcutree.c        |   59 +++++--
 b/kernel/rcutree.h        |    8 
 b/kernel/rcutree_plugin.h |   41 +++-
 b/kernel/rcutree_trace.c  |   32 ++-
 kernel/rcutree.c          |  383 ---------------------------------------------
 kernel/rcutree.h          |    5 
 kernel/rcutree_plugin.h   |  384 ++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 489 insertions(+), 423 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0LWL53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 06:57:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55039 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab0LWL51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 06:57:27 -0500
Date: Thu, 23 Dec 2010 12:57:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, tj@kernel.org,
        fweisbec@gmail.com, mk@lab.zgora.pl
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.38
Message-ID: <20101223115711.GB1471@elte.hu>
References: <20101223053736.GA17521@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101223053736.GA17521@linux.vnet.ibm.com>
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
> This pull request covers RCU changes for 2.6.38.  These include RCU
> priority boosting for TINY_RCU and TINY_PREEMPT_RCU, some cleanups from
> Lai Jiangshan, fixes to synchronize_sched_expedited() including some
> from Tejun Heo, some nohz fixes from Frederic Weisbecker, some changes
> to reduce lock contention for internal-to-RCU locks, and a fix from
> Mariusz Kozlowski to fix unbalanced parentheses.
> 
> These changes are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next
> 
> ------------------>
> Frederic Weisbecker (2):
>       rcu: Stop chasing QS if another CPU did it for us
>       rcu: Keep gpnum and completed fields synchronized
> 
> Lai Jiangshan (2):
>       rcu,cleanup: move synchronize_sched_expedited() out of sched.c
>       rcu,cleanup: simplify the code when cpu is dying
> 
> Mariusz Kozlowski (1):
>       rculist: fix borked __list_for_each_rcu() macro
> 
> Paul E. McKenney (14):
>       rcu: add priority-inversion testing to rcutorture
>       rcu: move TINY_RCU from softirq to kthread
>       rcu: priority boosting for TINY_PREEMPT_RCU
>       rcu: add tracing for TINY_RCU and TINY_PREEMPT_RCU
>       rcu: document TINY_RCU and TINY_PREEMPT_RCU tracing.
>       rcu: Distinguish between boosting and boosted
>       rcu: get rid of obsolete "classic" names in TREE_RCU tracing
>       rcu: update documentation/comments for Lai's adoption patch
>       rcu: fix race condition in synchronize_sched_expedited()
>       rcu: Make synchronize_srcu_expedited() fast if running readers
>       rcu: fine-tune grace-period begin/end checks
>       rcu: limit rcu_node leaf-level fanout
>       rcu: reduce __call_rcu()-induced contention on rcu_node structures
>       rcu: remove unused __list_for_each_rcu() macro
> 
> Tejun Heo (1):
>       rcu: increase synchronize_sched_expedited() batching
> 
>  Documentation/RCU/trace.txt |  144 +++++++++++++--
>  include/linux/init_task.h   |    9 +-
>  include/linux/rculist.h     |    5 -
>  include/linux/rcupdate.h    |    4 +-
>  include/linux/rcutiny.h     |   13 +-
>  include/linux/rcutree.h     |    2 +
>  include/linux/sched.h       |   11 +-
>  init/Kconfig                |   55 ++++++-
>  kernel/rcutiny.c            |  105 +++++++----
>  kernel/rcutiny_plugin.h     |  433 +++++++++++++++++++++++++++++++++++++++++--
>  kernel/rcutorture.c         |  270 ++++++++++++++++++++++++++-
>  kernel/rcutree.c            |  156 ++++++++--------
>  kernel/rcutree.h            |   61 +++----
>  kernel/rcutree_plugin.h     |  135 +++++++++++++-
>  kernel/rcutree_trace.c      |   12 +-
>  kernel/sched.c              |   69 -------
>  kernel/srcu.c               |    8 +-
>  17 files changed, 1207 insertions(+), 285 deletions(-)

Pulled, thanks a lot Paul!

	Ingo

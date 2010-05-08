Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab0EHLPj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 07:15:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55493 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab0EHLPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 07:15:38 -0400
Date: Sat, 8 May 2010 13:15:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: [GIT PULL sched/core] cpu_stop: implement and use cpu_stop,
 take#3
Message-ID: <20100508111529.GA19796@elte.hu>
References: <1273164772-19149-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273164772-19149-1-git-send-email-tj@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Ingo.
> 
> Please pull from the following branch to receive cpu_stop patches.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cpu_stop
> 
> Adding mb()'s in synchronize_sched_expedited() is the only change
> since the last take[2].  Both Peter and Paul have acked the patchset.
> I'll post the patchset as replies to this message.
> 
> This patchset is on top of the current sched/core (99bd5e2f) and
> contains the following changes.
> 
> Paul E. McKenney (1):
>       scheduler: correctly place paranioa memory barriers in synchronize_sched_expedited()
> 
> Tejun Heo (4):
>       cpu_stop: implement stop_cpu[s]()
>       stop_machine: reimplement using cpu_stop
>       scheduler: replace migration_thread with cpu_stop
>       scheduler: kill paranoia check in synchronize_sched_expedited()
> 
>  Documentation/RCU/torture.txt |   10 -
>  arch/s390/kernel/time.c       |    1 -
>  drivers/xen/manage.c          |   14 +-
>  include/linux/rcutiny.h       |    2 -
>  include/linux/rcutree.h       |    1 -
>  include/linux/stop_machine.h  |   59 +++--
>  kernel/cpu.c                  |    8 -
>  kernel/module.c               |   14 +-
>  kernel/rcutorture.c           |    2 +-
>  kernel/sched.c                |  284 +++++-----------------
>  kernel/sched_fair.c           |   48 +++-
>  kernel/stop_machine.c         |  530 +++++++++++++++++++++++++++++++----------
>  12 files changed, 538 insertions(+), 435 deletions(-)

FYI, it doesnt build on x86 allnoconfig:

kernel/sched_fair.c: In function 'load_balance':
kernel/sched_fair.c:2917: error: implicit declaration of function 'stop_one_cpu_nowait'
kernel/sched.c: In function 'sched_exec':
kernel/sched.c:3084: error: implicit declaration of function 'stop_one_cpu'
kernel/sched.c: In function 'synchronize_sched_expedited':

	Ingo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab1A2ALX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 19:11:23 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:18285
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753258Ab1A2ALW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 19:11:22 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK1432N98dNzz1202hzzz2fh2a8h637h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D435B10.3050207@am.sony.com>
Date: Fri, 28 Jan 2011 16:10:56 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 05/18] sched: Provide p->on_rq
References: <20110104145929.772813816@chello.nl> <20110104150102.562967001@chello.nl>
In-Reply-To: <20110104150102.562967001@chello.nl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/11 06:59, Peter Zijlstra wrote:
Provide a generic p->on_rq because the p->se.on_rq semantics are
> unfavourable for lockless wakeups but needed for sched_fair.
>
> In particular, p->on_rq is only cleared when we actually dequeue the
> task in schedule() and not on any random dequeue as done by things
> like __migrate_task() and __sched_setscheduler().
>
> This also allows us to remove p->se usage from !sched_fair code.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/sched.h   |    1 +
>  kernel/sched.c          |   36 ++++++++++++++++++------------------
>  kernel/sched_debug.c    |    2 +-
>  kernel/sched_rt.c       |   10 +++++-----
>  kernel/sched_stoptask.c |    2 +-
>  5 files changed, 26 insertions(+), 25 deletions(-)

> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c


> @@ -2571,18 +2570,20 @@ int wake_up_state(struct task_struct *p,
>   */
>  static void __sched_fork(struct task_struct *p)
>  {
> +     p->on_rq                                = 0;

Nitpick: column alignment of "= 0" ^^^^.


> +
> +     p->se.on_rq                     = 0;
>       p->se.exec_start                = 0;
>       p->se.sum_exec_runtime          = 0;
>       p->se.prev_sum_exec_runtime     = 0;
>       p->se.nr_migrations             = 0;
> +     INIT_LIST_HEAD(&p->se.group_node);
>
>  #ifdef CONFIG_SCHEDSTATS
>       memset(&p->se.statistics, 0, sizeof(p->se.statistics));
>  #endif
>
>       INIT_LIST_HEAD(&p->rt.run_list);
> -     p->se.on_rq = 0;
> -     INIT_LIST_HEAD(&p->se.group_node);
>
>  #ifdef CONFIG_PREEMPT_NOTIFIERS
>       INIT_HLIST_HEAD(&p->preempt_notifiers);
>


-Frank


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab1LEQV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 11:21:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:33503 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447Ab1LEQV0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 11:21:26 -0500
Message-ID: <1323102051.32012.28.camel@twins>
Subject: Re: [PATCH] Do not include throttled time as steal time
From: Peter Zijlstra <peterz@infradead.org>
To: Mike wolf <mjw@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck <paulmck@linux.vnet.ibm.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>
Date: Mon, 05 Dec 2011 17:20:51 +0100
In-Reply-To: <4EDCDE54.3030300@linux.vnet.ibm.com>
References: <4EDCDE54.3030300@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 09:08 -0600, Mike wolf wrote:

Hi Mike, couple of problems with this:

1) You failed to CC the appropriate maintainers for the piece of code
you're trying to have changed. When in doubt see the MAINTAINERS
file ;-)

2) You failed to CC the people who wrote the feature you're having a
problem with.

> When the linux kernel is running as the guest OS and is configured
> for bandwidth control and steal time reporting, it can be confusing
> to users to see the throttled time show up in the steal time stats.
> The user will think they are not getting the cpu resources they have
> been configured.

Supposedly this is a BAD (tm) thing :-)

> Signed-off-by: Mike Wolf <mjw@linux.vnet.ibm.com>
> ---
>   kernel/sched_fair.c  |    4 ++--
>   kernel/sched_stats.h |    7 ++++++-
>   2 files changed, 8 insertions(+), 3 deletions(-)

3) You blink you loose, those files don't exist anymore. Patches are
best provided against the development tree of the particular subsystem
you're working against.

In this particular case tip/master is your target.

>   static inline void sched_info_depart(struct task_struct *t)
>   {
> +    struct task_group *tg = task_group(t);
> +    struct cfs_rq *cfs_rq;
>       unsigned long long delta = task_rq(t)->clock -
>                       t->sched_info.last_arrival;
> 
> +    cfs_rq = tg->cfs_rq[smp_processor_id()];
>       rq_sched_info_depart(task_rq(t), delta);
> 
> -    if (t->state == TASK_RUNNING)
> +
> +    if (t->state == TASK_RUNNING && !throttled_hierarchy(cfs_rq))
>           sched_info_queued(t);
>   }

4) so there's a lot more steal time crap all over the scheduler, you
failed to explain why only this particular bit is important enough to
change.




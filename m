Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab2JDGSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 02:18:37 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52472 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab2JDGSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 02:18:35 -0400
MIME-Version: 1.0
In-Reply-To: <1348252345-5642-4-git-send-email-morten.rasmussen@arm.com>
References: <1348252345-5642-1-git-send-email-morten.rasmussen@arm.com>
	<1348252345-5642-4-git-send-email-morten.rasmussen@arm.com>
Date: Thu, 4 Oct 2012 11:48:35 +0530
Message-ID: <CAKohpomytrzUz9YFaf59-1ZJ-XYv2mXSaQk2JXEt86wh=5X12A@mail.gmail.com>
Subject: Re: [RFC PATCH 03/10] sched: Forced task migration on heterogeneous systems
From: Viresh Kumar <viresh.kumar@linaro.org>
To: morten.rasmussen@arm.com
Cc: paulmck@linux.vnet.ibm.com, pjt@google.com, peterz@infradead.org,
        suresh.b.siddha@intel.com, linaro-sched-sig@lists.linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Robin Randhawa <robin.randhawa@arm.com>, Arvind.Chauhan@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor comments here :)

On 22 September 2012 00:02,  <morten.rasmussen@arm.com> wrote:

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index d80de46..490f1f0 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3744,7 +3744,6 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
>          * 1) task is cache cold, or
>          * 2) too many balance attempts have failed.
>          */
> -

:(

>         tsk_cache_hot = task_hot(p, env->src_rq->clock_task, env->sd);
>         if (!tsk_cache_hot ||
>                 env->sd->nr_balance_failed > env->sd->cache_nice_tries) {
> @@ -5516,6 +5515,199 @@ static unsigned int hmp_down_migration(int cpu, struct sched_entity *se)
>         return 0;
>  }
>

> +static int hmp_can_migrate_task(struct task_struct *p, struct lb_env *env)
> +{

<...>

> +static int move_specific_task(struct lb_env *env, struct task_struct *pm)
> +{
> +       struct task_struct *p, *n;
> +
> +       list_for_each_entry_safe(p, n, &env->src_rq->cfs_tasks, se.group_node) {
> +       if (throttled_lb_pair(task_group(p), env->src_rq->cpu,
> +                               env->dst_cpu))
> +               continue;

Please fix indentation of above if statement.

<...>

> +#else
> +static void hmp_force_up_migration(int this_cpu) { }

inline?

--
viresh

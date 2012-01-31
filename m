Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab2AaIqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 03:46:15 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40797 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab2AaIqN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 03:46:13 -0500
MIME-Version: 1.0
In-Reply-To: <4F2754A0.9090306@ct.jp.nec.com>
References: <4F2754A0.9090306@ct.jp.nec.com>
Date: Tue, 31 Jan 2012 09:46:12 +0100
Message-ID: <CAKfTPtDNmSXmeQD_2TJ6r4rsiH-s8VY-pjSf5=dfA6zMt9s_pg@mail.gmail.com>
Subject: Re: sched: fix compilation warning on !SMP
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/31 Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>
>  CC      kernel/sched/fair.o
> kernel/sched/fair.c:218:36: warning: 'max_load_balance_interval' defined but not used [-Wunused-variable]
>
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 8e77a6b..4ab60a2 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -215,8 +215,6 @@ calc_delta_mine(unsigned long delta_exec, unsigned long weight,
>
>  const struct sched_class fair_sched_class;
>
> -static unsigned long __read_mostly max_load_balance_interval = HZ/10;
> -
>  /**************************************************************
>  * CFS operations on generic schedulable entities:
>  */
> @@ -3086,6 +3084,8 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preemp
>  * Fair scheduling class load-balancing methods:
>  */
>
> +static unsigned long __read_mostly max_load_balance_interval = HZ/10;
> +

Sorry for moving it out of SMP. Thanks for fixing this

>  /*
>  * pull_task - move a task from a remote runqueue to the local runqueue.
>  * Both runqueues must be locked.
> --
> 1.7.7.6
>

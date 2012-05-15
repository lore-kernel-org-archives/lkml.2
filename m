Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933302Ab2EORtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:49:12 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42250 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499Ab2EORtI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:49:08 -0400
MIME-Version: 1.0
In-Reply-To: <tip-0sqhrht34phowgclj12dgk8h@git.kernel.org>
References: <tip-0sqhrht34phowgclj12dgk8h@git.kernel.org>
Date: Tue, 15 May 2012 10:49:07 -0700
X-Google-Sender-Auth: wjdDsok4aGT1TUGpJc84nMHEz3M
Message-ID: <CAE9FiQV7xz1nntEiUfwXwSLQGNQWoVKVnymMn9EuMd2gLFm_6g@mail.gmail.com>
Subject: Re: [tip:sched/core] sched/numa: Fix the new NUMA topology bits
From: Yinghai Lu <yinghai@kernel.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, a.p.zijlstra@chello.nl, greg.pearson@hp.com,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 6:43 AM, tip-bot for Peter Zijlstra
<a.p.zijlstra@chello.nl> wrote:
> Commit-ID:  dd7d8634e619b715a537402672d1383535ff4c54
> Gitweb:     http://git.kernel.org/tip/dd7d8634e619b715a537402672d1383535ff4c54
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Fri, 11 May 2012 00:56:20 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Mon, 14 May 2012 15:05:25 +0200
>
> sched/numa: Fix the new NUMA topology bits
>
> There's no need to convert a node number to a node number by
> pretending its a cpu number..
>
> Reported-by: Yinghai Lu <yinghai@kernel.org>
> Reported-and-Tested-by: Greg Pearson <greg.pearson@hp.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/n/tip-0sqhrht34phowgclj12dgk8h@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  kernel/sched/core.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b4f2096..0738036 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6395,8 +6395,7 @@ static void sched_init_numa(void)
>                        sched_domains_numa_masks[i][j] = mask;
>
>                        for (k = 0; k < nr_node_ids; k++) {
> -                               if (node_distance(cpu_to_node(j), k) >
> -                                               sched_domains_numa_distance[i])
> +                               if (node_distance(j, k) > sched_domains_numa_distance[i])
>                                        continue;
>
>                                cpumask_or(mask, mask, cpumask_of_node(k));

this one should be folded into offending commit

Commit-ID:  cb83b629bae0327cf9f44f096adc38d150ceb913
Gitweb:     http://git.kernel.org/tip/cb83b629bae0327cf9f44f096adc38d150ceb913
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 17 Apr 2012 15:49:36 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:00:55 +0200

sched/numa: Rewrite the CONFIG_NUMA sched domain support

Thanks

Yinghai

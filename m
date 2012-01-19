Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab2ASUkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 15:40:25 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:49347 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933003Ab2ASUkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 15:40:21 -0500
Message-ID: <1327005616.4826.4.camel@edumazet-laptop>
Subject: Re: [BUG] vmstat reports no interrupts
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Date: Thu, 19 Jan 2012 21:40:16 +0100
In-Reply-To: <20120114000101.GL1068@n2100.arm.linux.org.uk>
References: <20120114000101.GL1068@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 14 janvier 2012 à 00:01 +0000, Russell King - ARM Linux a
écrit :
> From: Russell King <rmk+kernel@arm.linux.org.uk>
> proc: fix /proc/stat intr sum
> 
> Commit 3292beb340c7688 (sched/accounting: Change cpustat fields to an array)
> deleted the code which provides us with the sum of all interrupts in
> the system, causing vmstat to report zero interrupts occuring in the
> system.  Fix this by restoring the code.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Tested-by: Russell King <rmk+kernel@arm.linux.org.uk> [on ARM]
> ---
>  fs/proc/stat.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/proc/stat.c b/fs/proc/stat.c
> index d76ca6a..121f77c 100644
> --- a/fs/proc/stat.c
> +++ b/fs/proc/stat.c
> @@ -77,6 +77,8 @@ static int show_stat(struct seq_file *p, void *v)
>  		steal += kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
>  		guest += kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
>  		guest_nice += kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
> +		sum += kstat_cpu_irqs_sum(i);
> +		sum += arch_irq_stat_cpu(i);
>  
>  		for (j = 0; j < NR_SOFTIRQS; j++) {
>  			unsigned int softirq_stat = kstat_softirqs_cpu(j, i);
> 

Any news on this patch being accepted and pushed to Linus ?

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Thanks



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab2LKEYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 23:24:04 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49851 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab2LKEYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 23:24:02 -0500
Message-ID: <50C6B530.3030307@linux.vnet.ibm.com>
Date: Tue, 11 Dec 2012 09:53:12 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Subject: Re: [PATCH 01/18] sched: select_task_rq_fair clean up
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com> <1355127754-8444-2-git-send-email-alex.shi@intel.com>
In-Reply-To: <1355127754-8444-2-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121104-4790-0000-0000-000005F83FF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On 12/10/2012 01:52 PM, Alex Shi wrote:
> It is impossible to miss a task allowed cpu in a eligible group.

The one thing I am concerned with here is if there is a possibility of
the task changing its tsk_cpus_allowed() while this code is running.

i.e find_idlest_group() finds an idle group,then the tsk_cpus_allowed()
for the task changes,perhaps by the user himself,which might not include
the cpus in the idle group.After this find_idlest_cpu() is called.I mean
a race condition in short.Then we might not have an eligible cpu in that
group right?

> And since find_idlest_group only return a different group which
> excludes old cpu, it's also imporissible to find a new cpu same as old
> cpu.

This I agree with.

> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 59e072b..df99456 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3150,11 +3150,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  		}
>  
>  		new_cpu = find_idlest_cpu(group, p, cpu);
> -		if (new_cpu == -1 || new_cpu == cpu) {
> -			/* Now try balancing at a lower domain level of cpu */
> -			sd = sd->child;
> -			continue;
> -		}
>  
>  		/* Now try balancing at a lower domain level of new_cpu */
>  		cpu = new_cpu;
> 
Regards
Preeti U Murthy


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab1AaTi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:38:27 -0500
Received: from xenotime.net ([72.52.115.56]:52541 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756156Ab1AaTiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:38:25 -0500
Date: Mon, 31 Jan 2011 11:38:20 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Jaswinder Singh <jaswinderlinux@gmail.com>
Subject: Re: [PATCH] Fix linux-next warning from abb74cef
Message-Id: <20110131113820.193a89c5.rdunlap@xenotime.net>
In-Reply-To: <1296501163-31113-1-git-send-email-venki@google.com>
References: <AANLkTi=+VtHwRMkxq+BK3wRDE9fiAZCy=5dypn45o=Hz@mail.gmail.com>
	<1296501163-31113-1-git-send-email-venki@google.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011 11:12:43 -0800 Venkatesh Pallipadi wrote:

> Yes. Patch below should fix the problem.
> 
> Fix below warning -
>  Introduced by commit abb74cefa9c682fb38ba86c17ca3c86fed6cc464 ("sched:
>  Export ns irqtimes through /proc/stat").
> 
> After merging the tip tree, today's linux-next build (powerpc
> ppc64_defconfig) produced these warnings:
> 
> kernel/sched.c:3719: warning: 'irqtime_account_idle_ticks' defined but not =
> used
> kernel/sched.c:3720: warning: 'irqtime_account_process_tick' defined but no=
> t used

[ugh on the '=' line continuations.]

> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
> ---
>  kernel/sched.c |   64 ++++++++++++++++++++++++++++----------------------------
>  1 files changed, 32 insertions(+), 32 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 477e1bc..9a552bd 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3654,6 +3654,36 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
>  	__account_system_time(p, cputime, cputime_scaled, target_cputime64);
>  }
>  
> +/*
> + * Account for involuntary wait time.
> + * @steal: the cpu time spent in involuntary wait

I see that you only moved this code, but please change @steal to @cputime also.

> + */
> +void account_steal_time(cputime_t cputime)
> +{
> +	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
> +	cputime64_t cputime64 = cputime_to_cputime64(cputime);
> +
> +	cpustat->steal = cputime64_add(cpustat->steal, cputime64);
> +}

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

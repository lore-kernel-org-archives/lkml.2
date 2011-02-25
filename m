Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab1BYSNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:13:25 -0500
Received: from smtp-out.google.com ([74.125.121.67]:56118 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932505Ab1BYSNX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:13:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I7ExH8Mqj/lwKJp2MNv6tw3Xr9tCC4eBeWNsBQUBI5J7iVb/LNTV8+gZfFnzXFRxvx
         veQyQigSjX8c//y+ZFIw==
MIME-Version: 1.0
In-Reply-To: <tip-7e9498705e810404ecf29bb2d6fa632b9484c609@git.kernel.org>
References: <20110225133228.GD7469@osiris.boeblingen.de.ibm.com>
	<tip-7e9498705e810404ecf29bb2d6fa632b9484c609@git.kernel.org>
Date: Fri, 25 Feb 2011 10:13:20 -0800
Message-ID: <AANLkTi=7Z7QoMLEMdwC=4mo3j_i-Bv5WxfjwONDG=wL8@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Add #ifdef around irq time accounting functions
From: Venkatesh Pallipadi <venki@google.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        venki@google.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 6:43 AM, tip-bot for Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> Commit-ID:  7e9498705e810404ecf29bb2d6fa632b9484c609
> Gitweb:     http://git.kernel.org/tip/7e9498705e810404ecf29bb2d6fa632b9484c609
> Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
> AuthorDate: Fri, 25 Feb 2011 14:32:28 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 25 Feb 2011 14:39:48 +0100
>
> sched: Add #ifdef around irq time accounting functions

I had a slightly different and I think a bit cleaner patch to address
the same problem earlier here
https://lkml.org/lkml/2011/1/31/363

Can you please take that patch instead of this one.

Thanks,
Venki

>
> Get rid of this:
>
>  kernel/sched.c:3731:13: warning: 'irqtime_account_idle_ticks' defined but not used
>  kernel/sched.c:3732:13: warning: 'irqtime_account_process_tick' defined but not used
>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Venkatesh Pallipadi <venki@google.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <20110225133228.GD7469@osiris.boeblingen.de.ibm.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/sched.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 2effcb7..79bca16 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3687,6 +3687,7 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
>        __account_system_time(p, cputime, cputime_scaled, target_cputime64);
>  }
>
> +#ifndef CONFIG_VIRT_CPU_ACCOUNTING
>  #ifdef CONFIG_IRQ_TIME_ACCOUNTING
>  /*
>  * Account a tick to a process and cpustat
> @@ -3753,6 +3754,7 @@ static void irqtime_account_idle_ticks(int ticks) {}
>  static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
>                                                struct rq *rq) {}
>  #endif
> +#endif /* !CONFIG_VIRT_CPU_ACCOUNTING */
>
>  /*
>  * Account for involuntary wait time.
>

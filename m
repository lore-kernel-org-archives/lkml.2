Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab2HQGSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 02:18:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51065 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2HQGSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 02:18:38 -0400
MIME-Version: 1.0
In-Reply-To: <1345129335-23688-1-git-send-email-tklauser@distanz.ch>
References: <1345129335-23688-1-git-send-email-tklauser@distanz.ch>
Date: Fri, 17 Aug 2012 14:18:36 +0800
Message-ID: <CAA_GA1dBPh3MLvRFwBsUt19RPYcs75qrWU3s8EAsHZ13SXpS0w@mail.gmail.com>
Subject: Re: [PATCH] blackfin: Use schedule_preempt_disabled()
From: Bob Liu <lliubbo@gmail.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 11:02 PM, Tobias Klauser <tklauser@distanz.ch> wrote:
> Follow bd2f5536 (sched/rt: Use schedule_preempt_disabled()).
>
> b5affb014 (blackfin: add bf60x to current framework) accidentally (?)
> reverted the change.
>

Applied, Thank you!

> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  arch/blackfin/kernel/process.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
> index 62bcea7..8936bbb 100644
> --- a/arch/blackfin/kernel/process.c
> +++ b/arch/blackfin/kernel/process.c
> @@ -95,9 +95,7 @@ void cpu_idle(void)
>                         idle();
>                 rcu_idle_exit();
>                 tick_nohz_idle_exit();
> -               preempt_enable_no_resched();
> -               schedule();
> -               preempt_disable();
> +               schedule_preempt_disabled();
>         }
>  }
>
> --
> 1.7.5.4
>

-- 
Regards,
--Bob

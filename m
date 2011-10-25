Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1JYWrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 18:47:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62010 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab1JYWrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 18:47:04 -0400
MIME-Version: 1.0
In-Reply-To: <1304511784-24205-1-git-send-email-vapier@gentoo.org>
References: <1304511784-24205-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 25 Oct 2011 18:46:42 -0400
X-Google-Sender-Auth: qY3vAeizFLdbSNfosoC4CCQ46WM
Message-ID: <CAMjpGUdnJ02bFG-fPW-dnG+nuvP=pe6Q2GaMHe9fUsJmNsj0mQ@mail.gmail.com>
Subject: Re: [PATCH] softirq: constify name array
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping ...
-mike

On Wed, May 4, 2011 at 08:23, Mike Frysinger <vapier@gentoo.org> wrote:
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  include/linux/interrupt.h |    2 +-
>  kernel/softirq.c          |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index bea0ac7..74a98ad 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -422,7 +422,7 @@ enum
>  /* map softirq index to softirq name. update 'softirq_to_name' in
>  * kernel/softirq.c when adding a new softirq.
>  */
> -extern char *softirq_to_name[NR_SOFTIRQS];
> +extern const char * const softirq_to_name[NR_SOFTIRQS];
>
>  /* softirq mask and active fields moved to irq_cpustat_t in
>  * asm/hardirq.h to get better cache usage.  KAO
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 174f976..9d744a7 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -56,7 +56,7 @@ static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp
>
>  DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
>
> -char *softirq_to_name[NR_SOFTIRQS] = {
> +const char * const softirq_to_name[NR_SOFTIRQS] = {
>        "HI", "TIMER", "NET_TX", "NET_RX", "BLOCK", "BLOCK_IOPOLL",
>        "TASKLET", "SCHED", "HRTIMER",  "RCU"
>  };
> --
> 1.7.5.rc3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

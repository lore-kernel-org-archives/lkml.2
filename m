Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1LAEIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 23:08:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44755 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1LAEIk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 23:08:40 -0500
MIME-Version: 1.0
In-Reply-To: <1320241585-28056-1-git-send-email-prarit@redhat.com>
References: <1320241585-28056-1-git-send-email-prarit@redhat.com>
Date: Thu, 1 Dec 2011 12:08:40 +0800
Message-ID: <CAPsfambtA1tOOYKLBmf=DbU2FAfj=EBQD2rirdwiOy2vMnzM7w@mail.gmail.com>
Subject: Re: [PATCH] [PATCH]: Reset clocksource watchdog after sysrq-t
From: Xiaochen Wang <xiaochn.wang@gmail.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, johnstul@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prarit,
    I'm reading the clocksource watchdog code, in which case I see your patch.
But i cannot understand the patch very well.

On Wed, Nov 2, 2011 at 9:46 PM, Prarit Bhargava <prarit@redhat.com> wrote:
> When doing a sysrq-t other processes are starved out because the task_list
> lock is held.  On a large enough system this means that the clocksource
> watchdog does not fire for a long time and when system operation resumes the
> watchdog erroneously marks the current clocksource as unstable.
Do you mean that a sysrq-t will enlarge the deviation between watchdog and the
 watched clocksource(in watchdog_list) ?
>
> Reset the clocksource watchdog after show_state_filter() has dumped the
> task states.
>
> Cc: tglx@linutronix.de
> Cc: johnstul@us.ibm.com
> ---
>  kernel/sched.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index d87c6e5..b09c053 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -71,6 +71,7 @@
>  #include <linux/ctype.h>
>  #include <linux/ftrace.h>
>  #include <linux/slab.h>
> +#include <linux/clocksource.h>
>
>  #include <asm/tlb.h>
>  #include <asm/irq_regs.h>
> @@ -6034,6 +6035,7 @@ void show_state_filter(unsigned long state_filter)
>        } while_each_thread(g, p);
>
>        touch_all_softlockup_watchdogs();
> +       clocksource_touch_watchdog();
>
>  #ifdef CONFIG_SCHED_DEBUG
>        sysrq_sched_debug_show();
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Thanks,
Xiaochen

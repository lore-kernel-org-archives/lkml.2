Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2DIHeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 03:34:24 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39081 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab2DIHeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 03:34:19 -0400
Message-ID: <4F8290F8.90706@gmail.com>
Date: Mon, 09 Apr 2012 09:34:16 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: Dario Faggioli <raistlin@linux.it>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DLS: add dl_time_equal helper in deadline scheduler
References: <CAJd=RBDKe_fX0ROdbs8sqeqJmjWtUmtSTtF1kMLbdOvt0a6UHQ@mail.gmail.com>
In-Reply-To: <CAJd=RBDKe_fX0ROdbs8sqeqJmjWtUmtSTtF1kMLbdOvt0a6UHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/07/2012 09:49 AM, Hillf Danton wrote:
> Hi all
>
> A tiny helper, dl_time_equal, is added for easing readers.
>
> And dl_entity_preempt is redefined to be bool, and its comment is also changed.
>
> Signed-off-by: Hillf Danton<dhillf@gmail.com>
> ---
>
> --- a/kernel/sched_dl.c	Sat Apr  7 15:00:28 2012
> +++ b/kernel/sched_dl.c	Sat Apr  7 15:20:10 2012
> @@ -16,16 +16,21 @@
>    */
>   static const struct sched_class dl_sched_class;
>
> -static inline int dl_time_before(u64 a, u64 b)
> +static inline bool dl_time_equal(u64 a, u64 b)
> +{
> +	return a == b;
> +}
> +
> +static inline bool dl_time_before(u64 a, u64 b)
>   {
>   	return (s64)(a - b)<  0;
>   }
>
>   /*
> - * Tells if entity @a should preempt entity @b.
> + * Return true if entity @a could preempt entity @b in term of deadline
>    */
> -static inline
> -int dl_entity_preempt(struct sched_dl_entity *a, struct sched_dl_entity *b)
> +static inline bool
> +dl_entity_preempt(struct sched_dl_entity *a, struct sched_dl_entity *b)
>   {
>   	return dl_time_before(a->deadline, b->deadline);
>   }
> @@ -885,7 +890,7 @@ static void check_preempt_curr_dl(struct
>   	 * In the unlikely case current and p have the same deadline
>   	 * let us try to decide what's the best thing to do...
>   	 */
> -	if ((s64)(p->dl.deadline - rq->curr->dl.deadline) == 0&&
> +	if (dl_time_equal(p->dl.deadline, rq->curr->dl.deadline)&&
>   	!need_resched())
>   		check_preempt_equal_dl(rq, p);
>   #endif /* CONFIG_SMP */
> --

I'll change the comparison to be deadline_a == deadline_b, but I don't see the
need for a special helper function. It is used only once, better to have the
comparison really inline (a very special case).

Thanks and Regards,

- Juri

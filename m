Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab2DVQK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 12:10:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46432 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2DVQK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 12:10:58 -0400
Message-ID: <4F942D8D.3060508@gmail.com>
Date: Sun, 22 Apr 2012 18:10:53 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: Dario Faggioli <raistlin@linux.it>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] DLS: fix switched_from_dl
References: <CAJd=RBAsSHp2KSnwF6h1fYCQyMCA-Lg31WNr9eTbuenkAU+vbw@mail.gmail.com>
In-Reply-To: <CAJd=RBAsSHp2KSnwF6h1fYCQyMCA-Lg31WNr9eTbuenkAU+vbw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 04:25 PM, Hillf Danton wrote:
> Pull only if the current task switches from DLS, since it was not preempted
> by pushable tasks waiting on other runqueues.
>
> Signed-off-by: Hillf Danton<dhillf@gmail.com>
> ---
>
> --- a/kernel/sched_dl.c	Mon Apr  9 19:39:56 2012
> +++ b/kernel/sched_dl.c	Tue Apr 10 21:23:52 2012
> @@ -1466,12 +1466,7 @@ static void switched_from_dl(struct rq *
>   		hrtimer_try_to_cancel(&p->dl.dl_timer);
>
>   #ifdef CONFIG_SMP
> -	/*
> -	 * Since this might be the only -deadline task on the rq,
> -	 * this is the right place to try to pull some other one
> -	 * from an overloaded cpu, if any.
> -	 */
> -	if (!rq->dl.dl_nr_running)
> +	if (p == rq->curr)
>   		pull_dl_task(rq);
>   #endif
>   }
> --

I'd stay with the original code. p (former -dl task) is going away
(changed its scheduling class from -dl to something else). If it was
the last -dl task on rq I'd probably want to pull someone else. No
assumptions needed in this case.

Thanks,

- Juri

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab1EQCfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 22:35:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40078 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab1EQCfi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 22:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LvXmmwr5cNS0DEUThbrn6JOFkYd9zt3njCyoq0hVQpazuQQJoc71FpFCR48VMOUQFe
         aiPo3i4+Pz3891muqqdFVefPou8wF+DpIWQWhbDYbttqvmF9Xqkiozvms/OS7osoesRc
         Ps3A+ZjuuwWg0IQ0WhWVATqJhxKF3McbN1yOw=
MIME-Version: 1.0
In-Reply-To: <BANLkTinw9LLiGD788+6AvbE+54jyVRUwBg@mail.gmail.com>
References: <BANLkTinw9LLiGD788+6AvbE+54jyVRUwBg@mail.gmail.com>
Date: Tue, 17 May 2011 10:35:37 +0800
Message-ID: <BANLkTikPhwajRBZ-dx46NnobOu10AmXoSg@mail.gmail.com>
Subject: Re: [PATCH] sched: fix how RT task is pulled
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 10:50 AM, Hillf Danton <dhillf@gmail.com> wrote:
> When pulling RT task for a given runqueue, if it is already overloaded
> with RT tasks, the pull operation could be avoided at the moment.
>
> btw, it looks like a typo?

No.

Below is how rt_overloaded() is realized:
static inline int rt_overloaded(struct rq *rq)
{
        return atomic_read(&rq->rd->rto_count);
}

You can notice it's about the overload of the very root_domain.

Thanks,
Yong

>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>  kernel/sched_rt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 19ecb31..14c764b 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1440,7 +1440,7 @@ static int pull_rt_task(struct rq *this_rq)
>        struct task_struct *p;
>        struct rq *src_rq;
>
> -       if (likely(!rt_overloaded(this_rq)))
> +       if (unlikely(rt_overloaded(this_rq)))
>                return 0;
>
>        for_each_cpu(cpu, this_rq->rd->rto_mask) {
>



-- 
Only stand for myself

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015Ab1FBIFC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 04:05:02 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42283 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab1FBIEz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 04:04:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i1AaMgNPwXDCCxKAkgQEHkZlLo3xL/kIubcxIJWGj3zavRmAtxue4xlHvQSBpkxDLi
         Dz2s36RvMoJ3x/92sBAD8E3IJTiwEsxuE8sG+KjJ8gc74hbq5b6tBotkrTb94SGtG34O
         tZev0UhkmpYKW+x5fU0XCeh1MlaLKaGUMaGKg=
MIME-Version: 1.0
In-Reply-To: <BANLkTimqWD=q6YnSDi-v9y=LMWecgEzEWg@mail.gmail.com>
References: <BANLkTimqWD=q6YnSDi-v9y=LMWecgEzEWg@mail.gmail.com>
Date: Thu, 2 Jun 2011 16:04:53 +0800
Message-ID: <BANLkTikoO5F5H4sEUoDPKX3qiahuehp=Mg@mail.gmail.com>
Subject: Re: [PATCH] sched: remove resetting exec_start in put_prev_task_rt()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 10:03 PM, Hillf Danton <dhillf@gmail.com> wrote:
> Resetting exec_start, after updated in update_curr_rt(), could open window for
> messing up the subsequent computations of delta_exec of the given task.

I can't see how could this happen. what kind of 'subsequent computations'
do you mean?

But because exec_start will be reset by _pick_next_task_rt()/set_curr_task_rt(),
you patch is ok. IMHO it is not critical, it's just cleanup instead.

Thanks,
Yong

>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>  kernel/sched_rt.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 88725c9..0f0cfce 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1166,7 +1166,6 @@ static struct task_struct
> *pick_next_task_rt(struct rq *rq)
>  static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
>  {
>        update_curr_rt(rq);
> -       p->se.exec_start = 0;
>
>        /*
>         * The previous task needs to be made eligible for pushing
>



-- 
Only stand for myself

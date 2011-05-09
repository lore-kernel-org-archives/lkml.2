Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab1EIEjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 00:39:43 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36923 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab1EIEjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 00:39:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O7e0Nd3fB+DZcdq48XsG7BQupCF14WZW79/3350UvmnJ77mX75uQgg0QcTUJqLwPYA
         IxwFZZWsUWJoU9TvT2/XKhkp977U780sftOGDF8pyimrTLjW6BIZEHtIVJPPT7CdzjYA
         4qmjgpMao1XJ/xCSmDfusJRyMd/GJveuyuqOc=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=tPbwNP3xDYZVHHqQ2zZujCBT6jw@mail.gmail.com>
References: <BANLkTi=tPbwNP3xDYZVHHqQ2zZujCBT6jw@mail.gmail.com>
Date: Mon, 9 May 2011 12:39:39 +0800
Message-ID: <BANLkTimjkK-q63x5DrEj+9=pF8zbW7mJ2g@mail.gmail.com>
Subject: Re: [PATCH] sched: shorten setting the allowed cpu mask of task
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 6, 2011 at 8:52 PM, Hillf Danton <dhillf@gmail.com> wrote:
> When setting the allowed cpu mask for a given task, if the task is
> already bound to certain cpu, after checking the validity of the new

Maybe we don't need to restrict it only on task bound to certain cpu.

> mask of allowed cpus, job is done, and no further efforts needed for
> the valid case as well.
>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>
> --- a/kernel/sched.c    2011-04-27 11:48:50.000000000 +0800
> +++ b/kernel/sched.c    2011-05-06 20:39:58.000000000 +0800
> @@ -5899,9 +5899,9 @@ again:
>                goto out;
>        }
>
> -       if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
> -                    !cpumask_equal(&p->cpus_allowed, new_mask))) {
> -               ret = -EINVAL;
> +       if ((p->flags & PF_THREAD_BOUND) && p != current) {
> +               if (!cpumask_equal(&p->cpus_allowed, new_mask))

IOW, we could make '!cpumask_equal(&p->cpus_allowed, new_mask)'
be a separated condition. And I don't see any potential problem with it.

Thanks,
Yong


> +                       ret = -EINVAL;
>                goto out;
>        }
>



-- 
Only stand for myself

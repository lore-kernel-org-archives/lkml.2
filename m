Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab3ABFo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 00:44:26 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:56469 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab3ABFoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 00:44:23 -0500
MIME-Version: 1.0
In-Reply-To: <ae59db1945518d6f6250920d46eb1f1a9cc0024e.1352361704.git.viresh.kumar@linaro.org>
References: <ae59db1945518d6f6250920d46eb1f1a9cc0024e.1352361704.git.viresh.kumar@linaro.org>
Date: Wed, 2 Jan 2013 11:14:23 +0530
Message-ID: <CAKohpokC5T8+iEiEbz1aoz0mgVXWULuBcVKp3KoQOxe7FfxZYg@mail.gmail.com>
Subject: Re: [PATCH] sched/fair: Set se->vruntime directly in place_entity()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 November 2012 13:33, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> We are first storing the new vruntime in a variable and then storing it in
> se->vruntime. Simply update se->vruntime directly.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  kernel/sched/fair.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index a319d56c..820a2f1 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1454,9 +1454,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
>         }
>
>         /* ensure we never gain time by being placed backwards. */
> -       vruntime = max_vruntime(se->vruntime, vruntime);
> -
> -       se->vruntime = vruntime;
> +       se->vruntime = max_vruntime(se->vruntime, vruntime);
>  }

Ping!!

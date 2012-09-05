Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab2IEQTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:19:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42002 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2IEQTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:19:52 -0400
MIME-Version: 1.0
In-Reply-To: <1346841475-4422-10-git-send-email-laijs@cn.fujitsu.com>
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com>
	<1346841475-4422-10-git-send-email-laijs@cn.fujitsu.com>
Date: Thu, 6 Sep 2012 00:19:52 +0800
Message-ID: <CACvQF51LgTYaEweHxwzshRJxZmP9mpFuGgk1c3NNzYwwqqyPLg@mail.gmail.com>
Subject: Re: [PATCH 09/11 V5] workqueue: rebind newly created worker
From: Lai Jiangshan <eag0628@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 6:37 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> when the newly created needs to be rebound. exile it!
> it will rebind itself in worker_thead().
>
> It just prepares, this code is useless until
> "we unbind/rebind without manager_mutex"
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 223d128..819c84e 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1838,6 +1838,11 @@ static void manager_start_worker(struct worker *worker, struct worker *manager)
>
>         /* copy the flags. also unbind the worker if the manager is unbound */
>         worker->flags |= manager->flags & WORKER_COPY_FLAGS;
> +
> +       if (need_to_rebind_worker(worker)) {
> +               /* exile it, and let it rebind itself */
> +               list_del_init(&worker->entry);

Sorry, we should not add it to idle_list.
"add and then remove " is wrong here.

> +       }
>  }
>
>  /**
> --
> 1.7.4.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

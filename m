Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2JVTYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:24:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab2JVTYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:24:03 -0400
Date: Mon, 22 Oct 2012 21:25:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 5/7] cgroup_freezer: allow moving tasks in and out of a
	frozen cgroup
Message-ID: <20121022192506.GA27163@redhat.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <1350426526-14254-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350426526-14254-6-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tha last question ;)

On 10/16, Tejun Heo wrote:
>
> @@ -190,12 +201,12 @@ static void freezer_fork(struct task_struct *task)
>  		goto out;
>
>  	spin_lock_irq(&freezer->lock);
> -	BUG_ON(freezer->state == CGROUP_FROZEN);
> -
> -	/* Locking avoids race with FREEZING -> THAWED transitions. */
> -	if (freezer->state == CGROUP_FREEZING)
> +	/*
> +	 * @task might have been just migrated into a FROZEN cgroup.

Confused. If it was migrated, then freezer_attach() should take care
do freeze_task?

IOW,

> Test
> +	 * equality with THAWED.  Read the comment in freezer_attach().
> +	 */
> +	if (freezer->state != CGROUP_THAWED)
>  		freeze_task(task);
> -

This can only happen in the "normal" case, when a CGROUP_FREEZING task
forks the new child. So we could even do BUG_ON(state = CGROUP_FROZEN).

Or there could be another reason?

Oleg.


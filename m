Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab2JVVZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:25:13 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38457 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2JVVZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:25:11 -0400
Date: Mon, 22 Oct 2012 17:25:05 -0400
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 5/7] cgroup_freezer: allow moving tasks in and out of a
 frozen cgroup
Message-ID: <20121022212505.GG5951@atj.dyndns.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <1350426526-14254-6-git-send-email-tj@kernel.org>
 <20121022192506.GA27163@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022192506.GA27163@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Oct 22, 2012 at 09:25:06PM +0200, Oleg Nesterov wrote:
> > @@ -190,12 +201,12 @@ static void freezer_fork(struct task_struct *task)
> >  		goto out;
> >
> >  	spin_lock_irq(&freezer->lock);
> > -	BUG_ON(freezer->state == CGROUP_FROZEN);
> > -
> > -	/* Locking avoids race with FREEZING -> THAWED transitions. */
> > -	if (freezer->state == CGROUP_FREEZING)
> > +	/*
> > +	 * @task might have been just migrated into a FROZEN cgroup.
> 
> Confused. If it was migrated, then freezer_attach() should take care
> do freeze_task?

Hmmm... there's a window where a task is migrated but ->attach()
hasn't completed yet, so freezer_attach() might not have kicked in
yet.  It might not be strictly necessary but I think it's more
consistent this way.  No?

Thanks.

--
tejun

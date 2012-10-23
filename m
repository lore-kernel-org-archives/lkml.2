Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164Ab2JWQNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:13:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198Ab2JWQNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:13:08 -0400
Date: Tue, 23 Oct 2012 18:14:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 5/7] cgroup_freezer: allow moving tasks in and out of a
	frozen cgroup
Message-ID: <20121023161414.GA18138@redhat.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <1350426526-14254-6-git-send-email-tj@kernel.org> <20121022192506.GA27163@redhat.com> <20121022212505.GG5951@atj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022212505.GG5951@atj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22, Tejun Heo wrote:
>
> Hello,
>
> On Mon, Oct 22, 2012 at 09:25:06PM +0200, Oleg Nesterov wrote:
> > > @@ -190,12 +201,12 @@ static void freezer_fork(struct task_struct *task)
> > >  		goto out;
> > >
> > >  	spin_lock_irq(&freezer->lock);
> > > -	BUG_ON(freezer->state == CGROUP_FROZEN);
> > > -
> > > -	/* Locking avoids race with FREEZING -> THAWED transitions. */
> > > -	if (freezer->state == CGROUP_FREEZING)
> > > +	/*
> > > +	 * @task might have been just migrated into a FROZEN cgroup.
> >
> > Confused. If it was migrated, then freezer_attach() should take care
> > do freeze_task?
>
> Hmmm... there's a window where a task is migrated but ->attach()
> hasn't completed yet, so freezer_attach() might not have kicked in
> yet.

Yes, I see.

Indeed, cgroup_task_migrate() is called before ->attach().

Thanks!

Oleg.


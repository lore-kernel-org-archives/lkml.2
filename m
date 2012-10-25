Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936033Ab2JYRla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:41:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757050Ab2JYRl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:41:28 -0400
Date: Thu, 25 Oct 2012 19:42:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/7] cgroup: cgroup_subsys->fork() should be called
	after the task is added to css_set
Message-ID: <20121025174233.GC7650@redhat.com>
References: <1350426526-14254-1-git-send-email-tj@kernel.org> <1350426526-14254-2-git-send-email-tj@kernel.org> <20121021191141.GA26218@redhat.com> <20121021192222.GB5951@atj.dyndns.org> <20121022180445.GB21553@redhat.com> <20121022211631.GE5951@atj.dyndns.org> <20121023155128.GB16201@redhat.com> <20121024190458.GB12182@atj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024190458.GB12182@atj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24, Tejun Heo wrote:
>
> Hello,
>
> On Tue, Oct 23, 2012 at 05:51:28PM +0200, Oleg Nesterov wrote:
> > Yes, yes. But in this case (I mean, for uprobes) "threadgroup" in the name
> > is misleading. It should be called unconditially without any argument.
> >
> > Please see
> >
> > 	[PATCH 1/2] brw_mutex: big read-write mutex
> > 	http://marc.info/?l=linux-kernel&m=135032816223715
>
> Ooh... that's something completely different.
>
> > 	[PATCH 2/2] uprobes: Use brw_mutex to fix register/unregister vs dup_mmap() race
> > 	http://marc.info/?l=linux-kernel&m=135032817823720
> >
> > for details, but in short 2/2 needs this giant lock to block dup_mmap()
> > system-wide, while cgroup (currently) only needs threadgroup lock if
> > CLONE_THREAD (ignoring do_exit) and per-task.
> >
> > So please forget, I no longer think it makes sense to use the same
> > thing for uprobes and cgroups.
>
> It is quite tempting to reduce hot path overhead and penalize cgroup
> migration ops more tho.  Write-locking brw_mutex on migration might
> not be too bad.  Why did you change your mind?

Well, mostly because I do not think 1/2 will be ever applied ;)

Since we already have (to my surprise!) percpu_rw_semaphore, I do
not think I can add another similar lock.

Perhaps uprobes can use percpu_rw_semaphore, but I am not sure...

Oleg.


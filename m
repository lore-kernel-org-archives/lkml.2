Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab1JLTMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 15:12:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab1JLTMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 15:12:33 -0400
Date: Wed, 12 Oct 2011 21:07:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: Tejun Heo <htejun@gmail.com>, rjw@sisk.pl, paul@paulmenage.org,
        lizf@cn.fujitsu.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        fweisbec@gmail.com, matthltc@us.ibm.com, akpm@linux-foundation.org
Subject: Re: [PATCH 3/4] threadgroup: extend threadgroup_lock() to cover
	exit and exec
Message-ID: <20111012190754.GA10238@redhat.com>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com> <1315159280-25032-4-git-send-email-htejun@gmail.com> <20110918173723.GA2384@redhat.com> <20111010171105.GE8100@google.com> <20111012175104.GA6156@redhat.com> <20111012180521.GA20715@ghc17.ghc.andrew.cmu.edu> <20111012182905.GA8580@redhat.com> <20111012184443.GB21363@ghc17.ghc.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012184443.GB21363@ghc17.ghc.andrew.cmu.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12, Ben Blum wrote:
>
> On Wed, Oct 12, 2011 at 08:29:05PM +0200, Oleg Nesterov wrote:
> > On 10/12, Ben Blum wrote:
> > >
> > > On Wed, Oct 12, 2011 at 07:51:04PM +0200, Oleg Nesterov wrote:
> > > >
> > > > > Also, it makes the mechanism unnecessarily cgroup-specific without
> > > > > gaining much if anything.
> > > >
> > > > Yes! And _personally_ I think it should be cgroup-specific, that is
> > > > why I dislike the very fact do_exit() uses it directly. To me it would
> > > > be cleaner to shift it into cgroup hooks. Yes, sure, this is subjective.
> > >
> > > In the fork path, threadgroup_fork_read_...() is also called directly,
> > > not through cgroups. Would that change too?
> >
> > Well, if you ask me, I'd prefer to move lock/unlock into
> > cgroup_fork/cgroup_post_fork ;) Although the error path plays with it
> > too. But this is minor.
> >
> > > > In fact I still hope we can kill this sem altogether, but so far I have
> > > > no idea how we can do this. We do need the new per-process lock to
> > > > protect (in particular) ->thread_group. It is quite possible that it
> > > > should be rw_semaphore. But in this case we down_write(), not _read
> > > > in exit/fork paths, and its scope should be small.
> > >
> > > I'm confused - taking a big rwsem for writing in the fork/exit paths?
> >
> > Yes, we need the new lock to avoid tasklist_lock.
>
> To avoid tasklist_lock in the cgroup path, or in the fork/exit path?

Sorry for confusion ;) I meant exit_notify/do_wait-like things.
I didn't mean cgroup at all.

Oleg.


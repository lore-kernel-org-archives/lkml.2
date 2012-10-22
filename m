Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab2JVVQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:16:42 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50963 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab2JVVQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:16:40 -0400
Date: Mon, 22 Oct 2012 17:16:31 -0400
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/7] cgroup: cgroup_subsys->fork() should be called after
 the task is added to css_set
Message-ID: <20121022211631.GE5951@atj.dyndns.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <1350426526-14254-2-git-send-email-tj@kernel.org>
 <20121021191141.GA26218@redhat.com>
 <20121021192222.GB5951@atj.dyndns.org>
 <20121022180445.GB21553@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022180445.GB21553@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Oct 22, 2012 at 08:04:45PM +0200, Oleg Nesterov wrote:
> > * Clear ->cgroup to %NULL during copy_process().
> 
> I completely agree. new_child->cgroups copied from parent looks simply
> strange until post_fork. If nothing else, the new task is still under
> construction by the time cgroup_fork() is called.

Yeah, and it's just nasty to have cgroup->fork() and ->attach() racing
each other.  As far as cgroup is concerned, the new task should be
completely idle till ->fork() is complete.

> > > I am starting to think again about a big-rw-lock around copy_process.
> > > Recently I tried to add one around dup_mmap for uprobes, but perhaps
> > > cgroups can use it too...
> >
> > If some other subsystems need it, maybe just make threadgroup locking
> > coarser?
> 
> What do you mean?

I probabl have misunderstood you but If you're gonna add big-rw-lock
around copy-process which is always gonna be grabbed, I was suggesting
maybe we could simply repurpose the existing threadgroup locking.  Or
are the requirements too different?

Thanks.

--
tejun

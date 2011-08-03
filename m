Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab1HCO3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 10:29:43 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41030 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab1HCO3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 10:29:37 -0400
Date: Wed, 3 Aug 2011 16:29:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 0/8 v3] cgroups: Task counter subsystem (was: New max
 number of tasks subsystem)
Message-ID: <20110803142926.GD5768@somewhere.redhat.com>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <20110801161900.1fe24b76.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801161900.1fe24b76.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 04:19:00PM -0700, Andrew Morton wrote:
> On Fri, 29 Jul 2011 18:13:22 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Reminder:
> > 
> > This patchset is aimed at reducing the impact of a forkbomb to a
> > cgroup boundaries, thus minimizing the consequences of such an attack
> > against the rest of the system.
> > 
> > This can be useful when cgroups are used to stage some processes or run
> > untrustees.
> 
> Really?  How useful?  Why is it useful enough to justify adding code
> such as this to the kernel?
> 
> Is forkbomb-prevention the only use?  Others have proposed different
> ways of preventing forkbombs which were independent of cgroups - is
> this way better and if so, why?

I should have given more details.

So this is not intended to replace exisiting solution to protect against
forkbombs on the whole machine or user scope, like rlmit NR_PROC.

But rlimit NR_PROC is sometimes not adapted like in the case of containers
implemented using cgroups. If we service many containers for sandboxing
applications or so, the traditional nr_proc rlimit doesn't work anymore
because if all the containers run under the same user, which should be
typically the case, then one container can starve all the others if it
spawns too much processes and the limit is per user and not per cgroup.

> 
> >  block/blk-cgroup.c            |   10 ++-
> >  include/linux/cgroup.h        |   15 +++-
> >  include/linux/cgroup_subsys.h |    8 ++
> >  include/linux/res_counter.h   |   12 +++
> >  init/Kconfig                  |    7 ++
> >  kernel/Makefile               |    1 +
> >  kernel/cgroup.c               |   25 ++++--
> >  kernel/cgroup_freezer.c       |    3 +-
> >  kernel/cgroup_task_counter.c  |  176 +++++++++++++++++++++++++++++++++++++++++
> >  kernel/cpuset.c               |    6 +-
> >  kernel/events/core.c          |    5 +-
> >  kernel/fork.c                 |    4 +
> >  kernel/res_counter.c          |   81 ++++++++++++++++---
> >  kernel/sched.c                |    6 +-
> 
> The patch forgot to document the feature: how it works, what it's
> useful for, what behaviour users can expect to see, when they should
> consider using it, what the userspace control interface is and how to
> configure it, etc.  Documentation/cgroups/ is the place for that.

Right, I'll that in the next take. I did not until now because the ABI was
still staging.

Thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab1HAXTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:19:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918Ab1HAXTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:19:09 -0400
Date: Mon, 1 Aug 2011 16:19:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 0/8 v3] cgroups: Task counter subsystem (was: New max
 number of tasks subsystem)
Message-Id: <20110801161900.1fe24b76.akpm@linux-foundation.org>
In-Reply-To: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011 18:13:22 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Reminder:
> 
> This patchset is aimed at reducing the impact of a forkbomb to a
> cgroup boundaries, thus minimizing the consequences of such an attack
> against the rest of the system.
> 
> This can be useful when cgroups are used to stage some processes or run
> untrustees.

Really?  How useful?  Why is it useful enough to justify adding code
such as this to the kernel?

Is forkbomb-prevention the only use?  Others have proposed different
ways of preventing forkbombs which were independent of cgroups - is
this way better and if so, why?

>  block/blk-cgroup.c            |   10 ++-
>  include/linux/cgroup.h        |   15 +++-
>  include/linux/cgroup_subsys.h |    8 ++
>  include/linux/res_counter.h   |   12 +++
>  init/Kconfig                  |    7 ++
>  kernel/Makefile               |    1 +
>  kernel/cgroup.c               |   25 ++++--
>  kernel/cgroup_freezer.c       |    3 +-
>  kernel/cgroup_task_counter.c  |  176 +++++++++++++++++++++++++++++++++++++++++
>  kernel/cpuset.c               |    6 +-
>  kernel/events/core.c          |    5 +-
>  kernel/fork.c                 |    4 +
>  kernel/res_counter.c          |   81 ++++++++++++++++---
>  kernel/sched.c                |    6 +-

The patch forgot to document the feature: how it works, what it's
useful for, what behaviour users can expect to see, when they should
consider using it, what the userspace control interface is and how to
configure it, etc.  Documentation/cgroups/ is the place for that.

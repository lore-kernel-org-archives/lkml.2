Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab1DLXZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 19:25:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756363Ab1DLXZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 19:25:39 -0400
Date: Tue, 12 Apr 2011 16:25:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com,
        menage@google.com, oleg@redhat.com,
        David Rientjes <rientjes@google.com>, Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH v8.75 0/4] cgroups: implement moving a threadgroup's
 threads atomically with cgroup.procs
Message-Id: <20110412162516.4120c441.akpm@linux-foundation.org>
In-Reply-To: <20110406194420.GC10792@ghc17.ghc.andrew.cmu.edu>
References: <20110208013542.GC31569@ghc17.ghc.andrew.cmu.edu>
	<20110406194420.GC10792@ghc17.ghc.andrew.cmu.edu>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Apr 2011 15:44:20 -0400
Ben Blum <bblum@andrew.cmu.edu> wrote:

> Same as before; using flex_array in attach_proc (thanks Kame).
> 
> -- Ben
> 
> ---
>  Documentation/cgroups/cgroups.txt |   39 ++-
>  block/blk-cgroup.c                |   18 -
>  include/linux/cgroup.h            |   10 
>  include/linux/init_task.h         |    9 
>  include/linux/sched.h             |   36 ++
>  kernel/cgroup.c                   |  489 +++++++++++++++++++++++++++++++++-----
>  kernel/cgroup_freezer.c           |   26 --
>  kernel/cpuset.c                   |   96 +++----
>  kernel/fork.c                     |   10 
>  kernel/sched.c                    |   38 --
>  mm/memcontrol.c                   |   18 -
>  security/device_cgroup.c          |    3 
>  12 files changed, 594 insertions(+), 198 deletions(-)

So where are we up to with all this.

I'm surprised that none of the patches had anyone's Acked-by: or
Reviewed-by:.  Were they really that mean to you, or have you not been
tracking these?


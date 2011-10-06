Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab1JFGu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 02:50:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50642 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab1JFGu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 02:50:58 -0400
Message-ID: <4E8D500B.5030508@cn.fujitsu.com>
Date: Thu, 06 Oct 2011 14:51:55 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v6
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-06 14:49:16,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-06 14:49:22,
	Serialize complete at 2011-10-06 14:49:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Frederic Weisbecker (9):
>   cgroups: Add res_counter_write_u64() API
>   cgroups: New resource counter inheritance API
>   cgroups: Add previous cgroup in can_attach_task/attach_task callbacks
>   cgroups: New cancel_attach_task subsystem callback
>   cgroups: Ability to stop res charge propagation on bounded ancestor
>   res_counter: Allow charge failure pointer to be null
>   cgroups: Pull up res counter charge failure interpretation to caller
>   cgroups: Allow subsystems to cancel a fork
>   cgroups: Add a task counter subsystem
> 
> Kirill A. Shutemov (1):
>   cgroups: Add res counter common ancestor searching
> 
>  Documentation/cgroups/cgroups.txt          |   13 ++-
>  Documentation/cgroups/resource_counter.txt |   20 +++-
>  Documentation/cgroups/task_counter.txt     |  153 ++++++++++++++++++
>  block/blk-cgroup.c                         |   12 +-
>  include/linux/cgroup.h                     |   28 +++-
>  include/linux/cgroup_subsys.h              |    8 +
>  include/linux/res_counter.h                |   27 +++-
>  init/Kconfig                               |    9 +
>  kernel/Makefile                            |    1 +
>  kernel/cgroup.c                            |   58 ++++++--
>  kernel/cgroup_freezer.c                    |    9 +-
>  kernel/cgroup_task_counter.c               |  239 ++++++++++++++++++++++++++++
>  kernel/cpuset.c                            |    6 +-
>  kernel/events/core.c                       |    5 +-
>  kernel/exit.c                              |    2 +-
>  kernel/fork.c                              |    7 +-
>  kernel/res_counter.c                       |   97 ++++++++++--
>  kernel/sched.c                             |    6 +-
>  18 files changed, 644 insertions(+), 56 deletions(-)
>  create mode 100644 Documentation/cgroups/task_counter.txt
>  create mode 100644 kernel/cgroup_task_counter.c
> 

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

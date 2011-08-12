Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1HLVLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 17:11:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41324 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab1HLVLl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 17:11:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110801161900.1fe24b76.akpm@linux-foundation.org>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com> <20110801161900.1fe24b76.akpm@linux-foundation.org>
From: Tim Hockin <thockin@hockin.org>
Date: Fri, 12 Aug 2011 14:11:18 -0700
X-Google-Sender-Auth: VbXui_mS0ba92Qn6gWwH5-dMwzo
Message-ID: <CAAAKZwupGmw_+EaApZFAqVcXWBF885Gsjx6tUWUdMuebXrt_Mg@mail.gmail.com>
Subject: Re: [PATCH 0/8 v3] cgroups: Task counter subsystem (was: New max
 number of tasks subsystem)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 4:19 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 29 Jul 2011 18:13:22 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Reminder:
>>
>> This patchset is aimed at reducing the impact of a forkbomb to a
>> cgroup boundaries, thus minimizing the consequences of such an attack
>> against the rest of the system.
>>
>> This can be useful when cgroups are used to stage some processes or run
>> untrustees.
>
> Really?  How useful?  Why is it useful enough to justify adding code
> such as this to the kernel?
>
> Is forkbomb-prevention the only use?  Others have proposed different
> ways of preventing forkbombs which were independent of cgroups - is
> this way better and if so, why?

I certainly want this for exactly the proposed use - putting a bounds
on threads/tasks per container.  It's rlimits but more useful.

IMHO, most every limit that can be set at a system level should be
settable at a cgroup level.  This is just one more isolation leak.

>>  block/blk-cgroup.c            |   10 ++-
>>  include/linux/cgroup.h        |   15 +++-
>>  include/linux/cgroup_subsys.h |    8 ++
>>  include/linux/res_counter.h   |   12 +++
>>  init/Kconfig                  |    7 ++
>>  kernel/Makefile               |    1 +
>>  kernel/cgroup.c               |   25 ++++--
>>  kernel/cgroup_freezer.c       |    3 +-
>>  kernel/cgroup_task_counter.c  |  176 +++++++++++++++++++++++++++++++++++++++++
>>  kernel/cpuset.c               |    6 +-
>>  kernel/events/core.c          |    5 +-
>>  kernel/fork.c                 |    4 +
>>  kernel/res_counter.c          |   81 ++++++++++++++++---
>>  kernel/sched.c                |    6 +-
>
> The patch forgot to document the feature: how it works, what it's
> useful for, what behaviour users can expect to see, when they should
> consider using it, what the userspace control interface is and how to
> configure it, etc.  Documentation/cgroups/ is the place for that.

+1 - I am not very familiar with the cgroups code, so I am disinclined
to learn it all just to evaluate the functionality and API of this
patch.  Design doc, please?

Tim

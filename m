Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab2LKAvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 19:51:42 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:48881 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2LKAvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 19:51:41 -0500
MIME-Version: 1.0
In-Reply-To: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
Date: Tue, 11 Dec 2012 08:51:40 +0800
Message-ID: <CAGjg+kGAokK0oOAOJL=apkcyi_deqtHHsaJCViCz9tOMKG56bw@mail.gmail.com>
Subject: Re: [PATCH 0/18] sched: simplified fork, enable load average into LB
 and power awareness scheduling
From: Alex Shi <lkml.alex@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 4:22 PM, Alex Shi <alex.shi@intel.com> wrote:
> This patchset base on tip/sched/core tree temporary, since it is more
> steady than tip/master. and it's easy to rebase on tip/master.
>
> It includes 3 parts changes.
>
> 1, simplified fork, patch 1~4, that simplified the fork/exec/wake log in
> find_idlest_group and select_task_rq_fair. it can increase 10+%
> hackbench process and thread performance on our 4 sockets SNB EP machine.
>
> 2, enable load average into LB, patch 5~9, that using load average in
> load balancing, with a runnable load value industrialization bug fix and
> new fork task load contrib enhancement.
>
> 3, power awareness scheduling, patch 10~18,
> Defined 2 new power aware policy balance and
> powersaving, and then try to spread or shrink tasks on CPU unit
> according the different scheduler policy. That can save much power when
> task number in system is no more then cpu number.

tried with sysbench fileio test rndrw mode, with half thread of LCPU number,
performance is similar, power can save about 5~10 Watts on 2 sockets SNB EP
and NHM EP boxes.

Any comments :)
>
> Any comments are appreciated!
>
> Best regards!
> Alex
>
> [PATCH 01/18] sched: select_task_rq_fair clean up
> [PATCH 02/18] sched: fix find_idlest_group mess logical
> [PATCH 03/18] sched: don't need go to smaller sched domain
> [PATCH 04/18] sched: remove domain iterations in fork/exec/wake
> [PATCH 05/18] sched: load tracking bug fix
> [PATCH 06/18] sched: set initial load avg of new forked task as its
> [PATCH 07/18] sched: compute runnable load avg in cpu_load and
> [PATCH 08/18] sched: consider runnable load average in move_tasks
> [PATCH 09/18] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
> [PATCH 10/18] sched: add sched_policy in kernel
> [PATCH 11/18] sched: add sched_policy and it's sysfs interface
> [PATCH 12/18] sched: log the cpu utilization at rq
> [PATCH 13/18] sched: add power aware scheduling in fork/exec/wake
> [PATCH 14/18] sched: add power/performance balance allowed flag
> [PATCH 15/18] sched: don't care if the local group has capacity
> [PATCH 16/18] sched: pull all tasks from source group
> [PATCH 17/18] sched: power aware load balance,
> [PATCH 18/18] sched: lazy powersaving balance
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

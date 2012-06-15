Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab2FOSQC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 14:16:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45563 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab2FOSQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 14:16:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120316144240.889278872@chello.nl>
References: <20120316144028.036474157@chello.nl>
	<20120316144240.889278872@chello.nl>
Date: Fri, 15 Jun 2012 11:16:00 -0700
X-Google-Sender-Auth: 2jkXwFEZOjCz5SGexJ4gbFtwFeM
Message-ID: <CA+8MBbJVFdz0g9dqz+3YbsGypKw4-tLb2XgoFq=_qOoq_Yq=Tw@mail.gmail.com>
Subject: Re: [RFC][PATCH 12/26] sched, mm: sched_{fork,exec} node assignment
From: Tony Luck <tony.luck@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 7:40 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Rework the scheduler fork,exec hooks to allow home-node assignment.

Some compile errors on the (somewhat bizarre) CONFIG_SMP=n,
CONFIG_NUMA=y case:

> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> +
> +       select_task_node(p, p->mm, SD_BALANCE_FORK);
kernel/sched/core.c: In function ‘sched_fork’:
kernel/sched/core.c:1802: error: ‘SD_BALANCE_FORK’ undeclared (first
use in this function)

Also (from an earlier patch?)

In file included from kernel/sched/core.c:84:
kernel/sched/sched.h: In function ‘offnode_tasks’:
kernel/sched/sched.h:477: error: ‘struct rq’ has no member named ‘offnode_tasks’

-Tony

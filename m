Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab2CUWx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:53:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40612 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab2CUWx6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:53:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120316144028.036474157@chello.nl>
References: <20120316144028.036474157@chello.nl>
Date: Wed, 21 Mar 2012 15:53:56 -0700
Message-ID: <CAOhV88NafiU7hseTzQfApthMk3X=_GT09gEM2Zzx5OJ=8z6vvw@mail.gmail.com>
Subject: Re: [RFC][PATCH 00/26] sched/numa
From: Nish Aravamudan <nish.aravamudan@gmail.com>
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

Hi Peter,

Sorry if this has already been reported, but

On Fri, Mar 16, 2012 at 7:40 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> Hi All,
>
> While the current scheduler has knowledge of the machine topology, including
> NUMA (although there's room for improvement there as well [1]), it is
> completely insensitive to which nodes a task's memory actually is on.
>
> Current upstream task memory allocation prefers to use the node the task is
> currently running on (unless explicitly told otherwise, see
> mbind()/set_mempolicy()), and with the scheduler free to move the task about at
> will, the task's memory can end up being spread all over the machine's nodes.
>
> While the scheduler does a reasonable job of keeping short running tasks on a
> single node (by means of simply not doing the cross-node migration very often),
> it completely blows for long-running processes with a large memory footprint.
>
> This patch-set aims at improving this situation. It does so by assigning a
> preferred, or home, node to every process/thread_group. Memory allocation is
> then directed by this preference instead of the node the task might actually be
> running on momentarily. The load-balancer is also modified to prefer running
> the task on its home-node, although not at the cost of letting CPUs go idle or
> at the cost of execution fairness.
<snip>

>  [24/26] mm, mpol: Implement numa_group RSS accounting

I was going to try and test this on power, but it fails to build:

  mm/filemap_xip.c: In function ‘__xip_unmap’:
  mm/filemap_xip.c:199: error: implicit declaration of function
‘numa_add_vma_counter’

and I think


>  [26/26] sched, numa: A few debug bits

introduced a new warning:

  kernel/sched/numa.c: In function ‘process_cpu_runtime’:
  kernel/sched/numa.c:210: warning: format ‘%lu’ expects type ‘long
unsigned int’, but argument 3 has type ‘u64’
  kernel/sched/numa.c:210: warning: format ‘%lu’ expects type ‘long
unsigned int’, but argument 4 has type ‘u64’

Thanks,
Nish

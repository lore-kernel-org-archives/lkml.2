Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab1BCJUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 04:20:49 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46881 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab1BCJUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 04:20:47 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4D4A7330.6070306@jp.fujitsu.com>
Date: Thu, 03 Feb 2011 18:19:44 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ciju Rajan K <ciju@linux.vnet.ibm.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH 2/2 v2.0]sched: Updating the sched-stat documentation
References: <4D3F3595.4020607@linux.vnet.ibm.com> <4D3F3695.7070708@linux.vnet.ibm.com>
In-Reply-To: <4D3F3695.7070708@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/01/26 5:46), Ciju Rajan K wrote:
> sched: Updating the sched-stat documentation
>
> Some of the unused fields are removed from /proc/schedstat.
> This is the documentation changes reflecting the same.
>
> Signed-off-by: Ciju Rajan K<ciju@linux.vnet.ibm.com>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
>
> diff --git a/Documentation/scheduler/sched-stats.txt b/Documentation/scheduler/sched-stats.txt
> index 01e6940..28bee75 100644
> --- a/Documentation/scheduler/sched-stats.txt
> +++ b/Documentation/scheduler/sched-stats.txt
> @@ -26,119 +26,81 @@ Note that any such script will necessarily be version-specific, as the main
>   reason to change versions is changes in the output format.  For those wishing
>   to write their own scripts, the fields are described here.
>
> +The first two fields of /proc/schedstat indicates the version (current
> +version is 16) and jiffies values. The following values are from
> +cpu&  domain statistics.
> +
>   CPU statistics
>   --------------
> -cpu<N>  1 2 3 4 5 6 7 8 9 10 11 12
> -
> -NOTE: In the sched_yield() statistics, the active queue is considered empty
> -    if it has only one process in it, since obviously the process calling
> -    sched_yield() is that process.
> -
> -First four fields are sched_yield() statistics:
> -     1) # of times both the active and the expired queue were empty
> -     2) # of times just the active queue was empty
> -     3) # of times just the expired queue was empty
> -     4) # of times sched_yield() was called
> -
> -Next three are schedule() statistics:
> -     5) # of times we switched to the expired queue and reused it
> -     6) # of times schedule() was called
> -     7) # of times schedule() left the processor idle
> +The format is like this:
>
> -Next two are try_to_wake_up() statistics:
> -     8) # of times try_to_wake_up() was called
> -     9) # of times try_to_wake_up() was called to wake up the local cpu
> +cpu<N>  1 2 3 4 5 6 7 8
>
> -Next three are statistics describing scheduling latency:
> -    10) sum of all time spent running by tasks on this processor (in jiffies)
> -    11) sum of all time spent waiting to run by tasks on this processor (in
> -        jiffies)
> -    12) # of timeslices run on this cpu
> +     1) # of times sched_yield() was called on this CPU
> +     2) # of times scheduler runs on this CPU
> +     3) # of times scheduler picks idle task as next task on this CPU
> +     4) # of times try_to_wake_up() is run on this CPU
> +        (Number of times task wakeup is attempted from this CPU)
> +     5) # of times try_to_wake_up() wakes up a task on the same CPU
> +        (local wakeup)
> +     6) Time(ns) for which tasks have run on this CPU
> +     7) Time(ns) for which tasks on this CPU's runqueue have waited
> +        before getting to run on the CPU
> +     8) # of tasks that have run on this CPU
>
>
>   Domain statistics
>   -----------------
> -One of these is produced per domain for each cpu described. (Note that if
> -CONFIG_SMP is not defined, *no* domains are utilized and these lines
> -will not appear in the output.)
> +One of these is produced per domain for each cpu described.
> +(Note that if CONFIG_SMP is not defined, *no* domains are utilized
> + and these lines will not appear in the output.)
>
> -domain<N>  <cpumask>  1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36
> +domain<N>  <cpumask>  1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29
>
>   The first field is a bit mask indicating what cpus this domain operates over.
>
> -The next 24 are a variety of load_balance() statistics in grouped into types
> -of idleness (idle, busy, and newly idle):
> -
> -     1) # of times in this domain load_balance() was called when the
> -        cpu was idle
> -     2) # of times in this domain load_balance() checked but found
> -        the load did not require balancing when the cpu was idle
> -     3) # of times in this domain load_balance() tried to move one or
> -        more tasks and failed, when the cpu was idle
> -     4) sum of imbalances discovered (if any) with each call to
> -        load_balance() in this domain when the cpu was idle
> -     5) # of times in this domain pull_task() was called when the cpu
> -        was idle
> -     6) # of times in this domain pull_task() was called even though
> -        the target task was cache-hot when idle
> -     7) # of times in this domain load_balance() was called but did
> -        not find a busier queue while the cpu was idle
> -     8) # of times in this domain a busier queue was found while the
> -        cpu was idle but no busier group was found
> -
> -     9) # of times in this domain load_balance() was called when the
> -        cpu was busy
> -    10) # of times in this domain load_balance() checked but found the
> -        load did not require balancing when busy
> -    11) # of times in this domain load_balance() tried to move one or
> -        more tasks and failed, when the cpu was busy
> -    12) sum of imbalances discovered (if any) with each call to
> -        load_balance() in this domain when the cpu was busy
> -    13) # of times in this domain pull_task() was called when busy
> -    14) # of times in this domain pull_task() was called even though the
> -        target task was cache-hot when busy
> -    15) # of times in this domain load_balance() was called but did not
> -        find a busier queue while the cpu was busy
> -    16) # of times in this domain a busier queue was found while the cpu
> -        was busy but no busier group was found
> -
> -    17) # of times in this domain load_balance() was called when the
> -        cpu was just becoming idle
> -    18) # of times in this domain load_balance() checked but found the
> -        load did not require balancing when the cpu was just becoming idle
> -    19) # of times in this domain load_balance() tried to move one or more
> -        tasks and failed, when the cpu was just becoming idle
> -    20) sum of imbalances discovered (if any) with each call to
> -        load_balance() in this domain when the cpu was just becoming idle
> -    21) # of times in this domain pull_task() was called when newly idle
> -    22) # of times in this domain pull_task() was called even though the
> -        target task was cache-hot when just becoming idle
> -    23) # of times in this domain load_balance() was called but did not
> -        find a busier queue while the cpu was just becoming idle
> -    24) # of times in this domain a busier queue was found while the cpu
> -        was just becoming idle but no busier group was found
> -
> +The next 24 are a variety of load_balance() statistics grouped into
> +types of idleness (idle, busy, and newly idle). The three idle
> +states are:
> +
> +CPU_IDLE:          This state is entered after CPU_NEWLY_IDLE
> +                   state fails to find a new task for this CPU
> +CPU_NOT_IDLE:      Load balancer is being run on a CPU when it is
> +                   not in IDLE state (busy times)
> +CPU_NEWLY_IDLE:    Load balancer is being run on a CPU which is
> +                   about to enter IDLE state
> +
> +There are eight stats available for each of the above three states:
> +     - # of times in this domain load_balance() was called
> +     - # of times in this domain load_balance() checked but found
> +        the load did not require balancing
> +     - # of times in this domain load_balance() tried to move one or
> +        more tasks and failed
> +     - sum of imbalances discovered (if any) with each call to
> +        load_balance() in this domain
> +     - # of times in this domain pull_task() was called
> +     - # of times in this domain pull_task() was called even though
> +        the target task was cache-hot
> +     - # of times in this domain load_balance() was called but did
> +        not find a busier queue
> +     - # of times in this domain a busier queue was found but no
> +        busier group was found
> +
> +   The first 1-8) fields are the stats when cpu was idle (CPU_IDLE),
> +   the next 9-15) fields are the stats when cpu was busy (CPU_NOT_IDLE),
> +   and the next 16-24) fields are the stats when cpu  was just
> +   becoming idle (CPU_NEWLY_IDLE)
> +
>      Next three are active_load_balance() statistics:
>       25) # of times active_load_balance() was called
>       26) # of times active_load_balance() tried to move a task and failed
>       27) # of times active_load_balance() successfully moved a task
>
> -   Next three are sched_balance_exec() statistics:
> -    28) sbe_cnt is not used
> -    29) sbe_balanced is not used
> -    30) sbe_pushed is not used
> -
> -   Next three are sched_balance_fork() statistics:
> -    31) sbf_cnt is not used
> -    32) sbf_balanced is not used
> -    33) sbf_pushed is not used
> -
> -   Next three are try_to_wake_up() statistics:
> -    34) # of times in this domain try_to_wake_up() awoke a task that
> +   Next two are try_to_wake_up() statistics:
> +    28) # of times in this domain try_to_wake_up() awoke a task that
>           last ran on a different cpu in this domain
> -    35) # of times in this domain try_to_wake_up() moved a task to the
> +    29) # of times in this domain try_to_wake_up() moved a task to the
>           waking cpu because it was cache-cold on its own cpu anyway
> -    36) # of times in this domain try_to_wake_up() started passive balancing
>
>   /proc/<pid>/schedstat
>   ----------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>



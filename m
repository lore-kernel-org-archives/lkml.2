Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab1ASPsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:48:00 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:46441 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab1ASPr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:47:59 -0500
Message-ID: <4D3707A7.9050805@linux.vnet.ibm.com>
Date: Wed, 19 Jan 2011 21:17:51 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2 v1.0]sched: Updating the sched-stat documentation
References: <4D341ECD.3020503@linux.vnet.ibm.com> <1295283289.30950.172.camel@laptop> <4D352CA6.7010109@linux.vnet.ibm.com> <4D352D64.6020302@linux.vnet.ibm.com> <4D368EB8.5020605@jp.fujitsu.com>
In-Reply-To: <4D368EB8.5020605@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satoru,


>> +The first two fields of /proc/schedstat indicates the version (current
>> +version is 16) and jiffies values. The following values are from
>> +cpu& domain statistics.
> 
> cpu & domain statistics.
> 

Will correct it in the next version.


>> +
>> +CPU_NEWLY_IDLE: Load balancer is being run on a CPU which is
>> + about to enter IDLE state
>> +CPU_IDLE: This state is entered after CPU_NEWLY_IDLE
>> + state fails to find a new task for this CPU
>> +CPU_NOT_IDLE: Load balancer is being run on a CPU when it is
>> + not in IDLE state (busy times)
>> +
>> +There are eight stats available for each of the three idle states:
> 
> It's more helpful iffiled 1-8 are for CPU_NEWLY_IDLE, 9-15 are for
> CPU_IDLE, and 16-24 is for CPU_NOT_IDLE. Current description doesn't
> say whether
> 
> 1) lb_count[CPU_NEWLY_IDLE],
> 2) lb_balanced[CPU_NEWLY_IDLE],
> 3) lb_failed[CPU_NEWLY_IDLE],
> ...
> 
> or
> 
> 1) lb_count[CPU_NEWLY_IDLE]
> 2) lb_count[CPU_IDLE]
> 3) lb_count[CPU_NOT_IDLE]
> ...
> 
Agreed. There is a certain ambiguity there. I will find a better way
to mention it.

Thanks for reviewing this. I will send the next version soon.

-Ciju
> Thanks,
> Satoru
> 
>>
>> - 1) # of times in this domain load_balance() was called when the
>> - cpu was idle
>> + 1) # of times in this domain load_balance() was called
>> 2) # of times in this domain load_balance() checked but found
>> - the load did not require balancing when the cpu was idle
>> + the load did not require balancing
>> 3) # of times in this domain load_balance() tried to move one or
>> - more tasks and failed, when the cpu was idle
>> + more tasks and failed
>> 4) sum of imbalances discovered (if any) with each call to
>> - load_balance() in this domain when the cpu was idle
>> - 5) # of times in this domain pull_task() was called when the cpu
>> - was idle
>> + load_balance() in this domain
>> + 5) # of times in this domain pull_task() was called
>> 6) # of times in this domain pull_task() was called even though
>> - the target task was cache-hot when idle
>> + the target task was cache-hot
>> 7) # of times in this domain load_balance() was called but did
>> - not find a busier queue while the cpu was idle
>> - 8) # of times in this domain a busier queue was found while the
>> - cpu was idle but no busier group was found
>> -
>> - 9) # of times in this domain load_balance() was called when the
>> - cpu was busy
>> - 10) # of times in this domain load_balance() checked but found the
>> - load did not require balancing when busy
>> - 11) # of times in this domain load_balance() tried to move one or
>> - more tasks and failed, when the cpu was busy
>> - 12) sum of imbalances discovered (if any) with each call to
>> - load_balance() in this domain when the cpu was busy
>> - 13) # of times in this domain pull_task() was called when busy
>> - 14) # of times in this domain pull_task() was called even though the
>> - target task was cache-hot when busy
>> - 15) # of times in this domain load_balance() was called but did not
>> - find a busier queue while the cpu was busy
>> - 16) # of times in this domain a busier queue was found while the cpu
>> - was busy but no busier group was found
>> -
>> - 17) # of times in this domain load_balance() was called when the
>> - cpu was just becoming idle
>> - 18) # of times in this domain load_balance() checked but found the
>> - load did not require balancing when the cpu was just becoming idle
>> - 19) # of times in this domain load_balance() tried to move one or more
>> - tasks and failed, when the cpu was just becoming idle
>> - 20) sum of imbalances discovered (if any) with each call to
>> - load_balance() in this domain when the cpu was just becoming idle
>> - 21) # of times in this domain pull_task() was called when newly idle
>> - 22) # of times in this domain pull_task() was called even though the
>> - target task was cache-hot when just becoming idle
>> - 23) # of times in this domain load_balance() was called but did not
>> - find a busier queue while the cpu was just becoming idle
>> - 24) # of times in this domain a busier queue was found while the cpu
>> - was just becoming idle but no busier group was found
>> -
>> + not find a busier queue
>> + 8) # of times in this domain a busier queue was found but no
>> + busier group was found
>> +
>> Next three are active_load_balance() statistics:
>> 25) # of times active_load_balance() was called
>> 26) # of times active_load_balance() tried to move a task and failed
>> 27) # of times active_load_balance() successfully moved a task
>>
>> - Next three are sched_balance_exec() statistics:
>> - 28) sbe_cnt is not used
>> - 29) sbe_balanced is not used
>> - 30) sbe_pushed is not used
>> -
>> - Next three are sched_balance_fork() statistics:
>> - 31) sbf_cnt is not used
>> - 32) sbf_balanced is not used
>> - 33) sbf_pushed is not used
>> -
>> - Next three are try_to_wake_up() statistics:
>> - 34) # of times in this domain try_to_wake_up() awoke a task that
>> + Next two are try_to_wake_up() statistics:
>> + 28) # of times in this domain try_to_wake_up() awoke a task that
>> last ran on a different cpu in this domain
>> - 35) # of times in this domain try_to_wake_up() moved a task to the
>> + 29) # of times in this domain try_to_wake_up() moved a task to the
>> waking cpu because it was cache-cold on its own cpu anyway
>> - 36) # of times in this domain try_to_wake_up() started passive balancing
>>
>> /proc/<pid>/schedstat
>> ----------------
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at http://www.tux.org/lkml/
>>
>>
> 
> 

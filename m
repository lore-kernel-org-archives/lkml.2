Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab1FIDZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 23:25:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:7391 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab1FIDZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 23:25:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HxEURIx8UxgLqVzjS+I6v+7DDP9Q2FLPrsbWc3jNXhuIWQfehxgut7K7dkU9j5f+6d
         huovDbrxnwnKBqc49ldA==
MIME-Version: 1.0
In-Reply-To: <20110608163234.GA23031@linux.vnet.ibm.com>
References: <20110503092846.022272244@google.com> <20110607154542.GA2991@linux.vnet.ibm.com>
 <1307529966.4928.8.camel@dhcp-10-30-22-158.sw.ru> <20110608163234.GA23031@linux.vnet.ibm.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 8 Jun 2011 20:25:00 -0700
Message-ID: <BANLkTim7a9uhH_K6sw4YdqWB6frT+HUqqQ@mail.gmail.com>
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs unpinned
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Pavel Emelianov <xemul@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamalesh,

I'm unable to reproduce the results you describe.  One possibility is
load-balancer interaction -- can you describe the topology of the
platform you are running this on?

On both a straight NUMA topology and a hyper-threaded platform I
observe a ~4% delta between the pinned and un-pinned cases.

Thanks -- results below,

- Paul


16 cores -- pinned:
Average CPU Idle percentage 4.77419%
Bandwidth shared with remaining non-Idle 95.22581%
Bandwidth of Group 1 = 6.6300 i.e = 6.3100% of non-Idle CPU time 95.22581%
|...... subgroup 1/1    = 50.0400       i.e = 3.1500% of 6.3100%
Groups non-Idle CPU time
|...... subgroup 1/2    = 49.9500       i.e = 3.1500% of 6.3100%
Groups non-Idle CPU time


Bandwidth of Group 2 = 6.6300 i.e = 6.3100% of non-Idle CPU time 95.22581%
|...... subgroup 2/1    = 50.0300       i.e = 3.1500% of 6.3100%
Groups non-Idle CPU time
|...... subgroup 2/2    = 49.9600       i.e = 3.1500% of 6.3100%
Groups non-Idle CPU time


Bandwidth of Group 3 = 13.2000 i.e = 12.5600% of non-Idle CPU time 95.22581%
|...... subgroup 3/1    = 25.0200       i.e = 3.1400% of 12.5600%
Groups non-Idle CPU time
|...... subgroup 3/2    = 24.9500       i.e = 3.1300% of 12.5600%
Groups non-Idle CPU time
|...... subgroup 3/3    = 25.0400       i.e = 3.1400% of 12.5600%
Groups non-Idle CPU time
|...... subgroup 3/4    = 24.9700       i.e = 3.1300% of 12.5600%
Groups non-Idle CPU time


Bandwidth of Group 4 = 26.1500 i.e = 24.9000% of non-Idle CPU time 95.22581%
|...... subgroup 4/1    = 12.4700       i.e = 3.1000% of 24.9000%
Groups non-Idle CPU time
|...... subgroup 4/2    = 12.5500       i.e = 3.1200% of 24.9000%
Groups non-Idle CPU time
|...... subgroup 4/3    = 12.4600       i.e = 3.1000% of 24.9000%
Groups non-Idle CPU time
|...... subgroup 4/4    = 12.5000       i.e = 3.1100% of 24.9000%
Groups non-Idle CPU time
|...... subgroup 4/5    = 12.5400       i.e = 3.1200% of 24.9000%
Groups non-Idle CPU time
|...... subgroup 4/6    = 12.4700       i.e = 3.1000% of 24.9000%
Groups non-Idle CPU time
|...... subgroup 4/7    = 12.5200       i.e = 3.1100% of 24.9000%
Groups non-Idle CPU time
|...... subgroup 4/8    = 12.4600       i.e = 3.1000% of 24.9000%
Groups non-Idle CPU time


Bandwidth of Group 5 = 47.3600 i.e = 45.0900% of non-Idle CPU time 95.22581%
|...... subgroup 5/1    = 49.9600       i.e = 22.5200% of 45.0900%
Groups non-Idle CPU time
|...... subgroup 5/2    = 6.3600        i.e = 2.8600% of 45.0900%
Groups non-Idle CPU time
|...... subgroup 5/3    = 6.2400        i.e = 2.8100% of 45.0900%
Groups non-Idle CPU time
|...... subgroup 5/4    = 6.1900        i.e = 2.7900% of 45.0900%
Groups non-Idle CPU time
|...... subgroup 5/5    = 6.2700        i.e = 2.8200% of 45.0900%
Groups non-Idle CPU time
|...... subgroup 5/6    = 6.3400        i.e = 2.8500% of 45.0900%
Groups non-Idle CPU time
|...... subgroup 5/7    = 6.1900        i.e = 2.7900% of 45.0900%
Groups non-Idle CPU time
|...... subgroup 5/8    = 6.1500        i.e = 2.7700% of 45.0900%
Groups non-Idle CPU time
|...... subgroup 5/9    = 6.2600        i.e = 2.8200% of 45.0900%
Groups non-Idle CPU time
|...... subgroup 5/10   = 6.2800        i.e = 2.8300% of 45.0900%
Groups non-Idle CPU time
|...... subgroup 5/11   = 6.2800        i.e = 2.8300% of 45.0900%
Groups non-Idle CPU time
|...... subgroup 5/12   = 6.1400        i.e = 2.7600% of 45.0900%
Groups non-Idle CPU time
|...... subgroup 5/13   = 6.0900        i.e = 2.7400% of 45.0900%
Groups non-Idle CPU time
|...... subgroup 5/14   = 6.3000        i.e = 2.8400% of 45.0900%
Groups non-Idle CPU time
|...... subgroup 5/15   = 6.1600        i.e = 2.7700% of 45.0900%
Groups non-Idle CPU time
|...... subgroup 5/16   = 6.3400        i.e = 2.8500% of 45.0900%
Groups non-Idle CPU time

AMD 16 core -- pinned:
Average CPU Idle percentage 0%
Bandwidth shared with remaining non-Idle 100%
Bandwidth of Group 1 = 6.2800 i.e = 6.2800% of non-Idle CPU time 100%
|...... subgroup 1/1    = 50.0000       i.e = 3.1400% of 6.2800%
Groups non-Idle CPU time
|...... subgroup 1/2    = 49.9900       i.e = 3.1300% of 6.2800%
Groups non-Idle CPU time


Bandwidth of Group 2 = 6.2800 i.e = 6.2800% of non-Idle CPU time 100%
|...... subgroup 2/1    = 50.0000       i.e = 3.1400% of 6.2800%
Groups non-Idle CPU time
|...... subgroup 2/2    = 49.9900       i.e = 3.1300% of 6.2800%
Groups non-Idle CPU time


Bandwidth of Group 3 = 12.5500 i.e = 12.5500% of non-Idle CPU time 100%
|...... subgroup 3/1    = 25.0100       i.e = 3.1300% of 12.5500%
Groups non-Idle CPU time
|...... subgroup 3/2    = 25.0000       i.e = 3.1300% of 12.5500%
Groups non-Idle CPU time
|...... subgroup 3/3    = 24.9900       i.e = 3.1300% of 12.5500%
Groups non-Idle CPU time
|...... subgroup 3/4    = 24.9700       i.e = 3.1300% of 12.5500%
Groups non-Idle CPU time


Bandwidth of Group 4 = 25.0400 i.e = 25.0400% of non-Idle CPU time 100%
|...... subgroup 4/1    = 12.5000       i.e = 3.1300% of 25.0400%
Groups non-Idle CPU time
|...... subgroup 4/2    = 12.5000       i.e = 3.1300% of 25.0400%
Groups non-Idle CPU time
|...... subgroup 4/3    = 12.5000       i.e = 3.1300% of 25.0400%
Groups non-Idle CPU time
|...... subgroup 4/4    = 12.5000       i.e = 3.1300% of 25.0400%
Groups non-Idle CPU time
|...... subgroup 4/5    = 12.5000       i.e = 3.1300% of 25.0400%
Groups non-Idle CPU time
|...... subgroup 4/6    = 12.4900       i.e = 3.1200% of 25.0400%
Groups non-Idle CPU time
|...... subgroup 4/7    = 12.4900       i.e = 3.1200% of 25.0400%
Groups non-Idle CPU time
|...... subgroup 4/8    = 12.4800       i.e = 3.1200% of 25.0400%
Groups non-Idle CPU time


Bandwidth of Group 5 = 49.8200 i.e = 49.8200% of non-Idle CPU time 100%
|...... subgroup 5/1    = 49.9400       i.e = 24.8800% of 49.8200%
Groups non-Idle CPU time
|...... subgroup 5/2    = 6.2700        i.e = 3.1200% of 49.8200%
Groups non-Idle CPU time
|...... subgroup 5/3    = 6.2400        i.e = 3.1000% of 49.8200%
Groups non-Idle CPU time
|...... subgroup 5/4    = 6.2400        i.e = 3.1000% of 49.8200%
Groups non-Idle CPU time
|...... subgroup 5/5    = 6.2500        i.e = 3.1100% of 49.8200%
Groups non-Idle CPU time
|...... subgroup 5/6    = 6.2500        i.e = 3.1100% of 49.8200%
Groups non-Idle CPU time
|...... subgroup 5/7    = 6.2600        i.e = 3.1100% of 49.8200%
Groups non-Idle CPU time
|...... subgroup 5/8    = 6.2600        i.e = 3.1100% of 49.8200%
Groups non-Idle CPU time
|...... subgroup 5/9    = 6.2400        i.e = 3.1000% of 49.8200%
Groups non-Idle CPU time
|...... subgroup 5/10   = 6.2400        i.e = 3.1000% of 49.8200%
Groups non-Idle CPU time
|...... subgroup 5/11   = 6.2400        i.e = 3.1000% of 49.8200%
Groups non-Idle CPU time
|...... subgroup 5/12   = 6.2400        i.e = 3.1000% of 49.8200%
Groups non-Idle CPU time
|...... subgroup 5/13   = 6.2200        i.e = 3.0900% of 49.8200%
Groups non-Idle CPU time
|...... subgroup 5/14   = 6.2200        i.e = 3.0900% of 49.8200%
Groups non-Idle CPU time
|...... subgroup 5/15   = 6.2400        i.e = 3.1000% of 49.8200%
Groups non-Idle CPU time
|...... subgroup 5/16   = 6.2400        i.e = 3.1000% of 49.8200%
Groups non-Idle CPU time


16 core hyper-threaded subset of 24 core machine (threads not pinned
individually):

Average CPU Idle percentage 35.0645%
Bandwidth shared with remaining non-Idle 64.9355%
Bandwidth of Group 1 = 6.6000 i.e = 4.2800% of non-Idle CPU time 64.9355%
|...... subgroup 1/1    = 50.0600       i.e = 2.1400% of 4.2800%
Groups non-Idle CPU time
|...... subgroup 1/2    = 49.9300       i.e = 2.1300% of 4.2800%
Groups non-Idle CPU time


Bandwidth of Group 2 = 6.6000 i.e = 4.2800% of non-Idle CPU time 64.9355%
|...... subgroup 2/1    = 50.0100       i.e = 2.1400% of 4.2800%
Groups non-Idle CPU time
|...... subgroup 2/2    = 49.9800       i.e = 2.1300% of 4.2800%
Groups non-Idle CPU time


Bandwidth of Group 3 = 13.1600 i.e = 8.5400% of non-Idle CPU time 64.9355%
|...... subgroup 3/1    = 25.0200       i.e = 2.1300% of 8.5400%
Groups non-Idle CPU time
|...... subgroup 3/2    = 24.9900       i.e = 2.1300% of 8.5400%
Groups non-Idle CPU time
|...... subgroup 3/3    = 24.9900       i.e = 2.1300% of 8.5400%
Groups non-Idle CPU time
|...... subgroup 3/4    = 24.9900       i.e = 2.1300% of 8.5400%
Groups non-Idle CPU time


Bandwidth of Group 4 = 25.9700 i.e = 16.8600% of non-Idle CPU time 64.9355%
|...... subgroup 4/1    = 12.5000       i.e = 2.1000% of 16.8600%
Groups non-Idle CPU time
|...... subgroup 4/2    = 12.5100       i.e = 2.1000% of 16.8600%
Groups non-Idle CPU time
|...... subgroup 4/3    = 12.6000       i.e = 2.1200% of 16.8600%
Groups non-Idle CPU time
|...... subgroup 4/4    = 12.3800       i.e = 2.0800% of 16.8600%
Groups non-Idle CPU time
|...... subgroup 4/5    = 12.4700       i.e = 2.1000% of 16.8600%
Groups non-Idle CPU time
|...... subgroup 4/6    = 12.4900       i.e = 2.1000% of 16.8600%
Groups non-Idle CPU time
|...... subgroup 4/7    = 12.5700       i.e = 2.1100% of 16.8600%
Groups non-Idle CPU time
|...... subgroup 4/8    = 12.4400       i.e = 2.0900% of 16.8600%
Groups non-Idle CPU time


Bandwidth of Group 5 = 47.6500 i.e = 30.9400% of non-Idle CPU time 64.9355%
|...... subgroup 5/1    = 50.5400       i.e = 15.6300% of 30.9400%
Groups non-Idle CPU time
|...... subgroup 5/2    = 6.0400        i.e = 1.8600% of 30.9400%
Groups non-Idle CPU time
|...... subgroup 5/3    = 6.0600        i.e = 1.8700% of 30.9400%
Groups non-Idle CPU time
|...... subgroup 5/4    = 6.4300        i.e = 1.9800% of 30.9400%
Groups non-Idle CPU time
|...... subgroup 5/5    = 6.3100        i.e = 1.9500% of 30.9400%
Groups non-Idle CPU time
|...... subgroup 5/6    = 6.0000        i.e = 1.8500% of 30.9400%
Groups non-Idle CPU time
|...... subgroup 5/7    = 6.3100        i.e = 1.9500% of 30.9400%
Groups non-Idle CPU time
|...... subgroup 5/8    = 5.9800        i.e = 1.8500% of 30.9400%
Groups non-Idle CPU time
|...... subgroup 5/9    = 6.2900        i.e = 1.9400% of 30.9400%
Groups non-Idle CPU time
|...... subgroup 5/10   = 6.3300        i.e = 1.9500% of 30.9400%
Groups non-Idle CPU time
|...... subgroup 5/11   = 6.5200        i.e = 2.0100% of 30.9400%
Groups non-Idle CPU time
|...... subgroup 5/12   = 6.0500        i.e = 1.8700% of 30.9400%
Groups non-Idle CPU time
|...... subgroup 5/13   = 6.3500        i.e = 1.9600% of 30.9400%
Groups non-Idle CPU time
|...... subgroup 5/14   = 6.3500        i.e = 1.9600% of 30.9400%
Groups non-Idle CPU time
|...... subgroup 5/15   = 6.3400        i.e = 1.9600% of 30.9400%
Groups non-Idle CPU time
|...... subgroup 5/16   = 6.4200        i.e = 1.9800% of 30.9400%
Groups non-Idle CPU time


16 core hyper-threaded subset of 24 core machine (threads individually):

Average CPU Idle percentage 31.7419%
Bandwidth shared with remaining non-Idle 68.2581%
Bandwidth of Group 1 = 6.2700 i.e = 4.2700% of non-Idle CPU time 68.2581%
|...... subgroup 1/1    = 50.0100       i.e = 2.1300% of 4.2700%
Groups non-Idle CPU time
|...... subgroup 1/2    = 49.9800       i.e = 2.1300% of 4.2700%
Groups non-Idle CPU time


Bandwidth of Group 2 = 6.2700 i.e = 4.2700% of non-Idle CPU time 68.2581%
|...... subgroup 2/1    = 50.0100       i.e = 2.1300% of 4.2700%
Groups non-Idle CPU time
|...... subgroup 2/2    = 49.9800       i.e = 2.1300% of 4.2700%
Groups non-Idle CPU time


Bandwidth of Group 3 = 12.5300 i.e = 8.5500% of non-Idle CPU time 68.2581%
|...... subgroup 3/1    = 25.0100       i.e = 2.1300% of 8.5500%
Groups non-Idle CPU time
|...... subgroup 3/2    = 25.0000       i.e = 2.1300% of 8.5500%
Groups non-Idle CPU time
|...... subgroup 3/3    = 24.9900       i.e = 2.1300% of 8.5500%
Groups non-Idle CPU time
|...... subgroup 3/4    = 24.9800       i.e = 2.1300% of 8.5500%
Groups non-Idle CPU time


Bandwidth of Group 4 = 25.0200 i.e = 17.0700% of non-Idle CPU time 68.2581%
|...... subgroup 4/1    = 12.5100       i.e = 2.1300% of 17.0700%
Groups non-Idle CPU time
|...... subgroup 4/2    = 12.5000       i.e = 2.1300% of 17.0700%
Groups non-Idle CPU time
|...... subgroup 4/3    = 12.5000       i.e = 2.1300% of 17.0700%
Groups non-Idle CPU time
|...... subgroup 4/4    = 12.5000       i.e = 2.1300% of 17.0700%
Groups non-Idle CPU time
|...... subgroup 4/5    = 12.5000       i.e = 2.1300% of 17.0700%
Groups non-Idle CPU time
|...... subgroup 4/6    = 12.4900       i.e = 2.1300% of 17.0700%
Groups non-Idle CPU time
|...... subgroup 4/7    = 12.4900       i.e = 2.1300% of 17.0700%
Groups non-Idle CPU time
|...... subgroup 4/8    = 12.4800       i.e = 2.1300% of 17.0700%
Groups non-Idle CPU time


Bandwidth of Group 5 = 49.8900 i.e = 34.0500% of non-Idle CPU time 68.2581%
|...... subgroup 5/1    = 49.9600       i.e = 17.0100% of 34.0500%
Groups non-Idle CPU time
|...... subgroup 5/2    = 6.2600        i.e = 2.1300% of 34.0500%
Groups non-Idle CPU time
|...... subgroup 5/3    = 6.2600        i.e = 2.1300% of 34.0500%
Groups non-Idle CPU time
|...... subgroup 5/4    = 6.2500        i.e = 2.1200% of 34.0500%
Groups non-Idle CPU time
|...... subgroup 5/5    = 6.2500        i.e = 2.1200% of 34.0500%
Groups non-Idle CPU time
|...... subgroup 5/6    = 6.2500        i.e = 2.1200% of 34.0500%
Groups non-Idle CPU time
|...... subgroup 5/7    = 6.2500        i.e = 2.1200% of 34.0500%
Groups non-Idle CPU time
|...... subgroup 5/8    = 6.2500        i.e = 2.1200% of 34.0500%
Groups non-Idle CPU time
|...... subgroup 5/9    = 6.2400        i.e = 2.1200% of 34.0500%
Groups non-Idle CPU time
|...... subgroup 5/10   = 6.2400        i.e = 2.1200% of 34.0500%
Groups non-Idle CPU time
|...... subgroup 5/11   = 6.2400        i.e = 2.1200% of 34.0500%
Groups non-Idle CPU time
|...... subgroup 5/12   = 6.2400        i.e = 2.1200% of 34.0500%
Groups non-Idle CPU time
|...... subgroup 5/13   = 6.2400        i.e = 2.1200% of 34.0500%
Groups non-Idle CPU time
|...... subgroup 5/14   = 6.2400        i.e = 2.1200% of 34.0500%
Groups non-Idle CPU time
|...... subgroup 5/15   = 6.2300        i.e = 2.1200% of 34.0500%
Groups non-Idle CPU time
|...... subgroup 5/16   = 6.2300        i.e = 2.1200% of 34.0500%
Groups non-Idle CPU time

On Wed, Jun 8, 2011 at 9:32 AM, Kamalesh Babulal
<kamalesh@linux.vnet.ibm.com> wrote:
> * Vladimir Davydov <vdavydov@parallels.com> [2011-06-08 14:46:06]:
>
>> On Tue, 2011-06-07 at 19:45 +0400, Kamalesh Babulal wrote:
>> > Hi All,
>> >
>> >     In our test environment, while testing the CFS Bandwidth V6 patch set
>> > on top of 55922c9d1b84. We observed that the CPU's idle time is seen
>> > between 30% to 40% while running CPU bound test, with the cgroups tasks
>> > not pinned to the CPU's. Whereas in the inverse case, where the cgroups
>> > tasks are pinned to the CPU's, the idle time seen is nearly zero.
>>
>> (snip)
>>
>> > load_tasks()
>> > {
>> >         for (( i=1; i<=5; i++ ))
>> >         do
>> >                 jj=$(eval echo "\$NR_TASKS$i")
>> >                 shares="1024"
>> >                 if [ $PRO_SHARES -eq 1 ]
>> >                 then
>> >                         eval shares=$(echo "$jj * 1024" | bc)
>> >                 fi
>> >                 echo $hares > $MOUNT/$i/cpu.shares
>>                         ^^^^^
>>                         a fatal misprint? must be shares, I guess
>>
>> (Setting cpu.shares to "", i.e. to the minimal possible value, will
>> definitely confuse the load balancer)
>
> My bad. It was fatal typo, thanks for pointing it out. It made a big difference
> in the idle time reported. After correcting to $shares, now the CPU idle time
> reported is 20% to 22%. Which is 10% less from the previous reported number.
>
> (snip)
>
> There have been questions on how to interpret the results. Consider the
> following test run without pinning of the cgroups tasks
>
> Average CPU Idle percentage 20%
> Bandwidth shared with remaining non-Idle 80%
>
> Bandwidth of Group 1 = 7.9700% i.e = 6.3700% of non-Idle CPU time 80%
> |...... subgroup 1/1    = 50.0200       i.e = 3.1800% of 6.3700% Groups non-Idle CPU time
> |...... subgroup 1/2    = 49.9700       i.e = 3.1800% of 6.3700% Groups non-Idle CPU time
>
> For example let consider the cgroup1 and sum_exec time is the 7 field
> captured from the /proc/sched_debug
>
> while1 27273     30665.912793      1988   120     30665.912793  30909.566767         0.021951 /1/2
> while1 27272     30511.105690      1995   120     30511.105690  30942.998099         0.017369 /1/1
>                                                              -----------------
>
>                                                                61852.564866
>                                                              -----------------
>  - The bandwidth for sub-cgroup1 of cgroup1 is calculated  = (30909.566767 * 100) / 61852.564866
>                                                           = ~50%
>
>   and sub-cgroup2 of cgroup1 is calculated                = (30942.998099 * 100) / 61852.564866
>                                                           = ~50%
>
> In the similar way If we add up the sum_exec of all the groups its
> ------------------------------------------------------------------------------------------------
> Group1          Group2          Group3          Group4          Group5          sum_exec
> ------------------------------------------------------------------------------------------------
> 61852.564866 + 61686.604930 + 122840.294858 + 232576.303937 +296166.889155 =    775122.657746
>
> again taking the example of cgroup1
> Total percentage of bandwidth allocated to cgroup1 = (61852.564866 * 100) / 775122.657746
>                                                   = ~ 7.9% of total bandwidth of all the cgroups
>
>
> Calculating the non-idle time is done with
>        Total (execution time * 100) / (no of cpus * 60000 ms) [script is run for a 60 seconds]
>        i.e. = (775122.657746 * 100) / (16 * 60000)
>             = ~80% of non-idle time
>
> Percentage of bandwidth allocated to cgroup1 of the non-idle is derived as
>        = (cgroup bandwith percentage * non-idle time) / 100
>        = for cgroup1   = (7.9700 * 80) / 100
>                        = 6.376% bandwidth allocated of non-Idle CPU time.
>
>
> Bandwidth of Group 2 = 7.9500% i.e = 6.3600% of non-Idle CPU time 80%
> |...... subgroup 2/1    = 49.9900       i.e = 3.1700% of 6.3600% Groups non-Idle CPU time
> |...... subgroup 2/2    = 50.0000       i.e = 3.1800% of 6.3600% Groups non-Idle CPU time
>
>
> Bandwidth of Group 3 = 15.8400% i.e = 12.6700% of non-Idle CPU time 80%
> |...... subgroup 3/1    = 24.9900       i.e = 3.1600% of 12.6700% Groups non-Idle CPU time
> |...... subgroup 3/2    = 24.9900       i.e = 3.1600% of 12.6700% Groups non-Idle CPU time
> |...... subgroup 3/3    = 25.0600       i.e = 3.1700% of 12.6700% Groups non-Idle CPU time
> |...... subgroup 3/4    = 24.9400       i.e = 3.1500% of 12.6700% Groups non-Idle CPU time
>
>
> Bandwidth of Group 4 = 30.0000% i.e = 24.0000% of non-Idle CPU time 80%
> |...... subgroup 4/1    = 13.1600       i.e = 3.1500% of 24.0000% Groups non-Idle CPU time
> |...... subgroup 4/2    = 11.3800       i.e = 2.7300% of 24.0000% Groups non-Idle CPU time
> |...... subgroup 4/3    = 13.1100       i.e = 3.1400% of 24.0000% Groups non-Idle CPU time
> |...... subgroup 4/4    = 12.3100       i.e = 2.9500% of 24.0000% Groups non-Idle CPU time
> |...... subgroup 4/5    = 12.8200       i.e = 3.0700% of 24.0000% Groups non-Idle CPU time
> |...... subgroup 4/6    = 11.0600       i.e = 2.6500% of 24.0000% Groups non-Idle CPU time
> |...... subgroup 4/7    = 13.0600       i.e = 3.1300% of 24.0000% Groups non-Idle CPU time
> |...... subgroup 4/8    = 13.0600       i.e = 3.1300% of 24.0000% Groups non-Idle CPU time
>
>
> Bandwidth of Group 5 = 38.2000% i.e = 30.5600% of non-Idle CPU time 80%
> |...... subgroup 5/1    = 48.1000       i.e = 14.6900%  of 30.5600% Groups non-Idle CPU time
> |...... subgroup 5/2    = 6.7900        i.e = 2.0700%   of 30.5600% Groups non-Idle CPU time
> |...... subgroup 5/3    = 6.3700        i.e = 1.9400%   of 30.5600% Groups non-Idle CPU time
> |...... subgroup 5/4    = 5.1800        i.e = 1.5800%   of 30.5600% Groups non-Idle CPU time
> |...... subgroup 5/5    = 5.0400        i.e = 1.5400%   of 30.5600% Groups non-Idle CPU time
> |...... subgroup 5/6    = 10.1400       i.e = 3.0900%   of 30.5600% Groups non-Idle CPU time
> |...... subgroup 5/7    = 5.0700        i.e = 1.5400%   of 30.5600% Groups non-Idle CPU time
> |...... subgroup 5/8    = 6.3900        i.e = 1.9500%   of 30.5600% Groups non-Idle CPU time
> |...... subgroup 5/9    = 6.8800        i.e = 2.1000%   of 30.5600% Groups non-Idle CPU time
> |...... subgroup 5/10   = 6.4700        i.e = 1.9700%   of 30.5600% Groups non-Idle CPU time
> |...... subgroup 5/11   = 6.5600        i.e = 2.0000%   of 30.5600% Groups non-Idle CPU time
> |...... subgroup 5/12   = 4.6400        i.e = 1.4100%   of 30.5600% Groups non-Idle CPU time
> |...... subgroup 5/13   = 7.4900        i.e = 2.2800%   of 30.5600% Groups non-Idle CPU time
> |...... subgroup 5/14   = 5.8200        i.e = 1.7700%   of 30.5600% Groups non-Idle CPU time
> |...... subgroup 5/15   = 6.5500        i.e = 2.0000%   of 30.5600% Groups non-Idle CPU time
> |...... subgroup 5/16   = 5.2700        i.e = 1.6100%   of 30.5600% Groups non-Idle CPU time
>
> Thanks,
> Kamalesh.
>

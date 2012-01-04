Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab2ADIWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 03:22:34 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33046 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab2ADIWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 03:22:32 -0500
MIME-Version: 1.0
In-Reply-To: <CAKfTPtBwGXZmRtLXGiCBu7OBpQCSFZfQUqSZ9zKF1kJF+DQobg@mail.gmail.com>
References: <1323717668-2143-1-git-send-email-vincent.guittot@linaro.org>
	<1323943710.18942.24.camel@twins>
	<CAKfTPtB7Lib71iGrf=fGC5qtKFwD_qw3yz2OSkNy+CW7fCDtgw@mail.gmail.com>
	<1323997138.1984.274.camel@sbsiddha-desk.sc.intel.com>
	<CAKfTPtBwGXZmRtLXGiCBu7OBpQCSFZfQUqSZ9zKF1kJF+DQobg@mail.gmail.com>
Date: Wed, 4 Jan 2012 09:22:31 +0100
Message-ID: <CAKfTPtC7TcEN2q-4TRoBvjB4DTgYDjvxNgZYjc+fuH80BdDvaA@mail.gmail.com>
Subject: Re: [RFC] sched: Ensure cpu_power periodic update
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Does it sound good for you if I update the comment of this patch with
the explanation of the previous mails or do you need more information
?

Thanks,
Vincent

On 16 December 2011 09:23, Vincent Guittot <vincent.guittot@linaro.org> wrote:
> On 16 December 2011 01:58, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
>> On Thu, 2011-12-15 at 05:36 -0800, Vincent Guittot wrote:
>>> I'm using cyclictest to easily reproduce the problem on my dual cortex-A9
>>
>> So does the cyclictest itself exhibit the problem or running cyclictest
>> with another workload showed the problem? In other words, what numbers
>> of the workload did you see change with this patch?
>>
>
> Using a cyclictest -q -t 5 -D 4 on my dual cortex-A9 shows the fact
> that the softirqs timer and sched are not called very often and the
> cpu_power is nearly never updated.
>
> I have also used the following sequence :
>
> cyclictest -q -t 5 -D 4 &
> sleep 2
> cyclictest -q -t 3 --affinity=0 -p 99 -D 2
>
> The cpu_power of cpu0 should start to decrease when the rt threads are
> started. Without the patch, we must wait for the next sched softirq
> for starting to update the cpu_power and we have no guarantee of the
> maximum interval. With the patch, the cpu_power is updated regularly
> using the balance_interval value.
>
> Vincent
>
>>>
>>> > Then again, its probably easier to keep update_group_power on this_cpu
>>> > than to allow a remote update of your cpu_power.
>>> >
>>>
>>> This additional path for updating the cpu_power will only be used by
>>> this_cpu because it is called by idle_balance. But we still have a
>>> call to update_group_power by a remote cpu when nohz_idle_balance is
>>> called.
>>
>> As Vincent mentioned, the current mainline kernel already updates the
>> remote cpu's group_power in the nohz idle load balancing patch.
>>
>> Also with all the recent nohz idle load balancing using kick, on a
>> dual-core system there may not be any nohz idle load balancing if
>> multiple tasks wakeup, run for short time and go back to idle before the
>> next tick. We rely on the wakeup balance to get it right in this case.
>>
>> thanks,
>> suresh
>>

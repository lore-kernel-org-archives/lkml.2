Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab2HGFFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 01:05:53 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:52593 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab2HGFFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 01:05:51 -0400
Message-ID: <5020A220.2030305@linux.vnet.ibm.com>
Date: Tue, 07 Aug 2012 13:05:36 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: John Stultz <johnstul@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        paulmck@linux.vnet.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mingo@kernel.org, a.p.zijlstra@chello.nl, prarit@redhat.com,
        tglx@linutronix.de, Dave Jones <davej@redhat.com>
Subject: Re: rcu: INFO: rcu_preempt detected stalls on CPUs/tasks on v3.6
References: <500ED719.2010002@gmail.com> <50112D3B.4020201@redhat.com> <50127B16.5040401@gmail.com> <50153138.4020304@redhat.com> <5015A5A8.7030601@gmail.com> <50161D5E.4030009@redhat.com> <50165046.9020705@gmail.com> <501654D3.7020504@redhat.com> <50168162.4010508@gmail.com> <50168981.3000001@redhat.com> <501EA58D.4090606@gmail.com> <501FFD2A.4010905@us.ibm.com> <50200AEF.5080904@us.ibm.com> <50200CE6.70009@gmail.com> <50202987.80409@us.ibm.com> <50202A83.40705@gmail.com>
In-Reply-To: <50202A83.40705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12080705-3864-0000-0000-00000412C0C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 04:35 AM, Sasha Levin wrote:
> On 08/06/2012 10:31 PM, John Stultz wrote:
>> On 08/06/2012 11:28 AM, Sasha Levin wrote:
>>> On 08/06/2012 08:20 PM, John Stultz wrote:
>>>> On 08/06/2012 10:21 AM, John Stultz wrote:
>>>>> On 08/05/2012 09:55 AM, Sasha Levin wrote:
>>>>>> On 07/30/2012 03:17 PM, Avi Kivity wrote:
>>>>>>> Possible causes:
>>>>>>>    - the APIC calibration in the guest failed, so it is programming too
>>>>>>> low values into the timer
>>>>>>>    - it actually needs 1 us wakeups and then can't keep up (esp. as kvm
>>>>>>> interrupt injection is slowing it down)
>>>>>>>
>>>>>>> You can try to find out by changing
>>>>>>> arch/x86/kvm/lapic.c:start_lapic_timer() to impose a minimum wakeup of
>>>>>>> (say) 20 microseconds which will let the guest live long enough for you
>>>>>>> to ftrace it and see what kind of timers it is programming.
>>>>>> I've kept trying to narrow it down, and found out It's triggerable using adjtimex().
>>>> Sorry, one more question: Could you provide details on how is it trigger-able using adjtimex?
>>> It triggers after a while of fuzzing using trinity of just adjtimex ('./trinity --quiet -l off -cadjtimex').
>>>
>>> Trinity is available here: http://git.codemonkey.org.uk/?p=trinity.git .
>>>
>>> Let me know if I can help further with reproducing this, I can probably copy over my testing environment to some other host if you'd like.
>> So far no luck. Dmesg mostly just gets filled up with trinity-child OOMs.   How much memory are you running with?
>>
>> Are you running trinity as root or as some user that has CAP_SYS_TIME and can actually change values via adjtimex? Or does it trip just by reading the values?
> 
> As root in a disposable vm. It triggers at a random point, not after a specific call.

I have tested with a 3.6.0-rc1 guest again, running command:

./trinity --quiet -l off -cadjtimex --dangerous

for normal user:
	only oom info
for root:
	the guest hung without any stall info printed

I'm not sure how this trinity tool implemented, but at least it do help
to produce some rarely kernel bug...

And could you please also provide the way you start the guest? Is there
any special option?

Regards,
Michael Wang

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


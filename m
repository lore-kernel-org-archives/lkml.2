Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab2HFUeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:34:16 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:41737 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343Ab2HFUeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:34:15 -0400
Message-ID: <50202987.80409@us.ibm.com>
Date: Mon, 06 Aug 2012 13:31:03 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Avi Kivity <avi@redhat.com>, paulmck@linux.vnet.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mingo@kernel.org, a.p.zijlstra@chello.nl, prarit@redhat.com,
        tglx@linutronix.de, Dave Jones <davej@redhat.com>
Subject: Re: rcu: INFO: rcu_preempt detected stalls on CPUs/tasks on v3.6
References: <500ED719.2010002@gmail.com> <50112D3B.4020201@redhat.com> <50127B16.5040401@gmail.com> <50153138.4020304@redhat.com> <5015A5A8.7030601@gmail.com> <50161D5E.4030009@redhat.com> <50165046.9020705@gmail.com> <501654D3.7020504@redhat.com> <50168162.4010508@gmail.com> <50168981.3000001@redhat.com> <501EA58D.4090606@gmail.com> <501FFD2A.4010905@us.ibm.com> <50200AEF.5080904@us.ibm.com> <50200CE6.70009@gmail.com>
In-Reply-To: <50200CE6.70009@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080620-6078-0000-0000-00000DF251ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2012 11:28 AM, Sasha Levin wrote:
> On 08/06/2012 08:20 PM, John Stultz wrote:
>> On 08/06/2012 10:21 AM, John Stultz wrote:
>>> On 08/05/2012 09:55 AM, Sasha Levin wrote:
>>>> On 07/30/2012 03:17 PM, Avi Kivity wrote:
>>>>> Possible causes:
>>>>>    - the APIC calibration in the guest failed, so it is programming too
>>>>> low values into the timer
>>>>>    - it actually needs 1 us wakeups and then can't keep up (esp. as kvm
>>>>> interrupt injection is slowing it down)
>>>>>
>>>>> You can try to find out by changing
>>>>> arch/x86/kvm/lapic.c:start_lapic_timer() to impose a minimum wakeup of
>>>>> (say) 20 microseconds which will let the guest live long enough for you
>>>>> to ftrace it and see what kind of timers it is programming.
>>>> I've kept trying to narrow it down, and found out It's triggerable using adjtimex().
>> Sorry, one more question: Could you provide details on how is it trigger-able using adjtimex?
> It triggers after a while of fuzzing using trinity of just adjtimex ('./trinity --quiet -l off -cadjtimex').
>
> Trinity is available here: http://git.codemonkey.org.uk/?p=trinity.git .
>
> Let me know if I can help further with reproducing this, I can probably copy over my testing environment to some other host if you'd like.
So far no luck. Dmesg mostly just gets filled up with trinity-child 
OOMs.   How much memory are you running with?

Are you running trinity as root or as some user that has CAP_SYS_TIME 
and can actually change values via adjtimex? Or does it trip just by 
reading the values?

thanks
-john



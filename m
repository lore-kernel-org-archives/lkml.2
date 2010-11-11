Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab0KKLAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:00:34 -0500
Received: from mail.windriver.com ([147.11.1.11]:36984 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab0KKLAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:00:33 -0500
Message-ID: <4CDBCCC8.4030104@windriver.com>
Date: Thu, 11 Nov 2010 19:00:24 +0800
From: DDD <dongdong.deng@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: dzickus@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: avoid calling arch_trigger_all_cpu_backtrace() at
 the same time on SMP
References: <1289442042-2515-1-git-send-email-dongdong.deng@windriver.com> <20101111092301.GD18789@elte.hu> <4CDBBCA5.50306@windriver.com> <20101111100109.GB24558@elte.hu>
In-Reply-To: <20101111100109.GB24558@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Nov 2010 10:59:49.0766 (UTC) FILETIME=[8F7A6260:01CB818F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * DDD <dongdong.deng@windriver.com> wrote:
> 
>> Ingo Molnar wrote:
>>> * Dongdong Deng <dongdong.deng@windriver.com> wrote:
>>>
>>>> +static int backtrace_flag;
>>>> +	if (cmpxchg(&backtrace_flag, 0, 1) != 0)
>>> Sorry to be a PITA, but i asked for test_and_set() because that's
>>> the simplest primitive. cmpxchg() semantics is not nearly as
>>> obvious and people regularly get it wrong :-/
>> As the 'backtrace_flag' could be accessed by multi-cpus on SMP at
>> the same time, I use cmpxchg() for getting a atomic/memory barrier
>> operation for 'backtrace_flag' variable.
>>
>> If we use test_and_set, maybe we need smp_wmb() after test_and_set.
>> (If I wrong, please correct me, thanks. :-) )
> 
> No, test_and_set_bit() is SMP safe and is an implicit barrier as well - so no 
> smp_wmb() or other barriers are needed.

Yep, the spin_lock of test_and_set_bit() could make sure that.

Thank you very much,
I will send out the new patch quickly. :-)

Dongdong

> 
> Thanks,
> 
> 	Ingo
> 


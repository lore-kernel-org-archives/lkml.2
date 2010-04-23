Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab0DWT0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:26:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241Ab0DWTZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:25:59 -0400
Message-ID: <4BD1F43E.2080404@redhat.com>
Date: Fri, 23 Apr 2010 22:25:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Zachary Amsden <zamsden@redhat.com>, Glauber Costa <glommer@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271675100.1674.818.camel@laptop> <4BCC3A3E.9070909@redhat.com> <20100419142158.GD14158@mothafucka.localdomain> <4BCC69D5.3050209@redhat.com> <1271688411.1488.248.camel@laptop> <4BCC8246.9040202@goop.org> <4BCD748E.7080007@redhat.com> <4BCDF12C.1020702@goop.org> <4BCDF85C.3000004@redhat.com> <4BCE0399.2010708@goop.org> <20100422131113.GA3364@mothafucka.localdomain> <4BD0FB92.4060301@redhat.com> <4BD169B5.4000409@redhat.com> <4BD1F37A.6040801@goop.org>
In-Reply-To: <4BD1F37A.6040801@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2010 10:22 PM, Jeremy Fitzhardinge wrote:
> On 04/23/2010 02:34 AM, Avi Kivity wrote:
>    
>>> diff -rup a/time-warp-test.c b/time-warp-test.c
>>> --- a/time-warp-test.c    2010-04-15 16:30:13.955981607 -1000
>>> +++ b/time-warp-test.c    2010-04-15 16:35:37.777982377 -1000
>>> @@ -91,7 +91,7 @@ static inline unsigned long long __rdtsc
>>>    {
>>>        DECLARE_ARGS(val, low, high);
>>>
>>> -    asm volatile("cpuid; rdtsc" : EAX_EDX_RET(val, low, high));
>>> +    asm volatile("cpuid; rdtsc" : EAX_EDX_RET(val, low, high) ::
>>> "ebx", "ecx");
>>>
>>>
>>>        
>>
>> Plus, replace cpuid by lfence/mfence.  cpuid will trap.
>>      
> I presume the clobbers are needed for cpuid; if you use [lm]fence then
> they shouldn't be needed, right?
>
>    

Right.  But I'm not sure lfence/mfence are sufficient - from what I 
understand rdtsc can pass right through them.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.


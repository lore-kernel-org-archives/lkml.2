Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0DALNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 07:13:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab0DALNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:13:30 -0400
Message-ID: <4BB47FC3.1020606@redhat.com>
Date: Thu, 01 Apr 2010 14:13:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, aarcange@redhat.com,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in mmu_take_all_locks()
References: <1270117906.1653.139.camel@laptop> <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 02:04 PM, Thomas Gleixner wrote:
>>
>>> mmu_take_all_locks() takes a spinlock for each vma, which means we increase
>>> the preempt count by the number of vmas in an address space.  Since the user
>>> controls the number of vmas, they can cause preempt_count to overflow.
>>>
>>> Fix by making mmu_take_all_locks() only disable preemption once by making
>>> the spinlocks preempt-neutral.
>>>        
>> Right, so while this will get rid of the warning it doesn't make the
>> code any nicer, its still a massive !preempt latency spot.
>>      
> I'm not sure whether this is a real well done April 1st joke or if there
> is someone trying to secure the "bad taste patch of the month" price.
>    

I don't think a spin_lock_nested_while_preempt_disabled() is worthwhile 
for this.

> Anyway, I don't see a reason why we can't convert those locks to
> mutexes and get rid of the whole preempt disabled region.
>    

If someone is willing to audit all code paths to make sure these locks 
are always taken in schedulable context I agree that's a better fix.

-- 
error compiling committee.c: too many arguments to function


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381Ab0DAQiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:38:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758036Ab0DAQiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:38:04 -0400
Message-ID: <4BB4AACE.5080202@redhat.com>
Date: Thu, 01 Apr 2010 10:16:46 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, aarcange@redhat.com,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in mmu_take_all_locks()
References: <1270117906.1653.139.camel@laptop> <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 07:04 AM, Thomas Gleixner wrote:
> On Thu, 1 Apr 2010, Peter Zijlstra wrote:
>> I'm sure you dropped Ingo and Thomas by accident.
>>
>> On Thu, 2010-04-01 at 12:40 +0300, Avi Kivity wrote:
>>> mmu_take_all_locks() takes a spinlock for each vma, which means we increase
>>> the preempt count by the number of vmas in an address space.  Since the user
>>> controls the number of vmas, they can cause preempt_count to overflow.
>>>
>>> Fix by making mmu_take_all_locks() only disable preemption once by making
>>> the spinlocks preempt-neutral.
>>
>> Right, so while this will get rid of the warning it doesn't make the
>> code any nicer, its still a massive !preempt latency spot.
>
> I'm not sure whether this is a real well done April 1st joke or if there
> is someone trying to secure the "bad taste patch of the month" price.
>
> Anyway, I don't see a reason why we can't convert those locks to
> mutexes and get rid of the whole preempt disabled region.

That would involve converting most of the locks in mm/
to mutexes, since these two locks get nested under
all kinds of other spinlocks...


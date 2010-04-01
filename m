Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab0DALKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 07:10:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab0DALKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:10:12 -0400
Message-ID: <4BB47EEA.4070102@redhat.com>
Date: Thu, 01 Apr 2010 14:09:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       aarcange@redhat.com, akpm@linux-foundation.org,
       Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, tglx <tglx@linutronix.de>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in  mmu_take_all_locks()
References: <20100330133634.2f1bf3d6@cuia.bos.redhat.com>	 <1270114817-28896-1-git-send-email-avi@redhat.com> <1270117906.1653.139.camel@laptop>
In-Reply-To: <1270117906.1653.139.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 01:31 PM, Peter Zijlstra wrote:
> I'm sure you dropped Ingo and Thomas by accident.
>
> On Thu, 2010-04-01 at 12:40 +0300, Avi Kivity wrote:
>    
>> mmu_take_all_locks() takes a spinlock for each vma, which means we increase
>> the preempt count by the number of vmas in an address space.  Since the user
>> controls the number of vmas, they can cause preempt_count to overflow.
>>
>> Fix by making mmu_take_all_locks() only disable preemption once by making
>> the spinlocks preempt-neutral.
>>      
> Right, so while this will get rid of the warning it doesn't make the
> code any nicer, its still a massive !preempt latency spot.
>    

True.  But this is a band-aid we can apply now while the correct fix is 
being worked out.

-- 
error compiling committee.c: too many arguments to function


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab0DAQkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:40:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758436Ab0DAQj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:39:57 -0400
Message-ID: <4BB4BE44.5070507@redhat.com>
Date: Thu, 01 Apr 2010 18:39:48 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in mmu_take_all_locks()
References: <1270117906.1653.139.camel@laptop> <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain> <4BB47FC3.1020606@redhat.com> <1270120592.1653.192.camel@laptop> <20100401153645.GP5825@random.random>
In-Reply-To: <20100401153645.GP5825@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 06:36 PM, Andrea Arcangeli wrote:
> On Thu, Apr 01, 2010 at 01:16:32PM +0200, Peter Zijlstra wrote:
>    
>> On Thu, 2010-04-01 at 14:13 +0300, Avi Kivity wrote:
>>
>>      
>>> If someone is willing to audit all code paths to make sure these locks
>>> are always taken in schedulable context I agree that's a better fix.
>>>        
>> They had better be, they're not irq-safe. Also that's what lockdep is
>> for.
>>      
> In my original patchset I included patches from Christoph to convert
> those locks to mutexes, there was apparently no problem at all with
> that. But frankly I think the only problem here is the warning. The
> only compliant we ever had here is from developers, no users at
> all. If this was a practical problem I think we should have heard
> something by now with so many KVM users out there (and gru too).
>
> The only single reason I'd go for mutexes would be to accommodate
> XPMEM requirements once and for all, no other reason.
>    

There is also a minor benefit for kvm.  Reduced latency over large mmu 
operations; code simplification (we now have some 
copy_from_user_inatomic() that could be simplified).

-- 
error compiling committee.c: too many arguments to function


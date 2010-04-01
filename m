Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab0DAQiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:38:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758427Ab0DAQin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:38:43 -0400
Message-ID: <4BB4C0F5.3070204@redhat.com>
Date: Thu, 01 Apr 2010 18:51:17 +0300
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
References: <1270117906.1653.139.camel@laptop> <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain> <4BB47FC3.1020606@redhat.com> <4BB480CC.2060503@redhat.com> <1270121264.1653.205.camel@laptop> <1270122194.1653.223.camel@laptop> <20100401154249.GQ5825@random.random>
In-Reply-To: <20100401154249.GQ5825@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 06:42 PM, Andrea Arcangeli wrote:
> On Thu, Apr 01, 2010 at 01:43:14PM +0200, Peter Zijlstra wrote:
>    
>> On Thu, 2010-04-01 at 13:27 +0200, Peter Zijlstra wrote:
>>      
>>> I've almost got a patch done that converts those two, still need to look
>>> where that tasklist_lock muck happens.
>>>        
>> OK, so the below builds and boots, only need to track down that
>> tasklist_lock nesting, but I got to run an errand first.
>>      
> You should have a look at my old patchset where Christoph already
> implemented this (and not for decreasing latency but to allow
> scheduling in mmu notifier handlers, only needed by XPMEM):
>
> http://www.kernel.org/pub/linux/kernel/people/andrea/patches/v2.6/2.6.26-rc7/mmu-notifier-v18/
>
> The ugliest part of it (that I think you missed below) is the breakage
> of the RCU locking in the anon-vma which requires adding refcounting
> to it. That was the worst part of the conversion as far as I can tell.
>
> http://www.kernel.org/pub/linux/kernel/people/andrea/patches/v2.6/2.6.26-rc7/mmu-notifier-v18/anon-vma
>    

Can we use srcu now instead?

-- 
error compiling committee.c: too many arguments to function


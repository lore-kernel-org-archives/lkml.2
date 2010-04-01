Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab0DAQky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:40:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757943Ab0DAQkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:40:16 -0400
Message-ID: <4BB48127.9040709@redhat.com>
Date: Thu, 01 Apr 2010 14:19:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, aarcange@redhat.com,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in mmu_take_all_locks()
References: <1270117906.1653.139.camel@laptop>	 <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>	 <4BB47FC3.1020606@redhat.com> <1270120592.1653.192.camel@laptop>
In-Reply-To: <1270120592.1653.192.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 02:16 PM, Peter Zijlstra wrote:
> On Thu, 2010-04-01 at 14:13 +0300, Avi Kivity wrote:
>
>    
>> If someone is willing to audit all code paths to make sure these locks
>> are always taken in schedulable context I agree that's a better fix.
>>      
> They had better be, they're not irq-safe. Also that's what lockdep is
> for.
>    

I don't understand.  There are non-schedulable contexts (i.e. with a 
spinlock held) that are not irq contexts.

-- 
error compiling committee.c: too many arguments to function


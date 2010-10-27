Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761266Ab0J0Nm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:42:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:32855 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827Ab0J0Nmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:42:54 -0400
Message-ID: <4CC82C2F.1020707@kernel.org>
Date: Wed, 27 Oct 2010 15:42:07 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>	 <1288158182-1753-1-git-send-email-brgerst@gmail.com>	 <1288159670.2652.181.camel@edumazet-laptop>	 <1288173442.15336.1490.camel@twins> <1288186405.2709.117.camel@edumazet-laptop>
In-Reply-To: <1288186405.2709.117.camel@edumazet-laptop>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Oct 2010 13:42:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/27/2010 03:33 PM, Eric Dumazet wrote:
> Le mercredi 27 octobre 2010 à 11:57 +0200, Peter Zijlstra a écrit :
>> On Wed, 2010-10-27 at 08:07 +0200, Eric Dumazet wrote:
>>>> -     irqctx = &per_cpu(hardirq_stack, cpu);
>>>> +     irqctx = (union irq_ctx *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER);
>>>
>>> Hmm, then we lose NUMA affinity for stacks. 
>>
>> I guess we could use:
>>
>>   alloc_pages_node(cpu_to_node(cpu), THREAD_FLAGS, THREAD_ORDER);
>>
>>
> 
> Anyway, I just discovered per_cpu data on my machine (NUMA capable) all
> sit on a single node, if 32bit kernel used.
> 
> # cat /proc/buddyinfo 
> Node 0, zone      DMA      0      1      0      1      2      1      1      0      1      1      3 
> Node 0, zone   Normal     94    251     81     16      3      2      1      2      1      2    187 
> Node 0, zone  HighMem    113     88     47     36     18      5      4      3      2      0    268 
> Node 1, zone  HighMem    154     97     43     16      9      4      3      2      3      2    482 
...
> 
> I presume node 1 having only HighMem could be the reason ?

What does cpu_to_node() on each cpu say?  Also, do you know why
num_possible_cpus() is 32, not 16?

Thanks.

-- 
tejun

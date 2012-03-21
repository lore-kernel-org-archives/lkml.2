Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab2CUBlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 21:41:21 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:11979 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab2CUBlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 21:41:19 -0400
Message-ID: <4F693074.3010002@snapgear.com>
Date: Wed, 21 Mar 2012 11:35:48 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the tip tree with the m68knommu tree
References: <20120302134903.7992cf17cb0c50b9a2b3842c@canb.auug.org.au> <20120321113852.93618d6fa5977e9a71caa298@canb.auug.org.au>
In-Reply-To: <20120321113852.93618d6fa5977e9a71caa298@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 21/03/12 10:38, Stephen Rothwell wrote:
> Hi Greg, Geert,
>
> On Fri, 2 Mar 2012 13:49:03 +1100 Stephen Rothwell<sfr@canb.auug.org.au>  wrote:
>>
>> Today's linux-next merge of the tip tree got conflicts in
>> arch/m68k/kernel/process_no.c and arch/m68k/kernel/process_mm.c between
>> commit 8d8b74c955fd ("m68k: merge the MMU and non-MMU versions of
>> process.c") from the m68knommu tree and commit bd2f55361f18 ("sched/rt:
>> Use schedule_preempt_disabled()") from the tip tree.
>
> That tip tree commit is now in Linus' tree, so I am now applying the
> patch below after merging the m68knommu tree.

Looks good, thanks.

Regards
Greg



>> The former merged these two files into a single process.c, so I removed
>> them.  I then applied the following merge fix patch.
>>
>> From: Stephen Rothwell<sfr@canb.auug.org.au>
>> Date: Fri, 2 Mar 2012 13:43:03 +1100
>> Subject: [PATCH] sched/rt: Use schedule_preempt_disabled() in m68k
>>
>> Signed-off-by: Stephen Rothwell<sfr@canb.auug.org.au>
>> ---
>>   arch/m68k/kernel/process.c |    4 +---
>>   1 files changed, 1 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
>> index f053e24..c54ef927 100644
>> --- a/arch/m68k/kernel/process.c
>> +++ b/arch/m68k/kernel/process.c
>> @@ -78,9 +78,7 @@ void cpu_idle(void)
>>   	while (1) {
>>   		while (!need_resched())
>>   			idle();
>> -		preempt_enable_no_resched();
>> -		schedule();
>> -		preempt_disable();
>> +		schedule_preempt_disabled();
>>   	}
>>   }
>>
>> --
>> 1.7.9.1
>


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab1LFGJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 01:09:16 -0500
Received: from cpanel23.proisp.no ([88.87.44.74]:37804 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1LFGJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 01:09:15 -0500
Message-ID: <4EDDB184.6000901@numascale.com>
Date: Tue, 06 Dec 2011 07:09:08 +0100
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org, tglx@linutronix.de,
        daniel@numascale-asia.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86: Add NumaChip support
References: <1323101246-2400-1-git-send-email-daniel@numascale-asia.com> <tip-44b111b519160e33fdc41eadb39af86a24707edf@git.kernel.org> <20111205203130.GA12364@elte.hu> <4EDD5D77.3030101@numascale.com> <20111206055023.GB1580@elte.hu>
In-Reply-To: <20111206055023.GB1580@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/6/2011 06:50, Ingo Molnar wrote:
>
> * Steffen Persvold<sp@numascale.com>  wrote:
>
>> On 12/5/2011 21:31, Ingo Molnar wrote:
>> []
>>> There's a new build failure caused by this commit:
>>
>> It's this commit actually :
>>
>> Commit-ID:  64be4c1c2428e148de6081af235e2418e6a66dda
>> Gitweb:     http://git.kernel.org/tip/64be4c1c2428e148de6081af235e2418e6a66dda
>> Author:     Daniel J Blueman<daniel@numascale-asia.com>
>> AuthorDate: Mon, 5 Dec 2011 16:20:37 +0800
>> Committer:  Ingo Molnar<mingo@elte.hu>
>> CommitDate: Mon, 5 Dec 2011 17:17:21 +0100
>>
>> x86: Add x86_init platform override to fix up NUMA core numbering
>>
>>>
>>>    arch/x86/kernel/cpu/common.c:1149:2: error: ‘struct cpuinfo_x86’ has no member named ‘phys_proc_id’
>>>
>>> Note that the config is a !SMP one - that's probably the key
>>> detail.
>>
>> Yes, phys_proc_id in struct cpuinfo_x86 is covered within "ifdef CONFIG_SMP".
>>
>>>
>>> Please send a delta fix that resolves this bug. You can find the
>>> current lineup in:
>>>
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
>>>
>>
>> Will do, should be fairly simple. Something in the lines of the attached should work (tested).
>>
>> Note: I used "ifdef CONFIG_NUMA" simply because it doesn't make sense in a non-numa configuration even with SMP enabled. Besides, the only place where it is called right now is in kernel/cpu/amd.c:srat_detect_node() within the "CONFIG_NUMA" protected part.
>>
>> Cheers,
>> --
>> Steffen Persvold, Chief Architect NumaChip
>> Numascale AS - www.numascale.com
>> Tel: +47 92 49 25 54 Skype: spersvold
>
>> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
>> index ad4da45..a70bd5b 100644
>> --- a/arch/x86/kernel/cpu/common.c
>> +++ b/arch/x86/kernel/cpu/common.c
>> @@ -1146,7 +1146,9 @@ static void dbg_restore_debug_regs(void)
>>    */
>>   void __cpuinit x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int node)
>>   {
>> +#ifdef CONFIG_NUMA
>>   	pr_err("NUMA core number %d differs from configured core number %d\n", node, c->phys_proc_id);
>> +#endif
>>   }
>
> Yep, this should do the trick - i'll need a Signed-off-by line
> to apply it.

Signed-off-by: Steffen Persvold <sp@numascale.com>

Cheers,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold

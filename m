Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab1LHWfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 17:35:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63626 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab1LHWfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 17:35:09 -0500
MIME-Version: 1.0
In-Reply-To: <20111206055023.GB1580@elte.hu>
References: <1323101246-2400-1-git-send-email-daniel@numascale-asia.com>
	<tip-44b111b519160e33fdc41eadb39af86a24707edf@git.kernel.org>
	<20111205203130.GA12364@elte.hu>
	<4EDD5D77.3030101@numascale.com>
	<20111206055023.GB1580@elte.hu>
Date: Thu, 8 Dec 2011 18:35:06 -0400
Message-ID: <CAELBVzBqNHsnRP=dt7nwFWoigfX4FF6nQio+P+Fz71xQY0qK4Q@mail.gmail.com>
Subject: Re: [tip:x86/apic] x86: Add NumaChip support
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steffen Persvold <sp@numascale.com>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        tglx@linutronix.de, daniel@numascale-asia.com,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 December 2011 01:50, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Steffen Persvold <sp@numascale.com> wrote:
>
>> On 12/5/2011 21:31, Ingo Molnar wrote:
>> []
>> > There's a new build failure caused by this commit:
>>
>> It's this commit actually :
>>
>> Commit-ID:  64be4c1c2428e148de6081af235e2418e6a66dda
>> Gitweb:     http://git.kernel.org/tip/64be4c1c2428e148de6081af235e2418e6a66dda
>> Author:     Daniel J Blueman <daniel@numascale-asia.com>
>> AuthorDate: Mon, 5 Dec 2011 16:20:37 +0800
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> CommitDate: Mon, 5 Dec 2011 17:17:21 +0100
>>
>> x86: Add x86_init platform override to fix up NUMA core numbering
>>
>> >
>> >   arch/x86/kernel/cpu/common.c:1149:2: error: ‘struct cpuinfo_x86’ has no member named ‘phys_proc_id’
>> >
>> > Note that the config is a !SMP one - that's probably the key
>> > detail.
>>
>> Yes, phys_proc_id in struct cpuinfo_x86 is covered within "ifdef CONFIG_SMP".
>>
>> >
>> > Please send a delta fix that resolves this bug. You can find the
>> > current lineup in:
>> >
>> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
>> >
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
>>   */
>>  void __cpuinit x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int node)
>>  {
>> +#ifdef CONFIG_NUMA
>>       pr_err("NUMA core number %d differs from configured core number %d\n", node, c->phys_proc_id);
>> +#endif
>>  }
>
> Yep, this should do the trick - i'll need a Signed-off-by line
> to apply it.
>
> Ideally i think c->phys_proc_id should should be available
> regardless of CONFIG_SMP or CONFIG_NUMA considerations - but
> that would be a wider change. (feel free to have a shot at it
> though, in addition to the fix above)
>

If Steffen does not plan to do this additional cleanup, I would give
it a try.  You would likely prefer the changes against -tip, correct?

-- 
Kevin Winchester

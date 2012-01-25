Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab2AYKcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 05:32:23 -0500
Received: from service87.mimecast.com ([91.220.42.44]:55342 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab2AYKcV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 05:32:21 -0500
Message-ID: <4F1FDA04.6050804@arm.com>
Date: Wed, 25 Jan 2012 10:31:32 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/6] ARM: Remove the __ARCH_WANT_INTERRUPTS_ON_CTXSW
 definition
References: <1327081352-13178-1-git-send-email-catalin.marinas@arm.com> <1327310131.2446.1.camel@twins> <20120123092624.GA11983@arm.com> <20120123094759.GU1068@n2100.arm.linux.org.uk> <20120123095338.GB11983@arm.com> <20120124151434.GL19798@mudshark.cambridge.arm.com>
In-Reply-To: <20120124151434.GL19798@mudshark.cambridge.arm.com>
X-Enigmail-Version: 1.3.4
X-OriginalArrivalTime: 25 Jan 2012 10:31:33.0359 (UTC) FILETIME=[821937F0:01CCDB4C]
X-MC-Unique: 112012510315107301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/01/12 15:14, Will Deacon wrote:
> On Mon, Jan 23, 2012 at 09:53:38AM +0000, Catalin Marinas wrote:
>> On Mon, Jan 23, 2012 at 09:47:59AM +0000, Russell King - ARM Linux wrote:
>>> On Mon, Jan 23, 2012 at 09:26:24AM +0000, Catalin Marinas wrote:
>>>> On Mon, Jan 23, 2012 at 09:15:31AM +0000, Peter Zijlstra wrote:
>>>>> On Fri, 2012-01-20 at 17:42 +0000, Catalin Marinas wrote:
>>>>>> This is version 3 of the set of patches removing
>>>>>> __ARCH_WANT_INTERRUPTS_ON_CTXSW on ARM. The series was rebased on top of
>>>>>> 3.3-rc1 and fixed the conflicts with the kernel/sched/ changes and the
>>>>>> ARM LPAE patches. There are no functional changes from v2. I plan to
>>>>>> push this to -next and get it ready for 3.4-rc1.
>>>>>>
>>>>>> Question for Peter/Ingo - how do we merge the first patch that
>>>>>> introduces finish_arch_post_lock_switch? Do you pick it up or I can
>>>>>> merge it via rmk (with your ack)?
>>>>>
>>>>> I'm fine either way, I'll probably ask Ingo to pull your tree so that I
>>>>> can stack some other patches on top.
>>>>
>>>> In which case I would need Russell's acked-by.
>>>
>>> That depends on knowing what CPU architectures this has been tested on,
>>> and whether anyone external has tested it.  It's definitely a change
>>> which needs some tested-by tags on it.
>>
>> I agree. On my side, I tested it on:
>>
>> Versatile Express + Cortex-A9 (SMP configuration, ASIDs)
>> Versatile PB926 (UP configuration, no ASIDs)
> 
> For what it's worth, I've also tested this on:
> 
> Realview PB1176 (UP, ASIDs)
> Cortex-A5 (SMP, ASIDs)
> Cortex-A7 (SMP, ASIDs)
> 
> and I haven't seen any problems with native, parallel kernel builds. I don't
> have anything prior to ARMv5 available, but at least we seem to have covered
> v5-v7.

Probably redundant with the above, but nonetheless tested on:
Realview PB11MP (SMP, ASIDs)
Realview PBA8 (UP, ASIDs)
Panda OMAP4 (SMP, ASIDs)

using parallel kernel builds.

	M.
-- 
Jazz is not dead. It just smells funny...


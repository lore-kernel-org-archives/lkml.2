Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab0LIJXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:23:40 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45161 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab0LIJXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:23:37 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6191"; a="65911934"
Message-ID: <15d23d63900e4545a40555961c49c421.squirrel@codeaurora.org>
In-Reply-To: <4CFDD297.4020600@codeaurora.org>
References: <1291327879-28073-1-git-send-email-johlstei@codeaurora.org>
    <20101202221909.GK29347@n2100.arm.linux.org.uk>
    <4CF94DDD.8000409@codeaurora.org>
    <20101203203653.GB10245@n2100.arm.linux.org.uk>
    <4CFDD297.4020600@codeaurora.org>
Date: Thu, 9 Dec 2010 01:23:24 -0800 (PST)
Subject: Re: [PATCH] arm: dma-mapping: move consistent_init to 
     early_initcall
From: skannan@codeaurora.org
To: "Saravana Kannan" <skannan@codeaurora.org>
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        "Nicolas Pitre" <nico@marvell.com>, linux-kernel@vger.kernel.org,
        "Jeff Ohlstein" <johlstei@codeaurora.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        "Tejun Heo" <tj@kernel.org>, linux-arm-kernel@lists.infradead.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Russell King - ARM Linux wrote:
>> On Fri, Dec 03, 2010 at 12:06:53PM -0800, Saravana Kannan wrote:
>>> The MSM8660 SoC uses the TrustZone technology and the Linux kernel
>>> executes in normal/non-secure domain. When the second core is brought
>>> out of reset, it starts executing a secure image which then jumps to
>>> "secondary_startup". So, before bringing the second core out of reset,
>>> we need to inform the secure domain code where secondary_startup is
>>> located in memory.
>>>
>>> We do the communication with the secure code by using buffers in
>>> memory.
>>>  The cache treats the NS (non secure) bit as an additional address bit
>>> when tagging memory. Hence, cache accesses are not coherent between the
>>> secure and non-secure domains. So, the secure side flushes it's cache
>>> after writing to the buffer. To properly read the response from the
>>> secure side, the kernel has to pick a buffer that isn't cacheable in
>>> the
>>> first place. We have similar issues in the reverse direction.
>>
>> So when ARM gets DMA-coherent caches, you of course aren't going to
>> complain that the DMA APIs start avoiding doing the current tricks with
>> non-cacheable memory?
>>
>> I view what you're doing above with the DMA API as an abuse of the API.
>> Just like the problems we're facing with ioremap() being used on system
>> RAM, you're asking for problems when the ARM architecture changes
>> because
>> you're using an API for it's current properties, not for its purpose.
>
> You are right. Thanks for catching this.
>
> So, that basically leaves us with these options:
> * Create another API to allow getting uncached pages. I don't think we
> will be the first or the last to want uncached pages. Even if ARM
> introduces DMA-coherent caches, it's  possible for SoC vendors to have
> other h/w blocks that could directly operate on memory. The cache might
> not be coherent with these h/w blocks.
> * Add a cache invalidate API that's outside the DMA APIs and can be used
>   when needed.
>
> Do one of the above two options sound reasonable to you?
>
>> I've been on for years about purpose-designed APIs for cache issues,
>> and every time someone abuses them, they eventually end up suffering
>> breakage.
>>
>> Let's wait until the full set of patches is available before discussing
>> further.
>
> Jeff Ohlstein sent out a series of patches ([PATCH 0/5] SMP support for
> msm). The patch that deals with talking to the secure domain code is
> titled "[PATCH 2/5] msm: scm-boot: Support for setting cold/warm boot
> addresses". I see that you replied to an email on that, but it's not
> clear if you connected that patch with this thread.
>
> Thanks,
> Saravana
>

Russell, Have you had a chance to look at this? Any comments? How do we
move ahead?

Thanks,
Saravana
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.



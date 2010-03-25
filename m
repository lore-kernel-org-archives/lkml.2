Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0CYLsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 07:48:09 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38827 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab0CYLsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 07:48:07 -0400
Date: Thu, 25 Mar 2010 20:48:04 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH v2] PL330: Add PL330 DMA controller driver
In-reply-to: <3eeda0228e2396b052b17689e2f3318e@localhost>
To: Marc Zyngier <maz@misterjones.org>
Cc: linus.ml.walleij@gmail.com, dan.j.williams@intel.com,
       kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Message-id: <4BAB4D74.7070909@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
References: <4BAAD5BB.7050101@samsung.com>
 <20100325054430.165311fa@taxman.wild-wind.fr.eu.org>
 <4BAB264C.2090502@samsung.com> <960f4547118a62d5863ee38ba760844c@localhost>
 <4BAB357B.7040108@samsung.com> <3eeda0228e2396b052b17689e2f3318e@localhost>
X-OriginalArrivalTime: 25 Mar 2010 11:48:03.0982 (UTC)
 FILETIME=[072472E0:01CACC11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/2010 7:32 PM, Marc Zyngier wrote:
> On Thu, 25 Mar 2010 19:05:47 +0900, Joonyoung Shim
> <jy0922.shim@samsung.com> wrote:
>> On 3/25/2010 6:32 PM, Marc Zyngier wrote:
>>> On Thu, 25 Mar 2010 18:01:00 +0900, Joonyoung Shim
>>> <jy0922.shim@samsung.com> wrote:
>>>> On 3/25/2010 2:44 PM, Marc Zyngier wrote:
>>>>> On Thu, 25 Mar 2010 12:17:15 +0900
>>>>> Joonyoung Shim <jy0922.shim@samsung.com> wrote:
>>>>>
>>>>>> +	writew(imm, desc_pool_virt);
>>>> Right. The write[bwl] is api for address ioremapped of io device. I
> will
>>>> change these.
>>>>
>>>>> Does anything ensure that this won't generate an unaligned access?
>>>>>
>>>> PL330 DMA controller fetches variable length instructions that consist
>>> of
>>>> one to six bytes, so i think unaligned access is no problem.
>>> I'm not too concerned about the device side of things. I'm more worried
>>> about the CPU access when writing the 'imm' value to memory.
>>>
>>> Consider desc_pool_virt 16bit aligned when entering the function.
> Writing
>>> the opcode makes it unaligned and then writing the 'imm' value will
>>> result
>>> as an unaligned access.
>>>
>> Why desc_pool_virt should be aligned more than 16bit?
> 
> There is reason for desc_pool_virt to be 16bit aligned. It's just that you
> have 50% chance that it will.
> In such case, you will write 'imm' to a non 16bit-aligned address. In my
> book, that's bad.
> 
> Same for pl330_dmamov(), which tries to write a 32bit value without
> checking the proper alignment.
> In such case, please use the put_unaligned macro to handle the possible
> unaligned access.
> 

OK. i will use put_unaligned.
Thanks.

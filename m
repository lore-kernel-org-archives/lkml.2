Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0CYKPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:15:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:57925 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab0CYKPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:15:51 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Mar 2010 06:15:50 EDT
Date: Thu, 25 Mar 2010 19:05:47 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH v2] PL330: Add PL330 DMA controller driver
In-reply-to: <960f4547118a62d5863ee38ba760844c@localhost>
To: Marc Zyngier <maz@misterjones.org>
Cc: dan.j.williams@intel.com, linus.ml.walleij@gmail.com,
       kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Message-id: <4BAB357B.7040108@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
References: <4BAAD5BB.7050101@samsung.com>
 <20100325054430.165311fa@taxman.wild-wind.fr.eu.org>
 <4BAB264C.2090502@samsung.com> <960f4547118a62d5863ee38ba760844c@localhost>
X-OriginalArrivalTime: 25 Mar 2010 10:05:47.0523 (UTC)
 FILETIME=[BD871D30:01CACC02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/2010 6:32 PM, Marc Zyngier wrote:
> On Thu, 25 Mar 2010 18:01:00 +0900, Joonyoung Shim
> <jy0922.shim@samsung.com> wrote:
>> On 3/25/2010 2:44 PM, Marc Zyngier wrote:
>>> On Thu, 25 Mar 2010 12:17:15 +0900
>>> Joonyoung Shim <jy0922.shim@samsung.com> wrote:
>>>
>>>> +	writew(imm, desc_pool_virt);
>> Right. The write[bwl] is api for address ioremapped of io device. I will
>> change these.
>>
>>> Does anything ensure that this won't generate an unaligned access?
>>>
>> PL330 DMA controller fetches variable length instructions that consist
> of
>> one to six bytes, so i think unaligned access is no problem.
> 
> I'm not too concerned about the device side of things. I'm more worried
> about the CPU access when writing the 'imm' value to memory.
> 
> Consider desc_pool_virt 16bit aligned when entering the function. Writing
> the opcode makes it unaligned and then writing the 'imm' value will result
> as an unaligned access.
> 

Why desc_pool_virt should be aligned more than 16bit?

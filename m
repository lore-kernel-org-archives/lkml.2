Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab2AaF7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 00:59:41 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42380 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab2AaF7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 00:59:39 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6605"; a="156889355"
Message-ID: <4F278341.4020600@codeaurora.org>
Date: Tue, 31 Jan 2012 11:29:29 +0530
From: Ravi Kumar V <kumarrav@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: linux-arch@vger.kernel.org, tsoni@codeaurora.org, linux@arm.linux.org.uk,
        arnd@arndb.de, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, bryanh@codeaurora.org,
        johlstei@codeaurora.org, Daniel Walker <dwalker@fifo99.com>,
        dan.j.williams@intel.com, davidb@codeaurora.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/2] Add Qualcomm MSM ADM DMAEngine driver
References: <1325854052-21402-1-git-send-email-kumarrav@codeaurora.org> <1326807902.1540.116.camel@vkoul-udesk3> <4F195E4C.6080805@codeaurora.org> <1327066287.517.4.camel@vkoul-udesk3> <4F1D4052.3070701@codeaurora.org> <1327326713.517.32.camel@vkoul-udesk3> <4F1FFF7E.3000802@codeaurora.org> <1327911315.1527.8.camel@vkoul-udesk3>
In-Reply-To: <1327911315.1527.8.camel@vkoul-udesk3>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/30/2012 1:45 PM, Vinod Koul wrote:
> On Wed, 2012-01-25 at 18:41 +0530, Ravi Kumar V wrote:
>> On 1/23/2012 7:21 PM, Vinod Koul wrote:
>>> On Mon, 2012-01-23 at 16:41 +0530, Ravi Kumar V wrote:
>>>>
>>>> If some changes are made in interleave API then it can support our BOX
>>>> mode. Here in interleaved template he is assuming destination pattern as
>>>> can be contiguous or same as source pattern, but in our case destination
>>>> pattern is different from source pattern.
>>>> So if a new parameter destination data chunk is added in "struct
>>>> dma_interleaved_template" structure then it can support different
>>>> destination pattern.
>>> do you mean you have cases where you are doing a "memcpy" from one
>>> interleaved memory to another?
>>> Can you provide me with a scenario where this maybe helpful?
>>
>> Presently we are transferring data from interleaved memory tho
>> contagious memory and vice-verse.
>> We can use the interleaved API for present scenario, but it will
>> restrict the HW capability of transferring data from one interleaved
>> pattern to other interleaved pattern.
> That's interesting capability.
> My question still unanswered is whats the real work usage of this
> capability. Helps to understand what this would be used for and
> providing optimal solution
>>
>>>
>>> The reason why the API was designed like this was to give ability to
>>> take these kind of interleaved memory and copy them to peripheral
>>> (constant addr) or memory (typically contagious).
>>>
>>> In case it is just a pattern I wonder why it cannot be described in
>>> standard scatter gather definitions as you can split the block further
>>> down to copy from one respective block to somewhere else in memory.
>>
>> We can use scatter gather but it will be extra burden on software to
>> create those many SG list unlike in box mode just a single command
>> serves the purpose.
>>
>>>> Also it will good if you can provide another parameter for passing
>>>> private data to dma driver.
>>> 1. what does this parameter do?
>>
>> Private parameter in our case will be command configuration parameter
>> where we are passing information to HW like endianness, synchronization
>> &  acknowledge mechanism between DMA HW and peripherals running with
>> different clock than DMA.
> This is a separate discussion. We had similar talk on need to pass
> controller/subsystem specific parameters [1] sometime back during RIO
> patches. Alexandre has posted a new RFC [2] which should be extended to
> whatever API you finally end up using
>
> [1]: https://lkml.org/lkml/2011/10/24/275
> [2]: https://lkml.org/lkml/2012/1/26/405
>

Yes if we follow the above RFC and add extra context parameter also in 
device_prep_dma_sg() & device_prep_interleaved_dma() then it supports 
our hardware and our work will be completed.

can we follow above RFC and implement our driver.
Is above RFC finalized and included in mainline?

Thanks,
Ravi Kumar

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

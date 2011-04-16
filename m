Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932Ab1DPJ75 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 05:59:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60866 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1DPJ7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 05:59:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6317"; a="86172566"
Message-ID: <4DA96890.2070207@codeaurora.org>
Date: Sat, 16 Apr 2011 15:29:44 +0530
From: Murali Nalajala <mnalajal@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Dima Zavin <dima@android.com>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Subject: Re: [PATCH 2/2] mtd: msm_nand: Add initial msm nand driver support.
References: <1298940450-27365-1-git-send-email-mnalajal@codeaurora.org>	 <1298940450-27365-2-git-send-email-mnalajal@codeaurora.org>	 <1302861097.3220.12.camel@localhost>  <4DA85B24.50807@codeaurora.org> <1302942029.2308.1.camel@koala>
In-Reply-To: <1302942029.2308.1.camel@koala>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/2011 1:50 PM, Artem Bityutskiy wrote:
> On Fri, 2011-04-15 at 20:20 +0530, Murali Nalajala wrote:
>> On 4/15/2011 3:21 PM, Artem Bityutskiy wrote:
>>> On Tue, 2011-03-01 at 06:17 +0530, Murali Nalajala wrote:
>>>> +#define pr_fmt(fmt) "%s:" fmt, __func__
>>>> +
>>>> +#include<linux/kernel.h>
>>>> +#include<linux/mtd/mtd.h>
>>>> +#include<linux/mtd/nand.h>
>>>> +#include<linux/mtd/partitions.h>
>>>> +#include<linux/platform_device.h>
>>>> +#include<linux/sched.h>
>>>> +#include<linux/slab.h>
>>>> +#include<linux/dma-mapping.h>
>>>> +#include<asm/mach/flash.h>
>>>> +#include<mach/dma.h>
>>>> +
>>>> +#include "msm_nand.h"
>>>> +
>>>> +unsigned long msm_nand_phys;
>>>
>>> No global variables like this please. Here is how you use them:
>>>
>>> +extern unsigned long msm_nand_phys;
>>
>> extern declaration in the 'C' file causing warning. We are in plan to
>> upload the OneNAND changes soon which makes use of the same .h file.
>
> So you say that OneNAND (an independent driver) is going to use this
> variable? Are you also going to export it?

I haven't decided yet when oneNAND driver come in still it is under 
discussion. There is a chance that if OneNAND comes as an individual 
driver then i have to export this variable.

Can i export this variable now? What is your suggestion?

>
>>> +#define MSM_NAND_REG(off) (msm_nand_phys + (off))
>>> +
>>> +#define MSM_NAND_FLASH_CMD            MSM_NAND_REG(0x0000)
>>> +#define MSM_NAND_ADDR0                MSM_NAND_REG(0x0004)
>>>
>>> Could you please make the macros to take the "struct msm_nand_chip
>>> *chip" argument instead, and store the pase address there. Do not hide
>>> the fact that those macros are actually functions, not constant - this
>>> is error prone.
>>>
>>> Besides, I'm do not know your HW, but if you have several controllers
>>> with various base addresses - your driver won't work.
>>
>> you are correct, we have multiple controllers, which breaks this logic
>> in future.
>
> So then make your macros to accept the base address as an argument
> instead please.
>


Thanks,
Murali N

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

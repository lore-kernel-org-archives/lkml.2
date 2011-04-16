Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971Ab1DPKPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 06:15:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57606 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698Ab1DPKPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 06:15:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6317"; a="86173598"
Message-ID: <4DA96C24.707@codeaurora.org>
Date: Sat, 16 Apr 2011 15:45:00 +0530
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
References: <1298940450-27365-1-git-send-email-mnalajal@codeaurora.org>	 <1298940450-27365-2-git-send-email-mnalajal@codeaurora.org>	 <1302861097.3220.12.camel@localhost>  <4DA85B24.50807@codeaurora.org>	 <1302942029.2308.1.camel@koala> <1302942712.2308.3.camel@koala>
In-Reply-To: <1302942712.2308.3.camel@koala>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/2011 2:01 PM, Artem Bityutskiy wrote:
> On Sat, 2011-04-16 at 11:20 +0300, Artem Bityutskiy wrote:
>>>> +#define MSM_NAND_REG(off) (msm_nand_phys + (off))
>>>> +
>>>> +#define MSM_NAND_FLASH_CMD            MSM_NAND_REG(0x0000)
>>>> +#define MSM_NAND_ADDR0                MSM_NAND_REG(0x0004)
>>>>
>>>> Could you please make the macros to take the "struct msm_nand_chip
>>>> *chip" argument instead, and store the pase address there. Do not hide
>>>> the fact that those macros are actually functions, not constant - this
>>>> is error prone.
>>>>
>>>> Besides, I'm do not know your HW, but if you have several controllers
>>>> with various base addresses - your driver won't work.
>>>
>>> you are correct, we have multiple controllers, which breaks this logic
>>> in future.
>>
>> So then make your macros to accept the base address as an argument
>> instead please.
>
> Or better make macros to be constants, and always use something like
> base + MSM_NAND_FLASH_CMD - this is the standard approach.

Here all the registers expands to 'base + register offset'.
In the code we are directly using the macro names (these are register 
names on my controller) i.e. MSM_NAND_FLASH_CMD & MSM_NAND_ADDR0 without 
thinking of what the controller base is and what controller it is.

Currently, this code we have targeted for the single NAND controller 
solution for some of the MSM's. There are other targets which uses 
multiple NAND controllers which we haven't done much work yet to submit 
those patches.

Thanks,
Murali N

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

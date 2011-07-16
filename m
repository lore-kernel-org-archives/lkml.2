Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab1GPD6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 23:58:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36011 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab1GPD6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 23:58:02 -0400
X-AuditID: cbfee61a-b7cf0ae000006bc6-5d-4e210c4994f9
Date: Sat, 16 Jul 2011 12:58:25 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCHv3] ARM: EXYNOS4: Support for generic I/O power domains on
 EXYNOS4210
In-reply-to: <035201cc4367$2b165c80$81431580$%kim@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "'Rafael J. Wysocki'" <rjw@sisk.pl>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'MyungJoo Ham'" <myungjoo.ham@samsung.com>,
        "'Sylwester Nawrocki'" <snjw23@gmail.com>,
        linux-pm@lists.linux-foundation.org,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Message-id: <4E210C61.6060006@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
References: <4E165C64.8090808@samsung.com>
 <000e01cc3d2f$eca5d530$c5f17f90$%kim@samsung.com>
 <4E16A171.7040509@samsung.com>
 <035201cc4367$2b165c80$81431580$%kim@samsung.com>
X-OriginalArrivalTime: 16 Jul 2011 03:58:25.0924 (UTC)
 FILETIME=[9D2A8440:01CC436C]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin Kim wrote:
> Chanwoo Choi wrote:
>> Kukjin Kim wrote:
> 
> (snip)
> 
>>>> @@ -183,6 +183,7 @@ config MACH_NURI
>>>>  	select EXYNOS4_SETUP_SDHCI
>>>>  	select EXYNOS4_SETUP_USB_PHY
>>>>  	select SAMSUNG_DEV_PWM
>>>> +	select PM_GENERIC_DOMAINS if PM
>>> Do you _really_ think this should be under MACH_NURI?
>>>
>> This patch apply the generic power-domain to NURI board.
> 
> I mean, the PM_GENERIC_DOMAINS feature depends on CPU not board even though this is for only NURI board.
> 
OK, I will move it from CONFIG_MACH_NURI to CONFIG_CPU_EXYNOS4210 in arch/arm/mach-exynos4/Kconfig.

> (snip)
> 
>>>> diff --git a/arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
>>>> b/arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
>>>> new file mode 100644
>>>> index 0000000..ab09034
>>>> --- /dev/null
>>>> +++ b/arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
>>>> @@ -0,0 +1,53 @@
>>>> +/* linux/arch/arm/mach-exynos4/include/mach/pm-exynos4.h
>>> According to your file name, should be linux/arch/arm/mach-
>> exynos4/include/mach/pm-exynos4210.h ?
>>
> I said just typo...
> 
> +/* linux/arch/arm/mach-exynos4/include/mach/pm-exynos4210.h
> 
>> This patch support only power-domain of EXYNOS4210, so I named "pm-
>> exynos4210.h"
>> If EXYNOS4 series board will be released, I will modify include file name
>> from "pm-exynos4210.h" to "pm-exynos4.h" to support all EXYNOS4 series.
> 
> No need it, it's different.

My mistake. I will fix it.
> 
> (snip)
> 
>>> Would be better if you could add some common function for pd_power_up and
>> _down...
>>
>> What do you mean about common function?
>>
> I thought, pd_power_up and _down can be implemented in one function.
> 

OK, If you want to combine two function(pd_power_up and pd_power_down),
I will modify it.

> (snip)
> 
>>> I wonder why we need to add this for handling power domain not update current
>> pd.
>>
> See arch/arm/mach-exynos4/dev-pd.c
> 
> I mean, we _really_ need to keep duplication files for handling power domain?...

Now, you're right. 
But, If Generic Power-domain Framework will be applied to the mainline,
I think it necessary that we should apply Generic Power-domain Framework to all of 
the board using EXYNOS4210(arch/arm/mach-exynos4) and delete old power-domain
(arch/arm/mach-exynos4/dev-pd.c) to remove duplication file.

Thanks & Regards,
Chanwoo Choi






Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab1GFJJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 05:09:52 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4513 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab1GFJJt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 05:09:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 06 Jul 2011 02:09:34 -0700
Message-ID: <4E14264A.1070908@nvidia.com>
Date: Wed, 6 Jul 2011 18:09:30 +0900
From: Jinyoung Park <jinyoungp@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ko; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] backlight: aat2870: fix setting max_current
References: <1309941665.6088.9.camel@phoenix>
In-Reply-To: <1309941665.6088.9.camel@phoenix>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Axel

 > I make enum aat2870_current starting from 1 instead of adding a 
AAT2870_CURRENT_0_00,
 > because adding a AAT2870_CURRENT_0_00 may let people feel it is a 
valid setting for max_current.
I got it. There is no problem.

 > BTW, I don't have this device handy. can you help to test it?
Just now I have tested your change on real device and working fine as 
expected.

Tested-by: Jin Park <jinyoungp@nvidia.com>

Thanks,
Jin.

2011-07-06 오후 5:41, Axel Lin 쓴 글:
> 1. current implementation tests wrong value for setting aat2870_bl->max_current.
> 2. In current implementation, we cannot differentiate below 2 cases:
>         a) if pdata->max_current is not set , or
>         b) pdata->max_current is set to AAT2870_CURRENT_0_45 ( which is also 0 ).
>     fix it by setting AAT2870_CURRENT_0_45 to be 1 and adjust the equation
>     in aat2870_brightness() accordingly.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---
> hi Jin,
> I make enum aat2870_current starting from 1 instead of adding a AAT2870_CURRENT_0_00,
> because adding a AAT2870_CURRENT_0_00 may let people feel it is a valid setting for max_current.
>
> BTW, I don't have this device handy. can you help to test it?
> Thanks,
> Axel
>
>   drivers/video/backlight/aat2870_bl.c |    4 ++--
>   include/linux/mfd/aat2870.h          |    2 +-
>   2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/video/backlight/aat2870_bl.c b/drivers/video/backlight/aat2870_bl.c
> index 4952a61..c0e2ce7 100644
> --- a/drivers/video/backlight/aat2870_bl.c
> +++ b/drivers/video/backlight/aat2870_bl.c
> @@ -44,7 +44,7 @@ static inline int aat2870_brightness(struct aat2870_bl_driver_data *aat2870_bl,
>   	struct backlight_device *bd = aat2870_bl->bd;
>   	int val;
>
> -	val = brightness * aat2870_bl->max_current;
> +	val = brightness * (aat2870_bl->max_current - 1);
>   	val /= bd->props.max_brightness;
>
>   	return val;
> @@ -175,7 +175,7 @@ static int aat2870_bl_probe(struct platform_device *pdev)
>   	else
>   		aat2870_bl->channels = AAT2870_BL_CH_ALL;
>
> -	if (pdata->max_brightness>  0)
> +	if (pdata->max_current>  0)
>   		aat2870_bl->max_current = pdata->max_current;
>   	else
>   		aat2870_bl->max_current = AAT2870_CURRENT_27_9;
> diff --git a/include/linux/mfd/aat2870.h b/include/linux/mfd/aat2870.h
> index 89212df..f7316c2 100644
> --- a/include/linux/mfd/aat2870.h
> +++ b/include/linux/mfd/aat2870.h
> @@ -89,7 +89,7 @@ enum aat2870_id {
>
>   /* Backlight current magnitude (mA) */
>   enum aat2870_current {
> -	AAT2870_CURRENT_0_45,
> +	AAT2870_CURRENT_0_45 = 1,
>   	AAT2870_CURRENT_0_90,
>   	AAT2870_CURRENT_1_80,
>   	AAT2870_CURRENT_2_70,

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab1GFHus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 03:50:48 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:32980 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1GFHuq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 03:50:46 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <4E1411B1.8020102@nvidia.com>
References: <1309935342.6088.5.camel@phoenix> <4E1411B1.8020102@nvidia.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 6 Jul 2011 15:50:26 +0800
Message-ID: <CAF+7xW=M_PBQhyt3H450Lijo8uXyz+r0PQ0LHLqQ15z=6uBz2Q@mail.gmail.com>
Subject: Re: backlight: aat2870_bl: questions about setting max_current
To: Jinyoung Park <jinyoungp@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/6 Jinyoung Park <jinyoungp@nvidia.com>:
> Hi, Axel
>
>> 1. Seems the implementation tests wrong value for setting
>> aat2870_bl->max_current.
>>     I think you mean:
> Right, that's my mean. This is my mistyping bug.
>
>> 2. Even above issue is fixed, you still cannot differentiate below 2
>> cases:
>>          a) if pdata->max_current is not set , or
>>          b) pdata->max_current is set to AAT2870_CURRENT_0_45 ( which is
>> also 0 ).
>>     In either case, current implementation will set max_current to
>> AAT2870_CURRENT_27_9.
> I didn't find it when verifying driver on real device and my self review.
> Thanks for your kindly review.
>
> Below is fixed codes. How about this change?
It looks fine in fixing this issue.

Yet another question:
(Just a quick check at the datasheet.)
Why not just set max_current to AAT2870_CURRENT_27_9?
Why do you want max_current to be configurable by pdata?

Regards,
Axel
> If there is no problem, could you submit this change with first change as
> one patch?
> because two changes are related.
>
> diff --git a/drivers/video/backlight/aat2870_bl.c
> b/drivers/video/backlight/aat2870_bl.c
> index 4952a61..c0e2ce7 100644
> --- a/drivers/video/backlight/aat2870_bl.c
> +++ b/drivers/video/backlight/aat2870_bl.c
> @@ -44,7 +44,7 @@ static inline int aat2870_brightness(struct
> aat2870_bl_driver_data *aat2870_bl,
>        struct backlight_device *bd = aat2870_bl->bd;
>        int val;
>
> -       val = brightness * aat2870_bl->max_current;
> +       val = brightness * (aat2870_bl->max_current - 1);
>        val /= bd->props.max_brightness;
>
>        return val;
> diff --git a/include/linux/mfd/aat2870.h b/include/linux/mfd/aat2870.h
> index 89212df..f8b7e8e 100644
> --- a/include/linux/mfd/aat2870.h
> +++ b/include/linux/mfd/aat2870.h
> @@ -89,6 +89,7 @@ enum aat2870_id {
>
>  /* Backlight current magnitude (mA) */
>  enum aat2870_current {
> +       AAT2870_CURRENT_0_00,
>        AAT2870_CURRENT_0_45,
>        AAT2870_CURRENT_0_90,
>        AAT2870_CURRENT_1_80,
>
> Thanks,
> Jin.
>

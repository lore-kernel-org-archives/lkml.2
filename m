Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab1F3Hu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 03:50:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41920 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758528Ab1F3Huu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 03:50:50 -0400
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <004a01cc3662$65751a90$305f4fb0$%kim@samsung.com>
References: <20110620101737.GA31864@opensource.wolfsonmicro.com>
	<1308621527-2457-1-git-send-email-myungjoo.ham@samsung.com>
	<1308621527-2457-3-git-send-email-myungjoo.ham@samsung.com>
	<004a01cc3662$65751a90$305f4fb0$%kim@samsung.com>
Date: Thu, 30 Jun 2011 16:50:48 +0900
X-Google-Sender-Auth: cjj9-NimcJg3p_CgQmdT8LVWrJg
Message-ID: <BANLkTik-k+9=8coWpZO_zToYCm8iHfO3CQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] Samsung SoC ADC: Channel selection for S5PV210,
 S5PC110, and Exynos4
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, dg77.kim@samsung.com,
        =?UTF-8?B?7ZWo66qF7KO8?= <myungjoo.ham@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 10:42 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> MyungJoo Ham wrote:
>>
>> In S5PV210/S5PC110/Exynos4, ADCMUX channel selection uses ADCMUX
>> register, not ADCCON register. This patch corrects the behavior of
>> Samsung-ADC for such cpus.
>>
>> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> --
>> v2: No changes from v1. Resubmitted as a series of patches
>> ---
[]
>>
>>  enum s3c_cpu_type {
>>       TYPE_S3C24XX,
>> -     TYPE_S3C64XX
>> +     TYPE_S3C64XX,
>> +     TYPE_S5P,
>>  };
>
> How about S5PC100? Following is better for next if we cannot distinguish it
> by CPU.
>
> -enum s3c_cpu_type {
> -       TYPE_S3C24XX,
> -       TYPE_S3C64XX
> +enum samsung_adc_type {
> +       TYPE_ADC24,      /* S3C24XX */
> +       TYPE_ADC64,      /* S3C64XX, S5P64X0, S5PC100 */
> +       TYPE_ADCV3      /* S5PV210, EXYNOS4210 */
>  };
> ...
>
> TYPE_ADCV1 and V2?...
> Of course, the name can be changed...

I don't mind about these names as they are just internal values of adc.c.
Anyway, I prefer the last suggestion and I'll use TYPE_ADCV1/V2/V3.

Thanks.

-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858

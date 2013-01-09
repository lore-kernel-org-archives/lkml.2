Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab3AIEa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 23:30:58 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:62979 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab3AIEa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 23:30:56 -0500
MIME-Version: 1.0
In-Reply-To: <1357516522.4940.8.camel@joe-AO722>
References: <1353937640-9939-3-git-send-email-amit.kachhap@linaro.org>
	<1357516248-31350-1-git-send-email-amit.daniel@samsung.com>
	<1357516522.4940.8.camel@joe-AO722>
Date: Tue, 8 Jan 2013 20:30:55 -0800
Message-ID: <CADGdYn4CeWB5zHuHrfSLYsyOCA_zcSgm9LHTwtei1zAhfmDJNQ@mail.gmail.com>
Subject: Re: [PATCH 2/5 RESEND] thermal: exynos: Miscellaneous fixes to
 support falling threshold interrupt
From: amit kachhap <amit.kachhap@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-pm@lists.linux-foundation.org, linux-pm@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Thanks for the review. Will re-post with your suggestion,

On Sun, Jan 6, 2013 at 3:55 PM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2013-01-06 at 15:50 -0800, Amit Daniel Kachhap wrote:
>> Below fixes are done to support falling threshold interrupt,
>> * Falling interrupt status macro corrected according to exynos5 data sheet.
>> * The get trend function modified to calculate trip temperature correctly.
>> * The clearing of interrupt status in the isr is now done after handling
>>   the event that caused the interrupt.
> []
>> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
> []
>> @@ -373,12 +373,19 @@ static int exynos_get_temp(struct thermal_zone_device *thermal,
>>  static int exynos_get_trend(struct thermal_zone_device *thermal,
>>                       int trip, enum thermal_trend *trend)
>>  {
>> -     if (thermal->temperature >= trip)
>> +     int ret = 0;
Yes agreed. Will modify it.
>
> Unnecessary initialization
>
>> +     unsigned long trip_temp;
>> +
>> +     ret = exynos_get_trip_temp(thermal, trip, &trip_temp);
>> +     if (ret < 0)
>> +             return ret;
>> +
>> +     if (thermal->temperature >= trip_temp)
>>               *trend = THERMAL_TREND_RAISING;
>>       else
>>               *trend = THERMAL_TREND_DROPPING;
>
> THERMAL_TREND_STABLE ?
Only 2 trend is sufficient. It is stable for some time as the falling
threshold interrupt is some units below the trip temp.
>
>>
>> -     return 0;
>> +     return ret;
Ok agreed
>
> return 0 is clearer.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

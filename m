Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab2I0LVa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:21:30 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:39039 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab2I0LV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:21:29 -0400
MIME-Version: 1.0
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB591D41F5@BGSMSX101.gar.corp.intel.com>
References: <1348743492-30852-1-git-send-email-sachin.kamat@linaro.org>
	<4D68720C2E767A4AA6A8796D42C8EB591D41F5@BGSMSX101.gar.corp.intel.com>
Date: Thu, 27 Sep 2012 16:51:29 +0530
Message-ID: <CAK9yfHxhpp66QsiXQOYEGN+wQ7k73Yi--41biPFS+WvkwWTx1A@mail.gmail.com>
Subject: Re: [PATCH] thermal: step_wise: Add missing static storage class specifiers
From: Sachin Kamat <sachin.kamat@linaro.org>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "patches@linaro.org" <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 September 2012 16:45, R, Durgadoss <durgadoss.r@intel.com> wrote:
>> -----Original Message-----
>> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
>> Sent: Thursday, September 27, 2012 4:28 PM
>> To: linux-kernel@vger.kernel.org
>> Cc: R, Durgadoss; Zhang, Rui; sachin.kamat@linaro.org; patches@linaro.org
>> Subject: [PATCH] thermal: step_wise: Add missing static storage class
>> specifiers
>>
>> Fixes the following sparse warnings:
>> drivers/thermal/step_wise.c:153:5: warning:
>> symbol 'step_wise_throttle' was not declared. Should it be static?
>> drivers/thermal/step_wise.c:172:25: warning:
>> symbol 'thermal_gov_step_wise' was not declared. Should it be static?
>
> Looks fine.
> Acked-by: Durgadoss R <durgadoss.r@intel.com>
>
> Care to fix the same things in fair_share.c and user_space.c ?

Sure. Right away :)

>
> Thanks,
> Durga
>
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  drivers/thermal/step_wise.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
>> index 3f9cfcf..1242cff 100644
>> --- a/drivers/thermal/step_wise.c
>> +++ b/drivers/thermal/step_wise.c
>> @@ -150,7 +150,7 @@ static void thermal_zone_trip_update(struct
>> thermal_zone_device *tz, int trip)
>>   * step. If the zone is 'cooling down' it brings back the performance of
>>   * the devices by one step.
>>   */
>> -int step_wise_throttle(struct thermal_zone_device *tz, int trip)
>> +static int step_wise_throttle(struct thermal_zone_device *tz, int trip)
>>  {
>>       struct thermal_instance *instance;
>>
>> @@ -169,7 +169,7 @@ int step_wise_throttle(struct thermal_zone_device
>> *tz, int trip)
>>       return 0;
>>  }
>>
>> -struct thermal_governor thermal_gov_step_wise = {
>> +static struct thermal_governor thermal_gov_step_wise = {
>>       .name           = DEFAULT_THERMAL_GOVERNOR,
>>       .throttle       = step_wise_throttle,
>>       .owner          = THIS_MODULE,
>> --
>> 1.7.4.1
>



-- 
With warm regards,
Sachin

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab2CVFKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 01:10:22 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49714 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab2CVFKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 01:10:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120321151357.53fb86e4@endymion.delvare>
References: <1332328201-21191-1-git-send-email-amit.kachhap@linaro.org>
	<20120321151357.53fb86e4@endymion.delvare>
Date: Thu, 22 Mar 2012 10:40:17 +0530
Message-ID: <CAK44p22JK+DkbrTwCSU1OCkkC=sHrWeFfEmTE8Km3=dZm4T-aQ@mail.gmail.com>
Subject: Re: [PATCH] thermal: Fix for setting the thermal zone mode to enable/disable
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 March 2012 19:43, Jean Delvare <khali@linux-fr.org> wrote:
> On Wed, 21 Mar 2012 16:40:01 +0530, Amit Daniel Kachhap wrote:
>> Basically without this patch changing the mode of thermal zone
>> is not possible as wrong string size is passed to strncmp.
>
> Actually it is possible,
> $ echo -n disabled > mode
> works fine. But it fails without the -n, your patch would fix that.
Thanks for pointing this out. Anyway this patch makes some sense until
sysfs takes care of this.
>
> Acked-by: Jean Delvare <khali@linux-fr.org>
>
> Note that a quick grep suggests that drivers/misc/ad525x_dpot.c,
> security/selinux/hooks.c and arch/m68k/sun3/prom/console.c suffer from
> the same issue, if you want to fix them too.
>
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
>> ---
>>  drivers/thermal/thermal_sys.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
>> index 220ce7e..96da1af 100644
>> --- a/drivers/thermal/thermal_sys.c
>> +++ b/drivers/thermal/thermal_sys.c
>> @@ -152,9 +152,9 @@ mode_store(struct device *dev, struct device_attribute *attr,
>>       if (!tz->ops->set_mode)
>>               return -EPERM;
>>
>> -     if (!strncmp(buf, "enabled", sizeof("enabled")))
>> +     if (!strncmp(buf, "enabled", sizeof("enabled") - 1))
>>               result = tz->ops->set_mode(tz, THERMAL_DEVICE_ENABLED);
>> -     else if (!strncmp(buf, "disabled", sizeof("disabled")))
>> +     else if (!strncmp(buf, "disabled", sizeof("disabled") - 1))
>>               result = tz->ops->set_mode(tz, THERMAL_DEVICE_DISABLED);
>>       else
>>               result = -EINVAL;
>
>
> --
> Jean Delvare

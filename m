Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab1LAI0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 03:26:06 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35218 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676Ab1LAI0E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 03:26:04 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <4ED734AD.1070303@compulab.co.il>
References: <1322704074.11560.3.camel@phoenix> <1322704507.11560.8.camel@phoenix>
 <4ED734AD.1070303@compulab.co.il>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 1 Dec 2011 16:18:35 +0800
Message-ID: <CAF+7xWnf398rY_Lb8CexjZDtcp8poseQc11S-14xyNSVGDdJWw@mail.gmail.com>
Subject: Re: [PATCH 4/4] mfd: twl6040-core: Use gpio_request_one
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, Misael Lopez Cruz <misael.lopez@ti.com>,
        Jorge Eduardo Candelaria <jorge.candelaria@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/1 Igor Grinberg <grinberg@compulab.co.il>:
> On 12/01/11 03:55, Axel Lin wrote:
>> Use gpio_request_one() instead of multiple gpiolib calls.
>>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> ---
>>  drivers/mfd/twl6040-core.c |    7 ++-----
>>  1 files changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
>> index 268f80f..e57b1d1 100644
>> --- a/drivers/mfd/twl6040-core.c
>> +++ b/drivers/mfd/twl6040-core.c
>> @@ -509,13 +509,10 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
>>               twl6040->audpwron = -EINVAL;
>>
>>       if (gpio_is_valid(twl6040->audpwron)) {
>> -             ret = gpio_request(twl6040->audpwron, "audpwron");
>> +             ret = gpio_request_one(twl6040->audpwron, GPIOF_OUT_INIT_LOW,
>> +                                    "audpwron");
>>               if (ret)
>>                       goto gpio1_err;
>> -
>> -             ret = gpio_direction_output(twl6040->audpwron, 0);
>> -             if (ret)
>> -                     goto gpio2_err;
>>       }
>
> same here, double check gpio_is_valid()?

In the case of
twl6040->audpwron = -EINVAL;  ( see line 509 )
gpio_is_valid returns false, we just don't request gpio.

If we remove the gpio_is_valid checking here,
then gpio_request_one will return -EINVAL.
Then the code always goes to the error path if twl6040->audpwron is -EINVAL.

Axel
>
>
> --
> Regards,
> Igor.

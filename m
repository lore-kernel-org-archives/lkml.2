Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab1DLETs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 00:19:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:30200 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab1DLETq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 00:19:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nAzrWUMrv30m/MPle4ZNQ+pUGtRRBQvXUdD+s4HrQQJoa03gPyyDx3SdgXSh6FPLDZ
         MR36cnAWGCjNe8RKtodQ==
MIME-Version: 1.0
In-Reply-To: <4D9D0227.3000807@metafoo.de>
References: <1301796792-28806-1-git-send-email-bleung@chromium.org>
	<1302134120-29589-1-git-send-email-bleung@chromium.org>
	<4D9D0227.3000807@metafoo.de>
Date: Mon, 11 Apr 2011 21:19:42 -0700
X-Google-Sender-Auth: YYL3oAYa9uV0dW5nW3BNwdjdLG4
Message-ID: <BANLkTinEgCeXtv0kW7XTu142LjFucnKwHA@mail.gmail.com>
Subject: Re: [PATCH v3] gpio-charger: Add gpio_charger_resume
From: Benson Leung <bleung@chromium.org>
To: Lars-Peter Clausen <lars@metafoo.de>, cbouatmailru@gmail.com
Cc: rklein@nvidia.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Lars.

Hi Anton,

Can this patch be applied?

Thanks,
Benson

On Wed, Apr 6, 2011 at 5:15 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 04/07/2011 01:55 AM, Benson Leung wrote:
>> Gpio charger should notify if the gpio state had changed
>> during suspend. This will send a CHANGED event each time
>> the system resumes, ensuring a plug/unplug of the charger
>> is not missed.
>>
>> Signed-off-by: Benson Leung <bleung@chromium.org>
> Acked-By: Lars-Peter Clausen <lars@metafoo.de>
>
>>
>> --
>> Version history :
>> v3 : Use SIMPLE_DEV_PM_OPS
>> v2 : Changed to use dev_ms_ops
>> v1 : Initial
>> ---
>>  drivers/power/gpio-charger.c |   15 +++++++++++++++
>>  1 files changed, 15 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
>> index 25b88ac..718f2c5 100644
>> --- a/drivers/power/gpio-charger.c
>> +++ b/drivers/power/gpio-charger.c
>> @@ -161,12 +161,27 @@ static int __devexit gpio_charger_remove(struct platform_device *pdev)
>>       return 0;
>>  }
>>
>> +#ifdef CONFIG_PM_SLEEP
>> +static int gpio_charger_resume(struct device *dev)
>> +{
>> +     struct platform_device *pdev = to_platform_device(dev);
>> +     struct gpio_charger *gpio_charger = platform_get_drvdata(pdev);
>> +
>> +     power_supply_changed(&gpio_charger->charger);
>> +
>> +     return 0;
>> +}
>> +#endif
>> +
>> +static SIMPLE_DEV_PM_OPS(gpio_charger_pm_ops, NULL, gpio_charger_resume);
>> +
>>  static struct platform_driver gpio_charger_driver = {
>>       .probe = gpio_charger_probe,
>>       .remove = __devexit_p(gpio_charger_remove),
>>       .driver = {
>>               .name = "gpio-charger",
>>               .owner = THIS_MODULE,
>> +             .pm = &gpio_charger_pm_ops,
>>       },
>>  };
>>
>
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab1DFU6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:58:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:4884 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab1DFU6v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:58:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Kn/X5+CHauVNV39yXkue8hPd9TnYp+wxtlPrLCFHjsLiQ79+Fe0fZ7eUYoDfp4rDq2
         alghF2JXdWxXokLa6pMw==
MIME-Version: 1.0
In-Reply-To: <4D9C7B52.2060307@metafoo.de>
References: <1301796792-28806-1-git-send-email-bleung@chromium.org>
	<BANLkTinh-Chz7GzdHLqpSSzq4BzzwX5axw@mail.gmail.com>
	<4D9C7B52.2060307@metafoo.de>
Date: Wed, 6 Apr 2011 13:58:47 -0700
X-Google-Sender-Auth: F3GUELDF-uizXX-1RCSK0lp8QXs
Message-ID: <BANLkTingVDgBGJZiqj6YwYT2HpQ2icZzFw@mail.gmail.com>
Subject: Re: [PATCH v2] gpio-charger: Add gpio_charger_resume
From: Benson Leung <bleung@chromium.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: cbouatmailru@gmail.com, rklein@nvidia.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Lars,

v3 coming right up.

Benson

On Wed, Apr 6, 2011 at 7:40 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 04/06/2011 11:08 AM, Benson Leung wrote:
>> Hi Lars,
>>
>> Please take another look.
>>
>> Thanks,
>> Benson
>>
>
> Hi
>
> Some minor issues:
>
>> On Sat, Apr 2, 2011 at 7:13 PM, Benson Leung <bleung@chromium.org> wrote:
>>> Gpio charger should notify if the gpio state had changed
>>> during suspend. This will send a CHANGED event each time
>>> the system resumes, ensuring a plug/unplug of the charger
>>> is not missed.
>>>
>>> Signed-off-by: Benson Leung <bleung@chromium.org>
>>>
>>> --
>>> Version history :
>>> v2 : Changed to use dev_pm_ops
>>> v1 : Initial
>>> ---
>>>  drivers/power/gpio-charger.c |   20 ++++++++++++++++++++
>>>  1 files changed, 20 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
>>> index 25b88ac..df29059 100644
>>> --- a/drivers/power/gpio-charger.c
>>> +++ b/drivers/power/gpio-charger.c
>>> @@ -161,12 +161,32 @@ static int __devexit gpio_charger_remove(struct platform_device *pdev)
>>>        return 0;
>>>  }
>>>
>>> +#if defined(CONFIG_PM)
>
> #ifdef CONFIG_PM_SLEEP
>
>>> +static int gpio_charger_resume(struct device *dev)
>>> +{
>>> +       struct platform_device *pdev = to_platform_device(dev);
>>> +       struct gpio_charger *gpio_charger = platform_get_drvdata(pdev);
>>> +
>>> +       power_supply_changed(&gpio_charger->charger);
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +static const struct dev_pm_ops gpio_charger_pm_ops = {
>>> +       .resume         = gpio_charger_resume,
>>> +};
>>> +#endif
>
> static SIMPLE_DEV_PM_OPS(gpio_charger_pm_ops, gpio_charger_resume, NULL);
>
> This will also setup the pm hooks for suspend to disk.
> And SIMPLE_DEV_PM_OPS will also ignore the callbacks if CONFIG_PM_SLEEP is not
> set, so it can go outside of the #ifdef CONFIG_PM_SLEEP and you can also get
> rid of the #ifdef ...
>
>>> +
>>> +
>>>  static struct platform_driver gpio_charger_driver = {
>>>        .probe = gpio_charger_probe,
>>>        .remove = __devexit_p(gpio_charger_remove),
>>>        .driver = {
>>>                .name = "gpio-charger",
>>>                .owner = THIS_MODULE,
>>> +#if defined(CONFIG_PM)
>>> +               .pm = &gpio_charger_pm_ops,
>>> +#endif
>
> ... here.
>
>>>        },
>>>  };
>>>
>>> --
>>> 1.7.1
>>>
>>>
>>
>>
>>
>
>



-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org

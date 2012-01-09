Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab2AIOF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 09:05:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47370 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab2AIOFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 09:05:25 -0500
MIME-Version: 1.0
In-Reply-To: <4F0AE2BF.6080605@metafoo.de>
References: <4F0AC06C.3000502@gmail.com> <4F0AE2BF.6080605@metafoo.de>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Mon, 9 Jan 2012 15:05:02 +0100
Message-ID: <CAH9NwWeO30KB8UiNNt4Ng9M9Q=cG0wHMkhEEH_m2nutYk7wCHg@mail.gmail.com>
Subject: Re: [PATCH v2] add led driver for Bachmann's ot200
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        bigeasy@linutronix.de, rpurdie@rpsys.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


2012/1/9 Lars-Peter Clausen <lars@metafoo.de>:
> On 01/09/2012 11:24 AM, Christian Gmeiner wrote:
>> From a7fecf3426ef98fdd19e9d2610665b9d1ce358a0 Mon Sep 17 00:00:00 2001
>> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de
>> <mailto:bigeasy@linutronix.de>>
>> Date: Mon, 9 Jan 2012 10:09:50 +0100
>> Subject: [PATCH v2] add led driver for Bachmann's ot200
>>
>> This patch adds support for leds on Bachmann's ot200 visualisation device.
>> The device has three leds on the back panel (led_err, led_init and led_run)
>> and can handle up to seven leds on the front panel.
>>
>> The driver was written by Linutronix on behalf of
>> Bachmann electronic GmbH.
>>
>> Changes in v2:
>> - *incorporated* feedback from Andrew Morton and Lars-Peter Clausen
>>
>
> looks good to me except some minor style issues and the <mailto:...> tags.
>

I have switch to an other mail client now...

>
>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de
>> <mailto:bigeasy@linutronix.de>>
>> Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com
>> <mailto:christian.gmeiner@gmail.com>>
>> ---
>> [...]
>> diff --git a/drivers/leds/leds-ot200.c b/drivers/leds/leds-ot200.c
>> new file mode 100644
>> index 0000000..4d000ac
>> --- /dev/null
>> +++ b/drivers/leds/leds-ot200.c
>> @@ -0,0 +1,177 @@
>> [...]
>> +
>> +static int __devinit ot200_led_probe(struct platform_device *pdev)
>> +{
>> +    int i;
>> +    int ret;
>> +
>> +    for (i = 0; i < ARRAY_SIZE(leds); i++) {
>> +
>> +        leds[i].cdev.name = leds[i].name;
>> +        leds[i].cdev.default_trigger = NULL;
>> +        leds[i].cdev.blink_set = NULL;
>
> No need to initialize to NULL.

okay

>
>> +        leds[i].cdev.brightness_set = ot200_led_brightness_set;
>> +
>> +        ret = led_classdev_register(&pdev->dev, &leds[i].cdev);
>> +        if (ret < 0)
>> +            goto err;
>> +
>> +        dev_set_drvdata(leds[i].cdev.dev, &leds[i]);
>
> Neither this ...
>
>> +    }
>> +
>> +    platform_set_drvdata(pdev, leds);
>
> nor this is ever used.

you are right

>
>> +
>> +    outb(0x0, 0x49);    /* turn off all front leds */
>> +    outb(0x2, 0x5a);    /* turn on init led */
>> +    leds_front = 0;
>> +    leds_back = BIT(1);
>
> Maybe initialize leds_front and leds_back first and pass it to outb.
>
>> +
>> +    return 0;
>> +
>> +err:
>> +    for (i = i - 1; i >= 0; i--)
>> +        led_classdev_unregister(&leds[i].cdev);
>> +
>> +    return ret;
>> +}
>> +

Hope v3 will make it :)

thanks
--
Christian Gmeiner, MSc

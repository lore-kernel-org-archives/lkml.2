Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab1LMVWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 16:22:54 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63285 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab1LMVWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 16:22:51 -0500
Message-ID: <4EE7C1C9.8080000@solonet.org.ua>
Date: Tue, 13 Dec 2011 23:21:13 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH v3 resend2] s3c/s3c24xx: arm: leds: Make s3c24xx LEDS
 driver use gpiolib
References: <4EE7B41C.5080006@solonet.org.ua> <1323810417.3837.25.camel@joe2Laptop>
In-Reply-To: <1323810417.3837.25.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,
Thank you for review.

On 12/13/2011 11:06 PM, Joe Perches wrote:
> On Tue, 2011-12-13 at 22:22 +0200, Denis Kuzmenko wrote:
>> Make s3c24xx LEDS driver use gpiolib. Fix error disabling pull during probe.
> []
>> diff --git a/drivers/leds/leds-s3c24xx.c b/drivers/leds/leds-s3c24xx.c
> []
>> @@ -45,23 +45,35 @@ static void s3c24xx_led_set(struct led_classdev *led_cdev,
>> +	/*
>> +	 * ensure value is 0 or 1 to use it with bitwise XOR (^)
>> +	 * (only 100% brightness is supported)
>> +	 */
>> +	value = value ? 1 : 0;
> 
> Maybe value = !!value;

IMHO my variant is better readable.

>> +		/* no point in having a pull-up as we are always driving */
>> +		s3c_gpio_setpull(pdata->gpio, S3C_GPIO_PULL_NONE);
>> +		ret = gpio_direction_output(pdata->gpio,
>> +				!!(pdata->flags & S3C24XX_LEDF_ACTLOW));
> 
> akin to this use.

There is no so much space for implementation used before so I've used
shorter notation, again, for better readability.

-- 
Best regards, Denis Kuzmenko.

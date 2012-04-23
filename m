Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab2DWI1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 04:27:04 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:46150 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab2DWI1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 04:27:01 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Apr 2012 04:27:01 EDT
Message-ID: <4F9510FF.9060604@atmel.com>
Date: Mon, 23 Apr 2012 10:21:19 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arm-kernel@lists.infradead.org>, <arnd@arndb.de>, <olof@lixom.net>,
        <plagnioj@jcrosoft.com>, <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>
Subject: Re: [PATCH 10/12] leds-atmel-pwm.c: Make pwmled_probe() __devinit
References: <cover.1334567594.git.nicolas.ferre@atmel.com> <23f8dba8a3e1ae21a5953747b63dc0a21fcba868.1334567594.git.nicolas.ferre@atmel.com> <20120420143427.97c08ee5.akpm@linux-foundation.org>
In-Reply-To: <20120420143427.97c08ee5.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.159.245.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2012 11:34 PM, Andrew Morton :
> On Mon, 16 Apr 2012 11:20:54 +0200
> Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> 
>> Commit 892a884 (leds: convert led platform drivers to module_platform_driver)
>> is omitting the section mismatch error: so change annotation of the probe
>> function to __devinit instead of __init.
>>
>> ...
>>
>> --- a/drivers/leds/leds-atmel-pwm.c
>> +++ b/drivers/leds/leds-atmel-pwm.c
>> @@ -35,7 +35,7 @@ static void pwmled_brightness(struct led_classdev *cdev, enum led_brightness b)
>>   * NOTE:  we reuse the platform_data structure of GPIO leds,
>>   * but repurpose its "gpio" number as a PWM channel number.
>>   */
>> -static int __init pwmled_probe(struct platform_device *pdev)
>> +static int __devinit pwmled_probe(struct platform_device *pdev)
>>  {
>>  	const struct gpio_led_platform_data	*pdata;
>>  	struct pwmled				*leds;
> 
> This is theoretically oopsable and the patch is probably needed in 3.4
> and 3.3.x.

Absolutely, I will request it to be included in stable tree then.

> But you've applied it to linu-next via your own tree so I won't be
> merging it.

Ok, thanks for having taken this patch into account Andrew.

Best regards,
-- 
Nicolas Ferre

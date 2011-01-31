Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab1AaX46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:56:58 -0500
Received: from mail131.messagelabs.com ([216.82.242.99]:47374 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab1AaX45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 18:56:57 -0500
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-131.messagelabs.com!1296518215!12358790!1
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.97]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 31 Jan 2011 17:56:53 -0600
Subject: Re: [leds-pca9532] Add gpio capability
Thread-Topic: Re: [leds-pca9532] Add gpio capability
Thread-Index: AcvBoojycM09n7jnSDeE2o7G+39//g==
Message-ID: <0D753D10438DA54287A00B027084269764CEEDA479@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0VNv6Jm005856

>>>> + if (gpios) {
>>>> + data->gpio.label = "gpio-pca9532";
>>>> + data->gpio.set = pca9532_gpio_set_value;
>>>> + data->gpio.get = pca9532_gpio_get_value;
>>>> + data->gpio.request = pca9532_gpio_request_pin;
>>>> + data->gpio.can_sleep = 1;
>>>> + data->gpio.base = pdata->gpio_base;
>>>> + data->gpio.ngpio = 16;
>>>> + data->gpio.dev = &client->dev;
>>>> + data->gpio.owner = THIS_MODULE;
>>>
>>> I'd assume that you also need to define a direction_output-function which
>>> always
>>> returns success?
>>
>> Yes, you are right. It is not possible to set direction in hw, but I
>> should provide them.
>
> It should be okay to skip direction_input, because gpiolib will return an error
> if it is not available. This is exactly why IMO you need a direction_output
> returning 0. Otherwise drivers checking if that operation was successful, might
> be fooled.

>From the datasheet:


6.4 Pins used as GPIOs

LEDn pins not used to control LEDs can be used as General Purpose I/Os (GPIOs).

To use as input, set LEDn to high-impendance (00) and then read the pin state
via the INPUT0 or INPUT1 register.

For use as output, connect external pull-up resistor to the pin and size it
according to the DC recommended operating characteristics.  LEDn output is HIGH
when the output is programmed as high-impedance, and LOW when programmed LOW
through the 'LED selector' register.  The output can be pulse-width controlled
when PWM0 or PWM1 are used.


So, you should provide both a direction_input and direction_output.

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

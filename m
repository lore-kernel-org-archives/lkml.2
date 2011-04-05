Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab1DESNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 14:13:07 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:30716 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab1DESND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 14:13:03 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-132.messagelabs.com!1302027181!21368751!1
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.99]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Fabio Estevam <fabio.estevam@freescale.com>,
        =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Date: Tue, 5 Apr 2011 13:12:59 -0500
Subject: RE: [PATCH] leds: provide helper to register "leds-gpio" devices
Thread-Topic: [PATCH] leds: provide helper to register "leds-gpio" devices
Thread-Index: AcvzrqlsvxN8o1/eSQSRq3QJ9vEXbQACgCiw
Message-ID: <0D753D10438DA54287A00B027084269764D1CFC085@AUSP01VMBX24.collaborationhost.net>
References: <20110405073030.GI13963@pengutronix.de>
 <1301992655-8514-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <4D9B3FA8.1010407@freescale.com> <4D9B4363.8010606@freescale.com>
In-Reply-To: <4D9B4363.8010606@freescale.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p35IDGb9028494

On Tuesday, April 05, 2011 9:29 AM, Fabio Estevam wrote:
> On 4/5/2011 1:13 PM, Fabio Estevam wrote:
>> Hi Uwe,
>> 
>> On 4/5/2011 5:37 AM, Uwe Kleine-KÃ¶nig wrote:
>>> This function makes a deep copy of the platform data to allow it to live
>>> in init memory.
>>> The definition cannot go into leds-gpio.c because it needs to be builtin
>>> to be usable by platforms.
>>>
>>> Signed-off-by: Uwe Kleine-KÃ¶nig <u.kleine-koenig@pengutronix.de>
>> 
>> I tested your patch on a MX53EVK board, but I could only build it after unselecting the mmc driver.
>> 
>> This is the error I got when mmc was selected:
>> 
>>   CC      drivers/mmc/card/mmc_test.o
>>   LD      drivers/mmc/card/built-in.o
>>   CC      drivers/mmc/core/sdio_io.o
>> In file included from include/linux/mmc/host.h:13,
>>                  from drivers/mmc/core/sdio_io.c:12:
>> include/linux/leds.h:220: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'gpio_led_register_device'
>> make[3]: *** [drivers/mmc/core/sdio_io.o] Error 1
>> make[2]: *** [drivers/mmc/core] Error 2
>> make[1]: *** [drivers/mmc] Error 2
>> make: *** [drivers] Error 2
>
> If I declare it as "platform_device *gpio_led_register_device" then it builds fine.

With the change Fabio pointed out this builds and works fine on the ep93xx.

Hartley


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

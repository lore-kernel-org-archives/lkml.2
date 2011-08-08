Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab1HHX6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 19:58:15 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:55546 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1HHX6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 19:58:14 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1312847884!31037311!14
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.31]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ryan Mallon <rmallon@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Date: Mon, 8 Aug 2011 18:58:10 -0500
Subject: RE: gpio: ep93xx: remove unused inline function
Thread-Topic: gpio: ep93xx: remove unused inline function
Thread-Index: AcxWJofHV4wmTaLFRjKH0qLsQHvEKwAAB92A
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F388389201@AUSP01VMBX24.collaborationhost.net>
References: <201108081618.30158.hartleys@visionengravers.com>
 <4E407700.5080304@gmail.com>
In-Reply-To: <4E407700.5080304@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p78NwMoI028051

On Monday, August 08, 2011 4:54 PM, Ryan Mallon wrote:
> On 09/08/11 09:18, H Hartley Sweeten wrote:
>> Signed-off-by: H Hartley Sweeten<hsweeten@visionengravers.com>
>> Cc: Ryan Mallon<rmallon@gmail.com>
>> Cc: Grant Likely<grant.likely@secretlab.ca>
>>
>> ---
>>
>> diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
>> index 468b27d..e0ad8e0 100644
>> --- a/drivers/gpio/gpio-ep93xx.c
>> +++ b/drivers/gpio/gpio-ep93xx.c
>> @@ -62,11 +62,6 @@ static void ep93xx_gpio_update_int_params(unsigned port)
>>   		EP93XX_GPIO_REG(int_en_register_offset[port]));
>>   }
>>
>> -static inline void ep93xx_gpio_int_mask(unsigned line)
>> -{
>> -	gpio_int_unmasked[line>>  3]&= ~(1<<  (line&  7));
>> -}
>> -
>>   static void ep93xx_gpio_int_debounce(unsigned int irq, bool enable)
>>   {
>>   	int line = irq_to_gpio(irq);
>
> Yup. Looks like it got factored directly into ep93xx_gpio_irq_mask.
>
> Acked-by: Ryan Mallon <rmallon@gmail.com>

Thanks.

> Note that we have a lot of line >> 3 and (1 << (line & 7)) scattered 
> through this file. We could do something like this (completely untested):

Actually, I'm trying to figure out a way to use the generic-chip stuff to
handle the gpio interrupts.  I just haven't worked it out yet.

There seems to be a push to deprecate irq_to_gpio() so something will
eventually have to be done...

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

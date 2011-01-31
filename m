Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab1AaSIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:08:11 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60391 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1AaSIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:08:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=LiDi4HnUF5q1NRPrsd+G/QTieJ6qXZO798TxWEwFnBUz9yCoc/Zy1NeZ+H0TRLLLLL
         4gJSE7FwQhfQMwYDITpKOX3P3wGocijCYk9RJlEB8EosimU4Q0FCC/iiJBdfOhoRj9qh
         YiTxqAp58cmDgPt6iZdmAZrgzE6phkh8R+hUo=
MIME-Version: 1.0
In-Reply-To: <20110131160321.GA23546@oksana.dev.rtsoft.ru>
References: <20110131135147.GB3883@oksana.dev.rtsoft.ru> <20110131154354.GC3819@enneenne.com>
 <20110131160321.GA23546@oksana.dev.rtsoft.ru>
From: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Date: Mon, 31 Jan 2011 19:07:27 +0100
Message-ID: <AANLkTikr3LL-+4LObBaCTo7JGTFTRdVbpbbUH4nfJ28X@mail.gmail.com>
Subject: Re: Fwd: [PATCH] bq27x00_battery: Add new properties
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/31 Anton Vorontsov <cbouatmailru@gmail.com>:
> On Mon, Jan 31, 2011 at 04:43:56PM +0100, Rodolfo Giometti wrote:
>> On Mon, Jan 31, 2011 at 04:51:47PM +0300, Anton Vorontsov wrote:
> [...]
>> Why not using:
>>
>>    !!(gpio & 0x40)
>>
>> or
>>
>>    (gpio & 0x40) ? 1 : 0
>>
>> ? I think it could be more readable... :)
>>
>> However, I don't understand why you fix gpio=0... it's your machine
>> depending settings? In these case you should use the platform_data
>> mechanism to properly setup the GPIO.
>
> I agree. It looks like a machine-specific configuration, and
> exporting this GPIO as 'ONLINE' property may break other users.
>
> Instead, I would suggest adding gpiolib support into this driver,
> and passing 'int online_gpio' via platform data. That way you can
> pass any GPIOs to this driver, not only bq's.
>
> Pali, you can just split GPIO and 'ONLINE' property additions
> into a separate patch for now, so we can apply the rest of the
> changes, and hold on the GPIO stuff.

Ok, I delete GPIO and ONLINE additions from this patch.

>
> [...]
>> > +static int bq27x00_battery_nac(struct bq27x00_device_info *di)
>>
>> Let me suggest using bq27x00_battery_nac_uAh as function name...
>
> Regarding these suffixes. I'm not sure. This seems a bit too
> verbose. So I'd prefer to not introduce these.
>
> Though, whatever you guys like... I'm fine either way.

It think it is not needed to rename functions. In
Documentation/power/power_supply_class.txt is written that default
units are µA, µV, µAh, ... and functions in my patch return values in
these correct units.

>
> [...]
>> >  MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
>> >  MODULE_DESCRIPTION("BQ27x00 battery monitor driver");
>> > +MODULE_ALIAS("i2c:bq27000");
>> > +MODULE_ALIAS("i2c:bq27200");
>> > +MODULE_ALIAS("i2c:bq27500");
>
> Btw, this is actually another bugfix. Pali, you might want to separate
> it into yet another patch.

Ok, I separate aliases to new patch.

>
> Thanks!
>
> --
> Anton Vorontsov
> Email: cbouatmailru@gmail.com
>



-- 
Pali Rohár
pali.rohar@gmail.com

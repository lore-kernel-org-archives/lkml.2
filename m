Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab1AaTR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:17:56 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:55702 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514Ab1AaTRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:17:55 -0500
Message-ID: <4D470B42.7050301@metafoo.de>
Date: Mon, 31 Jan 2011 20:19:30 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: [PATCH] bq27x00_battery: Add new properties
References: <20110131135147.GB3883@oksana.dev.rtsoft.ru> <20110131154354.GC3819@enneenne.com> <20110131160321.GA23546@oksana.dev.rtsoft.ru> <AANLkTikr3LL-+4LObBaCTo7JGTFTRdVbpbbUH4nfJ28X@mail.gmail.com>
In-Reply-To: <AANLkTikr3LL-+4LObBaCTo7JGTFTRdVbpbbUH4nfJ28X@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 07:07 PM, Pali Rohár wrote:
> 2011/1/31 Anton Vorontsov <cbouatmailru@gmail.com>:
>> On Mon, Jan 31, 2011 at 04:43:56PM +0100, Rodolfo Giometti wrote:
>>> On Mon, Jan 31, 2011 at 04:51:47PM +0300, Anton Vorontsov wrote:
>> [...]
>>> Why not using:
>>>
>>>    !!(gpio & 0x40)
>>>
>>> or
>>>
>>>    (gpio & 0x40) ? 1 : 0
>>>
>>> ? I think it could be more readable... :)
>>>
>>> However, I don't understand why you fix gpio=0... it's your machine
>>> depending settings? In these case you should use the platform_data
>>> mechanism to properly setup the GPIO.
>>
>> I agree. It looks like a machine-specific configuration, and
>> exporting this GPIO as 'ONLINE' property may break other users.
>>
>> Instead, I would suggest adding gpiolib support into this driver,
>> and passing 'int online_gpio' via platform data. That way you can
>> pass any GPIOs to this driver, not only bq's.
>>
>> Pali, you can just split GPIO and 'ONLINE' property additions
>> into a separate patch for now, so we can apply the rest of the
>> changes, and hold on the GPIO stuff.
> 
> Ok, I delete GPIO and ONLINE additions from this patch.
> 
>>
>> [...]
>>>> +static int bq27x00_battery_nac(struct bq27x00_device_info *di)
>>>
>>> Let me suggest using bq27x00_battery_nac_uAh as function name...
>>
>> Regarding these suffixes. I'm not sure. This seems a bit too
>> verbose. So I'd prefer to not introduce these.
>>
>> Though, whatever you guys like... I'm fine either way.
> 
> It think it is not needed to rename functions. In
> Documentation/power/power_supply_class.txt is written that default
> units are µA, µV, µAh, ... and functions in my patch return values in
> these correct units.
> 
>>
>> [...]
>>>>  MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
>>>>  MODULE_DESCRIPTION("BQ27x00 battery monitor driver");
>>>> +MODULE_ALIAS("i2c:bq27000");
>>>> +MODULE_ALIAS("i2c:bq27200");
>>>> +MODULE_ALIAS("i2c:bq27500");
>>
>> Btw, this is actually another bugfix. Pali, you might want to separate
>> it into yet another patch.
> 
> Ok, I separate aliases to new patch.
> 

The bq27000 is not an I2C device.

- Lars

>>
>> Thanks!
>>
>> --
>> Anton Vorontsov
>> Email: cbouatmailru@gmail.com
>>
> 
> 
> 


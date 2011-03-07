Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1CGG73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 01:59:29 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:55585 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972Ab1CGG72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 01:59:28 -0500
Message-ID: <4D748292.7030302@metafoo.de>
Date: Mon, 07 Mar 2011 08:00:34 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: "'Ben Dooks'" <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/09] ARM: s3c2440: gta02: Request usb pullup pin before
 using it
References: <1297043521-21903-1-git-send-email-lars@metafoo.de> <1297043521-21903-8-git-send-email-lars@metafoo.de> <000301cbd70f$12367070$36a35150$%kim@samsung.com> <4D6B7826.1030500@metafoo.de> <003201cbd734$79d87050$6d8950f0$%kim@samsung.com> <4D6B7FE6.8090802@metafoo.de> <031101cbdc92$e6c44730$b44cd590$%kim@samsung.com>
In-Reply-To: <031101cbdc92$e6c44730$b44cd590$%kim@samsung.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2011 07:42 AM, Kukjin Kim wrote:
> Lars-Peter Clausen wrote:
>>
>> On 02/28/2011 11:44 AM, Kukjin Kim wrote:
>>> Lars-Peter Clausen wrote:
>>>>
>>>> On 02/28/2011 07:16 AM, Kukjin Kim wrote:
>>>>> Lars-Peter Clausen wrote:
>>>>>>
>>>>>> Request the gpio pin used to control the usb pullup before using it
> to
>>>>> avoid
>>>>>> a
>>>>>> runtime warning about an auto-requested gpio.
>>>>>>
>>>>>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>>>>>> ---
>>>>>>  arch/arm/mach-s3c2440/mach-gta02.c |   17 +++++++++++++++--
>>>>>>  1 files changed, 15 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/arm/mach-s3c2440/mach-gta02.c
>>>>> b/arch/arm/mach-s3c2440/mach-
>>>>>> gta02.c
>>>>>> index 1396639..94456fa 100644
>>>>>> --- a/arch/arm/mach-s3c2440/mach-gta02.c
>>>>>> +++ b/arch/arm/mach-s3c2440/mach-gta02.c
>>>>>> @@ -451,11 +451,11 @@ static void gta02_udc_command(enum
>>> s3c2410_udc_cmd_e
>>>>>> cmd)
>>>>>>  	switch (cmd) {
>>>>>>  	case S3C2410_UDC_P_ENABLE:
>>>>>>  		pr_debug("%s S3C2410_UDC_P_ENABLE\n", __func__);
>>>>>> -		gpio_direction_output(GTA02_GPIO_USB_PULLUP, 1);
>>>>>> +		gpio_set_value(GTA02_GPIO_USB_PULLUP, 1);
>>>>>
>>>>> How about following instead?
>>>>> 	gpio_request(GTA02_GPIO_USB_PULLUP, "USB_PULLUP");
>>>>> 	gpio_direction_output(GTA02_GPIO_USB_PULLUP, 1);
>>>>> 	gpio_free(GTA02_GPIO_USB_PULLUP);
>>>>>
>>>>
>>>> I don't think that is a good idea. This gpio should really be reserved
> for
>>>> the
>>>> udc driver. If it is freed again, it could be requested from someone
> else
>>>> which
>>>> could lead to undefined behaviour.
>>>>
>>> Yes right, but I mean the board designer already knows the usage of
>>> regarding GPIOs on his board.
>>> So why do we really need gpio_request for it?...
>>
>> Well, for one because it's part of the gpio-api. You should not call any
>> other
>> gpio functions on a pin unless you've successfully requested that pin.
>> On the other hand this helps debugging and ensures that the same gpio is
> not
>> used by two drivers accident. For example it is also possible to request
>> gpios
>> from userspace using the gpio sysfs. So by keeping the gpio requested it
> wont
>> be possible to request it from userspace by accident. And the gpio will
> also
>> be
>> listed in the gpio debugfs file, which can be helpful for debugging as
> well.
>>
>> - Lars
> 
> Hi Lars,
> 
> Ok, will apply :)
> Thanks.
> 
> Best regards,
> Kgene.
> --
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
> 

Hi Kgene

Actually I've prepared another patch, which I'm was about to send in a few
minutes, which moves the controlling of the pullup pin to the udc driver.

- Lars

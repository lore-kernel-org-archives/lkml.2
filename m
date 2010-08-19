Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab0HSJ4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 05:56:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48903 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab0HSJ4P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 05:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ki0eJ27ZNfVhc1X/UlA5/HvTyj9EOwKIUcl13V/l9qSVZA+ZRJan1qrRsB06tmbd1j
         U1EINvLriQfqx/+RblXcWXn94A3pbj4xkg5YSzCXGcQTX3zYNMxK1ZKTwhY7sIq64Hrw
         HFVp2MLqGk8lHbpMU2LOOz+rLmOm+6Ey0bmEU=
MIME-Version: 1.0
In-Reply-To: <4C6D0025.1090502@jic23.retrosnub.co.uk>
References: <20100802035422.GA2883@july>
	<AANLkTimkd5HLs7EyCX3--VO8fyJhXCBG-KMuG9wr0ZZk@mail.gmail.com>
	<4C6D0025.1090502@jic23.retrosnub.co.uk>
Date: Thu, 19 Aug 2010 18:56:13 +0900
X-Google-Sender-Auth: 3IXgGl8XNxvHwi7ABpuuoBpywYI
Message-ID: <AANLkTimmygeV-eaYHTXPhX+2cimHGP5W-3jt_mesAp8s@mail.gmail.com>
Subject: Re: [PATCH] MFD: LP3974 PMIC support
From: Kyungmin Park <kmpark@infradead.org>
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        m.szyprowski@samsung.com, broonie@opensource.wolfsonmicro.com,
        jy0922.shim@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 6:57 PM, Jonathan Cameron
<kernel@jic23.retrosnub.co.uk> wrote:
> On 08/19/10 06:08, Kyungmin Park wrote:
>> Any comments? I hope it's included the 2.6.36 if possible.
> One request for clarification below....
>>
>> Thank you,
>> Kyungmin Park
>>
>> On Mon, Aug 2, 2010 at 12:54 PM, Kyungmin Park <kmpark@infradead.org> wrote:
>>> From: Kyungmin Park <kyungmin.park@samsung.com>
>>>
>>> LP3974 PMIC support. It has same functionality with max8998.
>>>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>>> index db63d40..50383b1 100644
>>> --- a/drivers/mfd/Kconfig
>>> +++ b/drivers/mfd/Kconfig
>>> @@ -303,6 +303,18 @@ config MFD_MAX8998
>>>          accessing the device, additional drivers must be enabled in order
>>>          to use the functionality of the device.
>>>
>>> +config MFD_LP3974
>>> +       bool "National Semiconductor LP3974 PMIC Support"
>>> +       depends on I2C=y
>>> +       select MFD_CORE
>>> +       select MFD_MAX8998
>>> +       help
>>> +         Say yes here to support for National Semiconductor LP3974. This is
>>> +         a Power Management IC. This driver provies common support for
>>> +         accessing the device, additional drivers must be enabled in order
>>> +         to use the functionality of the device.
>>> +         Note that it has same functionality with max8998.
> What is gained from adding a second kconfig option?
> Numerous drivers throughout the kernel support very differently named parts, so why
> not just change the text for the MFD_MAX8998 to say it supports this part as well?

I also consider that. If I got the LP3974 but can't find a config so
it's some confused.
Well, I will modify the MAX8998 comment. if you want

Thank you,
Kyungmin Park

>>> +
>>>  config MFD_WM8400
>>>        tristate "Support Wolfson Microelectronics WM8400"
>>>        select MFD_CORE
>>> diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
>>> index 0d68de2..cea9f48 100644
>>> --- a/drivers/mfd/max8998.c
>>> +++ b/drivers/mfd/max8998.c
>>> @@ -30,6 +30,11 @@
>>>  #include <linux/mfd/max8998.h>
>>>  #include <linux/mfd/max8998-private.h>
>>>
>>> +enum max8998_type {
>>> +       TYPE_MAX8998,
>>> +       TYPE_LP3974,
>>> +};
>>> +
>>>  static struct mfd_cell max8998_devs[] = {
>>>        {
>>>                .name = "max8998-pmic",
>>> @@ -127,8 +132,8 @@ static int max8998_i2c_remove(struct i2c_client *i2c)
>>>  }
>>>
>>>  static const struct i2c_device_id max8998_i2c_id[] = {
>>> -       { "max8998", 0 },
>>> -       { }
>>> +       { "max8998", TYPE_MAX8998 },
>>> +       { "lp3974", TYPE_LP3974 },
>>>  };
>>>  MODULE_DEVICE_TABLE(i2c, max8998_i2c_id);
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>

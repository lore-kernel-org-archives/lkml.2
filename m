Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab2EJHbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:31:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43649 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693Ab2EJHbb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:31:31 -0400
MIME-Version: 1.0
In-Reply-To: <4FAACB66.3020706@gmail.com>
References: <1336580695-1184-1-git-send-email-yadi.brar@samsung.com>
	<1336580695-1184-3-git-send-email-yadi.brar@samsung.com>
	<4FAACB66.3020706@gmail.com>
Date: Thu, 10 May 2012 13:01:30 +0530
Message-ID: <CAKew6eUQ7P8SNK+0AGdJP1w51i8krGcPiMjCF4vHaWd93wR8ng@mail.gmail.com>
Subject: Re: [PATCH 2/2] regulator: Add support for MAX77686.
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Yadwinder Singh <yadi.brar@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi  Sylwester,

On Thu, May 10, 2012 at 1:24 AM, Sylwester Nawrocki <snjw23@gmail.com> wrote:
> Hi,
>
> just a few nitpicks...
>
>
> On 05/09/2012 06:24 PM, Yadwinder Singh wrote:
>>
>> From: Yadwinder Singh Brar<yadi.brar@samsung.com>
>>
>> Add support for PMIC/regulator portion of MAX77686 multifunction device.
>> MAX77686 provides LDOs[1-26] and BUCKs[1-9]. This is initial release of
>> driver
>> which supports setting and getting the voltage of a regulator with I2C
>> interface.
>>
>> Signed-off-by: Yadwinder Singh Brar<yadi.brar@samsung.com>
>
> ...
>
>> diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
>> new file mode 100644
>> index 0000000..4aa9722
>> --- /dev/null
>> +++ b/drivers/regulator/max77686.c
>> @@ -0,0 +1,660 @@
>> +/*
>> + * max77686.c - Regulator driver for the Maxim 77686
>> + *
>> + * Copyright (C) 2012 Samsung Electronics
>
>
> I believe this should read:
>
>  + * Copyright (C) 2012 Samsung Electronics Co., Ltd.
>
> In patch 1/2 the copyright notice is also not exactly correct.
>
>
>> + * Chiwoong Byun<woong.byun@smasung.com>
>
>
> s/smasung/samsung
>
> ...
>

Thanks for pointing. I will rectify above mistakes.

>> +static int max77686_get_enable_register(struct regulator_dev *rdev,
>> +                                       int *reg, int *mask, int *pattern)
>> +{
>> +       int rid = rdev_get_id(rdev);
>> +
>> +       switch (rid) {
>> +       case MAX77686_LDO1...MAX77686_LDO26:
>> +               *reg = MAX77686_REG_LDO1CTRL1 + (rid - MAX77686_LDO1);
>> +               *mask = 0xC0;
>> +               *pattern = 0xC0;
>
>
> What about using lower case for all hex numbers ?
>
> ...
>

Yes, i will take care of this.

>> +static int max77686_get_voltage_register(struct regulator_dev *rdev,
>> +                                        int *_reg, int *_shift, int
>> *_mask)
>> +{
>
> ...
>
>> +       case MAX77686_BUCK2:
>> +               reg = MAX77686_REG_BUCK2DVS1;
>> +               mask = 0xff;
>> +               break;
>> +       case MAX77686_BUCK3:
>> +               reg = MAX77686_REG_BUCK3DVS1;
>> +               mask = 0xff;
>> +               break;
>> +       case MAX77686_BUCK4:
>> +               reg = MAX77686_REG_BUCK4DVS1;
>> +               mask = 0xff;
>> +               break;
>> +       case MAX77686_BUCK5...MAX77686_BUCK9:
>> +               reg = MAX77686_REG_BUCK5OUT + (rid - MAX77686_BUCK5) * 2;
>> +               break;
>> +       default:
>> +               return -EINVAL;
>> +       }
>> +
>> +       *_reg = reg;
>> +       *_shift = shift;
>> +       *_mask = mask;
>> +
>> +       return 0;
>> +}
>
>
> Thanks,
> Sylwester
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

Thanks,
Yadwinder.

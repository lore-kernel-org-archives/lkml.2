Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab0H3Nki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:40:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38135 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab0H3Nkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:40:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=THRIdDA5XcE1t6JFyJN1HJIbUUjYzDMwsh8XCbCHPmFDmdsG+TpQbNbMi+kg2IQT83
         dD3FlOas+oJBjAx5VRIjfVJWEBO60A6HX56ir+3iUkLi+HmVVm9GUJNsKwQNULsWXaLL
         OQV2hkDZ41aqTNswHmqZ8Tq1Qx42gELq+DoVo=
MIME-Version: 1.0
In-Reply-To: <006301cb483c$434f76f0$c9ee64d0$%kim@samsung.com>
References: <20100830114729.GA13150@july>
	<006301cb483c$434f76f0$c9ee64d0$%kim@samsung.com>
Date: Mon, 30 Aug 2010 22:40:33 +0900
X-Google-Sender-Auth: cqGHNL3kq3zJuqKoHHnI7QMraTQ
Message-ID: <AANLkTimxhFtfB8G-z=04zj7ZRq+f7GDaVX5mzgCENuvx@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: Samsung S3C: Move/use the S3C common GPIO IRQ type
From: Kyungmin Park <kmpark@infradead.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jy0922.shim@samsung.com, m.szyprowski@samsung.com, ben-linux@fluff.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 9:09 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Kyungmin Park wrote:
>>
>> From: Kyungmin Park <kyungmin.park@samsung.com>
>>
>> Samsung S3C series have the common GPIO IRQ type for all S3C series.
>>
> I can't agree with your changing name. Why do you want to change the name?
> If you want to move S3C2410_EXTINT_XXX from regs-irqtype.h, just move
> without any changes.
As S5P series change the name conversion. I will also modify the s3c series.

>
> But I'm still thinking why should we move the external interrupt definitions
> to plat/gpio-core.h...

To use the GPIO interrupt. these definitions are used both external
interrupt and GPIO interrupt.
>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  arch/arm/mach-s3c64xx/irq-eint.c                  |   12 ++++++------
>>  arch/arm/plat-s3c24xx/irq.c                       |   14 +++++++-------
>>  arch/arm/plat-s5p/irq-eint.c                      |    2 --
>>  arch/arm/plat-samsung/include/plat/gpio-core.h    |    6 ++++++
>>  arch/arm/plat-samsung/include/plat/regs-irqtype.h |   21
> ---------------------
>>  5 files changed, 19 insertions(+), 36 deletions(-)
>>  delete mode 100644 arch/arm/plat-samsung/include/plat/regs-irqtype.h
>>
>> diff --git a/arch/arm/mach-s3c64xx/irq-eint.c
> b/arch/arm/mach-s3c64xx/irq-eint.c
>> index 5682d6a..c079147 100644
>> --- a/arch/arm/mach-s3c64xx/irq-eint.c
>> +++ b/arch/arm/mach-s3c64xx/irq-eint.c
>> @@ -21,8 +21,8 @@
>>
>>  #include <asm/hardware/vic.h>
>>
>> -#include <plat/regs-irqtype.h>
>>  #include <mach/regs-gpio.h>
>> +#include <plat/gpio-core.h>
>>  #include <plat/gpio-cfg.h>
>>
>>  #include <mach/map.h>
>> @@ -85,23 +85,23 @@ static int s3c_irq_eint_set_type(unsigned int irq,
> unsigned
>> int type)
>>               break;
>>
>>       case IRQ_TYPE_EDGE_RISING:
>> -             newvalue = S3C2410_EXTINT_RISEEDGE;
>> +             newvalue = S3C_GPIO_EDGE_RISING;
>>               break;
>>
>>       case IRQ_TYPE_EDGE_FALLING:
>> -             newvalue = S3C2410_EXTINT_FALLEDGE;
>> +             newvalue = S3C_GPIO_EDGE_FALLING;
>>               break;
>>
>>       case IRQ_TYPE_EDGE_BOTH:
>> -             newvalue = S3C2410_EXTINT_BOTHEDGE;
>> +             newvalue = S3C_GPIO_EDGE_BOTH;
>>               break;
>>
>>       case IRQ_TYPE_LEVEL_LOW:
>> -             newvalue = S3C2410_EXTINT_LOWLEV;
>> +             newvalue = S3C_GPIO_LEVEL_LOW;
>>               break;
>>
>>       case IRQ_TYPE_LEVEL_HIGH:
>> -             newvalue = S3C2410_EXTINT_HILEV;
>> +             newvalue = S3C_GPIO_LEVEL_HIGH;
>>               break;
>>
>>       default:
>> diff --git a/arch/arm/plat-s3c24xx/irq.c b/arch/arm/plat-s3c24xx/irq.c
>> index ad0d44e..e1a6fe5 100644
>> --- a/arch/arm/plat-s3c24xx/irq.c
>> +++ b/arch/arm/plat-s3c24xx/irq.c
>> @@ -23,12 +23,12 @@
>>  #include <linux/interrupt.h>
>>  #include <linux/ioport.h>
>>  #include <linux/sysdev.h>
>> +#include <linux/gpio.h>
>>
> Why need this inclusion?
>
>>  #include <asm/irq.h>
>>  #include <asm/mach/irq.h>
>>
>> -#include <plat/regs-irqtype.h>
>> -
>> +#include <plat/gpio-core.h>
>>  #include <plat/cpu.h>
>>  #include <plat/pm.h>
>>  #include <plat/irq.h>
>> @@ -201,23 +201,23 @@ s3c_irqext_type(unsigned int irq, unsigned int type)
>>                       break;
>>
>>               case IRQ_TYPE_EDGE_RISING:
>> -                     newvalue = S3C2410_EXTINT_RISEEDGE;
>> +                     newvalue = S3C_GPIO_EDGE_RISING;
>>                       break;
>>
>>               case IRQ_TYPE_EDGE_FALLING:
>> -                     newvalue = S3C2410_EXTINT_FALLEDGE;
>> +                     newvalue = S3C_GPIO_EDGE_FALLING;
>>                       break;
>>
>>               case IRQ_TYPE_EDGE_BOTH:
>> -                     newvalue = S3C2410_EXTINT_BOTHEDGE;
>> +                     newvalue = S3C_GPIO_EDGE_BOTH;
>>                       break;
>>
>>               case IRQ_TYPE_LEVEL_LOW:
>> -                     newvalue = S3C2410_EXTINT_LOWLEV;
>> +                     newvalue = S3C_GPIO_LEVEL_LOW;
>>                       break;
>>
>>               case IRQ_TYPE_LEVEL_HIGH:
>> -                     newvalue = S3C2410_EXTINT_HILEV;
>> +                     newvalue = S3C_GPIO_LEVEL_HIGH;
>>                       break;
>>
>>               default:
>> diff --git a/arch/arm/plat-s5p/irq-eint.c b/arch/arm/plat-s5p/irq-eint.c
>> index 4e0d94b..02d6ea2 100644
>> --- a/arch/arm/plat-s5p/irq-eint.c
>> +++ b/arch/arm/plat-s5p/irq-eint.c
>> @@ -19,8 +19,6 @@
>>
>>  #include <asm/hardware/vic.h>
>>
>> -#include <plat/regs-irqtype.h>
>> -
>>  #include <mach/map.h>
>>  #include <plat/cpu.h>
>>  #include <plat/pm.h>
>> diff --git a/arch/arm/plat-samsung/include/plat/gpio-core.h
> b/arch/arm/plat-
>> samsung/include/plat/gpio-core.h
>> index c8681e0..2aef589 100644
>> --- a/arch/arm/plat-samsung/include/plat/gpio-core.h
>> +++ b/arch/arm/plat-samsung/include/plat/gpio-core.h
>> @@ -14,6 +14,12 @@
>>  #define GPIOCON_OFF  (0x00)
>>  #define GPIODAT_OFF  (0x04)
>>
>> +#define S3C_GPIO_LEVEL_LOW           (0x00)
>> +#define S3C_GPIO_LEVEL_HIGH          (0x01)
>> +#define S3C_GPIO_EDGE_FALLING                (0x02)
>> +#define S3C_GPIO_EDGE_RISING         (0x04)
>> +#define S3C_GPIO_EDGE_BOTH           (0x06)
>> +
> GPIO_LELVEL? GPIO_EDGE?...
>
> I think EXTINT_LEVEL_XXX and EXTINT_EDGE_XXX are more clear.

       case IRQ_TYPE_EDGE_BOTH:
             newvalue = S3C_GPIO_EDGE_BOTH;

Don't you it's more clear?

>
>>  #define S5P_GPIO_LEVEL_LOW           (0x00)
>>  #define S5P_GPIO_LEVEL_HIGH          (0x01)
>>  #define S5P_GPIO_EDGE_FALLING                (0x02)
>> diff --git a/arch/arm/plat-samsung/include/plat/regs-irqtype.h
> b/arch/arm/plat-
>> samsung/include/plat/regs-irqtype.h
>> deleted file mode 100644
>> index c63cd3f..0000000
>> --- a/arch/arm/plat-samsung/include/plat/regs-irqtype.h
>> +++ /dev/null
>> @@ -1,21 +0,0 @@
>> -/* arch/arm/plat-s3c/include/plat/regs-irqtype.h
>> - *
>> - * Copyright 2008 Simtec Electronics
>> - *      Ben Dooks <ben@simtec.co.uk>
>> - *      http://armlinux.simtec.co.uk/
>> - *
>> - * S3C - IRQ detection types.
>> - *
>> - * This program is free software; you can redistribute it and/or modify
>> - * it under the terms of the GNU General Public License version 2 as
>> - * published by the Free Software Foundation.
>> - */
>> -
>> -/* values for S3C2410_EXTINT0/1/2 and other cpus in the series, including
>> - * the S3C64XX
>> -*/
>> -#define S3C2410_EXTINT_LOWLEV         (0x00)
>> -#define S3C2410_EXTINT_HILEV  (0x01)
>> -#define S3C2410_EXTINT_FALLEDGE       (0x02)
>> -#define S3C2410_EXTINT_RISEEDGE       (0x04)
>> -#define S3C2410_EXTINT_BOTHEDGE       (0x06)
>> --
>
> Thanks.
>
> Best regards,
> Kgene.
> --
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

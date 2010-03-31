Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab0CaDAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 23:00:51 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34199 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab0CaDAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 23:00:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MsmwjdkRWDK2yqWUGbBfp3eaFDjrz98p247j4wqRjh2qYC2kiXbl1Dgox8nUuLLwfo
         rJ0+HaC08PAYLmSV++mAYvb7F14a3UiVKMDHcb37nAd/6kqj9GMlPKf3i0OzCFsmAVUR
         Iomo8oHiFjjyHob99ExTIpC4nBfFpDip3tgXU=
MIME-Version: 1.0
In-Reply-To: <20100331010431.GJ31126@trinity.fluff.org>
References: <20100324070943.GA6779@july>
	 <20100331010431.GJ31126@trinity.fluff.org>
Date: Wed, 31 Mar 2010 12:00:47 +0900
X-Google-Sender-Auth: 52edf303e6477f6c
Message-ID: <s2h9c9fda241003302000s476bea37i24ec237e26aaef7d@mail.gmail.com>
Subject: Re: [PATCH] Samsung SoCs: CPU detection support (v4)
From: Kyungmin Park <kmpark@infradead.org>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 10:04 AM, Ben Dooks <ben-linux@fluff.org> wrote:
> On Wed, Mar 24, 2010 at 04:09:43PM +0900, Kyungmin Park wrote:
>> Store the CPU ID to cpu_id variable and use it to detect CPU
>>
>> On S3C64XX, Some pheripherals such as OneNAND have different configuration
>> and handle it differently to do this it needs to detect CPU ID.
>
> Just do it like everything else on these platfroms do and use
> a rename-able platform device. I do not like the cpu_is macros, it
> makes it harder to deal with autoloading modules.

You mean OMAP is harder to support autoloading modules?
and in case of OneNAND it's only one 'samsung-onenand' module name,
why do we need rename-able platform devices?

>
> It isn't as if there are plenty of drivers in the s3c/s5p series already
> doing this.

Don't you think we create the too much driver? e.g., why each UART
drivers are needed for samsung SoCs.
s3c2400.c, s3c2410.c, s3c2412.c, s3c2440.c, s3c24a0.c, s3c6400.c, s5pv210.c.
Don't you merge simple two or three modules since it's codes are
almost duplicated and uses similar UART blocks.

Thank you,
Kyungmin Park

>
>> Also S5PC1XX is supported.
>>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>> diff --git a/arch/arm/plat-samsung/include/plat/cpu.h b/arch/arm/plat-samsung/include/plat/cpu.h
>> index d316b4a..5fd5e1b 100644
>> --- a/arch/arm/plat-samsung/include/plat/cpu.h
>> +++ b/arch/arm/plat-samsung/include/plat/cpu.h
>> @@ -15,6 +15,8 @@
>>  #ifndef __SAMSUNG_PLAT_CPU_H
>>  #define __SAMSUNG_PLAT_CPU_H
>>
>> +#include <plat/cpuid.h>
>> +
>>  #define IODESC_ENT(x) { (unsigned long)S3C24XX_VA_##x, __phys_to_pfn(S3C24XX_PA_##x), S3C24XX_SZ_##x, MT_DEVICE }
>>
>>  #ifndef MHZ
>> diff --git a/arch/arm/plat-samsung/include/plat/cpuid.h b/arch/arm/plat-samsung/include/plat/cpuid.h
>> new file mode 100644
>> index 0000000..bd7162c
>> --- /dev/null
>> +++ b/arch/arm/plat-samsung/include/plat/cpuid.h
>> @@ -0,0 +1,199 @@
>> +/*
>> + * arch/arm/plat-samsung/include/mach/cpuid.h
>> + *
>> + *  Samsung cpu type detection
>> + *
>> + *  Copyright (C) 2008-2010 Samsung Electronics
>> + *  Kyungmin Park <kyungmin.park@samsung.com>
>> + *
>> + * Derived from OMAP cpu.h
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
>> + */
>> +
>> +#ifndef __ASM_ARCH_SAMSUNG_CPU_H
>> +#define __ASM_ARCH_SAMSUNG_CPU_H
>> +
>> +extern unsigned long samsung_cpu_id(void);
>> +
>> +/*
>> + * cpu_is_s3c24xx(): True for s3c2400, s3c2410, s3c2440 and so on
>> + * cpu_is_s3c241x(): True fro s3c2410, s3c2412
>> + * cpu_is_s3c244x(): True fro s3c2440, s3c2442, s3c2443
>> + * cpu_is_s3c64xx(): True for s3c6400, s3c6410
>> + * cpu_is_s5pc1xx(): True for s5pc100, s5pc110
>> + * cpu_is_s5p64xx(): True for s5p6442
>> + */
>> +#define GET_SAMSUNG_CLASS    ((samsung_cpu_id() >> 24) & 0xff)
>> +
>> +#define IS_SAMSUNG_CLASS(class, id)                                  \
>> +static inline int is_##class (void)                                  \
>> +{                                                                    \
>> +     return (GET_SAMSUNG_CLASS == (id)) ? 1 : 0;                     \
>> +}
>> +
>> +#define GET_SAMSUNG_SUBCLASS ((samsung_cpu_id() >> 20) & 0xfff)
>> +
>> +#define IS_SAMSUNG_SUBCLASS(subclass, id)                            \
>> +static inline int is_##subclass (void)                                       \
>> +{                                                                    \
>> +     return (GET_SAMSUNG_SUBCLASS == (id)) ? 1 : 0;                  \
>> +}
>> +
>> +IS_SAMSUNG_CLASS(s3c24xx, 0x24)
>> +IS_SAMSUNG_CLASS(s3c64xx, 0x64)
>> +IS_SAMSUNG_CLASS(s5pc1xx, 0xc1)
>> +
>> +IS_SAMSUNG_SUBCLASS(s3c241x, 0x241)
>> +IS_SAMSUNG_SUBCLASS(s3c244x, 0x244)
>> +IS_SAMSUNG_SUBCLASS(s5p64xx, 0x644)
>> +
>> +#define cpu_is_s3c24xx()             0
>> +#define cpu_is_s3c241x()             0
>> +#define cpu_is_s3c244x()             0
>> +#define cpu_is_s3c64xx()             0
>> +#define cpu_is_s5pc1xx()             0
>> +#define cpu_is_s5p64xx()             0
>> +
>> +#if defined(CONFIG_ARCH_S3C2410)
>> +# undef  cpu_is_s3c24xx
>> +# undef  cpu_is_s3c241x
>> +# undef  cpu_is_s3c244x
>> +# define cpu_is_s3c24xx()            is_s3c24xx()
>> +# define cpu_is_s3c241x()            is_s3c241x()
>> +# define cpu_is_s3c244x()            is_s3c244x()
>> +#endif
>> +
>> +#if defined(CONFIG_ARCH_S3C64XX)
>> +# undef  cpu_is_s3c64xx
>> +# define cpu_is_s3c64xx()            is_s3c64xx()
>> +#endif
>> +
>> +#if defined(CONFIG_ARCH_S5PC1XX) || defined(CONFIG_ARCH_S5PC11X)
>> +# undef  cpu_is_s5pc1xx
>> +# define cpu_is_s5pc1xx()            is_s5pc1xx()
>> +#endif
>> +
>> +#if defined(CONFIG_ARCH_S5P64XX)
>> +# undef  cpu_is_s5p64xx
>> +# define cpu_is_s5p64xx()            is_s5p64xx()
>> +#endif
>> +
>> +/*
>> + * Macros to detect individual cpu types.
>> + * cpu_is_s3c2410(): True for s3c2410
>> + * cpu_is_s3c2440(): True for s3c2440
>> + * cpu_is_s3c6400(): True for s3c6400
>> + * cpu_is_s3c6410(): True for s3c6410
>> + * cpu_is_s5pc100(): True for s5pc100
>> + * cpu_is_s5pc110(): True for s5pc110
>> + * cpu_is_s5p6442(): True for s5p6442
>> + *
>> + * Exception:
>> + * Store Revision A to 1
>> + * s3c2410a -> s3c2411
>> + * s3c2440a -> s3c2441
>> + */
>> +
>> +#define GET_SAMSUNG_TYPE     ((samsung_cpu_id() >> 16) & 0xffff)
>> +
>> +#define IS_SAMSUNG_TYPE(type, id)                                    \
>> +static inline int is_##type (void)                                   \
>> +{                                                                    \
>> +     return (GET_SAMSUNG_TYPE == (id)) ? 1 : 0;                      \
>> +}
>> +
>> +IS_SAMSUNG_TYPE(s3c2400, 0x2400)
>> +IS_SAMSUNG_TYPE(s3c2410, 0x2410)
>> +IS_SAMSUNG_TYPE(s3c2410a, 0x2411)
>> +IS_SAMSUNG_TYPE(s3c2412, 0x2412)
>> +IS_SAMSUNG_TYPE(s3c2440, 0x2440)
>> +IS_SAMSUNG_TYPE(s3c2440a, 0x2441)
>> +IS_SAMSUNG_TYPE(s3c2442, 0x2442)
>> +IS_SAMSUNG_TYPE(s3c2443, 0x2443)
>> +IS_SAMSUNG_TYPE(s3c6400, 0x6400)
>> +IS_SAMSUNG_TYPE(s3c6410, 0x6410)
>> +IS_SAMSUNG_TYPE(s5pc100, 0xc100)
>> +IS_SAMSUNG_TYPE(s5pc110, 0xc110)
>> +IS_SAMSUNG_TYPE(s5p6442, 0x6442)
>> +
>> +#define cpu_is_s3c2400()             0
>> +#define cpu_is_s3c2410()             0
>> +#define cpu_is_s3c2410a()            0
>> +#define cpu_is_s3c2412()             0
>> +#define cpu_is_s3c2440()             0
>> +#define cpu_is_s3c2440a()            0
>> +#define cpu_is_s3c2442()             0
>> +#define cpu_is_s3c2443()             0
>> +#define cpu_is_s3c6400()             0
>> +#define cpu_is_s3c6410()             0
>> +#define cpu_is_s5pc100()             0
>> +#define cpu_is_s5pc110()             0
>> +#define cpu_is_s5p6442()             0
>> +
>> +#if defined(CONFIG_ARCH_S3C2410)
>> +# undef  cpu_is_s3c2400
>> +# define cpu_is_s3c2400()            is_s3c2400()
>> +#endif
>> +
>> +#if defined(CONFIG_CPU_S3C2410)
>> +# undef  cpu_is_s3c2410
>> +# undef  cpu_is_s3c2410a
>> +# define cpu_is_s3c2410()            is_s3c2410()
>> +# define cpu_is_s3c2410a()           is_s3c2410a()
>> +#endif
>> +
>> +#if defined(CONFIG_CPU_S3C2412)
>> +# undef  cpu_is_s3c2412
>> +# define cpu_is_s3c2412()            is_s3c2412()
>> +#endif
>> +
>> +#if defined(CONFIG_CPU_S3C2440)
>> +# undef  cpu_is_s3c2440
>> +# undef  cpu_is_s3c2440a
>> +# define cpu_is_s3c2440()            is_s3c2440()
>> +# define cpu_is_s3c2440a()           is_s3c2440a()
>> +#endif
>> +
>> +#if defined(CONFIG_CPU_S3C2442)
>> +# undef  cpu_is_s3c2442
>> +# define cpu_is_s3c2442()            is_s3c2442()
>> +#endif
>> +
>> +#if defined(CONFIG_CPU_S3C2443)
>> +# undef  cpu_is_s3c2443
>> +# define cpu_is_s3c2443()            is_s3c2443()
>> +#endif
>> +
>> +#if defined(CONFIG_ARCH_S3C64XX)
>> +# undef  cpu_is_s3c6400
>> +# undef  cpu_is_s3c6410
>> +# define cpu_is_s3c6400()            is_s3c6400()
>> +# define cpu_is_s3c6410()            is_s3c6410()
>> +#endif
>> +
>> +#if defined(CONFIG_ARCH_S5PC1XX) || defined(CONFIG_ARCH_S5PC11X)
>> +# undef  cpu_is_s5pc100
>> +# undef  cpu_is_s5pc110
>> +# define cpu_is_s5pc100()            is_s5pc100()
>> +# define cpu_is_s5pc110()            is_s5pc110()
>> +#endif
>> +
>> +#if defined(CONFIG_CPU_S5P6442)
>> +# undef  cpu_is_s5p6442
>> +# define cpu_is_s5p6442()            is_s5p6442()
>> +#endif
>> +
>> +#endif
>> diff --git a/arch/arm/plat-samsung/init.c b/arch/arm/plat-samsung/init.c
>> index 6790edf..cb3560d 100644
>> --- a/arch/arm/plat-samsung/init.c
>> +++ b/arch/arm/plat-samsung/init.c
>> @@ -30,6 +30,44 @@
>>  #include <plat/regs-serial.h>
>>
>>  static struct cpu_table *cpu;
>> +static unsigned long cpu_id;
>> +
>> +unsigned long samsung_cpu_id(void)
>> +{
>> +     return cpu_id;
>> +}
>> +EXPORT_SYMBOL(samsung_cpu_id);
>> +
>> +static void __init set_cpu_id(unsigned long idcode)
>> +{
>> +     /*
>> +      * cpu_id encoding is as follows
>> +      * cpu_id & 0xff000000 -> S3C Class (24xx/64xx/C1xx)
>> +      * cpu_id & 0xfff00000 -> S3C Sub Class (241x/244x)
>> +      * cpu_id & 0xffff0000 -> S3C Type (2410/2440/6400/6410/C100/C110)
>> +      *
>> +      * Remains[15:0] are reserved
>> +      *
>> +      * 24xx/64xx is started from 0x30000000
>> +      * C1xx is started from 0x40000000
>> +      *
>> +      * Exception:
>> +      *  Store Revision A to 1 such as
>> +      *  s3c2410A to s3c2411
>> +      *  s3c2440A to s3c2441
>> +      */
>> +     if ((idcode >> 28) == 0x4)
>> +             cpu_id = 0xC0000000 | ((idcode & 0x00fff000) << 4);
>> +     else
>> +             cpu_id = (idcode & 0x0ffff000) << 4;
>> +
>> +     if (idcode == 0x32410002 || idcode == 0x32440001)
>> +             cpu_id |= (0x1 << 16);
>> +     if (idcode == 0x32440aaa)       /* s3c2442 */
>> +             cpu_id |= (0x2 << 16);
>> +     if (idcode == 0x0)              /* s3c2400 */
>> +             cpu_id |= (0x2400 << 16);
>> +}
>>
>>  static struct cpu_table * __init s3c_lookup_cpu(unsigned long idcode,
>>                                               struct cpu_table *tab,
>> @@ -53,6 +91,8 @@ void __init s3c_init_cpu(unsigned long idcode,
>>               panic("Unknown S3C24XX CPU");
>>       }
>>
>> +     set_cpu_id(idcode);
>> +
>>       printk("CPU %s (id 0x%08lx)\n", cpu->name, idcode);
>>
>>       if (cpu->map_io == NULL || cpu->init == NULL) {
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
> --
> --
> Ben
>
> Q:      What's a light-year?
> A:      One-third less calories than a regular year.
>
>

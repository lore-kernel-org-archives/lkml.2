Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab0FSOgK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 10:36:10 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47917 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab0FSOgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 10:36:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hPuv5czZ1qGzDF3KHOU1WEjsdvFuwCRiRHcAKH6FZuATH++2v4Bbl4LFeO8KIPuajA
         Zb3+ClIPCeH29+GSYaeB2fK3NHnsl34Blt7oSHRELIKZ6Y+3LZVUWuTkq2b4+xQfcoPj
         13WmteaT48OkZtBoG5UyxGqHqySCuDijVC0LE=
MIME-Version: 1.0
In-Reply-To: <4C1CCBCE.4000307@metafoo.de>
References: <1276924111-11158-1-git-send-email-lars@metafoo.de>
	<1276924111-11158-16-git-send-email-lars@metafoo.de>
	<201006191243.39793.marek.vasut@gmail.com>
	<4C1CC08E.5050009@metafoo.de>
	<4C1CC818.7000009@gmail.com>
	<4C1CCBCE.4000307@metafoo.de>
Date: Sat, 19 Jun 2010 22:36:06 +0800
Message-ID: <AANLkTin2ASknC9B3291nz2zWyEajVYzX0yZ8tSrtxp69@mail.gmail.com>
Subject: Re: [PATCH v2 15/26] RTC: Add JZ4740 RTC driver
From: Wan ZongShun <mcuos.com@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Marek Vasut <marek.vasut@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/19 Lars-Peter Clausen <lars@metafoo.de>:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Wan ZongShun wrote:
>> Hi Lars-Peter,
>>
>>
>>> Hi
>>>
>>> Marek Vasut wrote:
>>>> Dne So 19. června 2010 07:08:20 Lars-Peter Clausen napsal(a):
>>>>
>>>>> This patch adds support for the RTC unit on JZ4740 SoCs.
>>>>>
>>>>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>>>>> Cc: Alessandro Zummo <a.zummo@towertech.it>
>>>>> Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
>>>>> Cc: Wan ZongShun <mcuos.com@gmail.com>
>>>>> Cc: Marek Vasut <marek.vasut@gmail.com>
>>>>> Cc: rtc-linux@googlegroups.com
>>>>>
>>>>> ---
>>>>> Changes since v1
>>>>> - Use dev_get_drvdata directly instead of wrapping it in dev_to_rtc
>>>>> - Add common implementation for jz4740_rtc_{alarm,update}_irq_enable
>>>>> - Check whether rtc structure could be allocated
>>>>> - Fix deadlocks which could occur if the HW was broken
>>>>> ---
>>>>>  drivers/rtc/Kconfig      |   11 ++
>>>>>  drivers/rtc/Makefile     |    1 +
>>>>>  drivers/rtc/rtc-jz4740.c |  341
>>>>> ++++++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 353
>>>>> insertions(+), 0 deletions(-)
>>>>>  create mode 100644 drivers/rtc/rtc-jz4740.c
>>>>>
>>>>> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
>>>>> index 10ba12c..d0ed7e6 100644
>>>>> --- a/drivers/rtc/Kconfig
>>>>> +++ b/drivers/rtc/Kconfig
>>>>> @@ -905,4 +905,15 @@ config RTC_DRV_MPC5121
>>>>>        This driver can also be built as a module. If so, the module
>>>>>        will be called rtc-mpc5121.
>>>>>
>>>>> +config RTC_DRV_JZ4740
>>>>> +    tristate "Ingenic JZ4740 SoC"
>>>>> +    depends on RTC_CLASS
>>>>> +    depends on MACH_JZ4740
>>>>> +    help
>>>>> +      If you say yes here you get support for the Ingenic JZ4740
>>>>> SoC RTC
>>>>> +      controller.
>>>>> +
>>>>> +      This driver can also be buillt as a module. If so, the module
>>>>> +      will be called rtc-jz4740.
>>>>> +
>>>>>  endif # RTC_CLASS
>>>>> diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
>>>>> index 5adbba7..fedf9bb 100644
>>>>> --- a/drivers/rtc/Makefile
>>>>> +++ b/drivers/rtc/Makefile
>>>>> @@ -47,6 +47,7 @@ obj-$(CONFIG_RTC_DRV_EP93XX)    += rtc-ep93xx.o
>>>>>  obj-$(CONFIG_RTC_DRV_FM3130)    += rtc-fm3130.o
>>>>>  obj-$(CONFIG_RTC_DRV_GENERIC)    += rtc-generic.o
>>>>>  obj-$(CONFIG_RTC_DRV_ISL1208)    += rtc-isl1208.o
>>>>> +obj-$(CONFIG_RTC_DRV_JZ4740)    += rtc-jz4740.o
>>>>>  obj-$(CONFIG_RTC_DRV_M41T80)    += rtc-m41t80.o
>>>>>  obj-$(CONFIG_RTC_DRV_M41T94)    += rtc-m41t94.o
>>>>>  obj-$(CONFIG_RTC_DRV_M48T35)    += rtc-m48t35.o
>>>>> diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
>>>>> new file mode 100644
>>>>> index 0000000..720afb2
>>>>> --- /dev/null
>>>>> +++ b/drivers/rtc/rtc-jz4740.c
>>>>> @@ -0,0 +1,341 @@
>>>>> +/*
>>>>> + *  Copyright (C) 2009-2010, Lars-Peter Clausen <lars@metafoo.de>
>>>>> + *    JZ4740 SoC RTC driver
>>>>> + *
>>>>> + *  This program is free software; you can redistribute it
>>>>> and/or modify
>>>>> it + *  under  the terms of  the GNU General Public License as
>>>>> published
>>>>> by the + *  Free Software Foundation;  either version 2 of the
>>>>> License, or
>>>>> (at your + *  option) any later version.
>>>>> + *
>>>>> + *  You should have received a copy of the GNU General Public
>>>>> License
>>>>> along + *  with this program; if not, write to the Free Software
>>>>> Foundation, Inc., + *  675 Mass Ave, Cambridge, MA 02139, USA.
>>>>> + *
>>>>> + */
>>>>> +
>>>>> +#include <linux/kernel.h>
>>>>> +#include <linux/module.h>
>>>>> +#include <linux/platform_device.h>
>>>>> +#include <linux/rtc.h>
>>>>> +#include <linux/slab.h>
>>>>> +#include <linux/spinlock.h>
>>>>> +
>>>>> +#define JZ_REG_RTC_CTRL        0x00
>>>>> +#define JZ_REG_RTC_SEC        0x04
>>>>> +#define JZ_REG_RTC_SEC_ALARM    0x08
>>>>> +#define JZ_REG_RTC_REGULATOR    0x0C
>>>>> +#define JZ_REG_RTC_HIBERNATE    0x20
>>>>> +#define JZ_REG_RTC_SCRATCHPAD    0x34
>>>>> +
>>>>> +#define JZ_RTC_CTRL_WRDY    BIT(7)
>>>>> +#define JZ_RTC_CTRL_1HZ        BIT(6)
>>>>> +#define JZ_RTC_CTRL_1HZ_IRQ    BIT(5)
>>>>> +#define JZ_RTC_CTRL_AF        BIT(4)
>>>>> +#define JZ_RTC_CTRL_AF_IRQ    BIT(3)
>>>>> +#define JZ_RTC_CTRL_AE        BIT(2)
>>>>> +#define JZ_RTC_CTRL_ENABLE    BIT(0)
>>>>> +
>>>>> +struct jz4740_rtc {
>>>>> +    struct resource *mem;
>>>>> +    void __iomem *base;
>>>>> +
>>>>> +    struct rtc_device *rtc;
>>>>> +
>>>>> +    unsigned int irq;
>>>>> +
>>>>> +    spinlock_t lock;
>>>>> +};
>>>>> +
>>>>> +static inline uint32_t jz4740_rtc_reg_read(struct jz4740_rtc
>>>>> *rtc, size_t
>>>>> reg) +{
>>>>> +    return readl(rtc->base + reg);
>>>>> +}
>>>>> +
>>>>> +static inline void jz4740_rtc_wait_write_ready(struct jz4740_rtc
>>>>> *rtc)
>>>>> +{
>>>>> +    uint32_t ctrl;
>>>>> +    int timeout = 1000;
>>>>> +
>>>>> +    do {
>>>>> +        ctrl = jz4740_rtc_reg_read(rtc, JZ_REG_RTC_CTRL);
>>>>> +    } while (!(ctrl & JZ_RTC_CTRL_WRDY) && --timeout);
>>>>>
>>>> if (!timeout) {
>>>>     scream_and_die_in_pain();
>>>>     dev_err("I died");
>>>> ... or something like that ... what if it times out, in this
>>>> implementation, noone will know this failed.
>>>>
>>>> I haven't looked through the whole source code, but can't this be
>>>> wrapped into the reg_write() ?
>>>> }
>>>>
>>> Well IF it will ever die, you'll notice cause your rtc clock won't
>>> work
>>> anymore.
>>>
>>> It could be wrapped into reg_write, but there is a different
>>> version of
>>> the SoC with the only difference of the RTC unit being that a
>>> different
>>> mechanism is used determine whether it is ok to write or not. So it
>>> makes sense to keep it seperate.
>>>>> +}
>>>>> +
>>>>> +static inline void jz4740_rtc_reg_write(struct jz4740_rtc *rtc,
>>>>> size_t
>>>>> reg, +    uint32_t val)
>>>>> +{
>>>>> +    jz4740_rtc_wait_write_ready(rtc);
>>>>> +    writel(val, rtc->base + reg);
>>>>> +}
>>>>> +
>>>>> +static void jz4740_rtc_ctrl_set_bits(struct jz4740_rtc *rtc,
>>>>> uint32_t
>>>>> mask, +    uint32_t val)
>>>>> +{
>>>>> +    unsigned long flags;
>>>>> +    uint32_t ctrl;
>>>>> +
>>>>> +    spin_lock_irqsave(&rtc->lock, flags);
>>>>>
>>>> Can't we use local_irq_save()/local_irq_restore() ?
>>>>
>>> Why would that be preferable? In the non-debug, non-rt case this will
>>> expand to local_irq_{save,restore} anyway, but you'll lose the
>>> semantics
>>> of an lock.
>>
>> Anyway,spin_lock_irqsave is most universal and secure lock function,
>> it can
>> apply to smp or single cpu, it can be ok here.
>>
>>
>>>>
>>>>> +
>>>>> +    ctrl = jz4740_rtc_reg_read(rtc, JZ_REG_RTC_CTRL);
>>>>> +
>>>>> +    /* Don't clear interrupt flags by accident */
>>>>> +    ctrl |= JZ_RTC_CTRL_1HZ | JZ_RTC_CTRL_AF;
>>>>> +
>>>>> +    ctrl &= ~mask;
>>>>> +    ctrl |= val;
>>>>> +
>>>>> +    jz4740_rtc_reg_write(rtc, JZ_REG_RTC_CTRL, ctrl);
>>>>> +
>>>>> +    spin_unlock_irqrestore(&rtc->lock, flags);
>>>>> +}
>>>>> +
>>>>> +static int jz4740_rtc_read_time(struct device *dev, struct
>>>>> rtc_time *time)
>>>>> +{
>>>>> +    struct jz4740_rtc *rtc = dev_get_drvdata(dev);
>>>>> +    uint32_t secs, secs2;
>>>>> +    int timeout = 5;
>>>>> +
>>>>> +    /* If the seconds register is read while it is updated, it
>>>>> can contain a
>>>>> +     * bogus value. This can be avoided by making sure that two
>>>>> consecutive
>>>>> +     * reads have the same value.
>>>>> +     */
>>>>> +    secs = jz4740_rtc_reg_read(rtc, JZ_REG_RTC_SEC);
>>>>> +    secs2 = jz4740_rtc_reg_read(rtc, JZ_REG_RTC_SEC);
>>>>> +
>>>>> +    while (secs != secs2 && --timeout) {
>>>>> +        secs = secs2;
>>>>> +        secs2 = jz4740_rtc_reg_read(rtc, JZ_REG_RTC_SEC);
>>>>> +    }
>>>>> +
>>>>> +    if (timeout == 0)
>>>>> +        return -EIO;
>>>>> +
>>>>> +    rtc_time_to_tm(secs, time);
>>>>> +
>>>>> +    return rtc_valid_tm(time);
>>>>> +}
>>>>> +
>>>>> +static int jz4740_rtc_set_mmss(struct device *dev, unsigned long
>>>>> secs)
>>>>> +{
>>>>> +    struct jz4740_rtc *rtc = dev_get_drvdata(dev);
>>>>> +
>>>>> +    if ((uint32_t)secs != secs)
>>>>> +        return -EINVAL;
>>>>>
>>>> Is the typecast here necessary ?
>>>>
>>> Strictly speaking not.
>>>>
>>>>> +
>>>>> +    jz4740_rtc_reg_write(rtc, JZ_REG_RTC_SEC, secs);
>>>>> +
>>>>> +    return 0;
>>>>> +}
>>>>> +
>>>>> +static int jz4740_rtc_read_alarm(struct device *dev, struct
>>>>> rtc_wkalrm
>>>>> *alrm) +{
>>>>> +    struct jz4740_rtc *rtc = dev_get_drvdata(dev);
>>>>> +    uint32_t secs;
>>>>> +    uint32_t ctrl;
>>>>> +
>>>>> +    secs = jz4740_rtc_reg_read(rtc, JZ_REG_RTC_SEC_ALARM);
>>>>> +
>>>>> +    ctrl = jz4740_rtc_reg_read(rtc, JZ_REG_RTC_CTRL);
>>>>> +
>>>>> +    alrm->enabled = !!(ctrl & JZ_RTC_CTRL_AE);
>>>>> +    alrm->pending = !!(ctrl & JZ_RTC_CTRL_AF);
>>>>> +
>>>>>
>>>> Is the double negation (!!) here necessary ?
>>>>
>>>>
>>> To quote rtc.h "/* 0 = alarm disabled, 1 = alarm enabled */", so yes.
>>
>> You are right, but it is not true reason.
>>
>> Please keep (!!) here, to make sure 'enabled' and 'pending'
>> to be '0' or '1' is good habit, since they are 'unsigned char'
>> variables.
>>
>> Thanks!
>>
>>>>> +    rtc_time_to_tm(secs, &alrm->time);
>>>>> +
>>>>> +    return rtc_valid_tm(&alrm->time);
>>>>> +}
>>>>> +
>>>>> +static int jz4740_rtc_set_alarm(struct device *dev, struct
>>>>> rtc_wkalrm
>>>>> *alrm) +{
>>>>> +    struct jz4740_rtc *rtc = dev_get_drvdata(dev);
>>>>> +    unsigned long secs;
>>>>> +
>>>>> +    rtc_tm_to_time(&alrm->time, &secs);
>>>>> +
>>>>> +    if ((uint32_t)secs != secs)
>>>>> +        return -EINVAL;
>>>>>
>>>> DTTO above
>>>>
>>>>
>>>>> +
>>>>> +    jz4740_rtc_reg_write(rtc, JZ_REG_RTC_SEC_ALARM,
>>>>> (uint32_t)secs);
>>>>>
>>>> DTTO
>>>>
>>>>
>>>>> +    jz4740_rtc_ctrl_set_bits(rtc, JZ_RTC_CTRL_AE,
>>>>> +                    alrm->enabled ? JZ_RTC_CTRL_AE : 0);
>>>>>
>>>> Possibly the double negation above wasn't necessary
>>>>
>>>>
>>>>> +
>>>>> +    return 0;
>>>>> +}
>>>>> +
>>>>> +static inline int jz4740_irq_enable(struct device *dev, int irq,
>>>>> +    unsigned int enable)
>>>>> +{
>>>>> +    struct jz4740_rtc *rtc = dev_get_drvdata(dev);
>>>>> +    jz4740_rtc_ctrl_set_bits(rtc, irq, enable ? irq : 0);
>>>>> +
>>>>> +    return 0;
>>>>> +}
>>>>> +
>>>>> +static int jz4740_rtc_update_irq_enable(struct device *dev,
>>>>> unsigned int
>>>>> enable) +{
>>>>> +    return jz4740_irq_enable(dev, JZ_RTC_CTRL_1HZ_IRQ, enable);
>>>>> +}
>>>>> +
>>>>> +static int jz4740_rtc_alarm_irq_enable(struct device *dev,
>>>>> unsigned int
>>>>> enable) +{
>>>>> +    return jz4740_irq_enable(dev, JZ_RTC_CTRL_AF_IRQ, enable);
>>>>> +}
>>>>> +
>>>>> +static struct rtc_class_ops jz4740_rtc_ops = {
>>>>> +    .read_time    = jz4740_rtc_read_time,
>>>>> +    .set_mmss    = jz4740_rtc_set_mmss,
>>>>> +    .read_alarm    = jz4740_rtc_read_alarm,
>>>>> +    .set_alarm    = jz4740_rtc_set_alarm,
>>>>> +    .update_irq_enable = jz4740_rtc_update_irq_enable,
>>>>> +    .alarm_irq_enable = jz4740_rtc_alarm_irq_enable,
>>>>> +};
>>>>> +
>>>>> +static irqreturn_t jz4740_rtc_irq(int irq, void *data)
>>>>> +{
>>>>> +    struct jz4740_rtc *rtc = data;
>>>>> +    uint32_t ctrl;
>>>>> +    unsigned long events = 0;
>>>>> +    ctrl = jz4740_rtc_reg_read(rtc, JZ_REG_RTC_CTRL);
>>>>> +
>>>>> +    if (ctrl & JZ_RTC_CTRL_1HZ)
>>>>> +        events |= (RTC_UF | RTC_IRQF);
>>>>> +
>>>>> +    if (ctrl & JZ_RTC_CTRL_AF)
>>>>> +        events |= (RTC_AF | RTC_IRQF);
>>>>> +
>>>>> +    rtc_update_irq(rtc->rtc, 1, events);
>>>>> +
>>>>> +    jz4740_rtc_ctrl_set_bits(rtc, JZ_RTC_CTRL_1HZ |
>>>>> JZ_RTC_CTRL_AF, 0);
>>>>> +
>>>>> +    return IRQ_HANDLED;
>>>>> +}
>>>>> +
>>>>> +void jz4740_rtc_poweroff(struct device *dev)
>>>>> +{
>>>>> +    struct jz4740_rtc *rtc = dev_get_drvdata(dev);
>>>>> +    jz4740_rtc_reg_write(rtc, JZ_REG_RTC_HIBERNATE, 1);
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(jz4740_rtc_poweroff);
>>>>> +
>>>>> +static int __devinit jz4740_rtc_probe(struct platform_device *pdev)
>>>>> +{
>>>>> +    int ret;
>>>>> +    struct jz4740_rtc *rtc;
>>>>> +    uint32_t scratchpad;
>>>>> +
>>>>> +    rtc = kmalloc(sizeof(*rtc), GFP_KERNEL);
>>
>> Please use kzalloc or kmalloc plus memset, but you forget to add
>> memset,
>> I prefer kzalloc, of course, you can use latter.
>>
> All fields of the struct are initialized in probe function, so kzalloc
> is unnecessary overhead(small though).

Of course, you have the correct reason, but  using kzalloc is good habit,
now, many people submit their patches to convert kmalloc + memset.

In addition, if some guys write their drivers refer to your this
driver, but they
did not know initializing all the fields of struct is indispensible,
which will be
a potential dangerous.

Other parts of The driver look good to me, except this issue, so I
cannot recommend
it to Andrew for merging your patch, you have to wait for Andrew's ACK.

>>>>> +    if (!rtc)
>>>>> +        return -ENOMEM;
>>>>> +
>>>>> +    rtc->irq = platform_get_irq(pdev, 0);
>>>>> +    if (rtc->irq < 0) {
>>>>> +        ret = -ENOENT;
>>>>> +        dev_err(&pdev->dev, "Failed to get platform irq\n");
>>>>> +        goto err_free;
>>>>> +    }
>>>>> +
>>>>> +    rtc->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>>> +    if (!rtc->mem) {
>>>>> +        ret = -ENOENT;
>>>>> +        dev_err(&pdev->dev, "Failed to get platform mmio
>>>>> memory\n");
>>>>> +        goto err_free;
>>>>> +    }
>>>>> +
>>>>> +    rtc->mem = request_mem_region(rtc->mem->start,
>>>>> resource_size(rtc->mem),
>>>>> +                    pdev->name);
>>>>> +    if (!rtc->mem) {
>>>>> +        ret = -EBUSY;
>>>>> +        dev_err(&pdev->dev, "Failed to request mmio memory
>>>>> region\n");
>>>>> +        goto err_free;
>>>>> +    }
>>>>> +
>>>>> +    rtc->base = ioremap_nocache(rtc->mem->start,
>>>>> resource_size(rtc->mem));
>>>>> +    if (!rtc->base) {
>>>>> +        ret = -EBUSY;
>>>>> +        dev_err(&pdev->dev, "Failed to ioremap mmio memory\n");
>>>>> +        goto err_release_mem_region;
>>>>> +    }
>>>>> +
>>>>> +    spin_lock_init(&rtc->lock);
>>>>> +
>>>>> +    platform_set_drvdata(pdev, rtc);
>>>>>
>>>> dev_set_drvdata()?
>>>>
>>>>
>>> No.
>>>>> +
>>>>> +    rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
>>>>> &jz4740_rtc_ops,
>>>>> +                    THIS_MODULE);
>>>>> +    if (IS_ERR(rtc->rtc)) {
>>>>> +        ret = PTR_ERR(rtc->rtc);
>>>>> +        dev_err(&pdev->dev, "Failed to register rtc device:
>>>>> %d\n", ret);
>>>>> +        goto err_iounmap;
>>>>> +    }
>>>>> +
>>>>> +    ret = request_irq(rtc->irq, jz4740_rtc_irq, 0,
>>>>> +                pdev->name, rtc);
>> In fact, I prefer you can use this IRQ flags, such as IRQF_DISABLED,
>> IRQF_SHARED.
> IRQF_DISABLED is deprecated and IRQF_SHARED doesn't make any sense
> here. In fact not requesting with IRQF_SHARED might help to spot
> errors if another driver requested the IRQ by accident (Or this driver
> requested the wrong irq).
>>
>>>>> +    if (ret) {
>>>>> +        dev_err(&pdev->dev, "Failed to request rtc irq: %d\n",
>>>>> ret);
>>>>> +        goto err_unregister_rtc;
>>>>> +    }
>>>>> +
>>>>> +    scratchpad = jz4740_rtc_reg_read(rtc, JZ_REG_RTC_SCRATCHPAD);
>>>>> +    if (scratchpad != 0x12345678) {
>>>>> +        jz4740_rtc_reg_write(rtc, JZ_REG_RTC_SCRATCHPAD,
>>>>> 0x12345678);
>>>>> +        jz4740_rtc_reg_write(rtc, JZ_REG_RTC_SEC, 0);
>>>>> +    }
>>>>> +
>>>>> +    return 0;
>>>>> +
>>>>> +err_unregister_rtc:
>>>>> +    rtc_device_unregister(rtc->rtc);
>>>>> +err_iounmap:
>>>>> +    platform_set_drvdata(pdev, NULL);
>>>>> +    iounmap(rtc->base);
>>>>> +err_release_mem_region:
>>>>> +    release_mem_region(rtc->mem->start, resource_size(rtc->mem));
>>>>> +err_free:
>>>>> +    kfree(rtc);
>>>>> +
>>>>> +    return ret;
>>>>> +}
>>>>> +
>>>>> +static int __devexit jz4740_rtc_remove(struct platform_device
>>>>> *pdev)
>>>>> +{
>>>>> +    struct jz4740_rtc *rtc = platform_get_drvdata(pdev);
>>>>>
>>>> dev_get_drvdata();
>>>>
>>>>
>>>>> +
>>>>> +    free_irq(rtc->irq, rtc);
>>>>> +
>>>>> +    rtc_device_unregister(rtc->rtc);
>>>>> +
>>>>> +    iounmap(rtc->base);
>>>>> +    release_mem_region(rtc->mem->start, resource_size(rtc->mem));
>>>>> +
>>>>> +    kfree(rtc);
>>>>> +
>>>>> +    platform_set_drvdata(pdev, NULL);
>>>>>
>>>> DTTO
>>>>
>>>>
>>>>> +
>>>>> +    return 0;
>>>>> +}
>>>>> +
>>>>> +struct platform_driver jz4740_rtc_driver = {
>>>>> +    .probe = jz4740_rtc_probe,
>>>>> +    .remove = __devexit_p(jz4740_rtc_remove),
>>>>> +    .driver = {
>>>>> +        .name = "jz4740-rtc",
>>>>> +        .owner = THIS_MODULE,
>>>>> +    },
>>>>> +};
>>>>> +
>>>>> +static int __init jz4740_rtc_init(void)
>>>>> +{
>>>>> +    return platform_driver_register(&jz4740_rtc_driver);
>>>>> +}
>>>>> +module_init(jz4740_rtc_init);
>>>>> +
>>>>> +static void __exit jz4740_rtc_exit(void)
>>>>> +{
>>>>> +    platform_driver_unregister(&jz4740_rtc_driver);
>>>>> +}
>>>>> +module_exit(jz4740_rtc_exit);
>>>>> +
>>>>> +MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
>>>>> +MODULE_LICENSE("GPL");
>>>>> +MODULE_DESCRIPTION("RTC driver for the JZ4740 SoC\n");
>>>>> +MODULE_ALIAS("platform:jz4740-rtc");
>>>>>
>>>> Cheers
>>>>
> Thanks for reviewing
> - - Lars
>
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.9 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
>
> iEYEARECAAYFAkwcy80ACgkQBX4mSR26RiM+lgCfZPjAyf1kJstVzqIVlv2uCGMc
> ruMAoIRF2fDWMG8mQJFb9V7iTmVTSgqs
> =2MQV
> -----END PGP SIGNATURE-----
>
>



-- 
*linux-arm-kernel mailing list
mail addr:linux-arm-kernel@lists.infradead.org
you can subscribe by:
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

* linux-arm-NUC900 mailing list
mail addr:NUC900@googlegroups.com
main web: https://groups.google.com/group/NUC900
you can subscribe it by sending me mail:
mcuos.com@gmail.com

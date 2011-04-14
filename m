Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888Ab1DNO3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:29:33 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39128 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758837Ab1DNO3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:29:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rPX+mioTEhcR73eNEZFEn+dD6GoIFJgqmMhOwvRiI5F1VfZGwqGncBqIZc+MSRqN1l
         55NqP0WlNv9Y51d2VkLmIZLeTmI4lfprj6IwFfytISav46Ia0UuSvaGRkdknZIP36ej2
         EmukPUlDjlJf3NsYWuDpONbH+rJBDV4t04Y5o=
Message-ID: <4DA704BD.7090501@gmail.com>
Date: Thu, 14 Apr 2011 22:29:17 +0800
From: Wanlong Gao <wanlong.gao@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Haojian Zhuang <hzhuang1@marvell.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 06/13] mfd: pxa-w1: MFD driver for PXA 1wire control +
 DS1WM chip
References: <1302706264-25815-1-git-send-email-haojian.zhuang@marvell.com>	<1302706264-25815-2-git-send-email-haojian.zhuang@marvell.com>	<1302706264-25815-3-git-send-email-haojian.zhuang@marvell.com>	<1302706264-25815-4-git-send-email-haojian.zhuang@marvell.com>	<1302706264-25815-5-git-send-email-haojian.zhuang@marvell.com>	<1302706264-25815-6-git-send-email-haojian.zhuang@marvell.com>	<1302706264-25815-7-git-send-email-haojian.zhuang@marvell.com> <BANLkTinf6kB_ifDd-D+cLDHV7SAu0P+wfg@mail.gmail.com> <25B60CDC2F704E4E9D88FFD52780CB4C05CF05AC11@SC-VEXCH1.marvell.com>
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C05CF05AC11@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011-4-14 22:21, Haojian Zhuang 写道:
> 
> 
>> -----Original Message-----
>> From: gaowanlong@gmail.com [mailto:gaowanlong@gmail.com] On Behalf Of
>> Wanlong Gao
>> Sent: 2011年4月14日 10:18 PM
>> To: Haojian Zhuang
>> Cc: sameo@linux.intel.com; haojian.zhuang@gmail.com; linux-
>> kernel@vger.kernel.org; Evgeniy Polyakov
>> Subject: Re: [PATCH 06/13] mfd: pxa-w1: MFD driver for PXA 1wire control
>> + DS1WM chip
>>
>> On 4/13/11, Haojian Zhuang<haojian.zhuang@marvell.com>  wrote:
>>> This driver provides registers and IRQ of PXA3xx chips to the ds1wm
>> driver.
>>>
>>> Signed-off-by: Haojian Zhuang<haojian.zhuang@marvell.com>
>>> Cc: Evgeniy Polyakov<johnpol@2ka.mipt.ru>
>>> ---
>>>   drivers/mfd/Kconfig  |    7 ++
>>>   drivers/mfd/Makefile |    1 +
>>>   drivers/mfd/pxa-w1.c |  150
>>> ++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   3 files changed, 158 insertions(+), 0 deletions(-)
>>>   create mode 100644 drivers/mfd/pxa-w1.c
>>>
>>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>>> index e2fea58..b6ecf90 100644
>>> --- a/drivers/mfd/Kconfig
>>> +++ b/drivers/mfd/Kconfig
>>> @@ -34,6 +34,13 @@ config MFD_88PM860X
>>>   	  select individual components like voltage regulators, RTC and
>>>   	  battery-charger under the corresponding menus.
>>>
>>> +config MFD_PXA_DS1WM
>>> +	tristate "Support DS1WM chip on Marvell silicons"
>>> +	select MFD_CORE
>>> +	help
>>> +	  This core driver provides register access for PXA_DS1WM.
>>> +	  Actual functionality is handled by the ds1wm drivers.
>>> +
>>>   config MFD_SM501
>>>   	tristate "Support for Silicon Motion SM501"
>>>   	 ---help---
>>> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
>>> index 419caa9..4f8d1d2 100644
>>> --- a/drivers/mfd/Makefile
>>> +++ b/drivers/mfd/Makefile
>>> @@ -4,6 +4,7 @@
>>>
>>>   88pm860x-objs			:= 88pm860x-core.o 88pm860x-i2c.o
>>>   obj-$(CONFIG_MFD_88PM860X)	+= 88pm860x.o
>>> +obj-$(CONFIG_MFD_PXA_DS1WM)	+= pxa-w1.o
>>>   obj-$(CONFIG_MFD_SM501)		+= sm501.o
>>>   obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
>>>
>>> diff --git a/drivers/mfd/pxa-w1.c b/drivers/mfd/pxa-w1.c
>>> new file mode 100644
>>> index 0000000..98074ff
>>> --- /dev/null
>>> +++ b/drivers/mfd/pxa-w1.c
>>> @@ -0,0 +1,150 @@
>>> +/*
>>> + * Core driver for PXA DS1WM chip.
>>> + *
>>> + * Copyright (C) 2010 Marvell<jtzhou@marvell.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or
>> modify
>>> + * it under the terms of the GNU General Public License as published
>> by
>>> + * the Free Software Foundation; version 2 of the License.
>>> + */
>>> +
>>> +#include<linux/init.h>
>>> +#include<linux/module.h>
>>> +#include<linux/slab.h>
>>> +#include<linux/platform_device.h>
>>> +#include<linux/gpio.h>
>>> +#include<linux/io.h>
>>> +#include<linux/irq.h>
>>> +#include<linux/clk.h>
>>> +#include<linux/err.h>
>>> +#include<linux/interrupt.h>
>>> +#include<linux/mfd/core.h>
>>> +#include<linux/mfd/ds1wm.h>
>>> +
>>> +struct pxa_w1_info {
>>> +	struct clk *clk;
>>> +};
>>> +
>>> +static int ds1wm_enable(struct platform_device *pdev)
>>> +{
>>> +	struct device *dev = pdev->dev.parent;
>>> +	struct pxa_w1_info *info = dev_get_drvdata(dev);
>>> +
>>> +	clk_enable(info->clk);
>>> +	dev_dbg(dev, "pxa DS1WM clk (active)\n");
>>> +	return 0;
>>> +}
>>> +
>>> +static int ds1wm_disable(struct platform_device *pdev)
>>> +{
>>> +	struct device *dev = pdev->dev.parent;
>>> +	struct pxa_w1_info *info = dev_get_drvdata(dev);
>>> +
>>> +	clk_disable(info->clk);
>>> +	dev_dbg(dev, "pxa DS1WM clk (in-active)\n");
>>> +	return 0;
>>> +}
>>> +
>>> +static struct resource ds1wm_resources[] __devinitdata = {
>>> +	{0, 0, "ds1wm-mem", IORESOURCE_MEM,},
>>> +	{0, 0, "ds1wm-irq", IORESOURCE_IRQ,},
>>> +};
>>> +
>>> +static struct ds1wm_driver_data ds1wm_pdata;
>>> +
>>> +static struct mfd_cell ds1wm_cell __devinitdata = {
>>> +	.name		= "ds1wm",
>>> +	.enable		= ds1wm_enable,
>>> +	.disable	= ds1wm_disable,
>>> +	.platform_data	=&ds1wm_pdata,
>>> +	.pdata_size	= sizeof(ds1wm_pdata),
>>> +	.num_resources	= ARRAY_SIZE(ds1wm_resources),
>>> +	.resources	= ds1wm_resources,
>>> +};
>>> +
>>> +static int __devinit pxa_w1_probe(struct platform_device *pdev)
>>> +{
>>> +	struct ds1wm_driver_data *pdata = pdev->dev.platform_data;
>>> +	struct pxa_w1_info *info;
>>> +	struct resource *r;
>>> +	int ret, irq;
>>> +
>>> +	info = kzalloc(sizeof(struct pxa_w1_info), GFP_KERNEL);
>>> +	if (!info)
>>> +		return -ENOMEM;
>>> +
>>> +	r = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>>> +	if (r == NULL) {
>> Prefer to (!r) ?
> 
> Why do you always stick to use !r? I like to use NULL since it's clear to me.
> 
Use your habits and I just make a noise .
Thanks


>>> +		ret = -ENXIO;
>>> +		goto out;
>>> +	}
>>> +	irq = r->start;
>>> +	if (pdata)
>>> +		ds1wm_pdata.active_high = pdata->active_high;
>>> +	if (ds1wm_pdata.active_high)
>>> +		ds1wm_resources[1].flags |= IORESOURCE_IRQ_HIGHEDGE;
>>> +	else
>>> +		ds1wm_resources[1].flags |= IORESOURCE_IRQ_LOWEDGE;
>>> +
>>> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> +	if (r == NULL) {
>> The same ?
>>> +		ret = -ENXIO;
>>> +		goto out;
>>> +	}
>>> +	ds1wm_resources[0].end = resource_size(r) - 1;
>>> +
>>> +	info->clk = clk_get(&pdev->dev, NULL);
>>> +	if (IS_ERR(info->clk)) {
>>> +		ret = PTR_ERR(info->clk);
>>> +		goto out;
>>> +	}
>>> +	platform_set_drvdata(pdev, info);
>>> +
>>> +	ds1wm_pdata.clock_rate = clk_get_rate(info->clk);
>>> +	ret = mfd_add_devices(&pdev->dev, pdev->id,&ds1wm_cell, 1, r,
>> irq);
>>> +	if (ret<  0)
>>> +		dev_err(&pdev->dev, "failed to register pxa DS1WM\n");
>>> +
>>> +	return 0;
>>> +out:
>>> +	kfree(info);
>>> +	return ret;
>>> +}
>>> +
>>> +static int __devexit pxa_w1_remove(struct platform_device *pdev)
>>> +{
>>> +	struct pxa_w1_info *info = platform_get_drvdata(pdev);
>>> +
>>> +	mfd_remove_devices(&pdev->dev);
>>> +	clk_put(info->clk);
>>> +	kfree(info);
>>> +	platform_set_drvdata(pdev, NULL);
>>> +	return 0;
>>> +}
>>> +
>>> +static struct platform_driver pxa_w1_driver = {
>>> +	.driver = {
>>> +		   .name	= "pxa3xx-w1",
>>> +		   .owner	= THIS_MODULE,
>>> +	},
>>> +	.probe		= pxa_w1_probe,
>>> +	.remove		= __devexit_p(pxa_w1_remove),
>>> +};
>>> +
>>> +static int __init pxa_w1_base_init(void)
>>> +{
>>> +	return platform_driver_register(&pxa_w1_driver);
>>> +}
>>> +
>>> +static void __exit pxa_w1_base_exit(void)
>>> +{
>>> +	platform_driver_unregister(&pxa_w1_driver);
>>> +}
>>> +
>>> +module_init(pxa_w1_base_init);
>>> +module_exit(pxa_w1_base_exit);
>>> +
>>> +MODULE_AUTHOR("Jett Zhou<jtzhou@marvell.com>");
>>> +MODULE_DESCRIPTION("one wire driver for PXA");
>>> +MODULE_LICENSE("GPL");
>>> +MODULE_ALIAS("platform:pxa-w1");
>>
>> Best regards ,
>> Thanks
>>> --
>>> 1.5.6.5
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-
>> kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>


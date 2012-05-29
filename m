Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab2E2GdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 02:33:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49929 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2E2GdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 02:33:08 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7fe76d0000023f5-94-4fc46d9ddc5e
Message-id: <4FC46D9C.4090705@samsung.com>
Date: Tue, 29 May 2012 15:33:00 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpudie@rpsys.net>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-leds@vger.kernel.org,
        Andrew Morton <akpm@google.com>
Subject: Re: [PATCH] leds: MAX77693: Add MAX77694 LED driver
References: <1337933951-22545-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAK5ve-KhE5e8FLwqSBoKVr=KwxCo=hJ2h9QHKLs=oRi+nf3KNA@mail.gmail.com>
In-reply-to: <CAK5ve-KhE5e8FLwqSBoKVr=KwxCo=hJ2h9QHKLs=oRi+nf3KNA@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jAd25uUf8Db7/FLC4vGsOm8XWN+sY
	HZg8Pm+SC2CM4rJJSc3JLEst0rdL4Mq4POU5c0H/BsaKnXdXszcwPqjuYuTkkBAwkXh79gcb
	hC0mceHeeiCbi0NIYBGjxOFFLxlBErwCghI/Jt9j6WLk4GAWkJc4cikbJMwsoC4xad4iZoj6
	t4wS5/5vYoao15LY8ecjmM0ioCrxdtpSJhCbTUBO4m3TN0aQOaICERK/+jlAwiJAJV1dV8H2
	MgvcYpT4934hO0hCWMBG4vHUhawQC/qBEqcvg13KKRAs8bLlDcsERoFZSO6bhXDfLCT3LWBk
	XsUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHIzPpHYwrmywOMQowMGoxMPbkXzEX4g1say4
	MvcQowQHs5IIr2AWUIg3JbGyKrUoP76oNCe1+BCjNAeLkjiv3eId/kIC6YklqdmpqQWpRTBZ
	Jg5OqQbGgvdsK/am6lvO3rW0lm1na8D75AlPtPu/35ZraquTeXPmfBkjl/z/+kT2W4KB1eV7
	H+fu+S4uv2jn9ZjDWlt2JO6rY/4gYLb1qEnI6TtLrd0mPq3M2Zj3Zgfn/9yv8cofWTm/Tsow
	vJx4SeVLw0op9t39v748Xz1pU8z9uwr/NArU+p4vjnQ+qcRSnJFoqMVcVJwIAC3/j3tCAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On 2012년 05월 25일 23:26, Bryan Wu wrote:

> Hi Jonghwa,
> 
> [PATCH] leds: MAX77693: Add MAX77694 LED driver
> 
> The subject is inconsistent, please change it to
> "[PATCH] leds: Add MAX77693 LED driver"
> 
> On Fri, May 25, 2012 at 4:19 PM, Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
>> This patch is initial support for max77693 led driver.
>> MAX77693 has 2 FLEDS, and 2 modes, FLASH/TORCH. It can be set up brightness,
>> opeation, flash timer by platform data, and especially brightness can be modified
>> by led API either. This driver uses regmap to access to its register.
>>
>> Signed-off-by: Jonghwa LEE <jonghwa3.lee@samsung.com>
>> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/leds/Kconfig          |    8 +
>>  drivers/leds/Makefile         |    1 +
>>  drivers/leds/leds-max77693.c  |  301 +++++++++++++++++++++++++++++++++++++++++
>>  include/linux/leds-max77693.h |  154 +++++++++++++++++++++
>>  4 files changed, 464 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/leds/leds-max77693.c
>>  create mode 100644 include/linux/leds-max77693.h
>>
>> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
>> index ff4b8cf..6a644df 100644
>> --- a/drivers/leds/Kconfig
>> +++ b/drivers/leds/Kconfig
>> @@ -387,6 +387,14 @@ config LEDS_TCA6507
>>          LED driver chips accessed via the I2C bus.
>>          Driver support brightness control and hardware-assisted blinking.
>>
>> +config LEDS_MAX77693
>> +       bool "LED support for the MAX77693"
> 
> Can this driver be module? if yes, it should be "tristate".


Okay, I'll modify it.

> 
>> +       depends on LEDS_CLASS
>> +       depends on MFD_MAX77693
> 
> It can be "depends on LEDS_CLASS && MFD_MAX77693" as others
> 
>> +       default y
> 
> I don't think this default is necessary here.


Yes, you're right.

> 
>> +       help
>> +         This option enables support for the LEDs on the MAX77693.
>> +
>>  config LEDS_MAX8997
>>        tristate "LED support for MAX8997 PMIC"
>>        depends on LEDS_CLASS && MFD_MAX8997
>> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
>> index 890481c..ff4ff2c 100644
>> --- a/drivers/leds/Makefile
>> +++ b/drivers/leds/Makefile
>> @@ -45,6 +45,7 @@ obj-$(CONFIG_LEDS_NETXBIG)            += leds-netxbig.o
>>  obj-$(CONFIG_LEDS_ASIC3)               += leds-asic3.o
>>  obj-$(CONFIG_LEDS_RENESAS_TPU)         += leds-renesas-tpu.o
>>  obj-$(CONFIG_LEDS_MAX8997)             += leds-max8997.o
>> +obj-$(CONFIG_LEDS_MAX77693)            += leds-max77693.o
>>
>>  # LED SPI Drivers
>>  obj-$(CONFIG_LEDS_DAC124S085)          += leds-dac124s085.o
>> diff --git a/drivers/leds/leds-max77693.c b/drivers/leds/leds-max77693.c
>> new file mode 100644
>> index 0000000..dee8f59
>> --- /dev/null
>> +++ b/drivers/leds/leds-max77693.c
>> @@ -0,0 +1,301 @@
>> +/*
>> + * LED driver for Maxim MAX77693 - leds-max77673.c
>> + *
>> + * Copyright (C) 2012 Samsung Electronics Co.Ltd
>> + * ByungChang Cha <bc.cha@samsung.com>
>> + * Jonghwa Lee <jonghwa3.lee@samsung.com>
>> + *
>> + * This program is not provided / owned by Maxim Integrated Products.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/init.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/leds.h>
>> +#include <linux/workqueue.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/slab.h>
>> +#include <linux/mfd/max77693.h>
>> +#include <linux/mfd/max77693-private.h>
> 
> Looks like these 2 header files are not in mainline yet. It'd better
> to submit a MFD driver like mfd-max77693 and this leds-max77693 driver
> in one patchset. Otherwise this commit will cause building error.
> 


Sorry, I missed to notify it in patch description.
MAX77693 mfd driver is updated on mfd-2.6/for-next branch.

>> +#include <linux/leds-max77693.h>
> 
> Obviously most content of this header file won't be exposed to users
> like platform device code in ARM world. So please move out those
> register definitions and some local data struct definitions in this C
> file.
> Just keep platform_data struct in the leds-max77693.h and put it in
> include/linux/platform_data/
> 


Okay, I'll do so.

>> +#include <linux/module.h>
>> +#include <linux/regmap.h>
>> +
>> +struct max77693_led_data {
>> +       struct led_classdev led;
>> +       struct max77693_dev *max77693;
>> +       struct max77693_led *data;
>> +       struct regmap *regmap;
>> +       struct work_struct work;
>> +       struct mutex lock;
>> +       spinlock_t value_lock;
> 
> Why do you need 2 different locks here? I think just one of them is OK.
> 


Okay,

>> +       int brightness;
>> +};
>> +
>> +static u8 led_en_mask[MAX77693_LED_MAX] = {
>> +       MAX77693_FLASH_FLED1_EN,
>> +       MAX77693_FLASH_FLED2_EN,
>> +       MAX77693_TORCH_FLED1_EN,
>> +       MAX77693_TORCH_FLED2_EN
>> +};
>> +
>> +static u8 reg_led_timer[MAX77693_LED_MAX] = {
>> +       MAX77693_LED_REG_FLASH_TIMER,
>> +       MAX77693_LED_REG_FLASH_TIMER,
>> +       MAX77693_LED_REG_ITORCHTIMER,
>> +       MAX77693_LED_REG_ITORCHTIMER,
>> +};
>> +
>> +static u8 reg_led_current[MAX77693_LED_MAX] = {
>> +       MAX77693_LED_REG_IFLASH1,
>> +       MAX77693_LED_REG_IFLASH2,
>> +       MAX77693_LED_REG_ITORCH,
>> +       MAX77693_LED_REG_ITORCH,
>> +};
>> +
>> +static u8 led_current_mask[MAX77693_LED_MAX] = {
>> +       MAX77693_FLASH_IOUT1,
>> +       MAX77693_FLASH_IOUT2,
>> +       MAX77693_TORCH_IOUT1,
>> +       MAX77693_TORCH_IOUT2
>> +};
>> +
>> +static u8 led_current_shift[MAX77693_LED_MAX] = {
>> +       0,
>> +       0,
>> +       0,
>> +       4,
>> +};
>> +
>> +static int max77693_led_get_en_value(struct max77693_led_data *led_data, int on)
>> +{
>> +       if (on)
>> +               return MAX77693_FLED_I2C;
>> +
>> +       if (led_data->data->cntrl_mode == MAX77693_LED_CTRL_BY_I2C)
>> +               return MAX77693_FLED_OFF;
>> +       else if (led_data->data->id < 2)
>> +               return MAX77693_FLED_FLASHEN;
>> +       else
>> +               return MAX77693_FLED_TORCHEN;
>> +}
>> +
>> +static void max77693_led_set(struct led_classdev *led_cdev,
>> +                                        enum led_brightness value)
>> +{
>> +       unsigned long flags;
>> +       struct max77693_led_data *led_data
>> +               = container_of(led_cdev, struct max77693_led_data, led);
>> +
>> +       pr_debug("[LED] %s\n", __func__);
> 
> please replace these pr_debug, pr_err and other similar stuff to
> dev_dbg, dev_err.


I'll replace it.

> 
>> +
>> +       spin_lock_irqsave(&led_data->value_lock, flags);
>> +       led_data->brightness = min_t(int, value, MAX77693_FLASH_IOUT1);
>> +       spin_unlock_irqrestore(&led_data->value_lock, flags);
>> +
> 
> This spin_lock looks useless to me, since you have mutex_lock in the
> max77693_led_work. That's enough.
> 


Okay,

>> +       schedule_work(&led_data->work);
>> +}
>> +
>> +static void led_set(struct max77693_led_data *led_data)
>> +{
>> +       int ret;
>> +       struct max77693_led *data = led_data->data;
>> +       int id = data->id;
>> +       u8 mask;
>> +       u8 shift = led_current_shift[id];
>> +       int value;
>> +
>> +               value = max77693_led_get_en_value(led_data, 0);
>> +               mask = led_en_mask[id];
>> +               ret = regmap_update_bits(led_data->regmap,
>> +                                       MAX77693_LED_REG_FLASH_EN,
>> +                                       led_en_mask[id],
>> +                                       value << (ffs(led_en_mask[id]) - 1));
>> +               if (unlikely(ret))
>> +                       goto error_set_bits;
>> +
>> +               ret = regmap_update_bits(led_data->regmap,
>> +                                       reg_led_current[id],
>> +                                       led_current_mask[id],
>> +                                       led_data->brightness << shift);
>> +               if (unlikely(ret))
>> +                       goto error_set_bits;
>> +
>> +               return;
>> +
> Indent is wrong in above section.
> 
> 
>> +error_set_bits:
>> +       pr_err("%s: can't set led level %d\n", __func__, ret);
>> +       return;
>> +}
>> +
>> +static void max77693_led_work(struct work_struct *work)
>> +{
>> +       struct max77693_led_data *led_data
>> +               = container_of(work, struct max77693_led_data, work);
>> +
>> +       pr_debug("[LED] %s\n", __func__);
>> +
>> +       mutex_lock(&led_data->lock);
>> +       led_set(led_data);
>> +       mutex_unlock(&led_data->lock);
>> +}
>> +
>> +static int max77693_led_setup(struct max77693_led_data *led_data)
>> +{
>> +       int ret = 0;
>> +       struct max77693_led *data = led_data->data;
>> +       int id = data->id;
>> +       int value;
>> +
>> +       ret |= regmap_write(led_data->regmap, MAX77693_LED_REG_VOUT_CNTL,
>> +                                 MAX77693_BOOST_FLASH_FLEDNUM_2
>> +                               | MAX77693_BOOST_FLASH_MODE_BOTH);
>> +       ret |= regmap_write(led_data->regmap, MAX77693_LED_REG_VOUT_FLASH1,
>> +                         MAX77693_BOOST_VOUT_FLASH_FROM_VOLT(5000));
>> +       ret |= regmap_write(led_data->regmap,
>> +                       MAX77693_LED_REG_MAX_FLASH1, 0xEC);
>> +       ret |= regmap_write(led_data->regmap,
>> +                       MAX77693_LED_REG_MAX_FLASH2, 0x00);
>> +
>> +       value = max77693_led_get_en_value(led_data, 0);
>> +
>> +       ret |= regmap_update_bits(led_data->regmap,
>> +                                MAX77693_LED_REG_FLASH_EN,
>> +                                led_en_mask[id],
>> +                                value << (ffs(led_en_mask[id]) - 1));
>> +
>> +       /* Set TORCH_TMR_DUR or FLASH_TMR_DUR */
>> +       if (id < 2) {
>> +               ret |= regmap_write(led_data->regmap, reg_led_timer[id],
>> +                               (data->timer | data->timer_mode << 7));
>> +       } else {
>> +               ret |= regmap_write(led_data->regmap, reg_led_timer[id],
>> +                                       0xC0);
>> +       }
>> +
>> +       /* Set current */
>> +       ret |= regmap_update_bits(led_data->regmap, reg_led_current[id],
>> +                       led_current_mask[id],
>> +                       led_data->brightness << led_current_shift[id]);
>> +
>> +       return ret;
>> +}
>> +
>> +static int max77693_led_probe(struct platform_device *pdev)
>> +{
>> +       struct max77693_dev *max77693 = dev_get_drvdata(pdev->dev.parent);
>> +       struct max77693_platform_data *max77693_pdata
>> +                                       = dev_get_platdata(max77693->dev);
>> +       struct max77693_led_platform_data *pdata;
>> +       struct max77693_led *data;
>> +       struct max77693_led_data *led_data;
>> +       struct max77693_led_data **led_datas;
> 
> We got 5 "data" here, Can we choose better name?

>
Okay, I'll consider it.


>> +       int ret = 0;
>> +       int i;
>> +
>> +       if (max77693_pdata->led_data) {
>> +               pdata = max77693_pdata->led_data;
>> +       } else {
>> +               pr_err("%s : No plaform data\n", __func__);
>> +               return -ENODEV;
>> +       }
>> +
> 
> This is not beautiful.
> 
> struct max77693_led_platform_data *pdata = max77693_pdata->led_data;
> 
> if (!pdata) {
>         dev_err(...);
>         return -ENODEV;
> }
> 
>> +       led_datas = devm_kzalloc(max77693->dev,
>> +                               sizeof(struct max77693_led_data *)
>> +                               * MAX77693_LED_MAX, GFP_KERNEL);
>> +       if (unlikely(!led_datas)) {
>> +               pr_err("[LED] memory allocation error %s\n", __func__);
>> +               return -ENOMEM;
>> +       }
>> +
> 
> Why not just use a static pointer array like
> static struct max77693_led_data *led_datas[MAX77693_LED_MAX];
> Actually, I think this led_datas is totally useless. You can add
> "struct max77693_led_data *led_data" in "struct max77693_led".
> Then you can access every led_data like "pdata->leds[i]->led_data"
>


Okay, I'll apply it.


> And where is the definition of MAX77693_LED_MAX, I guess it equals 4.
> But it is missing in this patch, which cause kernel can't be built.
> 

>> +       platform_set_drvdata(pdev, led_datas);

>> +
>> +       for (i = 0; i < pdata->num_leds; i++) {
>> +               data = &(pdata->leds[i]);
>> +               led_data = devm_kzalloc(max77693->dev,
>> +                               sizeof(struct max77693_led_data),
>> +                               GFP_KERNEL);
>> +               led_datas[i] = led_data;
>> +               if (unlikely(!led_data)) {
>> +                       pr_err("[LED] memory allocation error %s\n", __func__);
>> +                       ret = -ENOMEM;
>> +                       continue;
>> +               }
>> +
>> +               led_data->max77693 = max77693;
>> +               led_data->regmap = max77693->regmap;
>> +               led_data->data = data;
>> +               led_data->led.name = data->name;
>> +               led_data->led.brightness_set = max77693_led_set;
>> +               led_data->led.brightness = LED_OFF;
>> +               led_data->brightness = data->brightness;
>> +               led_data->led.flags = LED_CORE_SUSPENDRESUME;
>> +               led_data->led.max_brightness = data->id < 2
>> +                       ? MAX_FLASH_DRV_LEVEL : MAX_TORCH_DRV_LEVEL;
>> +
>> +               mutex_init(&led_data->lock);
>> +               spin_lock_init(&led_data->value_lock);
>> +               INIT_WORK(&led_data->work, max77693_led_work);
>> +
>> +               ret = led_classdev_register(&pdev->dev, &led_data->led);
>> +               if (unlikely(ret)) {
>> +                       pr_err("unable to register LED\n");
>> +                       ret = -EFAULT;
>> +                       continue;
>> +               }
>> +
>> +               ret = max77693_led_setup(led_data);
>> +               if (unlikely(ret)) {
>> +                       pr_err("unable to register LED\n");
> 
> I think this message is a copy&paste from upper lines and meaningless here.
> 


Okay, I'll fix it.

>> +                       led_classdev_unregister(&led_data->led);
>> +                       ret = -EFAULT;
>> +               }
>> +       }
>> +       return ret;
>> +}
>> +
>> +static int __devexit max77693_led_remove(struct platform_device *pdev)
>> +{
>> +       struct max77693_led_data **led_datas = platform_get_drvdata(pdev);
>> +       int i;
>> +
>> +       for (i = 0; i != MAX77693_LED_MAX; ++i) {
>> +               if (led_datas[i] == NULL)
>> +                       continue;
>> +
>> +               cancel_work_sync(&led_datas[i]->work);
>> +               mutex_destroy(&led_datas[i]->lock);
>> +               led_classdev_unregister(&led_datas[i]->led);
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static struct platform_driver max77693_led_driver = {
>> +       .probe          = max77693_led_probe,
>> +       .remove         = __devexit_p(max77693_led_remove),
>> +       .driver         = {
>> +               .name   = "max77693-led",
>> +               .owner  = THIS_MODULE,
>> +       },
>> +};
>> +
>> +static int __init max77693_led_init(void)
>> +{
>> +       return platform_driver_register(&max77693_led_driver);
>> +}
>> +module_init(max77693_led_init);
>> +
>> +static void __exit max77693_led_exit(void)
>> +{
>> +       platform_driver_unregister(&max77693_led_driver);
>> +}
>> +module_exit(max77693_led_exit);
>> +
>> +MODULE_AUTHOR("ByungChang Cha <bc.cha@samsung.com>");
>> +MODULE_DESCRIPTION("MAX77693 LED driver");
>> +MODULE_LICENSE("GPL");
>> diff --git a/include/linux/leds-max77693.h b/include/linux/leds-max77693.h
>> new file mode 100644
>> index 0000000..a50a120
>> --- /dev/null
>> +++ b/include/linux/leds-max77693.h
>> @@ -0,0 +1,154 @@
>> +/*
>> + * leds-max77693.h - Flash-led driver for Maxim MAX77693
>> + *
>> + * Copyright (C) 2012 Samsung Electronics Co.Ltd
>> + * ByungChang Cha <bc.cha@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef __LEDS_MAX77693_H__
>> +#define __LEDS_MAX77693_H__
>> +
>> +/* MAX77693_IFLASH1 */
>> +#define MAX77693_FLASH_IOUT1           0x3F
>> +
>> +/* MAX77693_IFLASH2 */
>> +#define MAX77693_FLASH_IOUT2           0x3F
>> +
>> +/* MAX77693_ITORCH */
>> +#define MAX77693_TORCH_IOUT1           0x0F
>> +#define MAX77693_TORCH_IOUT2           0xF0
>> +
>> +/* MAX77693_TORCH_TIMER */
>> +#define MAX77693_TORCH_TMR_DUR         0x0F
>> +#define MAX77693_DIS_TORCH_TMR         0x40
>> +#define MAX77693_TORCH_TMR_MODE                0x80
>> +#define MAX77693_TORCH_TMR_MODE_ONESHOT        0x00
>> +#define MAX77693_TORCH_TMR_MDOE_MAXTIMER       0x01
>> +
>> +/* MAX77693_FLASH_TIMER */
>> +#define MAX77693_FLASH_TMR_DUR         0x0F
>> +#define MAX77693_FLASH_TMR_MODE                0x80
>> +/* MAX77693_FLASH_TMR_MODE value */
>> +#define MAX77693_FLASH_TMR_MODE_ONESHOT        0x00
>> +#define MAX77693_FLASH_TMR_MDOE_MAXTIMER       0x01
>> +
>> +/* MAX77693_FLASH_EN */
>> +#define MAX77693_TORCH_FLED2_EN                0x03
>> +#define MAX77693_TORCH_FLED1_EN                0x0C
>> +#define MAX77693_FLASH_FLED2_EN                0x30
>> +#define MAX77693_FLASH_FLED1_EN                0xC0
>> +/* MAX77693 FLEDx_EN value */
>> +#define MAX77693_FLED_OFF              0x00
>> +#define MAX77693_FLED_FLASHEN          0x01
>> +#define MAX77693_FLED_TORCHEN          0x02
>> +#define MAX77693_FLED_I2C              0X03
>> +
>> +/* MAX77693_VOUT_CNTL */
>> +#define MAX77693_BOOST_FLASH_MODE      0x07
>> +#define MAX77693_BOOST_FLASH_FLEDNUM   0x80
>> +/* MAX77693_BOOST_FLASH_MODE vaule*/
>> +#define MAX77693_BOOST_FLASH_MODE_OFF  0x00
>> +#define MAX77693_BOOST_FLASH_MODE_FLED1        0x01
>> +#define MAX77693_BOOST_FLASH_MODE_FLED2        0x02
>> +#define MAX77693_BOOST_FLASH_MODE_BOTH 0x03
>> +#define MAX77693_BOOST_FLASH_MODE_FIXED        0x04
>> +/* MAX77693_BOOST_FLASH_FLEDNUM vaule*/
>> +#define MAX77693_BOOST_FLASH_FLEDNUM_1 0x00
>> +#define MAX77693_BOOST_FLASH_FLEDNUM_2 0x80
>> +
>> +/* MAX77693_VOUT_FLASH1 */
>> +#define MAX77693_BOOST_VOUT_FLASH      0x7F
>> +#define MAX77693_BOOST_VOUT_FLASH_FROM_VOLT(mV)                                \
>> +               ((mV) <= 3300 ? 0x00 :                                  \
>> +               ((mV) <= 5500 ? (((mV) - 3300) / 25 + 0x0C) : 0x7F))
>> +
>> +#define MAX_FLASH_CURRENT      1000    /* 1000mA(0x1f) */
>> +#define MAX_TORCH_CURRENT      250     /* 250mA(0x0f) */
>> +#define MAX_FLASH_DRV_LEVEL    63      /* 15.625 + 15.625*63 mA */
>> +#define MAX_TORCH_DRV_LEVEL    15      /* 15.625 + 15.625*15 mA */
>> +
>> +enum max77693_led_id
>> +{
>> +       MAX77693_FLASH_LED_1,
>> +       MAX77693_FLASH_LED_2,
>> +       MAX77693_TORCH_LED_1,
>> +       MAX77693_TORCH_LED_2,
>> +       MAX77693_LED_MAX,
>> +};
>> +
>> +enum max77693_led_time
>> +{
>> +       MAX77693_FLASH_TIME_62P5MS,
>> +       MAX77693_FLASH_TIME_125MS,
>> +       MAX77693_FLASH_TIME_187P5MS,
>> +       MAX77693_FLASH_TIME_250MS,
>> +       MAX77693_FLASH_TIME_312P5MS,
>> +       MAX77693_FLASH_TIME_375MS,
>> +       MAX77693_FLASH_TIME_437P5MS,
>> +       MAX77693_FLASH_TIME_500MS,
>> +       MAX77693_FLASH_TIME_562P5MS,
>> +       MAX77693_FLASH_TIME_625MS,
>> +       MAX77693_FLASH_TIME_687P5MS,
>> +       MAX77693_FLASH_TIME_750MS,
>> +       MAX77693_FLASH_TIME_812P5MS,
>> +       MAX77693_FLASH_TIME_875MS,
>> +       MAX77693_FLASH_TIME_937P5MS,
>> +       MAX77693_FLASH_TIME_1000MS,
>> +       MAX77693_FLASH_TIME_MAX,
>> +};
>> +
>> +enum max77693_torch_time
>> +{
>> +       MAX77693_TORCH_TIME_262MS,
>> +       MAX77693_TORCH_TIME_524MS,
>> +       MAX77693_TORCH_TIME_786MS,
>> +       MAX77693_TORCH_TIME_1048MS,
>> +       MAX77693_TORCH_TIME_1572MS,
>> +       MAX77693_TORCH_TIME_2096MS,
>> +       MAX77693_TORCH_TIME_2620MS,
>> +       MAX77693_TORCH_TIME_3114MS,
>> +       MAX77693_TORCH_TIME_4193MS,
>> +       MAX77693_TORCH_TIME_5242MS,
>> +       MAX77693_TORCH_TIME_6291MS,
>> +       MAX77693_TORCH_TIME_7340MS,
>> +       MAX77693_TORCH_TIME_9437MS,
>> +       MAX77693_TORCH_TIME_11534MS,
>> +       MAX77693_TORCH_TIME_13631MS,
>> +       MAX77693_TORCH_TIME_15728MS,
>> +       MAX77693_TORCH_TIME_MAX,
>> +};
>> +
>> +enum max77693_timer_mode
>> +{
>> +       MAX77693_TIMER_MODE_ONE_SHOT,
>> +       MAX77693_TIMER_MODE_MAX_TIMER,
>> +};
>> +
>> +enum max77693_led_cntrl_mode
>> +{
>> +       MAX77693_LED_CTRL_BY_FLASHSTB,
>> +       MAX77693_LED_CTRL_BY_I2C,
>> +};
>> +
> 
> I think all above can be moved to C file.
> 
>> +struct max77693_led
>> +{
>> +       const char                      *name;
>> +       const char                      *default_trigger;
>> +       int                             id;
>> +       int                             timer;
>> +       int                             brightness;
>> +       enum max77693_timer_mode        timer_mode;
>> +       enum max77693_led_cntrl_mode    cntrl_mode;
>> +};
>> +
>> +struct max77693_led_platform_data
>> +{
>> +       int num_leds;
>> +       struct max77693_led leds[MAX77693_LED_MAX];
>> +};
>> +
>> +#endif
>> --
>> 1.7.4.1
>>
> 
> Thanks,
> -Bryan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


Thank you for your advise, I'll fix it all then re-patch it.

Regards.

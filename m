Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab2IJBzF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 21:55:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45043 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab2IJBzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 21:55:01 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7f586d000007adc-1c-504d48734fed
Message-id: <504D4873.2010508@samsung.com>
Date: Mon, 10 Sep 2012 10:54:59 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: Re: [PATCH] clock: max77686: Add driver for Maxim 77686 32Khz crystal
 oscillator.
References: <1346144068-13371-1-git-send-email-jonghwa3.lee@samsung.com>
 <20120907000410.20289.117@nucleus>
In-reply-to: <20120907000410.20289.117@nucleus>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t9jQd1iD98Ag6sbZS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldGT+dqtoJ1IRWP311gbWCcY93FyMkhIWAiMeX6PmYIW0ziwr31
	bCC2kMB0RoltLSwgNq+AoMSPyfeAbA4OZgF5iSOXskHCzALqEpPmLQJq5QIq72KSeL/vGSNE
	vZbEwt4LYDaLgKrExMPfwGayCchJvG36xggyR1QgQuJXPwdIWASofNuBVjaImcUSZz/cZwWx
	hQViJPr69jBCnJMrcezfN7BzOAX0JW5eOscygVFgFpLrZiFcNwvJdQsYmVcxiqYWJBcUJ6Xn
	GukVJ+YWl+al6yXn525iBIfeM+kdjKsaLA4xCnAwKvHwdpj4BgixJpYVV+YeYpTgYFYS4bV8
	5xMgxJuSWFmVWpQfX1Sak1p8iFGag0VJnNfpnF2AkEB6YklqdmpqQWoRTJaJg1OqgbH3zaqF
	sZZHrvNc0tiSxs+97l70Ofliq0VCTQnvVTTcvp514dv02qLsvW1oCP+XyY9ZupgWl2o2V59d
	Y6R3dOnl+P/vYps9Ji/70mvW/HSn8b7nESXecm9rfnY/uSv83uuWjzaXN58c07H5Dm9Zd/ek
	83TannF/n2UiIH65SG2dVLXPi8IvT5VYijMSDbWYi4oTAVLqxgU5AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 09월 07일 09:04, Mike Turquette wrote:

> Quoting Jonghwa Lee (2012-08-28 01:54:28)
>> This patch supports max77686 mfd's clock driver using common clock frame work.
>> max77686 has 3 clock ouputs which all are generated from crystal oscillator and
>> SOC can enable/disable them via I2C bus. All clocks are fixed-rate clock sources
>> so that it doesn't supply interface for changing clock rate.
>> Driver uses regmap API to communicate with internal register.
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> 
> Looks good.  I've taken this into clk-next.
> 
> Regards,
> Mike
> 


Thanks,

Best Regards,
Jonghwa

>> ---
>> v5
>>  - Add registering failure handle for each clocks to prevent memory leak.
>>  - Update to use the latest clk_register. (Add clk_init_data).
>>  - Rename Kconfig menu's name and replace its position.
>>
>> v4
>>  https://lkml.org/lkml/2012/6/27/183
>>
>>  drivers/clk/Kconfig        |    6 +
>>  drivers/clk/Makefile       |    1 +
>>  drivers/clk/clk-max77686.c |  244 ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 251 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/clk/clk-max77686.c
>>
>> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
>> index 7f0b5ca..f300ec7 100644
>> --- a/drivers/clk/Kconfig
>> +++ b/drivers/clk/Kconfig
>> @@ -40,4 +40,10 @@ config COMMON_CLK_WM831X
>>            Supports the clocking subsystem of the WM831x/2x series of
>>           PMICs from Wolfson Microlectronics.
>>  
>> +config COMMON_CLK_MAX77686
>> +       tristate "Clock driver for Maxim 77686 MFD"
>> +       depends on MFD_MAX77686
>> +       ---help---
>> +         This driver supports Maxim 77686 crystal oscillator clock. 
>> +
>>  endmenu
>> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
>> index 5869ea3..97f5c57 100644
>> --- a/drivers/clk/Makefile
>> +++ b/drivers/clk/Makefile
>> @@ -13,3 +13,4 @@ obj-$(CONFIG_ARCH_INTEGRATOR) += versatile/
>>  
>>  # Chip specific
>>  obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
>> +obj-$(CONFIG_COMMON_CLK_MAX77686) += clk-max77686.o
>> diff --git a/drivers/clk/clk-max77686.c b/drivers/clk/clk-max77686.c
>> new file mode 100644
>> index 0000000..ac5f543
>> --- /dev/null
>> +++ b/drivers/clk/clk-max77686.c
>> @@ -0,0 +1,244 @@
>> +/*
>> + * clk-max77686.c - Clock driver for Maxim 77686
>> + *
>> + * Copyright (C) 2012 Samsung Electornics
>> + * Jonghwa Lee <jonghwa3.lee@samsung.com>
>> + *
>> + * This program is free software; you can redistribute  it and/or modify it
>> + * under  the terms of  the GNU General  Public License as published by the
>> + * Free Software Foundation;  either version 2 of the  License, or (at your
>> + * option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>> + *
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/slab.h>
>> +#include <linux/err.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/mfd/max77686.h>
>> +#include <linux/mfd/max77686-private.h>
>> +#include <linux/clk-provider.h>
>> +#include <linux/mutex.h>
>> +#include <linux/clkdev.h>
>> +
>> +enum {
>> +       MAX77686_CLK_AP = 0,
>> +       MAX77686_CLK_CP,
>> +       MAX77686_CLK_PMIC,
>> +       MAX77686_CLKS_NUM,
>> +};
>> +
>> +struct max77686_clk {
>> +       struct max77686_dev *iodev;
>> +       u32 mask;
>> +       struct clk_hw hw;
>> +       struct clk_lookup *lookup;
>> +};
>> +
>> +static struct max77686_clk *get_max77686_clk(struct clk_hw *hw)
>> +{
>> +       return container_of(hw, struct max77686_clk, hw);
>> +}
>> +
>> +static int max77686_clk_prepare(struct clk_hw *hw)
>> +{
>> +       struct max77686_clk *max77686;
>> +       int ret;
>> +
>> +       max77686 = get_max77686_clk(hw);
>> +       if (!max77686)
>> +               return -ENOMEM;
>> +
>> +       ret = regmap_update_bits(max77686->iodev->regmap,
>> +               MAX77686_REG_32KHZ, max77686->mask, max77686->mask);
>> +
>> +       return ret;
>> +}
>> +
>> +static void max77686_clk_unprepare(struct clk_hw *hw)
>> +{
>> +       struct max77686_clk *max77686;
>> +
>> +       max77686 = get_max77686_clk(hw);
>> +       if (!max77686)
>> +               return;
>> +
>> +       regmap_update_bits(max77686->iodev->regmap,
>> +               MAX77686_REG_32KHZ, max77686->mask, ~max77686->mask);
>> +}
>> +
>> +static int max77686_clk_is_enabled(struct clk_hw *hw)
>> +{
>> +       struct max77686_clk *max77686;
>> +       int ret;
>> +       u32 val;
>> +
>> +       max77686 = get_max77686_clk(hw);
>> +       if (!max77686)
>> +               return -ENOMEM;
>> +
>> +       ret = regmap_read(max77686->iodev->regmap,
>> +                               MAX77686_REG_32KHZ, &val);
>> +
>> +       if (ret < 0)
>> +               return -EINVAL;
>> +
>> +       return val & max77686->mask;
>> +}
>> +
>> +static struct clk_ops max77686_clk_ops = {
>> +       .prepare        = max77686_clk_prepare,
>> +       .unprepare      = max77686_clk_unprepare,
>> +       .is_enabled     = max77686_clk_is_enabled,
>> +};
>> +
>> +static struct clk_init_data max77686_clks_init[MAX77686_CLKS_NUM] = {
>> +       [MAX77686_CLK_AP] = {
>> +               .name = "32khz_ap",
>> +               .ops = &max77686_clk_ops,
>> +               .flags = CLK_IS_ROOT,
>> +       },
>> +       [MAX77686_CLK_CP] = {
>> +               .name = "32khz_cp",
>> +               .ops = &max77686_clk_ops,
>> +               .flags = CLK_IS_ROOT,
>> +       },
>> +       [MAX77686_CLK_PMIC] = {
>> +               .name = "32khz_pmic",
>> +               .ops = &max77686_clk_ops,
>> +               .flags = CLK_IS_ROOT,
>> +       },
>> +};
>> +
>> +static int max77686_clk_register(struct device *dev,
>> +                               struct max77686_clk *max77686)
>> +{
>> +       struct clk *clk;
>> +       struct clk_hw *hw = &max77686->hw;
>> +
>> +       clk = clk_register(dev, hw);
>> +
>> +       if (IS_ERR(clk))
>> +               return -ENOMEM;
>> +
>> +       max77686->lookup = devm_kzalloc(dev, sizeof(struct clk_lookup),
>> +                                       GFP_KERNEL);
>> +       if (IS_ERR(max77686->lookup))
>> +               return -ENOMEM;
>> +
>> +       max77686->lookup->con_id = hw->init->name;
>> +       max77686->lookup->clk = clk;
>> +
>> +       clkdev_add(max77686->lookup);
>> +
>> +       return 0;
>> +}
>> +
>> +static __devinit int max77686_clk_probe(struct platform_device *pdev)
>> +{
>> +       struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
>> +       struct max77686_clk **max77686_clks;
>> +       int i, ret;
>> +
>> +       max77686_clks = devm_kzalloc(&pdev->dev, sizeof(struct max77686_clk *)
>> +                                       * MAX77686_CLKS_NUM, GFP_KERNEL);
>> +       if (IS_ERR(max77686_clks))
>> +               return -ENOMEM;
>> +
>> +       for (i = 0; i < MAX77686_CLKS_NUM; i++) {
>> +               max77686_clks[i] = devm_kzalloc(&pdev->dev,
>> +                                       sizeof(struct max77686_clk), GFP_KERNEL);
>> +               if (IS_ERR(max77686_clks[i]))
>> +                       return -ENOMEM;
>> +       }
>> +
>> +       for (i = 0; i < MAX77686_CLKS_NUM; i++) {
>> +               max77686_clks[i]->iodev = iodev;
>> +               max77686_clks[i]->mask = 1 << i;
>> +               max77686_clks[i]->hw.init = &max77686_clks_init[i];
>> +
>> +               ret = max77686_clk_register(&pdev->dev, max77686_clks[i]);
>> +               if (ret) {
>> +                       switch (i) {
>> +                       case MAX77686_CLK_AP:
>> +                               dev_err(&pdev->dev, "Fail to register CLK_AP\n");
>> +                               goto err_clk_ap;
>> +                               break;
>> +                       case MAX77686_CLK_CP:
>> +                               dev_err(&pdev->dev, "Fail to register CLK_CP\n");
>> +                               goto err_clk_cp;
>> +                               break;
>> +                       case MAX77686_CLK_PMIC:
>> +                               dev_err(&pdev->dev, "Fail to register CLK_PMIC\n");
>> +                               goto err_clk_pmic;
>> +                       }
>> +               }
>> +       }
>> +
>> +       platform_set_drvdata(pdev, max77686_clks);
>> +
>> +       goto out;
>> +
>> +err_clk_pmic:
>> +       clkdev_drop(max77686_clks[MAX77686_CLK_CP]->lookup);
>> +       kfree(max77686_clks[MAX77686_CLK_CP]->hw.clk);
>> +err_clk_cp:
>> +       clkdev_drop(max77686_clks[MAX77686_CLK_AP]->lookup);
>> +       kfree(max77686_clks[MAX77686_CLK_AP]->hw.clk);
>> +err_clk_ap:
>> +out:
>> +       return ret;
>> +}
>> +
>> +static int __devexit max77686_clk_remove(struct platform_device *pdev)
>> +{
>> +       struct max77686_clk **max77686_clks = platform_get_drvdata(pdev);
>> +       int i;
>> +
>> +       for (i = 0; i < MAX77686_CLKS_NUM; i++) {
>> +               clkdev_drop(max77686_clks[i]->lookup);
>> +               kfree(max77686_clks[i]->hw.clk);
>> +       }
>> +       return 0;
>> +}
>> +
>> +static const struct platform_device_id max77686_clk_id[] = {
>> +       { "max77686-clk", 0},
>> +       { },
>> +};
>> +MODULE_DEVICE_TABLE(platform, max77686_clk_id);
>> +
>> +static struct platform_driver max77686_clk_driver = {
>> +       .driver = {
>> +               .name  = "max77686-clk",
>> +               .owner = THIS_MODULE,
>> +       },
>> +       .probe = max77686_clk_probe,
>> +       .remove = __devexit_p(max77686_clk_remove),
>> +       .id_table = max77686_clk_id,
>> +};
>> +
>> +static int __init max77686_clk_init(void)
>> +{
>> +       return platform_driver_register(&max77686_clk_driver);
>> +}
>> +subsys_initcall(max77686_clk_init);
>> +
>> +static void __init max77686_clk_cleanup(void)
>> +{
>> +       platform_driver_unregister(&max77686_clk_driver);
>> +}
>> +module_exit(max77686_clk_cleanup);
>> +
>> +MODULE_DESCRIPTION("MAXIM 77686 Clock Driver");
>> +MODULE_AUTHOR("Jonghwa Lee <jonghwa3.lee@samsung.com>");
>> +MODULE_LICENSE("GPL");
>> -- 
>> 1.7.4.1
> 



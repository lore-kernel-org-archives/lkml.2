Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab2GJQUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:20:21 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50521 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2GJQUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:20:18 -0400
Message-ID: <4FFC563D.2080807@linaro.org>
Date: Tue, 10 Jul 2012 18:20:13 +0200
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Subject: Re: [PATCH] mfd: Implement devicetree support for AB8500 Btemp
References: <1341926639-9956-1-git-send-email-rajanikanth.hv@stericsson.com>
In-Reply-To: <1341926639-9956-1-git-send-email-rajanikanth.hv@stericsson.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of my comments are picky, but if it's going into Mainline, it 
should at least look professional.

You didn't CC the ST-Ericsson internal mailing list.

Address is STEricsson_nomadik_linux@list.st.com

I'll do it for now, but please do so on your next submission.

On 10/07/12 15:23, Rajanikanth H.V wrote:
> From: "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>
>
>      This patch adds device tree support for
>      battery temperature monitor driver
>
> Signed-off-by: Rajanikanth H.V <rajanikanth.hv@stericsson.com>
> ---
>   .../bindings/power_supply/ab8500/btemp.txt         |   54 ++
>   arch/arm/boot/dts/db8500.dtsi                      |   17 +
>   arch/arm/mach-ux500/Makefile                       |    4 +-
>   arch/arm/mach-ux500/board-mop500-bm.c              |  532 ++++++++++++++++++++
>   arch/arm/mach-ux500/include/mach/board-mop500-bm.h |   24 +
>   drivers/mfd/ab8500-core.c                          |    1 +
>   drivers/power/Kconfig                              |    8 +-
>   drivers/power/ab8500_btemp.c                       |   79 ++-
>   include/linux/mfd/ab8500/pwmleds.h                 |   20 +
>   9 files changed, 722 insertions(+), 17 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/power_supply/ab8500/btemp.txt
>   create mode 100644 arch/arm/mach-ux500/board-mop500-bm.c
>   create mode 100644 arch/arm/mach-ux500/include/mach/board-mop500-bm.h
>   create mode 100644 include/linux/mfd/ab8500/pwmleds.h
>
> diff --git a/Documentation/devicetree/bindings/power_supply/ab8500/btemp.txt b/Documentation/devicetree/bindings/power_supply/ab8500/btemp.txt
> new file mode 100644
> index 0000000..8543ed1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power_supply/ab8500/btemp.txt
> @@ -0,0 +1,54 @@
> +AB8500 Battery Termperature Monitor Driver

Spelling.

> +
> +AB8500 is a mixed signal multimedia and power management
> +device comprising: power and energy management module,
> +WalliCharger and USB charger interface, audio, general
> +purpose ADC TVOut, clock management and SIM card Interface.

Mixture of capitalised and otherwise device names.

> +
> +Battery temperature monitoring support is part of 'energy
> +management module', the other components of this module
> +are: 'main and USB Combo charger' and fuel guage.

Spelling. Mixed use of ''.

> +The properties below describes the node for battery
> +temperature monitor driver.
> +
> +Required Properties:
> +- compatible = "stericsson,ab8500-btemp"
> +
> +interrupts:
> +	Four battery temperature ranges are be defined
> +	which results in interrupt events as:
> +	- Btemp
> +	- BtempLow
> +	- BtempMedium
> +	- BtempHigh
> +
> +
> +Supplied-to:
> +	This shall be power supply class dependency where in the runtime battery
> +	properties will be shared across fuel guage and charging algorithm driver.

Spelling.

> +
> +Thermister-interface:
> +	'btemp' and 'batctrl' are the pins interfaced for battery temperature
> +	measurement, btemp is used when NTC(Negative Termperature coefficient)

Spelling.

> +	resister is interfaced external to battery and batctrl is used when
> +	NTC resister is internal to battery.
> +
> +example:
> +ab8500-btemp {
> +	compatible = "stericsson,ab8500-btemp";
> +
> +	interrupt-names =
> +		"BAT_CTRL_INDB",	/* battery removal indicator */
> +		"BTEMP_LOW", 		/* Btemp < BtempLow, if battery temperature is lower than -10°C */
> +		"BTEMP_HIGH",		/* BtempLow < Btemp < BtempMedium,
> +								if battery temperature is between -10 and 0°C */
> +		"BTEMP_LOW_MEDIUM", /* BtempMedium < Btemp < BtempHigh,
> +								if battery temperature is between 0°C and “MaxTemp”.*/
> +		"BTEMP_MEDIUM_HIGH";/* Btemp > BtempHigh,
> +								if battery temperature is higher than “MaxTemp”. */
> +
> +	supplied-to = "ab8500_chargalg", "ab8500_fg";
> +
> +	thermister-internal-to-battery = <1>;
> +};
> diff --git a/arch/arm/boot/dts/db8500.dtsi b/arch/arm/boot/dts/db8500.dtsi
> index 7279165..527fdc3 100644
> --- a/arch/arm/boot/dts/db8500.dtsi
> +++ b/arch/arm/boot/dts/db8500.dtsi
> @@ -330,6 +330,23 @@
>   					vddadc-supply = <&ab8500_ldo_tvout_reg>;
>   				};
>
> +				ab8500-btemp {
> +					compatible = "stericsson,ab8500-btemp";
> +					interrupts = <20 0x04
> +								80 0x04
> +								81 0x04
> +								82 0x04
> +								83 0x04>;

Odd tabbing.

> +					interrupt-names = "BAT_CTRL_INDB",
> +									"BTEMP_LOW",
> +									"BTEMP_HIGH",
> +									"BTEMP_LOW_MEDIUM",
> +									"BTEMP_MEDIUM_HIGH";

As above.

> +					supplied_to = "ab8500_chargalg", "ab8500_fg";
> +					num_supplicants = <2>;
> +					battery_term_on_batctrl = <1>;
> +				};
> +
>   				ab8500-usb {
>   					compatible = "stericsson,ab8500-usb";
>   					interrupts = < 90 0x4
> diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
> index 026086f..b474917 100644
> --- a/arch/arm/mach-ux500/Makefile
> +++ b/arch/arm/mach-ux500/Makefile
> @@ -12,6 +12,8 @@ obj-$(CONFIG_MACH_MOP500)	+= board-mop500.o board-mop500-sdi.o \
>   				board-mop500-uib.o board-mop500-stuib.o \
>   				board-mop500-u8500uib.o \
>   				board-mop500-pins.o \
> -				board-mop500-msp.o
> +				board-mop500-msp.o \
> +				board-mop500-bm.o
> +

Unrelated line change.

>   obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
>   obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o

> diff --git a/arch/arm/mach-ux500/board-mop500-bm.c b/arch/arm/mach-ux500/board-mop500-bm.c
> diff --git a/arch/arm/mach-ux500/include/mach/board-mop500-bm.h b/arch/arm/mach-ux500/include/mach/board-mop500-bm.h

It would be better if you can find a way to not upstream these.

I think this data would be better suited for an include header file.

> diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
> index 738b9c5..402f630 100644
> --- a/drivers/mfd/ab8500-core.c
> +++ b/drivers/mfd/ab8500-core.c
> @@ -1046,6 +1046,7 @@ static struct mfd_cell __devinitdata ab8500_bm_devs[] = {
>   	},
>   	{
>   		.name = "ab8500-btemp",
> +		.of_compatible = "stericsson,ab8500-btemp",
>   		.num_resources = ARRAY_SIZE(ab8500_btemp_resources),
>   		.resources = ab8500_btemp_resources,
>   	},
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index e3a3b49..00dec0f 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -303,10 +303,10 @@ config AB8500_BM
>   	help
>   	  Say Y to include support for AB5500 battery management.
>
> -config AB8500_BATTERY_THERM_ON_BATCTRL
> -	bool "Thermistor connected on BATCTRL ADC"
> +config AB8500_9100_LI_ION_BATTERY
> +	bool "Enable support of the 9100 Li-ion battery charging"
>   	depends on AB8500_BM
>   	help
> -	  Say Y to enable battery temperature measurements using
> -	  thermistor connected on BATCTRL ADC.
> +		Say Y to enable support of the 9100 Li-ion battery charging.
> +

Random formatting.

>   endif # POWER_SUPPLY
> diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
> index bba3cca..1272bba 100644
> --- a/drivers/power/ab8500_btemp.c
> +++ b/drivers/power/ab8500_btemp.c
> @@ -16,6 +16,7 @@
>   #include <linux/interrupt.h>
>   #include <linux/delay.h>
>   #include <linux/slab.h>
> +#include <linux/of.h>
>   #include <linux/platform_device.h>
>   #include <linux/power_supply.h>
>   #include <linux/completion.h>
> @@ -25,6 +26,7 @@
>   #include <linux/mfd/abx500/ab8500-bm.h>
>   #include <linux/mfd/abx500/ab8500-gpadc.h>
>   #include <linux/jiffies.h>
> +#include <mach/board-mop500-bm.h>
>
>   #define VTVOUT_V			1800
>
> @@ -964,11 +966,13 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
>   {
>   	int irq, i, ret = 0;
>   	u8 val;
> -	struct abx500_bm_plat_data *plat_data = pdev->dev.platform_data;

I already told you about this.

> +	struct device_node *np = pdev->dev.of_node;
>   	struct ab8500_btemp *di;
> +	u32 pval;
> +	const char *sup_val;
>
> -	if (!plat_data) {
> -		dev_err(&pdev->dev, "No platform data\n");

And this. Check the last review I provided.

> +	if (!np) {
> +		dev_err(&pdev->dev, "No DT node for btemp found\n");
>   		return -EINVAL;
>   	}
>
> @@ -981,21 +985,64 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
>   	di->parent = dev_get_drvdata(pdev->dev.parent);
>   	di->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
>
> -	/* get btemp specific platform data */
> -	di->pdata = plat_data->btemp;
> -	if (!di->pdata) {
> -		dev_err(di->dev, "no btemp platform data supplied\n");

We still need to support registering from platform code.

> +	di->pdata =
> +		kzalloc(sizeof(struct abx500_btemp_platform_data), GFP_KERNEL);

Use devm_kzalloc instead.

> +	if (di->pdata == NULL) {
> +		ret = -ENOMEM;
> +		goto free_device_info;
> +	}
> +	/* get battery specific platform data */
> +	ret = of_property_read_u32(np, "num_supplicants", &pval);
> +	if (ret) {
> +		dev_err(di->dev, "missing property num_supplicants\n");
> +		kfree(di->pdata);

Then remove this line.

> +		ret = -EINVAL;
> +		goto free_device_info;
> +	}
> +	di->pdata->num_supplicants = pval;
> +	di->pdata->supplied_to =
> +		kzalloc(di->pdata->num_supplicants *
> +			sizeof(const char *), GFP_KERNEL);
> +	if (di->pdata->supplied_to == NULL) {
> +		kfree(di->pdata);
>   		ret = -EINVAL;
>   		goto free_device_info;
>   	}
>
> -	/* get battery specific platform data */
> -	di->bat = plat_data->battery;

Don't remove this, check for it.

> +	for (val = 0; val < di->pdata->num_supplicants; ++val)
> +		if (of_property_read_string_index
> +			(np, "supplied_to", val, &sup_val) == 0)
> +			*(di->pdata->supplied_to + val) = (char *)sup_val;
> +		else {
> +			dev_err(di->dev, "insufficient number of supplied_to data found\n");
> +			kfree(di->pdata);
> +			kfree(di->pdata->supplied_to);
> +			ret = -EINVAL;
> +			goto free_device_info;
> +		}
> +
> +	di->bat = kzalloc(sizeof(struct abx500_bm_data), GFP_KERNEL);
>   	if (!di->bat) {
> -		dev_err(di->dev, "no battery platform data supplied\n");
> -		ret = -EINVAL;
> +		kfree(di->pdata->supplied_to);
> +		kfree(di->pdata);
> +		ret = -ENOMEM;
>   		goto free_device_info;
>   	}
> +	dev_dbg(di->dev, "getting battery information\n");

Is this really necessary?

> +	di->bat = &ab8500_bm_data;
> +	ret = of_property_read_u32(np, "battery_term_on_batctrl", &pval);
> +	if (ret) {
> +		dev_err(di->dev, "missing property battery_term_on_batctrl\n");
> +		kfree(di->pdata->supplied_to);
> +		kfree(di->pdata);
> +		kfree(di->bat);
> +		ret = -ENOMEM;
> +		goto free_device_info;
> +	}
> +	if (pval == 0) {
> +		di->bat->bat_type = bat_type_ext_thermister;
> +		di->bat->adc_therm = ABx500_ADC_THERM_BATTEMP;
> +	}
>
>   	/* BTEMP supply */
>   	di->btemp_psy.name = "ab8500_btemp";
> @@ -1008,7 +1055,6 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
>   	di->btemp_psy.external_power_changed =
>   		ab8500_btemp_external_power_changed;
>
> -

Unrelated change.

>   	/* Create a work queue for the btemp */
>   	di->btemp_wq =
>   		create_singlethread_workqueue("ab8500_btemp_wq");
> @@ -1090,14 +1136,22 @@ free_irq:
>   		irq = platform_get_irq_byname(pdev, ab8500_btemp_irq[i].name);
>   		free_irq(irq, di);
>   	}
> +

As above.

>   free_btemp_wq:
>   	destroy_workqueue(di->btemp_wq);
> +

As above.

>   free_device_info:
>   	kfree(di);
>
>   	return ret;
>   }
>
> +static const struct of_device_id ab8500_btemp_match[] = {
> +	{.compatible = "stericsson,ab8500-btemp",},

Spacing is not consistent with previous submissions.

> +	{},
> +};
> +
> +
>   static struct platform_driver ab8500_btemp_driver = {
>   	.probe = ab8500_btemp_probe,
>   	.remove = __devexit_p(ab8500_btemp_remove),
> @@ -1106,6 +1160,7 @@ static struct platform_driver ab8500_btemp_driver = {
>   	.driver = {
>   		.name = "ab8500-btemp",
>   		.owner = THIS_MODULE,
> +		.of_match_table = ab8500_btemp_match,
>   	},
>   };
>
> diff --git a/include/linux/mfd/ab8500/pwmleds.h b/include/linux/mfd/ab8500/pwmleds.h
> new file mode 100644
> index 0000000..e316582
> --- /dev/null
> +++ b/include/linux/mfd/ab8500/pwmleds.h
> @@ -0,0 +1,20 @@
> +/*
> + * Copyright ST-Ericsson 2012.
> + *
> + * Author: Naga Radhesh <naga.radheshy@stericsson.com>
> + * Licensed under GPLv2.
> + */
> +#ifndef _AB8500_PWMLED_H
> +#define _AB8500_PWMLED_H
> +
> +struct ab8500_led_pwm {
> +	int	pwm_id;
> +	int	blink_en;
> +};
> +
> +struct ab8500_pwmled_platform_data {
> +	int	num_pwm;
> +	struct	ab8500_led_pwm *leds;
> +};
> +
> +#endif
>


-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog



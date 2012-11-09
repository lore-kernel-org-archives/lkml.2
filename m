Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab2KILBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:01:46 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51324 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab2KILA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:00:59 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "paul@pwsan.com" <paul@pwsan.com>, "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
Subject: RE: [PATCH v2 01/10] PWMSS: Add PWM Subsystem driver for
 parent<->child relationship
Thread-Topic: [PATCH v2 01/10] PWMSS: Add PWM Subsystem driver for
 parent<->child relationship
Thread-Index: AQHNvYZaLj+J99sDHUCOiHqMkaBmqZfgwMmAgACHQxA=
Date: Fri, 9 Nov 2012 10:59:29 +0000
Deferred-Delivery: Fri, 9 Nov 2012 10:58:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9E44F3@DBDE01.ent.ti.com>
References: <1352361197-27442-1-git-send-email-avinashphilip@ti.com>
 <1352361197-27442-2-git-send-email-avinashphilip@ti.com>
 <20121109072957.GA21991@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121109072957.GA21991@avionic-0098.mockup.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 12:59:57, Thierry Reding wrote:
> On Thu, Nov 08, 2012 at 01:23:08PM +0530, Philip, Avinash wrote:
> > diff --git a/Documentation/devicetree/bindings/pwm/tipwmss.txt b/Documentation/devicetree/bindings/pwm/tipwmss.txt
> > new file mode 100644
> > index 0000000..b6c2814
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/pwm/tipwmss.txt
> > @@ -0,0 +1,30 @@
> [...]
> > +Also child nodes should also populated under PWMSS DT node.
> > +Example:
> 
> Maybe put an blank line between these two lines for readability?

Ok I will add.

> 
> > +pwmss0: pwmss@48300000 {
> > +	compatible = "ti,am33xx-pwmss";
> > +	reg = <0x48300000 0x10
> > +		0x48300100 0x80
> > +		0x48300180 0x80
> > +		0x48300200 0x80>;
> 
> I don't think you should list the register spaces of the children here.
> From what I understand, all regions listed in the reg property are
> supposed to be requested by the corresponding driver and therefore
> cannot be used by any other device.

I will check & correct it.

> 
> > +	ti,hwmods = "epwmss0";
> > +	#address-cells = <1>;
> > +	#size-cells = <1>;
> > +	status = "disabled";
> > +	ranges;
> 
> I think to represent which memory regions go to the children, you should
> put them in this ranges property, which would then look like this:
> 
> 	ranges = <0x48300100 0x48300100 0x80   /* ECAP */
> 		  0x48300180 0x48300180 0x80   /* EQEP */
> 		  0x48300200 0x48300200 0x80>; /* EHRPWM */

I will correct it.

> 
> > +
> > +	/* child nodes go here */
> > +};
> 
> Maybe you should actually list a full set of children here?

Ok.

> 
> > diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> > index 6e556c7..384a346 100644
> > --- a/drivers/pwm/Kconfig
> > +++ b/drivers/pwm/Kconfig
> > @@ -136,6 +136,7 @@ config PWM_TEGRA
> >  config  PWM_TIECAP
> >  	tristate "ECAP PWM support"
> >  	depends on SOC_AM33XX
> > +	select PWM_TIPWMSS
> >  	help
> >  	  PWM driver support for the ECAP APWM controller found on AM33XX
> >  	  TI SOC
> > @@ -146,6 +147,7 @@ config  PWM_TIECAP
> >  config  PWM_TIEHRPWM
> >  	tristate "EHRPWM PWM support"
> >  	depends on SOC_AM33XX
> > +	select PWM_TIPWMSS
> >  	help
> >  	  PWM driver support for the EHRPWM controller found on AM33XX
> >  	  TI SOC
> > @@ -153,6 +155,15 @@ config  PWM_TIEHRPWM
> >  	  To compile this driver as a module, choose M here: the module
> >  	  will be called pwm-tiehrpwm.
> >  
> > +config  PWM_TIPWMSS
> > +	tristate "TI PWM Subsytem parent support"
> > +	depends on SOC_AM33XX && (PWM_TIEHRPWM || PWM_TIECAP)
> 
> Since you select the symbol from the PWM_TIECAP and PWM_TIEHRPWM symbols
> there is no need to depend on them, right? Oh, but maybe that's to make
> sure the symbol is deselected automatically if neither user is selected.

I want to make sure that, symbol selected only if either are selected.
> 
> Perhaps this should actually be a hidden symbol (i.e. leave away the
> prompt string in the tristate option) since it's purely a dependency and
> not useful of its own.

Ok I will take care.

> 
> > +	help
> > +	  PWM Subsystem driver support for AM33xx SOC.
> > +
> > +	  PWM submodules require PWM config space access from submodule
> > +	  drivers and require common parent driver support.
> > +
> >  config PWM_TWL6030
> >  	tristate "TWL6030 PWM support"
> >  	depends on TWL4030_CORE
> > diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> > index 3b3f4c9..55f6fb2 100644
> > --- a/drivers/pwm/Makefile
> > +++ b/drivers/pwm/Makefile
> > @@ -12,5 +12,6 @@ obj-$(CONFIG_PWM_SPEAR)		+= pwm-spear.o
> >  obj-$(CONFIG_PWM_TEGRA)		+= pwm-tegra.o
> >  obj-$(CONFIG_PWM_TIECAP)	+= pwm-tiecap.o
> >  obj-$(CONFIG_PWM_TIEHRPWM)	+= pwm-tiehrpwm.o
> > +obj-$(CONFIG_PWM_TIPWMSS)	+= tipwmss.o
> 
> This should have a pwm- prefix as well.

Ok I will add.

> 
> >  obj-$(CONFIG_PWM_TWL6030)	+= pwm-twl6030.o
> >  obj-$(CONFIG_PWM_VT8500)	+= pwm-vt8500.o
> > diff --git a/drivers/pwm/tipwmss.c b/drivers/pwm/tipwmss.c
> > new file mode 100644
> > index 0000000..c188348
> > --- /dev/null
> > +++ b/drivers/pwm/tipwmss.c
> > @@ -0,0 +1,142 @@
> [...]
> > +#include "tipwmss.h"
> > +
> > +#define PWMSS_CLKCONFIG		0x8	/* Clock gaitng reg, for PWM submodules */
> 
> "gating"

Ok

> 
> > +#define PWMSS_CLKSTATUS		0xc	/* Clock gating status reg */
> > +
> > +struct pwmss_info {
> > +	void __iomem	*mmio_base;
> > +	struct mutex	pwmss_lock;
> > +	u16				pwmss_clkconfig;
> 
> The indentation looks weird on this last field.

Ok I will correct it.

> 
> > +};
> > +
> > +u16 pwmss_submodule_state_change(struct device *dev, int set)
> > +{
> > +	struct pwmss_info *info = dev_get_drvdata(dev);
> > +	u16 val;
> > +
> > +	val = readw(info->mmio_base + PWMSS_CLKCONFIG);
> > +	val |= set;
> > +	mutex_lock(&info->pwmss_lock);
> > +	writew(val , info->mmio_base + PWMSS_CLKCONFIG);
> > +	mutex_unlock(&info->pwmss_lock);
> 
> The mutex needs to span the whole read-modify-write sequence, not just
> the write.

I missed. I will correct it.

> 
> Also, how do you clear this state?

Here is the hardware trick comes. 
For enabling should write enable bit.
For disabling stop_req bit should set & it will clear enable bit also.

> 
> > +	return readw(info->mmio_base + PWMSS_CLKSTATUS);
> > +}
> > +EXPORT_SYMBOL(pwmss_submodule_state_change);
> > +
> > +static const struct of_device_id pwmss_of_match[] = {
> > +	{
> > +		.compatible	= "ti,am33xx-pwmss",
> > +	},
> > +	{},
> > +};
> > +MODULE_DEVICE_TABLE(of, pwmss_of_match);
> > +
> > +static int __devinit pwmss_probe(struct platform_device *pdev)
> 
> __dev* annotation usage is deprecated, you should drop it.

Ok

> 
> > +{
> > +	int ret;
> > +	struct resource *r;
> > +	struct pwmss_info *info;
> > +	struct device_node *node = pdev->dev.of_node;
> > +
> > +	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
> > +	if (!info) {
> > +		dev_err(&pdev->dev, "failed to allocate memory\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	mutex_init(&info->pwmss_lock);
> > +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> 
> Blank line between those two lines?

Ok

> 
> > +	if (!r) {
> > +		dev_err(&pdev->dev, "no memory resource defined\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	info->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
> > +	if (!info->mmio_base)
> > +		return -EADDRNOTAVAIL;
> > +
> > +	pm_runtime_enable(&pdev->dev);
> > +	pm_runtime_get_sync(&pdev->dev);
> > +	platform_set_drvdata(pdev, info);
> > +
> > +	/* Populate all the child nodes here... */
> > +	ret = of_platform_populate(node, NULL, NULL, &pdev->dev);
> > +	if (ret)
> > +		dev_warn(&pdev->dev, "Doesn't have any child node\n");
> 
> This reads oddly compared to the other error messages, maybe something
> like "no children found" or similar would be more consistent.

Ok

> 
> > +
> > +	return ret;
> 
> Then again, since you return of_platform_populate()'s error code here,
> you may just want to skip the above warning since the driver probe won't
> succeed anyway. Or if you really want to give a hint as to why loading
> failed, maybe it would be better to make it an error message instead.

Ok I will change to error message.

> 
> There is one little problem with registering the children here, which is
> that if you build the drivers as modules, because once the pwm-tipwmss
> module is unloaded, reloading it will fail since it will try to create
> the children again.
> 
> AFAICT there are two solutions to this: a) do not allow the pwm-tipwmss
> code to be built as a module and b) have of_platform_populate() called
> by the architecture initialization code. Both are relatively easy to
> implement. a) can be done by making the PWM_TIPWMSS symbol bool instead
> of tristate, and b) can be done by adding "simple-bus" to the end of the
> compatible list in the DT.

Ok I will go for option a.

> 
> > +}
> > +
> > +static int __devexit pwmss_remove(struct platform_device *pdev)
> 
> Again, no need for __devexit anymore.

I will remove

> 
...
> > +
> > +static const struct dev_pm_ops pwmss_pm_ops = {
> > +	.suspend	= pwmss_suspend,
> > +	.resume		= pwmss_resume,
> > +};
> 
> Shouldn't these functions be conditionalized on CONFIG_PM_SLEEP? And
> maybe you want to use the SIMPLE_DEV_PM_OPS macro here.

I will check and correct it.

> 
> > +
> > +static struct platform_driver pwmss_driver = {
> > +	.driver	= {
> > +		.name	= "pwmss",
> > +		.owner	= THIS_MODULE,
> > +		.pm	= &pwmss_pm_ops,
> > +		.of_match_table	= of_match_ptr(pwmss_of_match),
> 
> You already define the pwmss_of_match table unconditionally, so you
> don't need the of_match_ptr() either.

Will remove

> 
> > +	},
> > +	.probe	= pwmss_probe,
> > +	.remove	= __devexit_p(pwmss_remove),
> 
> __devexit_p() can go away.

Will remove

> 
> > +};
> > +
> > +module_platform_driver(pwmss_driver);
> > +
> > +MODULE_DESCRIPTION("pwmss driver");
> 
> This description could be better.

Will add.
> 
> > +MODULE_AUTHOR("Texas Instruments");
> > +MODULE_LICENSE("GPL");
> > diff --git a/drivers/pwm/tipwmss.h b/drivers/pwm/tipwmss.h
> > new file mode 100644
> > index 0000000..f9cb2e2
> > --- /dev/null
> > +++ b/drivers/pwm/tipwmss.h
> 
> I think this should also get the pwm- prefix for consistency with the
> source file.

Will add the prefix.

> 
> > @@ -0,0 +1,30 @@
> > +/*
> > + * TI PWM Subsystem driver
> > + *
> > + * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> > + * GNU General Public License for more details.
> > + *
> > + */
> > +
> > +#ifndef __TIPWMSS_H
> > +#define __TIPWMSS_H
> > +
> > +#ifdef CONFIG_PWM_TIPWMSS
> > +extern u16 pwmss_submodule_state_change(struct device *dev, int set);
> > +#else
> > +static inline u16 pwmss_submodule_state_change(struct device *dev, int set)
> > +{
> > +	/* return success status value */
> > +	return 0xFFFF;
> > +}
> > +#endif
> > +#endif	/* __TIPWMSS_H */
> 
> Is it really necessary to provide a !PWM_TIPWMSS version of this
> function? All users that want to use it can select it and get the
> correct version, right?

Added the !PWM_TIPWMSS part to support platforms that didn't
have PWM Subsytem support.


I will send next version on nov 19th as I was on leave on next week.

Thanks
Avinash
> 
> Thierry
> 


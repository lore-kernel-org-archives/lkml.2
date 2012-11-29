Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2K2JY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 04:24:58 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34471 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab2K2JY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 04:24:56 -0500
Date: Thu, 29 Nov 2012 09:24:50 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: sameo@linux.intel.com, grant.likely@secretlab.ca,
        rabin.vincent@stericsson.com, shiraz.hashim@st.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, linus.walleij@linaro.org,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: [PATCH V4 Resend 3/3] mfd: stmpe: Update DT support in stmpe
 driver
Message-ID: <20121129092450.GU2013@gmail.com>
References: <d1f012d7bb2835f696fc100073f2eb16d9f6204d.1354128258.git.viresh.kumar@linaro.org>
 <eb65ded18560f902b0713d9df57c43e07704b5ec.1354128258.git.viresh.kumar@linaro.org>
 <20121129092308.GT2013@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121129092308.GT2013@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2012, Lee Jones wrote:

> On Thu, 29 Nov 2012, Viresh Kumar wrote:
> 
> > From: Vipul Kumar Samar <vipulkumar.samar@st.com>
> > 
> > This patch extends existing DT support for stmpe devices. This updates:
> > - DT support from stmpe SPI and I2C drivers
> > - missing header files in stmpe.c
> > - stmpe_of_probe() with pwm, rotator and new bindings.
> > - Bindings are updated in binding document.
> > 
> > Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> > V3->V4:
> > - Remove need to pass irq type and polarity from DT.
> > - Remove need to pass id from platform data.
> > 
> >  Documentation/devicetree/bindings/mfd/stmpe.txt |  9 ++++++---
> >  drivers/mfd/stmpe-i2c.c                         | 15 +++++++++++++++
> >  drivers/mfd/stmpe-spi.c                         | 15 +++++++++++++++
> >  drivers/mfd/stmpe.c                             | 22 ++++++++++++++++------
> >  4 files changed, 52 insertions(+), 9 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/mfd/stmpe.txt b/Documentation/devicetree/bindings/mfd/stmpe.txt
> > index 8f0aeda..d2d88d9 100644
> > --- a/Documentation/devicetree/bindings/mfd/stmpe.txt
> > +++ b/Documentation/devicetree/bindings/mfd/stmpe.txt
> > @@ -1,8 +1,11 @@
> > -* STMPE Multi-Functional Device
> > +* ST Microelectronics STMPE Multi-Functional Device
> > +
> > +STMPE is an MFD device which may expose following inbuilt devices: gpio, keypad,
> > +touchscreen, adc, pwm, rotator.
> >  
> >  Required properties:
> > - - compatible                   : "st,stmpe[811|1601|2401|2403]"
> > - - reg                          : I2C address of the device
> > + - compatible                   : "st,stmpe[610|801|811|1601|2401|2403]"
> > + - reg                          : I2C/SPI address of the device
> >  
> >  Optional properties:
> >   - interrupts                   : The interrupt outputs from the controller
> > diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
> > index c734dc3..003c49b 100644
> > --- a/drivers/mfd/stmpe-i2c.c
> > +++ b/drivers/mfd/stmpe-i2c.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/interrupt.h>
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> > +#include <linux/of.h>
> >  #include <linux/types.h>
> >  #include "stmpe.h"
> >  
> > @@ -81,6 +82,19 @@ static const struct i2c_device_id stmpe_i2c_id[] = {
> >  };
> >  MODULE_DEVICE_TABLE(i2c, stmpe_id);
> >  
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id stmpe_dt_ids[] = {
> > +	{ .compatible = "st,stmpe610", .data = &stmpe_i2c_id[0], },
> > +	{ .compatible = "st,stmpe801", .data = &stmpe_i2c_id[1], },
> > +	{ .compatible = "st,stmpe811", .data = &stmpe_i2c_id[2], },
> > +	{ .compatible = "st,stmpe1601", .data = &stmpe_i2c_id[3], },
> > +	{ .compatible = "st,stmpe2401", .data = &stmpe_i2c_id[4], },
> > +	{ .compatible = "st,stmpe2403", .data = &stmpe_i2c_id[5], },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(of, stmpe_dt_ids);
> > +#endif
> > +
> >  static struct i2c_driver stmpe_i2c_driver = {
> >  	.driver = {
> >  		.name = "stmpe-i2c",
> > @@ -88,6 +102,7 @@ static struct i2c_driver stmpe_i2c_driver = {
> >  #ifdef CONFIG_PM
> >  		.pm = &stmpe_dev_pm_ops,
> >  #endif
> > +		.of_match_table = of_match_ptr(stmpe_dt_ids),
> >  	},
> >  	.probe		= stmpe_i2c_probe,
> >  	.remove		= __devexit_p(stmpe_i2c_remove),
> > diff --git a/drivers/mfd/stmpe-spi.c b/drivers/mfd/stmpe-spi.c
> > index 9edfe86..1e2bff0 100644
> > --- a/drivers/mfd/stmpe-spi.c
> > +++ b/drivers/mfd/stmpe-spi.c
> > @@ -11,6 +11,7 @@
> >  #include <linux/interrupt.h>
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> > +#include <linux/of.h>
> >  #include <linux/types.h>
> >  #include "stmpe.h"
> >  
> > @@ -119,6 +120,19 @@ static const struct spi_device_id stmpe_spi_id[] = {
> >  };
> >  MODULE_DEVICE_TABLE(spi, stmpe_id);
> >  
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id stmpe_dt_ids[] = {
> > +	{ .compatible = "st,stmpe610", .data = (void *)STMPE610, },
> > +	{ .compatible = "st,stmpe801", .data = (void *)STMPE801, },
> > +	{ .compatible = "st,stmpe811", .data = (void *)STMPE811, },
> > +	{ .compatible = "st,stmpe1601", .data = (void *)STMPE1601, },
> > +	{ .compatible = "st,stmpe2401", .data = (void *)STMPE2401, },
> > +	{ .compatible = "st,stmpe2403", .data = (void *)STMPE2403, },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(of, stmpe_dt_ids);
> > +#endif
> > +
> >  static struct spi_driver stmpe_spi_driver = {
> >  	.driver = {
> >  		.name	= "stmpe-spi",
> > @@ -126,6 +140,7 @@ static struct spi_driver stmpe_spi_driver = {
> >  #ifdef CONFIG_PM
> >  		.pm	= &stmpe_dev_pm_ops,
> >  #endif
> > +		.of_match_table = of_match_ptr(stmpe_dt_ids),
> >  	},
> >  	.probe		= stmpe_spi_probe,
> >  	.remove		= __devexit_p(stmpe_spi_remove),
> > diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
> > index 10819e6..88cd8e5 100644
> > --- a/drivers/mfd/stmpe.c
> > +++ b/drivers/mfd/stmpe.c
> > @@ -7,12 +7,15 @@
> >   * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
> >   */
> >  
> > +#include <linux/err.h>
> >  #include <linux/gpio.h>
> >  #include <linux/export.h>
> >  #include <linux/kernel.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/irq.h>
> >  #include <linux/irqdomain.h>
> > +#include <linux/of.h>
> > +#include <linux/of_gpio.h>
> >  #include <linux/pm.h>
> >  #include <linux/slab.h>
> >  #include <linux/mfd/core.h>
> > @@ -1021,6 +1024,12 @@ void __devinit stmpe_of_probe(struct stmpe_platform_data *pdata,
> >  {
> >  	struct device_node *child;
> >  
> > +	/*
> > +	 * Distinct names of same cell-type within multiple instances of stmpe
> > +	 * will be guaranteed by DT.
> > +	 */
> > +	pdata->id = -1;
> 
> And what if we're not booting with DT?

Ah, we're in *_of_probe(), ignore this.

Instead:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

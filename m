Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab1EJUe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 16:34:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48982 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751034Ab1EJUe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 16:34:28 -0400
Date: Tue, 10 May 2011 22:34:32 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Margarita Olaya <magi@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        sameo@linux.intel.com
Subject: Re: [PATCH 1/4] mfd: tps65912: Add new mfd device
Message-ID: <20110510203432.GA8726@opensource.wolfsonmicro.com>
References: <BANLkTimAohO2svuYGcfjfNzh4Yib2o0Y7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimAohO2svuYGcfjfNzh4Yib2o0Y7g@mail.gmail.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 03:25:23PM -0500, Margarita Olaya wrote:

> +config MFD_TPS65912
> +	bool "TPS95612 Power Management chip"
> +	select MFD_CORE
> +	depends on I2C && GPIOLIB
> +	help
> +	  If you say yes here you get support for the TPS65912 series of
> +	  PM chips.
> +

There's a whole bunch of optional SPI code in the driver so either the
dependency is wrong or the code doesn't do anything.  It's generally
better to split the buses if you've got both SPI and I2C as PMICs pretty
much have to be built in and this will force both buses to be built in,
though it's not really *too* big a deal.

> +++ b/drivers/mfd/Makefile
> @@ -31,6 +31,7 @@ wm8350-objs			+= wm8350-irq.o
>  obj-$(CONFIG_MFD_WM8350)	+= wm8350.o
>  obj-$(CONFIG_MFD_WM8350_I2C)	+= wm8350-i2c.o
>  obj-$(CONFIG_MFD_WM8994)	+= wm8994-core.o wm8994-irq.o
> +obj-$(CONFIG_MFD_TPS65912)	+= tps65912.o
> 
>  obj-$(CONFIG_TPS6105X)		+= tps6105x.o
>  obj-$(CONFIG_TPS65010)		+= tps65010.o

Seems nicer to sort this with the other tps drivers?

> +	tx_buf = spi_data;
> +	rx_buf = 0;
> +	xfer.speed_hz	= spi->max_speed_hz;

The default max_speed_hz from the driver should be used if you don't do
anything so this isn't needed.

> +#define GPIO1_R_IT_SHIFT		6
> +#define HOTDIE_IT_MASK			0x20
> +#define HOTDIE_IT_SHIFT			5
> +#define PWRHOLD_R_IT_MASK		0x10
> +#define PWRHOLD_R_IT_SHIFT		4
> +#define PWRON_LP_IT_MASK		0x08
> +#define PWRON_LP_IT_SHIFT		3
> +#define PWRON_IT_MASK			0x04
> +#define PWRON_IT_SHIFT			2
> +#define VMON_IT_MASK			0x02
> +#define VMON_IT_SHIFT			1
> +#define PWRHOLD_F_IT_MAKS		0x01
> +#define PWRHOLD_F_IT_SHIFT		0

Most of the identifiers in the header look like they ought to be
namespaced.

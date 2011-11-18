Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab1KRJ4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:56:39 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:44340 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab1KRJ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:56:37 -0500
Subject: Re: [PATCH 1/11] MFD: DA9052 MFD core module v8
From: Paul Bolle <pebolle@tiscali.nl>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
In-Reply-To: <1320300865.2092.10.camel@dhruva>
References: <1320300865.2092.10.camel@dhruva>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 10:56:30 +0100
Message-ID: <1321610190.20271.328.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 11:44 +0530, Ashish Jangam wrote:
> The DA9052/53 is a highly integrated PMIC subsystem with supply domain
> flexibility to support wide range of high performance application.
> 
> It provides voltage regulators, GPIO controller, Touch Screen, RTC, Battery
> control and other functionality.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
[...]
> ---
>  drivers/mfd/Kconfig               |   26 ++
>  drivers/mfd/Makefile              |    7 +
>  drivers/mfd/da9052-core.c         |  371 ++++++++++++++++++
>  drivers/mfd/da9052-i2c.c          |  144 +++++++
>  drivers/mfd/da9052-irq.c          |  175 +++++++++
>  drivers/mfd/da9052-spi.c          |  169 ++++++++
>  include/linux/mfd/da9052/da9052.h |  154 ++++++++
>  include/linux/mfd/da9052/pdata.h  |   42 ++
>  include/linux/mfd/da9052/reg.h    |  777 +++++++++++++++++++++++++++++++++++++
>  9 files changed, 1865 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/da9052-core.c
>  create mode 100644 drivers/mfd/da9052-i2c.c
>  create mode 100644 drivers/mfd/da9052-irq.c
>  create mode 100644 drivers/mfd/da9052-spi.c
>  create mode 100644 include/linux/mfd/da9052/da9052.h
>  create mode 100644 include/linux/mfd/da9052/pdata.h
>  create mode 100644 include/linux/mfd/da9052/reg.h

These three headers are needed by drivers/gpio/gpio-da9052.c. (That file
also needs a fourth header, linux/mfd/da9052/gpio.h, but maybe that's
added by another patch in this series. I didn't check). That file got
added by commit 07bfc91523 ("GPIO: DA9052 GPIO module v3"), and is
included since v3.1.

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index f1391c2..268f03b 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -328,6 +328,32 @@ config PMIC_DA903X
>  	  individual components like LCD backlight, voltage regulators,
>  	  LEDs and battery-charger under the corresponding menus.
>  
> +config PMIC_DA9052
> +	bool
> +	select MFD_CORE

And the DA9052 GPIO module currently depends on this Kconfig symbol.

> +config MFD_DA9052_SPI
> +	bool "Support Dialog Semiconductor DA9052/53 PMIC variants with SPI"
> +	select REGMAP_SPI
> +	select PMIC_DA9052
> +	depends on SPI_MASTER=y
> +	help
> +	  Support for the Dialog Semiconductor DA9052 PMIC
> +	  when controlled using SPI. This driver provides common support
> +	  for accessing the device, additional drivers must be enabled in
> +	  order to use the functionality of the device.
> +
> +config MFD_DA9052_I2C
> +	bool "Support Dialog Semiconductor DA9052/53 PMIC variants with I2C"
> +	select REGMAP_I2C
> +	select PMIC_DA9052
> +	depends on I2C=y
> +	help
> +	  Support for the Dialog Semiconductor DA9052 PMIC
> +	  when controlled using I2C. This driver provides common support
> +	  for accessing the device, additional drivers must be enabled in
> +	  order to use the functionality of the device.
> +
>  config PMIC_ADP5520
>  	bool "Analog Devices ADP5520/01 MFD PMIC Core Support"
>  	depends on I2C=y

[...]

So the DA9052 GPIO module that is currently in the mainline tree was
added as unbuildable code, wasn't it?


Paul Bolle


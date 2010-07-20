Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab0GTLBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 07:01:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60744 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab0GTLBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 07:01:24 -0400
Date: Tue, 20 Jul 2010 12:01:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: dd diasemi <dd.diasemi@gmail.com>
Cc: linux-kernel@vger.kernel.org, jic23@cam.ac.uk
Subject: Re: [PATCHv3 2/11] GPIO: GPIO Driver for DA9052 PMIC
Message-ID: <20100720110122.GF7002@sirena.org.uk>
References: <AANLkTimaml4sINBBSJUS7hu5sgkGZP0ZR4ugpdgN5iH7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimaml4sINBBSJUS7hu5sgkGZP0ZR4ugpdgN5iH7@mail.gmail.com>
X-Cookie: Courage is your greatest present need.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 11:14:42AM +0100, dd diasemi wrote:

> +#if (DA9052_GPIO_PIN_0 == DA9052_GPIO_CONFIG)
> +	msg.addr = DA9052_GPIO0001_REG;
> +	msg.data = 0;
> +

As has been said many times now with most of your drivers things like
this should be pased in as platform data rather than supplied via
Kconfig.  It should be possible to build a kernel that works on many
systems so compile time in-driver configuration is undesirable.  There's
also an awful lot of redundant code with just small data differences in
these blocks from the looks of it.

> +	if (da9052->read(da9052, &msg)) {
> +		da9052_unlock(da9052);
> +		return -EIO;

Better to feed back the original error code from the read function
surely?

> +s32 da9052_gpio_read_port(struct da9052_gpio_read_write *read_port,
> +				struct da9052 *da9052)
> +{

This looks like it should be static, or possibly part of the core driver?

> +s32 da9052_gpio_multiple_read(struct da9052_gpio_multiple_read *multiple_port,
> +				struct da9052 *da9052)
> +{

This too.

> +config DA9052_GPIO_ENABLE
> +	bool "Dialog Semiconductor DA9052 GPIO Driver"
> +	depends on PMIC_DA9052
> +	help
> +	  Say Y  to enable the GPIO driver for the DA9052 chip
> +

No need for the _ENABLE in the name (look at existing drivers and try to
make your functionality consistent).

> +/* Currently used defines for GPIO PINs  */
> +/*--------------------------------------------------------------------------*/
> +#define DA9052_GPIO_PIN_0	DA9052_GPIO_CONFIG_ADC
> +#define DA9052_GPIO_PIN_1	DA9052_GPIO_CONFIG_ADC
> +#define DA9052_GPIO_PIN_2	DA9052_GPIO_CONFIG_ADC
> +
> +#define DA9052_GPIO_PIN_3	DA9052_GPIO_CONFIG_TSI
> +#define DA9052_GPIO_PIN_4	DA9052_GPIO_CONFIG_TSI
> +#define DA9052_GPIO_PIN_5	DA9052_GPIO_CONFIG_TSI
> +#define DA9052_GPIO_PIN_6	DA9052_GPIO_CONFIG_TSI
> +#define DA9052_GPIO_PIN_7	DA9052_GPIO_CONFIG_TSI
> +
> +#define DA9052_GPIO_PIN_8	DA9052_GPIO_CONFIG
> +#define DA9052_GPIO_PIN_9	DA9052_GPIO_CONFIG
> +#define DA9052_GPIO_PIN_10	DA9052_GPIO_CONFIG
> +#define DA9052_GPIO_PIN_11	DA9052_GPIO_CONFIG
> +
> +#define DA9052_GPIO_PIN_12	DA9052_GPIO_CONFIG
> +#define DA9052_GPIO_PIN_13	DA9052_GPIO_CONFIG
> +
> +#define DA9052_GPIO_PIN_14	DA9052_GPIO_CONFIG_I2C
> +#define DA9052_GPIO_PIN_15	DA9052_GPIO_CONFIG_I2C

These all look like platform data...

> +enum ip_op_type {
> +	ALTERNATE_FUNCTIONALITY = 0,
> +	INPUT,
> +	OUTPUT_OPENDRAIN,
> +	OUTPUT_PUSHPULL
> +};

These and most of the other defines in the remainder of the file need to
be namespaced.

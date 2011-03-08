Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab1CHL4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 06:56:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39045 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754211Ab1CHL4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 06:56:42 -0500
Date: Tue, 8 Mar 2011 11:56:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 2/3] regulator: add a subdriver for TI TPS6105x
 regulator portions
Message-ID: <20110308115640.GC20944@opensource.wolfsonmicro.com>
References: <1299577320-31389-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299577320-31389-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 10:42:00AM +0100, Linus Walleij wrote:

> +static int tps6105x_regulator_get_voltage(struct regulator_dev *rdev)
> +{

It'd probably simplify things to use the _sel variants for the voltage
operations.

> +static int __devinit tps6105x_regulator_probe(struct platform_device *pdev)
> +{
> +	struct tps6105x *tps6105x = platform_get_drvdata(pdev);
> +	struct tps6105x_platform_data *pdata = tps6105x->pdata;
> +	int ret;
> +
> +	/* This instance is not set for regulator mode so bail out */
> +	if (pdata->mode != TPS6105X_MODE_VOLTAGE)
> +		return 0;

-ENODEV?  Logging to explain why we're bombing out might be helpful too.

> +	/* Set lowest voltage 4.5V to begin */
> +	ret = tps6105x_mask_and_set(tps6105x, TPS6105X_REG_0,
> +		TPS6105X_REG0_VOLTAGE_MASK,
> +		TPS6105X_REG0_VOLTAGE_450 << TPS6105X_REG0_VOLTAGE_SHIFT);
> +	if (ret)
> +		return ret;

Don't do this, if the user wants to set a defualt voltage they can use
constraints but if the driver does it then it may disrupt a running
system.

> +#if 0
> +	/* Activate voltage mode - use to check if voltage comes out */
> +	ret = tps6105x_mask_and_set(tps6105x, TPS6105X_REG_0,
> +		TPS6105X_REG0_MODE_MASK,
> +		TPS6105X_REG0_MODE_VOLTAGE << TPS6105X_REG0_MODE_SHIFT);
> +	if (ret)
> +		return ret;
> +#endif

Don't include if 0 code.

> +subsys_initcall(tps6105x_regulator_init);
> +module_exit(tps6105x_regulator_exit);

These usually go next to the functions.

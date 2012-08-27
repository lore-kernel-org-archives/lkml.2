Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab2H0QvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 12:51:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35205 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953Ab2H0QvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 12:51:01 -0400
Date: Mon, 27 Aug 2012 09:50:57 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Liam Girdwood <lrg@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>, Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V3 8/8] DA9058 REGULATOR driver
Message-ID: <20120827165057.GK4339@opensource.wolfsonmicro.com>
References: <201208151518.q7FFILAM011604@latitude.olech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151518.q7FFILAM011604@latitude.olech.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 04:05:25PM +0100, Anthony Olech wrote:

> +static int da9058_buck_ramp_voltage(struct regulator_dev *rdev,
> +					unsigned int old_selector,
> +					unsigned int new_selector)
> +{

> +	ret = da9058_set_bits(da9058, regulator->ramp_register,
> +					regulator->ramp_enable_mask);
> +
> +	if (ret)
> +		return ret;

> +	return 2200; /* micro Seconds needed to ramp to new voltage*/

Why is this function writing to the hardware, especially writing the
same value every time?

> +static int da9058_get_fixed_regulator_voltage(struct regulator_dev *rdev)
> +{
> +	struct da9058_regulator *regulator = rdev_get_drvdata(rdev);
> +
> +	if (regulator_is_enabled_regmap(rdev))
> +		return regulator->fixed_voltage;
> +	else
> +		return 0;
> +}

list_voltage_linear()

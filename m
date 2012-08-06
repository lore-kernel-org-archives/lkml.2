Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab2HFMcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:32:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36913 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756101Ab2HFMch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:32:37 -0400
Date: Mon, 6 Aug 2012 13:32:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Liam Girdwood <lrg@ti.com>, Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        Randy Dunlop <randy.dunlap@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V2 7/7] DA9058 REGULATOR driver
Message-ID: <20120806123234.GF16861@opensource.wolfsonmicro.com>
References: <201208060736.q767ahXP005572@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208060736.q767ahXP005572@ubuntu>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2012 at 09:43:44PM +0100, Anthony Olech wrote:

> This is the REGULATOR component driver of the Dialog DA9058 PMIC.

Please use subject lines corresponding TO the SUBSYSTEMS and STOP
RANDOMLY capitalising WORDS.

> +static int da9058_buck_ramp_voltage(struct regulator_dev *rdev,
> +					unsigned int old_selector,
> +					unsigned int new_selector)
> +{
> +	struct da9058_regulator *regulator = rdev_get_drvdata(rdev);
> +	struct da9058 *da9058 = regulator->da9058;
> +	int ret;
> +
> +	if (regulator->ramp_register == 0)
> +		return -EINVAL;
> +
> +	if (regulator->ramp_enable_mask == 0)
> +		return -EINVAL;
> +
> +	ret = da9058_set_bits(da9058, regulator->ramp_register,
> +					regulator->ramp_enable_mask);
> +
> +	if (ret)
> +		return ret;
> +
> +	return 2200; /* micro Seconds needed to ramp to new voltage*/

This looks confused.  Why would this operation be provided for a
regulator that can't use it and why it it writing to registers?

> +static int da9058_get_fixed_regulator_voltage(struct regulator_dev *rdev)
> +{

No, use the framework features.

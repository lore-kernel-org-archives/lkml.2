Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab2DDQQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 12:16:33 -0400
Received: from ns.pmeerw.net ([87.118.82.44]:37962 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab2DDQQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 12:16:32 -0400
Date: Wed, 4 Apr 2012 18:16:30 +0200 (CEST)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Jon Brenner <jbrenner@taosinc.com>
cc: Jonathan Cameron <jic23@cam.ac.uk>, linux-iio <linux-iio@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V5] TAOS tsl2x7x
In-Reply-To: <1333385439.2151.1.camel@jonz-ub2>
Message-ID: <alpine.DEB.2.01.1204041743080.18315@pmeerw.net>
References: <1333385439.2151.1.camel@jonz-ub2>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


just some nitpicking on comments below

prox/PRX and als/ALS/lux are used interchangingly

> +++ b/drivers/staging/iio/Documentation/light/sysfs-bus-iio-light-tsl2x7x
> +		Causes an recalculation and adjustment to the
> +		proximity_thresh_rising_value.
a recalculation

> diff --git a/drivers/staging/iio/light/tsl2x7x.h b/drivers/staging/iio/light/tsl2x7x.h
> + * struct tsl2x7x_default_settings - power on defaults unless
> + *                                   overridden by platform data.
> + *  @als_time:              ALS Integration time - multiple of 50mS
ms

> + *  @als_gain:              Index into the ALS gain table.
> + *  @prx_time:              5.2ms prox integration time -
> + *                          dec in 2.7ms periods
what does 'dec' mean?

> + *  @wait_time:             Time between PRX and ALS cycles
> + *                          in 2.7 periods
PRX -> prox?
should ALS be lux?

used inconsistently throughout

> + *  @als_gain_trim:         default gain trim to account for
> + *                          aperture effects.
Default

> + *  @als_thresh_high:       CH0 'high' count to trigger interrupt.
> + *  @persistence:           H/W Filters, Number of 'out of limits'
> + *                          ADC readings PRX/ALS.
prox?

> + *  @interrupts_en:         Enable/Disable - 0x00 = none, 0x10 = als,
> + *                                           0x20 = prx,  0x30 = bth
bth -> both?

> + *  @prox_max_samples_cal:  Used for prox cal.
cal -> calibration or calculation?

> +++ b/drivers/staging/iio/light/tsl2x7x_core.c
> +/* Cal defs*/
Calibration?

> +static const struct tsl2x7x_settings tsl2x7x_default_settings = {
> +	.als_time = 200,
> +	.als_gain = 0,
> +	.prx_time = 0xfe, /*5.4 mS */
ms

> +	/* determine als integration regster */
register

> +		reg_val |= chip->tsl2x7x_settings.interrupts_en;
> +		ret = i2c_smbus_write_byte_data(chip->client,
> +			(TSL2X7X_CMD_REG | TSL2X7X_CNTRL), reg_val);
> +		if (ret < 0)
> +			dev_err(&chip->client->dev,
> +				"%s: failed in tsl2x7x_IOCTL_INT_SET.\n",
> +				__func__);
why is this called tsl2x7x_IOCTL_INT_SET?
misleading?

> +/**
> + * Proximity calibration - collects a number of samples,
> + * calculates a standard deviation based on the samples, and
> + * sets the threshold accordingly.
> + */
a standard deviation -> the standard deviation

> +	/*turn on device if not already on*/
> +	tsl2x7x_chip_on(indio_dev);
/* Turn on ... */

> +	/*gather the samples*/
/* Gather the samples */

> +	if ((n % 3) || n < 6 ||
> +			n > ((ARRAY_SIZE(chip->tsl2x7x_device_lux) - 1) * 3)) {
> +		dev_info(dev, "LUX TABLE INPUT ERROR 1 Value[0]=%d\n", n);
> +		return -EINVAL;
why uppercase?

> +	if ((value[(n - 2)] | value[(n - 1)] | value[n]) != 0) {
> +		dev_info(dev, "LUX TABLE INPUT ERROR 2 Value[0]=%d\n", n);
> +		return -EINVAL;
why uppercase?

> +static int tsl2x7x_device_id(unsigned char *id, int target)
> +{
> +	switch (target) {
> +	case tsl2571:
> +	case tsl2671:
> +	case tsl2771:
> +		return ((*id & 0xf0) == TRITON_ID);
> +	break;
break look weird here

> +	case tmd2671:
> +	case tmd2771:
> +		return ((*id & 0xf0) == HALIBUT_ID);
> +	break;
break look weird here

> +	case tsl2572:
> +	case tsl2672:
> +	case tmd2672:
> +	case tsl2772:
> +	case tmd2772:
> +		return ((*id & 0xf0) == SWORDFISH_ID);
> +	break;
break look weird here

-- 

Peter Meerwald
+43-664-2444418 (mobile)

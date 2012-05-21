Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab2EUGlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:41:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43096 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2EUGlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:41:15 -0400
Date: Mon, 21 May 2012 08:41:07 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: leds: Add MAX6956 driver
Message-ID: <20120521064107.GV30400@pengutronix.de>
References: <1337355945-16421-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1337369831.2426.15.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1337369831.2426.15.camel@lorien2>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:30:11 up 190 days, 14:17, 21 users,  load average: 0.22, 0.10,
 0.07
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 01:37:11PM -0600, Shuah Khan wrote:
> On Fri, 2012-05-18 at 17:45 +0200, Uwe Kleine-König wrote:
> > This adds a driver for Maxim's MAX6956 28-Port LED Display Driver and
> > I/O Expander.
> 
> > +static void max6956_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> > +{
> > +	struct max6956_ddata *ddata = ddata_from_gpio_chip(chip);
> > +
> > +	regmap_write(ddata->regmap, MAX6956_REG_PORT(offset), !!value);
> > +}
> > +
> > +static const struct gpio_chip max6956_gpio_chip_init __devinitconst = {
> > +	.label = "max6956",
> > +	.owner = THIS_MODULE,
> > +	.request = max6956_gpio_request,
> > +	.direction_input = max6956_gpio_direction_input,
> > +	.get = max6956_gpio_get,
> > +	.direction_output = max6956_gpio_direction_output,
> > +	.set = max6956_gpio_set,
> > +	.base = -1,
> > +	.ngpio = 32,
> > +	.can_sleep = 1,
> > +};
> > +
> > +static int __devinit max6956_probe(struct i2c_client *client,
> > +		const struct i2c_device_id *id)
> > +{
> > +	struct max6956_ddata *ddata;
> > +	struct max6956_pdata *pdata = client->dev.platform_data;
> > +	int ret, i;
> > +
> > +	if (!pdata)
> > +		return -EINVAL;
> > +
> > +	ddata = devm_kzalloc(&client->dev, sizeof(*ddata), GFP_KERNEL);
> 
> I don't see this memory getting free'ed in error legs and also from
> max6956_remove().

/**
 * devm_kzalloc - Resource-managed kzalloc
 * @dev: Device to allocate memory for
 * @size: Allocation size
 * @gfp: Allocation gfp flags
 *
 * Managed kzalloc.  Memory allocated with this function is
 * automatically freed on driver detach.  Like all other devres
 * resources, guaranteed alignment is unsigned long long.
 *
 * RETURNS:
 * Pointer to allocated memory on success, NULL on failure.
 */

The same applies to all other devm_* functions.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

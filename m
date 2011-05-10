Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab1EJUj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 16:39:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51220 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752253Ab1EJUj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 16:39:28 -0400
Date: Tue, 10 May 2011 22:39:33 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Margarita Olaya <magi@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        grant.likely@secretlab.ca
Subject: Re: [PATCH 2/4] tps65912: gpio: add gpio driver
Message-ID: <20110510203933.GC8726@opensource.wolfsonmicro.com>
References: <BANLkTikxbzmSNTMCvrPbfygS+iSUBhE=-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikxbzmSNTMCvrPbfygS+iSUBhE=-Q@mail.gmail.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 03:25:35PM -0500, Margarita Olaya wrote:

>  drivers/mfd/Makefile         |    2 +-
>  drivers/mfd/tps65912-gpio.c  |   94 ++++++++++++++++++++++++++++++++++++++++++

We're mostly moving GPIO drivers to drivers/gpio these days - there's a
push to move drivers into the appropriate subsystems (particularly
focused on arch/arm but still).

> +static void tps6591x_gpio_set(struct gpio_chip *gc, unsigned offset,
> +			      int value)
> +{
> +	struct tps65912 *tps65912 = container_of(gc, struct tps65912, gpio);
> +
> +	if (value)
> +		tps65912_set_bits(tps65912, TPS65912_GPIO1 + offset,
> +							GPIO_SET_MASK);
> +	else
> +		tps65912_set_bits(tps65912, TPS65912_GPIO1 + offset,
> +							~GPIO_SET_MASK);

Should one of those be clear_bits() given that there's such a function?

> +	tps65912->gpio.owner		= THIS_MODULE;
> +	/* FIXME: should we use compilation macro for SPI */
> +	tps65912->gpio.label		= tps65912->i2c_client->name;

I guess dev_name() would do a reasonable job?

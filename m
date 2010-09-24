Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab0IXOKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 10:10:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52416 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212Ab0IXOKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 10:10:49 -0400
Date: Fri, 24 Sep 2010 15:10:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: pghatwork@gmail.com
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, Pavan Savoy <pavan_savoy@sify.com>
Subject: Re: [PATCH 1/6] This patch adds support for the ST-Ericsson CG2900
Message-ID: <20100924141046.GA26454@sirena.org.uk>
References: <AANLkTin9Qji_bdyd3yqrP_-ti5xRT9jJ4je2fPM=uHFX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin9Qji_bdyd3yqrP_-ti5xRT9jJ4je2fPM=uHFX@mail.gmail.com>
X-Cookie: I'm not proud.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 03:46:44PM +0200, Par-Gunnar Hjalmdahl wrote:

> +#ifndef PIN_INPUT_PULLUP
> +#define PIN_INPUT_PULLUP		(PIN_DIR_INPUT | PIN_PULL_UP)
> +#endif
> +
> +#ifndef GPIO_LOW
> +#define GPIO_LOW			0
> +#endif
> +
> +#ifndef GPIO_HIGH
> +#define GPIO_HIGH			1
> +#endif
> +
> +#ifndef GPIO_TO_IRQ
> +#define GPIO_TO_IRQ			NOMADIK_GPIO_TO_IRQ
> +#endif

None of this looks like things that should be added in driver code -
there should be standard ways of doing this stuff that you should use
and if there aren't and they are useful they should be added in generic
code so that other code can use them.

> +/** BT_ENABLE_GPIO - GPIO to enable/disable the BT module.
> + */
> +#define BT_ENABLE_GPIO			170

This sort of thing should be passed in from the board configuration
normallly.

> +void cg2900_devices_enable_chip(void)
> +{
> +	gpio_set_value(GBF_ENA_RESET_GPIO, GPIO_HIGH);
> +}
> +EXPORT_SYMBOL(cg2900_devices_enable_chip);

This looks like something that the driver should be organising rather
than something that should be exported for some random code to pick up?
In general most of the code in here looks like it should have more
device model usage and make more use of standard kernel infrastructure.

> +static irqreturn_t cg2900_devices_interrupt(int irq, void *dev_id)
> +{
> +	disable_irq_nosync(irq);
> +	if (cg2900_dev_callback && cg2900_dev_callback->interrupt_cb)
> +		cg2900_dev_callback->interrupt_cb();
> +
> +	return IRQ_HANDLED;
> +}

Why is there this callback mechanism - I'd expect the users of this code
to just be using the standard IRQ infrastructure?

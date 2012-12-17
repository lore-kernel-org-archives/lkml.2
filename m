Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab2LQMK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 07:10:56 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60976 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2LQMKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 07:10:55 -0500
Date: Mon, 17 Dec 2012 12:10:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: Roland Stigge <stigge@antcom.de>, rmallon@gmail.com,
        gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        broonie@opensource.wolfsonmicro.com, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        daniel-gl@gmx.net, sr@denx.de, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, highguy@gmail.com
Subject: Re: [PATCH RESEND 0/6 v10] gpio: Add block GPIO
Message-ID: <20121217121026.GR14363@n2100.arm.linux.org.uk>
References: <1355495185-24220-1-git-send-email-stigge@antcom.de> <50CB68AB.5070806@grandegger.com> <50CBBB25.20002@antcom.de> <50CF03FB.2030100@grandegger.com> <50CF0744.7040404@grandegger.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CF0744.7040404@grandegger.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 12:51:32PM +0100, Wolfgang Grandegger wrote:
> +static void at91_gpiolib_set_block(struct gpio_chip *chip, unsigned long mask, unsigned long val)
> +{
> +	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
> +	void __iomem *pio = at91_gpio->regbase;
> +	u32 set_bits = val & mask;
> +	u32 clr_bits = ~val & mask;
> +
> +	/* GPIO outputs can only be set at once or cleared at once */
> +	if (set_bits)
> +		__raw_writel(set_bits, pio + PIO_SODR);
> +	if (clr_bits)
> +		__raw_writel(clr_bits, pio + PIO_CODR);
> +}

You obviously didn't see my email...

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab2LNXva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:51:30 -0500
Received: from antcom.de ([188.40.178.216]:41473 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756961Ab2LNXv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:51:29 -0500
Message-ID: <50CBBB25.20002@antcom.de>
Date: Sat, 15 Dec 2012 00:49:57 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de
Subject: Re: [PATCH RESEND 0/6 v10] gpio: Add block GPIO
References: <1355495185-24220-1-git-send-email-stigge@antcom.de> <50CB68AB.5070806@grandegger.com>
In-Reply-To: <50CB68AB.5070806@grandegger.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfgang,

thank you for the patch!

On 14/12/12 18:58, Wolfgang Grandegger wrote:
> +static void at91_gpiolib_set_block(struct gpio_chip *chip, unsigned long mask, unsigned long val)
> +{
> +	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
> +	void __iomem *pio = at91_gpio->regbase;
> +
> +	__raw_writel(mask, pio + (val ? PIO_SODR : PIO_CODR));
> +}
> +

Without having an AT91 available right now, I guess the hardware
interface of this GPIO chip is different from the GPIO block API. While
the hardware has clear and set registers, the val parameter of
at91_gpiolib_set_block() should be interpreted as the actual output
values. See lpc32xx_gpo_set_block() for an example for handling set and
clear registers like this: First, set_bits and clear_bits words are
calculated from mask and val parameters, and finally written to the
respective hardware registers.

Note that one .set_block() can result in writing both the set and clear
registers of the hardware when val contains both 0s and 1s in
respectively masked positions.

Roland

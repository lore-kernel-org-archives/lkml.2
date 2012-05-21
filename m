Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213Ab2EUVae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:30:34 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:37104 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2EUVac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:30:32 -0400
MIME-Version: 1.0
In-Reply-To: <1337628827-14484-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1337593269-2497-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<1337628827-14484-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Mon, 21 May 2012 23:30:28 +0200
Message-ID: <CACRpkdYJyUE-gM+wnOQvqW4Txuf65kEJsUbdJcBhkzRZYCxYDQ@mail.gmail.com>
Subject: Re: [PATCH v3] leds: Add MAX6956 driver
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 9:33 PM, Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:

> +config LEDS_MAX6956
> +       tristate "LED support for MAX6956 LED Display Driver and I/O Expander"
> +       depends on LEDS_CLASS
> +       depends on GPIOLIB

Shouldn't this be select GPIOLIB?

You seem to require it when using this driver.

Better than hiding it if not selecting GPIOLIB somewhere else?

> +struct max6956_ddata {
> +       struct device *dev;
> +
> +       struct mutex lock;
> +
> +       struct regmap *regmap;
> +
> +       struct gpio_chip gpio_chip;
> +
> +       struct max6956_pdata pdata;
> +
> +       struct max6956_led_ddata leds[32];
> +
> +       const char *gpio_names[32];
> +};

You can never have enough whitespace? ;-)

Anyway, so this thing has a gpio_chip and leds.

The archaic way is to create mfd/max-6956.c and have this
MFD device spawn two cells, one for GPIO landing in
driver/gpio/gpio-max6956.c and one for LED landing in
leds/leds-max6956.c, then mediate register read/writes and
regmap in the MFD driver.

The MFD driver decide using platform data whether each
line should be used for a LED or GPIO.

Is there some problem with this design pattern?

Yours,
Linus Walleij

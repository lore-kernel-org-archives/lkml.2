Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab1FJP5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 11:57:43 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:29399 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab1FJP5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 11:57:42 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-160.messagelabs.com!1307721388!25358604!119
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.178]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>
Date: Fri, 10 Jun 2011 10:57:33 -0500
Subject: RE: [PATCH 1/2] gpio: expose gpio_to_chip()
Thread-Topic: [PATCH 1/2] gpio: expose gpio_to_chip()
Thread-Index: AcwnS2VJ5Xo98OcRSASFzdRkx+mvDAAOjS0g
Message-ID: <ADE657CA350FB648AAC2C43247A983F001F3820B879F@AUSP01VMBX24.collaborationhost.net>
References: <1307695752-28051-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1307695752-28051-1-git-send-email-linus.walleij@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 10, 2011 1:49 AM, Linus Walleij wrote:
>
> This makes the gpio_to_chip() function available to drivers. The
> usecase is when you want to add a few chip-specific operations
> apart from the ones exposed in struct gpio_chip.
>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/gpio/gpiolib.c     |    2 +-
>  include/asm-generic/gpio.h |    1 +
>  2 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index a971e3d..dc315e9 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -114,7 +114,7 @@ static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
>  }
> 
>  /* caller holds gpio_lock *OR* gpio is marked as requested */
> -static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
> +struct gpio_chip *gpio_to_chip(unsigned gpio)
>  {
>  	return gpio_desc[gpio].chip;
>  }
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index fcdcb5d..dd8c815 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -132,6 +132,7 @@ struct gpio_chip {
>  #endif
>  };
> 
> +extern struct gpio_chip *gpio_to_chip(unsigned gpio);
>  extern const char *gpiochip_is_requested(struct gpio_chip *chip,
> 			unsigned offset);
>  extern int __must_check gpiochip_reserve(int start, int ngpio);

Linus,

You'll need to fix a couple drivers for this to work.  The symbol gpio_to_chip
is a static symbol in a couple places other than gpiolib.c.


arch/arm/plat-pxa/gpio.c:static inline struct pxa_gpio_chip *gpio_to_chip(unsigned gpio)
drivers/gpio/gpio-74x164.c:static struct gen_74x164_chip *gpio_to_chip(struct gpio_chip *gc)

Regards,
Hartley

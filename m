Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab0LMM3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:29:44 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:42435 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab0LMM3e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:29:34 -0500
X-IronPort-AV: E=Sophos;i="4.59,335,1288584000"; 
   d="scan'208";a="26039943"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>,
        Mike Frysinger <vapier@gentoo.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Date: Mon, 13 Dec 2010 12:29:31 +0000
Subject: RE: [PATCH 01/10] gpio: adp5588-gpio: irq_data conversion.
Thread-Topic: [PATCH 01/10] gpio: adp5588-gpio: irq_data conversion.
Thread-Index: AcuavaYbBcDzUDQeSyqVpUaMFNUsNwAA2PYA
Message-ID: <544AC56F16B56944AEC3BD4E3D591771324BCA82A5@LIMKCMBX1.ad.analog.com>
References: <cover.1292240053.git.buytenh@wantstofly.org>
 <20101213120239.GZ15575@mail.wantstofly.org>
In-Reply-To: <20101213120239.GZ15575@mail.wantstofly.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennert Buytenhek wrote on 2010-12-13:
> Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>

Mark Brown submitted a similar patch yesterday.
I'm going to ACK his one.

-Michael


> ---
>  drivers/gpio/adp5588-gpio.c |   39 ++++++++++++++++++++---------------
>  ---- 1 files changed, 20 insertions(+), 19 deletions(-)
> diff --git a/drivers/gpio/adp5588-gpio.c b/drivers/gpio/adp5588-gpio.c
> index 0871f78..33fc685 100644
> --- a/drivers/gpio/adp5588-gpio.c
> +++ b/drivers/gpio/adp5588-gpio.c
> @@ -146,9 +146,10 @@ static int adp5588_gpio_to_irq(struct gpio_chip
> *chip, unsigned off)
>       return dev->irq_base + off;
>  }
> -static void adp5588_irq_bus_lock(unsigned int irq)
> +static void adp5588_irq_bus_lock(struct irq_data *d)
>  {
> -     struct adp5588_gpio *dev = get_irq_chip_data(irq);
> +     struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
> +
>       mutex_lock(&dev->irq_lock);
>  }
> @@ -160,9 +161,9 @@ static void adp5588_irq_bus_lock(unsigned int irq)
>    * and unlocks the bus.
>    */
> -static void adp5588_irq_bus_sync_unlock(unsigned int irq)
> +static void adp5588_irq_bus_sync_unlock(struct irq_data *d)
>  {
> -     struct adp5588_gpio *dev = get_irq_chip_data(irq);
> +     struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
>       int i;
>
>       for (i = 0; i <= ADP5588_BANK(ADP5588_MAXGPIO); i++) @@ -175,31
>  +176,31 @@ static void adp5588_irq_bus_sync_unlock(unsigned int irq)
>       mutex_unlock(&dev->irq_lock); }
> -static void adp5588_irq_mask(unsigned int irq)
> +static void adp5588_irq_mask(struct irq_data *d)
>  {
> -     struct adp5588_gpio *dev = get_irq_chip_data(irq);
> -     unsigned gpio = irq - dev->irq_base;
> +     struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
> +     unsigned gpio = d->irq - dev->irq_base;
>
>       dev->irq_mask[ADP5588_BANK(gpio)] &= ~ADP5588_BIT(gpio);  }
> -static void adp5588_irq_unmask(unsigned int irq)
> +static void adp5588_irq_unmask(struct irq_data *d)
>  {
> -     struct adp5588_gpio *dev = get_irq_chip_data(irq);
> -     unsigned gpio = irq - dev->irq_base;
> +     struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
> +     unsigned gpio = d->irq - dev->irq_base;
>
>       dev->irq_mask[ADP5588_BANK(gpio)] |= ADP5588_BIT(gpio);  }
> -static int adp5588_irq_set_type(unsigned int irq, unsigned int type)
> +static int adp5588_irq_set_type(struct irq_data *d, unsigned int
> +type)
>  {
> -     struct adp5588_gpio *dev = get_irq_chip_data(irq);
> -     uint16_t gpio = irq - dev->irq_base;
> +     struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
> +     uint16_t gpio = d->irq - dev->irq_base;
>       unsigned bank, bit;
>
>       if ((type & IRQ_TYPE_EDGE_BOTH)) {
>               dev_err(&dev->client->dev, "irq %d: unsupported type %d\n",
> -                     irq, type);
> +                     d->irq, type);
>               return -EINVAL;
>       }
> @@ -222,11 +223,11 @@ static int adp5588_irq_set_type(unsigned int
> irq, unsigned int type)
>
>  static struct irq_chip adp5588_irq_chip = {
>       .name                   = "adp5588",
> -     .mask                   = adp5588_irq_mask,
> -     .unmask                 = adp5588_irq_unmask,
> -     .bus_lock               = adp5588_irq_bus_lock,
> -     .bus_sync_unlock        = adp5588_irq_bus_sync_unlock,
> -     .set_type               = adp5588_irq_set_type,
> +     .irq_mask               = adp5588_irq_mask,
> +     .irq_unmask             = adp5588_irq_unmask,
> +     .irq_bus_lock           = adp5588_irq_bus_lock,
> +     .irq_bus_sync_unlock    = adp5588_irq_bus_sync_unlock,
> +     .irq_set_type           = adp5588_irq_set_type,
>  };
>
>  static int adp5588_gpio_read_intstat(struct i2c_client *client, u8
> *buf)

Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 4036 Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab1EJKEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 06:04:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61848 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab1EJKEC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 06:04:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AMU1Bi5ERW3tGU2+A0+zKPphg6bcQ0+d7bsfoQ6qfpYb+ezupqbJlQkhhYmqob+94e
         tDlx8lvz/Ke1yBa9579wyVDVPAt6psLBe+DfWujthrrMgYfig+ciS/bANaqILlHWfqE5
         LajwKDZixBCVfvVqw1puNNM4rhESpKmkyMWvk=
MIME-Version: 1.0
In-Reply-To: <4DC53134.8070706@gmail.com>
References: <4DC53134.8070706@gmail.com>
Date: Tue, 10 May 2011 11:04:00 +0100
Message-ID: <BANLkTi=DV4nrX2TBaXGCDHB5z2Z4=Q+pqQ@mail.gmail.com>
Subject: Re: [PATCH] AT91: Add external RTC for Flexibity board
From: Maxim Osipov <maxim.osipov@gmail.com>
To: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Maxim Osipov <maxim.osipov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, May 7, 2011 at 12:47 PM, Maxim Osipov <maxim.osipov@gmail.com> wrote:
>
> This patch enables external RTC support on AT91 Flexibity board.
>
> Signed-off-by: Maxim Osipov <maxim.osipov@gmail.com>
> ---
>  arch/arm/mach-at91/board-flexibity.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-at91/board-flexibity.c b/arch/arm/mach-at91/board-flexibity.c
> index c8a62dc..4fdc96c 100644
> --- a/arch/arm/mach-at91/board-flexibity.c
> +++ b/arch/arm/mach-at91/board-flexibity.c
> @@ -1,7 +1,7 @@
>  /*
>  * linux/arch/arm/mach-at91/board-flexibity.c
>  *
> - *  Copyright (C) 2010 Flexibity
> + *  Copyright (C) 2010-2011 Flexibity
>  *  Copyright (C) 2005 SAN People
>  *  Copyright (C) 2006 Atmel
>  *
> @@ -65,6 +65,13 @@ static struct at91_udc_data __initdata flexibity_udc_data = {
>        .pullup_pin     = 0,            /* pull-up driven by UDC */
>  };
>
> +/* I2C devices */
> +static struct i2c_board_info __initdata flexibity_i2c_devices[] = {
> +       {
> +               I2C_BOARD_INFO("ds1307", 0x68),
> +       },
> +};
> +
>  /* SPI devices */
>  static struct spi_board_info flexibity_spi_devices[] = {
>        {       /* DataFlash chip */
> @@ -143,6 +150,9 @@ static void __init flexibity_board_init(void)
>        at91_add_device_usbh(&flexibity_usbh_data);
>        /* USB Device */
>        at91_add_device_udc(&flexibity_udc_data);
> +       /* I2C */
> +       at91_add_device_i2c(flexibity_i2c_devices,
> +               ARRAY_SIZE(flexibity_i2c_devices));
>        /* SPI */
>        at91_add_device_spi(flexibity_spi_devices,
>                ARRAY_SIZE(flexibity_spi_devices));
> --
> 1.7.4.1
>
>

If no comments on the patch - could someone commit it please? Or
should I submit it to the Russell's patch tracking system?

Kind regards,
Maxim

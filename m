Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab2DPJXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:23:48 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:59470 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752970Ab2DPJXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:23:46 -0400
Date: Mon, 16 Apr 2012 12:22:47 +0300
From: Felipe Balbi <balbi@ti.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, olof@lixom.net,
        plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 12/12] USB: gadget/at91_udc: add gpio_to_irq() function
 to vbus interrupt
Message-ID: <20120416092246.GH30878@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
 <041833f4078b6c28cf8a286fad8982bfae18f4b8.1334567594.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nO3oAMapP4dBpMZi"
Content-Disposition: inline
In-Reply-To: <041833f4078b6c28cf8a286fad8982bfae18f4b8.1334567594.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nO3oAMapP4dBpMZi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 16, 2012 at 11:20:56AM +0200, Nicolas Ferre wrote:
> Now that we are using irqdomains, we need to convert GPIO pins to Linux
> IRQ numbers using the gpio_to_irq() function.
> This call is added to request/free_irq calls.
>=20
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org

Please carry on with your series, patches looks fine.

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/gadget/at91_udc.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
> index 0c935d7..9d7bcd9 100644
> --- a/drivers/usb/gadget/at91_udc.c
> +++ b/drivers/usb/gadget/at91_udc.c
> @@ -1863,8 +1863,8 @@ static int __devinit at91udc_probe(struct platform_=
device *pdev)
>  			mod_timer(&udc->vbus_timer,
>  				  jiffies + VBUS_POLL_TIMEOUT);
>  		} else {
> -			if (request_irq(udc->board.vbus_pin, at91_vbus_irq,
> -					0, driver_name, udc)) {
> +			if (request_irq(gpio_to_irq(udc->board.vbus_pin),
> +					at91_vbus_irq, 0, driver_name, udc)) {
>  				DBG("request vbus irq %d failed\n",
>  				    udc->board.vbus_pin);
>  				retval =3D -EBUSY;
> @@ -1886,7 +1886,7 @@ static int __devinit at91udc_probe(struct platform_=
device *pdev)
>  	return 0;
>  fail4:
>  	if (gpio_is_valid(udc->board.vbus_pin) && !udc->board.vbus_polled)
> -		free_irq(udc->board.vbus_pin, udc);
> +		free_irq(gpio_to_irq(udc->board.vbus_pin), udc);
>  fail3:
>  	if (gpio_is_valid(udc->board.vbus_pin))
>  		gpio_free(udc->board.vbus_pin);
> @@ -1924,7 +1924,7 @@ static int __exit at91udc_remove(struct platform_de=
vice *pdev)
>  	device_init_wakeup(&pdev->dev, 0);
>  	remove_debug_file(udc);
>  	if (gpio_is_valid(udc->board.vbus_pin)) {
> -		free_irq(udc->board.vbus_pin, udc);
> +		free_irq(gpio_to_irq(udc->board.vbus_pin), udc);
>  		gpio_free(udc->board.vbus_pin);
>  	}
>  	free_irq(udc->udp_irq, udc);
> --=20
> 1.7.10
>=20

--=20
balbi

--nO3oAMapP4dBpMZi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPi+TmAAoJEIaOsuA1yqRENCAP/jj93/g3gnoJCHr/MQ1ItrHX
2wMrxqKhqcdBasa15rixxulwXbd7pkvKQHDLPeyhM9EdI0/0fglhoV36TQjpEl7a
tJoGTql134I8/LZorc2weRoAWTe/FZsnNsYtfkLFKodIY6X5dNrJdaD8CAcvDRHV
ESqvm5/7ZeJHQTq0nBH4ylaCZdZR1KkbUwef7N/rSkpR9V/yxKO1R7EjNV5Zy9Fi
AxM7rnQG7I7y4EhsRVoCzrlYAevA3EsjLEOhwqItqtzO+1ddgQY8eJ3ff4nD5gT6
nfJKISRNw7EuHqW+oyXTPd9R0ydg+IBmEFUP0XQ0zUIfVtwzj0Ojf5svuKd9H5XM
Vb29AunAH5mToRoUDFzqqw6Zj5oFap7iiW8ui4y7AHyTDE0UMUFx4ykvO72tGABS
YjKRss7urG/k8YOGEOZap1wt0rMJ285Y2v6m/ox9Cg6YAwXrXfmzT4pOa5+ssHk+
XZyWb+OzWjrZGTjDreUPUjD2XWnZ3ESG7vnQ/XWK/BUOMLuRX4xkzeHqsETFTnCZ
G8BrqzxSVOqG7kxn0uYXW1nnl51OFevfrbSVALK7oiBxE8PaMUbqcR51jseq70un
zbSw/3RwBe4R2m9znkq2yqBkKG4TNWxMH11ZeK6WtTXs1gp5daDV2O9kiOsiDIty
+BnXNnax9FBTKtyJH6KH
=bGrP
-----END PGP SIGNATURE-----

--nO3oAMapP4dBpMZi--

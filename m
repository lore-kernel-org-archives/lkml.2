Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030373Ab2AFP1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 10:27:47 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58894 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030340Ab2AFP1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 10:27:44 -0500
Date: Fri, 6 Jan 2012 16:27:41 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Denis Kuzmenko <linux@solonet.org.ua>,
        Dong Aisheng-B29396 <B29396@freescale.com>
Subject: Re: [PATCH RESEND] gpio: add flags to export GPIOs when requesting
Message-ID: <20120106152741.GE2610@pengutronix.de>
References: <1323797641-7277-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gMR3gsNFwZpnI/Ts"
Content-Disposition: inline
In-Reply-To: <1323797641-7277-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gMR3gsNFwZpnI/Ts
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 13, 2011 at 06:34:01PM +0100, Wolfram Sang wrote:
> Introduce new flags to automatically export GPIOs when using the convenie=
nce
> functions gpio_request_one() or gpio_request_array(). This eases support =
for
> custom boards where lots of GPIOs need to be exported for customer
> applications.
>=20
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
>=20
> Based on 3.2-rc5. Previous discussion (with kind of acks) can be found he=
re
>=20
> http://lkml.org/lkml/2011/11/15/378

Ping. I am using this patch with v3.2 right now and it is really useful
(and no build failure this time (I owe you a drink for my last patch!))

>=20
>  Documentation/gpio.txt |    3 +++
>  drivers/gpio/gpiolib.c |   12 +++++++++++-
>  include/linux/gpio.h   |    5 +++++
>  3 files changed, 19 insertions(+), 1 deletions(-)
>=20
> diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
> index 792faa3..9e28c05 100644
> --- a/Documentation/gpio.txt
> +++ b/Documentation/gpio.txt
> @@ -303,6 +303,9 @@ where 'flags' is currently defined to specify the fol=
lowing properties:
>  	* GPIOF_INIT_LOW	- as output, set initial level to LOW
>  	* GPIOF_INIT_HIGH	- as output, set initial level to HIGH
> =20
> +	* GPIOF_EXPORT_DIR_FIXED	- export gpio to sysfs, keep direction
> +	* GPIOF_EXPORT_DIR_CHANGEABLE	- also export, allow changing direction
> +
>  since GPIOF_INIT_* are only valid when configured as output, so group va=
lid
>  combinations as:
> =20
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index a971e3d..65ba047 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1285,8 +1285,18 @@ int gpio_request_one(unsigned gpio, unsigned long =
flags, const char *label)
>  				(flags & GPIOF_INIT_HIGH) ? 1 : 0);
> =20
>  	if (err)
> -		gpio_free(gpio);
> +		goto free_gpio;
> +
> +	if (flags & GPIOF_EXPORT) {
> +		err =3D gpio_export(gpio, flags & GPIOF_EXPORT_CHANGEABLE);
> +		if (err)
> +			goto free_gpio;
> +	}
> +
> +	return 0;
> =20
> + free_gpio:
> +	gpio_free(gpio);
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(gpio_request_one);
> diff --git a/include/linux/gpio.h b/include/linux/gpio.h
> index 38ac48b..38afe24 100644
> --- a/include/linux/gpio.h
> +++ b/include/linux/gpio.h
> @@ -14,6 +14,11 @@
>  #define GPIOF_OUT_INIT_LOW	(GPIOF_DIR_OUT | GPIOF_INIT_LOW)
>  #define GPIOF_OUT_INIT_HIGH	(GPIOF_DIR_OUT | GPIOF_INIT_HIGH)
> =20
> +#define GPIOF_EXPORT		(1 << 2)
> +#define GPIOF_EXPORT_CHANGEABLE	(1 << 3)
> +#define GPIOF_EXPORT_DIR_FIXED	(GPIOF_EXPORT)
> +#define GPIOF_EXPORT_DIR_CHANGEABLE (GPIOF_EXPORT | GPIOF_EXPORT_CHANGEA=
BLE)
> +
>  /**
>   * struct gpio - a structure describing a GPIO with configuration
>   * @gpio:	the GPIO number
> --=20
> 1.7.2.5
>=20

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--gMR3gsNFwZpnI/Ts
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8HEu0ACgkQD27XaX1/VRsEkACfcxxocfwqQtTAtyProIRnlOlF
AjoAoJwg1VSw90xNfSHt7lB005rKe7b5
=/LgT
-----END PGP SIGNATURE-----

--gMR3gsNFwZpnI/Ts--

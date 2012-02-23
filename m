Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab2BWMbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 07:31:39 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:36633 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753572Ab2BWMbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 07:31:38 -0500
Date: Thu, 23 Feb 2012 14:31:31 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Cc: linux-omap@vger.kernel.org, grant.likely@secretlab.ca, khilman@ti.com,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH 6/6] gpio/omap: fix _set_gpio_irqenable implementation
Message-ID: <20120223123130.GJ18463@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com>
 <1329999031-6914-7-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M1akecbV8LB7u7K0"
Content-Disposition: inline
In-Reply-To: <1329999031-6914-7-git-send-email-tarun.kanti@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M1akecbV8LB7u7K0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2012 at 05:40:31PM +0530, Tarun Kanti DebBarma wrote:
> This function should be capable of both enabling and disabling interrupts
> based upon the *enable* parameter. Right now the function only enables
> the interrupt and *enable* is not used at all. So add the interrupt
> disable capability also using the parameter.
>=20
> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>

This one should probably be ported to stable releases, adding
stable@vger to the cc list

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/gpio/gpio-omap.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> index 67535c8..acc71a0 100644
> --- a/drivers/gpio/gpio-omap.c
> +++ b/drivers/gpio/gpio-omap.c
> @@ -473,7 +473,10 @@ static void _disable_gpio_irqbank(struct gpio_bank *=
bank, int gpio_mask)
> =20
>  static inline void _set_gpio_irqenable(struct gpio_bank *bank, int gpio,=
 int enable)
>  {
> -	_enable_gpio_irqbank(bank, GPIO_BIT(bank, gpio));
> +	if (enable)
> +		_enable_gpio_irqbank(bank, GPIO_BIT(bank, gpio));
> +	else
> +		_disable_gpio_irqbank(bank, GPIO_BIT(bank, gpio));
>  }
> =20
>  /*
> --=20
> 1.7.0.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--M1akecbV8LB7u7K0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRjGiAAoJEIaOsuA1yqREr9kQALY+RgllD5n6DeeEFKVwTtSN
bKPceN7iwM6ktoAtjD8Sb5ui/JwVcw6ThYkWdC4IA23KQ+Qn2PdIGIU/P1BX6GDP
fz/I56DdVSbfHdcyscS7xZQEhqZ2Oc2q4e/wdVSj7gaUXWVFHcgHYov20vcAI7yw
eYyySzG3pHLqchmY0YprKG9ROuERhGi2KPZjV61SkYPBdPpgkANE1bC/WglbiJ/u
xQ69Bjhygnh0CZrURiTH/1HLTd0VyAPw9hMNvhVhAqOvA/jNVynoJIlWU4PyXLjQ
VSQx874XNQQVQcPAab2US6kGWhJ0JKu1BikvXEOhC6wFySUo+E3aB/DWtkLdPiDI
khXBGgQyjLmbzALmqAZxTSeSflKv8Aq+6r22UwRBoSrPRg7qgL6kz1RiyAlawWCs
nhKYnSJCFXm53QEDWKbFDF4nZiR1gh3s21p0Du4+QPm31CIK2+7FPiBe9twHZGIG
3f1Op4Y1sEb91srfmkGB6wJphn3sVdw0dIfIqjqnxxuYV2ro8aidrBx9EzZvCgpC
Xom2j4gH1+2M+fHeMYpSjCqKAoSToi4OIx1zHtz4Y+i7yYB/KkMwUkwenptzin3I
do0DDjiCcqVj/Cn1vdWvqSWpBdAXByGXyNbPQzQwZzRQMBhMcVHysHOlRw6EnLBk
KsyrSTdw8Xzt3G2Tw29S
=9aX6
-----END PGP SIGNATURE-----

--M1akecbV8LB7u7K0--

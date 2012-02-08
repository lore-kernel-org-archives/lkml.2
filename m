Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab2BHLAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:00:06 -0500
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:32973 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755470Ab2BHLAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:00:04 -0500
Date: Wed, 8 Feb 2012 12:59:58 +0200
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-i2c@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: Re: [PATCH] I2C: OMAP: fix build breakage when CONFIG_OF is not set
Message-ID: <20120208105957.GB16334@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1328698612-18661-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Content-Disposition: inline
In-Reply-To: <1328698612-18661-1-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 08, 2012 at 12:56:52PM +0200, Luciano Coelho wrote:
> Since commit 6145197be6cc0583fa1a2f4ec1079d366137061e, building

we generally like to see the commit subject here too. And adding the
abbreviated commit instead of the full sha1, wouldn't hurt either ;-)

> i2c_omap.c breaks if CONFIG_OF is not set:
>=20
> drivers/i2c/busses/i2c-omap.c: In function 'omap_i2c_probe':
> drivers/i2c/busses/i2c-omap.c:1021: error: 'omap_i2c_of_match' undeclared=
 (first use in this function)
> drivers/i2c/busses/i2c-omap.c:1021: error: (Each undeclared identifier is=
 reported only once
> drivers/i2c/busses/i2c-omap.c:1021: error: for each function it appears i=
n.)
>=20
> This is because the definition of omap_i2c_of_match is #ifdef'd on
> CONFIG_OF, but the usage of it is not.
>=20
> Since the places where omap_ic2_of_match are prepared to get NULL
> pointers if CONFIG_OF is not defined, we can simply define it to NULL.
>=20
> Cc: Benoit Cousson <b-cousson@ti.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>

after fixing the commit log, you can add:

Reviewed-by: Felipe Balbi <balbi@ti.com>

if you want.

> ---
>  drivers/i2c/busses/i2c-omap.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index f713eac..fd200eb 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -979,6 +979,8 @@ static const struct of_device_id omap_i2c_of_match[] =
=3D {
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, omap_i2c_of_match);
> +#else
> +static const struct of_device_id *omap_i2c_of_match =3D NULL;
>  #endif
> =20
>  static int __devinit
> --=20
> 1.7.5.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMlWtAAoJEIaOsuA1yqRE/voP/j5vccQ3UH1vDMIHo645ZpLP
mso6Leo26Q2C0mFPDJT84mhEREUkXkhVXSFMouTXsWByFhP+krGDgcqdCeuFGkC0
ga2jh8eA/Qt4xSbPnSAVaeSedP56kVKGDLFmOouT58teaIpjc5ZahZGTNltY6Tw1
fwSGAP8Mpu3zZXKx7k84omxBxXC/Y5PEkTlmcdaauSqJx2T4LGG7vMwQwGgDlbnl
er8sz8OcDyI5HBWMkJmOOhfzVnyN6cW6cX7QmHURRUCRksLFIXBMXy90siMFCJ2Z
AK3SCfAEwtk39nWkNYH5UTLu679cuK+tsND2DQ94K76mVInB9nDGQoLxfkRZEZqB
0Y6xsN3kmLIX1XRK6eesVfDA0EiRfgNcmHzRAjJsXvzXbXQARI0CgMUz40rNz0/H
D2Lait2kr06gR3PIbLWciCx+SQiPgx3PlWZuTpiujbfKvvGPd8iYv6cCVLYFhzlf
L/SZuJ3l1pEhAHZyrXCAMFfcg/uxEyqmH2uSfc2Nh7lSOQiPoCzN8o45q4pixwMl
g+teOCHdAk2ZNwAyWWzlKDyJhJb2/qx/SqFCRduSzSAjkiax00v0bpnv9MfUx9sI
sWyxT5mnKvBxqung+BfUROMd7KN5eccX8EhTx1pgQMv4hEXRHMg+ymXuGG/Um6mL
C2WPmkH3K5G6NzLhq4Mz
=n5dP
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab1LRSxe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 13:53:34 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49217 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab1LRSxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 13:53:31 -0500
Date: Sun, 18 Dec 2011 19:53:29 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Frederic LAMBERT <frdrc66@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] at25: DeviceTree support added
Message-ID: <20111218185329.GA25217@pengutronix.de>
References: <1324232035-2717-1-git-send-email-frdrc66@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <1324232035-2717-1-git-send-email-frdrc66@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

please also CC devicetree-discuss@lists.ozlabs.org when adding new bindings.

On Sun, Dec 18, 2011 at 07:13:55PM +0100, Frederic LAMBERT wrote:
> From: Frederic Lambert <frdrc66@gmail.com>
>=20
> Signed-off-by: Frederic Lambert <frdrc66@gmail.com>
> Signed-off-by: Frederic LAMBERT <frdrc66@gmail.com>

One is enough :)

> ---
>  Documentation/devicetree/bindings/spi/spi-bus.txt |   19 ++++++
>  drivers/misc/eeprom/at25.c                        |   62 +++++++++++++++=
+----
>  2 files changed, 68 insertions(+), 13 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/spi/spi-bus.txt b/Document=
ation/devicetree/bindings/spi/spi-bus.txt
> index e782add..168ac87 100644
> --- a/Documentation/devicetree/bindings/spi/spi-bus.txt
> +++ b/Documentation/devicetree/bindings/spi/spi-bus.txt
> @@ -33,6 +33,16 @@ contain the following properties.
>      		shifted clock phase (CPHA) mode
>  - spi-cs-high     - (optional) Empty property indicating device requires
>      		chip select active high
> +For SPI eeprom using driver 'at25', slave nodes shall also contain the
> +following properties.
> +- byte_len        - device RAM size
> +- dev_name        - device name
> +- pagesize        - for writes (see at25.c)
> +- flags           - adressing mode and R/O flag
> +      - bit 0:  8 bits addrs (EE_ADDR1)
> +      - bit 1: 16 bits addrs (EE_ADDR2)
> +      - bit 2: 24 bits addrs (EE_ADDR3)
> +      - bit 3: disallow writes (EE_READONLY)
> =20
>  SPI example for an MPC5200 SPI bus:
>  	spi@f00 {
> @@ -54,4 +64,13 @@ SPI example for an MPC5200 SPI bus:
>  			spi-max-frequency =3D <100000>;
>  			reg =3D <1>;
>  		};
> +		at25@0 {
> +			compatible =3D "eeprom,at25";

No, you can't map the platform data 1:1 to the device tree.
The compatible should specify the actual device, for example
"atmel,25320". And from that information you can derive...

> +			byte_len =3D <131072>;
> +			dev_name =3D "CY14B101P";

those two and the EE_ADDR.

> +			pagesize =3D <128>;

This is indeed a valid property, "read-only" would be another one of intere=
st.

Check at24.c and see how it is done there.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7uNqkACgkQD27XaX1/VRu7bwCgnXx+QjCAUBjE5El7y7o7y+zb
HI0AoIxbttoO//9kIfBAWtqv+z7aqOTW
=dzp4
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab2GMGcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 02:32:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35454 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2GMGcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 02:32:03 -0400
Date: Fri, 13 Jul 2012 08:31:59 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH 4/8 v2] i2c: i2c-bfin-twi: Tighten condition when failing
 I2C transfer if MEN bit is reset unexpectedly.
Message-ID: <20120713063159.GB32184@pengutronix.de>
References: <1339575767-22985-1-git-send-email-sonic.adi@gmail.com>
 <1339575767-22985-4-git-send-email-sonic.adi@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Content-Disposition: inline
In-Reply-To: <1339575767-22985-4-git-send-email-sonic.adi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 13, 2012 at 04:22:43PM +0800, Sonic Zhang wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
>=20
> In order to mark I2C transfer fail when MEN bit in I2C controller is rese=
t unexpeced

"unexpected"

> in MCOMP interrupt, interrupt status bits XMTSERV or RCVSERV should be ch=
ecked.
>=20
> Master Transfer Complete (MCOMP).
> [1] The initiated master transfer has completed. In the absence of a
> repeat start, the bus has been released.
> [0] The completion of a transfer has not been detected.
>=20
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/i2c/busses/i2c-bfin-twi.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-b=
fin-twi.c
> index a5ab454..2e59bbd 100644
> --- a/drivers/i2c/busses/i2c-bfin-twi.c
> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
> @@ -201,7 +201,8 @@ static void bfin_twi_handle_interrupt(struct bfin_twi=
_iface *iface,
>  		return;
>  	}
>  	if (twi_int_status & MCOMP) {
> -		if ((read_MASTER_CTL(iface) & MEN) =3D=3D 0 &&
> +		if (twi_int_status & (XMTSERV|RCVSERV) &&

Spaces around operators.

I fixed both for you.

> +			(read_MASTER_CTL(iface) & MEN) =3D=3D 0 &&
>  			(iface->cur_mode =3D=3D TWI_I2C_MODE_REPEAT ||
>  			iface->cur_mode =3D=3D TWI_I2C_MODE_COMBINED)) {
>  			iface->result =3D -1;
> --=20
> 1.7.0.4
>=20
>=20

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk//wN8ACgkQD27XaX1/VRtG/QCgkPW+AfSq2miKlblG4rpsmA77
VywAn1u86FeADKcPxob9tA+JfXi9k/uG
=Jy/t
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab2IML5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 07:57:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46244 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab2IML5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 07:57:37 -0400
Message-ID: <5051CA2C.5080806@pengutronix.de>
Date: Thu, 13 Sep 2012 13:57:32 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        sameo@linux.intel.com
Subject: Re: [PATCH 2/2] can: janz-ican3: fix support for older hardware revisions
References: <1347404295-7985-1-git-send-email-iws@ovro.caltech.edu> <1347404295-7985-3-git-send-email-iws@ovro.caltech.edu>
In-Reply-To: <1347404295-7985-3-git-send-email-iws@ovro.caltech.edu>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8D1073A90A7671430FB85825"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8D1073A90A7671430FB85825
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/12/2012 12:58 AM, Ira W. Snyder wrote:
> From: "Ira W. Snyder" <iws@ovro.caltech.edu>
>=20
> The Revision 1.0 Janz CMOD-IO Carrier Board does not have support for
> the reset registers. To support older hardware, the code is changed to
> use the hardware reset register on the Janz VMOD-ICAN3 hardware itself.=

>=20
> Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>

Applied to linux-can.

Tnx,
Marc
> ---
>  drivers/net/can/janz-ican3.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.=
c
> index 98ee438..7edadee 100644
> --- a/drivers/net/can/janz-ican3.c
> +++ b/drivers/net/can/janz-ican3.c
> @@ -1391,7 +1391,6 @@ static irqreturn_t ican3_irq(int irq, void *dev_i=
d)
>   */
>  static int ican3_reset_module(struct ican3_dev *mod)
>  {
> -	u8 val =3D 1 << mod->num;
>  	unsigned long start;
>  	u8 runold, runnew;
> =20
> @@ -1405,8 +1404,7 @@ static int ican3_reset_module(struct ican3_dev *m=
od)
>  	runold =3D ioread8(mod->dpm + TARGET_RUNNING);
> =20
>  	/* reset the module */
> -	iowrite8(val, &mod->ctrl->reset_assert);
> -	iowrite8(val, &mod->ctrl->reset_deassert);
> +	iowrite8(0x00, &mod->dpmctrl->hwreset);
> =20
>  	/* wait until the module has finished resetting and is running */
>  	start =3D jiffies;
>=20


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig8D1073A90A7671430FB85825
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBRyiwACgkQjTAFq1RaXHMBnQCcCgQW+8Q2GKlAcsVrGsWJsToa
H6UAn1E4s9c1TM4BdL4BumpBhs6RvQ5D
=AS86
-----END PGP SIGNATURE-----

--------------enig8D1073A90A7671430FB85825--

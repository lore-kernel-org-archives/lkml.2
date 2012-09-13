Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab2IML4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 07:56:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50939 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757744Ab2IML4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 07:56:42 -0400
Message-ID: <5051C9F0.3050600@pengutronix.de>
Date: Thu, 13 Sep 2012 13:56:32 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        sameo@linux.intel.com
Subject: Re: [PATCH 1/2] mfd/janz-cmodio: fix MODULBus number sysfs entry
References: <1347404295-7985-1-git-send-email-iws@ovro.caltech.edu> <1347404295-7985-2-git-send-email-iws@ovro.caltech.edu>
In-Reply-To: <1347404295-7985-2-git-send-email-iws@ovro.caltech.edu>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFB7AD0A080C12FDDAC84541C"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFB7AD0A080C12FDDAC84541C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/12/2012 12:58 AM, Ira W. Snyder wrote:
> From: "Ira W. Snyder" <iws@ovro.caltech.edu>
>=20
> Revision 1.0 of the Janz CMOD-IO Carrier Board does not contain zeroes
> in the top 4 bits of the modulbus_num (int_enable) register. Mask off
> the unused bits so that the correct value is displayed in sysfs.
>=20
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>

Who will take care of this patch?

Marc

> ---
>  drivers/mfd/janz-cmodio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/mfd/janz-cmodio.c b/drivers/mfd/janz-cmodio.c
> index 2ea9998..32d0efd 100644
> --- a/drivers/mfd/janz-cmodio.c
> +++ b/drivers/mfd/janz-cmodio.c
> @@ -216,7 +216,7 @@ static int __devinit cmodio_pci_probe(struct pci_de=
v *dev,
>  	}
> =20
>  	/* Read the hex switch on the carrier board */
> -	priv->hex =3D ioread8(&priv->ctrl->int_enable);
> +	priv->hex =3D ioread8(&priv->ctrl->int_enable) & 0x0f;
> =20
>  	/* Add the MODULbus number (hex switch value) to the device's sysfs *=
/
>  	ret =3D sysfs_create_group(&dev->dev.kobj, &cmodio_sysfs_attr_group);=

>=20


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigFB7AD0A080C12FDDAC84541C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBRyfAACgkQjTAFq1RaXHMAugCdFXAAw1GBtox/bqwWVCbgLrY9
qoYAniVdmc4G7TK3xzbDlvwGyG4HECH9
=u09E
-----END PGP SIGNATURE-----

--------------enigFB7AD0A080C12FDDAC84541C--

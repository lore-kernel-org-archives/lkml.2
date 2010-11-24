Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0KXM6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 07:58:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37825 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab0KXM6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 07:58:37 -0500
Message-ID: <4CED0BF1.1060305@pengutronix.de>
Date: Wed, 24 Nov 2010 13:58:25 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Christian Pellegrin <chripell@fsfe.org>,
        Barry Song <21cnbao@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        andrew.chih.howe.khor@intel.com, qi.wang@intel.com,
        margie.foster@intel.com, yong.y.wang@intel.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 12/17 v3] can: EG20T PCH: Fix bit timing
 calculation issue
References: <4CED037F.6060306@dsn.okisemi.com>
In-Reply-To: <4CED037F.6060306@dsn.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig77324EAB8C3B34DEAE8D6DC6"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig77324EAB8C3B34DEAE8D6DC6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/24/2010 01:22 PM, Tomoya MORINAGA wrote:
> Fix bit timing calculation issue
> Modify like use calculated value directly passed by CAN core module.
>=20
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

> ---
>  drivers/net/can/pch_can.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
> index 7342030..466f011 100644
> --- a/drivers/net/can/pch_can.c
> +++ b/drivers/net/can/pch_can.c
> @@ -800,17 +800,15 @@ static int pch_set_bittiming(struct net_device *n=
dev)
>  	const struct can_bittiming *bt =3D &priv->can.bittiming;
>  	u32 canbit;
>  	u32 bepe;
> -	u32 brp;
>=20
>  	/* Setting the CCE bit for accessing the Can Timing register. */
>  	pch_can_bit_set(&priv->regs->cont, PCH_CTRL_CCE);
>=20
> -	brp =3D (bt->tq) / (1000000000/PCH_CAN_CLK) - 1;
> -	canbit =3D brp & PCH_MSK_BITT_BRP;
> +	canbit =3D (bt->brp - 1) & PCH_MSK_BITT_BRP;

Masking here shouldn't be necessary but won't hurt, better play safe.

>  	canbit |=3D (bt->sjw - 1) << PCH_BIT_SJW_SHIFT;
>  	canbit |=3D (bt->phase_seg1 + bt->prop_seg - 1) << PCH_BIT_TSEG1_SHIF=
T;
>  	canbit |=3D (bt->phase_seg2 - 1) << PCH_BIT_TSEG2_SHIFT;
> -	bepe =3D (brp & PCH_MSK_BRPE_BRPE) >> PCH_BIT_BRPE_BRPE_SHIFT;
> +	bepe =3D ((bt->brp - 1) & PCH_MSK_BRPE_BRPE) >> PCH_BIT_BRPE_BRPE_SHI=
FT;

dito

>  	iowrite32(canbit, &priv->regs->bitt);
>  	iowrite32(bepe, &priv->regs->brpe);
>  	pch_can_bit_clear(&priv->regs->cont, PCH_CTRL_CCE);

cheers, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig77324EAB8C3B34DEAE8D6DC6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkztC/QACgkQjTAFq1RaXHNRIQCePMQYYBNFn4127QpxG2R6RbjN
q84An0SmoXzlx4RX0uHRcnwVw/w6zvqo
=98VQ
-----END PGP SIGNATURE-----

--------------enig77324EAB8C3B34DEAE8D6DC6--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab0LLS3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 13:29:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51414 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab0LLS31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 13:29:27 -0500
Message-ID: <4D04E6FD.50106@pengutronix.de>
Date: Sun, 12 Dec 2010 16:15:09 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: Wolfgang Grandegger <wg@grandegger.com>, socketcan-core@lists.berlios.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew.chih.howe.khor@intel.com, qi.wang@intel.com,
        margie.foster@intel.com, yong.y.wang@intel.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com
Subject: Re: [PATCH net-next-2.6 v8 20/20] CAN : Replace netif_rx to	netif_receive_skb
References: <4CFE16A3.6070903@dsn.okisemi.com>
In-Reply-To: <4CFE16A3.6070903@dsn.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig04ADE4E05813609ACB2750FC"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig04ADE4E05813609ACB2750FC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/07/2010 12:12 PM, Tomoya MORINAGA wrote:
> Since this driver is implemented as NAPI,
> netif_receive_skb must be used not netif_rx.
>=20
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Looks good.
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

Marc

> ---
>  drivers/net/can/pch_can.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
> index 4697b1c..8d45fdd 100644
> --- a/drivers/net/can/pch_can.c
> +++ b/drivers/net/can/pch_can.c
> @@ -572,7 +572,7 @@ static void pch_can_error(struct net_device *ndev, =
u32 status)
>  	cf->data[7] =3D (errc & PCH_REC) >> 8;
> =20
>  	priv->can.state =3D state;
> -	netif_rx(skb);
> +	netif_receive_skb(skb);
> =20
>  	stats->rx_packets++;
>  	stats->rx_bytes +=3D cf->can_dlc;


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig04ADE4E05813609ACB2750FC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk0E5wAACgkQjTAFq1RaXHO+/ACeOx5pkWUz7wuLSScnxBa7AGVA
Z/QAn0Ho3vV9IPUoHqAakZ8Aml733ScJ
=AlF3
-----END PGP SIGNATURE-----

--------------enig04ADE4E05813609ACB2750FC--

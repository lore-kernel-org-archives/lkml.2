Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964856Ab2JEVGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 17:06:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43030 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964797Ab2JEVGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 17:06:36 -0400
Message-ID: <506F4BC9.50506@pengutronix.de>
Date: Fri, 05 Oct 2012 23:06:17 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: wg@grandegger.com, davem@davemloft.net, jj@chaosbits.net,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/20 V2] drivers/net/can/sja1000/peak_pci.c: fix error
 return code
References: <1349469667-6137-1-git-send-email-peter.senna@gmail.com> <1349469667-6137-3-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1349469667-6137-3-git-send-email-peter.senna@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6AC7AE5B36A4A9E45097CEA7"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6AC7AE5B36A4A9E45097CEA7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/05/2012 10:41 PM, Peter Senna Tschudin wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
>=20
> The function peak_pci_probe() return 0 for success and negative value
> for most of its internal tests failures. There are two exceptions
> that are error cases going to failure_*:. Fore this two cases the
> function abort its success execution path, but returns non negative
> value, making it dificult for a caller function to notice the error.
>=20
> This patch fixes the error cases that do not return negative values.
>=20
> This was found by Coccinelle, but the code change was made by hand.
> This patch is not robot generated.
>=20
> A simplified version of the semantic match that finds this problem is
> as follows: (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret !=3D 0\))
>  { ... return ret; }
> |
> ret@p1 =3D 0
> )
> ... when !=3D ret =3D e1
>     when !=3D &ret
> *if(...)
> {
>   ... when !=3D ret =3D e2
>       when forall
>  return ret;
> }
> // </smpl>
>=20
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Too late, v1 of this patch is already in net/master

regards, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig6AC7AE5B36A4A9E45097CEA7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBvS80ACgkQjTAFq1RaXHPSeQCfeuKpV+0N0X8+nPBE+9cfldRI
vMwAnjrzgLOHZqtxArZ71zGn1cfbFbbh
=fKWB
-----END PGP SIGNATURE-----

--------------enig6AC7AE5B36A4A9E45097CEA7--

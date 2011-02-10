Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab1BJVlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 16:41:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60700 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab1BJVlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 16:41:40 -0500
Date: Thu, 10 Feb 2011 22:41:31 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Antony Pavlov <antony@niisi.msk.ru>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: cfi_cmdset_0002: fix sector erase command for
 AM29LV040B
Message-ID: <20110210214131.GA6561@pengutronix.de>
References: <1297371877-32123-1-git-send-email-antony@niisi.msk.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <1297371877-32123-1-git-send-email-antony@niisi.msk.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 11, 2011 at 12:04:37AM +0300, Antony Pavlov wrote:
> The AM29LV040B chips use 0x50 as sector erase command instead of 0x30 [1].
>=20
> [1] http://www.datasheetcatalog.com/datasheets_pdf/A/M/2/9/AM29LV040B.sht=
ml

I am confused. The datasheet says on page 15 it uses 0x30 while your
description above says it uses 0x50...

> Signed-off-by: Antony Pavlov <antony@niisi.msk.ru>
> ---
>  drivers/mtd/chips/cfi_cmdset_0002.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_=
cmdset_0002.c
> index f072fcf..a401dbe 100644
> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
> @@ -332,6 +332,14 @@ static void fixup_s29gl032n_sectors(struct mtd_info =
*mtd)
>  	}
>  }
> =20
> +static void fixup_use_sector_erase_cmd_30(struct mtd_info *mtd)
> +{
> +	struct map_info *map =3D mtd->priv;
> +	struct cfi_private *cfi =3D map->fldrv_priv;
> +
> +	cfi->sector_erase_cmd =3D CMD(0x30);

=2E.. but here you change it to 0x30 (which is the default) instead of 0x50?

Please clarify,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1UW4gACgkQD27XaX1/VRsalQCfddhBiMSGntZ6bVY1JuQ73sX8
P+oAoMjvwvOA5r/GfV8sTalXBtjByucG
=IYNr
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280Ab1IIKIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 06:08:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37708 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080Ab1IIKIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 06:08:23 -0400
Date: Fri, 9 Sep 2011 12:08:20 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/2] ALSA: keywest: Remove obsolete cleanup for
 clientdata
Message-ID: <20110909100820.GK1912@pengutronix.de>
References: <1315561784.2831.0.camel@phoenix>
 <1315561852.2831.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQ77YLfPrO/qF/pM"
Content-Disposition: inline
In-Reply-To: <1315561852.2831.1.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQ77YLfPrO/qF/pM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 09, 2011 at 05:50:52PM +0800, Axel Lin wrote:
> The i2c core will clear the clientdata pointer automatically.
> We don't have to set the `data' field to NULL in remove() or
> if probe() failed anymore.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

There is (at least) one

if (ptr)
	kfree(ptr);

in this driver. Maybe you could fix this, too, while you are here.

And there is soc/codecs/tpa6130a2.c waiting to be fixed as well :)

> ---
>  sound/ppc/keywest.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>=20
> diff --git a/sound/ppc/keywest.c b/sound/ppc/keywest.c
> index 8f064c7..4080bec 100644
> --- a/sound/ppc/keywest.c
> +++ b/sound/ppc/keywest.c
> @@ -82,7 +82,6 @@ static int keywest_attach_adapter(struct i2c_adapter *a=
dapter)
> =20
>  static int keywest_remove(struct i2c_client *client)
>  {
> -	i2c_set_clientdata(client, NULL);
>  	if (! keywest_ctx)
>  		return 0;
>  	if (client =3D=3D keywest_ctx->client)
> --=20
> 1.7.4.1
>=20
>=20
>=20

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--LQ77YLfPrO/qF/pM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk5p5ZQACgkQD27XaX1/VRsncwCgrVZ+E79G/JlKXRSNn+YY8GGK
OvcAn37uV4SLIO1ck6yw7dv0dMeM74tP
=IOt0
-----END PGP SIGNATURE-----

--LQ77YLfPrO/qF/pM--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1HTNow (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 09:44:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40663 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab1HTNou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 09:44:50 -0400
Date: Sat, 20 Aug 2011 15:44:39 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Julia Lawall <julia@diku.dk>
Cc: Liam Girdwood <lrg@ti.com>, kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Dong Aisheng <b29396@freescale.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] sound/soc/mxs/mxs-saif.c: add missing kfree
Message-ID: <20110820134439.GA2266@pengutronix.de>
References: <1313820761-12042-3-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <1313820761-12042-3-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 20, 2011 at 08:12:40AM +0200, Julia Lawall wrote:

> diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
> index 0b3adae..4a17bc8 100644
> --- a/sound/soc/mxs/mxs-saif.c
> +++ b/sound/soc/mxs/mxs-saif.c
> @@ -523,8 +523,10 @@ static int mxs_saif_probe(struct platform_device *pd=
ev)
>  	if (!saif)
>  		return -ENOMEM;
> =20
> -	if (pdev->id >=3D ARRAY_SIZE(mxs_saif))
> -		return -EINVAL;
> +	if (pdev->id >=3D ARRAY_SIZE(mxs_saif)) {
> +		ret =3D -EINVAL;
> +		goto failed;
> +	}
>  	mxs_saif[pdev->id] =3D saif;

Thanks, Julia. May I suggest to simple move the id-check before the
allocation?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk5PukcACgkQD27XaX1/VRs7/gCglf5+sIRVoH2jDAqCqjEVVzTh
UX0AoKRND9QLZLtDrUYLrtJ1bczyZx3y
=Fu0f
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--

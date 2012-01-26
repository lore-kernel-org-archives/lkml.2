Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab2AZNvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:51:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60511 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2AZNvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:51:39 -0500
Date: Thu, 26 Jan 2012 14:51:35 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 1/15] sound/soc/mxs/mxs-saif.c: add
 missing iounmap
Message-ID: <20120126135135.GD2611@pengutronix.de>
References: <1326362117-29371-1-git-send-email-Julia.Lawall@lip6.fr>
 <7FE21149F4667147B645348EC605788508FBDB@039-SN2MPN1-013.039d.mgd.msft.net>
 <alpine.DEB.2.02.1201241828480.1779@localhost6.localdomain6>
 <20120124202203.GD1135@opensource.wolfsonmicro.com>
 <alpine.DEB.2.02.1201242144580.1998@hadrien>
 <20120126110506.GB2611@pengutronix.de>
 <alpine.DEB.2.02.1201261220460.1851@localhost6.localdomain6>
 <20120126112242.GA9401@opensource.wolfsonmicro.com>
 <alpine.DEB.2.02.1201261439460.1851@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6WlEvdN9Dv0WHSBl"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1201261439460.1851@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6WlEvdN9Dv0WHSBl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Julia,

>  	iores =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> @@ -663,18 +663,11 @@ static int mxs_saif_probe(struct platform_device *p=
dev)
>  		goto failed_get_resource;
>  	}
>=20
> -	if (!request_mem_region(iores->start, resource_size(iores),
> -				"mxs-saif")) {
> -		dev_err(&pdev->dev, "request_mem_region failed\n");
> -		ret =3D -EBUSY;
> -		goto failed_get_resource;
> -	}
> -
> -	saif->base =3D ioremap(iores->start, resource_size(iores));
> +	saif->base =3D devm_request_and_ioremap(&pdev->dev, iores);

You can skip checking 'iores', too. I also did that in the example, but
a lot of people seem to miss it. Where did you get the information how
to use devm_request_and_ioremap? I probably need to spread the word even
more...

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--6WlEvdN9Dv0WHSBl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8hWmcACgkQD27XaX1/VRtTswCeLgDt7EjSmhNRcozYM9Rs94KA
8cUAn2Y7txHBqm6u85nuQ0rCT9o1lbYc
=SnFJ
-----END PGP SIGNATURE-----

--6WlEvdN9Dv0WHSBl--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab1BYSWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:22:17 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45832 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab1BYSWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:22:16 -0500
Date: Fri, 25 Feb 2011 19:22:06 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Philip Rakity <prakity@marvell.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jae hoon Chung <jh80.chung@gmail.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sdhci: always use max timeout for xfers
Message-ID: <20110225182206.GC15491@pengutronix.de>
References: <D8739074-546D-4531-A8E9-23E9F7A33EB5@marvell.com>
 <20110225180248.GA15491@pengutronix.de>
 <9C437661-BFCC-4F73-989E-06589E0D37CA@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NKoe5XOeduwbEQHU"
Content-Disposition: inline
In-Reply-To: <9C437661-BFCC-4F73-989E-06589E0D37CA@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NKoe5XOeduwbEQHU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> >> -	return count;
> >> +	return 0xE;
> >=20
> > Why don't you remove the function entirely?
>=20
> better to rename it --- to set_maximum_timeout  since a little clearer.
> left the old name for historical reasons -- if no need I will change it

I'd suggest...

>=20
> >=20
> >> }
> >>=20
> >> static void sdhci_set_transfer_irqs(struct sdhci_host *host)
> >> @@ -671,7 +633,7 @@ static void sdhci_prepare_data(struct sdhci_host *=
host, struct mmc_data *data)
> >> 	host->data =3D data;
> >> 	host->data_early =3D 0;
> >>=20
> >> -	count =3D sdhci_calc_timeout(host, data);
> >> +	count =3D sdhci_calc_timeout();
> >> 	sdhci_writeb(host, count, SDHCI_TIMEOUT_CONTROL);

using SDHCI_TIMEOUT_MAX here instead of count with a proper define in
sdhci.h.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--NKoe5XOeduwbEQHU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1n804ACgkQD27XaX1/VRtr1wCgsMBJ+4Y/OK/bUhfoGRVuE+zA
qgQAoK2dz5OxAbfzPw28b2oNou38z9xZ
=ECrS
-----END PGP SIGNATURE-----

--NKoe5XOeduwbEQHU--

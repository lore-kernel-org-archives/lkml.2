Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab1E3M6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:58:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47165 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab1E3M63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:58:29 -0400
Date: Mon, 30 May 2011 14:58:22 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sdhci: fix undue iomem warning
Message-ID: <20110530125822.GD3409@pengutronix.de>
References: <1306758796-4254-1-git-send-email-daniel.blueman@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yudcn1FV7Hsu/q59"
Content-Disposition: inline
In-Reply-To: <1306758796-4254-1-git-send-email-daniel.blueman@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yudcn1FV7Hsu/q59
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
> index 936bbca..ae948b0 100644
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -918,8 +918,9 @@ static struct sdhci_pci_slot * __devinit sdhci_pci_pr=
obe_slot(
>  		return ERR_PTR(-ENODEV);
>  	}
> =20
> -	if (pci_resource_len(pdev, bar) !=3D 0x100) {
> -		dev_err(&pdev->dev, "Invalid iomem size. You may "
> +	int len =3D pci_resource_len(pdev, bar);
> +	if (len !=3D 0x100 && len !=3D 0x200) {

Hmmm,

a) SDHC Specs (even v3) only mention 0x100, so this _is_ the standard.
   Do the new cards (which ones?) have anything located in the extra
   area?
b) your approach won't scale very well

so, I'd say it is better to keep the old way.

> +		dev_warn(&pdev->dev, "Invalid iomem size. You may "
>  			"experience problems.\n");

I second turning the message into a warning, though.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--yudcn1FV7Hsu/q59
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk3jlG4ACgkQD27XaX1/VRsD2QCbBiTgD8QyC17nQN4k5UtoPjdr
eVgAnAkmWcJQEhUm1D2Sjvjn5l2Re1OX
=AFp5
-----END PGP SIGNATURE-----

--yudcn1FV7Hsu/q59--

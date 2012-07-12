Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088Ab2GLKKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:10:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41490 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933652Ab2GLKJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:09:13 -0400
Date: Thu, 12 Jul 2012 11:53:52 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: khali@linux-fr.org, ben-linux@fluff.org, swarren@nvidia.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 4/5] i2c: tegra: Use struct dev_pm_ops for power
 management
Message-ID: <20120712095352.GD27520@pengutronix.de>
References: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com>
 <1341919244-23327-5-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9UV9rz0O2dU/yYYn"
Content-Disposition: inline
In-Reply-To: <1341919244-23327-5-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9UV9rz0O2dU/yYYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 10, 2012 at 04:50:43PM +0530, Laxman Dewangan wrote:
> Make the tegra i2c driver define its PM callbacks through
> struct dev_pm_ops objects rather than by using legacy PM hooks
> in struct platform_driver.
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/i2c/busses/i2c-tegra.c |   19 +++++++++++++------
>  1 files changed, 13 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegr=
a.c
> index 0792674..5f0572d 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -713,8 +713,9 @@ static int __devexit tegra_i2c_remove(struct platform=
_device *pdev)
>  }
> =20
>  #ifdef CONFIG_PM
> -static int tegra_i2c_suspend(struct platform_device *pdev, pm_message_t =
state)
> +static int tegra_i2c_suspend(struct device *dev)
>  {
> +	struct platform_device *pdev =3D to_platform_device(dev);
>  	struct tegra_i2c_dev *i2c_dev =3D platform_get_drvdata(pdev);

I like Rafael's patch better because of dev_get_drvdata. I'll pick his
and add your 5/5 on top of that.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--9UV9rz0O2dU/yYYn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/+nrAACgkQD27XaX1/VRvh8ACgtn+mpmpRyQgxTYZpWsiSnxgf
2eIAn04dCK7wANS9nESK9YwJsQMmOrFs
=tDuW
-----END PGP SIGNATURE-----

--9UV9rz0O2dU/yYYn--

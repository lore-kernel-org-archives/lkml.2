Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab2HRSwy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 14:52:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40464 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2HRSwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 14:52:51 -0400
Date: Sat, 18 Aug 2012 20:52:44 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: khali@linux-fr.org, swarren@nvidia.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        olof@lixom.net
Subject: Re: [PATCH REBASE 2/2] i2c: tegra: dynamically control fast clk
Message-ID: <20120818185244.GD19802@pengutronix.de>
References: <1345230155-4252-1-git-send-email-ldewangan@nvidia.com>
 <1345230155-4252-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZARJHfwaSJQLOEUz"
Content-Disposition: inline
In-Reply-To: <1345230155-4252-2-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZARJHfwaSJQLOEUz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 18, 2012 at 12:32:35AM +0530, Laxman Dewangan wrote:
> Tegra I2C driver enables the fast clock during initialization
> and does not disable till driver removed.
> Enable this clock before transfer and disable after transfer done.
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Except that this patch is affected from the flaw of the previous patch,
it looks good to me.

> -	clk_prepare_enable(i2c_dev->clk);
> +	tegra_i2c_clock_enable(i2c_dev);

This should be div_clk.

>  	for (i =3D 0; i < num; i++) {
>  		enum msg_end_type end_type =3D MSG_END_STOP;
>  		if (i < (num - 1)) {
> @@ -597,7 +621,7 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, s=
truct i2c_msg msgs[],
>  		if (ret)
>  			break;
>  	}
> -	clk_disable_unprepare(i2c_dev->div_clk);
> +	tegra_i2c_clock_disable(i2c_dev);
>  	return ret ?: i;

If that is fixed, you can add

Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ZARJHfwaSJQLOEUz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAv5HwACgkQD27XaX1/VRvu6QCgphMFz7+xOciNKwLbn32hqw6x
GdgAniqA07wwMuAUHLwkEdC+phgcQzt9
=bubb
-----END PGP SIGNATURE-----

--ZARJHfwaSJQLOEUz--

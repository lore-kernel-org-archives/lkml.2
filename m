Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab1LFTMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:12:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50965 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab1LFTMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:12:12 -0500
Date: Tue, 6 Dec 2011 20:12:03 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Lothar =?iso-8859-15?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>
Subject: Re: [MXS MMC 4/5] Check the return codes of clk_enable() and
 mxs_reset_block()
Message-ID: <20111206191203.GE7835@pengutronix.de>
References: <cover.1323177907.git.LW@KARO-electronics.de>
 <b4779523002ceef3e95887bbcf7ed570cdd93a95.1323177907.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JBi0ZxuS5uaEhkUZ"
Content-Disposition: inline
In-Reply-To: <b4779523002ceef3e95887bbcf7ed570cdd93a95.1323177907.git.LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JBi0ZxuS5uaEhkUZ
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 06, 2011 at 02:41:29PM +0100, Lothar Wa=DFmann wrote:
> Add an int return value to mxs_mmc_reset(), so that the return code of
> mxs_reset_block() can be promoted to the caller.
> Also check the return code of clk_enable() in the probe function.
>=20
> Signed-off-by: Lothar Wa=DFmann <LW@KARO-electronics.de>
> -	clk_enable(host->clk);
> +	ret =3D clk_enable(host->clk);
> +	if (ret) {
> +		dev_err(mmc_dev(host->mmc),
> +			"%s: failed to enable clock: %d\n", __func__, ret);
> +		goto out_clk_put;
> +	}
> =20
> -	mxs_mmc_reset(host);
> +	ret =3D mxs_mmc_reset(host);
> +	if (ret) {
> +		dev_err(mmc_dev(host->mmc),
> +			"%s: failed to reset controller: %d\n", __func__, ret);
> +		goto out_clk_put;
> +	}

Why __func__ here? dev_err and the msg itself should be indication enough?

Otherwise

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--JBi0ZxuS5uaEhkUZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7eaQMACgkQD27XaX1/VRsmVQCgo5C27YH0V2JpiZdVCoLmhRk8
R0sAoKv1OoiKTNL/O5v9j3Pgi3rxLL/B
=3SQY
-----END PGP SIGNATURE-----

--JBi0ZxuS5uaEhkUZ--

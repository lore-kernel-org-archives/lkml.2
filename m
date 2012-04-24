Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab2DXOoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 10:44:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33390 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab2DXOoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 10:44:20 -0400
Date: Tue, 24 Apr 2012 16:44:07 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: m.szyprowski@samsung.com, ben-linux@fluff.org, thomas.abraham@linaro.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, kyungmin.park@samsung.com,
        broonie@opensource.wolfsonmicro.com,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] i2c-s3c2410: Rework device type handling
Message-ID: <20120424144407.GA9007@pengutronix.de>
References: <1335198241-19344-1-git-send-email-k.lewandowsk@samsung.com>
 <1335198241-19344-2-git-send-email-k.lewandowsk@samsung.com>
 <20120423182033.GB2767@pengutronix.de>
 <4F966711.7080608@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <4F966711.7080608@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 24, 2012 at 10:40:49AM +0200, Karol Lewandowski wrote:
> On 23.04.2012 20:20, Wolfram Sang wrote:
>=20
> Hi!
>=20
> >> -static inline int s3c24xx_i2c_is2440(struct s3c24xx_i2c *i2c)
> >> +static inline unsigned int s3c24xx_get_device_quirks(struct platform_=
device *pdev)
> >>  {
> >> -	struct platform_device *pdev =3D to_platform_device(i2c->dev);
> >> -	enum s3c24xx_i2c_type type;
> >> -
> >> -#ifdef CONFIG_OF
> >> -	if (i2c->dev->of_node)
> >> -		return of_device_is_compatible(i2c->dev->of_node,
> >> -				"samsung,s3c2440-i2c");
> >> -#endif
> >> +	if (pdev->dev.of_node) {
> >> +		const struct of_device_id *match;
> >> +		match =3D of_match_node(&s3c24xx_i2c_match, pdev->dev.of_node);
> >=20
> > I'd appreciate a comment explaining why match can't be NULL here (as to
> > my understanding, it can't). Or just check for it, but this way it looks
> > a bit fishy and people (hopefully ;)) will ask about it.
>=20
>=20
> My understanding is that it can't be null for exactly same reason why
> platform_get_device_id(pdev) can't be null either (see below).
>=20
> I.e. prerequisite for this code to be run at all (as it's called from
> driver's .probe()) is to be already matched against very same match
> table.

Yes, I agree. Yet, this is not obvious and people might try to fix it
(especially since programs like smatch report it as potentially
dangerous). Ah, whatever, I could simply apply the fix then :) OK.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+WvDcACgkQD27XaX1/VRtfRwCfWhhvxIvD1njgpI9TcTD9rkO6
u9YAoKTCSavc1yBC7fSYosfqcBM3L/DE
=sVaK
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--

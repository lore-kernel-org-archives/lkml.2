Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab2DRNq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:46:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39615 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab2DRNqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:46:55 -0400
Date: Wed, 18 Apr 2012 15:46:44 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Karol Lewandowski <k.lewandowsk@samsung.com>, ben-linux@fluff.org,
        thomas.abraham@linaro.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        kyungmin.park@samsung.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 3/3] i2c-s3c2410: Add HDMIPHY quirk for S3C2440
Message-ID: <20120418134644.GB19220@pengutronix.de>
References: <1332357113-2973-1-git-send-email-k.lewandowsk@samsung.com>
 <1332357113-2973-4-git-send-email-k.lewandowsk@samsung.com>
 <20120417174029.GC22406@pengutronix.de>
 <00dd01cd1d5c$57ce7f80$076b7e80$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b5gNqxB1S1yM7hjW"
Content-Disposition: inline
In-Reply-To: <00dd01cd1d5c$57ce7f80$076b7e80$%szyprowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b5gNqxB1S1yM7hjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > >  Optional properties:
> > > +  - gpios: The order of the gpios should be the following: <SDA, SCL=
>.
> > > +    The gpio specifier depends on the gpio controller. Required in a=
ll cases
> > > +    except when "samsung,i2c-no-gpio" is also specified.
> > > +  - samsung,i2c-no-gpio: input/output lines of the controller are
> > > +    permanently wired to the respective client, there are no gpio
> > > +    lines that need to be configured to enable this controller
> >=20
> > Can't we just skip this property...
>=20
> All standard s3c-24x0 i2c controllers require gpio lines for proper opera=
tion,
> so lack of the gpios property should be considered as an error. However t=
here
> is a special case of internal, embedded i2c controller which has no such =
gpio=20
> lines at all.
>=20
> > >    - samsung,i2c-slave-addr: Slave address in multi-master enviroment=
=2E If not
> > >      specified, default value is 0.
> > >    - samsung,i2c-max-bus-freq: Desired frequency in Hz of the bus. If=
 not
> > >      specified, the default value in Hz is 100000.
> > > +  - samsung,i2c-quirk-hdmiphy: Quirk for HDMI PHY block found on
> > > +    Exynos4 platform - reduce timeout and reset controller after each
> > > +    transfer
> >=20
> > ... and this one, if we declare a new compatible-entry for exynos4?
>=20
> It is not strictly related to Exynos4 SoCs. Exynos4 SoC has 8 standard s3=
c2440 style
> i2c controllers and one additional, internal controller for HDMIPHY, whic=
h needs=20
> some workarounds in the driver. Maybe the quirk should be named 'broken t=
imeout=20
> detection'

I was wondering since you do what I suggested for platform devices already:

+               .name           =3D "s3c2440-hdmiphy-i2c",
+               .driver_data    =3D QUIRK_S3C2440 | QUIRK_HDMIPHY | QUIRK_N=
O_GPIO,

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--b5gNqxB1S1yM7hjW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+OxcQACgkQD27XaX1/VRu4KwCgu1vgcMKKuwN5f0KINk3bpier
OPUAn3bMe8SobLi5a+rxq/07bMC0WSA3
=dA0t
-----END PGP SIGNATURE-----

--b5gNqxB1S1yM7hjW--

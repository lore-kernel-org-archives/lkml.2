Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab2DWKBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:01:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48151 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab2DWKBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:01:19 -0400
Date: Mon, 23 Apr 2012 12:01:06 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, ben-linux@fluff.org,
        thomas.abraham@linaro.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        kyungmin.park@samsung.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 3/3] i2c-s3c2410: Add HDMIPHY quirk for S3C2440
Message-ID: <20120423100106.GB19192@pengutronix.de>
References: <1332357113-2973-1-git-send-email-k.lewandowsk@samsung.com>
 <1332357113-2973-4-git-send-email-k.lewandowsk@samsung.com>
 <20120417174029.GC22406@pengutronix.de>
 <00dd01cd1d5c$57ce7f80$076b7e80$%szyprowski@samsung.com>
 <20120418134644.GB19220@pengutronix.de>
 <4F8EEC60.2080603@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
In-Reply-To: <4F8EEC60.2080603@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Karol,

> >>> ... and this one, if we declare a new compatible-entry for exynos4?
> >>
> >> It is not strictly related to Exynos4 SoCs. Exynos4 SoC has 8 standard=
 s3c2440 style
> >> i2c controllers and one additional, internal controller for HDMIPHY, w=
hich needs=20
> >> some workarounds in the driver. Maybe the quirk should be named 'broke=
n timeout=20
> >> detection'
> >=20
> > I was wondering since you do what I suggested for platform devices alre=
ady:
> >=20
> > +               .name           =3D "s3c2440-hdmiphy-i2c",
> > +               .driver_data    =3D QUIRK_S3C2440 | QUIRK_HDMIPHY | QUI=
RK_NO_GPIO,
>=20
>=20
> Here I've done it this way for compatibility with legacy driver and
> board(s).

Understood.

> Device tree is new interface, and I thought that it would be better
> to describe things explicitly and separately from device type.
>=20
> Right now these properties are used only on S3C2440, but I don't
> consider it highly unlikely to see these on S3C**** in future.

My experience also says that it easily can get even worse :(

> Tomasz had similar doubts when I've posted patch that checked these
> quirks only for S3C2440:
>=20
>   http://permalink.gmane.org/gmane.linux.drivers.i2c/10305
>=20
> Thus, I've chosen properties and not separate type.

I understand this reasoning. I still differ, though. Think about my
above example about things getting worse. Then, you'd need another
quirk-property for $FLAW. Later, $FLAW is still there, but the timeout
issue was fixed. That would mean, the poor device-tree making person has
to know which quirks to select for this version of the controller. Just
specifying that it is the HDMI-phy and not a regular I2C controller is
much more convenient, and the driver will figure the rest.

> It's easy to introduce compat string (see below), but given above
> I'm afraid that we might end up adding -hdmiphy- variant for every
> new version of i2c controller.

I'd be fine with that, given that the upcoming hdmiphy versions will not
need all the same set of quirk-flags. I think we want that "quirk lookup
table" fixed in the driver and not encoded in the device tree where
people could get it wrong. Also, the quirks are nothing a board maker
can select from; it is implicit as soons as you want the HDMIPHY on that
SoC, thus the compatible-entry should be enough of a description.

I am not the ultimate expert about bindings, though, and am open for
corrections (I feel kinda confident on this issue, though ;))

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+VKGIACgkQD27XaX1/VRs/3gCfaJYb7/C+CZeqJPVdH2tbSFk2
POQAoL60oVexMDsHMPZY/04TUAk4p9nU
=DI+t
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--

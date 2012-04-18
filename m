Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2DRNkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:40:03 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55784 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab2DRNj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:39:59 -0400
Date: Wed, 18 Apr 2012 15:39:45 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: ben-linux@fluff.org, m.szyprowski@samsung.com, thomas.abraham@linaro.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, kyungmin.park@samsung.com,
        broonie@opensource.wolfsonmicro.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 2/3] i2c-s3c2410: Rework device type handling
Message-ID: <20120418133945.GA19220@pengutronix.de>
References: <1332357113-2973-1-git-send-email-k.lewandowsk@samsung.com>
 <1332357113-2973-3-git-send-email-k.lewandowsk@samsung.com>
 <20120417173136.GB22406@pengutronix.de>
 <4F8EAB94.7080707@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <4F8EAB94.7080707@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> >> Reorganize driver a bit to better handle device tree-based systems:
> >>
> >>  - move machine type to driver's private structure instead of
> >>    quering platform device variants in runtime
> >>
> >>  - replace s3c24xx_i2c_type enum with unsigned int that holds
> >>    bitmask with revision-specific quirks
> >>
> >> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >=20
> > Okay, so this driver needs to the 'data' field from either
> > platform_device_id or of_device_id and implements a function for that,
> > namely s3c24xx_get_device_quirks(). Grant, Rob: I'd think there might be
> > more drivers in need of that, so maybe it makes sense to have a generic
> > of-helper function?

Please wait one or two days before resending. Maybe Grant or Rob find
some time to answer this question. (Yeah, we can fix it later if such a
generic function is introduced somewhen).

> >> -/* i2c controller state */
> >> +#ifdef CONFIG_OF
> >> +static const struct of_device_id s3c24xx_i2c_match[];
> >> +#endif
> >=20
> > Uh, forward declaration with #ifdef. I'd think we should get this simply
> > to the front.
>=20
>=20
> Ok, as I think it's better to have dt and non-dt definitions together
> I'll move both of_device_id and platform_device_id to the top.

Agreed.

>=20
> >> +/* Treat S3C2410 as baseline hardware, anything else is supported via=
 quirks */
> >> +#define QUIRK_S3C2440		(1 << 0)
> >=20
> > Minor: Is it really a quirk being s3c2440? Maybe FLAG_*, dunno.
>=20
>=20
> In first version[1] of this patch I've used TYPEs for device types
> and FLAGS for quirks. However, I've squashed these into "quirks" after
> discussion with Mark[2].
>=20
> [1] http://permalink.gmane.org/gmane.linux.kernel/1266759
> [2] http://permalink.gmane.org/gmane.linux.kernel.samsung-soc/10255

It's minor, keep the QUIRKs.

> [ I'll also drop above CONFIG_OF ifdef, as of_match_node() seem
>   to be always defined since v3.2-rc1. ]

Great.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+OxCEACgkQD27XaX1/VRsfBACgvFrE7I7yC075t+xwKUfaHfgr
wvUAn3raIeCytJJ3hQU3BZzR/y7Q/ua2
=fZFN
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab2KNIlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 03:41:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54609 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841Ab2KNIlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 03:41:15 -0500
Date: Wed, 14 Nov 2012 17:41:07 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kevin Liu <keyuan.liu@gmail.com>
Cc: m.szyprowski@samsung.com, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, lrg@ti.com,
        Philip Rakity <prakity@nvidia.com>
Subject: Re: FW: [PATCH v2] mmc: sdhci: apply voltage range check only for
 non-fixed regulators
Message-ID: <20121114084105.GG7407@opensource.wolfsonmicro.com>
References: <25B60CDC2F704E4E9D88FFD52780CB4C060FBEA29A@SC-VEXCH1.marvell.com>
 <CADz5_gLC=z_VYrNq8q3dU7L6im7shSz-Sn6Tzym2mRZONwpgUg@mail.gmail.com>
 <20121114072855.GF7407@opensource.wolfsonmicro.com>
 <CADz5_gLb5ZRHLZHw1sDDWzu4QgOR7JXnaRMEXxETNzVsu1Wq1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="doKZ0ri6bHmN2Q5y"
Content-Disposition: inline
In-Reply-To: <CADz5_gLb5ZRHLZHw1sDDWzu4QgOR7JXnaRMEXxETNzVsu1Wq1A@mail.gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--doKZ0ri6bHmN2Q5y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 14, 2012 at 04:36:28PM +0800, Kevin Liu wrote:
> 2012/11/14 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> > Should this be regulator_set_voltage_tol()?  Otherwise it'd be good to
> > explain where the numbers come from.

> In SD physical layer spec 3.01 chapter 6.6.1, the threshold level for
> voltage range is defined as below:
> Vdd(min) = 2.7V while Vdd(max) = 3.6V.
> The card should work within the voltage range.

> If you are afraid the voltage value is too aggressive, maybe we can
> use regulator_set_voltage_tol() to set a smaller range.
> But which range should be reasonable?

The above makes total sense - thanks!  I just wasn't aware that the
range was specified in this fashion in the spec.  Might be worth a
comment in the code if you need to respin.

--doKZ0ri6bHmN2Q5y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQo1jgAAoJELSic+t+oim9PwoP/Rv2byOmmi62M0yl3b8JacYe
1sIwcylvswPrkDr+NvB1u80xNnLCjlAZ8XMrFRgz/Q59zgD3kcTFinPsC9kLtfnt
wEkrfe95LyBCXrxjjKSiFQEJ2AWL4NyfjU5Ttar8q8PMbsXHp6fZHFeAlDtZRETs
YyaBrLSIvHzjUeBOK+t3xtWDNM3vFJ//bFsRsvG4Xlqpxy2gWQoMl3R3own5410u
e71PApAHIky5Lj6sO9L8JjKmyDl9Z+my1e9Z/aGVXiKTOs/Px4r8Ibd4+8aAgllb
Jh9tPu1FyqPm/QQEoubW0cocdJ01VK6jSVJtC6Wnm8KHWjO75+LdGEWTALtIuJi4
dpQpH4FW/+k8S71zKEMl8Xf5hWpGNj78qWFqrf02rHfN4OgAnW04Kl5hWO7j8Llp
OH83xAXyQcj1AtuL5iiei4FXpTY+XKJyeJQFILxrqtzmh11UbXQvDXgAAesPz8ca
dzB1/DtHWjdBaGwHB3OIO0kgpZc9GI6M5yCdLBD6YSM6MS9r4YocBb1rQEJwPam0
prV/+UCnEQ1jfxcY7hUIIW6D1LGDvTc+jFfYrs3or+wORWCRiZxB1kTvD7fL3XwB
FPIfBhO5BipMnIdGm5v2ko2v4FwB+QnzAMDomwtWiWOeilcPtaB68CTHeJyvIwCy
HAbMo4vfT7dw8cQzIL6y
=hOQH
-----END PGP SIGNATURE-----

--doKZ0ri6bHmN2Q5y--

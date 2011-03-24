Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab1CXNZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:25:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50437 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918Ab1CXNZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:25:06 -0400
Message-ID: <4D8B4623.4010709@pengutronix.de>
Date: Thu, 24 Mar 2011 14:24:51 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: davinci-linux-open-source@linux.davincidsp.com, sachi@mistralsolutions.com,
        Samuel Ortiz <sameo@linux.intel.com>, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org,
        Stalin Srinivasan <stalin.s@mistralsolutions.com>
Subject: Re: [PATCH v3 1/7] mfd: add pruss mfd driver.
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com> <1299592667-21367-2-git-send-email-subhasish@mistralsolutions.com> <4D776B05.4010506@pengutronix.de> <384BC720F8C741B886DC000F067EBA20@subhasishg>
In-Reply-To: <384BC720F8C741B886DC000F067EBA20@subhasishg>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig31577B91C27ABFC51DAE3F8A"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig31577B91C27ABFC51DAE3F8A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/24/2011 02:16 PM, Subhasish Ghosh wrote:
> Hello,
>=20
>> A device may be de-initialized and another loaded or two different
>> devices
>> can be run simultaneously on the two cores.
>> It's also possible, as in our case, to implement a single device on bo=
th
>> the PRU's resulting in improved load sharing.
>=20
>> Make you driver compile with sparse "make C=3D1", you cast way too muc=
h
>> when accessing io mem. Use void __iomem * instead of u32 *.
>=20
>=20
> With make C=3D1 I am receiving some warnings such as:
>=20
> warning: cast removes address space of expression
> drivers/mfd/da8xx_pru.c:61:17: warning: incorrect type in argument 1
> (different base types)
> drivers/mfd/da8xx_pru.c:61:17:    expected void const volatile [noderef=
]
> <asn:2>*<noident>
> drivers/mfd/da8xx_pru.c:61:17:    got int
> drivers/mfd/da8xx_pru.c:66:28: warning: incorrect type in argument 1
> (different address spaces)

(Re)read the warning carefully:

You have to fix drivers/mfd/da8xx_pru.c, the first argument should be
__void iomem *, not an int. Fix the type of the first argument. Don't
use any casts at all, follow all warnings, eventually you will have void
__iomem * (or struct * instead of void *) and no warnings.

> I can remove all of these by casting to (__force void  __iomem *) but i=
s
> this correct.

No evil casts, please :)

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig31577B91C27ABFC51DAE3F8A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk2LRiYACgkQjTAFq1RaXHNLuACdGLs2yJyWSFWKsS8vWvEDxdUi
DhIAnitT/3dVAxlZFlaMJOi8nWTTDrW3
=5Nqq
-----END PGP SIGNATURE-----

--------------enig31577B91C27ABFC51DAE3F8A--

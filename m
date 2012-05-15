Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab2EOLhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:37:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:13823 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757814Ab2EOLhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:37:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="144185906"
Message-ID: <1337082053.2528.182.camel@sauron.fi.intel.com>
Subject: Re: determining if a block erasure failed
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 15 May 2012 14:40:53 +0300
In-Reply-To: <alpine.DEB.2.00.1205150944550.17750@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205150944550.17750@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-wHcbzVME1qxCAF7Zz4/7"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wHcbzVME1qxCAF7Zz4/7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-15 at 09:53 +0200, Joel Reardon wrote:
> I want the caller of erase_worker() to be aware if the erase block became
> bad. Here is the relevant code at the end of erase_worker():
>=20
> /* at this time, the erase has failed. err =3D=3D -EIO */
>         ubi_msg("mark PEB %d as bad", pnum);
>         err =3D ubi_io_mark_bad(ubi, pnum);
>         if (err)
>                 goto out_ro;
>=20
> /* does other stuff, not touching err */
>=20
> /* err =3D=3D 0 here, because of above goto */
>         return err;
>=20
> out_ro:
>         ubi_ro_mode(ubi);
>         return err;
>=20
>=20
> So, if this function should return zero when the erase block fails, then =
I
> will add a "result" field to ubi_work that will store the result of the
> work function. But I figured I'd check first if the return err that alway=
s
> returns 0 is not an oversight and this function should return -EIO if it
> fails.

Why do you need the results?

--=20
Best Regards,
Artem Bityutskiy

--=-wHcbzVME1qxCAF7Zz4/7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPskDFAAoJECmIfjd9wqK016AQAI+ivy9LlcCpTlskcpavM2un
it/3nULP+UUxZWOzr8DiS3SfO//sEuPBlenZgPtwZ7qBn4WYdw9O3EWY7bunjTEJ
FSr3cIX6CseMBe6RSOsHqdpooNiMHJLN1pPv2QLKe2cX0vY55B/jPr5vzESWiBR1
B/qiz06qY0I+3AOtkylLQDprviCgjlLUVDc6lo5fzWA48mV5kwR3K17s0rg9mpNR
vJ8uWTt+z0CN/zVmX7KBMNimZW1FdVO4+7PwWmGwN27XrOGOyO/SEWR4cV+5Euu/
r4iGMmh9p7+Gxr7dbRciKVfe87p63gnVPZG88uDTokh4PJ3p6jVjQnhPkwocnxYq
+6MgS8MyG9mFvxr6ZexkIqI6Pi/YJFTypORG3pA5+JlIDLfhbnrXdVaKqWwb1KJx
ZSmtq0kBfz9i9IG4XpgsjE3hb8t17JOy/tl1QkAE82QUEY5UPxDvLR2/tk+TihQU
ddRmsCnqyJTkFync9onG4p247V0MZSB8FNKnvBx9EkCgqiq34l8gZkm/7CbQNbu+
RpHgFEIbJqZiHKgfJIQULBKfRuuGEnIkHxW4/aa8zg2VaEYDI/3aTGzpExnu1TC7
CA9XwD7/emgwOJVeX+zh/yN8wK7+zXh6eyVRo8J26wvXrHtbE/4HSEiHC6wqSLAl
eFQptQwf41H3TfeQBYiO
=0TYs
-----END PGP SIGNATURE-----

--=-wHcbzVME1qxCAF7Zz4/7--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab2GEBZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 21:25:09 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:36013 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab2GEBZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 21:25:06 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: size_t/ssize_t warnings (was: Re: Build regressions/improvements in v3.5-rc5)
Date: Wed, 4 Jul 2012 21:25:13 -0400
User-Agent: KMail/1.13.7 (Linux/3.4.4; KDE/4.6.5; x86_64; ; )
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        "Linux-Arch" <linux-arch@vger.kernel.org>, linux-cris-kernel@axis.com
References: <CAMuHMdVJTUF3r=MKzpkvj6y_xdVdw=zEgAy2_wm_hG94jdrhBA@mail.gmail.com>
In-Reply-To: <CAMuHMdVJTUF3r=MKzpkvj6y_xdVdw=zEgAy2_wm_hG94jdrhBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2082783.vk3JZMNMW3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201207042125.14680.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2082783.vk3JZMNMW3
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 04 July 2012 16:17:28 Geert Uytterhoeven wrote:
> On Wed, Jul 4, 2012 at 3:34 PM, Jan Kara <jack@suse.cz> wrote:
> >>   + fs/quota/quota_tree.c: warning: format '%zd' expects argument of
> >>   type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]:=
=20
> >>   =3D> 372:4 + fs/quota/quota_v2.c: warning: format '%zd' expects
> >>   argument of type 'signed size_t', but argument 5 has type 'ssize_t'
> >>   [-Wformat]:  =3D> 66:92
> >  =20
> >   These really look like false positives (there are quite a few of this
> >=20
> > kind). Can we possibly silence them?
>=20
> These 2 warnings happen on cris only, because size_t is unsigned int and
> ssize_t is (signed) long. They go away if I make ssize_t int.
>=20
> I had a look at the various definitions of size_t and ssize_t:
>=20
>                         __kernel_size_t                       =20
> __kernel_ssize_t ---------------                         ----------------
>=20
> generic 32-bit:         unsigned int                            int
> generic 64-bit:         __kernel_ulong_t (unsigned long)
> __kernel_long_t (long)
>=20
> Exceptions:
>=20
> avr32:                  unsigned long                           long
> blackfin:               unsigned long                           long
> cris:                   __SIZE_TYPE__ (unsigned int)            long
> mn10300/__GNUC__ =3D=3D 4:  unsigned int                            signe=
d int
> mn10300/__GNUC__ !=3D 4:  unsigned long                           signed =
long
> s390 (32-bit):          unsigned long                           int
> x32:                    __kernel_ulong_t (unsigned long long)
> __kernel_long_t (long long)
>=20
> On cris, I get the warning if ssize_t !=3D int.
> Whether size_t is unsigned int or unsigned long doesn't matter.
> So it's not just a mismatch between int and long.
>=20
> I also tried blackfin, which has matching unsigned long/long, and it
> doesn't give the warning. Presumably the toolchain has size_t hardcoded to
> long for printf-style format checking?

well, every gcc arch has to declare a type for size_t.  on Blackfin, we pic=
ked:
gcc/config/bfin/bfin.h:/* what is the 'type' of size_t */
gcc/config/bfin/bfin.h-#define SIZE_TYPE "long unsigned int"

grep shows that many other arches do the same
=2Dmike

--nextPart2082783.vk3JZMNMW3
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJP9Oz6AAoJEEFjO5/oN/WBkXsP/j8vqhTROh4Pagcdk9vKLhiH
SVm2fT0nzTmSRdxN2ehRydAmAyK6fooSPkSj6/hk9wCdPCbJAhj/D9wIXu2LaqHT
bxGSNaLXAKwVvx0eHfp/0XBtV3H1/X9TpBrtYYQ2UBSvWxQS/01hR7bL5USjwKZB
BO/s4IkuhKYe2K+2YR6T4LFe8OuDxzkwl68pUuQ8nbkM/FyW6BLyOuDiQqjkRyOu
GkBGE2HAZW2LmSd0oGYCboVvCO8E8r3LB96d1BHML03CzWbnyy6RyGrALF3Lg6Yb
DFEKlSLK6YOYWP5R0Z3i4Bxn55KGBuczYOE0uezW5G/iPiw++OIb6wogeqNcGKql
niRsbTIKKVPUXPHGmP5tHyHNCaDERctLHGXeVZUlYazBMwKX69FLiCD7uazBkBT2
nYP8KR4cQ5f8njTFKk18dgUOa8ETTBR781Ak4qHRtmBBKH3B3l/1JXS+EBR3vNv3
VHX6WQuJk66i1omYBmo7wZMUf9Sp1efZ34Qq1D2ZjYVaBz3Q+w6KsxMMfkXpEGhS
zFN2r2dbnEVKHNYXbGsxn/me86OhzpBKkthJ3oAuXi1rn3aUAN8TcSqFGUUE0de7
juKzvk7VJzX2doMfkXWJbaxltqWIhAAigOL4u33v+QunJWkN/e14HaAj68ooeX8S
wGWOIuncc+xVb0JXmFQR
=ALSI
-----END PGP SIGNATURE-----

--nextPart2082783.vk3JZMNMW3--

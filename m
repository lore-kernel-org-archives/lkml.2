Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab1CQC5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 22:57:15 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39931 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab1CQC5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 22:57:13 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: X32 psABI status update
Date: Wed, 16 Mar 2011 22:57:08 -0400
User-Agent: KMail/1.13.6 (Linux/2.6.37.3; KDE/4.6.0; x86_64; ; )
Cc: libc-alpha@sourceware.org, GCC Development <gcc@gcc.gnu.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com> <201103160124.42939.vapier@gentoo.org> <AANLkTim4w7zBBnsu+A1TMtb-wv60urDiSk5T0qbg7Oze@mail.gmail.com>
In-Reply-To: <AANLkTim4w7zBBnsu+A1TMtb-wv60urDiSk5T0qbg7Oze@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5282379.5kBbCvHj28";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201103162257.10440.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5282379.5kBbCvHj28
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wednesday, March 16, 2011 08:39:57 H.J. Lu wrote:
> On Tue, Mar 15, 2011 at 10:24 PM, Mike Frysinger wrote:
> > so we get back to my original e-mail:
> >        are you getting a unique host tuple for this ?  or are you
> > extending x86_64-linux-gnu ?  so the only way of knowing which ABI is to
> > check for the output of the compiler+compiler flags ?
>=20
> As I said, the target is x86_64- linux-gnu and you just add -mx32 to
> CFLAGS. The x86_64- linux-gnu binutils and GCC support  x32.

ok, took long enough, but that answers most things.  your usage of "x32-"=20
prefixed binaries in the documentation seems to imply a lot more than the f=
act=20
you just picked those locally to avoid system collisions.  this isnt a wiki=
=20
page, otherwise i'd clean things up for you.

in looking at the gcc files, it doesnt seem like there's any defines setup =
to=20
declare x32 directly.  instead, you'd have to do something like:
#ifdef __x86_64__
# if __SIZEOF_LONG__ =3D=3D 8
/* x86_64 */
# else
/* x32 */
# endif
#endif

any plans on adding an __x32__ (or whatever) cpp symbol to keep people from=
=20
coming up with their own special/broken crap ?  or are there some already t=
hat=20
i'm not seeing ?
=2Dmike

--nextPart5282379.5kBbCvHj28
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJNgXiGAAoJEEFjO5/oN/WBT4wP/2Ohc06NfWngBqGywlbyJRzn
cPn8sJ4tCClDjhRMwDBwaW0U5kN5zN8ByFcvGKrT6pFtG5SW0XSSz4qvdwX4HyZO
Zd4uGpDQiYir6Kc3jJ+TNPdpGCmIhmp9CU9NI+u6V8KuLH7NjktkPPQVp6AIXcx8
1Yf0/IZYd0w3I+27swd24HNX5/WgrR+EaI9mAmVumtmtB8BSf21mZKalOrxHaJVl
m5t/UvAHVfNgHf62uLk68Lz09vDjGDtuMc4NnEUO8kypPt3JasUH2GsLsIIg9Sw+
fW86XOBnajLz8bzG+W6aVDt9ntD8bA9fjf7CfP3HIXRUTfnYw+T9of/DrogJp8h6
QxImfitHCrm3D4qltqnV6G8Vol5+2rOVrL5PlbhAbq5k83B+B6ptCGwg5+aNteVD
V8+noFI4MOXDM1FVIW5SbQS8XizPMFAtLMMmaBrjehNrLeIg1DhUkxZ7j1es9e9Y
5kfUaQ5Oe3ZjXHMa0Dw4MU54S5ojN/07ruZ7xXA53C1Jm9nOVqg5bAcBYQSRbBt6
tKzmzqMtVxY+r3dIVDyRPJ/yOeuxd3noxymW3w2r7VghD06zDKJfXVYzLlpZzeTN
zaYLOqy1Dh9RZJ6LhE2HALPPNNxgFIepvixJtcC3vCyT8iJruIhPDzE+i/z7Fhsh
Rp0VnlRJgPhZ0z+TzFE+
=wkkI
-----END PGP SIGNATURE-----

--nextPart5282379.5kBbCvHj28--

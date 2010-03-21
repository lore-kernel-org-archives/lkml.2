Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab0CUTZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 15:25:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52052 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab0CUTZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 15:25:46 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-pci@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-s390@vger.kernel.org,
       linux-sh@vger.kernel.org
In-Reply-To: <87y6hlebik.fsf@basil.nowhere.org>
References: <1269126097.18314.111.camel@localhost>
	 <1269126340.18314.115.camel@localhost>  <87y6hlebik.fsf@basil.nowhere.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-aTG0+FBLZ4wAKesqS+5r"
Date: Sun, 21 Mar 2010 19:25:21 +0000
Message-ID: <1269199521.18314.220.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 2/4] panic: Allow taint flag for warnings to be changed
 from TAINT_WARN
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aTG0+FBLZ4wAKesqS+5r
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-03-21 at 20:10 +0100, Andi Kleen wrote:
> Ben Hutchings <ben@decadent.org.uk> writes:
>=20
> > WARN() is used in some places to report firmware or hardware bugs that
> > are then worked-around.  These bugs do not affect the stability of the
> > kernel and should not set the usual TAINT_WARN flag.  To allow for
> > this, add WARN_TAINT() and WARN_TAINT_ONCE() macros that take a taint
> > flag as argument.
> >
> > Architectures that implement warnings using trap instructions instead
> > of calls to warn_slowpath_*() must now implement __WARN_TAINT(taint)
> > instead of __WARN().
>=20
> I guess this should enforce that at least some taint flag is set?
> (e.g. with a BUILD_BUG_ON)

I'm being a bit sloppy with the wording here.  The TAINT_* macros are
actually bit numbers, not flags.  I could define a TAINT_MAX and add:

	BUILD_BUG_ON(taint < 0 || taint > TAINT_MAX);

Not sure that that's really worth doing though.

Ben.

--=20
Ben Hutchings
If you seem to know what you are doing, you'll be given more to do.

--=-aTG0+FBLZ4wAKesqS+5r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS6Zym+e/yOyVhhEJAQIoiA/+PtVtlFPVa6k50dvxo4ESDxteBVZfWXQZ
eu2QKBNWV9+YyonKYEkmD+HykXOT9+c8P5KthlGXPKiwTAbR1BE8tkaKOvI6WGUo
kK00Ie8kyIel99IKPaOsxSHQmda6pybUv+shIlx5zd1Ep9b9kDNflILNVLB8Xb/G
py0gRfbX1Oru49CAk5vHnCV3PpnmhdG9U94Y+agCdqXRlFGUHcRDeCkbHXxvmdBJ
eSTXqrD9YXwuJCk/vuJc+Zz1oxaKGu5RCK3ztRBD2afF41NB1KOy+zCv/hTEPHLl
OoKeV9vQG8wVtFGe5nDXTy2tGnZZI9O3W/jssnfzcyDf/DPX164fiQwMHSDfP0lB
Vzqtl/9/xOi8jZ7pDLz/4QtZfMr8/25cmWzuzazuqQTHKa5Gvl1On0LEA9e7uXqN
5u9VVK0sYNS2+zyM+JveFarY7+PMpeOZL1xeudD/fBDau9tUHkRywwlFt3HzVKDn
wwIuNWASR2taYgEGUT0ULyaM6judARKvHpwg8ger3WFc1l1r3jb6CgGoyqxWuOCA
OA7x9706CSvkFZ8ZKufUDqbORXtQWaGltGcGEvhOW6VygnW5oSivaYQ5OFAVPZOg
eVqjJMaR7lwW8geSX8fA2ht/h+u6SbtQmyOPsTdGXQmwXZhsiD5zhNDSVYusWNFw
WTzNxKHMvxU=
=2sqx
-----END PGP SIGNATURE-----

--=-aTG0+FBLZ4wAKesqS+5r--

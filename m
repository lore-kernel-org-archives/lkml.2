Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab2EGDzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 23:55:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52454 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab2EGDze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 23:55:34 -0400
Date: Mon, 7 May 2012 13:55:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pierre Carrier <pierre@spotify.com>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] lib/vsprintf.c: "%#o",0 becomes '0' instead of '00'
Message-Id: <20120507135523.59bcc702ac15348c237fc2fd@canb.auug.org.au>
In-Reply-To: <CAPXGRDkgEKFU7fVDqz33C9vqjdxmBYTbPEPbcfhpkg0NxOJz-g@mail.gmail.com>
References: <20120507101949.e18a8f3e222b178eeb699cf6@canb.auug.org.au>
	<1336353614-7944-1-git-send-email-pierre@spotify.com>
	<1336355974.8617.6.camel@joe2Laptop>
	<CAPXGRDkgEKFU7fVDqz33C9vqjdxmBYTbPEPbcfhpkg0NxOJz-g@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_May_2012_13_55_23_+1000_01PRo63E=Dur7Fer"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_May_2012_13_55_23_+1000_01PRo63E=Dur7Fer
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pierre,

On Mon, 7 May 2012 04:20:18 +0200 Pierre Carrier <pierre@spotify.com> wrote:
>
> On Mon, May 7, 2012 at 3:59 AM, Joe Perches <joe@perches.com> wrote:
> > If you do this, why not change 0-7 instead of just 0?
>=20
> Consistency with POSIX *printf.
>=20
> "#: Specifies that the value is to be converted to an alternative
> form. For o conversion, it increases the precision (if necessary) to
> force the first digit of the result to be zero."
> -- http://pubs.opengroup.org/onlinepubs/009695399/functions/printf.html
>=20
> % cat octal.c;gcc -o octal octal.c;./octal
> #include <stdio.h>
> void main() {
>         int i;
>         for (i=3D0;i<10;i++) printf("%#o ", i);
>         puts("");
> }
> 0 01 02 03 04 05 06 07 010 011

Yes, if we are going to follow anything, then it may as well be that.

However just to add more mess, the next part of that section of the standar=
d says:

"For x or X conversion specifiers, a non-zero result shall have 0x (or
0X) prefixed to it."

so we should also do:

0 0x1 ...

However, I think we expect 0x0, so changing it is, I think, unnecessary.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_May_2012_13_55_23_+1000_01PRo63E=Dur7Fer
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPp0esAAoJEECxmPOUX5FEgI4P+gM/e8+Eje3Ihak0s0c5lrrg
aFHmXXFS8u6+kI+xwKnFnzV3mcQZbwfuBexjdcMnfc6cllKmgzpya0tBaFtdPM+g
5VfVl7PCbS2pFMFL3fYr0Cb9lttm7bwaaIhpzFg3BUfx4UGqfRGKGmmRZe7OFfl2
h/+GEh0yr4md1OMnYrKNPvkfZLkSSpz5rI29+FBxzwZuZ/VE/Osdcr2FzNP7sph9
W00ta1GnqmD1u1skOWSEst3WIKDuNRYGDGVInC6NdKhXig+nfErs4TX0L2rRB+Xf
r5Suz/X0sHUPjexC4Au1zy/Kk5nTyKpzc5+NGHPOplKrHO59lJ0i28YhiF0nKzJe
107XhJseKmky2Hp+3TOJ7+KHLV9PxQzMHOxDf5uYv87Yciu4TtEjYqsaw9uapw96
SizfBTdiMVrIIfv1UyAqw25YJzADVIjLXhcIUjQ3Om1BJ/crSY/3nH95Obct9z/8
u6gVR8LlQbPjvku+o9lkx9DFfTbMiPCmjrj4RbPLiV2+NtgOgT2r63u8xT/DJyMj
VlawlOnHssTdQ7T6DmMoT6BYf8L0HcCw+QwKt0O04awaRUJONuvshj+t4kbhruEf
LwqtUfDdOq2HhqeSwVQQZxawD9Yc9DAYh3u0ZIqUFOWTiHO8Rxord26wWcy0RevY
pT+TJLCtZ+eW6mz+iGpB
=V1kE
-----END PGP SIGNATURE-----

--Signature=_Mon__7_May_2012_13_55_23_+1000_01PRo63E=Dur7Fer--

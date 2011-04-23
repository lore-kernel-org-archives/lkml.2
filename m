Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab1DWAQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 20:16:42 -0400
Received: from csamuel.org ([74.50.50.137]:46623 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016Ab1DWAQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 20:16:41 -0400
From: Chris Samuel <chris@csamuel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad Pentium Pro system
Date: Sat, 23 Apr 2011 10:16:18 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <201104222333.25546.chris@csamuel.org> <20110422173422.46134f20@lxorguk.ukuu.org.uk>
In-Reply-To: <20110422173422.46134f20@lxorguk.ukuu.org.uk>
X-Face: Wcb;^Ll1x`\6);#5&v=2":47)c~M=K)9_=0mp[Ob~p==:85h/k)fj6nBf@^SdaXtmdYGRq
	[>N&^2m#i\v9ZHe:G-e=OR}-sEf`CdEL2/\).SeCBSC"Cn[(:./c*I|/3KCDO$<{n8m;X_
	g\Y9LQ=v/b5`)L,WOQdI*?SqUCgiw/9`KxgdU5;z8L.3)F!1M3=w:i9MsWp&v;%usOXL;w
	6kF?wAZjss.+y(78'qBu";bx]>"2dZd/S$^K)nU^N0HM\^^;s#q
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1531560.jZSmrLU9EB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201104231016.23579.chris@csamuel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1531560.jZSmrLU9EB
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Syt mae Alan! ;-)

On Sat, 23 Apr 2011 02:34:22 AM Alan Cox wrote:

> earlyprintk=3Dvga

Ahh, that's a new one on me, and it reveals that the kernel
has gone from 2.6.18 detecting:

256MB LOWMEM available.

to 2.6.39-rc4 detecting:

16MB LOWMEM available.

That would explain an awful lot..

> (or better yet earlyprintk=3DttyS0 and a serial port)

Hmm, I might still have a null modem cable hanging around..

> There are a couple of PPro funnies - there's an area of memory that
> must be excluded due to a chip errata and I seem to remember some
> PPro boxes also having slightly quirking E820 (BIOS memory
> reporting behaviour)

Sigh, that's just reminded me that a couple of years ago I
had a private discussion with H. Peter Anvin about 2.6.25
panic'ing on boot with:

initrd extends beyond end of memory (0x0ffef173 > ox01000000)

He gave me a modified syslinux to dump out memory information
and it reported:

INT 15h =3D f000:f859 DOS RAM: 638K (0x9f800) INT 12h: 638K (0x9f800)
INT 15 88: 0x3c00 (15360K) INT 15 E801: 0x0000 (0K) 0x0000 (0K)

He responded with:

# Right... you have a system dependent on E801, and somehow E801
# returns crap.
#
# I'm going to cook up a modified meminfo.c32 for you and see if
# we can't track this down.

Unfortunately nothing happened and when I prodded him it turned
out he'd been too busy, so I just kept on running old kernels
from that point on and completely forgot about why. :-(

Hope life is still good in Abertawe!

Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1531560.jZSmrLU9EB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATbIaUo1yjaOTJg85AQJpJggAtMkLRdwvwjZjpUCQX2iqm2WIPN9ALILi
W9j7zm9tF9GHsy8DdetnYojrriHf7slzDvj0j5jXGM0oASQoRGmMG2cX7NZ21cNz
Um1cRR+SxiwDaUuo8XfZuWKxDSzGdAJhk1u1J5E9VJmOWhVs1fPmXnFTb21zUHXV
KRLLrYxZ6w/nf4Ub12SY+sQGqldedHCeb0TTVplzIikU2JivBl6VpCU2ZMajtQ1g
katYBtA4wD30dUkJaL5ziJtf/rtYYZpkSDe2iapOPjhEzIYZ1llIX3IlsAmocTNG
Zt4CvOYIfe5r5YhBgp5SgXfbscYJvYYnKgegvCHh5xfoGSOMF80z0w==
=frIZ
-----END PGP SIGNATURE-----

--nextPart1531560.jZSmrLU9EB--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab1KTXKd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 18:10:33 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:45104 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133Ab1KTXKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 18:10:32 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: David Daney <ddaney.cavm@gmail.com>
Subject: Re: [PATCH RFC 0/5] Speed booting by sorting exception tables at build time.
Date: Sun, 20 Nov 2011 18:10:29 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.1; KDE/4.6.5; x86_64; ; )
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-embedded@vger.kernel.org, x86@kernel.org,
        David Daney <david.daney@cavium.com>
References: <1321645068-20475-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1321645068-20475-1-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1765674.i1izCIRxU1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111201810.31468.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1765674.i1izCIRxU1
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 18 November 2011 14:37:43 David Daney wrote:
> I noticed when booting MIPS64 kernels that sorting of the main
> __ex_table was taking a long time (2,692,220 cycles or 3.3 mS at
> 800MHz to be exact).  That is not too bad for real silicon
> implementations, but when running on a slow simulator, it can be
> significant.

i've seen this perf hit in my simulation runs too

> Here is more or less what I did:
>=20
> o A flag word is added to the kernel to indicate that the __ex_table
>   is already sorted.  sort_main_extable() checks this and if it is
>   clear, returns without doing the sort.
>=20
> o I shamelessly stole code from recordmcount and created a new build
>   time helper program 'sortextable'.  This is run on the final vmlinux
>   image, it sorts the table, and then clears the flag word.
>=20
> Potential areas for improvement:
>=20
> o Sort module exception tables too.
>=20
> o Get rit of the flag word, and assume that if an architecture supports
>   build time sorting, that it must have been done.
>=20
> o Add support for architectures other than MIPS and x86

i don't see much here that is arch-specific.  why have a knob at all ?  let=
's=20
just jump in with both feet and do this for everyone :).
=2Dmike

--nextPart1765674.i1izCIRxU1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOyYjnAAoJEEFjO5/oN/WBan8QAIDOerOF9p6aDqIjEulUa07s
p1gy5dR6Eklvo3vIJNtp8pPYMv4AEfbRc58NnQQXdMg8bdrxCvXgauITtKKE5tLi
CJwc7nEYSl3khG3zys2xT49bg7Y+yrMXcwFd6aU2g1vM7IkZu/GKlMgFCRTneRXo
eayd9qk/DArh/MOPS9X1cWJr4bfdje7Dwl8RtG92IJqUwGhQxDwTp9Keimh4IPfQ
cByx6OkFaDlec797DZQCN77sGYcqMllnc0Mv8g2CiZa93yNAZpZAsEge12kG+2Rl
mf2dSDitdBTmsGPyyaCugaLbG1Imy0XWn1wtBY04gCPn9mrO6mXbv4FcPo4tnjIU
sR15xxuCiVGd6DkOnRXKxplMdGE1cNBVOFdoDMHAB7qs3F9Qp3XVCwWr7mGocYGf
6IuhEDXhInN0rmpY+NeS3YFpRsUGj3W6GaSsi8z5EwQz7jpmuX/1KR+2W1Dee2p9
bcowwKKJgk2Xuav1ZvyjbduGDn0svh4Y4gf8SuGq/AVK0wkmZ//m5/x4PF4ej4PC
BYdpU3tiEHQ80q59wX/94KGtdywPbYmM1mlDeh4Uhf7Hx+ICpg++hNhTc4vH8FkL
yM/JcsU3KAnoTyFqu+KTLzD08lJmdEOdY9tMRFou+dswLBV+TtMKs6lzikBU+8dz
znqgG33O6P618SyNqHNm
=Scc4
-----END PGP SIGNATURE-----

--nextPart1765674.i1izCIRxU1--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab0I1Qn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 12:43:27 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:33150 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955Ab0I1Qn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 12:43:26 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: libc-ports@sourceware.org
Subject: Re: asm-generic/unistd.h and glibc use of NR_ipc
Date: Tue, 28 Sep 2010 12:42:54 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35.4; KDE/4.5.1; x86_64; ; )
Cc: Chris Metcalf <cmetcalf@tilera.com>, Arnd Bergmann <arnd@arndb.de>,
        linasvepstas@gmail.com, GLIBC Devel <libc-alpha@sourceware.org>,
        linux-kernel@vger.kernel.org
References: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com> <201009281040.09728.arnd@arndb.de> <4CA1E809.5010103@tilera.com>
In-Reply-To: <4CA1E809.5010103@tilera.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3924477.dOEpMKBaFh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009281242.57006.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3924477.dOEpMKBaFh
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday, September 28, 2010 09:05:13 Chris Metcalf wrote:
> On 9/28/2010 4:40 AM, Arnd Bergmann wrote:
> > Chris Metcalf is using the generic unistd.h file on the tile architectu=
re
> > and has a glibc port that should be easily portable to all future
> > architectures. There are a few of them getting ready to be merged
> > now (c6x, lm32, nios2, and some people have contacted me privately
> > for architectures I cannot name).

c6x lacks a MMU, so i dont see how it could possibly use glibc.  same for=20
lm32.  nios2 at least has an optional MMU, so it'd be usable some of the ti=
me. =20
so no, i dont see a generic unistd.h glibc port being useful for them.

> One question for the libc folks is nomenclature.  For now I'm using
> "sysdeps/unix/sysv/linux/generic" to hold the sources that are meant to be
> used for any architecture that uses Arnd's <asm-generic/unistd.h> along
> with the other asm-generic headers, e.g. <asm-generic/stat.h>.   I've
> appended a list of the files that I've put in that directory to this
> email.  Many of them are there just for handling missing "standard"
> syscalls in <asm-generic/unistd.h>; for example the "readlink" syscall
> becomes "readlinkat" in dl-origin.c, etc.
>=20
> Is this the best name to use for the directory, though?  In particular,
> glibc already uses "sysdeps/generic" in a slightly special sense to provi=
de
> the fallback if no sysdeps override is available for a given file.  But t=
he
> Linux naming of "generic unistd.h" is pretty commonplace, so I assume that
> in the "linux/" hierarchy it is reasonably clear what that subdirectory
> means.

i think "generic" in the context of "linux" is ok, but about the only real=
=20
answer you'd get is if it comes from drepper/roland.
=2Dmike

--nextPart3924477.dOEpMKBaFh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQIcBAABAgAGBQJMohsQAAoJEEFjO5/oN/WBOEUP/R++c0h3eS4bhQW7X7CXHLwe
DYLxcagnijuXP7We0zecN42T23/uUi7jnAKXLgpXGPGxraFqIpkyhNGBcz8WcOmN
G0IHwjTAS3P5YGpwZcECC58mFfYziDeDBT+haTG4zkrvdB4jbKQkcYO86Trm2mWx
InLUJwVQFvY77PAOdlWFKRvVUC85XiwkPfnLhdvqMHsMDFs1TcbKVNboBM1j4Aoa
99aApYgWfTPJ7rrwGsG6HwPidr0rPKNa1NEpv33FaHXe2sD75o3F0QkYnxSa4h5g
1At2/RT9I6H5Pw9rbRLPzuv3cR3nNAWL9tRRp9sa5SQym3PdLp95NEiyeuwVVMb1
VI9HmFHt4/y8g4X1g3bDSg8b5xii1ibvTf5DiLDZV1JfBDB5WTMZY67kkh8SJcGY
SBLwtKjg8XL2iMFTvcQz0tdEwBuhwfIf+3eOlNS37PPrdRTlW/ZcxlLhrjOUvkZc
Aof9H1nLPUvuHmGaFqBsEQMLvtnJH0lfhFV8oXApsF7Pe7AglIpOjrnRR2x+JT8C
2S1j6V1Hl8re770Mw8He+urAmsN8l3A4IhhMwyiQ4H63mhUFK1sUQYlFs8JX4r7l
34ee693IPoQr1PhsLSEywNMP6SPpTxyprgDZXbefDZ7hfG0IF9bP92vFDR3BOUYz
abATHdV2tY1F+POS4SUj
=clmc
-----END PGP SIGNATURE-----

--nextPart3924477.dOEpMKBaFh--

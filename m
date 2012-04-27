Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab2D0XYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:24:19 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48870 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574Ab2D0XYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:24:18 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] asm-generic: io: remove {read,write} string functions
Date: Fri, 27 Apr 2012 19:26:11 -0400
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc1; KDE/4.6.5; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
References: <1335523376-14695-1-git-send-email-will.deacon@arm.com> <4F9ADD22.70003@zytor.com> <201204272052.34489.arnd@arndb.de>
In-Reply-To: <201204272052.34489.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1414056.aDHJfJLrhy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201204271926.14872.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1414056.aDHJfJLrhy
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Friday 27 April 2012 16:52:34 Arnd Bergmann wrote:
> On Friday 27 April 2012, H. Peter Anvin wrote:
> > On 04/27/2012 10:14 AM, Will Deacon wrote:
> > > If you remove the architecture-specific drivers, there's really not a
> > > lot left and, even then, we only need to convert those drivers which
> > > are intended to be portable between architectures where the string
> > > functions are not consistently available.
> > >=20
> > > By overheads, I assume you're referring to the IO_COND check on the
> > > address space? I wouldn't expect this to be noticeable compared to the
> > > cost of the I/O access and I'm not sure it's worth worrying about for
> > > the sake of the small number of drivers affected.
> >=20
> > It's not in time, but it adds bulk to the code.  The point is that what
> > is the benefit of not making these part of the general API?  For
> > architectures where the address space doesn't matter they could just
> > alias it to the same functions, or use the generic versions.
>=20
> The main reasons I can see for not making it a general purpose API are:
>=20
> * It's a very confusing interface, because the endianess rules are
> different from the non-string variants and counterintuitive.
>=20
> * Almost all the users are ancient ARM specific drivers, the others are
>   either new ARM specific drivers or drivers that started out as ARM-only
>   and were ported later to other architectures (sh, avr32, mips, mn10300
>   and blackfin)
>=20
> * On all these architectures, the PCI I/O space is memory mapped (or
>   non-existent), so the ioread* functions are trivial wrappers without
>   additional overhead.
>=20
> * Most architectures don't implement them today, but all architectures
>   that support MMIO also implement the ioread string operations.

i'm ambivalent with keeping or tossing these funcs.  Blackfin (afaik) picke=
d=20
them up really only for the reasons Arnd cited -- drivers using memory mapp=
ed=20
registers originally for ARM (or m68k/coldfire i think) used this API, and =
it=20
was easier for us to implement these defines in our asm/io.h and get the=20
drivers "for free".

i am strongly in favor though of agreeing on & documenting the baseline API=
=20
first before attempting to clean anything up.  sorry to keep harping on thi=
s.
=2Dmike

--nextPart1414056.aDHJfJLrhy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPmysVAAoJEEFjO5/oN/WB6MYP/177ggREDUlQ0oZ4c+xYZKu3
euqCS8T7j1eXsIZwsqD/DmLXUfT1MTD0L4s2HCl2RXn6WP9/gJXr1DYQRMOhh3wp
a3IPqc6yAIRMdJe2YBzkDuXTP/1eBnXtrVKf7s2GCntveQs1yyITk6IiPgLsqpV2
Mv7cQqymvKDuzcggBUm76aL4u7bQ5hjnfuoFEGGMFYdK1449bQSqRaKsoPbhhyr7
n59XWjnLJ+HZN7dmxoyUJXrBh9cZ7Gd4SInkC6RgoIHHVKiPzngiPzaMpI1xMqJS
hTAn5Cpqjd2VwMpEjYy37PRt32tyNfmPoT/WNeTofwXBhUhQ/xqel7zd7rtdTGGN
UnX5b94qPleaNfP9odHSm73GtUGotnUrBSYwhA3jYAIMqHYNA18YpVBVScTqYTdv
6QYiu7zYNEq6DRz6eDLIVxfc8hhtguMdofV+BfREnk+pEIh1ey98BnmmAobNgylI
CqS96DE5HoMCgNdwdxZwDbuH1dBROj3XYC59kVsSh7ClKOMkLEUJKBT2WRd8Wf8B
XKiQBJGMxPJidItN+HWxt7yxLAhAlrfjeobG4oLVM5VS4qxeLiKRPnDzRwXqsEgI
CMgINjb3s09q1fjPv749z29XJA2QV99A4NsbC6XLxUVoOpuHvV+bCqbPUDeOTIjw
sAe/8J6P3Z3Fai0J29Mt
=4P1Q
-----END PGP SIGNATURE-----

--nextPart1414056.aDHJfJLrhy--

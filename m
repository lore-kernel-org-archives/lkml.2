Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab2BXQTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:19:47 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:34251 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755942Ab2BXQTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:19:45 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] [PATCH] asm-generic/unistd.h: handle symbol prefixes in cond_syscall
Date: Fri, 24 Feb 2012 11:19:42 -0500
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: James Hogan <james.hogan@imgtec.com>, linux-arch@vger.kernel.org,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4F47981F.4020305@imgtec.com> <201202241424.07319.arnd@arndb.de>
In-Reply-To: <201202241424.07319.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart15680091.6DaiNokvTq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201202241119.44480.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart15680091.6DaiNokvTq
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Friday 24 February 2012 09:24:07 Arnd Bergmann wrote:
> On Friday 24 February 2012, James Hogan wrote:
> > Some architectures have symbol prefixes and set CONFIG_SYMBOL_PREFIX,
> > but this wasn't taken into account by the generic cond_syscall. It's
> > easy enough to fix in a generic fashion, so add the symbol prefix to
> > symbol names in cond_syscall when CONFIG_SYMBOL_PREFIX is set.
> >=20
> >  include/asm-generic/unistd.h |    9 ++++++++-
> >  1 files changed, 8 insertions(+), 1 deletions(-)
> >=20
> > --- a/include/asm-generic/unistd.h
> > +++ b/include/asm-generic/unistd.h
> > =20
> >  #ifndef cond_syscall
> > -#define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x
> > ",sys_ni_syscall")
> > +#ifdef CONFIG_SYMBOL_PREFIX
> > +#define __SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
> > +#else
> > +#define __SYMBOL_PREFIX
> > +#endif
> > +#define cond_syscall(x) asm(".weak\t" __SYMBOL_PREFIX #x "\n\t" \
> > +                           ".set\t" __SYMBOL_PREFIX #x "," \
> > +                           __SYMBOL_PREFIX "sys_ni_syscall")
> >=20
> >  #endif
>=20
> Our trend is to move away from arch specific Kconfig symbols and
> __ARCH_HAS_* macros towards just defining whatever you need in the
> architecture as an override for the generic definition.

i don't see how __ARCH_HAS_xxx would help here.  the symbol prefix is a str=
ing,=20
not a bool value.  it's also already used by linux/export.h, asm-
generic/vmlinux.lds.h, and module code in scripts/.

> Just provide your own unistd.h that does

the point of asm-generic is so that arches don't have to keep copying &=20
pasting things that they really don't care about.  James' proposed patch lo=
oks=20
good to me.  it might be nice to go even further and add logic to a core=20
header so that CONFIG_SYMBOL_PREFIX is always defined ...
=2Dmike

--nextPart15680091.6DaiNokvTq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPR7igAAoJEEFjO5/oN/WBNyEQAIAsafkCYO2NqPp5tfzsHa9E
JsN2hZdzroQuBhESfE16iLxii8cwor2MNnZHYfLWBiKVdle4pUu9cidL7OUQfFQo
3Zl+PlwYQtPqw5XLl3XyYPeeLOIaC4KKhHhlKP809eyU4KkciXP8MknKgnJ+cyvK
JcQrn8SlnS9+sFDL7841/L6oTe0CzXx1ekmcv0sXSG8tEPKhlq5nvKJHNAgg6Aef
sagDOD+nfnQc7c0rawh1zIQKAHlCaK+RNpqIX7+8NcR0HxOfgr3lu5U9oeChnVxY
p3Ow57S3ZJ7wswwNM6ZBG8Ooly3leM8uvrsGl5BYbbX/vDNaGhWcSdDYeS1PQovN
6Q9hwCNzWjj5sdSZC/2lApt/qwn2efXpHnrufZlCqF7rTr5bNTLtfjE3RDgFRN5C
OuN8L816Cks8XZzn/AoRvhWTV/8XI6JfxYkDPk4fGZOfm6Cjd7BzhgHfZPFeEnt9
gcAG+DzHBfftFfjrYtDb9ohlEOqsRCaj6GL90jk+WRoVpNanqyidbATQkrlrGs3D
yqhyWmpuBqbumZu7t+4HnuLmC0QnAvTHDSDGmm8RZNu/H3EsFqIUP5YaPjIXOiCS
urqT0EfmjkN6m+WiqEHcThqlDFkF61a0oBqDaJKV0PKcnhlewD5viU0UBRgZnGZj
YBDghMkFO75KdcMzWkPH
=UOag
-----END PGP SIGNATURE-----

--nextPart15680091.6DaiNokvTq--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2HUSxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:53:21 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54375 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab2HUSxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:53:18 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 16/31] arm64: ELF definitions
Date: Tue, 21 Aug 2012 14:53:16 -0400
User-Agent: KMail/1.13.7 (Linux/3.5.0; KDE/4.6.5; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <CAMuHMdVEX0egzFETMJ=LA_PB+7Qc=Ph-7uxofVr__wOE-0cvLQ@mail.gmail.com> <20120821182731.GJ12708@arm.com>
In-Reply-To: <20120821182731.GJ12708@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart25409338.yePxEpnEFs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201208211453.18583.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart25409338.yePxEpnEFs
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tuesday 21 August 2012 14:27:31 Catalin Marinas wrote:
> On Tue, Aug 21, 2012 at 07:17:19PM +0100, Geert Uytterhoeven wrote:
> > On Tue, Aug 21, 2012 at 6:06 PM, Catalin Marinas wrote:
> > > But I can see on x86 that it always reports x86_64 even if the task is
> > > x86_32.
> >=20
> > Really?
> >=20
> > $ uname -m
> > x86_64
> > $ linux32 uname -m
> > i686
> > $
>=20
> Well, you set the personality explicitly with linux32. What I tested was
> with an x86_32 uname called directly (without linux32) and even though
> the ELF was a 32-bit one, it was reporting x86_64. In this AArch64
> patch, a compat task was automatically setting the linux32 personality
> (which x86 does not do).

i don't think any arch does this.

$ uname -m
ppc64
$ linux32 uname -m
ppc

$ uname -m
sparc64
$ linux32 uname -m
sparc

$ uname -m
x86_64
$ linux32 uname -m
i686

$ uname -m
s390x
$ linux32 uname -m
s390

> Arnd's point is that the ELF file should not affect the personality and
> hence the uname value. This should only be done by an explicit call to
> sys_personality().

correct.  if someone really wants to launch their whole userland with the=20
adjusted personality, they could always boot the kernel with:
	init=3D/usr/bin/linux32 /sbin/init
but the kernel shouldn't be doing this automatically.
=2Dmike

--nextPart25409338.yePxEpnEFs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJQM9keAAoJEEFjO5/oN/WBWQYQAKnbugiuW2+wYUCO2IeI1oyr
ii4/qE5ow3lqG4mhoYWGQrlAW4tsD3SVi0L8uVN8V6A34C54FP3KPT1f//CdmDma
XbA7WiMj1xr9PwjhFBzEkBLfX7MWLZwYkfjI4FMbgd9Oyy7ekRT9cZ04uyKbyb0r
UcUllamPmGt4ulMwjlpVp03BZmaEoSDrMJyZg1i4Jm79+yHoAofsog/xfDrgJDH0
8bOOtkzu9osnSyc4pzwVG8Cp77KVWC6yUnuoJe7B2lxVoYbyMhD86pPXGpu9mbo5
2XEW4IxkMQ21RW63qoYHxIGWR3RXclAKkZ9RNxvsbt+BBt+Yzh2s1fg/YjOPmL2X
MlzQGn8aPqm40C2Q5nTA2P8TMLnGXIqHpdvTjDjrRwJdqLo6+KPXy5zuiW/TYvcY
MiBwuyJu82O3qUL5pJ+qELSin/3antNCXEb6CjXQZKvXIq5/XjWVWKjHDGp1boGS
n60a1FLM8QQ+SPhvOktG4BaAFLxCeT5viXtJAfBmwL+oL5oCXcZfgyeWq2fLneep
KFszOoP5NCrQLT1iBbz7bcaRkb2MPSEbNhbI+4GBGLyEnWZ/Teb+DRNkblOMNIbn
Pa1alyETxZ8uTtFKTY6we/InBLsPYwGAv9GPSvll2eZLDYWYN1Qrr9AGyBaBmik5
l++FTbGTJ9GNxm6/06Pc
=kbS0
-----END PGP SIGNATURE-----

--nextPart25409338.yePxEpnEFs--

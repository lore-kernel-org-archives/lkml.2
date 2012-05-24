Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab2EXHQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 03:16:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45295 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab2EXHQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 03:16:09 -0400
Date: Thu, 24 May 2012 17:16:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
Message-Id: <20120524171604.0d98284f3affc643e9714470@canb.auug.org.au>
In-Reply-To: <20120523153536.GD26974@gmail.com>
References: <20120521185412.aca92107d0a8c4fdd8474e34@canb.auug.org.au>
	<20120521091257.GF31407@gmail.com>
	<20120522182542.655b939d96a8eb67390abb9a@canb.auug.org.au>
	<20120523153536.GD26974@gmail.com>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_May_2012_17_16_04_+1000_GH7cjMAe1pXBtuc8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_May_2012_17_16_04_+1000_GH7cjMAe1pXBtuc8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Wed, 23 May 2012 17:35:36 +0200 Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > On Mon, 21 May 2012 11:12:57 +0200 Ingo Molnar <mingo@kernel.org> wrote:
> > >
> > > * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >=20
> > > > After merging the final tree, today's linux-next build (i386 defcon=
fig)
> > > > failed like this:
> > > >=20
> > > > Invalid absolute R_386_32 relocation: jiffies
> > >=20
> > > Hm, that's our fault: seems like a linker bug fallout, one which=20
> > > we fixed in -tip.
> > >=20
> > > > I am not sure what caused this (it may even been a bad merge=20
> > > > on my part).  I have left it broken for today.
> > >=20
> > > While we've fixed this, to simplify merge window integration of=20
> > > linux-next I've excluded tip:x86/trampoline from the linux-next=20
> > > branch for now, so this build failure should go away tomorrow.
> >=20
> > Weirdly, I still got the same error today.  Any ideas?
>=20
> Ought to be fixed now.

OK, clearly something is wrong :-( There could well be a problem with my
toolchain.

I am still getting this error.  Build is an i386 defconfig

$ i386-linux-gcc --version
i386-linux-gcc (GCC) 4.6.0
Copyright (C) 2011 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ i386-linux-ld --version
GNU ld (GNU Binutils) 2.21
Copyright 2010 Free Software Foundation, Inc.
This program is free software; you may redistribute it under the terms of
the GNU General Public License version 3 or (at your option) a later versio=
n.
This program has absolutely no warranty.

I have CONFIG_DEBUG_SECTION_MISMATCH=3Dy and -s on the build command line.

This is the entire build log:

In file included from /scratch/sfr/next/arch/x86/include/asm/uaccess.h:580:=
0,
                 from /scratch/sfr/next/include/linux/uaccess.h:5,
                 from /scratch/sfr/next/include/linux/highmem.h:8,
                 from /scratch/sfr/next/include/linux/pagemap.h:10,
                 from /scratch/sfr/next/fs/binfmt_misc.c:27:
/scratch/sfr/next/arch/x86/include/asm/uaccess_32.h: In function 'parse_com=
mand.part.1':
/scratch/sfr/next/arch/x86/include/asm/uaccess_32.h:211:26: warning: call t=
o 'copy_from_user_overflow' declared with attribute warning: copy_from_user=
() buffer size is not provably correct [enabled by default]
sort done marker at 9112a4
Invalid absolute R_386_32 relocation: jiffies
make[3]: *** [arch/x86/boot/compressed/vmlinux.relocs] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [arch/x86/boot/compressed/vmlinux] Error 2
make[1]: *** [bzImage] Error 2
make: *** [sub-make] Error 2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__24_May_2012_17_16_04_+1000_GH7cjMAe1pXBtuc8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPveA0AAoJEECxmPOUX5FEBuAP/jmSuxNkhHa/KqCtPbwHHODr
mb/QiMENqgjguVW54dJLZVYlHxl++DKqxx4Te9423DbiMmWRiEtnaeeBaPQGFt/8
A/5ArzUxIqxxo9bI5+Ukw7EWgW+mQ6FeDx00BqQcIrTA7zG8FTXZk3iR475/LErE
AP4VKGkhe6sdxVJst5NS9f4ULq2xQoeN2CrI4p5monIj7argzwKwV2mPY93y2HDN
as5eUQS3pgtmbHmWgSE/g8io3TnPszV1z5UKmLG+I+j8ykgI3wrR3EFLWD4/xohq
Gd5WVIzCCml0ffT3PPpRVXeTD2dni0QuVIkNoftXJVEVHbMf8NaAVrQCxkY6g/9n
qtKT24SksSB9zq0UYmMNxB091YRGlo8pSiShcR2Z98sZ+Wbfeu5cUHTf76VpEYhc
S6DaK+y0KIY9yJIaNTeVtjsVlOFliL0zDBYi7NYUAku5YA0Zq0Meh7ZE1+t9PJ0z
eOM+DXgkg6iorxH0jp+w5NuLadVHFnn0Buyfz+tzCq876KEbYfsrUDPQJr9EMt1Y
IP4QmusFGkcHVn2l9AuaQnJzt1qLZVcX0RpUxUxY3FNyu8IE6O30HFfCZpwzjqbL
Oz7KOBnnZFPzFOpev5lu8Jmhekl10gcBhYV3g287uH9aOPTQs2NK6xDpV9BSWmIf
H8AuAfTrEiBmgGQtotsZ
=GyZp
-----END PGP SIGNATURE-----

--Signature=_Thu__24_May_2012_17_16_04_+1000_GH7cjMAe1pXBtuc8--

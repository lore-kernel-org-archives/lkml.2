Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab2CAAbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:31:17 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50707 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478Ab2CAAbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:31:16 -0500
Date: Thu, 1 Mar 2012 11:31:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [tip:x86/asm] bitops: Optimise get_order()
Message-Id: <20120301113106.020c3ad0560425970c9de34e@canb.auug.org.au>
In-Reply-To: <CAP=VYLr5id0TrsQFbaKOi6FoK7=_zW-Q9dwH+rAEbnmYunHvNQ@mail.gmail.com>
References: <20120220223928.16199.29548.stgit@warthog.procyon.org.uk>
	<tip-d66acc39c7cee323733c8503b9de1821a56dff7e@git.kernel.org>
	<CAP=VYLr5id0TrsQFbaKOi6FoK7=_zW-Q9dwH+rAEbnmYunHvNQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__1_Mar_2012_11_31_06_+1100__R.pU2sRX8cSNR2C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Mar_2012_11_31_06_+1100__R.pU2sRX8cSNR2C
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Feb 2012 15:29:04 -0500 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> On Mon, Feb 20, 2012 at 6:20 PM, tip-bot for David Howells
> <dhowells@redhat.com> wrote:
> > Commit-ID: =C2=A0d66acc39c7cee323733c8503b9de1821a56dff7e
> > Gitweb: =C2=A0 =C2=A0 http://git.kernel.org/tip/d66acc39c7cee323733c850=
3b9de1821a56dff7e
> > Author: =C2=A0 =C2=A0 David Howells <dhowells@redhat.com>
> > AuthorDate: Mon, 20 Feb 2012 22:39:29 +0000
> > Committer: =C2=A0H. Peter Anvin <hpa@zytor.com>
> > CommitDate: Mon, 20 Feb 2012 14:47:02 -0800
> >
> > bitops: Optimise get_order()
>=20
> This is causing build failures on non-x86 in linux next according to git =
bisect.

Presumably it needs to include linux/bitops.h (and see below).

> > +static inline __attribute_const__
> > +int __get_order(unsigned long size)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 int order;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 size--;
> > + =C2=A0 =C2=A0 =C2=A0 size >>=3D PAGE_SHIFT;
> > +#if BITS_PER_LONG =3D=3D 32
> > + =C2=A0 =C2=A0 =C2=A0 order =3D fls(size);
> > +#else
> > + =C2=A0 =C2=A0 =C2=A0 order =3D fls64(size);
> > +#endif

linux/bitops.h has fls_long() that does this size test and calls the right =
thing.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__1_Mar_2012_11_31_06_+1100__R.pU2sRX8cSNR2C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTsNKAAoJEECxmPOUX5FEZREP/07NgZai+MjUkXd7K4UX4gAd
q40AEDmhQQNBvJ5Eq3jE0GgZx69eZ8RgChDwOZ16pGgxKfffZ8NTRqGszG2wB9f7
TMWNe4ECUs3TZRWVNmI+p1gzQetoTkJde8o6IfINP4RIhbLup7IIO0pHMBjkXfeq
q8NtoeNo2O6jUiA1P8asSnkIW3hnbER79Sfp28YPpP1RuPYpWTykM5CeGnqaGkd3
CkuqiDe63PeymlAa/CGUWVd+8ZObRSiM6+NZQBcYfj+bsJTPAeRtjT42Z5xhF72w
juddpSSRAj51zvyxuKRpJdXOCkBYU/R0terdt8guw4zYbVNivclxtIMassI3YZbz
5EsjQNhAzX5ytawiCFDVv3sq3S5SBJ1835O0d41tIkqtlAizcn9vWwwEjkztMMBp
lAdxQ6ixQQteBP4J8wvq10KBl2AjGzt8o/ks4pe3xQiPYsIwqrjeeE2ZpkCDxWTU
wfbY0Ui82Sxq6HZCjq1GN5bCQT7VcwGCRF6SdUeox5zm6S6ApQ74ESS+hpkwctX6
8eGV3dZ0eKm4uBwsQLHGCWqAv64ipPWOIqZ4lRqoo9Khcxxbv8Ghg3b5v7uf+Cd7
7WJ7w1my8PAiAjlLH9QiWg23ahuXDnzua2wudAb0qqh2jCZoSxvdEfJF1Qvb4/gW
tJOXlGChUfVWuNNuKuEU
=SjUv
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Mar_2012_11_31_06_+1100__R.pU2sRX8cSNR2C--

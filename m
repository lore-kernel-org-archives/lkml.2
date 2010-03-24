Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab0CXLlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:41:12 -0400
Received: from ozlabs.org ([203.10.76.45]:53388 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab0CXLlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:41:09 -0400
Subject: Re: [PATCH -v4 00/08] use lmb with x86
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100324104844.GA896@elte.hu>
References: <1269427029-21000-1-git-send-email-yinghai@kernel.org>
	 <20100324104844.GA896@elte.hu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1awye0z1mlrNhPcGrEB4"
Date: Wed, 24 Mar 2010 22:41:08 +1100
Message-ID: <1269430868.2500.14.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1awye0z1mlrNhPcGrEB4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-03-24 at 11:48 +0100, Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
>=20
> > new early_res is lmb extension. and it could be used to replace bootmem=
.
>=20
> Why not do what we suggested: extend lmb.c to also offer the=20
> early_res-equivalent functionality, and remove kernel/early_res.c and mov=
e=20
> lib/lmb.c to mm/lmb.c?
>=20
> We dont want two facilities (early_res and lmb) really ...

Exactly.=20

This series seems to leave us with kernel/early_res.c (which should
never have moved out of arch/x86 AFAICS) - as well as using some of
lmb.c.

It doesn't compile on powerpc, because early_res.c is looking for
find_fw_memmap_area() which is still under arch/x86.

And sprinkling CONFIG_NO_BOOTMEM everywhere is getting a bit gross. I
notice that's already happened to mm/(bootmem|page_alloc).c but
propagating it further is not nice.

cheers

--=-1awye0z1mlrNhPcGrEB4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkup+lMACgkQdSjSd0sB4dK6AwCfYttVCzUU3RJDuSdh6cwf4tLg
0FAAniW7ilFsqPMjjogBgNbfvtRjM9Xz
=bYeo
-----END PGP SIGNATURE-----

--=-1awye0z1mlrNhPcGrEB4--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab1FRSl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 14:41:29 -0400
Received: from ulysses.noc.ntua.gr ([147.102.222.230]:65220 "EHLO
	ulysses.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab1FRSl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 14:41:27 -0400
Message-ID: <4DFCF13F.50401@cslab.ece.ntua.gr>
Date: Sat, 18 Jun 2011 21:41:03 +0300
From: Vasileios Karakasis <bkk@cslab.ece.ntua.gr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100217 Lightning/1.0b1 Shredder/3.0.3pre
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-numa@vger.kernel.org
Subject: Re: [BUG] Invalid return address of mmap() followed by mbind() in
 multithreaded context
References: <4DFB710D.7000902@cslab.ece.ntua.gr> <20110618181232.GI16236@one.firstfloor.org>
In-Reply-To: <20110618181232.GI16236@one.firstfloor.org>
X-Enigmail-Version: 1.0.1
OpenPGP: id=17A67A9C;
	url=http://www.cslab.ece.ntua.gr/~bkk/files/bkk.pub
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1CC55EF867D4A735A093B854"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (ulysses.noc.ntua.gr [147.102.222.230]); Sat, 18 Jun 2011 21:41:17 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1CC55EF867D4A735A093B854
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

That's right, but what I want to demonstrate is that the address
returned by mmap() is invalid and the dereference crashes the program,
while it shouldn't. I could equally omit this statement, in which case
mbind() would fail with EFAULT.

On 06/18/2011 09:12 PM, Andi Kleen wrote:
>>     for (i =3D 0; i < NR_ITER; i++) {
>>         addr =3D mmap(0, PAGE_SIZE, PROT_READ | PROT_WRITE,
>>                     MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
>>         if (addr =3D=3D (void *) -1) {
>>             assert(0 && "mmap failed");
>>         }
>>         *addr =3D 0;
>>
>>         err =3D mbind(addr, PAGE_SIZE, MPOL_BIND, &node, sizeof(node),=
 0);
>=20
> mbind() can be only done before the first touch. you're not actually te=
sting=20
> numa policy.
>=20
> -andi

--=20
V.K.


--------------enig1CC55EF867D4A735A093B854
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk388U0ACgkQHUHhfRemepxHwwCg8nBwl3ZuVdCmwEecizOdDuOM
680An3lRmAFNS5Ek8ZQjBSPb5YUcqNwA
=CacT
-----END PGP SIGNATURE-----

--------------enig1CC55EF867D4A735A093B854--

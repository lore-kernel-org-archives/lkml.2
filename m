Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab1IJEL1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 00:11:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47806 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750712Ab1IJEL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 00:11:26 -0400
Subject: Re: Bug#640964: linux-image-3.1.0-rc4-486: BUG() triggered on XO-1
 hardware
From: Ben Hutchings <ben@decadent.org.uk>
To: Andres Salomon <dilinger@queued.net>
Cc: 640964@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>
Date: Sat, 10 Sep 2011 05:11:06 +0100
References: <20110908174625.1b97223a@queued.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-iHyOlinYnhbpKA9GVwAJ"
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315627876.23168.108.camel@deadeye>
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iHyOlinYnhbpKA9GVwAJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-09-09 at 03:41 +0100, Ben Hutchings wrote:
> On Thu, 2011-09-08 at 17:46 -0700, Andres Salomon wrote:
> > Package: linux-image-3.1.0-rc4-486
> > Version: 3.1.0~rc4-1~experimental.1
> > Severity: normal
> >=20
> > During boot on an OLPC XO-1, I encounter the following problem.  I
> > believe it's the statement BUG_ON(a->cpuid >=3D NCAPINTS*32), though I'=
m
> > not staring at an exact copy of linux-2.6 source.
> [...]
>=20
> Agreed.
>=20
> Variable a is in the EBX register, value 0xc143c668.  Looking at a dump
> of this kernel image, the __alt_instructions array starts with:
>=20
>  c143c638 7e51bcff 1c050000 1a000503 7d51bcff  ~Q..........}Q..
>  c143c648 13050000 1a000503 6653bcff 0a050000  ........fS......
>  c143c658 19000503 00000000 ce55bcff 00000000  .........U......
>  c143c668 9a000200 cf55bcff f1040000 e4000303  .....U..........
>  ...
>=20
> Converting back to C structures:
>=20
> /* instr_offset, repl_offset, cpuid, instrlen, replacementlen */
> { 0xffbc517e, 0x0000051c, 0x001a, 0x05, 0x03 },
> { 0xffbc517d, 0x00000513, 0x001a, 0x05, 0x03 },
> { 0xffbc5366, 0x0000050a, 0x0019, 0x05, 0x03 },
> { 0x00000000, 0xffbc55ce, 0x0000, 0x00, 0x00 },
> { 0x0002009a, 0xffbc55cf, 0x04f1, 0x00, 0x00 },
> ...
>=20
> Oops, we have 4 bytes of zeroes between what should be elements 2 and 3.
> That results in __alt_instructions[4].cpuid =3D=3D 0x04f1 which trips the
> BUG check.  This is nothing OLPC-specific; it's going to happen on any
> machine trying to boot this image.
>=20
> So the question is, where does that padding come from?

Element 2 is for the wmb() in async_hcall() in arch/x86/lguest/boot.c.
Element 3 is for the use_xsave() in __unlazy_fpu().

There is no padding between any of the other elements in
__alt_instructions in this image.

But there's nothing very special or obviously wrong about those two uses
of alternatives.

Ben.

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-iHyOlinYnhbpKA9GVwAJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATmrjW+e/yOyVhhEJAQqaLBAAugH1v7rP8UXNzneK2R7lfyZxEBm40ujg
2H0gq3cd3RUsI/giUE3LJkkVVx/n9fDBGI+CX9V5wejHH8Gpupu+VlIQOQuLKbF3
C7TvHAhCXLJw0i7ZgYbeXRFQiwRicxMVtQJZebCYXtBGgMXRDZ4SOe0NsyccqO9z
Eubkj066WaH0pDiKShFYtCVab8uXcAJZvviG9vRM8zYLFZvhUaUf8hi1j48y1zyg
TTY7abnH6zrUIQu6ZDh7bRJT7dD+Hk6UOfJKKWsWkhR20PBeFeCDN4E+sRYOCm0E
Gs+BZFO7Q556AjpYoCSy2xrVWqIlwQ342k0Hgi3B4hxRJAvEy/WnyiN8BIpeLgjA
SRTgbhhUFvwjNWpSl5GcB5qd1+lsoXkokER1y4DigPuQy/VAfY8Ew4+8uCChbFeB
lKZoVx5Uhd07gmZxVaqVmAgN7cGmCsycKTnfpN/f745TZFVEzykMYops9QPdoCip
0ms8vWAo4JYHbVsnlvVvxFQ6TqFtjjn3WFcXSS15OAgnVVf9OiZuaA8PCUhZF2zX
MGLS6gTZOR/AeJcb/HrQ//TRQHX506+sLTmz7OAbNBp2MwJN8ljVzVwLkqn21wuC
2kovK0/sTYmvSL8WLw0/Rvc+lULVHuIsoMx62TXkRjdZ+dX5d77RE4UaOYjDUiPj
UcDDpQTp94o=
=e3jc
-----END PGP SIGNATURE-----

--=-iHyOlinYnhbpKA9GVwAJ--

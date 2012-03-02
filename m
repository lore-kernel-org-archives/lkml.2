Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879Ab2CBHIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:08:23 -0500
Received: from mail.southpole.se ([193.12.106.18]:41279 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964849Ab2CBHIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:08:20 -0500
Message-ID: <1330672071.19557.105.camel@satguru>
Subject: Re: OpenRISC: Module loader broken
From: Jonas Bonn <jonas@southpole.se>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Weinberger <richard@nod.at>, linux@openrisc.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 02 Mar 2012 08:07:51 +0100
In-Reply-To: <CAMuHMdVEQ-=vCawQPUbG_D6jA7fLxV4zYddYjc-5htW1baE2zg@mail.gmail.com>
References: <4F501C7A.30307@nod.at> <1330668690.19557.91.camel@satguru>
	 <CAMuHMdVEQ-=vCawQPUbG_D6jA7fLxV4zYddYjc-5htW1baE2zg@mail.gmail.com>
Organization: South Pole Consulting AB
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-wtBJbVIVFdzwEEnI66Fa"
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 72098-03400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--=-wtBJbVIVFdzwEEnI66Fa
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-03-02 at 07:49 +0100, Geert Uytterhoeven wrote:
> On Fri, Mar 2, 2012 at 07:11, Jonas Bonn <jonas@southpole.se> wrote:
> So OpenRISC is big endian, which matches
> arch/openrisc/include/asm/byteorder.h:#include <linux/byteorder/big_endia=
n.h>
>=20
> However, there are some remainings of little endian support:
> arch/openrisc/include/asm/unaligned.h:#if defined(__LITTLE_ENDIAN)
> arch/openrisc/include/asm/unaligned.h:#elif defined(__BIG_ENDIAN)
> arch/openrisc/include/asm/unaligned.h:# error need to define endianess

Technically OpenRISC can be either big or little endian, but there is no
publically available little-endian implementation... yet.  There's a
proprietary little-endian implementation, but they're not running Linux.
Anyway, that's the reason for starting to cater for both endianesses.

>=20
> > Since 'location' points at the 32-bit instruction in question, that cas=
t
> > is supposed to be saying:  'move 16 bit value into low 16 bits of
> > instruction'.
>=20
> It may be more readable and safer (w.r.t. changing endianness) to do
> 32-bit loads and stores and explicitly modify the 16 LSB.

Agreed.  It's probably a bit too clever that way it's written now.

/Jonas

--=-wtBJbVIVFdzwEEnI66Fa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk9QcccACgkQ70gcjN2673N1GwCg0rBJ5VtaQMSnBLvuiILZBo/C
HKYAn1JHwiCK+4SOHzOCVOLlb7Lup2hm
=sDsG
-----END PGP SIGNATURE-----

--=-wtBJbVIVFdzwEEnI66Fa--


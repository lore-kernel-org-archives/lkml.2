Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab1C1FIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 01:08:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39413 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab1C1FIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 01:08:21 -0400
Date: Mon, 28 Mar 2011 16:08:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block drivers for 2.6.39-rc
Message-Id: <20110328160812.b4d19eb5.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTik3GZ0b5S7p4ONQu4Hb8LoKewmMJ7_J5zvumYD-@mail.gmail.com>
References: <4D8E36CC.7080707@fusionio.com>
	<20110328042311.GA15481@elte.hu>
	<AANLkTik3GZ0b5S7p4ONQu4Hb8LoKewmMJ7_J5zvumYD-@mail.gmail.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Mar_2011_16_08_12_+1100_q0llRY.trVWmGemw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Mar_2011_16_08_12_+1100_q0llRY.trVWmGemw
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus, Ingo,

On Sun, 27 Mar 2011 21:37:50 -0700 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Sun, Mar 27, 2011 at 9:23 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > This driver does not build at all:
> >
> > =C2=A0drivers/block/drbd/drbd_bitmap.c:1187:5: error: implicit declarat=
ion of function =E2=80=98generic_find_next_zero_le_bit=E2=80=99 [-Werror=3D=
implicit-function-declaration]
> > =C2=A0drivers/block/drbd/drbd_bitmap.c:1190:5: error: implicit declarat=
ion of function =E2=80=98generic_find_next_le_bit=E2=80=99 [-Werror=3Dimpli=
cit-function-declaration]
> > =C2=A0drivers/block/drbd/drbd_bitmap.c:1290:4: error: implicit declarat=
ion of function =E2=80=98generic___test_and_set_le_bit=E2=80=99 [-Werror=3D=
implicit-function-declaration]
> > =C2=A0drivers/block/drbd/drbd_bitmap.c:1292:4: error: implicit declarat=
ion of function =E2=80=98generic___test_and_clear_le_bit=E2=80=99 [-Werror=
=3Dimplicit-function-declaration]
> > =C2=A0drivers/block/drbd/drbd_bitmap.c:1441:3: error: implicit declarat=
ion of function =E2=80=98generic_test_le_bit=E2=80=99 [-Werror=3Dimplicit-f=
unction-declaration]
> >
> > Has this been build-tested? These APIs do not exist upstream.
>=20
> Actually, I think that's just a merge error - those horrible nasty
> crazy names did use to exist.
>=20
> Does this fix it? (Untested!)

You also need to remove the include of asm-generic/bitops/le.h from that
file now (the easiest way is to revert commit f0ff1357ce39 ("drbd: need
include for bitops functions declarations").

Jens was informed about these problems when they appeared in linux-next.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Mar_2011_16_08_12_+1100_q0llRY.trVWmGemw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNkBe8AAoJEDMEi1NhKgbs9yEH/RNq4PNwuVwUd5ulcah8cDda
eQyUxjrf86m7ERny+Pgp7mzObK5VTamzgtruKDhG/CfBabj3B1a/4asjB8zUudiu
WAGpIQAbfWxOibjqazx84sGkS7p1q4UaBNMUiqGql4jqaX8Zml6F3BA8tFef7h+l
axN1X8hY3U2vMCjC5IZcBOkMf80G6kFAPFIzhv1ieKNxBRruxtZH0xXDjLox6BwH
j5p5Bj8wDMD61Upl2/NGUkmybJdV/9ViDD73JWT2+rIyJmYqNKSsbiqEsE9MW5+9
s0aJz/S/6+nE+ehsjUWMCbfEUKqRx+uRIUOXGUJyYR30/VPyRuhiKf4ejQTgGxY=
=q1ZA
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Mar_2011_16_08_12_+1100_q0llRY.trVWmGemw--

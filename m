Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260Ab0JIMkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 08:40:40 -0400
Received: from smtp207.alice.it ([82.57.200.103]:58386 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab0JIMkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 08:40:39 -0400
Date: Sat, 9 Oct 2010 14:40:26 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Alan Ott <alan@signal11.us>, Oliver Neukum <oliver@neukum.name>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 0/2] HID: hidraw, fix two NULL pointer dereferences
Message-Id: <20101009144026.c37f8d25.ospite@studenti.unina.it>
In-Reply-To: <4CAC4AC3.60507@gmail.com>
References: <alpine.LNX.2.00.1010041548580.29535@pobox.suse.cz>
	<1286292017-6746-1-git-send-email-ospite@studenti.unina.it>
	<4CAB94A0.8040402@gmail.com>
	<20101006120129.52da81d3.ospite@studenti.unina.it>
	<4CAC4AC3.60507@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__9_Oct_2010_14_40_26_+0200_huzKpfoGAnXCecf+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__9_Oct_2010_14_40_26_+0200_huzKpfoGAnXCecf+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 06 Oct 2010 12:09:07 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 10/06/2010 12:01 PM, Antonio Ospite wrote:
> > On Tue, 05 Oct 2010 23:12:00 +0200
> > Jiri Slaby <jirislaby@gmail.com> wrote:
[...]
> >> Hi, please fix also the window in hidraw_release.
> >>
> >=20
> > I am not sure I get what you mean, can you please add more details?
>=20
> Sure. Look at the code:
> if (!hidraw_table[minor])
>         return -ENODEV;
> ...
> dev =3D hidraw_table[minor];
> if (!--dev->open) {
> ...
>=20
> This is done without minors_lock, so you can easily have dev being NULL
> even though the first if.
>

Jiri (Slaby) I think it makes more sense if you send a patch about this
as it is you who has raised the issue.

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Sat__9_Oct_2010_14_40_26_+0200_huzKpfoGAnXCecf+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkywYroACgkQ5xr2akVTsAFb5QCfeUKQ5Wi4iSDBGMj3dZbCF3jF
ozgAoJS/S/r/qjrQvQ6MxNJHbtsFzcgO
=e80J
-----END PGP SIGNATURE-----

--Signature=_Sat__9_Oct_2010_14_40_26_+0200_huzKpfoGAnXCecf+--

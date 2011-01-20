Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab1ATNE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 08:04:26 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:42587 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab1ATNEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 08:04:25 -0500
X-Spam-ASN: 
Date: Thu, 20 Jan 2011 16:04:15 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PPS parport boot lockup: INFO: HARDIRQ-READ-safe ->
 HARDIRQ-READ-unsafe lock order detected
Message-ID: <20110120160415.0e7da2b7@desktopvm.lvknet>
In-Reply-To: <20110119083916.GA2166@elte.hu>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
	<20110119083916.GA2166@elte.hu>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/RKplKHgI/hm6U8B/e827BgI"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/RKplKHgI/hm6U8B/e827BgI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Wed, 19 Jan 2011 09:39:16 +0100
Ingo Molnar <mingo@elte.hu> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

>=20
> .38-rc1 allyes64 bootup locks up soft, but first produces this lockdep sp=
lat:
>=20
[snip]
> That's probably one of these commits:
>=20
>  563558b2c735: pps: add parallel port PPS signal generator
>  46b402a0e5e4: pps: add parallel port PPS signal generator
>  a10203c691ea: pps: add parallel port PPS client
>=20
> Plus CONFIG_PPS_CLIENT_PARPORT=3Dy.
>=20
> This feature seems rather untested - this is a plain whitebox PC with a p=
arallel=20
> port.

I'm investigating this. Thanks for the report!

> Btw., why does 46b402a0e5e4 and 563558b2c735 have the same title?

Well, 46b402a0e5e4 refers to version 6 of my patchset and 563558b2c735
is a diff between version 6 and 7. I've seen from the e-mails from
Andrew that I received that he added both patches and then folded the
latter into the former. The same thing happened with several other
patches but only these two sneaked in. Maybe this is a bug in the
software (quilt?).

--=20
  Alexander

--Sig_/RKplKHgI/hm6U8B/e827BgI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJNODLPAAoJEElrwznyooJbMLsH/jTTRqw1wNprNVjfjRTTK3G0
ZvCuRPggegJaMVrXtuGkuhhL32Np1FyUS5EYy1aSxPEkNXRmylJunrnKBLEIxOQb
an7szzbNGC+zh68nxaodAkrGtLFgs86rvDuncyn5tALzQa7okzKpXCuws/byDLmY
WTII19YZ52db3NoqUmj070c/YhRB6e1+C9CPCIIHX+FIdBf5foog/vtiTyYFaXWx
/IM6ABNOQX0Sx0ltdtPoLiApWy9UDsb7/Tvo8+iDsBvrKs0FxIwkNzqBLAQ7f4wz
ssFeliut7lsCstq7bHlQKvYEvaGmWMf2bZlRWLfYuLQ8/cRvri8b9WAmkhq5xcA=
=SVg6
-----END PGP SIGNATURE-----

--Sig_/RKplKHgI/hm6U8B/e827BgI--

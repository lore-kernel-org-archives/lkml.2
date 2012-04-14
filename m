Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab2DNKYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:24:34 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:39878 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753820Ab2DNKYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:24:32 -0400
Subject: Re: [PATCH v2 3/4] fat: mark superblock as dirty less often
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Sat, 14 Apr 2012 13:24:17 +0300
In-Reply-To: <87k41ihdub.fsf@devron.myhome.or.jp>
References: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
	 <1334326795-2446-4-git-send-email-dedekind1@gmail.com>
	 <87k41ihdub.fsf@devron.myhome.or.jp>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-MMrUMz7v7LL+JyGyxzrv"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1334399070.2263.3.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MMrUMz7v7LL+JyGyxzrv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, thanks for feed-back,

On Sat, 2012-04-14 at 18:17 +0900, OGAWA Hirofumi wrote:
> Artem Bityutskiy <dedekind1@gmail.com> writes:
>=20
> > From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> >
> > This patch is a preparation for further changes. It touches few functio=
ns
> > in fatent.c and prevents them from marking the superblock as dirty
> > unnecessarily often. Namely, instead of marking it as dirty in the inte=
rnal
> > tight loops - do it only once at the end of the functions. And instead =
of
> > marking it as dirty while holding the FAT table lock, do it outside the=
 lock.
> >
> > The reason for this patch is that marking the superblock as dirty will =
soon
> > become a little bit heavier operation, so it is cleaner to do this only=
 when it
> > is necessary.
>=20
> For it, please use local variable like,
>=20
>=20
> {
>        	int fsinfo_dirty =3D 0;
>=20
> 	while (1) {
>         	change free_clusters
>                 fsinfo_dirty =3D 1;
>         }
>=20
>         if (fsinfo_dirty)
>         	mark_fsinfo_dirty()
> }
>=20
> instead of dirty it always.

But could you please explain why do we need an extra variable? What is
the problem with doing all our FAT table changes and then marking the
FSINFO as dirty?

--=20
Best Regards,
Artem Bityutskiy

--=-MMrUMz7v7LL+JyGyxzrv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJPiVBRAAoJEJtuLFy+q7fevn4H/103fsRTTWftqgfhWFFTiAaY
bdlvuxsIcpP9HLhLVoYcFEmSTvT2/vfFX1zDqM8blG6r1UT0M/mTk05+ts4njojr
X9949f4QICXugXgSsp4q6kcju2w/dbW5BE9vK6PgJAFL4wnFZzbxpeSO0khvNLSJ
23Ex9VGN8orixqL9N1ujVbnrc6z1LHL0A/IAzRG1FkTt+hPSwVFIIZtjYek+uVny
5vOP73csFSFkz19pLD6eQvCNNkqOeqQorhLvw35+Bd7BEy900223IbHNE4MCUIL2
hHhu9N7fUd4Z9Znvf16SGtsHIVdTGaNZ8sdwNMU0NfhI30yaMrwEXUdGmSvjdZw=
=c7ju
-----END PGP SIGNATURE-----

--=-MMrUMz7v7LL+JyGyxzrv--


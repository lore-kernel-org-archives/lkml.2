Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab1DBAUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 20:20:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51565 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab1DBAUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 20:20:47 -0400
Date: Sat, 2 Apr 2011 11:20:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: Jens Axboe <jaxboe@fusionio.com>, Sedat Dilek <sedat.dilek@googlemail.com>,
        dedekind1@gmail.com, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 1 [BROKEN ubifs when
 CONFIG_DEBUG_SECTION_MISMATCH=y]s
Message-Id: <20110402112037.ca288d7b.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTimhD_cu46Bhtt9v8MjKMVCnVMT6Es+Ys9RNPOp1@mail.gmail.com>
References: <AANLkTimhD_cu46Bhtt9v8MjKMVCnVMT6Es+Ys9RNPOp1@mail.gmail.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__2_Apr_2011_11_20_37_+1100_D2dZDoOT_/IX2CL9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Apr_2011_11_20_37_+1100_D2dZDoOT_/IX2CL9
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

cc'ing Jens ...

On Fri, 1 Apr 2011 20:22:41 +0200 Sedat Dilek <sedat.dilek@googlemail.com> =
wrote:
>
> On Fri, Apr 1, 2011 at 7:02 PM, Artem Bityutskiy <dedekind1@gmail.com> wr=
ote:
> > On Fri, 2011-04-01 at 18:10 +0200, Sedat Dilek wrote:
> >> On Fri, Apr 1, 2011 at 6:06 PM, Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >> > Cc'ing Artem,
> >> >
> >> > On Fri, 1 Apr 2011 17:55:52 +0200 Sedat Dilek <sedat.dilek@googlemai=
l.com> wrote:
> >> >>
> >> >> With CONFIG_DEBUG_SECTION_MISMATCH=3Dy set, I see in my build.log:
> >> >> ...
> >> >> MODPOST 2742 modules
> >> >> ...
> >> >> ERROR: "empty_aops" [fs/ubifs/ubifs.ko] undefined!
> >> >> make[5]: *** [__modpost] Error 1
> >> >> make[4]: *** [modules] Error 2
> >> >> make[3]: *** [sub-make] Error 2
> >> >> make[2]: *** [all] Error 2
> >> >> make[2]: Leaving directory
> >> >> `/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/build_i386_no=
ne_686-iniza'
> >> >>
> >> >> - Sedat -
> >> >>
> >> >
> >> >
> >> > --
> >> > Cheers,
> >> > Stephen Rothwell =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0sfr@canb.auug.org.au
> >> > http://www.canb.auug.org.au/~sfr/
> >> >
> >>
> >> Speculative patch (untested).
> >>
> >> - Sedat -
> >>
> >> $ diff -uprN fs/ubifs/xattr.c.orig fs/ubifs/xattr.c
> >> --- fs/ubifs/xattr.c.orig =C2=A0 =C2=A0 =C2=A0 2011-04-01 15:56:08.471=
082117 +0200
> >> +++ fs/ubifs/xattr.c =C2=A0 =C2=A02011-04-01 18:08:27.355276827 +0200
> >> @@ -81,6 +81,7 @@ enum {
> >>
> >> =C2=A0static const struct inode_operations none_inode_operations;
> >> =C2=A0static const struct file_operations none_file_operations;
> >> +static const struct address_space_operations empty_aops;
> >>
> >> =C2=A0/**
> >> =C2=A0 * create_xattr - create an extended attribute.
> >
> > ubifs doess not have 'empty_aops' symbol and does not use such symbol. I
> > do not understand how you got that build issue, but this must be
> > something to do with your local setup.
> >
> > Also:
> >
> > [dedekind@eru linux-next (master)]$ grep -r 'empty_aops' *
> > fs/nilfs2/page.c: =C2=A0 =C2=A0 =C2=A0 static const struct address_spac=
e_operations empty_aops;
> > fs/nilfs2/page.c: =C2=A0 =C2=A0 =C2=A0 mapping->a_ops =3D &empty_aops;
> > fs/inode.c: =C2=A0 =C2=A0 static const struct address_space_operations =
empty_aops;
> > fs/inode.c: =C2=A0 =C2=A0 mapping->a_ops =3D &empty_aops;
> >
> > in the current linux-next.
> >
> > --
> > Best Regards,
> > Artem Bityutskiy (=D0=90=D1=80=D1=82=D1=91=D0=BC =D0=91=D0=B8=D1=82=D1=
=8E=D1=86=D0=BA=D0=B8=D0=B9)
> >
> >
>=20
> You are right, I pulled linux-2.6-block.git#for-linus into linux-next.
> Looks like linux-2.6-block-for-linus/0007-fs-export-empty_aops.patch
> is causing this [1].
>=20
> - Sedat -
>=20
> [1] http://git.kernel.org/?p=3Dlinux/kernel/git/axboe/linux-2.6-block.git=
;a=3Dcommit;h=3D2c9214b7b72cf440024d8b91523eea25bbc76040
>=20


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__2_Apr_2011_11_20_37_+1100_D2dZDoOT_/IX2CL9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNlmvVAAoJEDMEi1NhKgbs7tsH/1QbcmvD7LtKIkH2wBYR2brt
1+D/V952iKiTxSYLfRWBW4V/vcCeq/EcpeovfW9iBueI19Ug7hxK7YuMXtS25DM6
4ND5GNQzntYaGXMfs34eFXO0U0Ee/8pud9bk9SUHRz2/qYRIiO/g3eMb2I+aGCvs
08RKgi5Fm/KFHVl1ePuTZ9I29x5vmbkmsYpPPkh9XSnyYUeqCyJEHU0F1lpGWglE
26hhs9ldCcVLZybXaQHYChTVu5GgCevCeF5Q3UI/CWzHGQe7SQoA6QsKCzKFyYBx
k0xD7pWVJL2+UJk1gyNsWm5BDyvB37/1pPYq/DybA2dqCtvzRN2vPJtniolzGqU=
=KfHY
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Apr_2011_11_20_37_+1100_D2dZDoOT_/IX2CL9--

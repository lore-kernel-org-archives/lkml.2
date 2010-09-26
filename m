Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab0IZXkd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 19:40:33 -0400
Received: from imp02.mtu.ru ([62.5.255.19]:38368 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757639Ab0IZXkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 19:40:31 -0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc
To: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [Bug #19082] fs/fs-writeback.c to dump
Date: Mon, 27 Sep 2010 03:40:17 +0400
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5+; KDE/4.5.1; x86_64; ; )
References: <MEG5YPP-fxC.A.vnD.So6nMB@chimera> <sQALkqF1FWE.A.ztD.Xo6nMB@chimera>
In-Reply-To: <sQALkqF1FWE.A.ztD.Xo6nMB@chimera>
X-Face: $dO4505L-bM3\Iz"(
 =?utf-8?q?V=3Dy=2EbL/75=7B5ys3=3AB=5B-aPBQvs*Z=25fdBqFhvc85hmZN4j1kwRzwvY*?=
 =?utf-8?q?R=0A=094=09nvQ/=23/+kWXH?=((aXWh\%mvG1V()Z0k:NwZAIu\S0d1%,nv`^
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12757424.VEodz173Ws";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009270340.26148.pavel@pavlinux.ru>
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart12757424.VEodz173Ws
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=D0=92 =D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B8 =D0=BE=D1=82 =
=D0=9F=D0=BE=D0=BD=D0=B5=D0=B4=D0=B5=D0=BB=D1=8C=D0=BD=D0=B8=D0=BA 27 =D1=
=81=D0=B5=D0=BD=D1=82=D1=8F=D0=B1=D1=80=D1=8F 2010 00:04:16 =D0=B2=D1=8B =
=D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB=D0=B8:
> This message has been generated automatically as a part of a summary repo=
rt
> of recent regressions.
>=20
> The following bug entry is on the current list of known regressions
> from 2.6.35.  Please verify if it still should be listed and let the
> tracking team know (either way).

I don't know, this bug or not :)

# view +73 fs/fs-writeback.c
=2E..

static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
{
        struct super_block *sb =3D inode->i_sb;
        struct backing_dev_info *bdi =3D inode->i_mapping->backing_dev_info;

        /*
         * For inodes on standard filesystems, we use superblock's bdi. For
         * inodes on virtual filesystems, we want to use inode mapping's bdi
         * because they can possibly point to something useful (think about
         * block_dev filesystem).
         */

        if (sb->s_bdi && sb->s_bdi !=3D &noop_backing_dev_info) {

               /* Some device inodes could play dirty tricks. Catch them...=
 */

          WARN(bdi !=3D sb->s_bdi && bdi_cap_writeback_dirty(bdi),
                        "Dirtiable inode bdi %s !=3D sb bdi %s\n",
                        bdi->name, sb->s_bdi->name);
                return sb->s_bdi;
        }
        return bdi;
}




>=20
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D19082
> Subject		: fs/fs-writeback.c to dump
> Submitter	: Pavel Vasilyev <pavel@pavlinux.ru>
> Date		: 2010-09-25 15:52 (2 days old)
> Message-ID	: <201009251952.58749.pavel@pavlinux.ru>
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D128543035026659&w=3D2

--nextPart12757424.VEodz173Ws
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyf2eoACgkQOqfDywN0JIlt/ACglmHH1Ct3ydheAvgETH3FYlnc
mKkAmgLfZVaop0X4dUpOaQSqv/8Ii8nN
=pf03
-----END PGP SIGNATURE-----

--nextPart12757424.VEodz173Ws--

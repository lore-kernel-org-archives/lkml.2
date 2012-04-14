Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab2DNK3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:29:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38340 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab2DNK3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:29:42 -0400
Subject: Re: [PATCH v2 4/4] fat: switch to fsinfo_inode
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Sat, 14 Apr 2012 13:29:37 +0300
In-Reply-To: <87fwc6hazv.fsf@devron.myhome.or.jp>
References: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
	 <1334326795-2446-5-git-send-email-dedekind1@gmail.com>
	 <87fwc6hazv.fsf@devron.myhome.or.jp>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-hw0t7TMzuXujmRHHTJBE"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1334399379.2263.8.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hw0t7TMzuXujmRHHTJBE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-04-14 at 19:19 +0900, OGAWA Hirofumi wrote:
> Artem Bityutskiy <dedekind1@gmail.com> writes:
>=20
> > From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> >
> > Currently FAT file-system maps the VFS "superblock" abstraction to the =
FSINFO
> > block. The FSINFO block contains non-essential data about the amount of=
 free
> > clusters and the next free cluster. FAT file-system can always find out=
 this
> > information by scanning the FAT table, but having it in the FSINFO bloc=
k may
> > speed things up sometimes. So FAT file-system relies on the VFS superbl=
ock
> > write-out services to make sure the FSINFO block is written out to the =
media
> > from time to time.
> >
> > The whole "superblock write-out" VFS infrastructure is served by the
> > 'sync_supers()' kernel thread, which wakes up every 5 (by default) seco=
nds and
> > writes out all dirty superblock using the '->write_super()' call-back. =
But the
> > problem with this thread is that it wastes power by waking up the syste=
m every
> > 5 seconds no matter what. So we want to kill it completely and thus, we=
 need to
> > make file-systems to stop using the '->write_super' VFS service, and th=
en
> > remove it together with the kernel thread.
> >
> > This patch switches the FAT FSINFO block management from
> > '->write_super()'/'->s_dirt' to 'fsinfo_inode'/'->write_inode'. Now, in=
stead of
> > setting the 's_dirt' flag, we just mark the special 'fsinfo_inode' inod=
e as
> > dirty and let VFS invoke the '->write_inode' call-back when needed, whe=
re we
> > write-out the FSINFO block.
> >
> > This patch also makes sure we do not mark the 'fsinfo_inode' inode as d=
irty if
> > we are not FAT32 (FAT16 and FAT12 do not have the FSINFO block) or if w=
e are in
> > R/O mode.
> >
> > As a bonus, we can also remove the '->sync_fs()' and '->write_super()' =
FAT
> > call-back function because they become unneeded.
>=20
> Hm, does this guarantee to flush FSINFO at umount?

Of course, and I checked it. It is just a dirty inode. If you do not
worry that any other inode won't get written-beck, then you should not
worry about this one.

> FSINFO is last part of data dependency. I.e. inode change can dirty
> FSINFO. So, FSINFO has to be flushed after normal inodes.

Sorry, I do not see how this can be true. You have a just bunch of dirty
inodes, and it does not matter in which order you flush them. See
__fat_write_inode() - it does not change the FAT table and does not
affect the FSINFO block.

Besides, the _current_ code first writes out FSINFO, because VFS calls
->sync_fs() first, then it starts writing back, then VFS calls
->sync_fs() for the second time.

--=20
Best Regards,
Artem Bityutskiy

--=-hw0t7TMzuXujmRHHTJBE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJPiVGRAAoJEJtuLFy+q7feb10H/RfsZYgScFxp6ARRmhRyPQqM
RWp9eV4I1ernB/DXaT0ERud8w7I0jlJv9b/9F2/vmm4FnogngEgDT/ojYe7Os4ce
V9usr3er9U9KGYO06GSz8XMcrwaIjdvcaTcGpqD9eXL3y8Vqsw1a6ZrkTNz8FRWl
kiKYWdBstWK3a1uuFFlX2Gg1nB+c9VOrjz4wJSlumV0FT/mlENUj9eK9y8tRDoRF
rgeKZ5Vpa1gTnvcPSpnc3Y+TUU62mFcpMehOSxIqLg3c0D9VdYh1Y1OVHaRhaL6O
OdFzcniQR8PYvXEyFDbOAItpAsVJyF2x/u2wauhsd23bqXtF7IoeURNUITXk/zM=
=M/tv
-----END PGP SIGNATURE-----

--=-hw0t7TMzuXujmRHHTJBE--


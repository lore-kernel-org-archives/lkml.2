Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab2FQVUO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 17:20:14 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56116 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473Ab2FQVUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 17:20:11 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: jdow <jdow@earthlink.net>
Subject: Re: Partitions: Amiga RDB partition on 2 TB disk way too big, while OK in AmigaOS 4.1
Date: Sun, 17 Jun 2012 23:20:10 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.3; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-m68k@vger.kernel.org
References: <201206170841.20222.Martin@lichtvoll.de> <CAMuHMdWY7=2nJDUjQFGPhdOAFGYeUsnvgPcaEvB2Gxf7P=E+Ug@mail.gmail.com> <4FDE46E4.7020009@earthlink.net> (sfid-20120617_231310_643468_CCA19A89)
In-Reply-To: <4FDE46E4.7020009@earthlink.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Kok3PEFIXH4xOZi"
Message-Id: <201206172320.10272.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_Kok3PEFIXH4xOZi
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Am Sonntag, 17. Juni 2012 schrieb jdow:
> On 2012/06/17 09:36, Geert Uytterhoeven wrote:
> > On Sun, Jun 17, 2012 at 2:58 PM, Martin Steigerwald=20
<Martin@lichtvoll.de> wrote:
> >> Am Sonntag, 17. Juni 2012 schrieb jdow:
> >> | JXFS 64 bit file system
> >> |=20
> >> | With AmigaOS 4.x a new file system has been introduced called
> >> | JXFS. It is a totally new 64 bit file system that supports
> >> | partitions up to 16 TB in size. It is a modern journalling file
> >> | system, which means that it reduces data loss if data writes to
> >> | the disk are interrupted. It is the fastest and most reliable
> >> | file system ever created for AmigaOS.
> >>=20
> >> http://www.amigaos.net/content/1/features
> >>=20
> >> Well I asked AmigaOS 4 developers about this issue as well. Lets see
> >> what they say about 2 TB limits.
> >=20
> > 16 TB =3D 2 TB * 8. Perhaps they increased the block size from 512 to
> > 4096?
> >=20
> > block/partitions/amiga.c reads the block size from
> > RigidDiskBlock.rdb_BlockBytes,
> > but after conversion to 512-byte blocks, all further calculations are
> > done on "int", so it will overflow for disks larger than 2 TiB.
> >=20
> > Note that in your profile-binary.img, the field is 0x200, i.e. 512
> > bytes per block,
> > so I'll have to get a deeper look into your RDB first...
[=E2=80=A6]
> Note that the work I did on the Linux RDB code eons ago took full
> cognizance of the physical and virtual block sizes.
[=E2=80=A6]
> I've asked Martin for a digital copy of his RDBs and what he thinks the
> partition(s) should look like. I should also be told whether the disk
> is supposed to be solely Amiga OSs or not. I gather it's not.

Its all in the bug report. profile-binary.img should be it.

Its small so I attach it.

Meanwhile I try to get the currently supported maximum disk size out from=20
the OS 4 developers. Maybe JXFS is playing tricks that other filesystems do=
=20
not play or simply has a different implementation.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--Boundary-00=_Kok3PEFIXH4xOZi
Content-Type: application/octet-stream;
  name="profile-binary.img"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="profile-binary.img"

UkRTSwAAAIDvabVYAAAABwAAAgAAAAAX/////wAAAAH/////////////////////////////////
/////////wTaAtkAAAAQAAAAAwAAAAEE2gLZAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAIDwAAACsE2gLYAAAAMAAAAAAAAAADAAAAAEhpdGFjaGkgICAg
ICAgTUwwMjIwRjMwUE1MNk8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQ
QVJUAAAAQFw7/bcAAAAHAAAAAgAAAAAAAAAAAAAAAAAAAAADTFZNAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAABMAAACAAAAAAAAAAAMAAAABAAAAEAAAAAIAAAAAAAAAAAAAACsD6AAr
AAAAZAAAAAF/////f////AAAAABMTlgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFBB
UlQAAABAWYwRjgAAAAcAAAADAAAAAAAAAAAAAAAAAAAAAANCQUsAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAEwAAAIAAAAAAAAAAAwAAAAEAAAAQAAAAAgAAAAAAAAAAA+gALASwACwA
ABOIAAAAAX////9////8AAAAAEpYRgQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUEFS
VAAAAEAHTcVfAAAAB/////8AAAAAAAAAAAAAAAAAAAAAB1RBVVNDSDIAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAATAAAAgAAAAAAAAAADAAAABAAAABAAAAACAAAAAAAAAAAEsAAtBNoC2AAA
B9AAAAABf////3////wAAAAARE9TAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=

--Boundary-00=_Kok3PEFIXH4xOZi--

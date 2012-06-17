Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124Ab2FQVGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 17:06:08 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:53260 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab2FQVGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 17:06:05 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Partitions: Amiga RDB partition on 2 TB disk way too big, while OK in AmigaOS 4.1
Date: Sun, 17 Jun 2012 23:06:02 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.3; x86_64; ; )
Cc: jdow <jdow@earthlink.net>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-m68k@vger.kernel.org
References: <201206170841.20222.Martin@lichtvoll.de> <201206171458.58462.Martin@lichtvoll.de> <CAMuHMdWY7=2nJDUjQFGPhdOAFGYeUsnvgPcaEvB2Gxf7P=E+Ug@mail.gmail.com> (sfid-20120617_225443_752860_DC66624F)
In-Reply-To: <CAMuHMdWY7=2nJDUjQFGPhdOAFGYeUsnvgPcaEvB2Gxf7P=E+Ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206172306.03202.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 17. Juni 2012 schrieb Geert Uytterhoeven:
> On Sun, Jun 17, 2012 at 2:58 PM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> > Am Sonntag, 17. Juni 2012 schrieb jdow:
> > | JXFS 64 bit file system
> > | 
> > | With AmigaOS 4.x a new file system has been introduced called JXFS.
> > | It is a totally new 64 bit file system that supports partitions up
> > | to 16 TB in size. It is a modern journalling file system, which
> > | means that it reduces data loss if data writes to the disk are
> > | interrupted. It is the fastest and most reliable file system ever
> > | created for AmigaOS.
> > 
> > http://www.amigaos.net/content/1/features
> > 
> > Well I asked AmigaOS 4 developers about this issue as well. Lets see
> > what they say about 2 TB limits.
> 
> 16 TB = 2 TB * 8. Perhaps they increased the block size from 512 to
> 4096?

I hope to get anything back from the AmigaOS 4 developers.

> block/partitions/amiga.c reads the block size from
> RigidDiskBlock.rdb_BlockBytes,
> but after conversion to 512-byte blocks, all further calculations are
> done on "int", so it will overflow for disks larger than 2 TiB.
> 
> Note that in your profile-binary.img, the field is 0x200, i.e. 512
> bytes per block,
> so I'll have to get a deeper look into your RDB first...

Okay, thanks!

I did not get any information regarding the current size limit yet.

Strangely on AmigaOS 4.1 all values seem to be fine except for the total
sectors value. 

And on Linux begin and end cylinders are correct, only size is off:

merkaba:~> amiga-fdisk -l /dev/sdb                         
Disk /dev/sdb: 3 heads, 16 sectors, 81396441 cylinders, RDB: 0
Logical Cylinders from 43 to 81396440, 24576  bytes/Cylinder 

Device     Boot Mount   Begin      End     Size   Pri  BBlks    System
/dev/sdb1       *        43   65536043   1572864024     0      0  Linux native
/dev/sdb2       *    65536044   78643244   314572824     0      0  [unknown]
/dev/sdb3       *    78643245   81396440   66076704     0      0  Amiga FFS Int.

But not only from the first, also of the second and third one it seems.

65536043 - 43 = 65536000

78643244 - 65536044 = 13107200

81396440 - 78643245 = 2753195

I would think that if there is a overflow it would already be in the cylinder
numbers.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

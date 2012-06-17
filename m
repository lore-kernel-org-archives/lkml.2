Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab2FQKuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 06:50:21 -0400
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:54416
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754727Ab2FQKuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 06:50:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=UJCmaF3czCkLZk1k27sTiGR9EdaZZRiIxCOmMBJlxrFembZKpCsIcZK2uw8yW9ZN;
  h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4FDDB667.4020609@earthlink.net>
Date: Sun, 17 Jun 2012 03:50:15 -0700
From: jdow <jdow@earthlink.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-m68k@vger.kernel.org
Subject: Re: Partitions: Amiga RDB partition on 2 TB disk way too big, while
 OK in AmigaOS 4.1
References: <201206170841.20222.Martin@lichtvoll.de>
In-Reply-To: <201206170841.20222.Martin@lichtvoll.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-ELNK-Trace: bb89ecdb26a8f9f24d2b10475b571120841c09a80b8d9eb6fdca9509bc252269d76c288a9a7904f8350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.127.11.14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll have to make time to look it over, considering I am more or less
the mommy of the RDBs. Now, 2TB may be a tad beyond the abilities of
the RDBs to express. Memory insists that the RDBs worked on either
BYTE or block counts. Your seeing a problem at 2TB suggests it really
stored bit counts. The numbers are supposed to be unsigned. And whether
the RDBs store values in blocks or BYTEs is immaterial when you get
down to it. (The RDBs do store the disk's actual and virtual block
sizes. The latter is what the filesystem uses.)

However, since C programs seek plus and minus in BYTEs you are stuck
with 31 bits worth of disk as your limit. That matches nicely with
your 31 bits. The RDBs should still be useful if you make sure to
plant them on block 1 or higher leaving block zero for other OSs and
you only use the first 2 TB for the Amiga OS files. (RDPrep and the
HDWrench library both exhibited a strong preference for starting the
RDB blocks on block 3 of the disk.)

{^_^}   Joanne Dow, yeah, that antique broad.

On 2012/06/16 23:41, Martin Steigerwald wrote:
> Hi Jens, hi Linux m68k developers,
>
> I reported that as
>
> https://bugzilla.kernel.org/show_bug.cgi?id=43511
>
> I will attach there some more debug data like binary copy of RDB and such.
>
> But maybe its easier to discuss here.
>
> I am not sure whether its an issue with Linux or an issue with the RDB
> format and disks with big sizes. But AFAIK RDB format is capable of
> handling 2 TB disks.
>
>
>
>
> With my 2 TB mixed Amiga/Linux backup disk, which I partioned under
> AmigaOS 4.0/1 with Media Toolbox I get the following in Linux:
>
>
> Jun 17 07:28:14 merkaba kernel: [30852.968978] sata_sil24 0000:05:00.0:
> enabling device (0000 -> 0003)
> Jun 17 07:28:14 merkaba kernel: [30852.969401] scsi9 : sata_sil24
> Jun 17 07:28:14 merkaba kernel: [30852.969533] ata10: SATA max UDMA/100
> host m128@0xf1c02000 port 0xf1c00000 irq 19
> Jun 17 07:28:16 merkaba kernel: [30855.163712] ata10: SATA link up 3.0
> Gbps (SStatus 123 SControl 0)
> Jun 17 07:28:16 merkaba kernel: [30855.165014] ata10.00: ATA-8: Hitachi
> HDS5C3020ALA632, ML6OA580, max UDMA/133
> Jun 17 07:28:16 merkaba kernel: [30855.165017] ata10.00: 3907029168
> sectors, multi 16: LBA48 NCQ (depth 31/32)
> Jun 17 07:28:16 merkaba kernel: [30855.166378] ata10.00: configured for
> UDMA/100
> Jun 17 07:28:16 merkaba kernel: [30855.166477] scsi 9:0:0:0: Direct-Access
> ATA      Hitachi HDS5C302 ML6O PQ: 0 ANSI: 5
> Jun 17 07:28:16 merkaba kernel: [30855.166653] sd 9:0:0:0: [sdb]
> 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
> Jun 17 07:28:16 merkaba kernel: [30855.166699] sd 9:0:0:0: [sdb] Write
> Protect is off
> Jun 17 07:28:16 merkaba kernel: [30855.166702] sd 9:0:0:0: [sdb] Mode
> Sense: 00 3a 00 00
> Jun 17 07:28:16 merkaba kernel: [30855.166726] sd 9:0:0:0: [sdb] Write
> cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Jun 17 07:28:16 merkaba kernel: [30855.200936]  sdb: RDSK (512) sdb1
> (LNX^@)(res 2 spb 1) sdb2 (JXF^D)(res 2 spb 1) sdb3 (DOS^C)(res 2 spb 4)
> Jun 17 07:28:16 merkaba kernel: [30855.200943] sdb: p1 size
> 18446744072560312368 extends beyond EOD, enabling native capacity
> Jun 17 07:28:16 merkaba kernel: [30855.201344]  sdb: RDSK (512) sdb1
> (LNX^@)(res 2 spb 1) sdb2 (JXF^D)(res 2 spb 1) sdb3 (DOS^C)(res 2 spb 4)
> Jun 17 07:28:16 merkaba kernel: [30855.201347] sdb: p1 size
> 18446744072560312368 extends beyond EOD, truncated
> Jun 17 07:28:16 merkaba kernel: [30855.201398] sdb: p2 start
> 18446744072560314432 is beyond EOD, truncated
> Jun 17 07:28:16 merkaba kernel: [30855.201400] sdb: p3 start
> 18446744073189460080 is beyond EOD, truncated
> Jun 17 07:28:16 merkaba kernel: [30855.201570] sd 9:0:0:0: [sdb] Attached
> SCSI disk
>
>
> The first partition seems to be way to big:
>
> merkaba:~#1> amiga-fdisk -l /dev/sdc
> Disk /dev/sdc: 3 heads, 16 sectors, 81396441 cylinders, RDB: 0
> Logical Cylinders from 43 to 81396440, 24576  bytes/Cylinder
>
> Device     Boot Mount   Begin      End     Size   Pri  BBlks    System
> /dev/sdc1       *        43   65536043   1572864024     0      0  Linux
> native
> /dev/sdc2       *    65536044   78643244   314572824     0      0
> [unknown]
> /dev/sdc3       *    78643245   81396440   66076704     0      0  Amiga
> FFS Int.
>
> (sdc2 is JXFS, a new filesystem in AmigaOS 4 that is not known to Linux
> yet)
>
>
> In cat /proc/partitions I get:
>
> merkaba:~> cat /proc/partitions
> major minor  #blocks  name
>
>   […]
>     8       16 1953514584 sdb
>     8       17 1953513552 sdb1
> merkaba:~>
>
>
> Thus the Debian Linux Kernel 3.4.1 I am using here, truncates the first
> oversized partition and has no space for the other, too, which therefore
> are inaccessible under Linux.
>
> I didn´t notice this initially, but it happened from the beginning, I have
> an old amiga-fdisk listing that is exactly the same.
>
> Amiga Mediatoolbox has a different oppinion on the partition layout:
>
> LVM aka sdc1: 1500 GByte, 43 to 65536043 cyl, size 65536001 Zylinder
> BAK aka sdc2: 300 GByte, 65536044 to 78643244 cyl, size 13107201 Zylinder
> TAUSCH2 aka sdc3: 63,016 GByte, 78643245 to  81396440 cyl, didn´t note the
> size here, but as far as I remember was okay as well
>
> But it seems to be confused about the whole size of the disk as well:
>
> Logical sizes:
>
> Blocks per cylinder: 48
> Cylinders: 81396441
> Sectors: -397938128
> Blocksize: 512
>
> The sectors seem overflowed.
>
> So it might be a problem with RDB and 2TB disks and nothing to do with
> Linux. But still on AmigaOS 4.1 I can access the two Amiga partitions
> after the Linux partition.
>
>
>
> I have another 500GB disk for backup up my Sam440ep AmigaOS 4.1 "Amiga", I
> plan to repartition the 2 TB disk as GPT anyway, but since MediaToolBox in
> AmigaOS 4.1 has a different meaning about the partioning and this can cause
> serious data loss, I think its good to look at it.
>
> I had a BTRFS filesystem that had some checksum errors. Maybe thats somehow
> related to this issue and AmigaOS and/or Linux overwrote something it
> shouldn´t have touched.
>
> I will report a bug with AmigaOS 4.1 developers as well to get more
> details.
>
>
> merkaba:~> cat /proc/version
> Linux version 3.4-trunk-amd64 (Debian 3.4.1-1~experimental.1)
> (debian-kernel@lists.debian.org) (gcc version 4.6.3 (Debian 4.6.3-1) ) #1
> SMP
> Wed Jun 6 10:34:53 CEST 2012
>
> Ciao,
>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab2FQK66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 06:58:58 -0400
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69]:35003 "EHLO
	elasmtp-mealy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754780Ab2FQK64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 06:58:56 -0400
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Jun 2012 06:58:56 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=hUAV01ciJPXLz/ry6zcq89t8XxJNKNhoxdBcsUOxHJLsPe4M4v9gr3Y00nI+aOme;
  h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <4FDDB714.2020005@earthlink.net>
Date: Sun, 17 Jun 2012 03:53:08 -0700
From: jdow <jdow@earthlink.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: Partitions: Amiga RDB partition on 2 TB disk way too big, while
 OK in AmigaOS 4.1
References: <201206171033.51625.Martin@lichtvoll.de>
In-Reply-To: <201206171033.51625.Martin@lichtvoll.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-ELNK-Trace: bb89ecdb26a8f9f24d2b10475b571120841c09a80b8d9eb616d46244ff0f08b215a7e2390362a40c350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.127.11.14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By the way, what did you use to setup the Amiga RDBs?

{^_^}   Joanne Dow

On 2012/06/17 01:33, Martin Steigerwald wrote:
> Sorry, forgot to keep Cc.
>
> I think I will keep the disk as is for a while. I just won´t plug it to
> the Amiga, since I have my Amiga backup on another dedicated
> disk and do not want to overwrite my Linux backups. So its available
> for testing for a while. It should be save as long as I use the disk
> in Linux only.
>
> For safety I will recreate all backups. I can checksum the BTRFS based
> backup partition for checksum errors, but fscking the other non
> BTRFS ones will only give a vague hint.
>
>
> Am Sonntag, 17. Juni 2012 schrieb Martin Steigerwald:
>> Hi Jens, hi Linux m68k developers,
>>
>> I reported that as
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=43511
>>
>> I will attach there some more debug data like binary copy of RDB and
>> such.
>>
>> But maybe its easier to discuss here.
>
> I think this one is pretty serious:
>
> merkaba:~> pvdisplay /dev/sdb1
>    --- Physical volume ---
>    PV Name               /dev/sdb1
>    VG Name               steigerwald
>    PV Size               1,82 TiB / not usable 4,08 MiB
>    Allocatable           yes
>    PE Size               4,00 MiB
>    Total PE              476931
>    Free PE               105731
>    Allocated PE          371200
>    PV UUID               ZXMECC-JAir-lX8Q-rLhS-W1cS-quwz-b3FXWp
>
> merkaba:~> vgdisplay steigerwald
>    --- Volume group ---
>    VG Name               steigerwald
>    System ID
>    Format                lvm2
>    Metadata Areas        2
>    Metadata Sequence No  7
>    VG Access             read/write
>    VG Status             resizable
>    MAX LV                0
>    Cur LV                5
>    Open LV               1
>    Max PV                0
>    Cur PV                1
>    Act PV                1
>    VG Size               1,82 TiB
>    PE Size               4,00 MiB
>    Total PE              476931
>    Alloc PE / Size       371200 / 1,42 TiB
>    Free  PE / Size       105731 / 413,01 GiB
>    VG UUID               uhjjE1-0yrD-Ch1A-d9qL-P5jY-UDXE-io4bpi
>
>
> with
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
>
> Due to truncating oversized partition instead of refusing to use
> them the PV and consequently VG span the whole disk instead
> of leaving space for the >350GB in the two other partitions:
>
> merkaba:~> cat /proc/partitions
> major minor  #blocks  name
>
>   […]
>     8       16 1953514584 sdb
>     8       17 1953513552 sdb1
>
> (now sdb instead of sdc back when I run amiga-fdisk)
>
>
> This is just asking for trouble. Thus:
>
> Bug 43521 - Amiga RDB partitions: truncates miscaluted partitions size
> instead of refusing to use it
> https://bugzilla.kernel.org/show_bug.cgi?id=43521
>
>
> My suggestion is to bail out if a partition size looks insane and
> impossible.
> Having to manually fix it up to access the data on disk still looks better
> to me than potentially overwriting lots of data.
>
>
>
> Until today I never actually did an Amiga backup to the disk, I just
> created the two Amiga partitions and copied some screenshots of them
> but that might be enough to explain the checksum errors I found in a
> BTRFS backup partition.
>
> I am now checking my Linux backups. They might be save, cause not all
> space on the volume group is used.
>
> See:
>
> kernel got struck while scrubbing BTRFS with node- and leafsize 32768
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg17108.html
>
> s/struck/stuck
>
> Thanks,
>


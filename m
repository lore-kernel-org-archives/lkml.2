Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab0LMXNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 18:13:09 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54284 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab0LMXNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 18:13:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=RHllv9YsOoqE+a2c7smBbdXUdgVZvCQvvolLua1TgFZzbXwp3Ks1POxayqyqkm3S59
         /5f7lawEdg8dheOUgyb18HCnbs7HmMKVTx9egSwwSqGbfQ+HNck4512KYXH03w/ikB7G
         HPURUw1Bxe6aLGfojIAMGH1D5mhkpact0Wur0=
MIME-Version: 1.0
Date: Mon, 13 Dec 2010 23:13:06 +0000
Message-ID: <AANLkTimCi1ek0qXCkp7kmszLUsJkvzJGXOm63Sm75xtQ@mail.gmail.com>
Subject: ext4: initial error at 1288471943: ext4_mb_generate_buddy:718
From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I'm running 2.6.36 and I'm seeing this about once per day in dmesg:

EXT4-fs (dm-0): error count: 1
EXT4-fs (dm-0): initial error at 1288471943: ext4_mb_generate_buddy:718
EXT4-fs (dm-0): last error at 1288471943: ext4_mb_generate_buddy:718

uptime && dmesg | grep ' last error at 1288471943' | wc -l
 23:08:29 up 20 days,  5:46,  1 user,  load average: 0.69, 0.85, 0.83

e2fsprogs 1.41.12-1
lvm2 2.02.78-1

As you can see it's always the exact same message. I've run fsck on
the system and no errors were found. dm-0 is the root filesystem, it
all looks like this:


lrwxrwxrwx 1 root root 7 Nov 23 17:22 /dev/mapper/lvmssd-root -> ../dm-0

  --- Volume group ---
  VG Name               lvmssd
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  27
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               53.80 GiB
  PE Size               4.00 MiB
  Total PE              13772
  Alloc PE / Size       13772 / 53.80 GiB
  Free  PE / Size       0 / 0
  VG UUID               4jqUcB-jEzl-pKT1-mcPU-soCV-2YXT-cuTk9v

...

 hdparm -i /dev/sda

/dev/sda:

 Model=Corsair CSSD-F60GB2, FwRev=1.1, SerialNo=10326505580009990027
 Config={ Fixed }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
 BuffType=unknown, BuffSize=unknown, MaxMultSect=16, MultSect=1
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=117231408
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4
 DMA modes:  mdma0 mdma1 mdma2
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6
 AdvancedPM=no WriteCache=enabled
 Drive conforms to: unknown:  ATA/ATAPI-2,3,4,5,6,7

 * signifies the current active mode

Is this message dangerous? Can I disable it somehow? Why is it showing up? Etc.


Thanks,
// Mathias

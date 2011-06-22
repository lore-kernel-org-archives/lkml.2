Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab1FVOVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:21:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64740 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab1FVOVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:21:32 -0400
Message-ID: <4E01FA5A.1020307@aktendiener.de>
Date: Wed, 22 Jun 2011 16:21:14 +0200
From: Johannes Wiedersich <debian@aktendiener.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110606 Icedove/3.1.10
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>, 631255@bugs.debian.org
Subject: Re: 3.0-rc3: kernel BUG at fs/inode.c:1368!
References: <20110622063624.7374.9343.reportbug@johannes4.fritz.box> <1308750980.3093.470.camel@localhost>
In-Reply-To: <1308750980.3093.470.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:9MbsMVU8yy6ZD4/RmvmzBsQH2Ka/hl2Vcv1xW6zqWBB
 VxQUQpitXRqA0ILaWOle2gB4UwNmiEBOir6GTgOECcnPIK+tG+
 Z4rUw9By1N7UB6Iky/5BRmfjob/Gyb5+fcW+ueZGuZWZ/RPQ39
 Wxt12nGrzOuKXhPOSDFcDkHnU+2onLVm1Z8cauTv6uo40wDbUJ
 quFpav0U2zlsnplcIrqCCkibgi0D0GcmmeXQ3SH3QI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-22 15:56, Ben Hutchings wrote:
> On Wed, 2011-06-22 at 08:36 +0200, Johannes Wiedersich wrote:
>> Package: linux-2.6
>> Version: 3.0.0~rc3-1~experimental.1
>> Severity: important
>>
>>
>> aptitude installing a package triggers a kernel oops. I have no idea,
>> what part of the installation process is to blame, but could try to
>> reproduce, if I would get further instructions. 
> [...]
> 
> I assume you haven't seen a similar crash in earlier versions?

No, linux-image-2.6.39-2-amd64 and linux-image-2.6.38-2-amd64 from
testing and unstable are fine, while I could reproduce this behaviour
for 3.0.0~rc3-1.

> Also, what type of filesystem where you installing on
> (ext3/ext4/btrfs/xfs...)?

$ mount
/dev/mapper/johannes--fast-root--amd64 on / type ext4
(rw,errors=remount-ro,commit=0)
/dev/sdb1 on /boot type ext2 (rw)

Some snippets from vgdisplay and lvdisplay:

/===================16:17:19-root@johannes4:~# vgdisplay
  --- Volume group ---
  VG Name               johannes-fast
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  4
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                3
  Open LV               2
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               74.29 GiB
  PE Size               4.00 MiB
  Total PE              19018
  Alloc PE / Size       19018 / 74.29 GiB
  Free  PE / Size       0 / 0
  VG UUID               YmvwSc-BDlh-YaXC-ac8z-98mo-5tMG-i27v6b

  --- Volume group ---
  VG Name               johannes4

[....]

16:17:22-root@johannes4:~# lvdisplay
  --- Logical volume ---
  LV Name                /dev/johannes-fast/root-amd64
  VG Name                johannes-fast
  LV UUID                nOzLXl-960W-3zX2-8m7b-A7iH-FWbG-H6j77T
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                18.62 GiB
  Current LE             4768
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:0

  --- Logical volume ---
  LV Name                /dev/johannes-fast/home-fast
  VG Name                johannes-fast
  LV UUID                PSStvE-11cT-VXRJ-K7xM-U9sY-fRN3-s2A6Yu
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                46.56 GiB
  Current LE             11920
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:2

[...]

  --- Logical volume ---
  LV Name                /dev/johannes4/swap_1
  VG Name                johannes4
  LV UUID                b4HIrg-u4Ui-mUp1-7VMg-6LFA-0fFC-jTMCFT
  LV Write Access        read/write
  LV Status              available
  # open                 2
  LV Size                5.64 GiB
  Current LE             1443
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           254:1


\==============================================================

> 
> Forwarding this to LKML.

Thanks!

Johannes

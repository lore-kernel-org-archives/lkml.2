Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab1FFJ7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 05:59:13 -0400
Received: from mail.wdtv.com ([66.118.69.84]:39870 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571Ab1FFJ7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 05:59:08 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: Lars =?utf-8?q?T=C3=A4uber?= <taeuber@bbaw.de>
Subject: Re: [PROBLEM] reproduceable storage errors on high IO load
Date: Mon, 6 Jun 2011 05:59:02 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.38.8-pclos1.pae.bfs; KDE/4.6.3; i686; ; )
References: <20110606095127.21d23a70.taeuber@bbaw.de>
In-Reply-To: <20110606095127.21d23a70.taeuber@bbaw.de>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201106060559.03131.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 06, 2011, Lars Täuber wrote:
>Hallo!
>
>This is a message originally sent to linux-scsi.
>I got no reply so I think this was the wrong ML.
>Please tell me if I should send more specific information about
>something. Since january I struggle with this problem. It prevents me
>from running a backup server productively.
>
>Thank you.
>Lars
>
>
>
>Hi there,
>
>I have a problem with a SW-RAID6. It is reproduceable also after changing
>the hole hardware. I startet with a Suse 11.2. The problem occured
>during writing much data to the array (high io load). This is hopefully
>the right ML for my problem. Otherwise please excuse me and point me the
>the right ML.
>
>
>Then I changed the PSU. Still errors on high load.
>Then I changed the sata controller (Sil 3114 - sata_sil) with one with a
>different chipset (driver: sata_mv). Still errors on high load. Then I
>changed the disk enclosure and all cables. Still errors.
>Then I changed the mainboard (tyan opteron) with one from supermicro
>(H8SCM-F) with 6-core opteron. Still errors. Then I changed to ubuntu
>10.04 -> 10.10. Still errors
>Then I tried different schedulars (noop,anticipatory,cfq,deadline). Still
>errors. Then I tried kernel options: noapic + acpi=off without luck.
>Then I changed the sata controller with a areca sas (driver: mvsas).
>Still errors. Then I tried some different hdds (orig: Western Digital
>WDC WD2002FYPS + WDC WD2003FYYS; new: Seagate ST3320620NS). Still
>errors. Then I tried some different kernel versions from ubuntu without
>luck: 2.6.32-22-server
>2.6.35-25-server
>
>Then I tried self compiled kernels without luck:
>2.6.35.13
>2.6.38.6
>2.6.39: same problem occurs but later
>
>The current configuration:
>- tested only 64-bit kernels
>- Supermicro H8SCM-F (AMD SR5650+SP5100) with 6-core opteron
>- Areca (non-raid) ARC-1300ix-16 sas controller
>- SW-RAID6 over 8 Western Digital HDDs (sone WDC WD2002FYPS + some WDC
>WD2003FYYS) - redundant PSU
>
>How to reproduce my problem:
>mdadm -C /dev/md3 -l6 -n8 /dev/sd[c-h] missing missing
>(the two missing hdds prevent this raid from initial sync)
>
>Everything is just fine till yet.
>Now produce high io-load:
>mke2fs -j /dev/md3
>
>The detailed history (search for Lars to get my posts):
>https://bugs.launchpad.net/ubuntu/+bug/550559
>
>The error messages changed a bit during the kernel versions.
>The nearly complete dmesg output:
>https://launchpadlibrarian.net/72325163/20110524.dmesg.out
>
>Is there something I do wrong? Could someone help me to debug this?
>Thanks
>Lars

Looking at your dmesg, I get the impression you have a bunch of disks that 
are in need of a firmware update.  Unforch, the dmesg snippet does not 
include the drive discovery and identification data.

However, I would back that data up to another medium before I did that as I 
had the seagate firmware update scramble the blkid's and partition names of 
one of two 1Tb drives I have.  Neither drive errors now, but the read/write 
speeds for the 2nd identical drive are about 1/3rd the rate of the first.

Firmware updates are in the form of a bootable cd .iso, and you can 
download the cd image from the makers site.

Cheers, gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Eisenhower!!  Your mimeograph machine upsets my stomach!!

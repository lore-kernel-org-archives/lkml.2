Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab0FWRIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:08:36 -0400
Received: from fep15.mx.upcmail.net ([62.179.121.35]:45185 "EHLO
	fep15.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab0FWRId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:08:33 -0400
X-SourceIP: 77.57.188.152
Message-ID: <4C223F8A.9030306@odi.ch>
Date: Wed, 23 Jun 2010 19:08:26 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100415 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ata link not reset properly
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=BX1z5e3lS7RAKjOkUI/uDpZ/pP4xz0N/VImyOZX9Sfk= c=1 sm=0 a=wbKXeunVgZ0A:10 a=8nJEP1OIZ-IA:10 a=VwQbUJbxAAAA:8 a=9c7KVfinEksGT300a6wA:9 a=AVt-N3lzlmrR1_8V0D0A:7 a=NnBWPXawONcSlpL_YZHqTq5LGfYA:4 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From time to time this nVidia SATA controller chokes on a FLUSH CACHE.

1. why does the kernel not try to HARD reset the link?
2. it would be nice to have the possibility to manually force a (hard) reset or
to re-initialize the device. Other than rebooting I mean :-)

Thanks.
  Ortwin

Kernel is basically a 2.6.32.8 with a cherry picked fix:
http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob;f=queue-2.6.33/enable-retries-for-syncronize_cache-commands-to-fix-i-o-error.patch;h=2401e54b05502803889d4ece2afefc3e2b64995f;hb=117d7c078957b2e200e3fcf06c182422366764b0

Jun 23 12:06:48 gollum kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0
action 0x6 frozen
Jun 23 12:06:48 gollum kernel: ata2.00: failed command: FLUSH CACHE
Jun 23 12:06:48 gollum kernel: ata2.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0
tag 0
Jun 23 12:06:48 gollum kernel: res 40/00:01:00:00:00/00:00:00:00:00/a0 Emask 0x4
(timeout)
Jun 23 12:06:48 gollum kernel: ata2.00: status: { DRDY }
Jun 23 12:06:53 gollum kernel: ata2: link is slow to respond, please be patient
(ready=0)
Jun 23 12:06:53 gollum kernel: ata2: link is slow to respond, please be patient
(ready=0)
Jun 23 12:07:59 gollum kernel: ata2: device not ready (errno=-16), forcing hardreset
Jun 23 12:07:59 gollum kernel: ata2: device not ready (errno=-16), forcing hardreset
Jun 23 12:07:59 gollum kernel: ata2: soft resetting link
Jun 23 12:07:59 gollum kernel: ata2: soft resetting link
Jun 23 12:07:59 gollum kernel: ata2: link is slow to respond, please be patient
(ready=0)
Jun 23 12:07:59 gollum kernel: ata2: link is slow to respond, please be patient
(ready=0)
Jun 23 12:07:59 gollum kernel: ata2: SRST failed (errno=-16)
Jun 23 12:07:59 gollum kernel: ata2: soft resetting link
Jun 23 12:07:59 gollum kernel: ata2: soft resetting link
Jun 23 12:07:59 gollum kernel: ata2: link is slow to respond, please be patient
(ready=0)
Jun 23 12:07:59 gollum kernel: ata2: link is slow to respond, please be patient
(ready=0)
Jun 23 12:07:59 gollum kernel: ata2: SRST failed (errno=-16)
Jun 23 12:07:59 gollum kernel: ata2: soft resetting link
Jun 23 12:07:59 gollum kernel: ata2: soft resetting link
Jun 23 12:07:59 gollum kernel: ata2: link is slow to respond, please be patient
(ready=0)
Jun 23 12:07:59 gollum kernel: ata2: link is slow to respond, please be patient
(ready=0)
Jun 23 12:07:59 gollum kernel: ata2: SRST failed (errno=-16)
Jun 23 12:07:59 gollum kernel: ata2: soft resetting link
Jun 23 12:07:59 gollum kernel: ata2: soft resetting link
Jun 23 12:07:59 gollum kernel: ata2: SRST failed (errno=-16)
Jun 23 12:07:59 gollum kernel: ata2: reset failed, giving up
Jun 23 12:07:59 gollum kernel: ata2.00: disabled
Jun 23 12:07:59 gollum kernel: ata2.00: disabled
Jun 23 12:07:59 gollum kernel: ata2.01: disabled
Jun 23 12:07:59 gollum kernel: ata2.01: disabled
Jun 23 12:07:59 gollum kernel: ata2.00: device reported invalid CHS sector 0
Jun 23 12:07:59 gollum kernel: ata2.00: device reported invalid CHS sector 0
Jun 23 12:07:59 gollum kernel: ata2: EH complete
Jun 23 12:07:59 gollum kernel: ata2: EH complete
Jun 23 12:07:59 gollum kernel: end_request: I/O error, dev sdb, sector 58604962
Jun 23 12:07:59 gollum kernel: md: super_written gets error=-5, uptodate=0
Jun 23 12:07:59 gollum kernel: md: super_written gets error=-5, uptodate=0
Jun 23 12:07:59 gollum kernel: raid1: Disk failure on sdb3, disabling device.
Jun 23 12:07:59 gollum kernel: raid1: Operation continuing on 1 devices.
Jun 23 12:07:59 gollum kernel: RAID1 conf printout:
Jun 23 12:07:59 gollum kernel: RAID1 conf printout:
Jun 23 12:07:59 gollum kernel: --- wd:1 rd:2
Jun 23 12:07:59 gollum kernel: --- wd:1 rd:2
Jun 23 12:07:59 gollum kernel: disk 0, wo:0, o:1, dev:sda3
Jun 23 12:07:59 gollum kernel: disk 0, wo:0, o:1, dev:sda3
Jun 23 12:07:59 gollum kernel: disk 1, wo:1, o:0, dev:sdb3
Jun 23 12:07:59 gollum kernel: disk 1, wo:1, o:0, dev:sdb3
Jun 23 12:07:59 gollum kernel: RAID1 conf printout:
Jun 23 12:07:59 gollum kernel: RAID1 conf printout:
Jun 23 12:07:59 gollum kernel: --- wd:1 rd:2
Jun 23 12:07:59 gollum kernel: --- wd:1 rd:2
Jun 23 12:07:59 gollum kernel: disk 0, wo:0, o:1, dev:sda3
Jun 23 12:07:59 gollum kernel: disk 0, wo:0, o:1, dev:sda3


lspci:
00:1e.0 PCI bridge: nVidia Corporation nForce2 AGP (rev c1)
00:1e.0 0604: 10de:01e8 (rev c1)

ATA initialization:
Jun 23 18:46:38 gollum kernel: ata2.00: ATA-5: IC25N030ATCS04-0, CA3OA71A, max
UDMA/100
Jun 23 18:46:38 gollum kernel: ata2.00: ATA-5: IC25N030ATCS04-0, CA3OA71A, max
UDMA/100
Jun 23 18:46:38 gollum kernel: ata2.00: 58605120 sectors, multi 16: LBA
Jun 23 18:46:38 gollum kernel: ata2.00: 58605120 sectors, multi 16: LBA
Jun 23 18:46:38 gollum kernel: ata2.01: ATAPI: Pioneer DVD-ROM ATAPIModel
DVD-115  0127, E1.27, max UDMA/33
Jun 23 18:46:38 gollum kernel: ata2.01: ATAPI: Pioneer DVD-ROM ATAPIModel
DVD-115  0127, E1.27, max UDMA/33
Jun 23 18:46:38 gollum kernel: ata2: nv_mode_filter: 0x3f39f&0x3f39f->0x3f39f,
BIOS=0x3f000 (0xc700c6c0) ACPI=0x3f01f (20:60:0x1f)
Jun 23 18:46:38 gollum kernel: ata2: nv_mode_filter: 0x739f&0x739f->0x739f,
BIOS=0x7000 (0xc700c6c0) ACPI=0x701f (20:60:0x1f)
Jun 23 18:46:38 gollum kernel: ata2.00: configured for UDMA/100
Jun 23 18:46:38 gollum kernel: ata2.00: configured for UDMA/100
Jun 23 18:46:38 gollum kernel: ata2.01: configured for UDMA/33
Jun 23 18:46:38 gollum kernel: ata2.01: configured for UDMA/33
Jun 23 18:46:38 gollum kernel: scsi 1:0:0:0: Direct-Access     ATA
IC25N030ATCS04-0 CA3O PQ: 0 ANSI: 5
Jun 23 18:46:38 gollum kernel: scsi 1:0:0:0: Direct-Access     ATA
IC25N030ATCS04-0 CA3O PQ: 0 ANSI: 5
Jun 23 18:46:38 gollum kernel: sd 1:0:0:0: [sdb] 58605120 512-byte logical
blocks: (30.0 GB/27.9 GiB)
Jun 23 18:46:38 gollum kernel: sd 1:0:0:0: [sdb] 58605120 512-byte logical
blocks: (30.0 GB/27.9 GiB)
Jun 23 18:46:38 gollum kernel: sd 1:0:0:0: [sdb] Write Protect is off
Jun 23 18:46:38 gollum kernel: sd 1:0:0:0: [sdb] Write Protect is off
Jun 23 18:46:38 gollum kernel: sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Jun 23 18:46:38 gollum kernel: sd 1:0:0:0: [sdb] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Jun 23 18:46:38 gollum kernel: sd 1:0:0:0: [sdb] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Jun 23 18:46:38 gollum kernel: sdb:
Jun 23 18:46:38 gollum kernel: sdb:
Jun 23 18:46:38 gollum kernel: sd 1:0:0:0: Attached scsi generic sg1 type 0
Jun 23 18:46:38 gollum kernel: sd 1:0:0:0: Attached scsi generic sg1 type 0
Jun 23 18:46:38 gollum kernel: sdb1 sdb2 sdb3
Jun 23 18:46:38 gollum kernel: sdb1 sdb2 sdb3
Jun 23 18:46:38 gollum kernel: scsi 1:0:1:0: CD-ROM            PIONEER  DVD-ROM
DVD-115F 1.27 PQ: 0 ANSI: 5
Jun 23 18:46:38 gollum kernel: scsi 1:0:1:0: CD-ROM            PIONEER  DVD-ROM
DVD-115F 1.27 PQ: 0 ANSI: 5
Jun 23 18:46:38 gollum kernel: sd 1:0:0:0: [sdb] Attached SCSI disk
Jun 23 18:46:38 gollum kernel: sd 1:0:0:0: [sdb] Attached SCSI disk

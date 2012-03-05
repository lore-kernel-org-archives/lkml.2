Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab2CEAQH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 19:16:07 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:34883 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab2CEAQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 19:16:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jackdachef@gmail.com designates 10.224.105.203 as permitted sender) smtp.mail=jackdachef@gmail.com; dkim=pass header.i=jackdachef@gmail.com
MIME-Version: 1.0
Date: Mon, 5 Mar 2012 01:16:03 +0100
Message-ID: <CAG-aW058YL042Q-Wkw3RpD_XmK3_Q+3uL1zmq6jX8iZTWfeX6Q@mail.gmail.com>
Subject: eSATA hotplug (subsequent harddrives after disconnecting 1st one) not
 working with JMicron after transition from 3.2 to 3.3
From: Matt <jackdachef@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
        jeff@garzik.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

hi everyone!


I'm going to make this short:

nobody seems to have mentioned this issue:

when connecting an eSATA-harddrive to the JMicron-Port (there are 2
eSATA-connections at the back of my computer) for the ***1st time***


03:00.0 SATA controller: JMicron Technology Corp. JMB362/JMB363 Serial
ATA Controller (rev 03)
	Subsystem: Acer Incorporated [ALI] Device 036b
	Kernel driver in use: ahci
03:00.1 IDE interface: JMicron Technology Corp. JMB362/JMB363 Serial
ATA Controller (rev 03)

the drive is recognized correctly and works.

After disconnecting it - no matter how:
- sdparm -C stop -r /dev/foo
- hdparm -Y /dev/foo
- simply syncing, umounting and disconnecting the cable

AFTER that - the following harddrives aren't recognized in 3.3*
kernels (afaik I saw this with 3.3-rc4, 3.3-rc5 and 3.3-rc6).

resulting in something like the following (similar output from 3.3-rc5
and 3.3-rc6 I tested):


[  165.204810] ata8: exception Emask 0x10 SAct 0x0 SErr 0x4050000
action 0xe frozen
[  165.204815] ata8: irq_stat 0x00400040, connection status changed
[  165.204820] ata8: SError: { PHYRdyChg CommWake DevExch }
[  165.204828] ata8: hard resetting link
[  175.186937] ata8: softreset failed (1st FIS failed)
[  175.186942] ata8: hard resetting link
[  178.355501] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  178.415668] ata8.00: ATA-8: ST31000340NS, SN06, max UDMA/133
[  178.415674] ata8.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[  178.458053] ata8.00: configured for UDMA/133
[  178.458065] ata8: EH complete
[  178.458173] scsi 7:0:0:0: Direct-Access     ATA      ST31000340NS
  SN06 PQ: 0 ANSI: 5
[  178.458425] sd 7:0:0:0: Attached scsi generic sg6 type 0
[  178.458517] sd 7:0:0:0: [sde] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[  178.458966] sd 7:0:0:0: [sde] Write Protect is off
[  178.458972] sd 7:0:0:0: [sde] Mode Sense: 00 3a 00 00
[  178.459024] sd 7:0:0:0: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  178.786470]  sde: unknown partition table
[  178.786845] sd 7:0:0:0: [sde] Attached SCSI disk
[  195.701008] device fsid xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx devid 1
transid 764 /dev/mapper/foo
[  195.701560] btrfs: use zlib compression
[  195.701568] btrfs: enabling inode map caching
[  195.701571] btrfs: not using ssd allocation scheme
[  195.701573] btrfs: disk space caching is enabled
[ 1097.511452] ata8: exception Emask 0x10 SAct 0x0 SErr 0x990000
action 0xe frozen
[ 1097.511457] ata8: irq_stat 0x00400000, PHY RDY changed
[ 1097.511462] ata8: SError: { PHYRdyChg 10B8B Dispar LinkSeq }
[ 1097.511469] ata8: hard resetting link
[ 1098.232718] ata8: SATA link down (SStatus 0 SControl 300)
[ 1103.224210] ata8: hard resetting link
[ 1103.528529] ata8: SATA link down (SStatus 0 SControl 300)
[ 1103.528543] ata8: limiting SATA link speed to 1.5 Gbps
[ 1108.519909] ata8: hard resetting link
[ 1108.824385] ata8: SATA link down (SStatus 0 SControl 310)
[ 1108.824397] ata8.00: disabled
[ 1108.824413] ata8: EH complete
[ 1108.824422] ata8.00: detaching (SCSI 7:0:0:0)
[ 1108.824945] sd 7:0:0:0: [sde] Synchronizing SCSI cache
[ 1108.824979] sd 7:0:0:0: [sde]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[ 1108.824985] sd 7:0:0:0: [sde] Stopping disk
[ 1108.824994] sd 7:0:0:0: [sde] START_STOP FAILED
[ 1108.824997] sd 7:0:0:0: [sde]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
<== that's actually the output after the 1st drive got disconnected

normally it should do some "hard resetting link", "SATA link down",
etc. stuff - from experience
but it doesn't afterwards




in contrast to that with 3.2.7 (3.2.0 also worked) I get:

[37019.604474] ata8: exception Emask 0x10 SAct 0x0 SErr 0x4050000
action 0xe frozen
[37019.604479] ata8: irq_stat 0x00400040, connection status changed
[37019.604484] ata8: SError: { PHYRdyChg CommWake DevExch }
[37019.604492] ata8: hard resetting link
[37029.594133] ata8: softreset failed (device not ready)
[37029.594138] ata8: hard resetting link
[37033.016254] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[37033.022865] ata8.00: ATA-7: SAMSUNG HD154UI, 1AG01118, max UDMA7
[37033.022871] ata8.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[37033.029703] ata8.00: configured for UDMA/133
[37033.029816] ata8: EH complete
[37033.029931] scsi 7:0:0:0: Direct-Access     ATA      SAMSUNG
HD154UI  1AG0 PQ: 0 ANSI: 5
[37033.030211] sd 7:0:0:0: Attached scsi generic sg6 type 0
[37033.030498] sd 7:0:0:0: [sde] 2930277168 512-byte logical blocks:
(1.50 TB/1.36 TiB)
[37033.030829] sd 7:0:0:0: [sde] Write Protect is off
[37033.030835] sd 7:0:0:0: [sde] Mode Sense: 00 3a 00 00
[37033.030934] sd 7:0:0:0: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[37033.295423]  sde: unknown partition table
[37033.295958] sd 7:0:0:0: [sde] Attached SCSI disk
[37049.934934] XFS (dm-5): Mounting Filesystem
[37050.227741] XFS (dm-5): Ending clean mount
[42210.895611] ata8: exception Emask 0x10 SAct 0x0 SErr 0x990000
action 0xe frozen
[42210.895616] ata8: irq_stat 0x00400000, PHY RDY changed
[42210.895621] ata8: SError: { PHYRdyChg 10B8B Dispar LinkSeq }
[42210.895629] ata8: hard resetting link
[42211.617334] ata8: SATA link down (SStatus 0 SControl 300)
[42216.608708] ata8: hard resetting link
[42216.913199] ata8: SATA link down (SStatus 0 SControl 300)
[42216.913213] ata8: limiting SATA link speed to 1.5 Gbps
[42221.904576] ata8: hard resetting link
[42222.209073] ata8: SATA link down (SStatus 0 SControl 310)
[42222.209086] ata8.00: disabled
[42222.209103] ata8: EH complete
[42222.209112] ata8.00: detaching (SCSI 7:0:0:0)
[42222.209536] sd 7:0:0:0: [sde] Synchronizing SCSI cache
[42222.209581] sd 7:0:0:0: [sde]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[42222.209586] sd 7:0:0:0: [sde] Stopping disk
[42222.209602] sd 7:0:0:0: [sde] START_STOP FAILED
[42222.209605] sd 7:0:0:0: [sde]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[42261.075981] ata8: exception Emask 0x10 SAct 0x0 SErr 0x4040000
action 0xe frozen
[42261.075986] ata8: irq_stat 0x00000040, connection status changed
[42261.075991] ata8: SError: { CommWake DevExch }
[42261.075999] ata8: limiting SATA link speed to 1.5 Gbps
[42261.076004] ata8: hard resetting link
[42271.065824] ata8: softreset failed (device not ready)
[42271.065829] ata8: hard resetting link
[42274.437026] ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[42274.457828] ata8.00: ATA-8: WDC WD1001FALS-00J7B0, 05.00K05, max UDMA/133
[42274.457834] ata8.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[42274.459131] ata8.00: configured for UDMA/133
[42274.459143] ata8: EH complete
[42274.459256] scsi 7:0:0:0: Direct-Access     ATA      WDC
WD1001FALS-0 05.0 PQ: 0 ANSI: 5
[42274.459446] sd 7:0:0:0: Attached scsi generic sg6 type 0
[42274.459561] sd 7:0:0:0: [sde] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[42274.460043] sd 7:0:0:0: [sde] Write Protect is off
[42274.460049] sd 7:0:0:0: [sde] Mode Sense: 00 3a 00 00
[42274.460193] sd 7:0:0:0: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[42274.470058]  sde: unknown partition table
[42274.470335] sd 7:0:0:0: [sde] Attached SCSI disk



I had some detection-issues or link-reset issues in the past but that
most probably was due to a faulty cable which got replaced meanwhile.


But this issue right now is sort of insurmountable for me


I tried commands to trigger rescan but it seemingly didn't help (don't
know if I used it on the correct ports but I tried several and it made
no change - so that most likely also doesn't work)
if you can show me the corresponding & correct commands I'd be glad to
test them out whether it made a change


since the 3.3 gives me some noticably better responsiveness during
heavy I/O (rsync backup, load, etc.) I'd prefer to continue using that

but it's kinda painful having to restart the computer after every
eSATA backup when there are several in queue


Hope I CC'ed the right persons for this

Does this ring a bell for anyone ?

Bisecting unfortunately for me is not an option since I need this box
all day & night long for productivity - so I hope that this draws some
more attention on this issue
and other users & testers with same controller can test this out, too

Testing a few patches & changes should be no problem though



Many thanks in advance for your help

Kind Regards

Matt

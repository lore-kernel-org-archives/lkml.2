Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076Ab2H3EjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 00:39:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51946 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2H3EjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 00:39:15 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 29 Aug 2012 21:38:52 -0700
Message-ID: <CALCETrW-LFzcHYgx=thQiuTfU8RdRBrtXwE7QboWpNrjz4An4A@mail.gmail.com>
Subject: Which disk is ata4?
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of my disks went out to lunch for a while.  Logs below.

Which one is it?  The only useful thing in /sys/class/ata_port/ata4 is
the device symlink, which points at
/sys/devices/pci0000:00/0000:00:1f.2/ata4.  That, in turn, has an
ata_port directory (contains nothing I don't already know) and a link4
directory.  The ata_link directory is unhelpful, as is
/sys/devices/pci0000:00/0000:00:1f.2/ata4/link4/dev4.0/ata_device/dev4.0.

Taking a leap of faith, /sys/devices/pci0000:00/0000:00:1f.2 contains
ata1-6 and host0-5.  So maybe ata4 is host3.  Following lots of
symlinks through host3 leads me to the block device sdd.  Maybe that's
correct?  I'm really not sure.  Am I missing something obvious?

I even tried looking for symlinks the other way, like this:

/sys$ find -type l -exec echo -n {} ' ' \; -exec readlink {} \; |grep ata4
./devices/pci0000:00/0000:00:1f.2/ata4/ata_port/ata4/subsystem
../../../../../../class/ata_port
./devices/pci0000:00/0000:00:1f.2/ata4/ata_port/ata4/device  ../../../ata4
./devices/pci0000:00/0000:00:1f.2/ata4/link4/ata_link/link4/subsystem
../../../../../../../class/ata_link
./devices/pci0000:00/0000:00:1f.2/ata4/link4/ata_link/link4/device
../../../link4
./devices/pci0000:00/0000:00:1f.2/ata4/link4/dev4.0/ata_device/dev4.0/subsystem
 ../../../../../../../../class/ata_device
./devices/pci0000:00/0000:00:1f.2/ata4/link4/dev4.0/ata_device/dev4.0/device
 ../../../dev4.0
./class/ata_link/link4
../../devices/pci0000:00/0000:00:1f.2/ata4/link4/ata_link/link4
./class/ata_port/ata4  ../../devices/pci0000:00/0000:00:1f.2/ata4/ata_port/ata4
./class/ata_device/dev4.0
../../devices/pci0000:00/0000:00:1f.2/ata4/link4/dev4.0/ata_device/dev4.0

No luck.

[784786.047673] ata4.00: exception Emask 0x10 SAct 0x7800 SErr 0x0
action 0x6 frozen
[784786.047707] ata4.00: irq_stat 0x08000000, interface fatal error
[784786.047730] ata4.00: failed command: READ FPDMA QUEUED
[784786.047752] ata4.00: cmd 60/40:58:80:a9:48/00:00:86:00:00/40 tag
11 ncq 32768 in
[784786.047753]          res c0/00:40:80:15:8d/00:00:86:00:00/40 Emask
0x12 (ATA bus error)
[784786.047805] ata4.00: status: { Busy }
[784786.047819] ata4.00: failed command: READ FPDMA QUEUED
[784786.047840] ata4.00: cmd 60/40:60:80:aa:48/00:00:86:00:00/40 tag
12 ncq 32768 in
[784786.047841]          res c0/00:40:80:15:8d/00:00:86:00:00/40 Emask
0x12 (ATA bus error)
[784786.047893] ata4.00: status: { Busy }
[784786.047907] ata4.00: failed command: READ FPDMA QUEUED
[784786.047928] ata4.00: cmd 60/40:68:c0:aa:48/00:00:86:00:00/40 tag
13 ncq 32768 in
[784786.047929]          res c0/00:40:80:15:8d/00:00:86:00:00/40 Emask
0x12 (ATA bus error)
[784786.047981] ata4.00: status: { Busy }
[784786.047996] ata4.00: failed command: READ FPDMA QUEUED
[784786.048016] ata4.00: cmd 60/40:70:00:ab:48/00:00:86:00:00/40 tag
14 ncq 32768 in
[784786.048017]          res c0/00:40:80:15:8d/00:00:86:00:00/40 Emask
0x12 (ATA bus error)
[784786.048067] ata4.00: status: { Busy }
[784786.048085] ata4: hard resetting link
[784786.365119] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[784786.380854] ata4.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[784786.380860] ata4.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY
FREEZE LOCK) filtered out
[784786.380864] ata4.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[784786.382279] ata4.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[784786.382283] ata4.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY
FREEZE LOCK) filtered out
[784786.382287] ata4.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
CONFIGURATION OVERLAY) filtered out
[784786.382747] ata4.00: configured for UDMA/133
[784786.382761] ata4: EH complete

--Andy

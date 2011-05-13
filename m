Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582Ab1EMS7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:59:23 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:43303 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1EMS7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:59:21 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: 2.6.39-rc5-mmotm0429 and later - delay detecting DVD at boot
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1305313109_2567P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 13 May 2011 14:58:29 -0400
Message-ID: <14360.1305313109@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.4DCD7F56.00E1,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1305313109_2567P
Content-Type: text/plain; charset=us-ascii

Hardware: Dell Latitude E6500 laptop.

In kernel 2.6.39-rc5-mmotm0429 and later, I see this 10-second pause at boot:

[    1.231050] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.231988] ata1.00: ATA-8: WDC WD1600BJKT-75F4T0, 11.01A11, max UDMA/133
[    1.231991] ata1.00: 312581808 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.232906] ata1.00: configured for UDMA/133
[    1.233704] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600BJKT-7 11.0 PQ: 0 ANSI: 5
[    1.234428] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.234636] sd 0:0:0:0: [sda] Write Protect is off
[    1.234639] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.234712] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.235580] sda: detected capacity change from 0 to 160041885696
[    1.266786]  sda: sda1 sda2
[    1.267681] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.588040] ata2: link is slow to respond, please be patient (ready=0)
[   11.280039] ata2: COMRESET failed (errno=-16)
[   11.585046] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   11.586633] ata2.00: ATAPI: MATSHITA DVD+/-RW UJ892, 1.01, max UDMA/100
[   11.589048] ata2.00: configured for UDMA/100
[   11.592387] scsi 1:0:0:0: CD-ROM            MATSHITA DVD+-RW UJ892    1.01 PQ: 0 ANSI: 5
[   11.595167] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   11.595171] cdrom: Uniform CD-ROM driver Revision: 3.20
[   11.595697] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   11.901042] ata5: SATA link down (SStatus 0 SControl 300)
[   12.206042] ata6: SATA link down (SStatus 0 SControl 300)

Previously working boot had this:

[    1.253038] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.253987] ata1.00: ATA-8: WDC WD1600BJKT-75F4T0, 11.01A11, max UDMA/133
[    1.253991] ata1.00: 312581808 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.254928] ata1.00: configured for UDMA/133
[    1.255709] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600BJKT-7 11.0 PQ: 0 ANSI: 5
[    1.256717] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.256937] sd 0:0:0:0: [sda] Write Protect is off
[    1.256941] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.257026] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.283598]  sda: sda1 sda2
[    1.284607] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.979041] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.980625] ata2.00: ATAPI: MATSHITA DVD+/-RW UJ892, 1.01, max UDMA/100
[    1.982976] ata2.00: configured for UDMA/100
[    1.986303] scsi 1:0:0:0: CD-ROM            MATSHITA DVD+-RW UJ892    1.01 PQ: 0 ANSI: 5
[    1.989312] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.989316] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.989998] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    2.295035] ata5: SATA link down (SStatus 0 SControl 300)
[    2.600035] ata6: SATA link down (SStatus 0 SControl 300)

I'll have some time to bisect this one this weekend, if it doesn't ring any bells. I see one
other posting on lkml  on 05/06 from Andy Lutomirski about 'Cougar Point' regression:

http://marc.info/?l=linux-kernel&m=130479522525753&w=2

but no follow-ups that I've found.

Not sure if my laptop has whatever Cougar Point is - lspci reports:

00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
00:01.0 PCI bridge: Intel Corporation Mobile 4 Series Chipset PCI Express Graphics Port (rev 07)
00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network Connection (rev 03)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 3 (rev 03)
00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
00:1f.2 RAID bus controller: Intel Corporation Mobile 82801 SATA RAID Controller (rev 03)



--==_Exmh_1305313109_2567P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNzX9VcC3lWbTT17ARAuKfAKCj3l1YsMMA67PDtu48mrIxbpDKKACg7e4y
J4VI71/ibsYiTFT2LxcwT6o=
=YaPt
-----END PGP SIGNATURE-----

--==_Exmh_1305313109_2567P--


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab0GDBZY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 21:25:24 -0400
Received: from troy.hostgo.com ([64.62.143.130]:40834 "EHLO troy.hostgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368Ab0GDBZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 21:25:23 -0400
From: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Drives missing at boot
Date: Sat, 3 Jul 2010 19:25:19 -0600
User-Agent: KMail/1.13.3 (Linux/2.6.34-0.dmz.10-liquorix-amd64; KDE/4.4.4; x86_64; ; )
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com> <AANLkTikPsRvvpSZirSygnZqyGKcS-Bz0eVeASZZqvZwH@mail.gmail.com> <AANLkTintf2mwgBVuk_4GmfHTzyJebP2kyfcNGij_epy-@mail.gmail.com>
In-Reply-To: <AANLkTintf2mwgBVuk_4GmfHTzyJebP2kyfcNGij_epy-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007031925.19446.tfjellstrom@strangesoft.net>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - troy.hostgo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - strangesoft.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On July 3, 2010, Mark Knecht wrote:
> On Sat, Jul 3, 2010 at 12:57 PM, Mark Knecht <markknecht@gmail.com> wrote:
> > On Sat, Jul 3, 2010 at 12:42 PM, Stan Hoeppner <stan@hardwarefreak.com> 
wrote:
> >> Mark Knecht put forth on 7/3/2010 2:21 PM:
> >>> Note two things:
> >>> 
> >>> 1) All the drives are always reported by BIOS at boot time. Now, that
> >>> doesn't guarantee that the drives spin up. It may only mean they can
> >>> be read by BIOS, but they are there as far as I can tell. They show
> >>> up in the boot screens and in BIOS itself if I drop in to play with
> >>> settings.
> >> 
> >> I missed that.  I thought I read it was both.  My bad.
> > 
> > Not a problem. It's good to be as clear as possible for all involved.
> > 
> >>> QUESTION: There are some settings in BIOS for delaying the drive. (Or
> >>> something. I'm using the machine and not in BIOS) There were settings
> >>> from 0 to 35 seconds if I remember correctly. Possibly I should try
> >>> setting each drive to a different value to different value to stagger
> >>> power up?
> >> 
> >> If that PSU meets published specs you shouldn't need delayed spin up
> >> with those 5 drives.
> > 
> > I've not dropped into BIOS yet as the machine is in use but from the
> > Asus manual it appears the delay is not on a drive by drive basis so I
> > don't think I can do much there.
> > 
> >>> If you need more info or have other ideas please let me know.
> >> 
> >> Your answers here should have pretty much eliminated hardware issues
> >> as the cause, unless that particular mobo has BIOS or other issues
> >> I'm unaware of.
> >> 
> >> I've found it's always best to ask about hardware with this kind of
> >> report just to eliminate possibilities.  All that gear is good
> >> quality stuff.  If the problem is due to hardware, it's because one
> >> of your components is defective, but we don't see evidence of that at
> >> this point.
> >> 
> >> Also, TTBOMK, if a SATA drive motor doesn't spin up, the drive
> >> firmware won't report the drive as ready upstream, thus the BIOS
> >> won't list the drive.
> > 
> > An off-list response suggested possibly setting some drive jumpers on
> > non-boot drives to power up in standby. Apparently the kernel will
> > then spin up those drives later? If I cannot stagger the drives in
> > BIOS then I will likely try that. Technically I guess I only need
> > /boot on sda to get the kernel booted. The mdadm RAID1 on sda/sdb/sdc
> > could start slightly later, and technically the RAID0 on sdd/sde could
> > start very late as there are only VMWare images on that drive.
> > 
> > Cheers,
> > Mark
> 
> OK, I don't know if this is related but so far I cannot get the
> machine to boot if I set BIOS SATA configuration to AHCI. I believe
> that I have AHCI support as well as SATA support built into the kernel
> but when I set the BIOS to AHCI the machine just hangs saying it finds
> no medium. I assume that means no hard drive. I have to set SATA
> support to enhanced and then IDE to get the machine to boot at all.
> 
> I did notice that my earlier kernel had the depreciated ATA/ATAPI
> support selected so I removed that from the kernel but it didn't
> change the results.
> 
> The lshw listings below show the DATA controllers. The 20360/363 is
> (apparently) the eSATA controller going to the front panel. Nothing is
> attached there. The chipset supposedly handles 6 SATA ports - they
> seem to be arranged x4 & x2. TTBOMK I have the CDROM and the 3-drive
> RAID1 on the 4 port controller and the RAID0, which fails to be
> recognized more often - on the 2 port controller. I don't know how to
> prove that though.
> 
> I'm unclear how mature the SATA support is for this chipset. Is there
> a chance that this is some bit that's not being sey reliably?
> 
> Also, I misspoke earlier about the graphics adapter. It's actually an
> ATI Radeon 5770 in this machine. The 9500GT is in another machine.
> 
> Thanks,
> Mark
> 
> c2stable ~ # lshw -short -class storage
> H/W path               Device     Class       Description
> =========================================================
> /0/100/1c.4/0                     storage     20360/20363 Serial ATA
> Controller /0/100/1c.4/0.1                   storage     20360/20363
> Serial ATA Controller /0/100/1f.2            scsi2      storage    
> 82801JI (ICH10 Family) 4 port SATA IDE Controller
> /0/100/1f.5            scsi5      storage     82801JI (ICH10 Family) 2
> port SATA IDE Controller
> c2stable ~ # lshw -short | grep SATA
> /0/100/1f.2            scsi2      storage     82801JI (ICH10 Family) 4
> port SATA IDE Controller
> /0/100/1f.5            scsi5      storage     82801JI (ICH10 Family) 2
> port SATA IDE Controller
> c2stable ~ # lshw -short | grep disk
> /0/100/1f.2/0          /dev/sda   disk        500GB WDC WD5002ABYS-0
> /0/100/1f.2/0.0.0      /dev/sdb   disk        500GB WDC WD5002ABYS-0
> /0/100/1f.2/1          /dev/sdc   disk        500GB WDC WD5002ABYS-0
> /0/100/1f.5/0.0.0      /dev/sdd   disk        500GB WDC WD5002ABYS-0
> c2stable ~ #
> 
> NOTE ABOVE: /dev/sde not recognized on this boot.
> 
> 
> c2stable linux # lspci
> 00:00.0 Host bridge: Intel Corporation X58 I/O Hub to ESI Port (rev 13)
> 00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
> Express Root Port 1 (rev 13)
> 00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
> Express Root Port 3 (rev 13)
> 00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
> Express Root Port 7 (rev 13)
> 00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System Management
> Registers (rev 13)
> 00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch
> Pad Registers (rev 13)
> 00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status
> and RAS Registers (rev 13)
> 00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers
> (rev 13) 00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10
> Family) USB UHCI Controller #4
> 00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #5
> 00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #6
> 00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
> EHCI Controller #2
> 00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD
> Audio Controller
> 00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express
> Port 1 00:1c.2 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI
> Express Port 3 00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10
> Family) PCI Express Port 5 00:1c.5 PCI bridge: Intel Corporation 82801JI
> (ICH10 Family) PCI Express Port 6 00:1d.0 USB Controller: Intel
> Corporation 82801JI (ICH10 Family) USB UHCI Controller #1
> 00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #2
> 00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
> UHCI Controller #3
> 00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
> EHCI Controller #1
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
> 00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface
> Controller 00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10
> Family) 4 port SATA IDE Controller
> 00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
> 00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port
> SATA IDE Controller
> 03:00.0 VGA compatible controller: ATI Technologies Inc Device 68b8
> 03:00.1 Audio device: ATI Technologies Inc Device aa58
> 04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056
> PCI-E Gigabit Ethernet Controller (rev 12)
> 05:00.0 SATA controller: JMicron Technology Corp. 20360/20363 Serial
> ATA Controller (rev 03)
> 05:00.1 IDE interface: JMicron Technology Corp. 20360/20363 Serial ATA
> Controller (rev 03)
> 06:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056
> PCI-E Gigabit Ethernet Controller (rev 12)
> 08:02.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306 Fire II
> IEEE 1394 OHCI Link Layer Controller (rev c0)
> c2stable linux #

If it wasn't for all that, I'd have suspected a small power issue.

I recently ran into an odd problem of how my PSU has its rails split up 
between different cables. If I had all the hardware in the box hooked up 
with the normal "black" cables from my PSU I'd get errors from one of my 2TB 
WD Green's. But if I moved the drives, or the GPU to the "red" plug (modular 
psu), everything worked. I assume the rails on my psu were split up 
absolutely retardedly, causing the main 12v rail to be shared between the 
cpu, all add-on devices, AND the non-modular PCI-E cable for the GPU 
(8800GTS), causing that rail's voltage to drop below spec.

But it sounds like maybe your SATA chipset might not be supported in AHCI 
mode (which you really want), and might have issues in IDE mode. But given 
that its an intel chipset you'd think it'd have perfect support :o So I 
don't know.


-- 
Thomas Fjellstrom
tfjellstrom@strangesoft.net

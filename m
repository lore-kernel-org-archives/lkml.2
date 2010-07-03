Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab0GCWbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 18:31:52 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:40057 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab0GCWbs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 18:31:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AQclX8/s0IKc/zYCISZmpoDfYl1vSMJz/lpARHXFVcTalrqtD8TcPo1DQtiuYMfWfk
         9cXoKYULnPFsOyAyCqnv21SGQTPkHGAGF+rzWRUHHZs0qe1mucivESnuZjHtb/IU+Epb
         3Ua/ZLPsCjAmjGbMciYUKvKSQIrxMrAv0LlKk=
MIME-Version: 1.0
In-Reply-To: <AANLkTikPsRvvpSZirSygnZqyGKcS-Bz0eVeASZZqvZwH@mail.gmail.com>
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>
	<4C2F5ECB.1040505@kernel.org>
	<AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>
	<4C2F87C1.8000701@hardwarefreak.com>
	<AANLkTimVJEO-yF3GZ2ghX6DNPuAu-A-MNNO9x8Q1EpRc@mail.gmail.com>
	<4C2F9292.708@hardwarefreak.com>
	<AANLkTikPsRvvpSZirSygnZqyGKcS-Bz0eVeASZZqvZwH@mail.gmail.com>
Date: Sat, 3 Jul 2010 15:31:48 -0700
Message-ID: <AANLkTintf2mwgBVuk_4GmfHTzyJebP2kyfcNGij_epy-@mail.gmail.com>
Subject: Re: Drives missing at boot
From: Mark Knecht <markknecht@gmail.com>
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Tejun Heo <tj@kernel.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 3, 2010 at 12:57 PM, Mark Knecht <markknecht@gmail.com> wrote:
> On Sat, Jul 3, 2010 at 12:42 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> Mark Knecht put forth on 7/3/2010 2:21 PM:
>>
>>> Note two things:
>>>
>>> 1) All the drives are always reported by BIOS at boot time. Now, that
>>> doesn't guarantee that the drives spin up. It may only mean they can
>>> be read by BIOS, but they are there as far as I can tell. They show up
>>> in the boot screens and in BIOS itself if I drop in to play with
>>> settings.
>>
>> I missed that.  I thought I read it was both.  My bad.
>>
>
> Not a problem. It's good to be as clear as possible for all involved.
>
>>> QUESTION: There are some settings in BIOS for delaying the drive. (Or
>>> something. I'm using the machine and not in BIOS) There were settings
>>> from 0 to 35 seconds if I remember correctly. Possibly I should try
>>> setting each drive to a different value to different value to stagger
>>> power up?
>>
>> If that PSU meets published specs you shouldn't need delayed spin up with
>> those 5 drives.
>>
>
> I've not dropped into BIOS yet as the machine is in use but from the
> Asus manual it appears the delay is not on a drive by drive basis so I
> don't think I can do much there.
>
>>> If you need more info or have other ideas please let me know.
>>
>> Your answers here should have pretty much eliminated hardware issues as the
>> cause, unless that particular mobo has BIOS or other issues I'm unaware of.
>>
>> I've found it's always best to ask about hardware with this kind of report
>> just to eliminate possibilities.  All that gear is good quality stuff.  If the
>> problem is due to hardware, it's because one of your components is defective,
>> but we don't see evidence of that at this point.
>>
>> Also, TTBOMK, if a SATA drive motor doesn't spin up, the drive firmware won't
>> report the drive as ready upstream, thus the BIOS won't list the drive.
>
> An off-list response suggested possibly setting some drive jumpers on
> non-boot drives to power up in standby. Apparently the kernel will
> then spin up those drives later? If I cannot stagger the drives in
> BIOS then I will likely try that. Technically I guess I only need
> /boot on sda to get the kernel booted. The mdadm RAID1 on sda/sdb/sdc
> could start slightly later, and technically the RAID0 on sdd/sde could
> start very late as there are only VMWare images on that drive.
>
> Cheers,
> Mark
>

OK, I don't know if this is related but so far I cannot get the
machine to boot if I set BIOS SATA configuration to AHCI. I believe
that I have AHCI support as well as SATA support built into the kernel
but when I set the BIOS to AHCI the machine just hangs saying it finds
no medium. I assume that means no hard drive. I have to set SATA
support to enhanced and then IDE to get the machine to boot at all.

I did notice that my earlier kernel had the depreciated ATA/ATAPI
support selected so I removed that from the kernel but it didn't
change the results.

The lshw listings below show the DATA controllers. The 20360/363 is
(apparently) the eSATA controller going to the front panel. Nothing is
attached there. The chipset supposedly handles 6 SATA ports - they
seem to be arranged x4 & x2. TTBOMK I have the CDROM and the 3-drive
RAID1 on the 4 port controller and the RAID0, which fails to be
recognized more often - on the 2 port controller. I don't know how to
prove that though.

I'm unclear how mature the SATA support is for this chipset. Is there
a chance that this is some bit that's not being sey reliably?

Also, I misspoke earlier about the graphics adapter. It's actually an
ATI Radeon 5770 in this machine. The 9500GT is in another machine.

Thanks,
Mark

c2stable ~ # lshw -short -class storage
H/W path               Device     Class       Description
=========================================================
/0/100/1c.4/0                     storage     20360/20363 Serial ATA Controller
/0/100/1c.4/0.1                   storage     20360/20363 Serial ATA Controller
/0/100/1f.2            scsi2      storage     82801JI (ICH10 Family) 4
port SATA IDE Controller
/0/100/1f.5            scsi5      storage     82801JI (ICH10 Family) 2
port SATA IDE Controller
c2stable ~ # lshw -short | grep SATA
/0/100/1f.2            scsi2      storage     82801JI (ICH10 Family) 4
port SATA IDE Controller
/0/100/1f.5            scsi5      storage     82801JI (ICH10 Family) 2
port SATA IDE Controller
c2stable ~ # lshw -short | grep disk
/0/100/1f.2/0          /dev/sda   disk        500GB WDC WD5002ABYS-0
/0/100/1f.2/0.0.0      /dev/sdb   disk        500GB WDC WD5002ABYS-0
/0/100/1f.2/1          /dev/sdc   disk        500GB WDC WD5002ABYS-0
/0/100/1f.5/0.0.0      /dev/sdd   disk        500GB WDC WD5002ABYS-0
c2stable ~ #

NOTE ABOVE: /dev/sde not recognized on this boot.


c2stable linux # lspci
00:00.0 Host bridge: Intel Corporation X58 I/O Hub to ESI Port (rev 13)
00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
Express Root Port 1 (rev 13)
00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
Express Root Port 3 (rev 13)
00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI
Express Root Port 7 (rev 13)
00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System Management
Registers (rev 13)
00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch
Pad Registers (rev 13)
00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status
and RAS Registers (rev 13)
00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers (rev 13)
00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #4
00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #5
00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #6
00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #2
00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD
Audio Controller
00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 1
00:1c.2 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 3
00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 5
00:1c.5 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Port 6
00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #1
00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #2
00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB
UHCI Controller #3
00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2
EHCI Controller #1
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4 port
SATA IDE Controller
00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port
SATA IDE Controller
03:00.0 VGA compatible controller: ATI Technologies Inc Device 68b8
03:00.1 Audio device: ATI Technologies Inc Device aa58
04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056
PCI-E Gigabit Ethernet Controller (rev 12)
05:00.0 SATA controller: JMicron Technology Corp. 20360/20363 Serial
ATA Controller (rev 03)
05:00.1 IDE interface: JMicron Technology Corp. 20360/20363 Serial ATA
Controller (rev 03)
06:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056
PCI-E Gigabit Ethernet Controller (rev 12)
08:02.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306 Fire II
IEEE 1394 OHCI Link Layer Controller (rev c0)
c2stable linux #

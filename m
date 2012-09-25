Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab2IYSc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 14:32:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab2IYSc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 14:32:56 -0400
Message-ID: <1348597970.28860.114.camel@bling.home>
Subject: Re: 3.6-rc7 boot crash + bisection
From: Alex Williamson <alex.williamson@redhat.com>
To: Florian Dazinger <florian@dazinger.net>
Cc: linux-kernel@vger.kernel.org, "Roedel, Joerg" <Joerg.Roedel@amd.com>
Date: Tue, 25 Sep 2012 12:32:50 -0600
In-Reply-To: <20120924210348.5f50677b@brain.lan>
References: <20120924210348.5f50677b@brain.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 21:03 +0200, Florian Dazinger wrote:
> Hi,
> I think I've found a regression, which causes an early boot crash, I
> appended the kernel output via jpg file, since I do not have a serial
> console or sth.
> 
> after bisection, it boils down to this commit:
> 
> 9dcd61303af862c279df86aa97fde7ce371be774 is the first bad commit
> commit 9dcd61303af862c279df86aa97fde7ce371be774
> Author: Alex Williamson <alex.williamson@redhat.com>
> Date:   Wed May 30 14:19:07 2012 -0600
> 
>     amd_iommu: Support IOMMU groups
>     
>     Add IOMMU group support to AMD-Vi device init and uninit code.
>     Existing notifiers make sure this gets called for each device.
>     
>     Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>     Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> :040000 040000 2f6b1b8e104d6dfec0abaa9646750f9b5a4f4060
> 837ae95e84f6d3553457c4df595a9caa56843c03 M      drivers

[switching back to mailing list thread]

I asked Florian for dmesg w/ amd_iommu_dump, here's the relevant lines:

[    1.485645] AMD-Vi: device: 00:00.2 cap: 0040 seg: 0 flags: 3e info 1300
[    1.485683] AMD-Vi:        mmio-addr: 00000000feb20000
[    1.485901] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 00:00.0 flags: 00
[    1.485935] AMD-Vi:   DEV_RANGE_END           devid: 00:00.2
[    1.485969] AMD-Vi:   DEV_SELECT                      devid: 00:02.0 flags: 00
[    1.486002] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 01:00.0 flags: 00
[    1.486036] AMD-Vi:   DEV_RANGE_END           devid: 01:00.1
[    1.486070] AMD-Vi:   DEV_SELECT                      devid: 00:04.0 flags: 00
[    1.486103] AMD-Vi:   DEV_SELECT                      devid: 02:00.0 flags: 00
[    1.486137] AMD-Vi:   DEV_SELECT                      devid: 00:05.0 flags: 00
[    1.486170] AMD-Vi:   DEV_SELECT                      devid: 03:00.0 flags: 00
[    1.486204] AMD-Vi:   DEV_SELECT                      devid: 00:06.0 flags: 00
[    1.486238] AMD-Vi:   DEV_SELECT                      devid: 04:00.0 flags: 00
[    1.486271] AMD-Vi:   DEV_SELECT                      devid: 00:07.0 flags: 00
[    1.486305] AMD-Vi:   DEV_SELECT                      devid: 05:00.0 flags: 00
[    1.486338] AMD-Vi:   DEV_SELECT                      devid: 00:09.0 flags: 00
[    1.486372] AMD-Vi:   DEV_SELECT                      devid: 06:00.0 flags: 00
[    1.486406] AMD-Vi:   DEV_SELECT                      devid: 00:0b.0 flags: 00
[    1.486439] AMD-Vi:   DEV_SELECT                      devid: 07:00.0 flags: 00
[    1.486473] AMD-Vi:   DEV_ALIAS_RANGE                 devid: 08:01.0 flags: 00 devid_to: 08:00.0
[    1.486510] AMD-Vi:   DEV_RANGE_END           devid: 08:1f.7
[    1.486548] AMD-Vi:   DEV_SELECT                      devid: 00:11.0 flags: 00
[    1.486581] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 00:12.0 flags: 00
[    1.486620] AMD-Vi:   DEV_RANGE_END           devid: 00:12.2
[    1.486654] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 00:13.0 flags: 00
[    1.486688] AMD-Vi:   DEV_RANGE_END           devid: 00:13.2
[    1.486721] AMD-Vi:   DEV_SELECT                      devid: 00:14.0 flags: d7
[    1.486755] AMD-Vi:   DEV_SELECT                      devid: 00:14.3 flags: 00
[    1.486788] AMD-Vi:   DEV_SELECT                      devid: 00:14.4 flags: 00
[    1.486822] AMD-Vi:   DEV_ALIAS_RANGE                 devid: 09:00.0 flags: 00 devid_to: 00:14.4
[    1.486859] AMD-Vi:   DEV_RANGE_END           devid: 09:1f.7
[    1.486897] AMD-Vi:   DEV_SELECT                      devid: 00:14.5 flags: 00
[    1.486931] AMD-Vi:   DEV_SELECT_RANGE_START  devid: 00:16.0 flags: 00
[    1.486965] AMD-Vi:   DEV_RANGE_END           devid: 00:16.2
[    1.487055] AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40


> lspci:
> 00:00.0 Host bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (external gfx0 port B) (rev 02)
> 00:00.2 IOMMU: Advanced Micro Devices [AMD] nee ATI RD990 I/O Memory Management Unit (IOMMU)
> 00:02.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (PCI express gpp port B)
> 00:04.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (PCI express gpp port D)
> 00:05.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (PCI express gpp port E)
> 00:06.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (PCI express gpp port F)
> 00:07.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (PCI express gpp port G)
> 00:09.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (PCI express gpp port H)
> 00:0b.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI RD890 PCI to PCI bridge (NB-SB link)
> 00:11.0 SATA controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (rev 40)
> 00:12.0 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
> 00:12.2 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB EHCI Controller
> 00:13.0 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
> 00:13.2 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB EHCI Controller
> 00:14.0 SMBus: Advanced Micro Devices [AMD] nee ATI SBx00 SMBus Controller (rev 42)
> 00:14.3 ISA bridge: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
> 00:14.4 PCI bridge: Advanced Micro Devices [AMD] nee ATI SBx00 PCI to PCI Bridge (rev 40)
> 00:14.5 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
> 00:16.0 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
> 00:16.2 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB EHCI Controller
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor HyperTransport Configuration
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Address Map
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor DRAM Controller
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Miscellaneous Control
> 00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Link Control
> 01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI RV730XT [Radeon HD 4670]
> 01:00.1 Audio device: Advanced Micro Devices [AMD] nee ATI RV710/730 HDMI Audio [Radeon HD 4000 series]
> 02:00.0 SATA controller: ASMedia Technology Inc. ASM1062 Serial ATA Controller (rev 01)
> 03:00.0 Ethernet controller: Intel Corporation 82583V Gigabit Network Connection
> 04:00.0 USB controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB Host Controller
> 05:00.0 USB controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB Host Controller
> 06:00.0 USB controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB Host Controller
> 07:00.0 PCI bridge: PLX Technology, Inc. PEX8112 x1 Lane PCI Express-to-PCI Bridge (rev aa)
> 08:04.0 Multimedia audio controller: C-Media Electronics Inc CMI8788
> [Oxygen HD Audio]         

We can see this is clearly wrong:

[    1.486473] AMD-Vi:   DEV_ALIAS_RANGE                 devid: 08:01.0 flags: 00 devid_to: 08:00.0
[    1.486510] AMD-Vi:   DEV_RANGE_END           devid: 08:1f.7

So the BIOS is telling us to alias everything in the range of 08:00.0 to
08:1f.7 to device id 08:01.0, which doesn't exist :(  Can you send lspci
-vvv?  I suspect we'll find that 07:00.0 sources bus 08 and that alias
should really be to 07:00.0 instead of 08:01.0.  Please also provide
dmidecode for this system, we may need to create a quirk for this box.
Thanks,

Alex


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab2K0Ofr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:35:47 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34729 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2K0Ofq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:35:46 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: "=?iso-8859-1?Q?'Bruno_Pr=E9mont'?=" <bonbons@linux-vserver.org>,
        <support@supermicro.com>, <linux-kernel@vger.kernel.org>,
        "'Dan Williams'" <djbw@fb.com>
References: <097501cdca7b$7e303890$7a90a9b0$@lucidpixels.com> <20121126224245.248f0901@neptune.home> <CAErSpo7Y7m9o2u36ghiW1UDkwweSCG1ZGBx167Anfw4wXTYrCg@mail.gmail.com> <CAErSpo6vrHMTht1nQxiF6HD7qCvUE-NS2eAnQjgUXym1pnNkSA@mail.gmail.com> <004201cdcc3a$a7538310$f5fa8930$@lucidpixels.com> <CAErSpo7530xA6=1Ytj09dwyS1M_N_yAfk4xkr3f9Z_NBn6TJrA@mail.gmail.com> <00a501cdcca3$c2638510$472a8f30$@lucidpixels.com> <00b501cdcca6$03f88af0$0be9a0d0$@lucidpixels.com> <00b701cdcca6$ff097620$fd1c6260$@lucidpixels.com>
In-Reply-To: <00b701cdcca6$ff097620$fd1c6260$@lucidpixels.com>
Subject: RE: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware bug question
Date: Tue, 27 Nov 2012 09:35:43 -0500
Message-ID: <00cc01cdccac$7c273d40$7475b7c0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQH421ylXKr/7aSEd56ctRShmAJ9gwGHtGctAMAwLAsA1DUSgwLbZdCZAXol/xoByREOOQK10CNCAguYW3OXN8CXgA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com] 
Sent: Tuesday, November 27, 2012 8:56 AM
To: 'Bjorn Helgaas'
Cc: 'Bruno Prémont'; support@supermicro.com; linux-kernel@vger.kernel.org;
'Dan Williams'
Subject: RE: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware
bug question


> It is _not_ working on the:

> 2) Supermicro X8DTH-F (the boot drive in this system is running off a
PCI-e
> card, could the IRQ for the I/O controller be getting re-mapped and
fail?)--
> worse case I can move the SSD from the 6.0gbpa SATA card to the
motherboard
> and see if that works, but that kind of defeats the purpose of a 6.0gbps
> SATA SSD.

When I removed the Highpoint 2-port SATA card and plugged it into the
motherboard, the system boots (plugged the SSD into the motherboard).
So if you use a HIGHPOINT 2-PORT SATA 6.0gbps card, do NOT enable IOMMU or
it will fail to initialize the Highpoint 2-port SATA controller card!
I also tried upgrading the BIOS (of the mobo, no diff)
I also tried just leaving the SATA card in and plugging it into the
motherboard (no diff)
Removed the Highpoint 2-port SATA card and then success, it would be nice to
use that card with IOMMU support though, is it just not compatible
(marvell-problem?) or is a driver bug?  Based on the pictures/etc sent
earlier?

$ dmesg|grep -i iommu
[    0.055134] dmar: IOMMU 0: reg_base_addr cfdfe000 ver 1:0 cap
c90780106f0462 ecap f020f6
[    0.055396] dmar: IOMMU 1: reg_base_addr fecfe000 ver 1:0 cap
c90780106f0462 ecap f020f6
[    0.760665] IOMMU 0 0xcfdfe000: using Queued invalidation
[    0.760803] IOMMU 1 0xfecfe000: using Queued invalidation
[    0.760937] IOMMU: Setting RMRR:
[    0.761102] IOMMU: Setting identity map for device 0000:00:1d.0
[0xbf7ec000 - 0xbf7fffff]
[    0.761329] IOMMU: Setting identity map for device 0000:00:1d.1
[0xbf7ec000 - 0xbf7fffff]
[    0.761542] IOMMU: Setting identity map for device 0000:00:1d.2
[0xbf7ec000 - 0xbf7fffff]
[    0.761758] IOMMU: Setting identity map for device 0000:00:1d.7
[0xbf7ec000 - 0xbf7fffff]
[    0.761974] IOMMU: Setting identity map for device 0000:00:1a.0
[0xbf7ec000 - 0xbf7fffff]
[    0.762190] IOMMU: Setting identity map for device 0000:00:1a.1
[0xbf7ec000 - 0xbf7fffff]
[    0.762407] IOMMU: Setting identity map for device 0000:00:1a.2
[0xbf7ec000 - 0xbf7fffff]
[    0.762620] IOMMU: Setting identity map for device 0000:00:1a.7
[0xbf7ec000 - 0xbf7fffff]
[    0.762816] IOMMU: Setting identity map for device 0000:00:1d.0 [0xec000
- 0xeffff]
[    0.763010] IOMMU: Setting identity map for device 0000:00:1d.1 [0xec000
- 0xeffff]
[    0.763197] IOMMU: Setting identity map for device 0000:00:1d.2 [0xec000
- 0xeffff]
[    0.763382] IOMMU: Setting identity map for device 0000:00:1d.7 [0xec000
- 0xeffff]
[    0.763567] IOMMU: Setting identity map for device 0000:00:1a.0 [0xec000
- 0xeffff]
[    0.763749] IOMMU: Setting identity map for device 0000:00:1a.1 [0xec000
- 0xeffff]
[    0.763934] IOMMU: Setting identity map for device 0000:00:1a.2 [0xec000
- 0xeffff]
[    0.764127] IOMMU: Setting identity map for device 0000:00:1a.7 [0xec000
- 0xeffff]
[    0.764311] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    0.764465] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 -
0xffffff]

--


==> Further issues with the X9SRL-F -- does this board support ASPM or is
this a Linux/ASPM implementation issue?
[    0.632170]  pci0000:ff: ACPI _OSC support notification failed, disabling
PCIe ASPM
[    0.632239]  pci0000:ff: Unable to request _OSC control (_OSC support
mask: 0x08)

Justin.









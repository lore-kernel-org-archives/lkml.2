Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab2K0N4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:56:30 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43154 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab2K0N43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:56:29 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: "=?iso-8859-1?Q?'Bruno_Pr=E9mont'?=" <bonbons@linux-vserver.org>,
        <support@supermicro.com>, <linux-kernel@vger.kernel.org>,
        "'Dan Williams'" <djbw@fb.com>
References: <097501cdca7b$7e303890$7a90a9b0$@lucidpixels.com> <20121126224245.248f0901@neptune.home> <CAErSpo7Y7m9o2u36ghiW1UDkwweSCG1ZGBx167Anfw4wXTYrCg@mail.gmail.com> <CAErSpo6vrHMTht1nQxiF6HD7qCvUE-NS2eAnQjgUXym1pnNkSA@mail.gmail.com> <004201cdcc3a$a7538310$f5fa8930$@lucidpixels.com> <CAErSpo7530xA6=1Ytj09dwyS1M_N_yAfk4xkr3f9Z_NBn6TJrA@mail.gmail.com> <00a501cdcca3$c2638510$472a8f30$@lucidpixels.com> <00b501cdcca6$03f88af0$0be9a0d0$@lucidpixels.com>
In-Reply-To: <00b501cdcca6$03f88af0$0be9a0d0$@lucidpixels.com>
Subject: RE: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware bug question
Date: Tue, 27 Nov 2012 08:56:27 -0500
Message-ID: <00b701cdcca6$ff097620$fd1c6260$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQH421ylXKr/7aSEd56ctRShmAJ9gwGHtGctAMAwLAsA1DUSgwLbZdCZAXol/xoByREOOQK10CNCl0gRvUA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It is _not_ working on the:

> 2) Supermicro X8DTH-F (the boot drive in this system is running off a
PCI-e
> card, could the IRQ for the I/O controller be getting re-mapped and
fail?)--
> worse case I can move the SSD from the 6.0gbpa SATA card to the
motherboard
> and see if that works, but that kind of defeats the purpose of a 6.0gbps
> SATA SSD.

When IOMMU is disabled, I/OAT DMA is successful on the second motherboard
(X8DTH-6F).
Specifically:

--- DMA Engine support
[*]   Intel I/OAT DMA support
[*]   Network: TCP receive copy offload   
[*]   Async_tx: Offload support for the async_tx api

When IOMMU/X2APIC is enabled on the X8DTH-6F it fails to boot.
Will keep doing more testing to see if I get anywhere w/regards to the
IOMMU.

Proof of success:

[    0.757467] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    0.757690] ioatdma 0000:00:16.0: irq 88 for MSI/MSI-X
[    0.757948] ioatdma 0000:00:16.1: irq 89 for MSI/MSI-X
[    0.758166] ioatdma 0000:00:16.2: irq 90 for MSI/MSI-X
[    0.758377] ioatdma 0000:00:16.3: irq 91 for MSI/MSI-X
[    0.758577] ioatdma 0000:00:16.4: irq 92 for MSI/MSI-X
[    0.758794] ioatdma 0000:00:16.5: irq 93 for MSI/MSI-X
[    0.759000] ioatdma 0000:00:16.6: irq 94 for MSI/MSI-X
[    0.759214] ioatdma 0000:00:16.7: irq 95 for MSI/MSI-X
[    0.759461] ioatdma 0000:80:16.0: irq 96 for MSI/MSI-X
[    0.759720] ioatdma 0000:80:16.1: irq 97 for MSI/MSI-X
[    0.759963] ioatdma 0000:80:16.2: irq 98 for MSI/MSI-X
[    0.760190] ioatdma 0000:80:16.3: irq 99 for MSI/MSI-X
[    0.760414] ioatdma 0000:80:16.4: irq 100 for MSI/MSI-X
[    0.760630] ioatdma 0000:80:16.5: irq 101 for MSI/MSI-X
[    0.760862] ioatdma 0000:80:16.6: irq 102 for MSI/MSI-X
[    0.761081] ioatdma 0000:80:16.7: irq 103 for MSI/MSI-X

--


==> Further issues with the X9SRL-F -- does this board support ASPM or is
this a Linux/ASPM implementation issue?
[    0.632170]  pci0000:ff: ACPI _OSC support notification failed, disabling
PCIe ASPM
[    0.632239]  pci0000:ff: Unable to request _OSC control (_OSC support
mask: 0x08)

Justin.








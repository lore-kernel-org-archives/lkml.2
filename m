Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946054Ab2K2Aet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:34:49 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:52363 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422635Ab2K2Aes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:34:48 -0500
Message-ID: <50B6ADA5.2030205@gmail.com>
Date: Wed, 28 Nov 2012 18:34:45 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        =?ISO-8859-1?Q?=27Bruno_Pr=E9?= =?ISO-8859-1?Q?mont=27?= 
	<bonbons@linux-vserver.org>,
        support@supermicro.com, linux-kernel@vger.kernel.org,
        "'Dan Williams'" <djbw@fb.com>
Subject: Re: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware
 bug question
References: <097501cdca7b$7e303890$7a90a9b0$@lucidpixels.com> <20121126224245.248f0901@neptune.home> <CAErSpo7Y7m9o2u36ghiW1UDkwweSCG1ZGBx167Anfw4wXTYrCg@mail.gmail.com> <CAErSpo6vrHMTht1nQxiF6HD7qCvUE-NS2eAnQjgUXym1pnNkSA@mail.gmail.com> <004201cdcc3a$a7538310$f5fa8930$@lucidpixels.com> <CAErSpo7530xA6=1Ytj09dwyS1M_N_yAfk4xkr3f9Z_NBn6TJrA@mail.gmail.com> <00a501cdcca3$c2638510$472a8f30$@lucidpixels.com> <00b501cdcca6$03f88af0$0be9a0d0$@lucidpixels.com>
In-Reply-To: <00b501cdcca6$03f88af0$0be9a0d0$@lucidpixels.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 07:49 AM, Justin Piszcz wrote:
>
>> It looks like maybe you don't have CONFIG_PCI_MMCONFIG turned on?
>
> ===> FOR I/OAT DMA
> Latest status, it _appears_ its working on the X9SRL-F now, thank you!
>
> 1) Supermicro X9SRL-F (GOOD)
> [    0.738510] ioatdma: Intel(R) QuickData Technology Driver 4.00
> [    0.738719] ioatdma 0000:00:04.0: irq 75 for MSI/MSI-X
> [    0.739088] ioatdma 0000:00:04.1: irq 76 for MSI/MSI-X
> [    0.739408] ioatdma 0000:00:04.2: irq 77 for MSI/MSI-X
> [    0.739739] ioatdma 0000:00:04.3: irq 78 for MSI/MSI-X
> [    0.740040] ioatdma 0000:00:04.4: irq 79 for MSI/MSI-X
> [    0.740342] ioatdma 0000:00:04.5: irq 80 for MSI/MSI-X
> [    0.740670] ioatdma 0000:00:04.6: irq 81 for MSI/MSI-X
> [    0.740971] ioatdma 0000:00:04.7: irq 82 for MSI/MSI-X
>
> It is _not_ working on the:
>
> 2) Supermicro X8DTH-F (the boot drive in this system is running off a PCI-e
> card, could the IRQ for the I/O controller be getting re-mapped and fail?)--
> worse case I can move the SSD from the 6.0gbpa SATA card to the motherboard
> and see if that works, but that kind of defeats the purpose of a 6.0gbps
> SATA SSD.
>
> (Fails to talk to the SSD)
> http://home.comcast.net/~jpiszcz/20121127/photo1-resize.jpg
>
> (then, a few moments later: Kernel panic)
> http://home.comcast.net/~jpiszcz/20121127/photo2-resize.jpg
>
> Would be curious if anyone had any suggestions besides removing the
> controller card?

What does lspci -vv show on that controller? Not sure what actual 
chipset that controller is, but there's a known issue with some Marvell 
6Gbps SATA controllers with DMAR enabled - it seems the device issues 
memory read/write requests from the wrong PCI function ID and the IOMMU 
rightly denies access as the function listed in the requests doesn't 
have any mapping to that memory. I don't think there's presently a 
workaround other than disabling DMAR. We could (and likely should) be 
detecting that device and adding some kind of quirk for it.

>
> --
>
>
> ==> Further issues with the X9SRL-F -- does this board support ASPM or is
> this a Linux/ASPM implementation issue?
> [    0.632170]  pci0000:ff: ACPI _OSC support notification failed, disabling
> PCIe ASPM
> [    0.632239]  pci0000:ff: Unable to request _OSC control (_OSC support
> mask: 0x08)

What's the full dmesg from this machine (or is it already posted somewhere)?

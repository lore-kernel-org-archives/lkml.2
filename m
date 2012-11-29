Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab2K2SRC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 13:17:02 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:54707 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2K2SRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 13:17:00 -0500
MIME-Version: 1.0
In-Reply-To: <02d501cdce0f$4b0ce520$e126af60$@lucidpixels.com>
References: <097501cdca7b$7e303890$7a90a9b0$@lucidpixels.com>
 <20121126224245.248f0901@neptune.home> <CAErSpo7Y7m9o2u36ghiW1UDkwweSCG1ZGBx167Anfw4wXTYrCg@mail.gmail.com>
 <CAErSpo6vrHMTht1nQxiF6HD7qCvUE-NS2eAnQjgUXym1pnNkSA@mail.gmail.com>
 <004201cdcc3a$a7538310$f5fa8930$@lucidpixels.com> <CAErSpo7530xA6=1Ytj09dwyS1M_N_yAfk4xkr3f9Z_NBn6TJrA@mail.gmail.com>
 <00a501cdcca3$c2638510$472a8f30$@lucidpixels.com> <00b501cdcca6$03f88af0$0be9a0d0$@lucidpixels.com>
 <50B6ADA5.2030205@gmail.com> <04b301cdcdcb$65e2f400$31a8dc00$@lucidpixels.com>
 <CADLC3L09uxX_AU+22nfS20DCE97n1_ZxkG5A1R9joJcEua-EBg@mail.gmail.com> <02d501cdce0f$4b0ce520$e126af60$@lucidpixels.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 29 Nov 2012 11:16:38 -0700
Message-ID: <CAErSpo7MpFrSX9rVH48A4mvsRdBjQybqiocv3nrZOPoK_+aqcw@mail.gmail.com>
Subject: Re: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware
 bug question
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        support@supermicro.com, linux-kernel@vger.kernel.org,
        Dan Williams <djbw@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 1:55 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> -----Original Message-----
> From: Robert Hancock [mailto:hancockrwd@gmail.com]
> Sent: Wednesday, November 28, 2012 7:55 PM
> To: Justin Piszcz
> Cc: Bjorn Helgaas; Bruno Prémont; support@supermicro.com;
> linux-kernel@vger.kernel.org; Dan Williams
> Subject: Re: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware
> bug question
>
> On Wed, Nov 28, 2012 at 6:49 PM, Justin Piszcz <jpiszcz@lucidpixels.com>
> wrote:
>>
>>
>> -----Original Message-----
>> From: Robert Hancock [mailto:hancockrwd@gmail.com]
>> Sent: Wednesday, November 28, 2012 7:35 PM
>> To: Justin Piszcz
>> Cc: 'Bjorn Helgaas'; 'Bruno Prémont'; support@supermicro.com;
>> linux-kernel@vger.kernel.org; 'Dan Williams'
>> Subject: Re: Supermicro X9SRL-F - channel enumeration error &
> ACPI/firmware
>> bug question
>>
>>
>> What does lspci -vv show on that controller? Not sure what actual
>> chipset that controller is, but there's a known issue with some Marvell
>> 6Gbps SATA controllers with DMAR enabled - it seems the device issues
>> memory read/write requests from the wrong PCI function ID and the IOMMU
>> rightly denies access as the function listed in the requests doesn't
>> have any mapping to that memory. I don't think there's presently a
>> workaround other than disabling DMAR. We could (and likely should) be
>> detecting that device and adding some kind of quirk for it.
>>
>> That sounds likely...
>> It is shown below:
>>
>> Card name: HighPoint Rocket 620 Dual Port SATA 6 Gbps PCI Express 2.0 Host
>> Adapter
>>
>> lspci -vv output:
>>
>> 84:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9123 PCIe SATA
>> 6.0 Gb/s controller (rev 11) (prog-if 01 [AHCI 1.0])
>>   Subsystem: Marvell Technology Group Ltd. 88SE9123 PCIe SATA 6.0 Gb/s
>> controller
>
> Yeah, that's one of those controllers I think. But I can't tell from
> the bit of the dmesg you posted exactly what's going on. Can you post
> a full boot log from having the card installed and some drive attached
> (by putting the boot drive on another controller for example)?
>
>>> ==> Further issues with the X9SRL-F -- does this board support ASPM or is
>>> this a Linux/ASPM implementation issue?
>>> [    0.632170]  pci0000:ff: ACPI _OSC support notification failed,
>> disabling
>>> PCIe ASPM
>>> [    0.632239]  pci0000:ff: Unable to request _OSC control (_OSC support
>>> mask: 0x08)
>>
>> What's the full dmesg from this machine (or is it already posted
> somewhere)?
>>
>> It is now available here:
>> http://home.comcast.net/~jpiszcz/20121128/dmesg.txt
>
>> Is that the same boot log? It doesn't have this error in it.
>
> Yes, the error is here: (its towards the bottom)
>
>  [    7.973015] ata14.00: qc timeout (cmd 0xa1)
> [    8.472120] ata14.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [    9.275922] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [   19.260667] ata14.00: qc timeout (cmd 0xa1)
> [   19.759828] ata14.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [   19.760451] ata14: limiting SATA link speed to 1.5 Gbps
> [   20.566598] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> [   50.521078] ata14.00: qc timeout (cmd 0xa1)
> [   51.020880] ata14.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [   51.824664] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> [   51.824682] dmar: DRHD: handling fault status reg 502
> [   51.824686] dmar: DMAR:[DMA Read] Request device [04:00.0] fault addr 0
> [   51.824686] DMAR:[fault reason 06] PTE Read access is not set

You have these devices:

    pci 0000:04:00.0: [10de:01d3] type 00 class 0x030000 nVidia G72
    pci 0000:84:00.0: [1b4b:9123] type 00 class 0x010601 Marvell 88SE9123 SATA
    pci 0000:84:00.1: [1b4b:91a4] type 00 class 0x01018f Marvell 88SE9128 IDE

I think the 04:00.0 DMAR errors are symptoms of nouveau driver issues,
and if you get rid of that driver, they'll probably go away.

But this 84:00.1 DMAR error:

    dmar: DMAR:[DMA Read] Request device [84:00.1] fault addr fff00000
    DMAR:[fault reason 02] Present bit in context entry is clear

looks like the probable cause of the Marvell issue.  It looks similar
to https://bugzilla.kernel.org/show_bug.cgi?id=42679, although the
reports there show a bb:dd.0 device (but no bb:dd.1 device), and the
DMAR rejects DMA that appears to be from bb:dd.1.

Another report that's even more similar is
https://bugzilla.redhat.com/show_bug.cgi?id=757166 .  In that case,
both bb:dd.0 and bb:dd.1 exist (as in your system), and the DMAR fault
is exactly like what you're seeing.

So you're not alone, but unfortunately, nobody seems to be working on
either bug report.  I took the liberty to add you to the cc: list of
both.

I don't really know what else to do at this point.  Maybe a SATA
expert with some Marvell docs could figure out why we're seeing DMA
from the IDE controller, but I'm not that person :)

> [   52.338871] EXT3-fs (sdb2): error: couldn't mount because of unsupported
> optional features (240)
> [   52.348938] EXT2-fs (sdb2): error: couldn't mount because of unsupported
> optional features (240)
> [   52.360314] EXT4-fs (sdb2): mounted filesystem with ordered data mode.
> Opts: (null)
>
> The system does not boot when the SSD is on that SATA controller.
> The error we were trying to get earlier (kernel panic)-- I cannot reproduce
> that anymore after adding nouveau for whatever reason.
> So to re-cap it boots now with nothing connected to the controller but the
> controller is non-workable/useless, as shown above.
> When you put the SSD on it, it cannot mount rootfs.
>
> Justin.
>
>

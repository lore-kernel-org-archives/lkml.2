Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932910Ab2K2AtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:49:22 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41238 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab2K2AtV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:49:21 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Robert Hancock'" <hancockrwd@gmail.com>
Cc: "=?iso-8859-1?Q?'Bruno_Pr=E9mont'?=" <bonbons@linux-vserver.org>,
        <support@supermicro.com>, <linux-kernel@vger.kernel.org>,
        "'Dan Williams'" <djbw@fb.com>
References: <097501cdca7b$7e303890$7a90a9b0$@lucidpixels.com> <20121126224245.248f0901@neptune.home> <CAErSpo7Y7m9o2u36ghiW1UDkwweSCG1ZGBx167Anfw4wXTYrCg@mail.gmail.com> <CAErSpo6vrHMTht1nQxiF6HD7qCvUE-NS2eAnQjgUXym1pnNkSA@mail.gmail.com> <004201cdcc3a$a7538310$f5fa8930$@lucidpixels.com> <CAErSpo7530xA6=1Ytj09dwyS1M_N_yAfk4xkr3f9Z_NBn6TJrA@mail.gmail.com> <00a501cdcca3$c2638510$472a8f30$@lucidpixels.com> <00b501cdcca6$03f88af0$0be9a0d0$@lucidpixels.com> <00b701cdcca6$ff097620$fd1c6260$@lucidpixels.com> <00cc01cdccac$7c273d40$7475b7c0$@lucidpixels.com> <CAErSpo6b2CBLCs9uP5Ls2qdM3QKG73pychSp9O4ADD07h_bdTA@mail.gmail.com>
In-Reply-To: <CAErSpo6b2CBLCs9uP5Ls2qdM3QKG73pychSp9O4ADD07h_bdTA@mail.gmail.com>
Subject: RE: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware bug question
Date: Wed, 28 Nov 2012 19:49:19 -0500
Message-ID: <04b201cdcdcb$5e2a2d50$1a7e87f0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQH421ylXKr/7aSEd56ctRShmAJ9gwGHtGctAMAwLAsA1DUSgwLbZdCZAXol/xoByREOOQK10CNCAguYW3MCOIRwlQL37+fVlxB3JlA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Bjorn Helgaas [mailto:bhelgaas@google.com] 
Sent: Wednesday, November 28, 2012 7:09 PM
To: Justin Piszcz
Cc: Bruno Prémont; support@supermicro.com; linux-kernel@vger.kernel.org; Dan
Williams
Subject: Re: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware
bug question

On Tue, Nov 27, 2012 at 7:35 AM, Justin Piszcz <jpiszcz@lucidpixels.com>
wrote:
>
>
> -----Original Message-----
> From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com]
> Sent: Tuesday, November 27, 2012 8:56 AM
> To: 'Bjorn Helgaas'
> Cc: 'Bruno Prémont'; support@supermicro.com; linux-kernel@vger.kernel.org;
> 'Dan Williams'
> Subject: RE: Supermicro X9SRL-F - channel enumeration error &
ACPI/firmware
> bug question
>
>
>> It is _not_ working on the:
>
>> 2) Supermicro X8DTH-F (the boot drive in this system is running off a
> PCI-e
>> card, could the IRQ for the I/O controller be getting re-mapped and
> fail?)--
>> worse case I can move the SSD from the 6.0gbpa SATA card to the
> motherboard
>> and see if that works, but that kind of defeats the purpose of a 6.0gbps
>> SATA SSD.
>
> When I removed the Highpoint 2-port SATA card and plugged it into the
> motherboard, the system boots (plugged the SSD into the motherboard).
> So if you use a HIGHPOINT 2-PORT SATA 6.0gbps card, do NOT enable IOMMU or
> it will fail to initialize the Highpoint 2-port SATA controller card!
> I also tried upgrading the BIOS (of the mobo, no diff)
> I also tried just leaving the SATA card in and plugging it into the
> motherboard (no diff)
> Removed the Highpoint 2-port SATA card and then success, it would be nice
to
> use that card with IOMMU support though, is it just not compatible
> (marvell-problem?) or is a driver bug?  Based on the pictures/etc sent
> earlier?

I would guess this is a core bug, but it's hard to tell without more
information.

If you boot with "intel_iommu=off", I would guess the Highpoint card
would work (this should have the same effect as turning off
CONFIG_INTEL_IOMMU).  I'd like to compare the complete dmesg log for
that boot with the one that fails.

It sounds like it might be hard to collect the log for the failing
case -- you said the boot fails when the Highpoint card is in the
system even if the SSD is connected to the motherboard instead of the
Highpoint card.  The panic in the photo2 image looks like it's just a
failure to mount the root filesystem, which is what I'd expect if we
can't find the SSD.  It seems like we ought to be able to *boot* with
the SSD connected to the motherboard, even if the Highpoint card
doesn't work.  But worst-case, a video of the failing boot might be
enough, especially if you can slow it down with "boot_delay="

--

SUMMARY: Card fails with iommu support in the kernel: (but system does now
boot (3.6.8) with the card in as long as the system disk isn't attached to
it, not sure what was wrong earlier).

It seems to be working now:
=> SSD on motherboard
=> PCI-e card (highpoint in the system but not used, no disks attached)

(After I enabled nouveau, not sure that has anything to do with it) I put
the card in, and it errors as usual but the SSD now on the motherboard it
does boot successfully.  

Here are the errors from the kernel trying to initialize the board with
iommu enabled (retrieved via netconsole) also picture below (w/help from
boot_delay=100 && nouveau enabled):
http://home.comcast.net/~jpiszcz/20121128/highpoint.jpg

Nov 28 19:30:16 p34 [    7.771060] ata14.00: qc timeout (cmd 0xa1) 
Nov 28 19:30:16 p34 [    8.270153] ata14.00: failed to IDENTIFY (I/O error,
err_mask=0x4) 
Nov 28 19:30:17 p34 [    9.073935] ata14: SATA link up 1.5 Gbps (SStatus 113
SControl 300) 
Nov 28 19:30:27 p34 [   19.058915] ata14.00: qc timeout (cmd 0xa1) 
Nov 28 19:30:28 p34 [   19.557885] ata14.00: failed to IDENTIFY (I/O error,
err_mask=0x4) 
Nov 28 19:30:28 p34 [   19.558478] ata14: limiting SATA link speed to 1.5
Gbps 
Nov 28 19:30:29 p34 [   20.363658] ata14: SATA link up 1.5 Gbps (SStatus 113
SControl 310) 
Nov 28 19:30:48 p34 [   39.568234] dmar: DRHD: handling fault status reg 502

Nov 28 19:30:48 p34 [   39.571508] dmar: DMAR:[DMA Read] Request device
[04:00.0] fault addr 0  [   39.571508] DMAR:[fault reason 06] PTE Read
access is not set 
Nov 28 19:30:59 p34 [   50.318146] ata14.00: qc timeout (cmd 0xa1) 
Nov 28 19:30:59 p34 [   50.818061] ata14.00: failed to IDENTIFY (I/O error,
err_mask=0x4) 
Nov 28 19:31:00 p34 [   51.621827] ata14: SATA link up 1.5 Gbps (SStatus 113
SControl 310)

Justin.



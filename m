Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab2K2AzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:55:21 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:44862 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932558Ab2K2AzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:55:19 -0500
MIME-Version: 1.0
In-Reply-To: <04b301cdcdcb$65e2f400$31a8dc00$@lucidpixels.com>
References: <097501cdca7b$7e303890$7a90a9b0$@lucidpixels.com>
	<20121126224245.248f0901@neptune.home>
	<CAErSpo7Y7m9o2u36ghiW1UDkwweSCG1ZGBx167Anfw4wXTYrCg@mail.gmail.com>
	<CAErSpo6vrHMTht1nQxiF6HD7qCvUE-NS2eAnQjgUXym1pnNkSA@mail.gmail.com>
	<004201cdcc3a$a7538310$f5fa8930$@lucidpixels.com>
	<CAErSpo7530xA6=1Ytj09dwyS1M_N_yAfk4xkr3f9Z_NBn6TJrA@mail.gmail.com>
	<00a501cdcca3$c2638510$472a8f30$@lucidpixels.com>
	<00b501cdcca6$03f88af0$0be9a0d0$@lucidpixels.com>
	<50B6ADA5.2030205@gmail.com>
	<04b301cdcdcb$65e2f400$31a8dc00$@lucidpixels.com>
Date: Wed, 28 Nov 2012 18:55:17 -0600
Message-ID: <CADLC3L09uxX_AU+22nfS20DCE97n1_ZxkG5A1R9joJcEua-EBg@mail.gmail.com>
Subject: Re: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware
 bug question
From: Robert Hancock <hancockrwd@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        support@supermicro.com, linux-kernel@vger.kernel.org,
        Dan Williams <djbw@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 6:49 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> -----Original Message-----
> From: Robert Hancock [mailto:hancockrwd@gmail.com]
> Sent: Wednesday, November 28, 2012 7:35 PM
> To: Justin Piszcz
> Cc: 'Bjorn Helgaas'; 'Bruno Prémont'; support@supermicro.com;
> linux-kernel@vger.kernel.org; 'Dan Williams'
> Subject: Re: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware
> bug question
>
>
> What does lspci -vv show on that controller? Not sure what actual
> chipset that controller is, but there's a known issue with some Marvell
> 6Gbps SATA controllers with DMAR enabled - it seems the device issues
> memory read/write requests from the wrong PCI function ID and the IOMMU
> rightly denies access as the function listed in the requests doesn't
> have any mapping to that memory. I don't think there's presently a
> workaround other than disabling DMAR. We could (and likely should) be
> detecting that device and adding some kind of quirk for it.
>
> That sounds likely...
> It is shown below:
>
> Card name: HighPoint Rocket 620 Dual Port SATA 6 Gbps PCI Express 2.0 Host
> Adapter
>
> lspci -vv output:
>
> 84:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9123 PCIe SATA
> 6.0 Gb/s controller (rev 11) (prog-if 01 [AHCI 1.0])
>   Subsystem: Marvell Technology Group Ltd. 88SE9123 PCIe SATA 6.0 Gb/s
> controller

Yeah, that's one of those controllers I think. But I can't tell from
the bit of the dmesg you posted exactly what's going on. Can you post
a full boot log from having the card installed and some drive attached
(by putting the boot drive on another controller for example)?

>> ==> Further issues with the X9SRL-F -- does this board support ASPM or is
>> this a Linux/ASPM implementation issue?
>> [    0.632170]  pci0000:ff: ACPI _OSC support notification failed,
> disabling
>> PCIe ASPM
>> [    0.632239]  pci0000:ff: Unable to request _OSC control (_OSC support
>> mask: 0x08)
>
> What's the full dmesg from this machine (or is it already posted somewhere)?
>
> It is now available here:
> http://home.comcast.net/~jpiszcz/20121128/dmesg.txt

Is that the same boot log? It doesn't have this error in it.

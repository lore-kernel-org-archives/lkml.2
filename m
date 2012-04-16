Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab2DPUxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:53:39 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51564 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab2DPUxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:53:38 -0400
MIME-Version: 1.0
In-Reply-To: <4F8C6E4E.1000205@fold.natur.cuni.cz>
References: <4F6A483D.50702@fold.natur.cuni.cz>
	<CAE9FiQVnErU-cska4gpinyj-LOup-U+3vsEG2z_-7h6kyREYtw@mail.gmail.com>
	<4F6A5A53.305@fold.natur.cuni.cz>
	<CAE9FiQXP7fO9OGN557jdofFFiFj96wL--ZA8X3UPEJ6o9JLvBw@mail.gmail.com>
	<4F8BEB1D.9080903@fold.natur.cuni.cz>
	<CAE9FiQXoX3J6P_9Tun_XbkK3egvSeBZxAtC13HacFDO0fwmZaA@mail.gmail.com>
	<4F8C6E4E.1000205@fold.natur.cuni.cz>
Date: Mon, 16 Apr 2012 13:53:37 -0700
X-Google-Sender-Auth: eCu_3HZsoVv8_9aTHQhT-j-S2oo
Message-ID: <CAE9FiQXikqikMw_LYGqAUsWqFqL-tLiresPhpkpDhb+AxwundQ@mail.gmail.com>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec timeframe
From: Yinghai Lu <yinghai@kernel.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 12:09 PM, Martin Mokrejs
<mmokrejs@fold.natur.cuni.cz> wrote:
> Yinghai Lu wrote:
>> On Mon, Apr 16, 2012 at 2:49 AM, Martin Mokrejs
>> <mmokrejs@fold.natur.cuni.cz> wrote:
>>> Hi Yinghai,
>>>
>>> Yinghai Lu wrote:
>>>> On Wed, Mar 21, 2012 at 3:46 PM, Martin Mokrejs
>>>   I had some Ooopses with 3.4-rc2 but now I have tested 3.4-rc3. Still, linux
>>> does NOT realize that I have removed an ExpressCard from the slot. It realizes
>>> that only when I pluging the card back again. Actually, this is a case of a
>>> NEC chipset base USB3.0 card.
>>>
>>>  In contrast, kernel DOES recognize that I unplugged a FireWire card from the
>>> same slot.
>>>
>>>  This is a Dell Vostro 3550 laptop. Below is what syslog logged with my comment.
>>> Empty lines between the log entries are inserted whe I either inserted or removed
>>> a card. Probably a bit more will be in the attached dmesg file.
>>>
>
> [cut]
>
>>
>> please check boot with pciehp.pciehp_debug=1
>>
>> also you could use tail -f /var/log/messages to get more timely outputs.
>
>
> I do not see anything extra logged during those INSERT/REMOVE attempts. Yes, there is somethiung
> in dmesg logged in addition when the machine booted up.
>
>
> INSERTING THE USB3.0 CARD FOR THE FIRST TIME AFTER BOOTUP
>
> Apr 16 20:40:32 vostro kernel: [  419.776551] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
> Apr 16 20:40:33 vostro kernel: [  420.798623] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
> Apr 16 20:40:33 vostro kernel: [  420.798657] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
> Apr 16 20:40:33 vostro kernel: [  420.798666] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
> Apr 16 20:40:33 vostro kernel: [  420.798678] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
> Apr 16 20:40:33 vostro kernel: [  420.798689] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
> Apr 16 20:40:33 vostro kernel: [  420.798827] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
> Apr 16 20:40:33 vostro kernel: [  420.798882] xhci_hcd 0000:11:00.0: xHCI Host Controller
> Apr 16 20:40:33 vostro kernel: [  420.798930] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
> Apr 16 20:40:33 vostro kernel: [  420.799256] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
> Apr 16 20:40:33 vostro kernel: [  420.799547] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
> Apr 16 20:40:33 vostro kernel: [  420.799548] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> Apr 16 20:40:33 vostro kernel: [  420.799549] usb usb5: Product: xHCI Host Controller
> Apr 16 20:40:33 vostro kernel: [  420.799551] usb usb5: Manufacturer: Linux 3.3.2-default xhci_hcd
> Apr 16 20:40:33 vostro kernel: [  420.799552] usb usb5: SerialNumber: 0000:11:00.0
> Apr 16 20:40:33 vostro kernel: [  420.799654] hub 5-0:1.0: USB hub found
> Apr 16 20:40:33 vostro kernel: [  420.799666] hub 5-0:1.0: 2 ports detected
> Apr 16 20:40:33 vostro kernel: [  420.799726] xhci_hcd 0000:11:00.0: xHCI Host Controller
> Apr 16 20:40:33 vostro kernel: [  420.799757] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
> Apr 16 20:40:33 vostro kernel: [  420.802464] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
> Apr 16 20:40:33 vostro kernel: [  420.802466] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> Apr 16 20:40:33 vostro kernel: [  420.802468] usb usb6: Product: xHCI Host Controller
> Apr 16 20:40:33 vostro kernel: [  420.802470] usb usb6: Manufacturer: Linux 3.3.2-default xhci_hcd
> Apr 16 20:40:33 vostro kernel: [  420.802471] usb usb6: SerialNumber: 0000:11:00.0
> Apr 16 20:40:33 vostro kernel: [  420.802632] hub 6-0:1.0: USB hub found
> Apr 16 20:40:33 vostro kernel: [  420.802651] hub 6-0:1.0: 2 ports detected
>
> REMOVED THE USB3.0 CARD
>
> RE-INSERTING THE USB3.0 CARD
>
> Apr 16 20:40:44 vostro kernel: [  431.946895] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
> Apr 16 20:40:44 vostro kernel: [  431.947148] xhci_hcd 0000:11:00.0: remove, state 4
> Apr 16 20:40:44 vostro kernel: [  431.947152] usb usb6: USB disconnect, device number 1
> Apr 16 20:40:44 vostro kernel: [  431.947331] xhci_hcd 0000:11:00.0: USB bus 6 deregistered
> Apr 16 20:40:44 vostro kernel: [  431.947398] xhci_hcd 0000:11:00.0: remove, state 4
> Apr 16 20:40:44 vostro kernel: [  431.947402] usb usb5: USB disconnect, device number 1
> Apr 16 20:40:44 vostro kernel: [  431.947642] xhci_hcd 0000:11:00.0: USB bus 5 deregistered
> Apr 16 20:40:44 vostro kernel: [  431.968146] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
> Apr 16 20:40:45 vostro kernel: [  432.990453] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
> Apr 16 20:40:45 vostro kernel: [  432.990487] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
> Apr 16 20:40:45 vostro kernel: [  432.990496] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
> Apr 16 20:40:45 vostro kernel: [  432.990509] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
> Apr 16 20:40:45 vostro kernel: [  432.990520] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
> Apr 16 20:40:45 vostro kernel: [  432.990649] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
> Apr 16 20:40:45 vostro kernel: [  432.990685] xhci_hcd 0000:11:00.0: xHCI Host Controller
> Apr 16 20:40:45 vostro kernel: [  432.990723] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
> Apr 16 20:40:45 vostro kernel: [  432.991014] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
> Apr 16 20:40:45 vostro kernel: [  432.991354] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
> Apr 16 20:40:45 vostro kernel: [  432.991357] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> Apr 16 20:40:45 vostro kernel: [  432.991359] usb usb5: Product: xHCI Host Controller
> Apr 16 20:40:45 vostro kernel: [  432.991360] usb usb5: Manufacturer: Linux 3.3.2-default xhci_hcd
> Apr 16 20:40:45 vostro kernel: [  432.991362] usb usb5: SerialNumber: 0000:11:00.0
> Apr 16 20:40:45 vostro kernel: [  432.991511] hub 5-0:1.0: USB hub found
> Apr 16 20:40:45 vostro kernel: [  432.991523] hub 5-0:1.0: 2 ports detected
> Apr 16 20:40:45 vostro kernel: [  432.991604] xhci_hcd 0000:11:00.0: xHCI Host Controller
> Apr 16 20:40:45 vostro kernel: [  432.991678] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
> Apr 16 20:40:45 vostro kernel: [  432.994264] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
> Apr 16 20:40:45 vostro kernel: [  432.994266] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> Apr 16 20:40:45 vostro kernel: [  432.994268] usb usb6: Product: xHCI Host Controller
> Apr 16 20:40:45 vostro kernel: [  432.994269] usb usb6: Manufacturer: Linux 3.3.2-default xhci_hcd
> Apr 16 20:40:45 vostro kernel: [  432.994270] usb usb6: SerialNumber: 0000:11:00.0
> Apr 16 20:40:45 vostro kernel: [  432.994431] hub 6-0:1.0: USB hub found
> Apr 16 20:40:45 vostro kernel: [  432.994449] hub 6-0:1.0: 2 ports detected
>

so the interrupt for removal get generated, but pcie_isr() is delayed
when another surprise is generated...

could be threaded_irq changes related.  Thomas ?

>
> INSERTING THE FireWire CARD
>
> Apr 16 20:41:27 vostro kernel: [  474.869403] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
> Apr 16 20:41:27 vostro kernel: [  474.869657] xhci_hcd 0000:11:00.0: remove, state 4
> Apr 16 20:41:27 vostro kernel: [  474.869661] usb usb6: USB disconnect, device number 1
> Apr 16 20:41:27 vostro kernel: [  474.869809] xhci_hcd 0000:11:00.0: USB bus 6 deregistered
> Apr 16 20:41:27 vostro kernel: [  474.869852] xhci_hcd 0000:11:00.0: remove, state 4
> Apr 16 20:41:27 vostro kernel: [  474.869857] usb usb5: USB disconnect, device number 1
> Apr 16 20:41:27 vostro kernel: [  474.870049] xhci_hcd 0000:11:00.0: USB bus 5 deregistered
> Apr 16 20:41:27 vostro kernel: [  474.878567] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
> Apr 16 20:41:28 vostro kernel: [  475.906546] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c007ff 64bit]
> Apr 16 20:41:28 vostro kernel: [  475.906570] pci 0000:11:00.0: BAR 2: assigned [io  0xc000-0xc0ff]
> Apr 16 20:41:28 vostro kernel: [  475.906584] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
> Apr 16 20:41:28 vostro kernel: [  475.906592] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
> Apr 16 20:41:28 vostro kernel: [  475.906605] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
> Apr 16 20:41:28 vostro kernel: [  475.906627] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
> Apr 16 20:41:28 vostro kernel: [  475.986838] firewire_ohci 0000:11:00.0: enabling device (0100 -> 0103)
> Apr 16 20:41:29 vostro kernel: [  476.066286] firewire_ohci: Added fw-ohci device 0000:11:00.0, OHCI v1.10, 4 IR + 8 IT contexts, quirks 0x11
> Apr 16 20:41:29 vostro kernel: [  476.565663] firewire_core: created device fw0: GUID 0011066600000003, S400
>
>
> REMOVING FireWire CARD
>
>
> Apr 16 20:41:39 vostro kernel: [  486.621576] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
> Apr 16 20:41:39 vostro kernel: [  486.621984] firewire_ohci: Removed fw-ohci device.
>

this card is not delayed.

Yinghai

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab2DXUqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 16:46:22 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:52493 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757530Ab2DXUqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 16:46:21 -0400
Message-ID: <4F971147.3000501@fold.natur.cuni.cz>
Date: Tue, 24 Apr 2012 22:47:03 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120319 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec
 timeframe
References: <4F909CEB.3060407@fold.natur.cuni.cz> <CAE9FiQU7gnKiwazN_2ykbXSkcuDqWMZNt0CHiGvae2L+rTVGug@mail.gmail.com> <CAE9FiQUk8D20mEFPE0ahwfigbEOHpbRp-X0wt4DC+293msw=4Q@mail.gmail.com> <4F91473A.1080007@fold.natur.cuni.cz> <CAE9FiQUQRAfdG1J6XUVcOVkeR00vyqnCrBg1O3S_ByC3dKOUog@mail.gmail.com> <4F919C22.1070608@fold.natur.cuni.cz> <4F919CD5.7070004@fold.natur.cuni.cz> <CAE9FiQV_cRTDTBmQwNLJtT-N=HTAxBiphBLDmKxM-N0JKyoR-w@mail.gmail.com> <20120420231748.GB7069@xanatos> <CAE9FiQX7JCZvL9S8ZOQQaHQ4nfU0XDj=8FmOfCtcz7WFjP8=Bg@mail.gmail.com> <20120421132516.GC7069@xanatos> <CAE9FiQUuHrsNPhPWAc9koOrW6Xc+ryOhf_nv2ZyWvG9XMAdNoA@mail.gmail.com>
In-Reply-To: <CAE9FiQUuHrsNPhPWAc9koOrW6Xc+ryOhf_nv2ZyWvG9XMAdNoA@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

Yinghai Lu wrote:
> On Sat, Apr 21, 2012 at 6:25 AM, Sarah Sharp
> <sarah.a.sharp@linux.intel.com> wrote:
>> On Fri, Apr 20, 2012 at 05:09:48PM -0700, Yinghai Lu wrote:
>>> On Fri, Apr 20, 2012 at 4:17 PM, Sarah Sharp
>>> <sarah.a.sharp@linux.intel.com> wrote:
>>>> On Fri, Apr 20, 2012 at 11:47:14AM -0700, Yinghai Lu wrote:
>>>>> On Fri, Apr 20, 2012 at 10:28 AM, Martin Mokrejs
>>>>> <mmokrejs@fold.natur.cuni.cz> wrote:
>>>>>> [30720.175637] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 108
>>>>>> [30720.175639] pciehp 0000:00:1c.7:pcie04: LinkState change
>>>>>> [30720.175643] pciehp 0000:00:1c.7:pcie04: lnk_status = 5011
>>>>>> [30720.175644] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
>>>>>> [30720.175648] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
>>>>>> [30720.175687] pciehp 0000:00:1c.7:pcie04: Surprise Removal
>>>>>> [30720.175718] pciehp 0000:00:1c.7:pcie04: Disabling domain:bus:device=0000:11:00
>>>>>> [30720.175721] pciehp 0000:00:1c.7:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:11:00
>>>>>>
>>>>>
>>>>> So the USB host control driver xhci put that 11:00.0 in strange power state.
>>>>
>>>> What do you mean "strange power state"?  The only PCI power states the
>>>> xHCI driver will use is D0 or D3hot.  D3hot is entered automatically by
>>>> the USB core runtime PM system when all USB devices are disconnected or
>>>> suspended.  So what strange power state are we talking about?
>>>
>>> that's helpful. Can that feature to be disabled?
>>
>> Yes.  There are several ways to disable automatic entry into D3hot.
>> The easiest way is to turn off CONFIG_USB_SUSPEND, which will disable
>> USB autosuspend (and subsequent runtime PM entry into D3hot) for all USB
>> hosts and devices.
> 
> Please try to boot with
> usbcore.autosuspend=0

Sorry for the delay, I was on a travel ...

With the express card itself (no USB devices attached to it) I do not see
a difference. Is this what you wanted me to test?



inserting

Apr 24 22:41:53 vostro kernel: [  523.968598] pciehp 0000:00:1c.7:pcie04: lnk_status = 7011
Apr 24 22:41:53 vostro kernel: [  523.968602] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
Apr 24 22:41:53 vostro kernel: [  524.091233] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
Apr 24 22:41:53 vostro kernel: [  524.091275] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
Apr 24 22:41:53 vostro kernel: [  524.091278] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
Apr 24 22:41:53 vostro kernel: [  524.091283] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
Apr 24 22:41:53 vostro kernel: [  524.091287] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
Apr 24 22:41:53 vostro kernel: [  524.091423] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
Apr 24 22:41:53 vostro kernel: [  524.091478] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 24 22:41:53 vostro kernel: [  524.091482] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
Apr 24 22:41:53 vostro kernel: [  524.091783] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
Apr 24 22:41:53 vostro kernel: [  524.092049] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
Apr 24 22:41:53 vostro kernel: [  524.092051] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 24 22:41:53 vostro kernel: [  524.092052] usb usb5: Product: xHCI Host Controller
Apr 24 22:41:53 vostro kernel: [  524.092053] usb usb5: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 24 22:41:53 vostro kernel: [  524.092054] usb usb5: SerialNumber: 0000:11:00.0
Apr 24 22:41:53 vostro kernel: [  524.092201] hub 5-0:1.0: USB hub found
Apr 24 22:41:53 vostro kernel: [  524.092212] hub 5-0:1.0: 2 ports detected
Apr 24 22:41:53 vostro kernel: [  524.092281] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 24 22:41:53 vostro kernel: [  524.092284] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
Apr 24 22:41:53 vostro kernel: [  524.095021] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
Apr 24 22:41:53 vostro kernel: [  524.095024] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 24 22:41:53 vostro kernel: [  524.095026] usb usb6: Product: xHCI Host Controller
Apr 24 22:41:53 vostro kernel: [  524.095028] usb usb6: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 24 22:41:53 vostro kernel: [  524.095030] usb usb6: SerialNumber: 0000:11:00.0
Apr 24 22:41:53 vostro kernel: [  524.095157] hub 6-0:1.0: USB hub found
Apr 24 22:41:53 vostro kernel: [  524.095176] hub 6-0:1.0: 2 ports detected


removing

re-inserting

Apr 24 22:43:17 vostro kernel: [  608.433647] pciehp 0000:00:1c.7:pcie04: lnk_status = 5011
Apr 24 22:43:17 vostro kernel: [  608.433651] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
Apr 24 22:43:17 vostro kernel: [  608.445663] xhci_hcd 0000:11:00.0: remove, state 4
Apr 24 22:43:17 vostro kernel: [  608.445669] usb usb6: USB disconnect, device number 1
Apr 24 22:43:17 vostro kernel: [  608.445824] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 24 22:43:17 vostro kernel: [  608.445828] xhci_hcd 0000:11:00.0: USB bus 6 deregistered
Apr 24 22:43:17 vostro kernel: [  608.445833] xhci_hcd 0000:11:00.0: remove, state 4
Apr 24 22:43:17 vostro kernel: [  608.445836] usb usb5: USB disconnect, device number 1
Apr 24 22:43:17 vostro kernel: [  608.446056] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 24 22:43:17 vostro kernel: [  608.446149] xhci_hcd 0000:11:00.0: USB bus 5 deregistered
Apr 24 22:43:17 vostro kernel: [  608.449971] pciehp 0000:00:1c.7:pcie04: lnk_status = 7011
Apr 24 22:43:17 vostro kernel: [  608.449976] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
Apr 24 22:43:17 vostro kernel: [  608.575392] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
Apr 24 22:43:17 vostro kernel: [  608.575434] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
Apr 24 22:43:17 vostro kernel: [  608.575438] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
Apr 24 22:43:17 vostro kernel: [  608.575443] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
Apr 24 22:43:17 vostro kernel: [  608.575447] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
Apr 24 22:43:17 vostro kernel: [  608.575575] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
Apr 24 22:43:17 vostro kernel: [  608.575649] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 24 22:43:17 vostro kernel: [  608.575655] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
Apr 24 22:43:17 vostro kernel: [  608.575956] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
Apr 24 22:43:17 vostro kernel: [  608.576238] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
Apr 24 22:43:17 vostro kernel: [  608.576240] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 24 22:43:17 vostro kernel: [  608.576241] usb usb5: Product: xHCI Host Controller
Apr 24 22:43:17 vostro kernel: [  608.576242] usb usb5: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 24 22:43:17 vostro kernel: [  608.576243] usb usb5: SerialNumber: 0000:11:00.0
Apr 24 22:43:17 vostro kernel: [  608.576399] hub 5-0:1.0: USB hub found
Apr 24 22:43:17 vostro kernel: [  608.576411] hub 5-0:1.0: 2 ports detected
Apr 24 22:43:17 vostro kernel: [  608.576472] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 24 22:43:17 vostro kernel: [  608.576475] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
Apr 24 22:43:17 vostro kernel: [  608.579188] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
Apr 24 22:43:17 vostro kernel: [  608.579191] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 24 22:43:17 vostro kernel: [  608.579193] usb usb6: Product: xHCI Host Controller
Apr 24 22:43:17 vostro kernel: [  608.579195] usb usb6: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 24 22:43:17 vostro kernel: [  608.579196] usb usb6: SerialNumber: 0000:11:00.0
Apr 24 22:43:17 vostro kernel: [  608.579324] hub 6-0:1.0: USB hub found
Apr 24 22:43:17 vostro kernel: [  608.579342] hub 6-0:1.0: 2 ports detected


removing




> 
> Yinghai
> 
> 

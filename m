Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab2DRRxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:53:45 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:50803 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751537Ab2DRRxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:53:43 -0400
Message-ID: <4F8EFFA3.3050705@fold.natur.cuni.cz>
Date: Wed, 18 Apr 2012 19:53:39 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120319 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec
 timeframe
References: <4F6A483D.50702@fold.natur.cuni.cz> <CAE9FiQVnErU-cska4gpinyj-LOup-U+3vsEG2z_-7h6kyREYtw@mail.gmail.com> <4F6A5A53.305@fold.natur.cuni.cz> <CAE9FiQXP7fO9OGN557jdofFFiFj96wL--ZA8X3UPEJ6o9JLvBw@mail.gmail.com> <4F8BEB1D.9080903@fold.natur.cuni.cz> <CAE9FiQXoX3J6P_9Tun_XbkK3egvSeBZxAtC13HacFDO0fwmZaA@mail.gmail.com> <4F8C6E4E.1000205@fold.natur.cuni.cz> <CAE9FiQXikqikMw_LYGqAUsWqFqL-tLiresPhpkpDhb+AxwundQ@mail.gmail.com> <CAE9FiQUFB=9zbP1yuBDH1RJrCCP=83kV_fH+TEtk80981-uP=w@mail.gmail.com> <CAE9FiQUbzM_TVu+bbXa6LWiUt01QsFiGoyYd0qV=41dXx4J31g@mail.gmail.com> <4F8D1B72.2000105@fold.natur.cuni.cz> <CAE9FiQW2MAW_WT+sq8XVtMOx=uR8FAN8O2wL2AOxkFBfEM285g@mail.gmail.com> <CAE9FiQWSw1h772ijZ6YL4EujwjgvZ84bbDx9VbF_cdE63D-41w@mail.gmail.com> <4F8D390F.9050408@fold.natur.cuni.cz> <CAE9FiQU-_BCCS1OKagVuj8YNrut8-6GH2_i86FsfS8UDWQ1pRA@mail.gmail.com> <CAE9FiQUxoHvUWFXv5LLcBT9vVGnQKp1-Tg7M3XPPULWwtX1iUw@mail.gmail.com>
In-Reply-To: <CAE9FiQUxoHvUWFXv5LLcBT9vVGnQKp1-Tg7M3XPPULWwtX1iUw@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yinghai Lu wrote:
> On Tue, Apr 17, 2012 at 10:07 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Tue, Apr 17, 2012 at 2:34 AM, Martin Mokrejs
>> <mmokrejs@fold.natur.cuni.cz> wrote:
>>> Yinghai Lu wrote:
>>>> On Tue, Apr 17, 2012 at 1:46 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>>>> On Tue, Apr 17, 2012 at 12:27 AM, Martin Mokrejs
>>>>> <mmokrejs@fold.natur.cuni.cz> wrote:
>>>>>>>
>>>>>>> can you send out lspci -vvxxxx -s 00:1c.7 after removing USB 3.0 express card?
>>>>>>
>>>>>> No, that did not help (tried on 3.4-rc3). First I plugged in the NEC uPD720200 USB3.0 card
>>>>>> and unplugged it (card removal not reported :(), saved the lspci output.
>>>>>> Then I inserted the FireWire card, unplugged, again saved the lspci output.
>>>>>> Finally, saved the dmesg. All three files are attached.
>>>>>
>>>>> for USB 3.0:
>>>>>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
>>>>>                        Changed: MRL- PresDet- LinkState+
>>>>
>>>> LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
>>>> BWMgmt+ ABWMgmt-
>>>>
>>>> link still active even that card get removed, that looks like chipset
>>>> have problem.
>>>
>>> Yinghai,
>>>  so what should I ask Dell for? To fix BIOS of the laptop? What exactly? Or do you think
>>> this is a hardware issue with the chipset?
>>
>> after the expresscard get removed, that root port socket status bits
>> still report Data Link Active, and
>> the card still present.
>>
>> Better check with Dell at first, and ask them to talk with intel if
>> there is silicon bug with that chipset that report wrong status.
>>
>> Let me check if i could rebase one my local patch do reset pcie link
>> to prove that problem it silicon related.
> 
> Rebase patches about pcie link disable/enable in /sys. please check them at
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> for-pci-test
> 
>   PCI, sysfs: merge dev and bus cpuaffinity show handling
>   PCI, sys: Use is_visable() with boot_vga attribute for pci_dev
>   PCI, sysfs: Put resource_alignment info pci_bus_attrs array
>   PCI: Move pcie_link_disable to pcie-link.c
>   PCI, sysfs: Add pcie attrs for pcie device under pci dev dir.
>   PCI: Add link_disable in /sysfs for pcie device
> 
> it is based on for-pci-root-bus-hotplug branch
> 
> Or you can just master branch like
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
> 
> After you remove USB3 expresscard, you need to
> 
> echo 1 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
> then
> echo 0 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable

So without these two echo commands the is no improvement/fix.

[  686.701306] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
[  686.701316] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
[  686.701319] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
[  686.701357] pciehp 0000:00:1c.7:pcie04: Surprise Removal
[  686.701390] pciehp 0000:00:1c.7:pcie04: check_link_active: lnk_status = 7011
[  686.809763] pciehp 0000:00:1c.7:pcie04: pciehp_check_link_status: lnk_status = 7011
[  686.809864] pci 0000:11:00.0: [1033:0194] type 00 class 0x0c0330
[  686.809914] pci 0000:11:00.0: reg 10: [mem 0x00000000-0x00001fff 64bit]
[  686.810166] pci 0000:11:00.0: PME# supported from D0 D3hot
[  686.829795] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
[  686.829840] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
[  686.829843] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
[  686.829848] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
[  686.829852] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
[  686.829991] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
[  686.830048] xhci_hcd 0000:11:00.0: xHCI Host Controller
[  686.830054] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
[  686.830348] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
[  686.830466] xhci_hcd 0000:11:00.0: irq 54 for MSI/MSI-X
[  686.830473] xhci_hcd 0000:11:00.0: irq 55 for MSI/MSI-X
[  686.830479] xhci_hcd 0000:11:00.0: irq 56 for MSI/MSI-X
[  686.830485] xhci_hcd 0000:11:00.0: irq 57 for MSI/MSI-X
[  686.830492] xhci_hcd 0000:11:00.0: irq 58 for MSI/MSI-X
[  686.830654] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[  686.830656] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  686.830657] usb usb5: Product: xHCI Host Controller
[  686.830658] usb usb5: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
[  686.830660] usb usb5: SerialNumber: 0000:11:00.0
[  686.830782] xHCI xhci_add_endpoint called for root hub
[  686.830784] xHCI xhci_check_bandwidth called for root hub
[  686.830807] hub 5-0:1.0: USB hub found
[  686.830819] hub 5-0:1.0: 2 ports detected
[  686.830921] xhci_hcd 0000:11:00.0: xHCI Host Controller
[  686.830925] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
[  686.833581] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
[  686.833583] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[  686.833585] usb usb6: Product: xHCI Host Controller
[  686.833586] usb usb6: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
[  686.833587] usb usb6: SerialNumber: 0000:11:00.0
[  686.833639] xHCI xhci_add_endpoint called for root hub
[  686.833641] xHCI xhci_check_bandwidth called for root hub
[  686.833666] hub 6-0:1.0: USB hub found
[  686.833678] hub 6-0:1.0: 2 ports detected

echo 1 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable

[  716.999938] pcieport 0000:00:1c.7: pcie_link_disable_set: lnk_ctrl = 53
[  717.024647] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
[  717.024657] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
[  717.024665] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
[  717.024723] pciehp 0000:00:1c.7:pcie04: Surprise Removal
[  717.024753] pciehp 0000:00:1c.7:pcie04: Disabling domain:bus:device=0000:11:00
[  717.024756] pciehp 0000:00:1c.7:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:11:00
[  717.044828] xhci_hcd 0000:11:00.0: remove, state 4
[  717.044834] usb usb6: USB disconnect, device number 1
[  717.044877] xHCI xhci_drop_endpoint called for root hub
[  717.044885] xHCI xhci_check_bandwidth called for root hub
[  717.044964] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
[  717.044967] xhci_hcd 0000:11:00.0: USB bus 6 deregistered
[  717.044971] xhci_hcd 0000:11:00.0: remove, state 4
[  717.044974] usb usb5: USB disconnect, device number 1
[  717.045000] xHCI xhci_drop_endpoint called for root hub
[  717.045001] xHCI xhci_check_bandwidth called for root hub
[  717.045053] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
[  717.045138] xhci_hcd 0000:11:00.0: USB bus 5 deregistered
[  717.045197] pci 0000:11:00.0: freeing pci_dev info

echo 0 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable

[  748.456914] pcieport 0000:00:1c.7: pcie_link_disable_set: lnk_ctrl = 40


Martin

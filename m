Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750Ab2DSVYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:24:21 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:53903 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933676Ab2DSVRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:17:07 -0400
Message-ID: <4F909CEB.3060407@fold.natur.cuni.cz>
Date: Fri, 20 Apr 2012 01:16:59 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120319 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec
 timeframe
References: <4F6A483D.50702@fold.natur.cuni.cz> <4F8BEB1D.9080903@fold.natur.cuni.cz> <CAE9FiQXoX3J6P_9Tun_XbkK3egvSeBZxAtC13HacFDO0fwmZaA@mail.gmail.com> <4F8C6E4E.1000205@fold.natur.cuni.cz> <CAE9FiQXikqikMw_LYGqAUsWqFqL-tLiresPhpkpDhb+AxwundQ@mail.gmail.com> <CAE9FiQUFB=9zbP1yuBDH1RJrCCP=83kV_fH+TEtk80981-uP=w@mail.gmail.com> <CAE9FiQUbzM_TVu+bbXa6LWiUt01QsFiGoyYd0qV=41dXx4J31g@mail.gmail.com> <4F8D1B72.2000105@fold.natur.cuni.cz> <CAE9FiQW2MAW_WT+sq8XVtMOx=uR8FAN8O2wL2AOxkFBfEM285g@mail.gmail.com> <CAE9FiQWSw1h772ijZ6YL4EujwjgvZ84bbDx9VbF_cdE63D-41w@mail.gmail.com> <4F8D390F.9050408@fold.natur.cuni.cz> <CAE9FiQU-_BCCS1OKagVuj8YNrut8-6GH2_i86FsfS8UDWQ1pRA@mail.gmail.com> <CAE9FiQUxoHvUWFXv5LLcBT9vVGnQKp1-Tg7M3XPPULWwtX1iUw@mail.gmail.com> <4F8EFFA3.3050705@fold.natur.cuni.cz> <CAE9FiQVcJbPub1O6nwyNsiijHFpHN0jMsGO4MmKugybPL7Wnug@mail.gmail.com> <4F8F243B.70906@fold.natur.cuni.cz> <CAE9FiQXx1NcGY9cHDiM5isx7NyxWN--Exb-4Gfj0arr6vf5ghQ@mail.gmail.com>
In-Reply-To: <CAE9FiQXx1NcGY9cHDiM5isx7NyxWN--Exb-4Gfj0arr6vf5ghQ@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yinghai Lu wrote:
> On Wed, Apr 18, 2012 at 1:29 PM, Martin Mokrejs
> <mmokrejs@fold.natur.cuni.cz> wrote:
>> Yinghai Lu wrote:
>>> On Wed, Apr 18, 2012 at 10:53 AM, Martin Mokrejs
>>> <mmokrejs@fold.natur.cuni.cz> wrote:
>>>>> After you remove USB3 expresscard, you need to
>>>>>
>>>>> echo 1 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
>>>>> then
>>>>> echo 0 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
>>>>
>>>> So without these two echo commands the is no improvement/fix.
>>>>
>>>> [  686.701306] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
>>>> [  686.701316] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
>>>> [  686.701319] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
>>>> [  686.701357] pciehp 0000:00:1c.7:pcie04: Surprise Removal
>>>> [  686.701390] pciehp 0000:00:1c.7:pcie04: check_link_active: lnk_status = 7011
>>>> [  686.809763] pciehp 0000:00:1c.7:pcie04: pciehp_check_link_status: lnk_status = 7011
>>> ...
>>>> [  686.833678] hub 6-0:1.0: 2 ports detected
>>>>
>>>> echo 1 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
>>>>
>>>> [  716.999938] pcieport 0000:00:1c.7: pcie_link_disable_set: lnk_ctrl = 53
>>>> [  717.024647] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
>>>> [  717.024657] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
>>>> [  717.024665] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
>>>> [  717.024723] pciehp 0000:00:1c.7:pcie04: Surprise Removal
>>>> [  717.024753] pciehp 0000:00:1c.7:pcie04: Disabling domain:bus:device=0000:11:00
>>>> [  717.024756] pciehp 0000:00:1c.7:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:11:00
>>> ..
>>>> [  717.045197] pci 0000:11:00.0: freeing pci_dev info
>>>>
>>>> echo 0 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
>>>>
>>>> [  748.456914] pcieport 0000:00:1c.7: pcie_link_disable_set: lnk_ctrl = 40
>>>>
>>>
>>> so it is chipset problem, it does not detect and report the presence
>>> of the card after that link is removed.
>>
>> Why doesn't this happen with the FireWire express card?
> 
> sometimes it report correctly. sometime it does not.

I realized with Win 7 that if the Express Card with the two USB 3.0 ports has an external drive
connected, its removal gets "always" detected. Probably because USB is polling for the disk and
realizes that is is gone?

Second observation is that in Device manager if I open the USB controllers list, I see for
this card a USB HUB and a USB controller (two lines in the listig). If I remove the card
the listing doesn't get updated. When I open the ROOT HUB properties, on the General tab
is claimed that it is working well and the system does not realize the card is unplugged
a long while already. But, if I open properties of the HOST CONTROLLER, it I think updates
the "General tab" and says something about code 45. And after closing tgis HOST CONTROLLER
window, the Device manager windows gets refreshed and the two lines related to the card
disappear.



I just tried something similar under linux, with all the patches I accumulated for 3.4-rc3
and posted in my previous emails. It seems linux flips some value so on every second card
removal it really does realize it was just unplugged.


Inserted.


Apr 20 00:56:36 vostro kernel: [ 2851.214712] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
Apr 20 00:56:36 vostro kernel: [ 2851.341855] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
Apr 20 00:56:36 vostro kernel: [ 2851.341892] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
Apr 20 00:56:36 vostro kernel: [ 2851.341907] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
Apr 20 00:56:36 vostro kernel: [ 2851.341912] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
Apr 20 00:56:36 vostro kernel: [ 2851.341916] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
Apr 20 00:56:36 vostro kernel: [ 2851.342042] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
Apr 20 00:56:36 vostro kernel: [ 2851.342083] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 00:56:36 vostro kernel: [ 2851.342088] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
Apr 20 00:56:36 vostro kernel: [ 2851.342391] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
Apr 20 00:56:36 vostro kernel: [ 2851.342677] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
Apr 20 00:56:36 vostro kernel: [ 2851.342678] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 00:56:36 vostro kernel: [ 2851.342680] usb usb5: Product: xHCI Host Controller
Apr 20 00:56:36 vostro kernel: [ 2851.342681] usb usb5: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 00:56:36 vostro kernel: [ 2851.342682] usb usb5: SerialNumber: 0000:11:00.0
Apr 20 00:56:36 vostro kernel: [ 2851.342855] hub 5-0:1.0: USB hub found
Apr 20 00:56:36 vostro kernel: [ 2851.342868] hub 5-0:1.0: 2 ports detected
Apr 20 00:56:36 vostro kernel: [ 2851.342935] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 00:56:36 vostro kernel: [ 2851.342938] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
Apr 20 00:56:36 vostro kernel: [ 2851.345622] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
Apr 20 00:56:36 vostro kernel: [ 2851.345625] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 00:56:36 vostro kernel: [ 2851.345628] usb usb6: Product: xHCI Host Controller
Apr 20 00:56:36 vostro kernel: [ 2851.345629] usb usb6: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 00:56:36 vostro kernel: [ 2851.345631] usb usb6: SerialNumber: 0000:11:00.0
Apr 20 00:56:36 vostro kernel: [ 2851.345738] hub 6-0:1.0: USB hub found
Apr 20 00:56:36 vostro kernel: [ 2851.345756] hub 6-0:1.0: 2 ports detected


Unplugged.

Re-inserted.

Apr 20 00:56:52 vostro kernel: [ 2866.836211] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
Apr 20 00:56:52 vostro kernel: [ 2866.838944] xhci_hcd 0000:11:00.0: remove, state 4
Apr 20 00:56:52 vostro kernel: [ 2866.838950] usb usb6: USB disconnect, device number 1
Apr 20 00:56:52 vostro kernel: [ 2866.839197] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 20 00:56:52 vostro kernel: [ 2866.839201] xhci_hcd 0000:11:00.0: USB bus 6 deregistered
Apr 20 00:56:52 vostro kernel: [ 2866.839207] xhci_hcd 0000:11:00.0: remove, state 4
Apr 20 00:56:52 vostro kernel: [ 2866.839211] usb usb5: USB disconnect, device number 1
Apr 20 00:56:52 vostro kernel: [ 2866.839315] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 20 00:56:52 vostro kernel: [ 2866.839402] xhci_hcd 0000:11:00.0: USB bus 5 deregistered
Apr 20 00:56:52 vostro kernel: [ 2866.852682] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
Apr 20 00:56:52 vostro kernel: [ 2866.978549] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
Apr 20 00:56:52 vostro kernel: [ 2866.978585] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
Apr 20 00:56:52 vostro kernel: [ 2866.978599] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
Apr 20 00:56:52 vostro kernel: [ 2866.978604] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
Apr 20 00:56:52 vostro kernel: [ 2866.978608] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
Apr 20 00:56:52 vostro kernel: [ 2866.978737] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
Apr 20 00:56:52 vostro kernel: [ 2866.978811] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 00:56:52 vostro kernel: [ 2866.978817] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
Apr 20 00:56:52 vostro kernel: [ 2866.979125] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
Apr 20 00:56:52 vostro kernel: [ 2866.979409] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
Apr 20 00:56:52 vostro kernel: [ 2866.979411] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 00:56:52 vostro kernel: [ 2866.979412] usb usb5: Product: xHCI Host Controller
Apr 20 00:56:52 vostro kernel: [ 2866.979413] usb usb5: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 00:56:52 vostro kernel: [ 2866.979414] usb usb5: SerialNumber: 0000:11:00.0
Apr 20 00:56:52 vostro kernel: [ 2866.979571] hub 5-0:1.0: USB hub found
Apr 20 00:56:52 vostro kernel: [ 2866.979584] hub 5-0:1.0: 2 ports detected
Apr 20 00:56:52 vostro kernel: [ 2866.979647] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 00:56:52 vostro kernel: [ 2866.979650] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
Apr 20 00:56:52 vostro kernel: [ 2866.982356] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
Apr 20 00:56:52 vostro kernel: [ 2866.982366] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 00:56:52 vostro kernel: [ 2866.982368] usb usb6: Product: xHCI Host Controller
Apr 20 00:56:52 vostro kernel: [ 2866.982369] usb usb6: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 00:56:52 vostro kernel: [ 2866.982371] usb usb6: SerialNumber: 0000:11:00.0
Apr 20 00:56:52 vostro kernel: [ 2866.982505] hub 6-0:1.0: USB hub found
Apr 20 00:56:52 vostro kernel: [ 2866.982526] hub 6-0:1.0: 2 ports detected
Apr 20 00:56:52 vostro kernel: [ 2867.298040] usb 5-1: new high-speed USB device number 2 using xhci_hcd
Apr 20 00:56:52 vostro kernel: [ 2867.322045] usb 5-1: New USB device found, idVendor=13fd, idProduct=0550
Apr 20 00:56:52 vostro kernel: [ 2867.322055] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Apr 20 00:56:52 vostro kernel: [ 2867.322061] usb 5-1: Product: ST9160821A      
Apr 20 00:56:52 vostro kernel: [ 2867.322066] usb 5-1: Manufacturer: Initio  
Apr 20 00:56:52 vostro kernel: [ 2867.322071] usb 5-1: SerialNumber: 00101005500011B80
Apr 20 00:56:52 vostro kernel: [ 2867.322267] usb 5-1: ep 0x81 - rounding interval to 32768 microframes, ep desc says 0 microframes
Apr 20 00:56:52 vostro kernel: [ 2867.322275] usb 5-1: ep 0x2 - rounding interval to 32768 microframes, ep desc says 0 microframes
Apr 20 00:56:52 vostro kernel: [ 2867.323071] scsi7 : usb-storage 5-1:1.0
Apr 20 00:56:52 vostro kernel: [ 2867.325012] generic-usb 0003:13FD:0550.0003: hiddev0,hidraw2: USB HID v1.10 Device [Initio   ST9160821A      ] on usb-0000:11:00.0-1/input1
Apr 20 00:56:53 vostro kernel: [ 2868.317504] scsi 7:0:0:0: Direct-Access     Initio   ST9160821A       3.12 PQ: 0 ANSI: 0
Apr 20 00:56:53 vostro kernel: [ 2868.317653] sd 7:0:0:0: Attached scsi generic sg3 type 0
Apr 20 00:56:53 vostro kernel: [ 2868.317882] sd 7:0:0:0: [sdc] 312581808 512-byte logical blocks: (160 GB/149 GiB)
Apr 20 00:56:53 vostro kernel: [ 2868.318506] sd 7:0:0:0: [sdc] Write Protect is off
Apr 20 00:56:53 vostro kernel: [ 2868.339644]  sdc: sdc1 sdc2
Apr 20 00:56:53 vostro kernel: [ 2868.341664] sd 7:0:0:0: [sdc] Attached SCSI disk
Apr 20 00:56:57 vostro kernel: [ 2872.458564] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
Apr 20 00:56:57 vostro kernel: [ 2872.460502] xhci_hcd 0000:11:00.0: remove, state 4
Apr 20 00:56:57 vostro kernel: [ 2872.460508] usb usb6: USB disconnect, device number 1
Apr 20 00:56:57 vostro kernel: [ 2872.460632] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 20 00:56:57 vostro kernel: [ 2872.460636] xhci_hcd 0000:11:00.0: USB bus 6 deregistered
Apr 20 00:56:57 vostro kernel: [ 2872.460642] xhci_hcd 0000:11:00.0: remove, state 1
Apr 20 00:56:57 vostro kernel: [ 2872.460646] usb usb5: USB disconnect, device number 1
Apr 20 00:56:57 vostro kernel: [ 2872.460648] usb 5-1: USB disconnect, device number 2

Unplugged.

Reinserted.

Apr 20 00:57:13 vostro kernel: [ 2888.039737] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)

Unplugged.

Apr 20 00:57:18 vostro kernel: [ 2893.662116] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)

Reinserted.

Apr 20 00:57:28 vostro kernel: [ 2903.463451] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
Apr 20 00:57:47 vostro kernel: [ 2922.386047] xhci_hcd 0000:11:00.0: Timeout while waiting for configure endpoint command
Apr 20 00:57:47 vostro kernel: [ 2922.386341] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 20 00:57:47 vostro kernel: [ 2922.386501] xhci_hcd 0000:11:00.0: USB bus 5 deregistered

Unplugged.

Apr 20 00:57:58 vostro kernel: [ 2933.338121] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)


Reinserted.

Apr 20 00:58:20 vostro kernel: [ 2954.976710] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
Apr 20 00:58:20 vostro kernel: [ 2955.097209] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
Apr 20 00:58:20 vostro kernel: [ 2955.097253] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
Apr 20 00:58:20 vostro kernel: [ 2955.097256] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
Apr 20 00:58:20 vostro kernel: [ 2955.097261] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
Apr 20 00:58:20 vostro kernel: [ 2955.097265] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
Apr 20 00:58:20 vostro kernel: [ 2955.097404] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
Apr 20 00:58:20 vostro kernel: [ 2955.097453] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 00:58:20 vostro kernel: [ 2955.097457] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
Apr 20 00:58:20 vostro kernel: [ 2955.097755] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
Apr 20 00:58:20 vostro kernel: [ 2955.098025] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
Apr 20 00:58:20 vostro kernel: [ 2955.098027] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 00:58:20 vostro kernel: [ 2955.098028] usb usb5: Product: xHCI Host Controller
Apr 20 00:58:20 vostro kernel: [ 2955.098029] usb usb5: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 00:58:20 vostro kernel: [ 2955.098030] usb usb5: SerialNumber: 0000:11:00.0
Apr 20 00:58:20 vostro kernel: [ 2955.098124] hub 5-0:1.0: USB hub found
Apr 20 00:58:20 vostro kernel: [ 2955.098135] hub 5-0:1.0: 2 ports detected
Apr 20 00:58:20 vostro kernel: [ 2955.098200] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 00:58:20 vostro kernel: [ 2955.098202] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
Apr 20 00:58:20 vostro kernel: [ 2955.100991] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
Apr 20 00:58:20 vostro kernel: [ 2955.100994] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 00:58:20 vostro kernel: [ 2955.100996] usb usb6: Product: xHCI Host Controller
Apr 20 00:58:20 vostro kernel: [ 2955.100998] usb usb6: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 00:58:20 vostro kernel: [ 2955.101000] usb usb6: SerialNumber: 0000:11:00.0
Apr 20 00:58:20 vostro kernel: [ 2955.101142] hub 6-0:1.0: USB hub found
Apr 20 00:58:20 vostro kernel: [ 2955.101162] hub 6-0:1.0: 2 ports detected
Apr 20 00:58:20 vostro kernel: [ 2955.416698] usb 5-1: new high-speed USB device number 2 using xhci_hcd
Apr 20 00:58:20 vostro kernel: [ 2955.440419] usb 5-1: New USB device found, idVendor=13fd, idProduct=0550
Apr 20 00:58:20 vostro kernel: [ 2955.440429] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Apr 20 00:58:20 vostro kernel: [ 2955.440436] usb 5-1: Product: ST9160821A      
Apr 20 00:58:20 vostro kernel: [ 2955.440441] usb 5-1: Manufacturer: Initio  
Apr 20 00:58:20 vostro kernel: [ 2955.440446] usb 5-1: SerialNumber: 00101005500011B80
Apr 20 00:58:20 vostro kernel: [ 2955.440655] usb 5-1: ep 0x81 - rounding interval to 32768 microframes, ep desc says 0 microframes
Apr 20 00:58:20 vostro kernel: [ 2955.440662] usb 5-1: ep 0x2 - rounding interval to 32768 microframes, ep desc says 0 microframes
Apr 20 00:58:20 vostro kernel: [ 2955.441473] scsi8 : usb-storage 5-1:1.0
Apr 20 00:58:20 vostro kernel: [ 2955.443278] generic-usb 0003:13FD:0550.0004: hiddev0,hidraw2: USB HID v1.10 Device [Initio   ST9160821A      ] on usb-0000:11:00.0-1/input1
Apr 20 00:58:21 vostro kernel: [ 2956.436130] scsi 8:0:0:0: Direct-Access     Initio   ST9160821A       3.12 PQ: 0 ANSI: 0
Apr 20 00:58:21 vostro kernel: [ 2956.436301] sd 8:0:0:0: Attached scsi generic sg3 type 0
Apr 20 00:58:21 vostro kernel: [ 2956.436509] sd 8:0:0:0: [sdc] 312581808 512-byte logical blocks: (160 GB/149 GiB)
Apr 20 00:58:21 vostro kernel: [ 2956.437119] sd 8:0:0:0: [sdc] Write Protect is off
Apr 20 00:58:21 vostro kernel: [ 2956.619459]  sdc: sdc1 sdc2
Apr 20 00:58:21 vostro kernel: [ 2956.622252] sd 8:0:0:0: [sdc] Attached SCSI disk
Apr 20 00:58:32 vostro kernel: [ 2967.162493] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
Apr 20 00:58:32 vostro kernel: [ 2967.169428] xhci_hcd 0000:11:00.0: remove, state 4
Apr 20 00:58:32 vostro kernel: [ 2967.169435] usb usb6: USB disconnect, device number 1
Apr 20 00:58:32 vostro kernel: [ 2967.169597] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 20 00:58:32 vostro kernel: [ 2967.169601] xhci_hcd 0000:11:00.0: USB bus 6 deregistered
Apr 20 00:58:32 vostro kernel: [ 2967.169606] xhci_hcd 0000:11:00.0: remove, state 1
Apr 20 00:58:32 vostro kernel: [ 2967.169610] usb usb5: USB disconnect, device number 1
Apr 20 00:58:32 vostro kernel: [ 2967.169612] usb 5-1: USB disconnect, device number 2

Unplugged.

Apr 20 00:59:18 vostro kernel: [ 3012.713612] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
Apr 20 00:59:22 vostro kernel: [ 3017.094745] xhci_hcd 0000:11:00.0: Timeout while waiting for configure endpoint command
Apr 20 00:59:22 vostro kernel: [ 3017.095109] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 20 00:59:22 vostro kernel: [ 3017.095268] xhci_hcd 0000:11:00.0: USB bus 5 deregistered

Reinserted.

Apr 20 00:59:36 vostro kernel: [ 3031.310569] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)




Apr 20 00:59:47 vostro kernel: [ 3041.609170] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
Apr 20 00:59:47 vostro kernel: [ 3041.738058] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
Apr 20 00:59:47 vostro kernel: [ 3041.738101] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
Apr 20 00:59:47 vostro kernel: [ 3041.738105] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
Apr 20 00:59:47 vostro kernel: [ 3041.738110] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
Apr 20 00:59:47 vostro kernel: [ 3041.738114] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
Apr 20 00:59:47 vostro kernel: [ 3041.738248] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
Apr 20 00:59:47 vostro kernel: [ 3041.738325] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 00:59:47 vostro kernel: [ 3041.738331] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
Apr 20 00:59:47 vostro kernel: [ 3041.738615] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
Apr 20 00:59:47 vostro kernel: [ 3041.738891] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
Apr 20 00:59:47 vostro kernel: [ 3041.738893] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 00:59:47 vostro kernel: [ 3041.738894] usb usb5: Product: xHCI Host Controller
Apr 20 00:59:47 vostro kernel: [ 3041.738896] usb usb5: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 00:59:47 vostro kernel: [ 3041.738897] usb usb5: SerialNumber: 0000:11:00.0
Apr 20 00:59:47 vostro kernel: [ 3041.739076] hub 5-0:1.0: USB hub found
Apr 20 00:59:47 vostro kernel: [ 3041.739088] hub 5-0:1.0: 2 ports detected
Apr 20 00:59:47 vostro kernel: [ 3041.739152] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 00:59:47 vostro kernel: [ 3041.739154] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
Apr 20 00:59:47 vostro kernel: [ 3041.741864] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
Apr 20 00:59:47 vostro kernel: [ 3041.741867] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 00:59:47 vostro kernel: [ 3041.741869] usb usb6: Product: xHCI Host Controller
Apr 20 00:59:47 vostro kernel: [ 3041.741870] usb usb6: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 00:59:47 vostro kernel: [ 3041.741872] usb usb6: SerialNumber: 0000:11:00.0
Apr 20 00:59:47 vostro kernel: [ 3041.741999] hub 6-0:1.0: USB hub found
Apr 20 00:59:47 vostro kernel: [ 3041.742017] hub 6-0:1.0: 2 ports detected
Apr 20 00:59:47 vostro kernel: [ 3042.057561] usb 5-1: new high-speed USB device number 2 using xhci_hcd
Apr 20 00:59:47 vostro kernel: [ 3042.081535] usb 5-1: New USB device found, idVendor=13fd, idProduct=0550
Apr 20 00:59:47 vostro kernel: [ 3042.081545] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Apr 20 00:59:47 vostro kernel: [ 3042.081552] usb 5-1: Product: ST9160821A      
Apr 20 00:59:47 vostro kernel: [ 3042.081557] usb 5-1: Manufacturer: Initio  
Apr 20 00:59:47 vostro kernel: [ 3042.081562] usb 5-1: SerialNumber: 00101005500011B80
Apr 20 00:59:47 vostro kernel: [ 3042.081771] usb 5-1: ep 0x81 - rounding interval to 32768 microframes, ep desc says 0 microframes
Apr 20 00:59:47 vostro kernel: [ 3042.081777] usb 5-1: ep 0x2 - rounding interval to 32768 microframes, ep desc says 0 microframes
Apr 20 00:59:47 vostro kernel: [ 3042.082649] scsi9 : usb-storage 5-1:1.0
Apr 20 00:59:47 vostro kernel: [ 3042.084557] generic-usb 0003:13FD:0550.0005: hiddev0,hidraw2: USB HID v1.10 Device [Initio   ST9160821A      ] on usb-0000:11:00.0-1/input1
Apr 20 00:59:48 vostro kernel: [ 3043.077000] scsi 9:0:0:0: Direct-Access     Initio   ST9160821A       3.12 PQ: 0 ANSI: 0
Apr 20 00:59:48 vostro kernel: [ 3043.077169] sd 9:0:0:0: Attached scsi generic sg3 type 0
Apr 20 00:59:48 vostro kernel: [ 3043.077416] sd 9:0:0:0: [sdc] 312581808 512-byte logical blocks: (160 GB/149 GiB)
Apr 20 00:59:48 vostro kernel: [ 3043.078326] sd 9:0:0:0: [sdc] Write Protect is off
Apr 20 00:59:48 vostro kernel: [ 3043.282712]  sdc: sdc1 sdc2
Apr 20 00:59:48 vostro kernel: [ 3043.284452] sd 9:0:0:0: [sdc] Attached SCSI disk



Apr 20 00:59:55 vostro kernel: [ 3049.662898] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
Apr 20 00:59:55 vostro kernel: [ 3049.666447] xhci_hcd 0000:11:00.0: remove, state 4
Apr 20 00:59:55 vostro kernel: [ 3049.666453] usb usb6: USB disconnect, device number 1
Apr 20 00:59:55 vostro kernel: [ 3049.666579] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 20 00:59:55 vostro kernel: [ 3049.666583] xhci_hcd 0000:11:00.0: USB bus 6 deregistered
Apr 20 00:59:55 vostro kernel: [ 3049.666589] xhci_hcd 0000:11:00.0: remove, state 1
Apr 20 00:59:55 vostro kernel: [ 3049.666593] usb usb5: USB disconnect, device number 1
Apr 20 00:59:55 vostro kernel: [ 3049.666595] usb 5-1: USB disconnect, device number 2


Apr 20 01:00:13 vostro kernel: [ 3067.852697] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)


Apr 20 01:00:28 vostro kernel: [ 3082.659655] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)


Apr 20 01:00:43 vostro kernel: [ 3097.705565] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
Apr 20 01:00:45 vostro kernel: [ 3099.591892] xhci_hcd 0000:11:00.0: Timeout while waiting for configure endpoint command
Apr 20 01:00:45 vostro kernel: [ 3099.592102] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 20 01:00:45 vostro kernel: [ 3099.592256] xhci_hcd 0000:11:00.0: USB bus 5 deregistered


Apr 20 01:00:57 vostro kernel: [ 3111.779422] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)


Apr 20 01:01:05 vostro kernel: [ 3120.078599] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
Apr 20 01:01:05 vostro kernel: [ 3120.201123] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
Apr 20 01:01:05 vostro kernel: [ 3120.201165] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
Apr 20 01:01:05 vostro kernel: [ 3120.201168] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
Apr 20 01:01:05 vostro kernel: [ 3120.201173] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
Apr 20 01:01:05 vostro kernel: [ 3120.201177] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
Apr 20 01:01:05 vostro kernel: [ 3120.201309] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
Apr 20 01:01:05 vostro kernel: [ 3120.201357] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 01:01:05 vostro kernel: [ 3120.201363] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
Apr 20 01:01:05 vostro kernel: [ 3120.201655] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
Apr 20 01:01:05 vostro kernel: [ 3120.201920] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
Apr 20 01:01:05 vostro kernel: [ 3120.201922] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 01:01:05 vostro kernel: [ 3120.201923] usb usb5: Product: xHCI Host Controller
Apr 20 01:01:05 vostro kernel: [ 3120.201924] usb usb5: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 01:01:05 vostro kernel: [ 3120.201926] usb usb5: SerialNumber: 0000:11:00.0
Apr 20 01:01:05 vostro kernel: [ 3120.202087] hub 5-0:1.0: USB hub found
Apr 20 01:01:05 vostro kernel: [ 3120.202098] hub 5-0:1.0: 2 ports detected
Apr 20 01:01:05 vostro kernel: [ 3120.202163] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 01:01:05 vostro kernel: [ 3120.202166] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
Apr 20 01:01:05 vostro kernel: [ 3120.204905] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
Apr 20 01:01:05 vostro kernel: [ 3120.204908] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 01:01:05 vostro kernel: [ 3120.204910] usb usb6: Product: xHCI Host Controller
Apr 20 01:01:05 vostro kernel: [ 3120.204912] usb usb6: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 01:01:05 vostro kernel: [ 3120.204914] usb usb6: SerialNumber: 0000:11:00.0
Apr 20 01:01:05 vostro kernel: [ 3120.205047] hub 6-0:1.0: USB hub found
Apr 20 01:01:05 vostro kernel: [ 3120.205066] hub 6-0:1.0: 2 ports detected
Apr 20 01:01:06 vostro kernel: [ 3120.520711] usb 5-1: new high-speed USB device number 2 using xhci_hcd
Apr 20 01:01:06 vostro kernel: [ 3120.544441] usb 5-1: New USB device found, idVendor=13fd, idProduct=0550
Apr 20 01:01:06 vostro kernel: [ 3120.544451] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Apr 20 01:01:06 vostro kernel: [ 3120.544458] usb 5-1: Product: ST9160821A      
Apr 20 01:01:06 vostro kernel: [ 3120.544463] usb 5-1: Manufacturer: Initio  
Apr 20 01:01:06 vostro kernel: [ 3120.544467] usb 5-1: SerialNumber: 00101005500011B80
Apr 20 01:01:06 vostro kernel: [ 3120.544659] usb 5-1: ep 0x81 - rounding interval to 32768 microframes, ep desc says 0 microframes
Apr 20 01:01:06 vostro kernel: [ 3120.544666] usb 5-1: ep 0x2 - rounding interval to 32768 microframes, ep desc says 0 microframes
Apr 20 01:01:06 vostro kernel: [ 3120.545482] scsi10 : usb-storage 5-1:1.0
Apr 20 01:01:06 vostro kernel: [ 3120.547430] generic-usb 0003:13FD:0550.0006: hiddev0,hidraw2: USB HID v1.10 Device [Initio   ST9160821A      ] on usb-0000:11:00.0-1/input1
Apr 20 01:01:07 vostro kernel: [ 3121.540046] scsi 10:0:0:0: Direct-Access     Initio   ST9160821A       3.12 PQ: 0 ANSI: 0
Apr 20 01:01:07 vostro kernel: [ 3121.540215] sd 10:0:0:0: Attached scsi generic sg3 type 0
Apr 20 01:01:07 vostro kernel: [ 3121.540479] sd 10:0:0:0: [sdc] 312581808 512-byte logical blocks: (160 GB/149 GiB)
Apr 20 01:01:07 vostro kernel: [ 3121.541628] sd 10:0:0:0: [sdc] Write Protect is off
Apr 20 01:01:07 vostro kernel: [ 3121.774199]  sdc: sdc1 sdc2
Apr 20 01:01:07 vostro kernel: [ 3121.775939] sd 10:0:0:0: [sdc] Attached SCSI disk


Maybe the above is helpful? 
Martin
P.S.: Meanwhile am waiting for an answer from Dell.

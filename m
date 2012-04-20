Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab2DTJWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 05:22:16 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:52126 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751661Ab2DTJWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 05:22:09 -0400
Message-ID: <4F91473A.1080007@fold.natur.cuni.cz>
Date: Fri, 20 Apr 2012 13:23:38 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120319 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec
 timeframe
References: <4F6A483D.50702@fold.natur.cuni.cz> <CAE9FiQXikqikMw_LYGqAUsWqFqL-tLiresPhpkpDhb+AxwundQ@mail.gmail.com> <CAE9FiQUFB=9zbP1yuBDH1RJrCCP=83kV_fH+TEtk80981-uP=w@mail.gmail.com> <CAE9FiQUbzM_TVu+bbXa6LWiUt01QsFiGoyYd0qV=41dXx4J31g@mail.gmail.com> <4F8D1B72.2000105@fold.natur.cuni.cz> <CAE9FiQW2MAW_WT+sq8XVtMOx=uR8FAN8O2wL2AOxkFBfEM285g@mail.gmail.com> <CAE9FiQWSw1h772ijZ6YL4EujwjgvZ84bbDx9VbF_cdE63D-41w@mail.gmail.com> <4F8D390F.9050408@fold.natur.cuni.cz> <CAE9FiQU-_BCCS1OKagVuj8YNrut8-6GH2_i86FsfS8UDWQ1pRA@mail.gmail.com> <CAE9FiQUxoHvUWFXv5LLcBT9vVGnQKp1-Tg7M3XPPULWwtX1iUw@mail.gmail.com> <4F8EFFA3.3050705@fold.natur.cuni.cz> <CAE9FiQVcJbPub1O6nwyNsiijHFpHN0jMsGO4MmKugybPL7Wnug@mail.gmail.com> <4F8F243B.70906@fold.natur.cuni.cz> <CAE9FiQXx1NcGY9cHDiM5isx7NyxWN--Exb-4Gfj0arr6vf5ghQ@mail.gmail.com> <4F909CEB.3060407@fold.natur.cuni.cz> <CAE9FiQU7gnKiwazN_2ykbXSkcuDqWMZNt0CHiGvae2L+rTVGug@mail.gmail.com> <CAE9FiQUk8D20mEFPE0ahwfigbEOHpbRp-X0wt4DC+293msw=4Q@mail.gmail.com>
In-Reply-To: <CAE9FiQUk8D20mEFPE0ahwfigbEOHpbRp-X0wt4DC+293msw=4Q@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: multipart/mixed;
 boundary="------------030707080001040104060403"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030707080001040104060403
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Yinghai Lu wrote:
> On Thu, Apr 19, 2012 at 2:48 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Thu, Apr 19, 2012 at 4:16 PM, Martin Mokrejs
>>> I just tried something similar under linux, with all the patches I accumulated for 3.4-rc3
>>> and posted in my previous emails. It seems linux flips some value so on every second card
>>> removal it really does realize it was just unplugged.
>> ...
>>
>> that is really looks like silicon problem.
>>
> 
> please check attached patch. Hope link change bit is flip around...
> if there is change, we could add some logic:
>    check if the device is there, or will reset link to normal state.

I don't think it helped but maybe you will see some difference:


Apr 20 12:50:57 vostro kernel: [   94.357228] pciehp 0000:00:1c.7:pcie04: lnk_status = 7011
Apr 20 12:50:57 vostro kernel: [   94.357232] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
Apr 20 12:50:57 vostro kernel: [   94.481210] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
Apr 20 12:50:57 vostro kernel: [   94.481255] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
Apr 20 12:50:57 vostro kernel: [   94.481258] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
Apr 20 12:50:57 vostro kernel: [   94.481263] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
Apr 20 12:50:57 vostro kernel: [   94.481267] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
Apr 20 12:50:57 vostro kernel: [   94.481407] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
Apr 20 12:50:57 vostro kernel: [   94.481463] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 12:50:57 vostro kernel: [   94.481468] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
Apr 20 12:50:57 vostro kernel: [   94.481767] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
Apr 20 12:50:57 vostro kernel: [   94.482036] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
Apr 20 12:50:57 vostro kernel: [   94.482038] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 12:50:57 vostro kernel: [   94.482039] usb usb5: Product: xHCI Host Controller
Apr 20 12:50:57 vostro kernel: [   94.482040] usb usb5: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 12:50:57 vostro kernel: [   94.482041] usb usb5: SerialNumber: 0000:11:00.0
Apr 20 12:50:57 vostro kernel: [   94.482188] hub 5-0:1.0: USB hub found
Apr 20 12:50:57 vostro kernel: [   94.482198] hub 5-0:1.0: 2 ports detected
Apr 20 12:50:57 vostro kernel: [   94.482265] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 12:50:57 vostro kernel: [   94.482268] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
Apr 20 12:50:57 vostro kernel: [   94.485004] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
Apr 20 12:50:57 vostro kernel: [   94.485007] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 12:50:57 vostro kernel: [   94.485009] usb usb6: Product: xHCI Host Controller
Apr 20 12:50:57 vostro kernel: [   94.485011] usb usb6: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 12:50:57 vostro kernel: [   94.485013] usb usb6: SerialNumber: 0000:11:00.0
Apr 20 12:50:57 vostro kernel: [   94.485148] hub 6-0:1.0: USB hub found
Apr 20 12:50:57 vostro kernel: [   94.485167] hub 6-0:1.0: 2 ports detected
Apr 20 12:51:02 vostro kernel: [   98.754813] usb 5-1: new high-speed USB device number 2 using xhci_hcd
Apr 20 12:51:02 vostro kernel: [   98.778392] usb 5-1: New USB device found, idVendor=13fd, idProduct=0550
Apr 20 12:51:02 vostro kernel: [   98.778403] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Apr 20 12:51:02 vostro kernel: [   98.778409] usb 5-1: Product: ST9160821A      
Apr 20 12:51:02 vostro kernel: [   98.778415] usb 5-1: Manufacturer: Initio  
Apr 20 12:51:02 vostro kernel: [   98.778419] usb 5-1: SerialNumber: 00101005500011B80
Apr 20 12:51:02 vostro kernel: [   98.778626] usb 5-1: ep 0x81 - rounding interval to 32768 microframes, ep desc says 0 microframes
Apr 20 12:51:02 vostro kernel: [   98.778632] usb 5-1: ep 0x2 - rounding interval to 32768 microframes, ep desc says 0 microframes
Apr 20 12:51:02 vostro kernel: [   98.779399] scsi7 : usb-storage 5-1:1.0
Apr 20 12:51:02 vostro kernel: [   98.781416] generic-usb 0003:13FD:0550.0003: hiddev0,hidraw2: USB HID v1.10 Device [Initio   ST9160821A      ] on usb-0000:11:00.0-1/input1
Apr 20 12:51:03 vostro kernel: [   99.774241] scsi 7:0:0:0: Direct-Access     Initio   ST9160821A       3.12 PQ: 0 ANSI: 0
Apr 20 12:51:03 vostro kernel: [   99.774396] sd 7:0:0:0: Attached scsi generic sg3 type 0
Apr 20 12:51:03 vostro kernel: [   99.774615] sd 7:0:0:0: [sdc] 312581808 512-byte logical blocks: (160 GB/149 GiB)
Apr 20 12:51:03 vostro kernel: [   99.775241] sd 7:0:0:0: [sdc] Write Protect is off
Apr 20 12:51:03 vostro kernel: [   99.996721]  sdc: sdc1 sdc2
Apr 20 12:51:03 vostro kernel: [   99.998520] sd 7:0:0:0: [sdc] Attached SCSI disk

re-moved

Apr 20 12:51:45 vostro kernel: [  142.235281] pciehp 0000:00:1c.7:pcie04: lnk_status = 5011
Apr 20 12:51:45 vostro kernel: [  142.235286] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
Apr 20 12:51:45 vostro kernel: [  142.240178] xhci_hcd 0000:11:00.0: remove, state 4
Apr 20 12:51:45 vostro kernel: [  142.240185] usb usb6: USB disconnect, device number 1
Apr 20 12:51:45 vostro kernel: [  142.240323] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 20 12:51:45 vostro kernel: [  142.240326] xhci_hcd 0000:11:00.0: USB bus 6 deregistered
Apr 20 12:51:45 vostro kernel: [  142.240332] xhci_hcd 0000:11:00.0: remove, state 1
Apr 20 12:51:45 vostro kernel: [  142.240337] usb usb5: USB disconnect, device number 1
Apr 20 12:51:45 vostro kernel: [  142.240339] usb 5-1: USB disconnect, device number 2
Apr 20 12:52:35 vostro kernel: [  192.165855] xhci_hcd 0000:11:00.0: Timeout while waiting for configure endpoint command
Apr 20 12:52:35 vostro kernel: [  192.166142] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 20 12:52:35 vostro kernel: [  192.166242] xhci_hcd 0000:11:00.0: USB bus 5 deregistered

you see those "60s" delay above?

re-inserted

Apr 20 12:56:18 vostro kernel: [  414.651967] pciehp 0000:00:1c.7:pcie04: lnk_status = 7011
Apr 20 12:56:18 vostro kernel: [  414.651972] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
Apr 20 12:56:18 vostro kernel: [  414.774447] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
Apr 20 12:56:18 vostro kernel: [  414.774478] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
Apr 20 12:56:18 vostro kernel: [  414.774493] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
Apr 20 12:56:18 vostro kernel: [  414.774498] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
Apr 20 12:56:18 vostro kernel: [  414.774502] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
Apr 20 12:56:18 vostro kernel: [  414.774644] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
Apr 20 12:56:18 vostro kernel: [  414.774693] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 12:56:18 vostro kernel: [  414.774698] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
Apr 20 12:56:18 vostro kernel: [  414.774992] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
Apr 20 12:56:18 vostro kernel: [  414.775300] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
Apr 20 12:56:18 vostro kernel: [  414.775302] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 12:56:18 vostro kernel: [  414.775303] usb usb5: Product: xHCI Host Controller
Apr 20 12:56:18 vostro kernel: [  414.775304] usb usb5: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 12:56:18 vostro kernel: [  414.775305] usb usb5: SerialNumber: 0000:11:00.0
Apr 20 12:56:18 vostro kernel: [  414.775450] hub 5-0:1.0: USB hub found
Apr 20 12:56:18 vostro kernel: [  414.775462] hub 5-0:1.0: 2 ports detected
Apr 20 12:56:18 vostro kernel: [  414.775559] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 12:56:18 vostro kernel: [  414.775570] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
Apr 20 12:56:18 vostro kernel: [  414.778228] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
Apr 20 12:56:18 vostro kernel: [  414.778230] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 12:56:18 vostro kernel: [  414.778231] usb usb6: Product: xHCI Host Controller
Apr 20 12:56:18 vostro kernel: [  414.778232] usb usb6: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 12:56:18 vostro kernel: [  414.778234] usb usb6: SerialNumber: 0000:11:00.0
Apr 20 12:56:18 vostro kernel: [  414.778320] hub 6-0:1.0: USB hub found
Apr 20 12:56:18 vostro kernel: [  414.778332] hub 6-0:1.0: 2 ports detected
Apr 20 12:56:18 vostro kernel: [  415.093937] usb 5-1: new high-speed USB device number 2 using xhci_hcd
Apr 20 12:56:18 vostro kernel: [  415.117398] usb 5-1: New USB device found, idVendor=13fd, idProduct=0550
Apr 20 12:56:18 vostro kernel: [  415.117409] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Apr 20 12:56:18 vostro kernel: [  415.117415] usb 5-1: Product: ST9160821A      
Apr 20 12:56:18 vostro kernel: [  415.117420] usb 5-1: Manufacturer: Initio  
Apr 20 12:56:18 vostro kernel: [  415.117425] usb 5-1: SerialNumber: 00101005500011B80
Apr 20 12:56:18 vostro kernel: [  415.117601] usb 5-1: ep 0x81 - rounding interval to 32768 microframes, ep desc says 0 microframes
Apr 20 12:56:18 vostro kernel: [  415.117606] usb 5-1: ep 0x2 - rounding interval to 32768 microframes, ep desc says 0 microframes
Apr 20 12:56:18 vostro kernel: [  415.118444] scsi8 : usb-storage 5-1:1.0
Apr 20 12:56:18 vostro kernel: [  415.120317] generic-usb 0003:13FD:0550.0004: hiddev0,hidraw2: USB HID v1.10 Device [Initio   ST9160821A      ] on usb-0000:11:00.0-1/input1
Apr 20 12:56:19 vostro kernel: [  416.113367] scsi 8:0:0:0: Direct-Access     Initio   ST9160821A       3.12 PQ: 0 ANSI: 0
Apr 20 12:56:19 vostro kernel: [  416.113528] sd 8:0:0:0: Attached scsi generic sg3 type 0
Apr 20 12:56:19 vostro kernel: [  416.113736] sd 8:0:0:0: [sdc] 312581808 512-byte logical blocks: (160 GB/149 GiB)
Apr 20 12:56:19 vostro kernel: [  416.114340] sd 8:0:0:0: [sdc] Write Protect is off
Apr 20 12:56:20 vostro kernel: [  416.309674]  sdc: sdc1 sdc2
Apr 20 12:56:20 vostro kernel: [  416.311327] sd 8:0:0:0: [sdc] Attached SCSI disk


removed

Apr 20 12:57:24 vostro kernel: [  481.131834] pciehp 0000:00:1c.7:pcie04: lnk_status = 5011
Apr 20 12:57:24 vostro kernel: [  481.131838] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
Apr 20 12:57:24 vostro kernel: [  481.135724] xhci_hcd 0000:11:00.0: remove, state 4
Apr 20 12:57:24 vostro kernel: [  481.135731] usb usb6: USB disconnect, device number 1
Apr 20 12:57:24 vostro kernel: [  481.135884] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 20 12:57:24 vostro kernel: [  481.135888] xhci_hcd 0000:11:00.0: USB bus 6 deregistered
Apr 20 12:57:24 vostro kernel: [  481.135893] xhci_hcd 0000:11:00.0: remove, state 1
Apr 20 12:57:24 vostro kernel: [  481.135898] usb usb5: USB disconnect, device number 1
Apr 20 12:57:24 vostro kernel: [  481.135900] usb 5-1: USB disconnect, device number 2
Apr 20 12:58:14 vostro kernel: [  531.061380] xhci_hcd 0000:11:00.0: Timeout while waiting for configure endpoint command
Apr 20 12:58:14 vostro kernel: [  531.061659] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 20 12:58:14 vostro kernel: [  531.061761] xhci_hcd 0000:11:00.0: USB bus 5 deregistered

you see those "60s" delay above?




Next tests without USB device attached to the express card:

re-inserting the card 

Apr 20 12:59:16 vostro kernel: [  592.704673] pciehp 0000:00:1c.7:pcie04: lnk_status = 7011
Apr 20 12:59:16 vostro kernel: [  592.704685] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
Apr 20 12:59:16 vostro kernel: [  592.829402] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
Apr 20 12:59:16 vostro kernel: [  592.829447] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
Apr 20 12:59:16 vostro kernel: [  592.829450] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
Apr 20 12:59:16 vostro kernel: [  592.829455] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
Apr 20 12:59:16 vostro kernel: [  592.829459] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
Apr 20 12:59:16 vostro kernel: [  592.829593] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
Apr 20 12:59:16 vostro kernel: [  592.829671] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 12:59:16 vostro kernel: [  592.829676] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
Apr 20 12:59:16 vostro kernel: [  592.829973] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
Apr 20 12:59:16 vostro kernel: [  592.830258] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
Apr 20 12:59:16 vostro kernel: [  592.830260] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 12:59:16 vostro kernel: [  592.830261] usb usb5: Product: xHCI Host Controller
Apr 20 12:59:16 vostro kernel: [  592.830262] usb usb5: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 12:59:16 vostro kernel: [  592.830263] usb usb5: SerialNumber: 0000:11:00.0
Apr 20 12:59:16 vostro kernel: [  592.830421] hub 5-0:1.0: USB hub found
Apr 20 12:59:16 vostro kernel: [  592.830434] hub 5-0:1.0: 2 ports detected
Apr 20 12:59:16 vostro kernel: [  592.830495] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 12:59:16 vostro kernel: [  592.830498] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
Apr 20 12:59:16 vostro kernel: [  592.833211] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
Apr 20 12:59:16 vostro kernel: [  592.833214] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 12:59:16 vostro kernel: [  592.833216] usb usb6: Product: xHCI Host Controller
Apr 20 12:59:16 vostro kernel: [  592.833217] usb usb6: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 12:59:16 vostro kernel: [  592.833219] usb usb6: SerialNumber: 0000:11:00.0
Apr 20 12:59:16 vostro kernel: [  592.833345] hub 6-0:1.0: USB hub found
Apr 20 12:59:16 vostro kernel: [  592.833363] hub 6-0:1.0: 2 ports detected

re-moving the card

nothing happened

re-inserting the card

Apr 20 13:03:06 vostro kernel: [  725.782822] pciehp 0000:00:1c.7:pcie04: lnk_status = 5011
Apr 20 13:03:06 vostro kernel: [  725.782826] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
Apr 20 13:03:06 vostro kernel: [  725.791556] xhci_hcd 0000:11:00.0: remove, state 4
Apr 20 13:03:06 vostro kernel: [  725.791562] usb usb6: USB disconnect, device number 1
Apr 20 13:03:06 vostro kernel: [  725.791821] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 20 13:03:06 vostro kernel: [  725.791825] xhci_hcd 0000:11:00.0: USB bus 6 deregistered
Apr 20 13:03:06 vostro kernel: [  725.791830] xhci_hcd 0000:11:00.0: remove, state 4
Apr 20 13:03:06 vostro kernel: [  725.791834] usb usb5: USB disconnect, device number 1
Apr 20 13:03:06 vostro kernel: [  725.792107] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 20 13:03:06 vostro kernel: [  725.792188] xhci_hcd 0000:11:00.0: USB bus 5 deregistered
Apr 20 13:03:06 vostro kernel: [  725.799098] pciehp 0000:00:1c.7:pcie04: lnk_status = 7011
Apr 20 13:03:06 vostro kernel: [  725.799113] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
Apr 20 13:03:06 vostro kernel: [  725.921259] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
Apr 20 13:03:06 vostro kernel: [  725.921303] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
Apr 20 13:03:06 vostro kernel: [  725.921306] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
Apr 20 13:03:06 vostro kernel: [  725.921311] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
Apr 20 13:03:06 vostro kernel: [  725.921315] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
Apr 20 13:03:06 vostro kernel: [  725.921457] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
Apr 20 13:03:06 vostro kernel: [  725.921505] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 13:03:06 vostro kernel: [  725.921510] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
Apr 20 13:03:06 vostro kernel: [  725.921808] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
Apr 20 13:03:06 vostro kernel: [  725.922079] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
Apr 20 13:03:06 vostro kernel: [  725.922081] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 13:03:06 vostro kernel: [  725.922082] usb usb5: Product: xHCI Host Controller
Apr 20 13:03:06 vostro kernel: [  725.922083] usb usb5: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 13:03:06 vostro kernel: [  725.922084] usb usb5: SerialNumber: 0000:11:00.0
Apr 20 13:03:06 vostro kernel: [  725.922233] hub 5-0:1.0: USB hub found
Apr 20 13:03:06 vostro kernel: [  725.922244] hub 5-0:1.0: 2 ports detected
Apr 20 13:03:06 vostro kernel: [  725.922310] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 13:03:06 vostro kernel: [  725.922312] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
Apr 20 13:03:06 vostro kernel: [  725.925042] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
Apr 20 13:03:06 vostro kernel: [  725.925045] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 13:03:06 vostro kernel: [  725.925047] usb usb6: Product: xHCI Host Controller
Apr 20 13:03:06 vostro kernel: [  725.925049] usb usb6: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 13:03:06 vostro kernel: [  725.925051] usb usb6: SerialNumber: 0000:11:00.0
Apr 20 13:03:06 vostro kernel: [  725.925203] hub 6-0:1.0: USB hub found
Apr 20 13:03:06 vostro kernel: [  725.925222] hub 6-0:1.0: 2 ports detected
     
removing the card

nothing happened

re-inserting the card

Apr 20 13:06:35 vostro kernel: [  935.028151] pciehp 0000:00:1c.7:pcie04: lnk_status = 5011
Apr 20 13:06:35 vostro kernel: [  935.028156] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
Apr 20 13:06:35 vostro kernel: [  935.030143] xhci_hcd 0000:11:00.0: remove, state 4
Apr 20 13:06:35 vostro kernel: [  935.030148] usb usb6: USB disconnect, device number 1
Apr 20 13:06:35 vostro kernel: [  935.030299] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 20 13:06:35 vostro kernel: [  935.030304] xhci_hcd 0000:11:00.0: USB bus 6 deregistered
Apr 20 13:06:35 vostro kernel: [  935.030310] xhci_hcd 0000:11:00.0: remove, state 4
Apr 20 13:06:35 vostro kernel: [  935.030315] usb usb5: USB disconnect, device number 1
Apr 20 13:06:35 vostro kernel: [  935.030410] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 20 13:06:35 vostro kernel: [  935.030498] xhci_hcd 0000:11:00.0: USB bus 5 deregistered
Apr 20 13:06:35 vostro kernel: [  935.043622] pciehp 0000:00:1c.7:pcie04: lnk_status = 7011
Apr 20 13:06:35 vostro kernel: [  935.043627] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
Apr 20 13:06:35 vostro kernel: [  935.169809] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
Apr 20 13:06:35 vostro kernel: [  935.169842] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
Apr 20 13:06:35 vostro kernel: [  935.169855] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
Apr 20 13:06:35 vostro kernel: [  935.169860] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
Apr 20 13:06:35 vostro kernel: [  935.169864] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
Apr 20 13:06:35 vostro kernel: [  935.170001] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
Apr 20 13:06:35 vostro kernel: [  935.170054] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 13:06:35 vostro kernel: [  935.170059] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
Apr 20 13:06:35 vostro kernel: [  935.170349] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
Apr 20 13:06:35 vostro kernel: [  935.170652] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
Apr 20 13:06:35 vostro kernel: [  935.170654] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 13:06:35 vostro kernel: [  935.170656] usb usb5: Product: xHCI Host Controller
Apr 20 13:06:35 vostro kernel: [  935.170657] usb usb5: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 13:06:35 vostro kernel: [  935.170658] usb usb5: SerialNumber: 0000:11:00.0
Apr 20 13:06:35 vostro kernel: [  935.170742] hub 5-0:1.0: USB hub found
Apr 20 13:06:35 vostro kernel: [  935.170753] hub 5-0:1.0: 2 ports detected
Apr 20 13:06:35 vostro kernel: [  935.170855] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 13:06:35 vostro kernel: [  935.170860] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
Apr 20 13:06:35 vostro kernel: [  935.173587] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
Apr 20 13:06:35 vostro kernel: [  935.173589] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 13:06:35 vostro kernel: [  935.173591] usb usb6: Product: xHCI Host Controller
Apr 20 13:06:35 vostro kernel: [  935.173592] usb usb6: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 13:06:35 vostro kernel: [  935.173593] usb usb6: SerialNumber: 0000:11:00.0
Apr 20 13:06:35 vostro kernel: [  935.173678] hub 6-0:1.0: USB hub found
Apr 20 13:06:35 vostro kernel: [  935.173689] hub 6-0:1.0: 2 ports detected

re-moving the card


Complete dmesg is attached. OK, the "60sec" delay is when xhci_hcd gives away its attempts.
I am not knowlegeable of the kernel at all but it is my impression that because of the
card presence detection there is no way to prevent that. But, if I get it right, now when I
pluging the card+USB disk in it into the computer before those "60sec" it gets detected,
so my problem is gone (xhci cancels the timeout because a "new card" was popped in with a "new"
device.

So, although I am now not sure whether I need your last patch, for the practical purpose that
I want to plugin a new card with a device into my computer, it works now. (added Sarah Sharp
into CC: just to make her aware of this scenario, no problem with xhci_hcd in my eyes)
;)

Martin

--------------030707080001040104060403
Content-Type: text/plain; charset=us-ascii;
 name="dmesg.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg.txt"

WyAgICAwLjAwMDAwMF0gSW5pdGlhbGl6aW5nIGNncm91cCBzdWJzeXMgY3B1ClsgICAgMC4w
MDAwMDBdIExpbnV4IHZlcnNpb24gMy40LjAtcmMzLWRlZmF1bHQgKHJvb3RAdm9zdHJvKSAo
Z2NjIHZlcnNpb24gNC41LjMgKEdlbnRvbyA0LjUuMy1yMiBwMS4xLCBwaWUtMC40LjcpICkg
IzggU01QIEZyaSBBcHIgMjAgMTI6NDQ6NDggTUVTVCAyMDEyClsgICAgMC4wMDAwMDBdIENv
bW1hbmQgbGluZTogcm9vdD0vZGV2L3NkYTUgcGNpZWhwLnBjaWVocF9kZWJ1Zz0xClsgICAg
MC4wMDAwMDBdIEJJT1MtcHJvdmlkZWQgcGh5c2ljYWwgUkFNIG1hcDoKWyAgICAwLjAwMDAw
MF0gIEJJT1MtZTgyMDogMDAwMDAwMDAwMDAwMDAwMCAtIDAwMDAwMDAwMDAwOWQ0MDAgKHVz
YWJsZSkKWyAgICAwLjAwMDAwMF0gIEJJT1MtZTgyMDogMDAwMDAwMDAwMDA5ZDQwMCAtIDAw
MDAwMDAwMDAwYTAwMDAgKHJlc2VydmVkKQpbICAgIDAuMDAwMDAwXSAgQklPUy1lODIwOiAw
MDAwMDAwMDAwMGUwMDAwIC0gMDAwMDAwMDAwMDEwMDAwMCAocmVzZXJ2ZWQpClsgICAgMC4w
MDAwMDBdICBCSU9TLWU4MjA6IDAwMDAwMDAwMDAxMDAwMDAgLSAwMDAwMDAwMDIwMDAwMDAw
ICh1c2FibGUpClsgICAgMC4wMDAwMDBdICBCSU9TLWU4MjA6IDAwMDAwMDAwMjAwMDAwMDAg
LSAwMDAwMDAwMDIwMjAwMDAwIChyZXNlcnZlZCkKWyAgICAwLjAwMDAwMF0gIEJJT1MtZTgy
MDogMDAwMDAwMDAyMDIwMDAwMCAtIDAwMDAwMDAwNDAwMDAwMDAgKHVzYWJsZSkKWyAgICAw
LjAwMDAwMF0gIEJJT1MtZTgyMDogMDAwMDAwMDA0MDAwMDAwMCAtIDAwMDAwMDAwNDAyMDAw
MDAgKHJlc2VydmVkKQpbICAgIDAuMDAwMDAwXSAgQklPUy1lODIwOiAwMDAwMDAwMDQwMjAw
MDAwIC0gMDAwMDAwMDBkYTRlNTAwMCAodXNhYmxlKQpbICAgIDAuMDAwMDAwXSAgQklPUy1l
ODIwOiAwMDAwMDAwMGRhNGU1MDAwIC0gMDAwMDAwMDBkYTUyODAwMCAoQUNQSSBOVlMpClsg
ICAgMC4wMDAwMDBdICBCSU9TLWU4MjA6IDAwMDAwMDAwZGE1MjgwMDAgLSAwMDAwMDAwMGRh
NzkzMDAwICh1c2FibGUpClsgICAgMC4wMDAwMDBdICBCSU9TLWU4MjA6IDAwMDAwMDAwZGE3
OTMwMDAgLSAwMDAwMDAwMGRhOTY3MDAwIChyZXNlcnZlZCkKWyAgICAwLjAwMDAwMF0gIEJJ
T1MtZTgyMDogMDAwMDAwMDBkYTk2NzAwMCAtIDAwMDAwMDAwZGFhODkwMDAgKHVzYWJsZSkK
WyAgICAwLjAwMDAwMF0gIEJJT1MtZTgyMDogMDAwMDAwMDBkYWE4OTAwMCAtIDAwMDAwMDAw
ZGFkNjgwMDAgKHJlc2VydmVkKQpbICAgIDAuMDAwMDAwXSAgQklPUy1lODIwOiAwMDAwMDAw
MGRhZDY4MDAwIC0gMDAwMDAwMDBkYWZlODAwMCAoQUNQSSBOVlMpClsgICAgMC4wMDAwMDBd
ICBCSU9TLWU4MjA6IDAwMDAwMDAwZGFmZTgwMDAgLSAwMDAwMDAwMGRiMDAwMDAwIChBQ1BJ
IGRhdGEpClsgICAgMC4wMDAwMDBdICBCSU9TLWU4MjA6IDAwMDAwMDAwZGI4MDAwMDAgLSAw
MDAwMDAwMGRmYTAwMDAwIChyZXNlcnZlZCkKWyAgICAwLjAwMDAwMF0gIEJJT1MtZTgyMDog
MDAwMDAwMDBmODAwMDAwMCAtIDAwMDAwMDAwZmMwMDAwMDAgKHJlc2VydmVkKQpbICAgIDAu
MDAwMDAwXSAgQklPUy1lODIwOiAwMDAwMDAwMGZlYzAwMDAwIC0gMDAwMDAwMDBmZWMwMTAw
MCAocmVzZXJ2ZWQpClsgICAgMC4wMDAwMDBdICBCSU9TLWU4MjA6IDAwMDAwMDAwZmVkMDAw
MDAgLSAwMDAwMDAwMGZlZDA0MDAwIChyZXNlcnZlZCkKWyAgICAwLjAwMDAwMF0gIEJJT1Mt
ZTgyMDogMDAwMDAwMDBmZWQxYzAwMCAtIDAwMDAwMDAwZmVkMjAwMDAgKHJlc2VydmVkKQpb
ICAgIDAuMDAwMDAwXSAgQklPUy1lODIwOiAwMDAwMDAwMGZlZTAwMDAwIC0gMDAwMDAwMDBm
ZWUwMTAwMCAocmVzZXJ2ZWQpClsgICAgMC4wMDAwMDBdICBCSU9TLWU4MjA6IDAwMDAwMDAw
ZmYwMDAwMDAgLSAwMDAwMDAwMTAwMDAwMDAwIChyZXNlcnZlZCkKWyAgICAwLjAwMDAwMF0g
IEJJT1MtZTgyMDogMDAwMDAwMDEwMDAwMDAwMCAtIDAwMDAwMDA0MWZlMDAwMDAgKHVzYWJs
ZSkKWyAgICAwLjAwMDAwMF0gTlggKEV4ZWN1dGUgRGlzYWJsZSkgcHJvdGVjdGlvbjogYWN0
aXZlClsgICAgMC4wMDAwMDBdIERNSSAyLjYgcHJlc2VudC4KWyAgICAwLjAwMDAwMF0gRE1J
OiBEZWxsIEluYy4gVm9zdHJvIDM1NTAvMEpHQzQ4LCBCSU9TIEEwOSAwOS8zMC8yMDExClsg
ICAgMC4wMDAwMDBdIGU4MjAgdXBkYXRlIHJhbmdlOiAwMDAwMDAwMDAwMDAwMDAwIC0gMDAw
MDAwMDAwMDAxMDAwMCAodXNhYmxlKSA9PT4gKHJlc2VydmVkKQpbICAgIDAuMDAwMDAwXSBl
ODIwIHJlbW92ZSByYW5nZTogMDAwMDAwMDAwMDBhMDAwMCAtIDAwMDAwMDAwMDAxMDAwMDAg
KHVzYWJsZSkKWyAgICAwLjAwMDAwMF0gTm8gQUdQIGJyaWRnZSBmb3VuZApbICAgIDAuMDAw
MDAwXSBsYXN0X3BmbiA9IDB4NDFmZTAwIG1heF9hcmNoX3BmbiA9IDB4NDAwMDAwMDAwClsg
ICAgMC4wMDAwMDBdIE1UUlIgZGVmYXVsdCB0eXBlOiB1bmNhY2hhYmxlClsgICAgMC4wMDAw
MDBdIE1UUlIgZml4ZWQgcmFuZ2VzIGVuYWJsZWQ6ClsgICAgMC4wMDAwMDBdICAgMDAwMDAt
OUZGRkYgd3JpdGUtYmFjawpbICAgIDAuMDAwMDAwXSAgIEEwMDAwLUJGRkZGIHVuY2FjaGFi
bGUKWyAgICAwLjAwMDAwMF0gICBDMDAwMC1DRkZGRiB3cml0ZS1wcm90ZWN0ClsgICAgMC4w
MDAwMDBdICAgRDAwMDAtRTdGRkYgdW5jYWNoYWJsZQpbICAgIDAuMDAwMDAwXSAgIEU4MDAw
LUZGRkZGIHdyaXRlLXByb3RlY3QKWyAgICAwLjAwMDAwMF0gTVRSUiB2YXJpYWJsZSByYW5n
ZXMgZW5hYmxlZDoKWyAgICAwLjAwMDAwMF0gICAwIGJhc2UgMDAwMDAwMDAwIG1hc2sgQzAw
MDAwMDAwIHdyaXRlLWJhY2sKWyAgICAwLjAwMDAwMF0gICAxIGJhc2UgNDAwMDAwMDAwIG1h
c2sgRkUwMDAwMDAwIHdyaXRlLWJhY2sKWyAgICAwLjAwMDAwMF0gICAyIGJhc2UgMERCODAw
MDAwIG1hc2sgRkZGODAwMDAwIHVuY2FjaGFibGUKWyAgICAwLjAwMDAwMF0gICAzIGJhc2Ug
MERDMDAwMDAwIG1hc2sgRkZDMDAwMDAwIHVuY2FjaGFibGUKWyAgICAwLjAwMDAwMF0gICA0
IGJhc2UgMEUwMDAwMDAwIG1hc2sgRkUwMDAwMDAwIHVuY2FjaGFibGUKWyAgICAwLjAwMDAw
MF0gICA1IGJhc2UgNDFGRTAwMDAwIG1hc2sgRkZGRTAwMDAwIHVuY2FjaGFibGUKWyAgICAw
LjAwMDAwMF0gICA2IGRpc2FibGVkClsgICAgMC4wMDAwMDBdICAgNyBkaXNhYmxlZApbICAg
IDAuMDAwMDAwXSAgIDggZGlzYWJsZWQKWyAgICAwLjAwMDAwMF0gICA5IGRpc2FibGVkClsg
ICAgMC4wMDAwMDBdIHg4NiBQQVQgZW5hYmxlZDogY3B1IDAsIG9sZCAweDcwNDA2MDAwNzA0
MDYsIG5ldyAweDcwMTA2MDAwNzAxMDYKWyAgICAwLjAwMDAwMF0gZTgyMCB1cGRhdGUgcmFu
Z2U6IDAwMDAwMDAwZGI4MDAwMDAgLSAwMDAwMDAwMTAwMDAwMDAwICh1c2FibGUpID09PiAo
cmVzZXJ2ZWQpClsgICAgMC4wMDAwMDBdIGxhc3RfcGZuID0gMHhkYWE4OSBtYXhfYXJjaF9w
Zm4gPSAweDQwMDAwMDAwMApbICAgIDAuMDAwMDAwXSBpbml0aWFsIG1lbW9yeSBtYXBwZWQg
OiAwIC0gMjAwMDAwMDAKWyAgICAwLjAwMDAwMF0gQmFzZSBtZW1vcnkgdHJhbXBvbGluZSBh
dCBbZmZmZjg4MDAwMDA5ODAwMF0gOTgwMDAgc2l6ZSAyMDQ4MApbICAgIDAuMDAwMDAwXSBp
bml0X21lbW9yeV9tYXBwaW5nOiAwMDAwMDAwMDAwMDAwMDAwLTAwMDAwMDAwZGFhODkwMDAK
WyAgICAwLjAwMDAwMF0gIDAwMDAwMDAwMDAgLSAwMGRhYTAwMDAwIHBhZ2UgMk0KWyAgICAw
LjAwMDAwMF0gIDAwZGFhMDAwMDAgLSAwMGRhYTg5MDAwIHBhZ2UgNGsKWyAgICAwLjAwMDAw
MF0ga2VybmVsIGRpcmVjdCBtYXBwaW5nIHRhYmxlcyB1cCB0byBkYWE4OTAwMCBAIDFmZmZh
MDAwLTIwMDAwMDAwClsgICAgMC4wMDAwMDBdIGluaXRfbWVtb3J5X21hcHBpbmc6IDAwMDAw
MDAxMDAwMDAwMDAtMDAwMDAwMDQxZmUwMDAwMApbICAgIDAuMDAwMDAwXSAgMDEwMDAwMDAw
MCAtIDA0MWZlMDAwMDAgcGFnZSAyTQpbICAgIDAuMDAwMDAwXSBrZXJuZWwgZGlyZWN0IG1h
cHBpbmcgdGFibGVzIHVwIHRvIDQxZmUwMDAwMCBAIGRhYTc3MDAwLWRhYTg5MDAwClsgICAg
MC4wMDAwMDBdIEFDUEk6IFJTRFAgMDAwMDAwMDAwMDBmMDQxMCAwMDAyNCAodjAyICAgREVM
TCkKWyAgICAwLjAwMDAwMF0gQUNQSTogWFNEVCAwMDAwMDAwMGRhZmU4MDc4IDAwMDc0ICh2
MDEgREVMTCAgICBXTjA5ICAgIDAxMDcyMDA5IEFNSSAgMDAwMTAwMTMpClsgICAgMC4wMDAw
MDBdIEFDUEk6IEZBQ1AgMDAwMDAwMDBkYWZmMWQwOCAwMDBGNCAodjA0ICAgREVMTCAgICAg
V04wOSAwMTA3MjAwOSBBTUkgIDAwMDEwMDEzKQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBEU0RU
IDAwMDAwMDAwZGFmZTgxODAgMDlCODUgKHYwMiAgIERFTEwgICAgIFdOMDkgMDAwMDAwMDAg
SU5UTCAyMDA1MTExNykKWyAgICAwLjAwMDAwMF0gQUNQSTogRkFDUyAwMDAwMDAwMGRhZmUz
ZjgwIDAwMDQwClsgICAgMC4wMDAwMDBdIEFDUEk6IEFQSUMgMDAwMDAwMDBkYWZmMWUwMCAw
MDA3MiAodjAzICAgREVMTCAgICAgV04wOSAwMTA3MjAwOSBBTUkgIDAwMDEwMDEzKQpbICAg
IDAuMDAwMDAwXSBBQ1BJOiBNQ0ZHIDAwMDAwMDAwZGFmZjFlNzggMDAwM0MgKHYwMSAgIERF
TEwgICAgIFdOMDkgMDEwNzIwMDkgTVNGVCAwMDAwMDA5NykKWyAgICAwLjAwMDAwMF0gQUNQ
STogU1NEVCAwMDAwMDAwMGRhZmYxZWI4IDAwNEIwICh2MDEgVHJtUmVmIFB0aWREZXZjIDAw
MDAxMDAwIElOVEwgMjAwOTExMTIpClsgICAgMC4wMDAwMDBdIEFDUEk6IFNMSUMgMDAwMDAw
MDBkYWZmMjM2OCAwMDE3NiAodjAxIERFTEwgICAgV04wOSAgICAwMTA3MjAwOSBBTUkgIDAw
MDEwMDEzKQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBIUEVUIDAwMDAwMDAwZGFmZjI0ZTAgMDAw
MzggKHYwMSAgIERFTEwgICAgIFdOMDkgMDEwNzIwMDkgQU1JLiAwMDAwMDAwNCkKWyAgICAw
LjAwMDAwMF0gQUNQSTogU1NEVCAwMDAwMDAwMGRhZmYyNTE4IDAwODQ2ICh2MDEgIFBtUmVm
ICBDcHUwSXN0IDAwMDAzMDAwIElOVEwgMjAwNTExMTcpClsgICAgMC4wMDAwMDBdIEFDUEk6
IFNTRFQgMDAwMDAwMDBkYWZmMmQ2MCAwMDk5NiAodjAxICBQbVJlZiAgICBDcHVQbSAwMDAw
MzAwMCBJTlRMIDIwMDUxMTE3KQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBETUFSIDAwMDAwMDAw
ZGFmZjM2ZjggMDAwRTggKHYwMSBJTlRFTCAgICAgIFNOQiAgMDAwMDAwMDEgSU5UTCAwMDAw
MDAwMSkKWyAgICAwLjAwMDAwMF0gQUNQSTogT1NGUiAwMDAwMDAwMGRhZmYzN2UwIDAwMDg2
ICh2MDEgREVMTCAgICBNMDggICAgIDA3REIwOTFFIEFTTCAgMDAwMDAwNjEpClsgICAgMC4w
MDAwMDBdIEFDUEk6IExvY2FsIEFQSUMgYWRkcmVzcyAweGZlZTAwMDAwClsgICAgMC4wMDAw
MDBdIE5vIE5VTUEgY29uZmlndXJhdGlvbiBmb3VuZApbICAgIDAuMDAwMDAwXSBGYWtpbmcg
YSBub2RlIGF0IDAwMDAwMDAwMDAwMDAwMDAtMDAwMDAwMDQxZmUwMDAwMApbICAgIDAuMDAw
MDAwXSBJbml0bWVtIHNldHVwIG5vZGUgMCAwMDAwMDAwMDAwMDAwMDAwLTAwMDAwMDA0MWZl
MDAwMDAKWyAgICAwLjAwMDAwMF0gICBOT0RFX0RBVEEgWzAwMDAwMDA0MWZkZmMwMDAgLSAw
MDAwMDAwNDFmZGZmZmZmXQpbICAgIDAuMDAwMDAwXSAgW2ZmZmZlYTAwMDAwMDAwMDAtZmZm
ZmVhMDAwZTdmZmZmZl0gUE1EIC0+IFtmZmZmODgwNDBmNDAwMDAwLWZmZmY4ODA0MWQ1ZmZm
ZmZdIG9uIG5vZGUgMApbICAgIDAuMDAwMDAwXSBab25lIFBGTiByYW5nZXM6ClsgICAgMC4w
MDAwMDBdICAgRE1BICAgICAgMHgwMDAwMDAxMCAtPiAweDAwMDAxMDAwClsgICAgMC4wMDAw
MDBdICAgRE1BMzIgICAgMHgwMDAwMTAwMCAtPiAweDAwMTAwMDAwClsgICAgMC4wMDAwMDBd
ICAgTm9ybWFsICAgMHgwMDEwMDAwMCAtPiAweDAwNDFmZTAwClsgICAgMC4wMDAwMDBdIE1v
dmFibGUgem9uZSBzdGFydCBQRk4gZm9yIGVhY2ggbm9kZQpbICAgIDAuMDAwMDAwXSBFYXJs
eSBtZW1vcnkgUEZOIHJhbmdlcwpbICAgIDAuMDAwMDAwXSAgICAgMDogMHgwMDAwMDAxMCAt
PiAweDAwMDAwMDlkClsgICAgMC4wMDAwMDBdICAgICAwOiAweDAwMDAwMTAwIC0+IDB4MDAw
MjAwMDAKWyAgICAwLjAwMDAwMF0gICAgIDA6IDB4MDAwMjAyMDAgLT4gMHgwMDA0MDAwMApb
ICAgIDAuMDAwMDAwXSAgICAgMDogMHgwMDA0MDIwMCAtPiAweDAwMGRhNGU1ClsgICAgMC4w
MDAwMDBdICAgICAwOiAweDAwMGRhNTI4IC0+IDB4MDAwZGE3OTMKWyAgICAwLjAwMDAwMF0g
ICAgIDA6IDB4MDAwZGE5NjcgLT4gMHgwMDBkYWE4OQpbICAgIDAuMDAwMDAwXSAgICAgMDog
MHgwMDEwMDAwMCAtPiAweDAwNDFmZTAwClsgICAgMC4wMDAwMDBdIE9uIG5vZGUgMCB0b3Rh
bHBhZ2VzOiA0MTcwMjM5ClsgICAgMC4wMDAwMDBdICAgRE1BIHpvbmU6IDU2IHBhZ2VzIHVz
ZWQgZm9yIG1lbW1hcApbICAgIDAuMDAwMDAwXSAgIERNQSB6b25lOiA1IHBhZ2VzIHJlc2Vy
dmVkClsgICAgMC4wMDAwMDBdICAgRE1BIHpvbmU6IDM5MjAgcGFnZXMsIExJRk8gYmF0Y2g6
MApbICAgIDAuMDAwMDAwXSAgIERNQTMyIHpvbmU6IDE0MjgwIHBhZ2VzIHVzZWQgZm9yIG1l
bW1hcApbICAgIDAuMDAwMDAwXSAgIERNQTMyIHpvbmU6IDg3NTY5MCBwYWdlcywgTElGTyBi
YXRjaDozMQpbICAgIDAuMDAwMDAwXSAgIE5vcm1hbCB6b25lOiA0NDc5MyBwYWdlcyB1c2Vk
IGZvciBtZW1tYXAKWyAgICAwLjAwMDAwMF0gICBOb3JtYWwgem9uZTogMzIzMTQ5NSBwYWdl
cywgTElGTyBiYXRjaDozMQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBQTS1UaW1lciBJTyBQb3J0
OiAweDQwOApbICAgIDAuMDAwMDAwXSBBQ1BJOiBMb2NhbCBBUElDIGFkZHJlc3MgMHhmZWUw
MDAwMApbICAgIDAuMDAwMDAwXSBBQ1BJOiBMQVBJQyAoYWNwaV9pZFsweDAxXSBsYXBpY19p
ZFsweDAwXSBlbmFibGVkKQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBMQVBJQyAoYWNwaV9pZFsw
eDAyXSBsYXBpY19pZFsweDAyXSBlbmFibGVkKQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBMQVBJ
QyAoYWNwaV9pZFsweDAzXSBsYXBpY19pZFsweDAxXSBlbmFibGVkKQpbICAgIDAuMDAwMDAw
XSBBQ1BJOiBMQVBJQyAoYWNwaV9pZFsweDA0XSBsYXBpY19pZFsweDAzXSBlbmFibGVkKQpb
ICAgIDAuMDAwMDAwXSBBQ1BJOiBMQVBJQ19OTUkgKGFjcGlfaWRbMHhmZl0gaGlnaCBlZGdl
IGxpbnRbMHgxXSkKWyAgICAwLjAwMDAwMF0gQUNQSTogSU9BUElDIChpZFsweDAyXSBhZGRy
ZXNzWzB4ZmVjMDAwMDBdIGdzaV9iYXNlWzBdKQpbICAgIDAuMDAwMDAwXSBJT0FQSUNbMF06
IGFwaWNfaWQgMiwgdmVyc2lvbiAzMiwgYWRkcmVzcyAweGZlYzAwMDAwLCBHU0kgMC0yMwpb
ICAgIDAuMDAwMDAwXSBBQ1BJOiBJTlRfU1JDX09WUiAoYnVzIDAgYnVzX2lycSAwIGdsb2Jh
bF9pcnEgMiBkZmwgZGZsKQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBJTlRfU1JDX09WUiAoYnVz
IDAgYnVzX2lycSA5IGdsb2JhbF9pcnEgOSBoaWdoIGxldmVsKQpbICAgIDAuMDAwMDAwXSBB
Q1BJOiBJUlEwIHVzZWQgYnkgb3ZlcnJpZGUuClsgICAgMC4wMDAwMDBdIEFDUEk6IElSUTIg
dXNlZCBieSBvdmVycmlkZS4KWyAgICAwLjAwMDAwMF0gQUNQSTogSVJROSB1c2VkIGJ5IG92
ZXJyaWRlLgpbICAgIDAuMDAwMDAwXSBVc2luZyBBQ1BJIChNQURUKSBmb3IgU01QIGNvbmZp
Z3VyYXRpb24gaW5mb3JtYXRpb24KWyAgICAwLjAwMDAwMF0gQUNQSTogSFBFVCBpZDogMHg4
MDg2YTcwMSBiYXNlOiAweGZlZDAwMDAwClsgICAgMC4wMDAwMDBdIFNNUDogQWxsb3dpbmcg
NCBDUFVzLCAwIGhvdHBsdWcgQ1BVcwpbICAgIDAuMDAwMDAwXSBucl9pcnFzX2dzaTogNDAK
WyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDAw
MDA5ZDAwMCAtIDAwMDAwMDAwMDAwOWUwMDAKWyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVy
ZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDAwMDA5ZTAwMCAtIDAwMDAwMDAwMDAwYTAwMDAK
WyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDAw
MDBhMDAwMCAtIDAwMDAwMDAwMDAwZTAwMDAKWyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVy
ZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDAwMDBlMDAwMCAtIDAwMDAwMDAwMDAxMDAwMDAK
WyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDAy
MDAwMDAwMCAtIDAwMDAwMDAwMjAyMDAwMDAKWyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVy
ZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDA0MDAwMDAwMCAtIDAwMDAwMDAwNDAyMDAwMDAK
WyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBk
YTRlNTAwMCAtIDAwMDAwMDAwZGE1MjgwMDAKWyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVy
ZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBkYTc5MzAwMCAtIDAwMDAwMDAwZGE5NjcwMDAK
WyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBk
YWE4OTAwMCAtIDAwMDAwMDAwZGFkNjgwMDAKWyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVy
ZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBkYWQ2ODAwMCAtIDAwMDAwMDAwZGFmZTgwMDAK
WyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBk
YWZlODAwMCAtIDAwMDAwMDAwZGIwMDAwMDAKWyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVy
ZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBkYjAwMDAwMCAtIDAwMDAwMDAwZGI4MDAwMDAK
WyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBk
YjgwMDAwMCAtIDAwMDAwMDAwZGZhMDAwMDAKWyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVy
ZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBkZmEwMDAwMCAtIDAwMDAwMDAwZjgwMDAwMDAK
WyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBm
ODAwMDAwMCAtIDAwMDAwMDAwZmMwMDAwMDAKWyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVy
ZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBmYzAwMDAwMCAtIDAwMDAwMDAwZmVjMDAwMDAK
WyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBm
ZWMwMDAwMCAtIDAwMDAwMDAwZmVjMDEwMDAKWyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVy
ZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBmZWMwMTAwMCAtIDAwMDAwMDAwZmVkMDAwMDAK
WyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBm
ZWQwMDAwMCAtIDAwMDAwMDAwZmVkMDQwMDAKWyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVy
ZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBmZWQwNDAwMCAtIDAwMDAwMDAwZmVkMWMwMDAK
WyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBm
ZWQxYzAwMCAtIDAwMDAwMDAwZmVkMjAwMDAKWyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVy
ZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBmZWQyMDAwMCAtIDAwMDAwMDAwZmVlMDAwMDAK
WyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBm
ZWUwMDAwMCAtIDAwMDAwMDAwZmVlMDEwMDAKWyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVy
ZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBmZWUwMTAwMCAtIDAwMDAwMDAwZmYwMDAwMDAK
WyAgICAwLjAwMDAwMF0gUE06IFJlZ2lzdGVyZWQgbm9zYXZlIG1lbW9yeTogMDAwMDAwMDBm
ZjAwMDAwMCAtIDAwMDAwMDAxMDAwMDAwMDAKWyAgICAwLjAwMDAwMF0gQWxsb2NhdGluZyBQ
Q0kgcmVzb3VyY2VzIHN0YXJ0aW5nIGF0IGRmYTAwMDAwIChnYXA6IGRmYTAwMDAwOjE4NjAw
MDAwKQpbICAgIDAuMDAwMDAwXSBzZXR1cF9wZXJjcHU6IE5SX0NQVVM6NCBucl9jcHVtYXNr
X2JpdHM6NCBucl9jcHVfaWRzOjQgbnJfbm9kZV9pZHM6MQpbICAgIDAuMDAwMDAwXSBQRVJD
UFU6IEVtYmVkZGVkIDI1IHBhZ2VzL2NwdSBAZmZmZjg4MDQxZmEwMDAwMCBzNzI0NDggcjgx
OTIgZDIxNzYwIHU1MjQyODgKWyAgICAwLjAwMDAwMF0gcGNwdS1hbGxvYzogczcyNDQ4IHI4
MTkyIGQyMTc2MCB1NTI0Mjg4IGFsbG9jPTEqMjA5NzE1MgpbICAgIDAuMDAwMDAwXSBwY3B1
LWFsbG9jOiBbMF0gMCAxIDIgMyAKWyAgICAwLjAwMDAwMF0gQnVpbHQgMSB6b25lbGlzdHMg
aW4gWm9uZSBvcmRlciwgbW9iaWxpdHkgZ3JvdXBpbmcgb24uICBUb3RhbCBwYWdlczogNDEx
MTEwNQpbICAgIDAuMDAwMDAwXSBQb2xpY3kgem9uZTogTm9ybWFsClsgICAgMC4wMDAwMDBd
IEtlcm5lbCBjb21tYW5kIGxpbmU6IHJvb3Q9L2Rldi9zZGE1IHBjaWVocC5wY2llaHBfZGVi
dWc9MQpbICAgIDAuMDAwMDAwXSBQSUQgaGFzaCB0YWJsZSBlbnRyaWVzOiA0MDk2IChvcmRl
cjogMywgMzI3NjggYnl0ZXMpClsgICAgMC4wMDAwMDBdIHhzYXZlL3hyc3RvcjogZW5hYmxl
ZCB4c3RhdGVfYnYgMHg3LCBjbnR4dCBzaXplIDB4MzQwClsgICAgMC4wMDAwMDBdIENoZWNr
aW5nIGFwZXJ0dXJlLi4uClsgICAgMC4wMDAwMDBdIE5vIEFHUCBicmlkZ2UgZm91bmQKWyAg
ICAwLjAwMDAwMF0gTWVtb3J5OiAxNjM3MjEzMmsvMTcyOTk0NTZrIGF2YWlsYWJsZSAoNTcx
OWsga2VybmVsIGNvZGUsIDYxODUwMGsgYWJzZW50LCAzMDg4MjRrIHJlc2VydmVkLCAzNjA3
ayBkYXRhLCA1NDRrIGluaXQpClsgICAgMC4wMDAwMDBdIEhpZXJhcmNoaWNhbCBSQ1UgaW1w
bGVtZW50YXRpb24uClsgICAgMC4wMDAwMDBdIAlSQ1UgZHludGljay1pZGxlIGdyYWNlLXBl
cmlvZCBhY2NlbGVyYXRpb24gaXMgZW5hYmxlZC4KWyAgICAwLjAwMDAwMF0gTlJfSVJRUzo0
MzUyIG5yX2lycXM6NzEyIDE2ClsgICAgMC4wMDAwMDBdIEV4dGVuZGVkIENNT1MgeWVhcjog
MjAwMApbICAgIDAuMDAwMDAwXSBDb25zb2xlOiBjb2xvdXIgVkdBKyA4MHgyNQpbICAgIDAu
MDAwMDAwXSBjb25zb2xlIFt0dHkwXSBlbmFibGVkClsgICAgMC4wMDAwMDBdIGhwZXQgY2xv
Y2tldmVudCByZWdpc3RlcmVkClsgICAgMC4wMDAwMDBdIEZhc3QgVFNDIGNhbGlicmF0aW9u
IHVzaW5nIFBJVApbICAgIDAuMDEwMDAwXSBEZXRlY3RlZCAyNzkzLjYyOCBNSHogcHJvY2Vz
c29yLgpbICAgIDAuMDAwMDAyXSBDYWxpYnJhdGluZyBkZWxheSBsb29wIChza2lwcGVkKSwg
dmFsdWUgY2FsY3VsYXRlZCB1c2luZyB0aW1lciBmcmVxdWVuY3kuLiA1NTg3LjI1IEJvZ29N
SVBTIChscGo9Mjc5MzYyODApClsgICAgMC4wMDAxOTFdIHBpZF9tYXg6IGRlZmF1bHQ6IDMy
NzY4IG1pbmltdW06IDMwMQpbICAgIDAuMDAxMTY1XSBEZW50cnkgY2FjaGUgaGFzaCB0YWJs
ZSBlbnRyaWVzOiAyMDk3MTUyIChvcmRlcjogMTIsIDE2Nzc3MjE2IGJ5dGVzKQpbICAgIDAu
MDA0MTczXSBJbm9kZS1jYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDEwNDg1NzYgKG9yZGVy
OiAxMSwgODM4ODYwOCBieXRlcykKWyAgICAwLjAwNTU0Ml0gTW91bnQtY2FjaGUgaGFzaCB0
YWJsZSBlbnRyaWVzOiAyNTYKWyAgICAwLjAwNTgwNV0gQ1BVOiBQaHlzaWNhbCBQcm9jZXNz
b3IgSUQ6IDAKWyAgICAwLjAwNTg5OF0gQ1BVOiBQcm9jZXNzb3IgQ29yZSBJRDogMApbICAg
IDAuMDA1OTkyXSBFTkVSR1lfUEVSRl9CSUFTOiBTZXQgdG8gJ25vcm1hbCcsIHdhcyAncGVy
Zm9ybWFuY2UnClsgICAgMC4wMDU5OTNdIEVORVJHWV9QRVJGX0JJQVM6IFZpZXcgYW5kIHVw
ZGF0ZSB3aXRoIHg4Nl9lbmVyZ3lfcGVyZl9wb2xpY3koOCkKWyAgICAwLjAwNjE4NV0gbWNl
OiBDUFUgc3VwcG9ydHMgNyBNQ0UgYmFua3MKWyAgICAwLjAwNjI4NV0gQ1BVMDogVGhlcm1h
bCBtb25pdG9yaW5nIGVuYWJsZWQgKFRNMSkKWyAgICAwLjAwNjM4M10gdXNpbmcgbXdhaXQg
aW4gaWRsZSB0aHJlYWRzLgpbICAgIDAuMDA2NTMyXSBBQ1BJOiBDb3JlIHJldmlzaW9uIDIw
MTIwMzIwClsgICAgMC4wMjc1ODBdIERNQVI6IEhvc3QgYWRkcmVzcyB3aWR0aCAzNgpbICAg
IDAuMDI3Njc0XSBETUFSOiBEUkhEIGJhc2U6IDB4MDAwMDAwZmVkOTAwMDAgZmxhZ3M6IDB4
MApbICAgIDAuMDI3Nzc0XSBJT01NVSAwOiByZWdfYmFzZV9hZGRyIGZlZDkwMDAwIHZlciAx
OjAgY2FwIGMwMDAwMDIwZTYwMjYyIGVjYXAgZjAxMDFhClsgICAgMC4wMjc5MjBdIERNQVI6
IERSSEQgYmFzZTogMHgwMDAwMDBmZWQ5MTAwMCBmbGFnczogMHgxClsgICAgMC4wMjgwMThd
IElPTU1VIDE6IHJlZ19iYXNlX2FkZHIgZmVkOTEwMDAgdmVyIDE6MCBjYXAgYzkwMDgwMjA2
NjAyNjIgZWNhcCBmMDEwNWEKWyAgICAwLjAyODE2NF0gRE1BUjogUk1SUiBiYXNlOiAweDAw
MDAwMGRhZDUzMDAwIGVuZDogMHgwMDAwMDBkYWQ2MWZmZgpbICAgIDAuMDI4MjYwXSBETUFS
OiBSTVJSIGJhc2U6IDB4MDAwMDAwZGI4MDAwMDAgZW5kOiAweDAwMDAwMGRmOWZmZmZmClsg
ICAgMC4wMjg0MjZdIElPQVBJQyBpZCAyIHVuZGVyIERSSEQgYmFzZSAgMHhmZWQ5MTAwMCBJ
T01NVSAxClsgICAgMC4wMjg1MjFdIEhQRVQgaWQgMCB1bmRlciBEUkhEIGJhc2UgMHhmZWQ5
MTAwMApbICAgIDAuMDI4NjE1XSBIUEVUIGlkIDAgdW5kZXIgRFJIRCBiYXNlIDB4ZmVkOTEw
MDAKWyAgICAwLjAyODcwOV0gSFBFVCBpZCAwIHVuZGVyIERSSEQgYmFzZSAweGZlZDkxMDAw
ClsgICAgMC4wMjg4MDJdIEhQRVQgaWQgMCB1bmRlciBEUkhEIGJhc2UgMHhmZWQ5MTAwMApb
ICAgIDAuMDI4ODk2XSBIUEVUIGlkIDAgdW5kZXIgRFJIRCBiYXNlIDB4ZmVkOTEwMDAKWyAg
ICAwLjAyODk4OF0gSFBFVCBpZCAwIHVuZGVyIERSSEQgYmFzZSAweGZlZDkxMDAwClsgICAg
MC4wMjkwODJdIEhQRVQgaWQgMCB1bmRlciBEUkhEIGJhc2UgMHhmZWQ5MTAwMApbICAgIDAu
MDI5MTc1XSBIUEVUIGlkIDAgdW5kZXIgRFJIRCBiYXNlIDB4ZmVkOTEwMDAKWyAgICAwLjAy
OTQyOV0gRW5hYmxlZCBJUlEgcmVtYXBwaW5nIGluIHgyYXBpYyBtb2RlClsgICAgMC4wMjk1
MjJdIEVuYWJsaW5nIHgyYXBpYwpbICAgIDAuMDI5NjEyXSBFbmFibGVkIHgyYXBpYwpbICAg
IDAuMDI5NzA1XSBTd2l0Y2hlZCBBUElDIHJvdXRpbmcgdG8gY2x1c3RlciB4MmFwaWMuClsg
ICAgMC4wMzAyMzZdIC4uVElNRVI6IHZlY3Rvcj0weDMwIGFwaWMxPTAgcGluMT0yIGFwaWMy
PS0xIHBpbjI9LTEKWyAgICAwLjEzMDE4Nl0gQ1BVMDogSW50ZWwoUikgQ29yZShUTSkgaTct
MjY0ME0gQ1BVIEAgMi44MEdIeiBzdGVwcGluZyAwNwpbICAgIDAuMjQ2NDY2XSBQZXJmb3Jt
YW5jZSBFdmVudHM6IFBFQlMgZm10MSssIDE2LWRlZXAgTEJSLCBTYW5keUJyaWRnZSBldmVu
dHMsIEludGVsIFBNVSBkcml2ZXIuClsgICAgMC4yNDY3NzBdIFBFQlMgZGlzYWJsZWQgZHVl
IHRvIENQVSBlcnJhdGEuClsgICAgMC4yNDY4NjJdIC4uLiB2ZXJzaW9uOiAgICAgICAgICAg
ICAgICAzClsgICAgMC4yNDY5NTRdIC4uLiBiaXQgd2lkdGg6ICAgICAgICAgICAgICA0OApb
ICAgIDAuMjQ3MDQ2XSAuLi4gZ2VuZXJpYyByZWdpc3RlcnM6ICAgICAgNApbICAgIDAuMjQ3
MTM4XSAuLi4gdmFsdWUgbWFzazogICAgICAgICAgICAgMDAwMGZmZmZmZmZmZmZmZgpbICAg
IDAuMjQ3MjMyXSAuLi4gbWF4IHBlcmlvZDogICAgICAgICAgICAgMDAwMDAwMDA3ZmZmZmZm
ZgpbICAgIDAuMjQ3MzI2XSAuLi4gZml4ZWQtcHVycG9zZSBldmVudHM6ICAgMwpbICAgIDAu
MjQ3NDE4XSAuLi4gZXZlbnQgbWFzazogICAgICAgICAgICAgMDAwMDAwMDcwMDAwMDAwZgpb
ICAgIDAuMjQ3NTk4XSBOTUkgd2F0Y2hkb2c6IGVuYWJsZWQsIHRha2VzIG9uZSBody1wbXUg
Y291bnRlci4KWyAgICAwLjI0OTA4OF0gQm9vdGluZyBOb2RlICAgMCwgUHJvY2Vzc29ycyAg
IzEKWyAgICAwLjI2MjI4OV0gTk1JIHdhdGNoZG9nOiBlbmFibGVkLCB0YWtlcyBvbmUgaHct
cG11IGNvdW50ZXIuClsgICAgMC4yNjI1NDldICAjMgpbICAgIDAuMjc1NzA0XSBOTUkgd2F0
Y2hkb2c6IGVuYWJsZWQsIHRha2VzIG9uZSBody1wbXUgY291bnRlci4KWyAgICAwLjI3NTk2
OF0gICMzIE9rLgpbICAgIDAuMjg5MTY4XSBOTUkgd2F0Y2hkb2c6IGVuYWJsZWQsIHRha2Vz
IG9uZSBody1wbXUgY291bnRlci4KWyAgICAwLjI4OTI4N10gQnJvdWdodCB1cCA0IENQVXMK
WyAgICAwLjI4OTM3OV0gVG90YWwgb2YgNCBwcm9jZXNzb3JzIGFjdGl2YXRlZCAoMjIzNDku
MDIgQm9nb01JUFMpLgpbICAgIDAuMjkyNDEwXSBkZXZ0bXBmczogaW5pdGlhbGl6ZWQKWyAg
ICAwLjI5MjY1N10gUE06IFJlZ2lzdGVyaW5nIEFDUEkgTlZTIHJlZ2lvbiBbbWVtIDB4ZGE0
ZTUwMDAtMHhkYTUyN2ZmZl0gKDI3NDQzMiBieXRlcykKWyAgICAwLjI5MjgxM10gUE06IFJl
Z2lzdGVyaW5nIEFDUEkgTlZTIHJlZ2lvbiBbbWVtIDB4ZGFkNjgwMDAtMHhkYWZlN2ZmZl0g
KDI2MjE0NDAgYnl0ZXMpClsgICAgMC4yOTMwODJdIHhvcjogYXV0b21hdGljYWxseSB1c2lu
ZyBiZXN0IGNoZWNrc3VtbWluZyBmdW5jdGlvbjogZ2VuZXJpY19zc2UKWyAgICAwLjMzNjMz
Ml0gICAgZ2VuZXJpY19zc2U6IDEyNDU1LjIwMCBNQi9zZWMKWyAgICAwLjMzNjQyNl0geG9y
OiB1c2luZyBmdW5jdGlvbjogZ2VuZXJpY19zc2UgKDEyNDU1LjIwMCBNQi9zZWMpClsgICAg
MC4zMzY2NTNdIGR1bW15OiAKWyAgICAwLjMzNjgxMl0gTkVUOiBSZWdpc3RlcmVkIHByb3Rv
Y29sIGZhbWlseSAxNgpbICAgIDAuMzM3MTk5XSBBQ1BJOiBidXMgdHlwZSBwY2kgcmVnaXN0
ZXJlZApbICAgIDAuMzM3Mzg3XSBQQ0k6IE1NQ09ORklHIGZvciBkb21haW4gMDAwMCBbYnVz
IDAwLTNmXSBhdCBbbWVtIDB4ZjgwMDAwMDAtMHhmYmZmZmZmZl0gKGJhc2UgMHhmODAwMDAw
MCkKWyAgICAwLjMzNzUzMl0gUENJOiBNTUNPTkZJRyBhdCBbbWVtIDB4ZjgwMDAwMDAtMHhm
YmZmZmZmZl0gcmVzZXJ2ZWQgaW4gRTgyMApbICAgIDAuMzQ0Njc1XSBQQ0k6IFVzaW5nIGNv
bmZpZ3VyYXRpb24gdHlwZSAxIGZvciBiYXNlIGFjY2VzcwpbICAgIDAuMzUwNzM4XSBiaW86
IGNyZWF0ZSBzbGFiIDxiaW8tMD4gYXQgMApbICAgIDAuNTE2MDgyXSByYWlkNjogaW50NjR4
MSAgIDI5MjEgTUIvcwpbICAgIDAuNjg1ODIxXSByYWlkNjogaW50NjR4MiAgIDMwMDIgTUIv
cwpbICAgIDAuODU1NTczXSByYWlkNjogaW50NjR4NCAgIDI3MjIgTUIvcwpbICAgIDEuMDI1
MzMyXSByYWlkNjogaW50NjR4OCAgIDE3MjkgTUIvcwpbICAgIDEuMTk1MDQ5XSByYWlkNjog
c3NlMngxICAgIDc1MjAgTUIvcwpbICAgIDEuMzY0Nzk5XSByYWlkNjogc3NlMngyICAgIDky
NzMgTUIvcwpbICAgIDEuNTM0NTQ2XSByYWlkNjogc3NlMng0ICAgMTA1NTIgTUIvcwpbICAg
IDEuNTM0NjM4XSByYWlkNjogdXNpbmcgYWxnb3JpdGhtIHNzZTJ4NCAoMTA1NTIgTUIvcykK
WyAgICAxLjUzNDc3M10gQUNQSTogQWRkZWQgX09TSShNb2R1bGUgRGV2aWNlKQpbICAgIDEu
NTM0ODY4XSBBQ1BJOiBBZGRlZCBfT1NJKFByb2Nlc3NvciBEZXZpY2UpClsgICAgMS41MzQ5
NjRdIEFDUEk6IEFkZGVkIF9PU0koMy4wIF9TQ1AgRXh0ZW5zaW9ucykKWyAgICAxLjUzNTA1
OV0gQUNQSTogQWRkZWQgX09TSShQcm9jZXNzb3IgQWdncmVnYXRvciBEZXZpY2UpClsgICAg
MS41MzYzNzFdIEFDUEk6IEVDOiBMb29rIHVwIEVDIGluIERTRFQKWyAgICAxLjUzNzY4Nl0g
QUNQSTogRXhlY3V0ZWQgMSBibG9ja3Mgb2YgbW9kdWxlLWxldmVsIGV4ZWN1dGFibGUgQU1M
IGNvZGUKWyAgICAxLjU0MjE1M10gW0Zpcm13YXJlIEJ1Z106IEFDUEk6IEJJT1MgX09TSShM
aW51eCkgcXVlcnkgaWdub3JlZApbICAgIDEuNTQ2NjQzXSBBQ1BJOiBTU0RUIDAwMDAwMDAw
ZGFkNTE2OTggMDA2NEYgKHYwMSAgUG1SZWYgIENwdTBDc3QgMDAwMDMwMDEgSU5UTCAyMDA1
MTExNykKWyAgICAxLjU0NzE4M10gQUNQSTogRHluYW1pYyBPRU0gVGFibGUgTG9hZDoKWyAg
ICAxLjU0NzM1Ml0gQUNQSTogU1NEVCAgICAgICAgICAgKG51bGwpIDAwNjRGICh2MDEgIFBt
UmVmICBDcHUwQ3N0IDAwMDAzMDAxIElOVEwgMjAwNTExMTcpClsgICAgMS41NDc5MzRdIEFD
UEk6IFNTRFQgMDAwMDAwMDBkYWQ1MmE5OCAwMDMwMyAodjAxICBQbVJlZiAgICBBcElzdCAw
MDAwMzAwMCBJTlRMIDIwMDUxMTE3KQpbICAgIDEuNTQ4NTEzXSBBQ1BJOiBEeW5hbWljIE9F
TSBUYWJsZSBMb2FkOgpbICAgIDEuNTQ4NjgzXSBBQ1BJOiBTU0RUICAgICAgICAgICAobnVs
bCkgMDAzMDMgKHYwMSAgUG1SZWYgICAgQXBJc3QgMDAwMDMwMDAgSU5UTCAyMDA1MTExNykK
WyAgICAxLjU0OTAyOF0gQUNQSTogU1NEVCAwMDAwMDAwMGRhZDUwZDk4IDAwMTE5ICh2MDEg
IFBtUmVmICAgIEFwQ3N0IDAwMDAzMDAwIElOVEwgMjAwNTExMTcpClsgICAgMS41NDk1NTdd
IEFDUEk6IER5bmFtaWMgT0VNIFRhYmxlIExvYWQ6ClsgICAgMS41NDk3MjddIEFDUEk6IFNT
RFQgICAgICAgICAgIChudWxsKSAwMDExOSAodjAxICBQbVJlZiAgICBBcENzdCAwMDAwMzAw
MCBJTlRMIDIwMDUxMTE3KQpbICAgIDEuNTUwNTE1XSBBQ1BJOiBJbnRlcnByZXRlciBlbmFi
bGVkClsgICAgMS41NTA2MDldIEFDUEk6IChzdXBwb3J0cyBTMCBTMSBTMyBTNCBTNSkKWyAg
ICAxLjU1MDkyMF0gQUNQSTogVXNpbmcgSU9BUElDIGZvciBpbnRlcnJ1cHQgcm91dGluZwpb
ICAgIDEuNTc1MzMwXSBBQ1BJOiBObyBkb2NrIGRldmljZXMgZm91bmQuClsgICAgMS41NzU0
MjRdIFBDSTogVXNpbmcgaG9zdCBicmlkZ2Ugd2luZG93cyBmcm9tIEFDUEk7IGlmIG5lY2Vz
c2FyeSwgdXNlICJwY2k9bm9jcnMiIGFuZCByZXBvcnQgYSBidWcKWyAgICAxLjU3NTg5OF0g
QUNQSTogUENJIFJvb3QgQnJpZGdlIFtQQ0kwXSAoZG9tYWluIDAwMDAgW2J1cyAwMC0zZV0p
ClsgICAgMS41NzY0MzJdIHBjaV9yb290IFBOUDBBMDg6MDA6IGhvc3QgYnJpZGdlIHdpbmRv
dyBbaW8gIDB4MDAwMC0weDBjZjddClsgICAgMS41NzY1MjldIHBjaV9yb290IFBOUDBBMDg6
MDA6IGhvc3QgYnJpZGdlIHdpbmRvdyBbaW8gIDB4MGQwMC0weGZmZmZdClsgICAgMS41NzY2
MjVdIHBjaV9yb290IFBOUDBBMDg6MDA6IGhvc3QgYnJpZGdlIHdpbmRvdyBbbWVtIDB4MDAw
YTAwMDAtMHgwMDBiZmZmZl0KWyAgICAxLjU3Njc2OV0gcGNpX3Jvb3QgUE5QMEEwODowMDog
aG9zdCBicmlkZ2Ugd2luZG93IFttZW0gMHgwMDBkMDAwMC0weDAwMGQzZmZmXQpbICAgIDEu
NTc2OTE1XSBwY2lfcm9vdCBQTlAwQTA4OjAwOiBob3N0IGJyaWRnZSB3aW5kb3cgW21lbSAw
eDAwMGQ0MDAwLTB4MDAwZDdmZmZdClsgICAgMS41NzcwNjBdIHBjaV9yb290IFBOUDBBMDg6
MDA6IGhvc3QgYnJpZGdlIHdpbmRvdyBbbWVtIDB4MDAwZDgwMDAtMHgwMDBkYmZmZl0KWyAg
ICAxLjU3NzIwNV0gcGNpX3Jvb3QgUE5QMEEwODowMDogaG9zdCBicmlkZ2Ugd2luZG93IFtt
ZW0gMHgwMDBkYzAwMC0weDAwMGRmZmZmXQpbICAgIDEuNTc3MzUxXSBwY2lfcm9vdCBQTlAw
QTA4OjAwOiBob3N0IGJyaWRnZSB3aW5kb3cgW21lbSAweDAwMGUwMDAwLTB4MDAwZTNmZmZd
ClsgICAgMS41Nzc0OTZdIHBjaV9yb290IFBOUDBBMDg6MDA6IGhvc3QgYnJpZGdlIHdpbmRv
dyBbbWVtIDB4MDAwZTQwMDAtMHgwMDBlN2ZmZl0KWyAgICAxLjU3NzY0MV0gcGNpX3Jvb3Qg
UE5QMEEwODowMDogaG9zdCBicmlkZ2Ugd2luZG93IFttZW0gMHhkZmEwMDAwMC0weGZlYWZm
ZmZmXQpbICAgIDEuNTc3Nzg1XSBwY2lfcm9vdCBQTlAwQTA4OjAwOiBob3N0IGJyaWRnZSB3
aW5kb3cgW21lbSAweGZlZDQwMDAwLTB4ZmVkNDRmZmZdClsgICAgMS41Nzc5NzNdIFBDSSBo
b3N0IGJyaWRnZSB0byBidXMgMDAwMDowMApbICAgIDEuNTc4MDY3XSBwY2lfYnVzIDAwMDA6
MDA6IGJ1c25fcmVzOiBbYnVzIDAwLTNlXSBmb3Igcm9vdCBidXMKWyAgICAxLjU3ODA2OV0g
cGNpX2J1cyAwMDAwOjAwOiByb290IGJ1cyByZXNvdXJjZSBbYnVzIDAwLTNlXQpbICAgIDEu
NTc4MTYzXSBwY2lfYnVzIDAwMDA6MDA6IHJvb3QgYnVzIHJlc291cmNlIFtpbyAgMHgwMDAw
LTB4MGNmN10KWyAgICAxLjU3ODI1OV0gcGNpX2J1cyAwMDAwOjAwOiByb290IGJ1cyByZXNv
dXJjZSBbaW8gIDB4MGQwMC0weGZmZmZdClsgICAgMS41NzgzNTVdIHBjaV9idXMgMDAwMDow
MDogcm9vdCBidXMgcmVzb3VyY2UgW21lbSAweDAwMGEwMDAwLTB4MDAwYmZmZmZdClsgICAg
MS41Nzg0NTJdIHBjaV9idXMgMDAwMDowMDogcm9vdCBidXMgcmVzb3VyY2UgW21lbSAweDAw
MGQwMDAwLTB4MDAwZDNmZmZdClsgICAgMS41Nzg1NDddIHBjaV9idXMgMDAwMDowMDogcm9v
dCBidXMgcmVzb3VyY2UgW21lbSAweDAwMGQ0MDAwLTB4MDAwZDdmZmZdClsgICAgMS41Nzg2
NDRdIHBjaV9idXMgMDAwMDowMDogcm9vdCBidXMgcmVzb3VyY2UgW21lbSAweDAwMGQ4MDAw
LTB4MDAwZGJmZmZdClsgICAgMS41Nzg3NDJdIHBjaV9idXMgMDAwMDowMDogcm9vdCBidXMg
cmVzb3VyY2UgW21lbSAweDAwMGRjMDAwLTB4MDAwZGZmZmZdClsgICAgMS41Nzg4MzldIHBj
aV9idXMgMDAwMDowMDogcm9vdCBidXMgcmVzb3VyY2UgW21lbSAweDAwMGUwMDAwLTB4MDAw
ZTNmZmZdClsgICAgMS41Nzg5MzZdIHBjaV9idXMgMDAwMDowMDogcm9vdCBidXMgcmVzb3Vy
Y2UgW21lbSAweDAwMGU0MDAwLTB4MDAwZTdmZmZdClsgICAgMS41NzkwMzRdIHBjaV9idXMg
MDAwMDowMDogcm9vdCBidXMgcmVzb3VyY2UgW21lbSAweGRmYTAwMDAwLTB4ZmVhZmZmZmZd
ClsgICAgMS41NzkxMzBdIHBjaV9idXMgMDAwMDowMDogcm9vdCBidXMgcmVzb3VyY2UgW21l
bSAweGZlZDQwMDAwLTB4ZmVkNDRmZmZdClsgICAgMS41NzkyMzNdIHBjaSAwMDAwOjAwOjAw
LjA6IFs4MDg2OjAxMDRdIHR5cGUgMDAgY2xhc3MgMHgwNjAwMDAKWyAgICAxLjU3OTI2N10g
cGNpIDAwMDA6MDA6MDIuMDogWzgwODY6MDEyNl0gdHlwZSAwMCBjbGFzcyAweDAzMDAwMApb
ICAgIDEuNTc5Mjc2XSBwY2kgMDAwMDowMDowMi4wOiByZWcgMTA6IFttZW0gMHhmNjgwMDAw
MC0weGY2YmZmZmZmIDY0Yml0XQpbICAgIDEuNTc5MjgyXSBwY2kgMDAwMDowMDowMi4wOiBy
ZWcgMTg6IFttZW0gMHhlMDAwMDAwMC0weGVmZmZmZmZmIDY0Yml0IHByZWZdClsgICAgMS41
NzkyODZdIHBjaSAwMDAwOjAwOjAyLjA6IHJlZyAyMDogW2lvICAweGYwMDAtMHhmMDNmXQpb
ICAgIDEuNTc5MzM2XSBwY2kgMDAwMDowMDoxNi4wOiBbODA4NjoxYzNhXSB0eXBlIDAwIGNs
YXNzIDB4MDc4MDAwClsgICAgMS41NzkzNThdIHBjaSAwMDAwOjAwOjE2LjA6IHJlZyAxMDog
W21lbSAweGY3ZjBhMDAwLTB4ZjdmMGEwMGYgNjRiaXRdClsgICAgMS41Nzk0MzJdIHBjaSAw
MDAwOjAwOjE2LjA6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDAgRDNob3QgRDNjb2xkClsgICAg
MS41Nzk0NjZdIHBjaSAwMDAwOjAwOjFhLjA6IFs4MDg2OjFjMmRdIHR5cGUgMDAgY2xhc3Mg
MHgwYzAzMjAKWyAgICAxLjU3OTQ4Nl0gcGNpIDAwMDA6MDA6MWEuMDogcmVnIDEwOiBbbWVt
IDB4ZjdmMDgwMDAtMHhmN2YwODNmZl0KWyAgICAxLjU3OTU3NF0gcGNpIDAwMDA6MDA6MWEu
MDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMCBEM2hvdCBEM2NvbGQKWyAgICAxLjU3OTYwMF0g
cGNpIDAwMDA6MDA6MWIuMDogWzgwODY6MWMyMF0gdHlwZSAwMCBjbGFzcyAweDA0MDMwMApb
ICAgIDEuNTc5NjE1XSBwY2kgMDAwMDowMDoxYi4wOiByZWcgMTA6IFttZW0gMHhmN2YwMDAw
MC0weGY3ZjAzZmZmIDY0Yml0XQpbICAgIDEuNTc5NjgxXSBwY2kgMDAwMDowMDoxYi4wOiBQ
TUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZApbICAgIDEuNTc5NzA2XSBwY2kg
MDAwMDowMDoxYy4wOiBbODA4NjoxYzEwXSB0eXBlIDAxIGNsYXNzIDB4MDYwNDAwClsgICAg
MS41Nzk3ODNdIHBjaSAwMDAwOjAwOjFjLjA6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDAgRDNo
b3QgRDNjb2xkClsgICAgMS41Nzk4MDldIHBjaSAwMDAwOjAwOjFjLjE6IFs4MDg2OjFjMTJd
IHR5cGUgMDEgY2xhc3MgMHgwNjA0MDAKWyAgICAxLjU3OTg4Nl0gcGNpIDAwMDA6MDA6MWMu
MTogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMCBEM2hvdCBEM2NvbGQKWyAgICAxLjU3OTkxM10g
cGNpIDAwMDA6MDA6MWMuMzogWzgwODY6MWMxNl0gdHlwZSAwMSBjbGFzcyAweDA2MDQwMApb
ICAgIDEuNTc5OTg5XSBwY2kgMDAwMDowMDoxYy4zOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQw
IEQzaG90IEQzY29sZApbICAgIDEuNTgwMDE5XSBwY2kgMDAwMDowMDoxYy40OiBbODA4Njox
YzE4XSB0eXBlIDAxIGNsYXNzIDB4MDYwNDAwClsgICAgMS41ODAxNTBdIHBjaSAwMDAwOjAw
OjFjLjQ6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDAgRDNob3QgRDNjb2xkClsgICAgMS41ODAx
OTFdIHBjaSAwMDAwOjAwOjFjLjc6IFs4MDg2OjFjMWVdIHR5cGUgMDEgY2xhc3MgMHgwNjA0
MDAKWyAgICAxLjU4MDMyNV0gcGNpIDAwMDA6MDA6MWMuNzogUE1FIyBzdXBwb3J0ZWQgZnJv
bSBEMCBEM2hvdCBEM2NvbGQKWyAgICAxLjU4MDM2NV0gcGNpIDAwMDA6MDA6MWQuMDogWzgw
ODY6MWMyNl0gdHlwZSAwMCBjbGFzcyAweDBjMDMyMApbICAgIDEuNTgwMzg1XSBwY2kgMDAw
MDowMDoxZC4wOiByZWcgMTA6IFttZW0gMHhmN2YwNzAwMC0weGY3ZjA3M2ZmXQpbICAgIDEu
NTgwNDczXSBwY2kgMDAwMDowMDoxZC4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90
IEQzY29sZApbICAgIDEuNTgwNDk5XSBwY2kgMDAwMDowMDoxZi4wOiBbODA4NjoxYzRiXSB0
eXBlIDAwIGNsYXNzIDB4MDYwMTAwClsgICAgMS41ODA2MjJdIHBjaSAwMDAwOjAwOjFmLjI6
IFs4MDg2OjFjMDNdIHR5cGUgMDAgY2xhc3MgMHgwMTA2MDEKWyAgICAxLjU4MDYzOV0gcGNp
IDAwMDA6MDA6MWYuMjogcmVnIDEwOiBbaW8gIDB4ZjBiMC0weGYwYjddClsgICAgMS41ODA2
NDddIHBjaSAwMDAwOjAwOjFmLjI6IHJlZyAxNDogW2lvICAweGYwYTAtMHhmMGEzXQpbICAg
IDEuNTgwNjU1XSBwY2kgMDAwMDowMDoxZi4yOiByZWcgMTg6IFtpbyAgMHhmMDkwLTB4ZjA5
N10KWyAgICAxLjU4MDY2M10gcGNpIDAwMDA6MDA6MWYuMjogcmVnIDFjOiBbaW8gIDB4ZjA4
MC0weGYwODNdClsgICAgMS41ODA2NzBdIHBjaSAwMDAwOjAwOjFmLjI6IHJlZyAyMDogW2lv
ICAweGYwNjAtMHhmMDdmXQpbICAgIDEuNTgwNjc4XSBwY2kgMDAwMDowMDoxZi4yOiByZWcg
MjQ6IFttZW0gMHhmN2YwNjAwMC0weGY3ZjA2N2ZmXQpbICAgIDEuNTgwNzIxXSBwY2kgMDAw
MDowMDoxZi4yOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQzaG90ClsgICAgMS41ODA3NDBdIHBj
aSAwMDAwOjAwOjFmLjM6IFs4MDg2OjFjMjJdIHR5cGUgMDAgY2xhc3MgMHgwYzA1MDAKWyAg
ICAxLjU4MDc1NV0gcGNpIDAwMDA6MDA6MWYuMzogcmVnIDEwOiBbbWVtIDB4ZjdmMDUwMDAt
MHhmN2YwNTBmZiA2NGJpdF0KWyAgICAxLjU4MDc3NV0gcGNpIDAwMDA6MDA6MWYuMzogcmVn
IDIwOiBbaW8gIDB4ZjA0MC0weGYwNWZdClsgICAgMS41ODA4MDVdIHBjaSAwMDAwOjAwOjFj
LjA6IGNoZWNrIGlmIGJ1c24gMDMtMDQgaXMgaW4gYnVzbl9yZXM6IFtidXMgMDAtM2VdClsg
ICAgMS41ODA4NTJdIHBjaV9idXMgMDAwMDowMzogYnVzbl9yZXM6IFtidXMgMDMtMDRdIGlz
IGluc2VydGVkIHVuZGVyIFtidXMgMDAtM2VdClsgICAgMS41ODA4NTZdIHBjaSAwMDAwOjAw
OjFjLjA6IFBDSSBicmlkZ2UgdG8gW2J1cyAwMy0wNF0KWyAgICAxLjU4MDk2Ml0gcGNpIDAw
MDA6MDA6MWMuMTogY2hlY2sgaWYgYnVzbiAwNS0wNiBpcyBpbiBidXNuX3JlczogW2J1cyAw
MC0zZV0KWyAgICAxLjU4MTAwN10gcGNpX2J1cyAwMDAwOjA1OiBidXNuX3JlczogW2J1cyAw
NS0wNl0gaXMgaW5zZXJ0ZWQgdW5kZXIgW2J1cyAwMC0zZV0KWyAgICAxLjU4MTAzM10gcGNp
IDAwMDA6MDU6MDAuMDogWzEwZWM6ODE2OF0gdHlwZSAwMCBjbGFzcyAweDAyMDAwMApbICAg
IDEuNTgxMDUzXSBwY2kgMDAwMDowNTowMC4wOiByZWcgMTA6IFtpbyAgMHhlMDAwLTB4ZTBm
Zl0KWyAgICAxLjU4MTA4N10gcGNpIDAwMDA6MDU6MDAuMDogcmVnIDE4OiBbbWVtIDB4ZjEx
MDQwMDAtMHhmMTEwNGZmZiA2NGJpdCBwcmVmXQpbICAgIDEuNTgxMTA5XSBwY2kgMDAwMDow
NTowMC4wOiByZWcgMjA6IFttZW0gMHhmMTEwMDAwMC0weGYxMTAzZmZmIDY0Yml0IHByZWZd
ClsgICAgMS41ODEyMDBdIHBjaSAwMDAwOjA1OjAwLjA6IHN1cHBvcnRzIEQxIEQyClsgICAg
MS41ODEyMDJdIHBjaSAwMDAwOjA1OjAwLjA6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDAgRDEg
RDIgRDNob3QgRDNjb2xkClsgICAgMS42MDAzMTBdIHBjaSAwMDAwOjAwOjFjLjE6IFBDSSBi
cmlkZ2UgdG8gW2J1cyAwNS0wNl0KWyAgICAxLjYwMDQ0OV0gcGNpIDAwMDA6MDA6MWMuMTog
ICBicmlkZ2Ugd2luZG93IFtpbyAgMHhlMDAwLTB4ZWZmZl0KWyAgICAxLjYwMDQ1OF0gcGNp
IDAwMDA6MDA6MWMuMTogICBicmlkZ2Ugd2luZG93IFttZW0gMHhmMTEwMDAwMC0weGYxMWZm
ZmZmIDY0Yml0IHByZWZdClsgICAgMS42MDA0NjJdIHBjaSAwMDAwOjAwOjFjLjM6IGNoZWNr
IGlmIGJ1c24gMDktMGEgaXMgaW4gYnVzbl9yZXM6IFtidXMgMDAtM2VdClsgICAgMS42MDA1
MDZdIHBjaV9idXMgMDAwMDowOTogYnVzbl9yZXM6IFtidXMgMDktMGFdIGlzIGluc2VydGVk
IHVuZGVyIFtidXMgMDAtM2VdClsgICAgMS42MDA2NjFdIHBjaSAwMDAwOjA5OjAwLjA6IFs4
MDg2OjAwOGFdIHR5cGUgMDAgY2xhc3MgMHgwMjgwMDAKWyAgICAxLjYwMDc5MF0gcGNpIDAw
MDA6MDk6MDAuMDogcmVnIDEwOiBbbWVtIDB4ZjdlMDAwMDAtMHhmN2UwMWZmZiA2NGJpdF0K
WyAgICAxLjYwMTM1Nl0gcGNpIDAwMDA6MDk6MDAuMDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBE
MCBEM2hvdCBEM2NvbGQKWyAgICAxLjYyMDM5NF0gcGNpIDAwMDA6MDA6MWMuMzogUENJIGJy
aWRnZSB0byBbYnVzIDA5LTBhXQpbICAgIDEuNjIwNDkyXSBwY2kgMDAwMDowMDoxYy4zOiAg
IGJyaWRnZSB3aW5kb3cgW21lbSAweGY3ZTAwMDAwLTB4ZjdlZmZmZmZdClsgICAgMS42MjA1
MDJdIHBjaSAwMDAwOjAwOjFjLjQ6IGNoZWNrIGlmIGJ1c24gMGItMGMgaXMgaW4gYnVzbl9y
ZXM6IFtidXMgMDAtM2VdClsgICAgMS42MjA1NzBdIHBjaV9idXMgMDAwMDowYjogYnVzbl9y
ZXM6IFtidXMgMGItMGNdIGlzIGluc2VydGVkIHVuZGVyIFtidXMgMDAtM2VdClsgICAgMS42
MjA1OTddIHBjaSAwMDAwOjBiOjAwLjA6IFsxMDRjOjgyNDFdIHR5cGUgMDAgY2xhc3MgMHgw
YzAzMzAKWyAgICAxLjYyMDYyMl0gcGNpIDAwMDA6MGI6MDAuMDogcmVnIDEwOiBbbWVtIDB4
ZjdkMDAwMDAtMHhmN2QwZmZmZiA2NGJpdF0KWyAgICAxLjYyMDY0Ml0gcGNpIDAwMDA6MGI6
MDAuMDogcmVnIDE4OiBbbWVtIDB4ZjdkMTAwMDAtMHhmN2QxMWZmZiA2NGJpdF0KWyAgICAx
LjYyMDc0Nl0gcGNpIDAwMDA6MGI6MDAuMDogc3VwcG9ydHMgRDEgRDIKWyAgICAxLjYyMDc0
N10gcGNpIDAwMDA6MGI6MDAuMDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMCBEMSBEMiBEM2hv
dCBEM2NvbGQKWyAgICAxLjY0MDI0OF0gcGNpIDAwMDA6MDA6MWMuNDogUENJIGJyaWRnZSB0
byBbYnVzIDBiLTBjXQpbICAgIDEuNjQwMzkyXSBwY2kgMDAwMDowMDoxYy40OiAgIGJyaWRn
ZSB3aW5kb3cgW21lbSAweGY3ZDAwMDAwLTB4ZjdkZmZmZmZdClsgICAgMS42NDA0MDRdIHBj
aSAwMDAwOjAwOjFjLjc6IGNoZWNrIGlmIGJ1c24gMTEtMTYgaXMgaW4gYnVzbl9yZXM6IFti
dXMgMDAtM2VdClsgICAgMS42NDA0NjldIHBjaV9idXMgMDAwMDoxMTogYnVzbl9yZXM6IFti
dXMgMTEtMTZdIGlzIGluc2VydGVkIHVuZGVyIFtidXMgMDAtM2VdClsgICAgMS42NDA0NzNd
IHBjaSAwMDAwOjAwOjFjLjc6IFBDSSBicmlkZ2UgdG8gW2J1cyAxMS0xNl0KWyAgICAxLjY0
MDU3MV0gcGNpIDAwMDA6MDA6MWMuNzogICBicmlkZ2Ugd2luZG93IFtpbyAgMHhjMDAwLTB4
ZGZmZl0KWyAgICAxLjY0MDU3NV0gcGNpIDAwMDA6MDA6MWMuNzogICBicmlkZ2Ugd2luZG93
IFttZW0gMHhmNmMwMDAwMC0weGY3Y2ZmZmZmXQpbICAgIDEuNjQwNTg0XSBwY2kgMDAwMDow
MDoxYy43OiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGYwMDAwMDAwLTB4ZjEwZmZmZmYgNjRi
aXQgcHJlZl0KWyAgICAxLjY0MDYzNl0gcGNpIDAwMDA6MDA6MWMuMDogUENJIGJyaWRnZSB0
byBbYnVzIDAzLTA0XQpbICAgIDEuNjQwNzQ2XSBwY2kgMDAwMDowMDoxYy4xOiBQQ0kgYnJp
ZGdlIHRvIFtidXMgMDUtMDZdClsgICAgMS42NDA4NDJdIHBjaSAwMDAwOjAwOjFjLjE6ICAg
YnJpZGdlIHdpbmRvdyBbaW8gIDB4ZTAwMC0weGVmZmZdClsgICAgMS42NDA4NTBdIHBjaSAw
MDAwOjAwOjFjLjE6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZjExMDAwMDAtMHhmMTFmZmZm
ZiA2NGJpdCBwcmVmXQpbICAgIDEuNjQwODgyXSBwY2kgMDAwMDowMDoxYy4zOiBQQ0kgYnJp
ZGdlIHRvIFtidXMgMDktMGFdClsgICAgMS42NDA5ODBdIHBjaSAwMDAwOjAwOjFjLjM6ICAg
YnJpZGdlIHdpbmRvdyBbbWVtIDB4ZjdlMDAwMDAtMHhmN2VmZmZmZl0KWyAgICAxLjY0MDk5
OF0gcGNpIDAwMDA6MDA6MWMuNDogUENJIGJyaWRnZSB0byBbYnVzIDBiLTBjXQpbICAgIDEu
NjQxMDk5XSBwY2kgMDAwMDowMDoxYy40OiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGY3ZDAw
MDAwLTB4ZjdkZmZmZmZdClsgICAgMS42NDExMTZdIHBjaSAwMDAwOjAwOjFjLjc6IFBDSSBi
cmlkZ2UgdG8gW2J1cyAxMS0xNl0KWyAgICAxLjY0MTIxNF0gcGNpIDAwMDA6MDA6MWMuNzog
ICBicmlkZ2Ugd2luZG93IFtpbyAgMHhjMDAwLTB4ZGZmZl0KWyAgICAxLjY0MTIxOV0gcGNp
IDAwMDA6MDA6MWMuNzogICBicmlkZ2Ugd2luZG93IFttZW0gMHhmNmMwMDAwMC0weGY3Y2Zm
ZmZmXQpbICAgIDEuNjQxMjI3XSBwY2kgMDAwMDowMDoxYy43OiAgIGJyaWRnZSB3aW5kb3cg
W21lbSAweGYwMDAwMDAwLTB4ZjEwZmZmZmYgNjRiaXQgcHJlZl0KWyAgICAxLjY0MTIzM10g
QUNQSTogUENJIEludGVycnVwdCBSb3V0aW5nIFRhYmxlIFtcX1NCXy5QQ0kwLl9QUlRdClsg
ICAgMS42NDE0MDNdIEFDUEk6IFBDSSBJbnRlcnJ1cHQgUm91dGluZyBUYWJsZSBbXF9TQl8u
UENJMC5SUDAxLl9QUlRdClsgICAgMS42NDE0NDBdIEFDUEk6IFBDSSBJbnRlcnJ1cHQgUm91
dGluZyBUYWJsZSBbXF9TQl8uUENJMC5SUDAyLl9QUlRdClsgICAgMS42NDE0NzldIEFDUEk6
IFBDSSBJbnRlcnJ1cHQgUm91dGluZyBUYWJsZSBbXF9TQl8uUENJMC5SUDA0Ll9QUlRdClsg
ICAgMS42NDE1MTVdIEFDUEk6IFBDSSBJbnRlcnJ1cHQgUm91dGluZyBUYWJsZSBbXF9TQl8u
UENJMC5SUDA1Ll9QUlRdClsgICAgMS42NDE1NjddIEFDUEk6IFBDSSBJbnRlcnJ1cHQgUm91
dGluZyBUYWJsZSBbXF9TQl8uUENJMC5SUDA4Ll9QUlRdClsgICAgMS42NDE2OTZdICBwY2kw
MDAwOjAwOiBSZXF1ZXN0aW5nIEFDUEkgX09TQyBjb250cm9sICgweDFkKQpbICAgIDEuNjQy
MDAyXSAgcGNpMDAwMDowMDogQUNQSSBfT1NDIGNvbnRyb2wgKDB4MTkpIGdyYW50ZWQKWyAg
ICAxLjY0NjY4Ml0gQUNQSTogUENJIEludGVycnVwdCBMaW5rIFtMTktBXSAoSVJRcyAzIDQg
NSA2IDEwICoxMSAxMiAxNCAxNSkKWyAgICAxLjY0NzI0OF0gQUNQSTogUENJIEludGVycnVw
dCBMaW5rIFtMTktCXSAoSVJRcyAzIDQgKjUgNiAxMCAxMSAxMiAxNCAxNSkKWyAgICAxLjY0
NzgwOF0gQUNQSTogUENJIEludGVycnVwdCBMaW5rIFtMTktDXSAoSVJRcyAqMyA0IDUgNiAx
MCAxMSAxMiAxNCAxNSkKWyAgICAxLjY0ODM2OV0gQUNQSTogUENJIEludGVycnVwdCBMaW5r
IFtMTktEXSAoSVJRcyAzIDQgNSA2ICoxMCAxMSAxMiAxNCAxNSkKWyAgICAxLjY0ODkyOV0g
QUNQSTogUENJIEludGVycnVwdCBMaW5rIFtMTktFXSAoSVJRcyAzIDQgNSA2IDEwIDExIDEy
IDE0IDE1KSAqMCwgZGlzYWJsZWQuClsgICAgMS42NDk2MThdIEFDUEk6IFBDSSBJbnRlcnJ1
cHQgTGluayBbTE5LRl0gKElSUXMgMyA0IDUgNiAxMCAxMSAxMiAxNCAxNSkgKjAsIGRpc2Fi
bGVkLgpbICAgIDEuNjUwMzA4XSBBQ1BJOiBQQ0kgSW50ZXJydXB0IExpbmsgW0xOS0ddIChJ
UlFzIDMgNCAqNSA2IDEwIDExIDEyIDE0IDE1KQpbICAgIDEuNjUwODcwXSBBQ1BJOiBQQ0kg
SW50ZXJydXB0IExpbmsgW0xOS0hdIChJUlFzIDMgNCAqNSA2IDEwIDExIDEyIDE0IDE1KQpb
ICAgIDEuNjUxNDI1XSBhY3BpIHJvb3Q6IFxfU0JfLlBDSTAgbm90aWZ5IGhhbmRsZXIgaW5z
dGFsbGVkClsgICAgMS42NTE0NzZdIEZvdW5kIDEgYWNwaSByb290IGRldmljZXMKWyAgICAx
LjY1MTU2MV0gdmdhYXJiOiBkZXZpY2UgYWRkZWQ6IFBDSTowMDAwOjAwOjAyLjAsZGVjb2Rl
cz1pbyttZW0sb3ducz1pbyttZW0sbG9ja3M9bm9uZQpbICAgIDEuNjUxNzEzXSB2Z2FhcmI6
IGxvYWRlZApbICAgIDEuNjUxODAzXSB2Z2FhcmI6IGJyaWRnZSBjb250cm9sIHBvc3NpYmxl
IDAwMDA6MDA6MDIuMApbICAgIDEuNjUyMDMzXSBTQ1NJIHN1YnN5c3RlbSBpbml0aWFsaXpl
ZApbICAgIDEuNjUyMTkxXSBsaWJhdGEgdmVyc2lvbiAzLjAwIGxvYWRlZC4KWyAgICAxLjY1
MjI5Ml0gdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciB1c2Jmcwpb
ICAgIDEuNjUyNDA3XSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBpbnRlcmZhY2UgZHJpdmVy
IGh1YgpbICAgIDEuNjUyNTI4XSB1c2Jjb3JlOiByZWdpc3RlcmVkIG5ldyBkZXZpY2UgZHJp
dmVyIHVzYgpbICAgIDEuNjUyNjc4XSBMaW51eCBtZWRpYSBpbnRlcmZhY2U6IHYwLjEwClsg
ICAgMS42NTI3OTFdIExpbnV4IHZpZGVvIGNhcHR1cmUgaW50ZXJmYWNlOiB2Mi4wMApbICAg
IDEuNjUzMjQ0XSB3bWk6IE1hcHBlciBsb2FkZWQKWyAgICAxLjY1MzM3OV0gQWR2YW5jZWQg
TGludXggU291bmQgQXJjaGl0ZWN0dXJlIERyaXZlciBWZXJzaW9uIDEuMC4yNS4KWyAgICAx
LjY1MzQ3NV0gUENJOiBVc2luZyBBQ1BJIGZvciBJUlEgcm91dGluZwpbICAgIDEuNjU1NDY3
XSBQQ0k6IHBjaV9jYWNoZV9saW5lX3NpemUgc2V0IHRvIDY0IGJ5dGVzClsgICAgMS42NTU1
NzNdIHJlc2VydmUgUkFNIGJ1ZmZlcjogMDAwMDAwMDAwMDA5ZDQwMCAtIDAwMDAwMDAwMDAw
OWZmZmYgClsgICAgMS42NTU1NzZdIHJlc2VydmUgUkFNIGJ1ZmZlcjogMDAwMDAwMDBkYTRl
NTAwMCAtIDAwMDAwMDAwZGJmZmZmZmYgClsgICAgMS42NTU1NzldIHJlc2VydmUgUkFNIGJ1
ZmZlcjogMDAwMDAwMDBkYTc5MzAwMCAtIDAwMDAwMDAwZGJmZmZmZmYgClsgICAgMS42NTU1
ODJdIHJlc2VydmUgUkFNIGJ1ZmZlcjogMDAwMDAwMDBkYWE4OTAwMCAtIDAwMDAwMDAwZGJm
ZmZmZmYgClsgICAgMS42NTU1ODRdIHJlc2VydmUgUkFNIGJ1ZmZlcjogMDAwMDAwMDQxZmUw
MDAwMCAtIDAwMDAwMDA0MWZmZmZmZmYgClsgICAgMS42NTU3MjBdIEJsdWV0b290aDogQ29y
ZSB2ZXIgMi4xNgpbICAgIDEuNjU1ODMyXSBORVQ6IFJlZ2lzdGVyZWQgcHJvdG9jb2wgZmFt
aWx5IDMxClsgICAgMS42NTU5MjZdIEJsdWV0b290aDogSENJIGRldmljZSBhbmQgY29ubmVj
dGlvbiBtYW5hZ2VyIGluaXRpYWxpemVkClsgICAgMS42NTYwMjNdIEJsdWV0b290aDogSENJ
IHNvY2tldCBsYXllciBpbml0aWFsaXplZApbICAgIDEuNjU2MTE3XSBCbHVldG9vdGg6IEwy
Q0FQIHNvY2tldCBsYXllciBpbml0aWFsaXplZApbICAgIDEuNjU2MjEzXSBCbHVldG9vdGg6
IFNDTyBzb2NrZXQgbGF5ZXIgaW5pdGlhbGl6ZWQKWyAgICAxLjY1NjM2OV0gY2ZnODAyMTE6
IENhbGxpbmcgQ1JEQSB0byB1cGRhdGUgd29ybGQgcmVndWxhdG9yeSBkb21haW4KWyAgICAx
LjY1NjU3Ml0gaHBldDA6IGF0IE1NSU8gMHhmZWQwMDAwMCwgSVJRcyAyLCA4LCAwLCAwLCAw
LCAwLCAwLCAwClsgICAgMS42NTcwMTZdIGhwZXQwOiA4IGNvbXBhcmF0b3JzLCA2NC1iaXQg
MTQuMzE4MTgwIE1IeiBjb3VudGVyClsgICAgMS42NTkxMjFdIFN3aXRjaGluZyB0byBjbG9j
a3NvdXJjZSBocGV0ClsgICAgMS42NTkyOTFdIHBucDogUG5QIEFDUEkgaW5pdApbICAgIDEu
NjU5MzkwXSBBQ1BJOiBidXMgdHlwZSBwbnAgcmVnaXN0ZXJlZApbICAgIDEuNjU5NzI1XSBw
bnAgMDA6MDA6IFtidXMgMDAtM2VdClsgICAgMS42NTk3MjddIHBucCAwMDowMDogW2lvICAw
eDAwMDAtMHgwY2Y3IHdpbmRvd10KWyAgICAxLjY1OTcyOF0gcG5wIDAwOjAwOiBbaW8gIDB4
MGNmOC0weDBjZmZdClsgICAgMS42NTk3MzBdIHBucCAwMDowMDogW2lvICAweDBkMDAtMHhm
ZmZmIHdpbmRvd10KWyAgICAxLjY1OTczMV0gcG5wIDAwOjAwOiBbbWVtIDB4MDAwYTAwMDAt
MHgwMDBiZmZmZiB3aW5kb3ddClsgICAgMS42NTk3MzNdIHBucCAwMDowMDogW21lbSAweDAw
MGMwMDAwLTB4MDAwYzNmZmYgd2luZG93XQpbICAgIDEuNjU5NzM1XSBwbnAgMDA6MDA6IFtt
ZW0gMHgwMDBjNDAwMC0weDAwMGM3ZmZmIHdpbmRvd10KWyAgICAxLjY1OTczNl0gcG5wIDAw
OjAwOiBbbWVtIDB4MDAwYzgwMDAtMHgwMDBjYmZmZiB3aW5kb3ddClsgICAgMS42NTk3Mzhd
IHBucCAwMDowMDogW21lbSAweDAwMGNjMDAwLTB4MDAwY2ZmZmYgd2luZG93XQpbICAgIDEu
NjU5NzM5XSBwbnAgMDA6MDA6IFttZW0gMHgwMDBkMDAwMC0weDAwMGQzZmZmIHdpbmRvd10K
WyAgICAxLjY1OTc0MV0gcG5wIDAwOjAwOiBbbWVtIDB4MDAwZDQwMDAtMHgwMDBkN2ZmZiB3
aW5kb3ddClsgICAgMS42NTk3NDJdIHBucCAwMDowMDogW21lbSAweDAwMGQ4MDAwLTB4MDAw
ZGJmZmYgd2luZG93XQpbICAgIDEuNjU5NzQ0XSBwbnAgMDA6MDA6IFttZW0gMHgwMDBkYzAw
MC0weDAwMGRmZmZmIHdpbmRvd10KWyAgICAxLjY1OTc0NV0gcG5wIDAwOjAwOiBbbWVtIDB4
MDAwZTAwMDAtMHgwMDBlM2ZmZiB3aW5kb3ddClsgICAgMS42NTk3NDddIHBucCAwMDowMDog
W21lbSAweDAwMGU0MDAwLTB4MDAwZTdmZmYgd2luZG93XQpbICAgIDEuNjU5NzQ4XSBwbnAg
MDA6MDA6IFttZW0gMHgwMDBlODAwMC0weDAwMGViZmZmIHdpbmRvd10KWyAgICAxLjY1OTc1
MF0gcG5wIDAwOjAwOiBbbWVtIDB4MDAwZWMwMDAtMHgwMDBlZmZmZiB3aW5kb3ddClsgICAg
MS42NTk3NTFdIHBucCAwMDowMDogW21lbSAweDAwMGYwMDAwLTB4MDAwZmZmZmYgd2luZG93
XQpbICAgIDEuNjU5NzUzXSBwbnAgMDA6MDA6IFttZW0gMHhkZmEwMDAwMC0weGZlYWZmZmZm
IHdpbmRvd10KWyAgICAxLjY1OTc1NV0gcG5wIDAwOjAwOiBbbWVtIDB4ZmVkNDAwMDAtMHhm
ZWQ0NGZmZiB3aW5kb3ddClsgICAgMS42NTk4MjNdIHBucCAwMDowMDogUGx1ZyBhbmQgUGxh
eSBBQ1BJIGRldmljZSwgSURzIFBOUDBhMDggUE5QMGEwMyAoYWN0aXZlKQpbICAgIDEuNjU5
ODM0XSBwbnAgMDA6MDE6IFtpbyAgMHgwMDAwLTB4MDAxZl0KWyAgICAxLjY1OTgzNl0gcG5w
IDAwOjAxOiBbaW8gIDB4MDA4MS0weDAwOTFdClsgICAgMS42NTk4MzddIHBucCAwMDowMTog
W2lvICAweDAwOTMtMHgwMDlmXQpbICAgIDEuNjU5ODM4XSBwbnAgMDA6MDE6IFtpbyAgMHgw
MGMwLTB4MDBkZl0KWyAgICAxLjY1OTg0MF0gcG5wIDAwOjAxOiBbZG1hIDRdClsgICAgMS42
NTk4ODBdIHBucCAwMDowMTogUGx1ZyBhbmQgUGxheSBBQ1BJIGRldmljZSwgSURzIFBOUDAy
MDAgKGFjdGl2ZSkKWyAgICAxLjY1OTg4OF0gcG5wIDAwOjAyOiBbbWVtIDB4ZmYwMDAwMDAt
MHhmZmZmZmZmZl0KWyAgICAxLjY1OTkyNV0gcG5wIDAwOjAyOiBQbHVnIGFuZCBQbGF5IEFD
UEkgZGV2aWNlLCBJRHMgSU5UMDgwMCAoYWN0aXZlKQpbICAgIDEuNjU5OTk4XSBwbnAgMDA6
MDM6IFttZW0gMHhmZWQwMDAwMC0weGZlZDAwM2ZmXQpbICAgIDEuNjYwMDQwXSBwbnAgMDA6
MDM6IFBsdWcgYW5kIFBsYXkgQUNQSSBkZXZpY2UsIElEcyBQTlAwMTAzIChhY3RpdmUpClsg
ICAgMS42NjAwNTFdIHBucCAwMDowNDogW2lvICAweDAwMmUtMHgwMDJmXQpbICAgIDEuNjYw
MDUyXSBwbnAgMDA6MDQ6IFtpbyAgMHgwMDRlLTB4MDA0Zl0KWyAgICAxLjY2MDA1NF0gcG5w
IDAwOjA0OiBbaW8gIDB4MDA2MV0KWyAgICAxLjY2MDA1NV0gcG5wIDAwOjA0OiBbaW8gIDB4
MDA2M10KWyAgICAxLjY2MDA1Nl0gcG5wIDAwOjA0OiBbaW8gIDB4MDA2NV0KWyAgICAxLjY2
MDA1OF0gcG5wIDAwOjA0OiBbaW8gIDB4MDA2N10KWyAgICAxLjY2MDA1OV0gcG5wIDAwOjA0
OiBbaW8gIDB4MDA3MF0KWyAgICAxLjY2MDA2MF0gcG5wIDAwOjA0OiBbaW8gIDB4MDA4MF0K
WyAgICAxLjY2MDA2MV0gcG5wIDAwOjA0OiBbaW8gIDB4MDA5Ml0KWyAgICAxLjY2MDA2Ml0g
cG5wIDAwOjA0OiBbaW8gIDB4MDBiMi0weDAwYjNdClsgICAgMS42NjAwNjRdIHBucCAwMDow
NDogW2lvICAweDA2ODAtMHgwNjlmXQpbICAgIDEuNjYwMDY1XSBwbnAgMDA6MDQ6IFtpbyAg
MHgxMDAwLTB4MTAwZl0KWyAgICAxLjY2MDA2Nl0gcG5wIDAwOjA0OiBbaW8gIDB4ZmZmZl0K
WyAgICAxLjY2MDA2OF0gcG5wIDAwOjA0OiBbaW8gIDB4ZmZmZl0KWyAgICAxLjY2MDA2OV0g
cG5wIDAwOjA0OiBbaW8gIDB4MDQwMC0weDA0NTNdClsgICAgMS42NjAwNzBdIHBucCAwMDow
NDogW2lvICAweDA0NTgtMHgwNDdmXQpbICAgIDEuNjYwMDcxXSBwbnAgMDA6MDQ6IFtpbyAg
MHgwNTAwLTB4MDU3Zl0KWyAgICAxLjY2MDA3M10gcG5wIDAwOjA0OiBbaW8gIDB4MTY0ZS0w
eDE2NGZdClsgICAgMS42NjAxMjhdIHN5c3RlbSAwMDowNDogW2lvICAweDA2ODAtMHgwNjlm
XSBoYXMgYmVlbiByZXNlcnZlZApbICAgIDEuNjYwMjI4XSBzeXN0ZW0gMDA6MDQ6IFtpbyAg
MHgxMDAwLTB4MTAwZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAxLjY2MDMyNF0gc3lzdGVt
IDAwOjA0OiBbaW8gIDB4ZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAxLjY2MDQxOV0g
c3lzdGVtIDAwOjA0OiBbaW8gIDB4ZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAxLjY2
MDUxNF0gc3lzdGVtIDAwOjA0OiBbaW8gIDB4MDQwMC0weDA0NTNdIGhhcyBiZWVuIHJlc2Vy
dmVkClsgICAgMS42NjA2MTFdIHN5c3RlbSAwMDowNDogW2lvICAweDA0NTgtMHgwNDdmXSBo
YXMgYmVlbiByZXNlcnZlZApbICAgIDEuNjYwNzA3XSBzeXN0ZW0gMDA6MDQ6IFtpbyAgMHgw
NTAwLTB4MDU3Zl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAxLjY2MDgwMl0gc3lzdGVtIDAw
OjA0OiBbaW8gIDB4MTY0ZS0weDE2NGZdIGhhcyBiZWVuIHJlc2VydmVkClsgICAgMS42NjA4
OThdIHN5c3RlbSAwMDowNDogUGx1ZyBhbmQgUGxheSBBQ1BJIGRldmljZSwgSURzIFBOUDBj
MDIgKGFjdGl2ZSkKWyAgICAxLjY2MDkwNl0gcG5wIDAwOjA1OiBbaW8gIDB4MDA3MC0weDAw
NzddClsgICAgMS42NjA5MTddIHBucCAwMDowNTogW2lycSA4XQpbICAgIDEuNjYwOTYwXSBw
bnAgMDA6MDU6IFBsdWcgYW5kIFBsYXkgQUNQSSBkZXZpY2UsIElEcyBQTlAwYjAwIChhY3Rp
dmUpClsgICAgMS42NjA5ODZdIHBucCAwMDowNjogW2lvICAweDA0NTQtMHgwNDU3XQpbICAg
IDEuNjYxMDM3XSBzeXN0ZW0gMDA6MDY6IFtpbyAgMHgwNDU0LTB4MDQ1N10gaGFzIGJlZW4g
cmVzZXJ2ZWQKWyAgICAxLjY2MTEzNF0gc3lzdGVtIDAwOjA2OiBQbHVnIGFuZCBQbGF5IEFD
UEkgZGV2aWNlLCBJRHMgSU5UM2YwZCBQTlAwYzAyIChhY3RpdmUpClsgICAgMS42NjExNDJd
IHBucCAwMDowNzogW2lvICAweDAwZjAtMHgwMGZmXQpbICAgIDEuNjYxMTQ4XSBwbnAgMDA6
MDc6IFtpcnEgMTNdClsgICAgMS42NjExOTBdIHBucCAwMDowNzogUGx1ZyBhbmQgUGxheSBB
Q1BJIGRldmljZSwgSURzIFBOUDBjMDQgKGFjdGl2ZSkKWyAgICAxLjY2MTIwNl0gcG5wIDAw
OjA4OiBbaW8gIDB4MDAxMC0weDAwMWZdClsgICAgMS42NjEyMDddIHBucCAwMDowODogW2lv
ICAweDAwMjItMHgwMDNmXQpbICAgIDEuNjYxMjA5XSBwbnAgMDA6MDg6IFtpbyAgMHgwMDQ0
LTB4MDA1Zl0KWyAgICAxLjY2MTIxMF0gcG5wIDAwOjA4OiBbaW8gIDB4MDA2OC0weDAwNmZd
ClsgICAgMS42NjEyMTFdIHBucCAwMDowODogW2lvICAweDAwNzItMHgwMDdmXQpbICAgIDEu
NjYxMjEzXSBwbnAgMDA6MDg6IFtpbyAgMHgwMDgwXQpbICAgIDEuNjYxMjE0XSBwbnAgMDA6
MDg6IFtpbyAgMHgwMDg0LTB4MDA4Nl0KWyAgICAxLjY2MTIxNl0gcG5wIDAwOjA4OiBbaW8g
IDB4MDA4OF0KWyAgICAxLjY2MTIxN10gcG5wIDAwOjA4OiBbaW8gIDB4MDA4Yy0weDAwOGVd
ClsgICAgMS42NjEyMThdIHBucCAwMDowODogW2lvICAweDAwOTAtMHgwMDlmXQpbICAgIDEu
NjYxMjIwXSBwbnAgMDA6MDg6IFtpbyAgMHgwMGEyLTB4MDBiZl0KWyAgICAxLjY2MTIyMV0g
cG5wIDAwOjA4OiBbaW8gIDB4MDBlMC0weDAwZWZdClsgICAgMS42NjEyMjJdIHBucCAwMDow
ODogW2lvICAweDA0ZDAtMHgwNGQxXQpbICAgIDEuNjYxMjI0XSBwbnAgMDA6MDg6IFttZW0g
MHhmZTgwMDAwMC0weGZlODAyZmZmXQpbICAgIDEuNjYxMjgwXSBzeXN0ZW0gMDA6MDg6IFtp
byAgMHgwNGQwLTB4MDRkMV0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAxLjY2MTM3Nl0gc3lz
dGVtIDAwOjA4OiBbbWVtIDB4ZmU4MDAwMDAtMHhmZTgwMmZmZl0gaGFzIGJlZW4gcmVzZXJ2
ZWQKWyAgICAxLjY2MTQ3M10gc3lzdGVtIDAwOjA4OiBQbHVnIGFuZCBQbGF5IEFDUEkgZGV2
aWNlLCBJRHMgUE5QMGMwMiAoYWN0aXZlKQpbICAgIDEuNjYxNDkxXSBwbnAgMDA6MDk6IFtp
cnEgMTJdClsgICAgMS42NjE1MzRdIHBucCAwMDowOTogUGx1ZyBhbmQgUGxheSBBQ1BJIGRl
dmljZSwgSURzIERMTDA0YjMgU1lOMDYwMCBTWU4wMDAyIFBOUDBmMTMgKGFjdGl2ZSkKWyAg
ICAxLjY2MTU0N10gcG5wIDAwOjBhOiBbaW8gIDB4MDA2MF0KWyAgICAxLjY2MTU0OF0gcG5w
IDAwOjBhOiBbaW8gIDB4MDA2NF0KWyAgICAxLjY2MTU1MF0gcG5wIDAwOjBhOiBbaW8gIDB4
MDA2Ml0KWyAgICAxLjY2MTU1MV0gcG5wIDAwOjBhOiBbaW8gIDB4MDA2Nl0KWyAgICAxLjY2
MTU1N10gcG5wIDAwOjBhOiBbaXJxIDFdClsgICAgMS42NjE1OTldIHBucCAwMDowYTogUGx1
ZyBhbmQgUGxheSBBQ1BJIGRldmljZSwgSURzIFBOUDAzMDMgKGFjdGl2ZSkKWyAgICAxLjY2
MTc5MF0gcG5wIDAwOjBiOiBbbWVtIDB4ZmVkMWMwMDAtMHhmZWQxZmZmZl0KWyAgICAxLjY2
MTc5Ml0gcG5wIDAwOjBiOiBbbWVtIDB4ZmVkMTAwMDAtMHhmZWQxN2ZmZl0KWyAgICAxLjY2
MTc5NF0gcG5wIDAwOjBiOiBbbWVtIDB4ZmVkMTgwMDAtMHhmZWQxOGZmZl0KWyAgICAxLjY2
MTc5NV0gcG5wIDAwOjBiOiBbbWVtIDB4ZmVkMTkwMDAtMHhmZWQxOWZmZl0KWyAgICAxLjY2
MTc5N10gcG5wIDAwOjBiOiBbbWVtIDB4ZjgwMDAwMDAtMHhmYmZmZmZmZl0KWyAgICAxLjY2
MTc5OF0gcG5wIDAwOjBiOiBbbWVtIDB4ZmVkMjAwMDAtMHhmZWQzZmZmZl0KWyAgICAxLjY2
MTc5OV0gcG5wIDAwOjBiOiBbbWVtIDB4ZmVkOTAwMDAtMHhmZWQ5M2ZmZl0KWyAgICAxLjY2
MTgwMV0gcG5wIDAwOjBiOiBbbWVtIDB4ZmVkNDUwMDAtMHhmZWQ4ZmZmZl0KWyAgICAxLjY2
MTgwMl0gcG5wIDAwOjBiOiBbbWVtIDB4ZmYwMDAwMDAtMHhmZmZmZmZmZl0KWyAgICAxLjY2
MTgwNF0gcG5wIDAwOjBiOiBbbWVtIDB4ZmVlMDAwMDAtMHhmZWVmZmZmZl0KWyAgICAxLjY2
MTgwNV0gcG5wIDAwOjBiOiBbbWVtIDB4ZGZhMDAwMDAtMHhkZmEwMGZmZl0KWyAgICAxLjY2
MTg3Ml0gc3lzdGVtIDAwOjBiOiBbbWVtIDB4ZmVkMWMwMDAtMHhmZWQxZmZmZl0gaGFzIGJl
ZW4gcmVzZXJ2ZWQKWyAgICAxLjY2MTk3MF0gc3lzdGVtIDAwOjBiOiBbbWVtIDB4ZmVkMTAw
MDAtMHhmZWQxN2ZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAxLjY2MjA2N10gc3lzdGVt
IDAwOjBiOiBbbWVtIDB4ZmVkMTgwMDAtMHhmZWQxOGZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQK
WyAgICAxLjY2MjE2NF0gc3lzdGVtIDAwOjBiOiBbbWVtIDB4ZmVkMTkwMDAtMHhmZWQxOWZm
Zl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAxLjY2MjI2Ml0gc3lzdGVtIDAwOjBiOiBbbWVt
IDB4ZjgwMDAwMDAtMHhmYmZmZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAxLjY2MjM1
OV0gc3lzdGVtIDAwOjBiOiBbbWVtIDB4ZmVkMjAwMDAtMHhmZWQzZmZmZl0gaGFzIGJlZW4g
cmVzZXJ2ZWQKWyAgICAxLjY2MjQ1OF0gc3lzdGVtIDAwOjBiOiBbbWVtIDB4ZmVkOTAwMDAt
MHhmZWQ5M2ZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAxLjY2MjU1NV0gc3lzdGVtIDAw
OjBiOiBbbWVtIDB4ZmVkNDUwMDAtMHhmZWQ4ZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAg
ICAxLjY2MjY1Ml0gc3lzdGVtIDAwOjBiOiBbbWVtIDB4ZmYwMDAwMDAtMHhmZmZmZmZmZl0g
aGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAxLjY2Mjc0OF0gc3lzdGVtIDAwOjBiOiBbbWVtIDB4
ZmVlMDAwMDAtMHhmZWVmZmZmZl0gY291bGQgbm90IGJlIHJlc2VydmVkClsgICAgMS42NjI4
NDVdIHN5c3RlbSAwMDowYjogW21lbSAweGRmYTAwMDAwLTB4ZGZhMDBmZmZdIGhhcyBiZWVu
IHJlc2VydmVkClsgICAgMS42NjI5NDJdIHN5c3RlbSAwMDowYjogUGx1ZyBhbmQgUGxheSBB
Q1BJIGRldmljZSwgSURzIFBOUDBjMDIgKGFjdGl2ZSkKWyAgICAxLjY2MzAwMV0gcG5wIDAw
OjBjOiBbaXJxIDIwXQpbICAgIDEuNjYzMDU3XSBwbnAgMDA6MGM6IFBsdWcgYW5kIFBsYXkg
QUNQSSBkZXZpY2UsIElEcyBTTU84ODAwIChhY3RpdmUpClsgICAgMS42NjMxNjddIHBucCAw
MDowZDogW21lbSAweDIwMDAwMDAwLTB4MjAxZmZmZmZdClsgICAgMS42NjMxNjldIHBucCAw
MDowZDogW21lbSAweDQwMDAwMDAwLTB4NDAxZmZmZmZdClsgICAgMS42NjMyMzhdIHN5c3Rl
bSAwMDowZDogW21lbSAweDIwMDAwMDAwLTB4MjAxZmZmZmZdIGhhcyBiZWVuIHJlc2VydmVk
ClsgICAgMS42NjMzMzZdIHN5c3RlbSAwMDowZDogW21lbSAweDQwMDAwMDAwLTB4NDAxZmZm
ZmZdIGhhcyBiZWVuIHJlc2VydmVkClsgICAgMS42NjM0MzNdIHN5c3RlbSAwMDowZDogUGx1
ZyBhbmQgUGxheSBBQ1BJIGRldmljZSwgSURzIFBOUDBjMDEgKGFjdGl2ZSkKWyAgICAxLjY2
MzQ3Nl0gcG5wOiBQblAgQUNQSTogZm91bmQgMTQgZGV2aWNlcwpbICAgIDEuNjYzNTY4XSBB
Q1BJOiBBQ1BJIGJ1cyB0eXBlIHBucCB1bnJlZ2lzdGVyZWQKWyAgICAxLjY3MTUzMF0gcGNp
IDAwMDA6MDA6MWMuMDogUENJIGJyaWRnZSB0byBbYnVzIDAzLTA0XQpbICAgIDEuNjcxNjM1
XSBwY2kgMDAwMDowMDoxYy4xOiBQQ0kgYnJpZGdlIHRvIFtidXMgMDUtMDZdClsgICAgMS42
NzE3MzFdIHBjaSAwMDAwOjAwOjFjLjE6ICAgYnJpZGdlIHdpbmRvdyBbaW8gIDB4ZTAwMC0w
eGVmZmZdClsgICAgMS42NzE4MzJdIHBjaSAwMDAwOjAwOjFjLjE6ICAgYnJpZGdlIHdpbmRv
dyBbbWVtIDB4ZjExMDAwMDAtMHhmMTFmZmZmZiA2NGJpdCBwcmVmXQpbICAgIDEuNjcxOTgx
XSBwY2kgMDAwMDowMDoxYy4zOiBQQ0kgYnJpZGdlIHRvIFtidXMgMDktMGFdClsgICAgMS42
NzIwNzhdIHBjaSAwMDAwOjAwOjFjLjM6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZjdlMDAw
MDAtMHhmN2VmZmZmZl0KWyAgICAxLjY3MjE4MV0gcGNpIDAwMDA6MDA6MWMuNDogUENJIGJy
aWRnZSB0byBbYnVzIDBiLTBjXQpbICAgIDEuNjcyMjgwXSBwY2kgMDAwMDowMDoxYy40OiAg
IGJyaWRnZSB3aW5kb3cgW21lbSAweGY3ZDAwMDAwLTB4ZjdkZmZmZmZdClsgICAgMS42NzIz
OTBdIHBjaSAwMDAwOjAwOjFjLjc6IFBDSSBicmlkZ2UgdG8gW2J1cyAxMS0xNl0KWyAgICAx
LjY3MjQ4NF0gcGNpIDAwMDA6MDA6MWMuNzogICBicmlkZ2Ugd2luZG93IFtpbyAgMHhjMDAw
LTB4ZGZmZl0KWyAgICAxLjY3MjU4NV0gcGNpIDAwMDA6MDA6MWMuNzogICBicmlkZ2Ugd2lu
ZG93IFttZW0gMHhmNmMwMDAwMC0weGY3Y2ZmZmZmXQpbICAgIDEuNjcyNjg1XSBwY2kgMDAw
MDowMDoxYy43OiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGYwMDAwMDAwLTB4ZjEwZmZmZmYg
NjRiaXQgcHJlZl0KWyAgICAxLjY3NDE5Nl0gcGNpX2J1cyAwMDAwOjAwOiByZXNvdXJjZSA0
IFtpbyAgMHgwMDAwLTB4MGNmN10KWyAgICAxLjY3NDE5OF0gcGNpX2J1cyAwMDAwOjAwOiBy
ZXNvdXJjZSA1IFtpbyAgMHgwZDAwLTB4ZmZmZl0KWyAgICAxLjY3NDE5OV0gcGNpX2J1cyAw
MDAwOjAwOiByZXNvdXJjZSA2IFttZW0gMHgwMDBhMDAwMC0weDAwMGJmZmZmXQpbICAgIDEu
Njc0MjAxXSBwY2lfYnVzIDAwMDA6MDA6IHJlc291cmNlIDcgW21lbSAweDAwMGQwMDAwLTB4
MDAwZDNmZmZdClsgICAgMS42NzQyMDJdIHBjaV9idXMgMDAwMDowMDogcmVzb3VyY2UgOCBb
bWVtIDB4MDAwZDQwMDAtMHgwMDBkN2ZmZl0KWyAgICAxLjY3NDIwNF0gcGNpX2J1cyAwMDAw
OjAwOiByZXNvdXJjZSA5IFttZW0gMHgwMDBkODAwMC0weDAwMGRiZmZmXQpbICAgIDEuNjc0
MjA2XSBwY2lfYnVzIDAwMDA6MDA6IHJlc291cmNlIDEwIFttZW0gMHgwMDBkYzAwMC0weDAw
MGRmZmZmXQpbICAgIDEuNjc0MjA3XSBwY2lfYnVzIDAwMDA6MDA6IHJlc291cmNlIDExIFtt
ZW0gMHgwMDBlMDAwMC0weDAwMGUzZmZmXQpbICAgIDEuNjc0MjA5XSBwY2lfYnVzIDAwMDA6
MDA6IHJlc291cmNlIDEyIFttZW0gMHgwMDBlNDAwMC0weDAwMGU3ZmZmXQpbICAgIDEuNjc0
MjEwXSBwY2lfYnVzIDAwMDA6MDA6IHJlc291cmNlIDEzIFttZW0gMHhkZmEwMDAwMC0weGZl
YWZmZmZmXQpbICAgIDEuNjc0MjEyXSBwY2lfYnVzIDAwMDA6MDA6IHJlc291cmNlIDE0IFtt
ZW0gMHhmZWQ0MDAwMC0weGZlZDQ0ZmZmXQpbICAgIDEuNjc0MjE0XSBwY2lfYnVzIDAwMDA6
MDU6IHJlc291cmNlIDAgW2lvICAweGUwMDAtMHhlZmZmXQpbICAgIDEuNjc0MjE1XSBwY2lf
YnVzIDAwMDA6MDU6IHJlc291cmNlIDIgW21lbSAweGYxMTAwMDAwLTB4ZjExZmZmZmYgNjRi
aXQgcHJlZl0KWyAgICAxLjY3NDIxN10gcGNpX2J1cyAwMDAwOjA5OiByZXNvdXJjZSAxIFtt
ZW0gMHhmN2UwMDAwMC0weGY3ZWZmZmZmXQpbICAgIDEuNjc0MjE5XSBwY2lfYnVzIDAwMDA6
MGI6IHJlc291cmNlIDEgW21lbSAweGY3ZDAwMDAwLTB4ZjdkZmZmZmZdClsgICAgMS42NzQy
MjBdIHBjaV9idXMgMDAwMDoxMTogcmVzb3VyY2UgMCBbaW8gIDB4YzAwMC0weGRmZmZdClsg
ICAgMS42NzQyMjJdIHBjaV9idXMgMDAwMDoxMTogcmVzb3VyY2UgMSBbbWVtIDB4ZjZjMDAw
MDAtMHhmN2NmZmZmZl0KWyAgICAxLjY3NDIyM10gcGNpX2J1cyAwMDAwOjExOiByZXNvdXJj
ZSAyIFttZW0gMHhmMDAwMDAwMC0weGYxMGZmZmZmIDY0Yml0IHByZWZdClsgICAgMS42NzQy
OTRdIE5FVDogUmVnaXN0ZXJlZCBwcm90b2NvbCBmYW1pbHkgMgpbICAgIDEuNjc0NjUxXSBJ
UCByb3V0ZSBjYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDUyNDI4OCAob3JkZXI6IDEwLCA0
MTk0MzA0IGJ5dGVzKQpbICAgIDEuNjc1NjQwXSBUQ1AgZXN0YWJsaXNoZWQgaGFzaCB0YWJs
ZSBlbnRyaWVzOiA1MjQyODggKG9yZGVyOiAxMSwgODM4ODYwOCBieXRlcykKWyAgICAxLjY3
Njg2MF0gVENQIGJpbmQgaGFzaCB0YWJsZSBlbnRyaWVzOiA2NTUzNiAob3JkZXI6IDgsIDEw
NDg1NzYgYnl0ZXMpClsgICAgMS42NzcwODJdIFRDUDogSGFzaCB0YWJsZXMgY29uZmlndXJl
ZCAoZXN0YWJsaXNoZWQgNTI0Mjg4IGJpbmQgNjU1MzYpClsgICAgMS42NzcxNzldIFRDUDog
cmVubyByZWdpc3RlcmVkClsgICAgMS42NzcyODddIFVEUCBoYXNoIHRhYmxlIGVudHJpZXM6
IDgxOTIgKG9yZGVyOiA2LCAyNjIxNDQgYnl0ZXMpClsgICAgMS42Nzc0MzRdIFVEUC1MaXRl
IGhhc2ggdGFibGUgZW50cmllczogODE5MiAob3JkZXI6IDYsIDI2MjE0NCBieXRlcykKWyAg
ICAxLjY3NzYzNV0gTkVUOiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAxClsgICAgMS42
Nzc3NDBdIHBjaSAwMDAwOjAwOjAyLjA6IEJvb3QgdmlkZW8gZGV2aWNlClsgICAgMS45MTkw
MTldIFBDSTogQ0xTIDY0IGJ5dGVzLCBkZWZhdWx0IDY0ClsgICAgMS45MTkwNzhdIERNQVI6
IE5vIEFUU1IgZm91bmQKWyAgICAxLjkxOTE5Ml0gSU9NTVUgMCAweGZlZDkwMDAwOiB1c2lu
ZyBRdWV1ZWQgaW52YWxpZGF0aW9uClsgICAgMS45MTkyODddIElPTU1VIDEgMHhmZWQ5MTAw
MDogdXNpbmcgUXVldWVkIGludmFsaWRhdGlvbgpbICAgIDEuOTE5MzgzXSBJT01NVTogU2V0
dGluZyBSTVJSOgpbICAgIDEuOTE5NDgzXSBJT01NVTogU2V0dGluZyBpZGVudGl0eSBtYXAg
Zm9yIGRldmljZSAwMDAwOjAwOjAyLjAgWzB4ZGI4MDAwMDAgLSAweGRmOWZmZmZmXQpbICAg
IDEuOTE5OTgzXSBJT01NVTogU2V0dGluZyBpZGVudGl0eSBtYXAgZm9yIGRldmljZSAwMDAw
OjAwOjFkLjAgWzB4ZGFkNTMwMDAgLSAweGRhZDYxZmZmXQpbICAgIDEuOTIwMTQ4XSBJT01N
VTogU2V0dGluZyBpZGVudGl0eSBtYXAgZm9yIGRldmljZSAwMDAwOjAwOjFhLjAgWzB4ZGFk
NTMwMDAgLSAweGRhZDYxZmZmXQpbICAgIDEuOTIwMzAyXSBJT01NVTogUHJlcGFyZSAwLTE2
TWlCIHVuaXR5IG1hcHBpbmcgZm9yIExQQwpbICAgIDEuOTIwNDAzXSBJT01NVTogU2V0dGlu
ZyBpZGVudGl0eSBtYXAgZm9yIGRldmljZSAwMDAwOjAwOjFmLjAgWzB4MCAtIDB4ZmZmZmZm
XQpbICAgIDEuOTIwODM4XSBQQ0ktRE1BOiBJbnRlbChSKSBWaXJ0dWFsaXphdGlvbiBUZWNo
bm9sb2d5IGZvciBEaXJlY3RlZCBJL08KWyAgICAxLjkyMzY0NF0gbWljcm9jb2RlOiBDUFUw
IHNpZz0weDIwNmE3LCBwZj0weDEwLCByZXZpc2lvbj0weDFiClsgICAgMS45MjM3NDddIG1p
Y3JvY29kZTogQ1BVMSBzaWc9MHgyMDZhNywgcGY9MHgxMCwgcmV2aXNpb249MHgxYgpbICAg
IDEuOTIzODUyXSBtaWNyb2NvZGU6IENQVTIgc2lnPTB4MjA2YTcsIHBmPTB4MTAsIHJldmlz
aW9uPTB4MWIKWyAgICAxLjkyMzk1MV0gbWljcm9jb2RlOiBDUFUzIHNpZz0weDIwNmE3LCBw
Zj0weDEwLCByZXZpc2lvbj0weDFiClsgICAgMS45MjQwOTZdIG1pY3JvY29kZTogTWljcm9j
b2RlIFVwZGF0ZSBEcml2ZXI6IHYyLjAwIDx0aWdyYW5AYWl2YXppYW4uZnNuZXQuY28udWs+
LCBQZXRlciBPcnViYQpbICAgIDEuOTI1MzI3XSBzaGExX3Nzc2UzOiBVc2luZyBBVlggb3B0
aW1pemVkIFNIQS0xIGltcGxlbWVudGF0aW9uClsgICAgMS45MjY1NTZdIEh1Z2VUTEIgcmVn
aXN0ZXJlZCAyIE1CIHBhZ2Ugc2l6ZSwgcHJlLWFsbG9jYXRlZCAwIHBhZ2VzClsgICAgMS45
Mjg0NTNdIERMTSBpbnN0YWxsZWQKWyAgICAxLjkyODY4Ml0gbXNnbW5pIGhhcyBiZWVuIHNl
dCB0byAzMjEwNQpbICAgIDEuOTI5OTUxXSBORVQ6IFJlZ2lzdGVyZWQgcHJvdG9jb2wgZmFt
aWx5IDM4ClsgICAgMS45MzAwNDRdIGFzeW5jX3R4OiBhcGkgaW5pdGlhbGl6ZWQgKGFzeW5j
KQpbICAgIDEuOTMwMTc2XSBCbG9jayBsYXllciBTQ1NJIGdlbmVyaWMgKGJzZykgZHJpdmVy
IHZlcnNpb24gMC40IGxvYWRlZCAobWFqb3IgMjUyKQpbICAgIDEuOTMwMzIyXSBpbyBzY2hl
ZHVsZXIgbm9vcCByZWdpc3RlcmVkClsgICAgMS45MzA0MTRdIGlvIHNjaGVkdWxlciBkZWFk
bGluZSByZWdpc3RlcmVkClsgICAgMS45MzA1MjNdIGlvIHNjaGVkdWxlciBjZnEgcmVnaXN0
ZXJlZCAoZGVmYXVsdCkKWyAgICAxLjkzMDk1N10gcGNpZXBvcnQgMDAwMDowMDoxYy43OiBp
cnEgNDIgZm9yIE1TSS9NU0ktWApbICAgIDEuOTMxMTY3XSBwY2lfaG90cGx1ZzogUENJIEhv
dCBQbHVnIFBDSSBDb3JlIHZlcnNpb246IDAuNQpbICAgIDEuOTMxMzQ3XSBwY2llaHAgMDAw
MDowMDoxYy43OnBjaWUwNDogSG90cGx1ZyBDb250cm9sbGVyOgpbICAgIDEuOTMxNDQyXSBw
Y2llaHAgMDAwMDowMDoxYy43OnBjaWUwNDogICBTZWcvQnVzL0Rldi9GdW5jL0lSUSA6IDAw
MDA6MDA6MWMuNyBJUlEgNDIKWyAgICAxLjkzMTU4N10gcGNpZWhwIDAwMDA6MDA6MWMuNzpw
Y2llMDQ6ICAgVmVuZG9yIElEICAgICAgICAgICAgOiAweDgwODYKWyAgICAxLjkzMTY4M10g
cGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6ICAgRGV2aWNlIElEICAgICAgICAgICAgOiAw
eDFjMWUKWyAgICAxLjkzMTc4MF0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6ICAgU3Vi
c3lzdGVtIElEICAgICAgICAgOiAweDA0YjMKWyAgICAxLjkzMTg3Nl0gcGNpZWhwIDAwMDA6
MDA6MWMuNzpwY2llMDQ6ICAgU3Vic3lzdGVtIFZlbmRvciBJRCAgOiAweDEwMjgKWyAgICAx
LjkzMTk3M10gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6ICAgUENJZSBDYXAgb2Zmc2V0
ICAgICAgOiAweDQwClsgICAgMS45MzIwNzBdIHBjaWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0
OiAgIFBDSSByZXNvdXJjZSBbMTNdICAgICA6IFtpbyAgMHhjMDAwLTB4ZGZmZl0KWyAgICAx
LjkzMjIxNl0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6ICAgUENJIHJlc291cmNlIFsx
NF0gICAgIDogW21lbSAweGY2YzAwMDAwLTB4ZjdjZmZmZmZdClsgICAgMS45MzIzNjNdIHBj
aWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiAgIFBDSSByZXNvdXJjZSBbMTVdICAgICA6IFtt
ZW0gMHhmMDAwMDAwMC0weGYxMGZmZmZmIDY0Yml0IHByZWZdClsgICAgMS45MzI1MTBdIHBj
aWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBTbG90IENhcGFiaWxpdGllcyAgICAgIDogMHgw
MDNjYjI2MApbICAgIDEuOTMyNjA4XSBwY2llaHAgMDAwMDowMDoxYy43OnBjaWUwNDogICBQ
aHlzaWNhbCBTbG90IE51bWJlciA6IDcKWyAgICAxLjkzMjcwNF0gcGNpZWhwIDAwMDA6MDA6
MWMuNzpwY2llMDQ6ICAgQXR0ZW50aW9uIEJ1dHRvbiAgICAgOiAgbm8KWyAgICAxLjkzMjgw
MF0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6ICAgUG93ZXIgQ29udHJvbGxlciAgICAg
OiAgbm8KWyAgICAxLjkzMjg5Nl0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6ICAgTVJM
IFNlbnNvciAgICAgICAgICAgOiAgbm8KWyAgICAxLjkzMjk5MV0gcGNpZWhwIDAwMDA6MDA6
MWMuNzpwY2llMDQ6ICAgQXR0ZW50aW9uIEluZGljYXRvciAgOiAgbm8KWyAgICAxLjkzMzA4
N10gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6ICAgUG93ZXIgSW5kaWNhdG9yICAgICAg
OiAgbm8KWyAgICAxLjkzMzE4NF0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6ICAgSG90
LVBsdWcgU3VycHJpc2UgICAgOiB5ZXMKWyAgICAxLjkzMzI4MV0gcGNpZWhwIDAwMDA6MDA6
MWMuNzpwY2llMDQ6ICAgRU1JIFByZXNlbnQgICAgICAgICAgOiAgbm8KWyAgICAxLjkzMzM3
N10gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6ICAgQ29tbWFuZCBDb21wbGV0ZWQgICAg
OiAgbm8KWyAgICAxLjkzMzQ3NF0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6IFNsb3Qg
U3RhdHVzICAgICAgICAgICAgOiAweDAwMDAKWyAgICAxLjkzMzU3M10gcGNpZWhwIDAwMDA6
MDA6MWMuNzpwY2llMDQ6IFNsb3QgQ29udHJvbCAgICAgICAgICAgOiAweDAwMDAKWyAgICAx
LjkzMzY3Ml0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6IExpbmsgQWN0aXZlIFJlcG9y
dGluZyBzdXBwb3J0ZWQKWyAgICAxLjkzMzY4MV0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2ll
MDQ6IEhQQyB2ZW5kb3JfaWQgODA4NiBkZXZpY2VfaWQgMWMxZSBzc192aWQgMTAyOCBzc19k
aWQgNGIzClsgICAgMS45MzM4MzBdIHBjaWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBSZWdp
c3RlcmluZyBkb21haW46YnVzOmRldj0wMDAwOjExOjAwIHN1bj03ClsgICAgMS45MzM4Nzld
IHBjaWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBwY2llaHBfZ2V0X3Bvd2VyX3N0YXR1czog
U0xPVENUUkwgNTggdmFsdWUgcmVhZCAxMDI4ClsgICAgMS45MzM4ODFdIHBjaWVocCAwMDAw
OjAwOjFjLjc6cGNpZTA0OiBzZXJ2aWNlIGRyaXZlciBwY2llaHAgbG9hZGVkClsgICAgMS45
MzM5MDZdIHBjaWVocDogcGNpZV9wb3J0X3NlcnZpY2VfcmVnaXN0ZXIgPSAwClsgICAgMS45
MzM5MDddIHBjaWVocDogUENJIEV4cHJlc3MgSG90IFBsdWcgQ29udHJvbGxlciBEcml2ZXIg
dmVyc2lvbjogMC40ClsgICAgMS45MzQwMDVdIGFjcGlwaHA6IEFDUEkgSG90IFBsdWcgUENJ
IENvbnRyb2xsZXIgRHJpdmVyIHZlcnNpb246IDAuNQpbICAgIDEuOTM0NDI3XSBpbnRlbF9p
ZGxlOiBNV0FJVCBzdWJzdGF0ZXM6IDB4MjExMjAKWyAgICAxLjkzNDQyOF0gaW50ZWxfaWRs
ZTogdjAuNCBtb2RlbCAweDJBClsgICAgMS45MzQ0MzBdIGludGVsX2lkbGU6IGxhcGljX3Rp
bWVyX3JlbGlhYmxlX3N0YXRlcyAweGZmZmZmZmZmClsgICAgMS45MzQ1MzVdIEFDUEk6IEFD
IEFkYXB0ZXIgW0FDXSAob24tbGluZSkKWyAgICAxLjkzNDczOV0gaW5wdXQ6IExpZCBTd2l0
Y2ggYXMgL2RldmljZXMvTE5YU1lTVE06MDAvZGV2aWNlOjAwL1BOUDBDMEQ6MDAvaW5wdXQv
aW5wdXQwClsgICAgMS45MzYzNDBdIEFDUEk6IExpZCBTd2l0Y2ggW0xJRDBdClsgICAgMS45
MzY0OTBdIGlucHV0OiBQb3dlciBCdXR0b24gYXMgL2RldmljZXMvTE5YU1lTVE06MDAvZGV2
aWNlOjAwL1BOUDBDMEM6MDAvaW5wdXQvaW5wdXQxClsgICAgMS45MzY2MzhdIEFDUEk6IFBv
d2VyIEJ1dHRvbiBbUFdSQl0KWyAgICAxLjkzNjc4OF0gaW5wdXQ6IFNsZWVwIEJ1dHRvbiBh
cyAvZGV2aWNlcy9MTlhTWVNUTTowMC9kZXZpY2U6MDAvUE5QMEMwRTowMC9pbnB1dC9pbnB1
dDIKWyAgICAxLjkzNjkzNl0gQUNQSTogU2xlZXAgQnV0dG9uIFtTQlROXQpbICAgIDEuOTM3
MDgzXSBpbnB1dDogUG93ZXIgQnV0dG9uIGFzIC9kZXZpY2VzL0xOWFNZU1RNOjAwL0xOWFBX
UkJOOjAwL2lucHV0L2lucHV0MwpbICAgIDEuOTM3MjI3XSBBQ1BJOiBQb3dlciBCdXR0b24g
W1BXUkZdClsgICAgMS45Mzc1NzldIEFDUEk6IFJlcXVlc3RpbmcgYWNwaV9jcHVmcmVxClsg
ICAgMS45NDc3NzRdIHRoZXJtYWwgTE5YVEhFUk06MDA6IHJlZ2lzdGVyZWQgYXMgdGhlcm1h
bF96b25lMApbICAgIDEuOTQ3ODcwXSBBQ1BJOiBUaGVybWFsIFpvbmUgW1RITV0gKDY3IEMp
ClsgICAgMS45NDgwNjhdIEdIRVM6IEhFU1QgaXMgbm90IGVuYWJsZWQhClsgICAgMS45Njg5
MjJdIFNlcmlhbDogODI1MC8xNjU1MCBkcml2ZXIsIDQgcG9ydHMsIElSUSBzaGFyaW5nIGRp
c2FibGVkClsgICAgMS45Njk5MjhdIE5vbi12b2xhdGlsZSBtZW1vcnkgZHJpdmVyIHYxLjMK
WyAgICAxLjk3MDM1MV0gaThrOiB1bmFibGUgdG8gZ2V0IFNNTSBCSU9TIHZlcnNpb24KWyAg
ICAxLjk3MzM5NV0gRGVsbCBsYXB0b3AgU01NIGRyaXZlciB2MS4xNCAyMS8wMi8yMDA1IE1h
c3NpbW8gRGFsIFpvdHRvIChkekBkZWJpYW4ub3JnKQpbICAgIDEuOTczNjM5XSBMaW51eCBh
Z3BnYXJ0IGludGVyZmFjZSB2MC4xMDMKWyAgICAxLjk3MzY2MF0gQUNQSTogQmF0dGVyeSBT
bG90IFtCQVQwXSAoYmF0dGVyeSBwcmVzZW50KQpbICAgIDEuOTczODkyXSBhZ3BnYXJ0LWlu
dGVsIDAwMDA6MDA6MDAuMDogSW50ZWwgU2FuZHlicmlkZ2UgQ2hpcHNldApbICAgIDEuOTc0
MDY4XSBhZ3BnYXJ0LWludGVsIDAwMDA6MDA6MDAuMDogZGV0ZWN0ZWQgZ3R0IHNpemU6IDIw
OTcxNTJLIHRvdGFsLCAyNjIxNDRLIG1hcHBhYmxlClsgICAgMS45NzUyNTldIGFncGdhcnQt
aW50ZWwgMDAwMDowMDowMC4wOiBkZXRlY3RlZCA2NTUzNksgc3RvbGVuIG1lbW9yeQpbICAg
IDEuOTc1NTA0XSBhZ3BnYXJ0LWludGVsIDAwMDA6MDA6MDAuMDogQUdQIGFwZXJ0dXJlIGlz
IDI1Nk0gQCAweGUwMDAwMDAwClsgICAgMS45NzU2NzJdIGlwbWkgbWVzc2FnZSBoYW5kbGVy
IHZlcnNpb24gMzkuMgpbICAgIDEuOTc1NzcyXSBIYW5nY2hlY2s6IHN0YXJ0aW5nIGhhbmdj
aGVjayB0aW1lciAwLjkuMSAodGljayBpcyAxODAgc2Vjb25kcywgbWFyZ2luIGlzIDYwIHNl
Y29uZHMpLgpbICAgIDEuOTc1OTE5XSBIYW5nY2hlY2s6IFVzaW5nIGdldHJhd21vbm90b25p
YygpLgpbICAgIDEuOTc2MDUwXSBbZHJtXSBJbml0aWFsaXplZCBkcm0gMS4xLjAgMjAwNjA4
MTAKWyAgICAxLjk3NjM4M10gaTkxNSAwMDAwOjAwOjAyLjA6IHNldHRpbmcgbGF0ZW5jeSB0
aW1lciB0byA2NApbICAgIDIuMDEyNjU5XSBtdHJyOiB0eXBlIG1pc21hdGNoIGZvciBlMDAw
MDAwMCwxMDAwMDAwMCBvbGQ6IHdyaXRlLWJhY2sgbmV3OiB3cml0ZS1jb21iaW5pbmcKWyAg
ICAyLjAxMjgwNV0gW2RybV0gTVRSUiBhbGxvY2F0aW9uIGZhaWxlZC4gIEdyYXBoaWNzIHBl
cmZvcm1hbmNlIG1heSBzdWZmZXIuClsgICAgMi4wMTMyMzBdIGk5MTUgMDAwMDowMDowMi4w
OiBpcnEgNDMgZm9yIE1TSS9NU0ktWApbICAgIDIuMDEzMjM4XSBbZHJtXSBTdXBwb3J0cyB2
YmxhbmsgdGltZXN0YW1wIGNhY2hpbmcgUmV2IDEgKDEwLjEwLjIwMTApLgpbICAgIDIuMDEz
MzM0XSBbZHJtXSBEcml2ZXIgc3VwcG9ydHMgcHJlY2lzZSB2YmxhbmsgdGltZXN0YW1wIHF1
ZXJ5LgpbICAgIDIuMDEzNDU3XSB2Z2FhcmI6IGRldmljZSBjaGFuZ2VkIGRlY29kZXM6IFBD
STowMDAwOjAwOjAyLjAsb2xkZGVjb2Rlcz1pbyttZW0sZGVjb2Rlcz1pbyttZW06b3ducz1p
byttZW0KWyAgICAyLjA5MDYxMV0gW2RybV0gRW5hYmxpbmcgUkM2IHN0YXRlczogUkM2IG9u
LCBSQzZwIG9mZiwgUkM2cHAgb2ZmClsgICAgMi42NDQ5MzVdIGZiY29uOiBpbnRlbGRybWZi
IChmYjApIGlzIHByaW1hcnkgZGV2aWNlClsgICAgMi45MTczNzddIFJlZmluZWQgVFNDIGNs
b2Nrc291cmNlIGNhbGlicmF0aW9uOiAyNzkzLjY1NiBNSHouClsgICAgMi45MTczODVdIFN3
aXRjaGluZyB0byBjbG9ja3NvdXJjZSB0c2MKWyAgICAzLjE0NjIzOF0gQ29uc29sZTogc3dp
dGNoaW5nIHRvIGNvbG91ciBmcmFtZSBidWZmZXIgZGV2aWNlIDE3MHg0OApbICAgIDMuMTQ5
MDA4XSBmYjA6IGludGVsZHJtZmIgZnJhbWUgYnVmZmVyIGRldmljZQpbICAgIDMuMTQ5MDA5
XSBkcm06IHJlZ2lzdGVyZWQgcGFuaWMgbm90aWZpZXIKWyAgICAzLjE1MDI2NF0gYWNwaSBk
ZXZpY2U6MzQ6IHJlZ2lzdGVyZWQgYXMgY29vbGluZ19kZXZpY2U0ClsgICAgMy4xNTA1MDVd
IGlucHV0OiBWaWRlbyBCdXMgYXMgL2RldmljZXMvTE5YU1lTVE06MDAvZGV2aWNlOjAwL1BO
UDBBMDg6MDAvTE5YVklERU86MDAvaW5wdXQvaW5wdXQ0ClsgICAgMy4xNTA1NDldIEFDUEk6
IFZpZGVvIERldmljZSBbR0ZYMF0gKG11bHRpLWhlYWQ6IHllcyAgcm9tOiBubyAgcG9zdDog
bm8pClsgICAgMy4xNTA2MTJdIFtkcm1dIEluaXRpYWxpemVkIGk5MTUgMS42LjAgMjAwODA3
MzAgZm9yIDAwMDA6MDA6MDIuMCBvbiBtaW5vciAwClsgICAgMy4xNTE0NTNdIGxvb3A6IG1v
ZHVsZSBsb2FkZWQKWyAgICAzLjE1MTU4OF0gYWhjaSAwMDAwOjAwOjFmLjI6IHZlcnNpb24g
My4wClsgICAgMy4xNTE2MzddIGFoY2kgMDAwMDowMDoxZi4yOiBpcnEgNDQgZm9yIE1TSS9N
U0ktWApbICAgIDMuMTUxNjYzXSBhaGNpOiBTU1MgZmxhZyBzZXQsIHBhcmFsbGVsIGJ1cyBz
Y2FuIGRpc2FibGVkClsgICAgMy4xNjcwMjFdIGFoY2kgMDAwMDowMDoxZi4yOiBBSENJIDAw
MDEuMDMwMCAzMiBzbG90cyA2IHBvcnRzIDYgR2JwcyAweDMxIGltcGwgU0FUQSBtb2RlClsg
ICAgMy4xNjcxMzFdIGFoY2kgMDAwMDowMDoxZi4yOiBmbGFnczogNjRiaXQgbmNxIHNudGYg
c3RhZyBwbSBsZWQgY2xvIHBpbyBzbHVtIHBhcnQgZW1zIHN4cyBhcHN0IApbICAgIDMuMTY3
MTcyXSBhaGNpIDAwMDA6MDA6MWYuMjogc2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0Clsg
ICAgMy4yMDc3MTZdIHNjc2kwIDogYWhjaQpbICAgIDMuMjA3ODI4XSBzY3NpMSA6IGFoY2kK
WyAgICAzLjIwNzkxOV0gc2NzaTIgOiBhaGNpClsgICAgMy4yMDgwMTFdIHNjc2kzIDogYWhj
aQpbICAgIDMuMjA4MDk5XSBzY3NpNCA6IGFoY2kKWyAgICAzLjIwODE5MV0gc2NzaTUgOiBh
aGNpClsgICAgMy4yMDk0NzFdIGF0YTE6IFNBVEEgbWF4IFVETUEvMTMzIGFiYXIgbTIwNDhA
MHhmN2YwNjAwMCBwb3J0IDB4ZjdmMDYxMDAgaXJxIDQ0ClsgICAgMy4yMTA0NTBdIGF0YTI6
IERVTU1ZClsgICAgMy4yMTE0MTVdIGF0YTM6IERVTU1ZClsgICAgMy4yMTIzNjRdIGF0YTQ6
IERVTU1ZClsgICAgMy4yMTMzMDZdIGF0YTU6IFNBVEEgbWF4IFVETUEvMTMzIGFiYXIgbTIw
NDhAMHhmN2YwNjAwMCBwb3J0IDB4ZjdmMDYzMDAgaXJxIDQ0ClsgICAgMy4yMTQyNzJdIGF0
YTY6IFNBVEEgbWF4IFVETUEvMTMzIGFiYXIgbTIwNDhAMHhmN2YwNjAwMCBwb3J0IDB4Zjdm
MDYzODAgaXJxIDQ0ClsgICAgMy4yMTUzNThdIHR1bjogVW5pdmVyc2FsIFRVTi9UQVAgZGV2
aWNlIGRyaXZlciwgMS42ClsgICAgMy4yMTYzMDBdIHR1bjogKEMpIDE5OTktMjAwNCBNYXgg
S3Jhc255YW5za3kgPG1heGtAcXVhbGNvbW0uY29tPgpbICAgIDMuMjE3MzE5XSByODE2OSBH
aWdhYml0IEV0aGVybmV0IGRyaXZlciAyLjNMSy1OQVBJIGxvYWRlZApbICAgIDMuMjE4Mzgy
XSByODE2OSAwMDAwOjA1OjAwLjA6IGlycSA0NSBmb3IgTVNJL01TSS1YClsgICAgMy4yMTg1
MzldIHI4MTY5IDAwMDA6MDU6MDAuMDogZXRoMDogUlRMODE2OGUvODExMWUgYXQgMHhmZmZm
YzkwMDA2NWQyMDAwLCAxODowMzo3MzphMDo2Zjo2YSwgWElEIDBjMjAwMDAwIElSUSA0NQpb
ICAgIDMuMjE5NTE2XSByODE2OSAwMDAwOjA1OjAwLjA6IGV0aDA6IGp1bWJvIGZlYXR1cmVz
IFtmcmFtZXM6IDkyMDAgYnl0ZXMsIHR4IGNoZWNrc3VtbWluZzoga29dClsgICAgMy4yMjA1
MDZdIFZNd2FyZSB2bXhuZXQzIHZpcnR1YWwgTklDIGRyaXZlciAtIHZlcnNpb24gMS4xLjI5
LjAtay1OQVBJClsgICAgMy4yMjE1MThdIGVoY2lfaGNkOiBVU0IgMi4wICdFbmhhbmNlZCcg
SG9zdCBDb250cm9sbGVyIChFSENJKSBEcml2ZXIKWyAgICAzLjIyMjQ5Ml0gZWhjaV9oY2Qg
MDAwMDowMDoxYS4wOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQKWyAgICAzLjIyMjQ5
NV0gZWhjaV9oY2QgMDAwMDowMDoxYS4wOiBFSENJIEhvc3QgQ29udHJvbGxlcgpbICAgIDMu
MjIzNDQzXSBlaGNpX2hjZCAwMDAwOjAwOjFhLjA6IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQs
IGFzc2lnbmVkIGJ1cyBudW1iZXIgMQpbICAgIDMuMjI0NDIzXSBlaGNpX2hjZCAwMDAwOjAw
OjFhLjA6IGRlYnVnIHBvcnQgMgpbICAgIDMuMjI5MjQzXSBlaGNpX2hjZCAwMDAwOjAwOjFh
LjA6IGNhY2hlIGxpbmUgc2l6ZSBvZiA2NCBpcyBub3Qgc3VwcG9ydGVkClsgICAgMy4yMjky
NTZdIGVoY2lfaGNkIDAwMDA6MDA6MWEuMDogaXJxIDE2LCBpbyBtZW0gMHhmN2YwODAwMApb
ICAgIDMuMjQ2ODc5XSBlaGNpX2hjZCAwMDAwOjAwOjFhLjA6IFVTQiAyLjAgc3RhcnRlZCwg
RUhDSSAxLjAwClsgICAgMy4yNDc5MDhdIHVzYiB1c2IxOiBOZXcgVVNCIGRldmljZSBmb3Vu
ZCwgaWRWZW5kb3I9MWQ2YiwgaWRQcm9kdWN0PTAwMDIKWyAgICAzLjI0ODgzOV0gdXNiIHVz
YjE6IE5ldyBVU0IgZGV2aWNlIHN0cmluZ3M6IE1mcj0zLCBQcm9kdWN0PTIsIFNlcmlhbE51
bWJlcj0xClsgICAgMy4yNDk3NzNdIHVzYiB1c2IxOiBQcm9kdWN0OiBFSENJIEhvc3QgQ29u
dHJvbGxlcgpbICAgIDMuMjUwNzAxXSB1c2IgdXNiMTogTWFudWZhY3R1cmVyOiBMaW51eCAz
LjQuMC1yYzMtZGVmYXVsdCBlaGNpX2hjZApbICAgIDMuMjUxNjM0XSB1c2IgdXNiMTogU2Vy
aWFsTnVtYmVyOiAwMDAwOjAwOjFhLjAKWyAgICAzLjI1MjcwNV0gaHViIDEtMDoxLjA6IFVT
QiBodWIgZm91bmQKWyAgICAzLjI1MzY1M10gaHViIDEtMDoxLjA6IDIgcG9ydHMgZGV0ZWN0
ZWQKWyAgICAzLjI1NDY0NF0gZWhjaV9oY2QgMDAwMDowMDoxZC4wOiBzZXR0aW5nIGxhdGVu
Y3kgdGltZXIgdG8gNjQKWyAgICAzLjI1NDY0OF0gZWhjaV9oY2QgMDAwMDowMDoxZC4wOiBF
SENJIEhvc3QgQ29udHJvbGxlcgpbICAgIDMuMjU1NTc2XSBlaGNpX2hjZCAwMDAwOjAwOjFk
LjA6IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIgMgpbICAg
IDMuMjU2NTI5XSBlaGNpX2hjZCAwMDAwOjAwOjFkLjA6IGRlYnVnIHBvcnQgMgpbICAgIDMu
MjYxMzMzXSBlaGNpX2hjZCAwMDAwOjAwOjFkLjA6IGNhY2hlIGxpbmUgc2l6ZSBvZiA2NCBp
cyBub3Qgc3VwcG9ydGVkClsgICAgMy4yNjEzNDRdIGVoY2lfaGNkIDAwMDA6MDA6MWQuMDog
aXJxIDIzLCBpbyBtZW0gMHhmN2YwNzAwMApbICAgIDMuMjc2ODMzXSBlaGNpX2hjZCAwMDAw
OjAwOjFkLjA6IFVTQiAyLjAgc3RhcnRlZCwgRUhDSSAxLjAwClsgICAgMy4yNzc4NDJdIHVz
YiB1c2IyOiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRWZW5kb3I9MWQ2YiwgaWRQcm9kdWN0
PTAwMDIKWyAgICAzLjI3ODc1MF0gdXNiIHVzYjI6IE5ldyBVU0IgZGV2aWNlIHN0cmluZ3M6
IE1mcj0zLCBQcm9kdWN0PTIsIFNlcmlhbE51bWJlcj0xClsgICAgMy4yNzk2NTRdIHVzYiB1
c2IyOiBQcm9kdWN0OiBFSENJIEhvc3QgQ29udHJvbGxlcgpbICAgIDMuMjgwNTQ5XSB1c2Ig
dXNiMjogTWFudWZhY3R1cmVyOiBMaW51eCAzLjQuMC1yYzMtZGVmYXVsdCBlaGNpX2hjZApb
ICAgIDMuMjgxNDUzXSB1c2IgdXNiMjogU2VyaWFsTnVtYmVyOiAwMDAwOjAwOjFkLjAKWyAg
ICAzLjI4MjQ0N10gaHViIDItMDoxLjA6IFVTQiBodWIgZm91bmQKWyAgICAzLjI4MzMzMl0g
aHViIDItMDoxLjA6IDIgcG9ydHMgZGV0ZWN0ZWQKWyAgICAzLjI4NDI1NF0gb2hjaV9oY2Q6
IFVTQiAxLjEgJ09wZW4nIEhvc3QgQ29udHJvbGxlciAoT0hDSSkgRHJpdmVyClsgICAgMy4y
ODUyMDZdIHhoY2lfaGNkIDAwMDA6MGI6MDAuMDogeEhDSSBIb3N0IENvbnRyb2xsZXIKWyAg
ICAzLjI4NjEwN10geGhjaV9oY2QgMDAwMDowYjowMC4wOiBuZXcgVVNCIGJ1cyByZWdpc3Rl
cmVkLCBhc3NpZ25lZCBidXMgbnVtYmVyIDMKWyAgICAzLjI4NzIxNF0geGhjaV9oY2QgMDAw
MDowYjowMC4wOiBpcnEgMTYsIGlvIG1lbSAweGY3ZDAwMDAwClsgICAgMy4yODgyMDldIHho
Y2lfaGNkIDAwMDA6MGI6MDAuMDogaXJxIDQ2IGZvciBNU0kvTVNJLVgKWyAgICAzLjI4ODIx
NF0geGhjaV9oY2QgMDAwMDowYjowMC4wOiBpcnEgNDcgZm9yIE1TSS9NU0ktWApbICAgIDMu
Mjg4MjE4XSB4aGNpX2hjZCAwMDAwOjBiOjAwLjA6IGlycSA0OCBmb3IgTVNJL01TSS1YClsg
ICAgMy4yODgyMjJdIHhoY2lfaGNkIDAwMDA6MGI6MDAuMDogaXJxIDQ5IGZvciBNU0kvTVNJ
LVgKWyAgICAzLjI4ODIyNl0geGhjaV9oY2QgMDAwMDowYjowMC4wOiBpcnEgNTAgZm9yIE1T
SS9NU0ktWApbICAgIDMuMjg4MzIwXSB1c2IgdXNiMzogTmV3IFVTQiBkZXZpY2UgZm91bmQs
IGlkVmVuZG9yPTFkNmIsIGlkUHJvZHVjdD0wMDAyClsgICAgMy4yODkyNTldIHVzYiB1c2Iz
OiBOZXcgVVNCIGRldmljZSBzdHJpbmdzOiBNZnI9MywgUHJvZHVjdD0yLCBTZXJpYWxOdW1i
ZXI9MQpbICAgIDMuMjkwMTk0XSB1c2IgdXNiMzogUHJvZHVjdDogeEhDSSBIb3N0IENvbnRy
b2xsZXIKWyAgICAzLjI5MTExOF0gdXNiIHVzYjM6IE1hbnVmYWN0dXJlcjogTGludXggMy40
LjAtcmMzLWRlZmF1bHQgeGhjaV9oY2QKWyAgICAzLjI5MjA1OV0gdXNiIHVzYjM6IFNlcmlh
bE51bWJlcjogMDAwMDowYjowMC4wClsgICAgMy4yOTMwNzZdIHhIQ0kgeGhjaV9hZGRfZW5k
cG9pbnQgY2FsbGVkIGZvciByb290IGh1YgpbICAgIDMuMjkzMDc4XSB4SENJIHhoY2lfY2hl
Y2tfYmFuZHdpZHRoIGNhbGxlZCBmb3Igcm9vdCBodWIKWyAgICAzLjI5MzExMl0gaHViIDMt
MDoxLjA6IFVTQiBodWIgZm91bmQKWyAgICAzLjI5NDA1Nl0gaHViIDMtMDoxLjA6IDIgcG9y
dHMgZGV0ZWN0ZWQKWyAgICAzLjI5NTA0Ml0geGhjaV9oY2QgMDAwMDowYjowMC4wOiB4SENJ
IEhvc3QgQ29udHJvbGxlcgpbICAgIDMuMjk1OTc4XSB4aGNpX2hjZCAwMDAwOjBiOjAwLjA6
IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIgNApbICAgIDMu
Mjk2OTQzXSB1c2IgdXNiNDogTmV3IFVTQiBkZXZpY2UgZm91bmQsIGlkVmVuZG9yPTFkNmIs
IGlkUHJvZHVjdD0wMDAzClsgICAgMy4yOTc4NzddIHVzYiB1c2I0OiBOZXcgVVNCIGRldmlj
ZSBzdHJpbmdzOiBNZnI9MywgUHJvZHVjdD0yLCBTZXJpYWxOdW1iZXI9MQpbICAgIDMuMjk4
Nzk4XSB1c2IgdXNiNDogUHJvZHVjdDogeEhDSSBIb3N0IENvbnRyb2xsZXIKWyAgICAzLjI5
OTcwOV0gdXNiIHVzYjQ6IE1hbnVmYWN0dXJlcjogTGludXggMy40LjAtcmMzLWRlZmF1bHQg
eGhjaV9oY2QKWyAgICAzLjMwMDYwOV0gdXNiIHVzYjQ6IFNlcmlhbE51bWJlcjogMDAwMDow
YjowMC4wClsgICAgMy4zMDE1NjJdIHhIQ0kgeGhjaV9hZGRfZW5kcG9pbnQgY2FsbGVkIGZv
ciByb290IGh1YgpbICAgIDMuMzAxNTY0XSB4SENJIHhoY2lfY2hlY2tfYmFuZHdpZHRoIGNh
bGxlZCBmb3Igcm9vdCBodWIKWyAgICAzLjMwMTU5OF0gaHViIDQtMDoxLjA6IFVTQiBodWIg
Zm91bmQKWyAgICAzLjMwMjQ5MF0gaHViIDQtMDoxLjA6IDIgcG9ydHMgZGV0ZWN0ZWQKWyAg
ICAzLjMwMzQ3M10gdXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciB1
YXMKWyAgICAzLjMwNDQyN10gaTgwNDI6IFBOUDogUFMvMiBDb250cm9sbGVyIFtQTlAwMzAz
OktCQyxQTlAwZjEzOlBTMl0gYXQgMHg2MCwweDY0IGlycSAxLDEyClsgICAgMy4zMDc2MjZd
IHNlcmlvOiBpODA0MiBLQkQgcG9ydCBhdCAweDYwLDB4NjQgaXJxIDEKWyAgICAzLjMwODU0
NV0gc2VyaW86IGk4MDQyIEFVWCBwb3J0IGF0IDB4NjAsMHg2NCBpcnEgMTIKWyAgICAzLjMw
OTU2Ml0gbW91c2VkZXY6IFBTLzIgbW91c2UgZGV2aWNlIGNvbW1vbiBmb3IgYWxsIG1pY2UK
WyAgICAzLjMxMDcyNl0gcnRjX2Ntb3MgMDA6MDU6IFJUQyBjYW4gd2FrZSBmcm9tIFM0Clsg
ICAgMy4zMTE3NTJdIHJ0Y19jbW9zIDAwOjA1OiBydGMgY29yZTogcmVnaXN0ZXJlZCBydGNf
Y21vcyBhcyBydGMwClsgICAgMy4zMTI2NzddIHJ0YzA6IGFsYXJtcyB1cCB0byBvbmUgbW9u
dGgsIHkzaywgMjQyIGJ5dGVzIG52cmFtLCBocGV0IGlycXMKWyAgICAzLjMxMzYwMl0gaTJj
IC9kZXYgZW50cmllcyBkcml2ZXIKWyAgICAzLjMxNDg4MV0gZ3NwY2FfbWFpbjogdjIuMTQu
MCByZWdpc3RlcmVkClsgICAgMy4zMTU4MTZdIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGlu
dGVyZmFjZSBkcml2ZXIgdXZjdmlkZW8KWyAgICAzLjMxNjczNl0gVVNCIFZpZGVvIENsYXNz
IGRyaXZlciAoMS4xLjEpClsgICAgMy4zMTc3NTBdIGNvcmV0ZW1wIGNvcmV0ZW1wLjA6IFRq
TWF4IGlzIDEwMCBkZWdyZWVzIEMKWyAgICAzLjMxNzc2MF0gY29yZXRlbXAgY29yZXRlbXAu
MDogVGpNYXggaXMgMTAwIGRlZ3JlZXMgQwpbICAgIDMuMzE3NzcwXSBjb3JldGVtcCBjb3Jl
dGVtcC4wOiBUak1heCBpcyAxMDAgZGVncmVlcyBDClsgICAgMy4zMTc3OThdIGlUQ09fd2R0
OiBJbnRlbCBUQ08gV2F0Y2hEb2cgVGltZXIgRHJpdmVyIHYxLjA3ClsgICAgMy4zMTg3OTNd
IGlUQ09fd2R0OiBGb3VuZCBhIENvdWdhciBQb2ludCBUQ08gZGV2aWNlIChWZXJzaW9uPTIs
IFRDT0JBU0U9MHgwNDYwKQpbICAgIDMuMzE5Nzg4XSBpVENPX3dkdDogaW5pdGlhbGl6ZWQu
IGhlYXJ0YmVhdD0zMCBzZWMgKG5vd2F5b3V0PTApClsgICAgMy4zMjA3MzRdIGlUQ09fdmVu
ZG9yX3N1cHBvcnQ6IHZlbmRvci1zdXBwb3J0PTAKWyAgICAzLjMyMTY5MF0gbWQ6IGxpbmVh
ciBwZXJzb25hbGl0eSByZWdpc3RlcmVkIGZvciBsZXZlbCAtMQpbICAgIDMuMzIyNjE3XSBt
ZDogcmFpZDAgcGVyc29uYWxpdHkgcmVnaXN0ZXJlZCBmb3IgbGV2ZWwgMApbICAgIDMuMzIz
NTQ2XSBtZDogcmFpZDEgcGVyc29uYWxpdHkgcmVnaXN0ZXJlZCBmb3IgbGV2ZWwgMQpbICAg
IDMuMzI0NDY0XSBtZDogcmFpZDEwIHBlcnNvbmFsaXR5IHJlZ2lzdGVyZWQgZm9yIGxldmVs
IDEwClsgICAgMy4zMjQ5NDFdIGlucHV0OiBBVCBUcmFuc2xhdGVkIFNldCAyIGtleWJvYXJk
IGFzIC9kZXZpY2VzL3BsYXRmb3JtL2k4MDQyL3NlcmlvMC9pbnB1dC9pbnB1dDUKWyAgICAz
LjMyNjMzMl0gbWQ6IHJhaWQ2IHBlcnNvbmFsaXR5IHJlZ2lzdGVyZWQgZm9yIGxldmVsIDYK
WyAgICAzLjMyNzI5OF0gbWQ6IHJhaWQ1IHBlcnNvbmFsaXR5IHJlZ2lzdGVyZWQgZm9yIGxl
dmVsIDUKWyAgICAzLjMyODIzOF0gbWQ6IHJhaWQ0IHBlcnNvbmFsaXR5IHJlZ2lzdGVyZWQg
Zm9yIGxldmVsIDQKWyAgICAzLjMyOTE5MF0gZGV2aWNlLW1hcHBlcjogdWV2ZW50OiB2ZXJz
aW9uIDEuMC4zClsgICAgMy4zMzAxNjRdIGRldmljZS1tYXBwZXI6IGlvY3RsOiA0LjIyLjAt
aW9jdGwgKDIwMTEtMTAtMTkpIGluaXRpYWxpc2VkOiBkbS1kZXZlbEByZWRoYXQuY29tClsg
ICAgMy4zMzExNTNdIGRldmljZS1tYXBwZXI6IGRtLWxvZy11c2Vyc3BhY2U6IHZlcnNpb24g
MS4xLjAgbG9hZGVkClsgICAgMy4zMzIxMDldIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGlu
dGVyZmFjZSBkcml2ZXIgYnR1c2IKWyAgICAzLjMzMzExOV0gY3B1aWRsZTogdXNpbmcgZ292
ZXJub3IgbGFkZGVyClsgICAgMy4zMzQxMzddIGNwdWlkbGU6IHVzaW5nIGdvdmVybm9yIG1l
bnUKWyAgICAzLjMzNTIwMV0gc2RoY2k6IFNlY3VyZSBEaWdpdGFsIEhvc3QgQ29udHJvbGxl
ciBJbnRlcmZhY2UgZHJpdmVyClsgICAgMy4zMzYxMzFdIHNkaGNpOiBDb3B5cmlnaHQoYykg
UGllcnJlIE9zc21hbgpbICAgIDMuMzM3ODIzXSBkY2RiYXMgZGNkYmFzOiBEZWxsIFN5c3Rl
bXMgTWFuYWdlbWVudCBCYXNlIERyaXZlciAodmVyc2lvbiA1LjYuMC0zLjIpClsgICAgMy4z
Mzk0MzZdIHVzYmNvcmU6IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgdXNiaGlk
ClsgICAgMy4zNDAzODRdIHVzYmhpZDogVVNCIEhJRCBjb3JlIGRyaXZlcgpbICAgIDMuMzQx
MzgwXSBtZWkgMDAwMDowMDoxNi4wOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQKWyAg
ICAzLjM0MTQyOF0gbWVpIDAwMDA6MDA6MTYuMDogaXJxIDUxIGZvciBNU0kvTVNJLVgKWyAg
ICAzLjM2NTkxOF0gaW5wdXQ6IERlbGwgV01JIGhvdGtleXMgYXMgL2RldmljZXMvdmlydHVh
bC9pbnB1dC9pbnB1dDYKWyAgICAzLjM3ODAxMF0gaW50ZWxfb2FrdHJhaWw6IFBsYXRmb3Jt
IG5vdCByZWNvZ25pemVkIChZb3UgY291bGQgdHJ5IHRoZSBtb2R1bGUncyBmb3JjZS1wYXJh
bWV0ZXIpClsgICAgMy4zNzgxNjZdIHNuZF9oZGFfaW50ZWwgMDAwMDowMDoxYi4wOiBpcnEg
NTIgZm9yIE1TSS9NU0ktWApbICAgIDMuNTU2NDk3XSBhdGExOiBTQVRBIGxpbmsgdXAgMy4w
IEdicHMgKFNTdGF0dXMgMTIzIFNDb250cm9sIDMwMCkKWyAgICAzLjU2MzYyOF0gYXRhMS4w
MDogQUNQSSBjbWQgMDAvMDA6MDA6MDA6MDA6MDA6YTAgKE5PUCkgcmVqZWN0ZWQgYnkgZGV2
aWNlIChTdGF0PTB4NTEgRXJyPTB4MDQpClsgICAgMy41NjUwMjFdIGF0YTEuMDA6IEFUQS04
OiBXREMgV0Q3NTAwQlBLVC03NVBLNFQwLCAwMS4wMUEwMSwgbWF4IFVETUEvMTMzClsgICAg
My41NjYwODNdIGF0YTEuMDA6IDE0NjUxNDkxNjggc2VjdG9ycywgbXVsdGkgMTY6IExCQTQ4
IE5DUSAoZGVwdGggMzEvMzIpLCBBQQpbICAgIDMuNTY2NDAxXSB1c2IgMS0xOiBuZXcgaGln
aC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciAyIHVzaW5nIGVoY2lfaGNkClsgICAgMy41NzQx
NDZdIGF0YTEuMDA6IEFDUEkgY21kIDAwLzAwOjAwOjAwOjAwOjAwOmEwIChOT1ApIHJlamVj
dGVkIGJ5IGRldmljZSAoU3RhdD0weDUxIEVycj0weDA0KQpbICAgIDMuNTc1NDk3XSBhdGEx
LjAwOiBjb25maWd1cmVkIGZvciBVRE1BLzEzMwpbICAgIDMuNTc2NzMzXSBzY3NpIDA6MDow
OjA6IERpcmVjdC1BY2Nlc3MgICAgIEFUQSAgICAgIFdEQyBXRDc1MDBCUEtULTcgMDEuMCBQ
UTogMCBBTlNJOiA1ClsgICAgMy41NzgyMzddIHNkIDA6MDowOjA6IFtzZGFdIDE0NjUxNDkx
NjggNTEyLWJ5dGUgbG9naWNhbCBibG9ja3M6ICg3NTAgR0IvNjk4IEdpQikKWyAgICAzLjU3
ODQzMF0gc2QgMDowOjA6MDogQXR0YWNoZWQgc2NzaSBnZW5lcmljIHNnMCB0eXBlIDAKWyAg
ICAzLjU4MDMzNF0gc2QgMDowOjA6MDogW3NkYV0gNDA5Ni1ieXRlIHBoeXNpY2FsIGJsb2Nr
cwpbICAgIDMuNTgxNDU5XSBzZCAwOjA6MDowOiBbc2RhXSBXcml0ZSBQcm90ZWN0IGlzIG9m
ZgpbICAgIDMuNTgyNDc4XSBzZCAwOjA6MDowOiBbc2RhXSBNb2RlIFNlbnNlOiAwMCAzYSAw
MCAwMApbICAgIDMuNTgyNTU5XSBzZCAwOjA6MDowOiBbc2RhXSBXcml0ZSBjYWNoZTogZW5h
YmxlZCwgcmVhZCBjYWNoZTogZW5hYmxlZCwgZG9lc24ndCBzdXBwb3J0IERQTyBvciBGVUEK
WyAgICAzLjY4NDM1Nl0gIHNkYTogc2RhMSBzZGEyIHNkYTMgc2RhNCA8IHNkYTUgc2RhNiA+
ClsgICAgMy42ODYxNDZdIHNkIDA6MDowOjA6IFtzZGFdIEF0dGFjaGVkIFNDU0kgZGlzawpb
ICAgIDMuNzE2Nzg0XSB1c2IgMS0xOiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRWZW5kb3I9
ODA4NywgaWRQcm9kdWN0PTAwMjQKWyAgICAzLjcxNzg3M10gdXNiIDEtMTogTmV3IFVTQiBk
ZXZpY2Ugc3RyaW5nczogTWZyPTAsIFByb2R1Y3Q9MCwgU2VyaWFsTnVtYmVyPTAKWyAgICAz
LjcxOTUyM10gaHViIDEtMToxLjA6IFVTQiBodWIgZm91bmQKWyAgICAzLjcyMDY4Nl0gaHVi
IDEtMToxLjA6IDYgcG9ydHMgZGV0ZWN0ZWQKWyAgICAzLjgzNjEwNV0gdXNiIDItMTogbmV3
IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgMiB1c2luZyBlaGNpX2hjZApbICAgIDMu
OTI1ODgyXSBhdGE1OiBTQVRBIGxpbmsgdXAgMS41IEdicHMgKFNTdGF0dXMgMTEzIFNDb250
cm9sIDMwMCkKWyAgICAzLjkzMDMyOF0gYXRhNS4wMDogQVRBUEk6IFBMRFMgRFZEKy8tUlcg
RFMtOEE4U0gsIEtEMTEsIG1heCBVRE1BLzEwMApbICAgIDMuOTM2ODAwXSBhdGE1LjAwOiBj
b25maWd1cmVkIGZvciBVRE1BLzEwMApbICAgIDMuOTUwNDA5XSBzY3NpIDQ6MDowOjA6IENE
LVJPTSAgICAgICAgICAgIFBMRFMgICAgIERWRCstUlcgRFMtOEE4U0ggS0QxMSBQUTogMCBB
TlNJOiA1ClsgICAgMy45NjUyMTldIHNyMDogc2NzaTMtbW1jIGRyaXZlOiAyNHgvMjR4IHdy
aXRlciBkdmQtcmFtIGNkL3J3IHhhL2Zvcm0yIGNkZGEgdHJheQpbICAgIDMuOTY2MzA4XSBj
ZHJvbTogVW5pZm9ybSBDRC1ST00gZHJpdmVyIFJldmlzaW9uOiAzLjIwClsgICAgMy45Njc3
MTBdIHNyIDQ6MDowOjA6IEF0dGFjaGVkIHNjc2kgQ0QtUk9NIHNyMApbICAgIDMuOTY3OTY5
XSBzciA0OjA6MDowOiBBdHRhY2hlZCBzY3NpIGdlbmVyaWMgc2cxIHR5cGUgNQpbICAgIDMu
OTg2NDI3XSB1c2IgMi0xOiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRWZW5kb3I9ODA4Nywg
aWRQcm9kdWN0PTAwMjQKWyAgICAzLjk4NzU0OV0gdXNiIDItMTogTmV3IFVTQiBkZXZpY2Ug
c3RyaW5nczogTWZyPTAsIFByb2R1Y3Q9MCwgU2VyaWFsTnVtYmVyPTAKWyAgICAzLjk4OTA5
Ml0gaHViIDItMToxLjA6IFVTQiBodWIgZm91bmQKWyAgICAzLjk5MDI4M10gaHViIDItMTox
LjA6IDggcG9ydHMgZGV0ZWN0ZWQKWyAgICAzLjk5NzI3Ml0gaW5wdXQ6IEhEQSBEaWdpdGFs
IFBDQmVlcCBhcyAvZGV2aWNlcy9wY2kwMDAwOjAwLzAwMDA6MDA6MWIuMC9pbnB1dC9pbnB1
dDcKWyAgICA0LjAyNDU3MF0gaW5wdXQ6IEhEQSBJbnRlbCBQQ0ggSERNSS9EUCxwY209MyBh
cyAvZGV2aWNlcy9wY2kwMDAwOjAwLzAwMDA6MDA6MWIuMC9zb3VuZC9jYXJkMC9pbnB1dDgK
WyAgICA0LjAyNjEzMV0gaW5wdXQ6IEhEQSBJbnRlbCBQQ0ggTWljIGFzIC9kZXZpY2VzL3Bj
aTAwMDA6MDAvMDAwMDowMDoxYi4wL3NvdW5kL2NhcmQwL2lucHV0OQpbICAgIDQuMDI3Njky
XSBpbnB1dDogSERBIEludGVsIFBDSCBIZWFkcGhvbmUgYXMgL2RldmljZXMvcGNpMDAwMDow
MC8wMDAwOjAwOjFiLjAvc291bmQvY2FyZDAvaW5wdXQxMApbICAgIDQuMDI5NjU5XSBBTFNB
IGRldmljZSBsaXN0OgpbICAgIDQuMDMwNzQ4XSAgICMwOiBIREEgSW50ZWwgUENIIGF0IDB4
ZjdmMDAwMDAgaXJxIDUyClsgICAgNC4wMzE5MTZdIFRDUDogY3ViaWMgcmVnaXN0ZXJlZApb
ICAgIDQuMDMzMDAxXSBORVQ6IFJlZ2lzdGVyZWQgcHJvdG9jb2wgZmFtaWx5IDE3ClsgICAg
NC4wMzQxMjBdIEJsdWV0b290aDogUkZDT01NIFRUWSBsYXllciBpbml0aWFsaXplZApbICAg
IDQuMDM1MjAzXSBCbHVldG9vdGg6IFJGQ09NTSBzb2NrZXQgbGF5ZXIgaW5pdGlhbGl6ZWQK
WyAgICA0LjAzNjI3OF0gQmx1ZXRvb3RoOiBSRkNPTU0gdmVyIDEuMTEKWyAgICA0LjAzNzMz
MF0gQmx1ZXRvb3RoOiBCTkVQIChFdGhlcm5ldCBFbXVsYXRpb24pIHZlciAxLjMKWyAgICA0
LjAzODM3MF0gQmx1ZXRvb3RoOiBCTkVQIGZpbHRlcnM6IHByb3RvY29sIG11bHRpY2FzdApb
ICAgIDQuMDM5Mzk1XSBCbHVldG9vdGg6IEhJRFAgKEh1bWFuIEludGVyZmFjZSBFbXVsYXRp
b24pIHZlciAxLjIKWyAgICA0LjA0MDcyMV0gc2N0cDogSGFzaCB0YWJsZXMgY29uZmlndXJl
ZCAoZXN0YWJsaXNoZWQgNjU1MzYgYmluZCA2NTUzNikKWyAgICA0LjA0MTg2NF0gUmVnaXN0
ZXJpbmcgdGhlIGRuc19yZXNvbHZlciBrZXkgdHlwZQpbICAgIDQuMDQzMjE1XSBQTTogQ2hl
Y2tpbmcgaGliZXJuYXRpb24gaW1hZ2UgcGFydGl0aW9uIC9kZXYvc2RhNgpbICAgIDQuMDQz
MjIwXSBQTTogSGliZXJuYXRpb24gaW1hZ2UgcGFydGl0aW9uIDg6NiBwcmVzZW50ClsgICAg
NC4wNDMyMjFdIFBNOiBMb29raW5nIGZvciBoaWJlcm5hdGlvbiBpbWFnZS4KWyAgICA0LjA5
OTAwNV0gUE06IEltYWdlIG5vdCBmb3VuZCAoY29kZSAtMjIpClsgICAgNC4wOTkwMTNdIFBN
OiBIaWJlcm5hdGlvbiBpbWFnZSBub3QgcHJlc2VudCBvciBjb3VsZCBub3QgYmUgbG9hZGVk
LgpbICAgIDQuMDk5MDQyXSByZWdpc3RlcmVkIHRhc2tzdGF0cyB2ZXJzaW9uIDEKWyAgICA0
LjEwMTE4N10gcnRjX2Ntb3MgMDA6MDU6IHNldHRpbmcgc3lzdGVtIGNsb2NrIHRvIDIwMTIt
MDQtMjAgMTI6NDk6MjcgVVRDICgxMzM0OTI2MTY3KQpbICAgIDQuMTAzMDU3XSBCSU9TIEVE
RCBmYWNpbGl0eSB2MC4xNiAyMDA0LUp1bi0yNSwgMSBkZXZpY2VzIGZvdW5kClsgICAgNC4x
MDU2MDVdIHVzYiAzLTE6IG5ldyBsb3ctc3BlZWQgVVNCIGRldmljZSBudW1iZXIgMiB1c2lu
ZyB4aGNpX2hjZApbICAgIDQuMTU5ODk0XSB1c2IgMy0xOiBOZXcgVVNCIGRldmljZSBmb3Vu
ZCwgaWRWZW5kb3I9MDQ2ZCwgaWRQcm9kdWN0PWMwNTAKWyAgICA0LjE2MDg1MF0gdXNiIDMt
MTogTmV3IFVTQiBkZXZpY2Ugc3RyaW5nczogTWZyPTEsIFByb2R1Y3Q9MiwgU2VyaWFsTnVt
YmVyPTAKWyAgICA0LjE2MTcxOF0gdXNiIDMtMTogUHJvZHVjdDogVVNCLVBTLzIgT3B0aWNh
bCBNb3VzZQpbICAgIDQuMTYyNTY5XSB1c2IgMy0xOiBNYW51ZmFjdHVyZXI6IExvZ2l0ZWNo
ClsgICAgNC4xNjM2NDhdIHVzYiAzLTE6IGVwIDB4ODEgLSByb3VuZGluZyBpbnRlcnZhbCB0
byA2NCBtaWNyb2ZyYW1lcywgZXAgZGVzYyBzYXlzIDgwIG1pY3JvZnJhbWVzClsgICAgNC4x
ODExNTNdIGlucHV0OiBMb2dpdGVjaCBVU0ItUFMvMiBPcHRpY2FsIE1vdXNlIGFzIC9kZXZp
Y2VzL3BjaTAwMDA6MDAvMDAwMDowMDoxYy40LzAwMDA6MGI6MDAuMC91c2IzLzMtMS8zLTE6
MS4wL2lucHV0L2lucHV0MTEKWyAgICA0LjE4MjU1N10gZ2VuZXJpYy11c2IgMDAwMzowNDZE
OkMwNTAuMDAwMTogaW5wdXQsaGlkcmF3MDogVVNCIEhJRCB2MS4xMCBNb3VzZSBbTG9naXRl
Y2ggVVNCLVBTLzIgT3B0aWNhbCBNb3VzZV0gb24gdXNiLTAwMDA6MGI6MDAuMC0xL2lucHV0
MApbICAgIDQuMjU1NDg3XSB1c2IgMS0xLjU6IG5ldyBoaWdoLXNwZWVkIFVTQiBkZXZpY2Ug
bnVtYmVyIDMgdXNpbmcgZWhjaV9oY2QKWyAgICA0LjMxNDI4MF0gaW5wdXQ6IER1YWxQb2lu
dCBTdGljayBhcyAvZGV2aWNlcy9wbGF0Zm9ybS9pODA0Mi9zZXJpbzEvaW5wdXQvaW5wdXQx
MgpbICAgIDQuMzE1Mjg1XSBhdGE2OiBTQVRBIGxpbmsgZG93biAoU1N0YXR1cyAwIFNDb250
cm9sIDMwMCkKWyAgICA0LjMyOTI5N10gaW5wdXQ6IEFscHNQUy8yIEFMUFMgRHVhbFBvaW50
IFRvdWNoUGFkIGFzIC9kZXZpY2VzL3BsYXRmb3JtL2k4MDQyL3NlcmlvMS9pbnB1dC9pbnB1
dDEzClsgICAgNC4zMzM1NDhdIG1kOiBXYWl0aW5nIGZvciBhbGwgZGV2aWNlcyB0byBiZSBh
dmFpbGFibGUgYmVmb3JlIGF1dG9kZXRlY3QKWyAgICA0LjMzNDUyMl0gbWQ6IElmIHlvdSBk
b24ndCB1c2UgcmFpZCwgdXNlIHJhaWQ9bm9hdXRvZGV0ZWN0ClsgICAgNC4zMzU5NjNdIG1k
OiBBdXRvZGV0ZWN0aW5nIFJBSUQgYXJyYXlzLgpbICAgIDQuMzM2OTM5XSBtZDogU2Nhbm5l
ZCAwIGFuZCBhZGRlZCAwIGRldmljZXMuClsgICAgNC4zMzc4ODldIG1kOiBhdXRvcnVuIC4u
LgpbICAgIDQuMzM4ODI1XSBtZDogLi4uIGF1dG9ydW4gRE9ORS4KWyAgICA0LjM3Mjc5MF0g
dXNiIDEtMS41OiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRWZW5kb3I9MDVjYSwgaWRQcm9k
dWN0PTE4MjAKWyAgICA0LjM3MzgxM10gdXNiIDEtMS41OiBOZXcgVVNCIGRldmljZSBzdHJp
bmdzOiBNZnI9MSwgUHJvZHVjdD0yLCBTZXJpYWxOdW1iZXI9MApbICAgIDQuMzc0NzIxXSB1
c2IgMS0xLjU6IFByb2R1Y3Q6IExhcHRvcF9JbnRlZ3JhdGVkX1dlYmNhbV9GSEQKWyAgICA0
LjM3NTYzOV0gdXNiIDEtMS41OiBNYW51ZmFjdHVyZXI6IENOMDFNV005NzI0ODcxQTRLQjI4
QTAwClsgICAgNC4zNzc0MTJdIHV2Y3ZpZGVvOiBGb3VuZCBVVkMgMS4wMCBkZXZpY2UgTGFw
dG9wX0ludGVncmF0ZWRfV2ViY2FtX0ZIRCAoMDVjYToxODIwKQpbICAgIDQuMzgwMTY2XSBp
bnB1dDogTGFwdG9wX0ludGVncmF0ZWRfV2ViY2FtX0ZIRCBhcyAvZGV2aWNlcy9wY2kwMDAw
OjAwLzAwMDA6MDA6MWEuMC91c2IxLzEtMS8xLTEuNS8xLTEuNToxLjAvaW5wdXQvaW5wdXQx
NApbICAgIDQuMzkxNzQxXSBram91cm5hbGQgc3RhcnRpbmcuICBDb21taXQgaW50ZXJ2YWwg
NSBzZWNvbmRzClsgICAgNC4zOTE5ODVdIEVYVDMtZnMgKHNkYTUpOiBtb3VudGVkIGZpbGVz
eXN0ZW0gd2l0aCB3cml0ZWJhY2sgZGF0YSBtb2RlClsgICAgNC4zOTIwMDBdIFZGUzogTW91
bnRlZCByb290IChleHQzIGZpbGVzeXN0ZW0pIHJlYWRvbmx5IG9uIGRldmljZSA4OjUuClsg
ICAgNC40MzI4NTVdIGRldnRtcGZzOiBtb3VudGVkClsgICAgNC40MzM5MTVdIEZyZWVpbmcg
dW51c2VkIGtlcm5lbCBtZW1vcnk6IDU0NGsgZnJlZWQKWyAgICA0LjQ1NTIzM10gdXNiIDIt
MS4yOiBuZXcgbG93LXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDMgdXNpbmcgZWhjaV9oY2QK
WyAgICA0LjU3Mjk5MV0gdXNiIDItMS4yOiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRWZW5k
b3I9MDRmMiwgaWRQcm9kdWN0PTAxMTYKWyAgICA0LjU3NDAyM10gdXNiIDItMS4yOiBOZXcg
VVNCIGRldmljZSBzdHJpbmdzOiBNZnI9MSwgUHJvZHVjdD0yLCBTZXJpYWxOdW1iZXI9MApb
ICAgIDQuNTc0OTU4XSB1c2IgMi0xLjI6IFByb2R1Y3Q6IFVTQiBLZXlib2FyZApbICAgIDQu
NTc1ODc4XSB1c2IgMi0xLjI6IE1hbnVmYWN0dXJlcjogQ0hJQ09OWQpbICAgIDQuNTgyMjM2
XSBpbnB1dDogQ0hJQ09OWSBVU0IgS2V5Ym9hcmQgYXMgL2RldmljZXMvcGNpMDAwMDowMC8w
MDAwOjAwOjFkLjAvdXNiMi8yLTEvMi0xLjIvMi0xLjI6MS4wL2lucHV0L2lucHV0MTUKWyAg
ICA0LjU4MzM0M10gZ2VuZXJpYy11c2IgMDAwMzowNEYyOjAxMTYuMDAwMjogaW5wdXQsaGlk
cmF3MTogVVNCIEhJRCB2MS4xMCBLZXlib2FyZCBbQ0hJQ09OWSBVU0IgS2V5Ym9hcmRdIG9u
IHVzYi0wMDAwOjAwOjFkLjAtMS4yL2lucHV0MApbICAgIDQuNjc1MDY5XSB1c2IgMi0xLjM6
IG5ldyBmdWxsLXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDQgdXNpbmcgZWhjaV9oY2QKWyAg
ICA0Ljc4NjIzN10gdXNiIDItMS4zOiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRWZW5kb3I9
MTM4YSwgaWRQcm9kdWN0PTAwMTEKWyAgICA0Ljc4NzMyMV0gdXNiIDItMS4zOiBOZXcgVVNC
IGRldmljZSBzdHJpbmdzOiBNZnI9MCwgUHJvZHVjdD0wLCBTZXJpYWxOdW1iZXI9MQpbICAg
IDQuNzg4MzIzXSB1c2IgMi0xLjM6IFNlcmlhbE51bWJlcjogNTZlZDU4MjFhZmUyClsgICAg
NC44NjQ1OTFdIHVzYiAyLTEuNjogbmV3IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1iZXIg
NSB1c2luZyBlaGNpX2hjZApbICAgIDUuMjI5MzgxXSB1c2IgMi0xLjY6IE5ldyBVU0IgZGV2
aWNlIGZvdW5kLCBpZFZlbmRvcj0wYmRhLCBpZFByb2R1Y3Q9MDEzOApbICAgIDUuMjMwNDMx
XSB1c2IgMi0xLjY6IE5ldyBVU0IgZGV2aWNlIHN0cmluZ3M6IE1mcj0xLCBQcm9kdWN0PTIs
IFNlcmlhbE51bWJlcj0zClsgICAgNS4yMzE0MzJdIHVzYiAyLTEuNjogUHJvZHVjdDogVVNC
Mi4wLUNSVwpbICAgIDUuMjMyNDIyXSB1c2IgMi0xLjY6IE1hbnVmYWN0dXJlcjogR2VuZXJp
YwpbICAgIDUuMjMzMzg3XSB1c2IgMi0xLjY6IFNlcmlhbE51bWJlcjogMjAwOTA1MTYzODgy
MDAwMDAKWyAgICA3LjQzMDM1N10gdWRldmRbMTc1Nl06IHN0YXJ0aW5nIHZlcnNpb24gMTcx
ClsgICAgOS44ODI3MjhdIEFDUEkgV2FybmluZzogMHgwMDAwMDAwMDAwMDBmMDQwLTB4MDAw
MDAwMDAwMDAwZjA1ZiBTeXN0ZW1JTyBjb25mbGljdHMgd2l0aCBSZWdpb24gXF9TQl8uUENJ
MC5TQlVTLlNNQkkgMSAoMjAxMjAzMjAvdXRhZGRyZXNzLTI1MSkKWyAgICA5Ljg4MjczNF0g
QUNQSTogSWYgYW4gQUNQSSBkcml2ZXIgaXMgYXZhaWxhYmxlIGZvciB0aGlzIGRldmljZSwg
eW91IHNob3VsZCB1c2UgaXQgaW5zdGVhZCBvZiB0aGUgbmF0aXZlIGRyaXZlcgpbICAgMTAu
MzM3MDU2XSBJbml0aWFsaXppbmcgVVNCIE1hc3MgU3RvcmFnZSBkcml2ZXIuLi4KWyAgIDEw
LjMzNzE2NV0gc2NzaTYgOiB1c2Itc3RvcmFnZSAyLTEuNjoxLjAKWyAgIDEwLjMzNzI1MF0g
dXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciB1c2Itc3RvcmFnZQpb
ICAgMTAuMzM3MjUyXSBVU0IgTWFzcyBTdG9yYWdlIHN1cHBvcnQgcmVnaXN0ZXJlZC4KWyAg
IDEwLjg2MDcxN10gSW50ZWwoUikgV2lyZWxlc3MgV2lGaSBMaW5rIEFHTiBkcml2ZXIgZm9y
IExpbnV4LCBpbi10cmVlOmQKWyAgIDEwLjg2MDcxOV0gQ29weXJpZ2h0KGMpIDIwMDMtMjAx
MiBJbnRlbCBDb3Jwb3JhdGlvbgpbICAgMTAuODYwOTA0XSBpd2x3aWZpIDAwMDA6MDk6MDAu
MDogcGNpX3Jlc291cmNlX2xlbiA9IDB4MDAwMDIwMDAKWyAgIDEwLjg2MDkwNl0gaXdsd2lm
aSAwMDAwOjA5OjAwLjA6IHBjaV9yZXNvdXJjZV9iYXNlID0gZmZmZmM5MDAwNjY4NDAwMApb
ICAgMTAuODYwOTA3XSBpd2x3aWZpIDAwMDA6MDk6MDAuMDogSFcgUmV2aXNpb24gSUQgPSAw
eDM0ClsgICAxMC44NjEwMDBdIGl3bHdpZmkgMDAwMDowOTowMC4wOiBpcnEgNTMgZm9yIE1T
SS9NU0ktWApbICAgMTAuOTI4Njc1XSBpd2x3aWZpIDAwMDA6MDk6MDAuMDogbG9hZGVkIGZp
cm13YXJlIHZlcnNpb24gMTcuMTY4LjUuMiBidWlsZCAzNTkwNQpbICAgMTAuOTI4NzcwXSBp
d2x3aWZpIDAwMDA6MDk6MDAuMDogQ09ORklHX0lXTFdJRklfREVCVUcgZW5hYmxlZApbICAg
MTAuOTI4NzcyXSBpd2x3aWZpIDAwMDA6MDk6MDAuMDogQ09ORklHX0lXTFdJRklfREVCVUdG
UyBkaXNhYmxlZApbICAgMTAuOTI4NzczXSBpd2x3aWZpIDAwMDA6MDk6MDAuMDogQ09ORklH
X0lXTFdJRklfREVWSUNFX1RSQUNJTkcgZGlzYWJsZWQKWyAgIDEwLjkyODc3NF0gaXdsd2lm
aSAwMDAwOjA5OjAwLjA6IENPTkZJR19JV0xXSUZJX0RFVklDRV9URVNUTU9ERSBkaXNhYmxl
ZApbICAgMTAuOTI4Nzc1XSBpd2x3aWZpIDAwMDA6MDk6MDAuMDogQ09ORklHX0lXTFdJRklf
UDJQIGRpc2FibGVkClsgICAxMC45Mjg3NzddIGl3bHdpZmkgMDAwMDowOTowMC4wOiBEZXRl
Y3RlZCBJbnRlbChSKSBDZW50cmlubyhSKSBXaXJlbGVzcy1OIDEwMzAgQkdOLCBSRVY9MHhC
MApbICAgMTAuOTI4ODIyXSBpd2x3aWZpIDAwMDA6MDk6MDAuMDogTDEgRGlzYWJsZWQ7IEVu
YWJsaW5nIEwwUwpbICAgMTAuOTQ1OTk1XSBpd2x3aWZpIDAwMDA6MDk6MDAuMDogZGV2aWNl
IEVFUFJPTSBWRVI9MHg3MWEsIENBTElCPTB4NgpbICAgMTAuOTQ1OTk3XSBpd2x3aWZpIDAw
MDA6MDk6MDAuMDogRGV2aWNlIFNLVTogMHgxNTAKWyAgIDEwLjk0NTk5OF0gaXdsd2lmaSAw
MDAwOjA5OjAwLjA6IFZhbGlkIFR4IGFudDogMHgxLCBWYWxpZCBSeCBhbnQ6IDB4MwpbICAg
MTAuOTQ2MDA4XSBpd2x3aWZpIDAwMDA6MDk6MDAuMDogVHVuYWJsZSBjaGFubmVsczogMTMg
ODAyLjExYmcsIDAgODAyLjExYSBjaGFubmVscwpbICAgMTAuOTQ2MTMyXSBSZWdpc3RlcmVk
IGxlZCBkZXZpY2U6IHBoeTAtbGVkClsgICAxMC45NDYxOTFdIGllZWU4MDIxMSBwaHkwOiBT
ZWxlY3RlZCByYXRlIGNvbnRyb2wgYWxnb3JpdGhtICdpd2wtYWduLXJzJwpbICAgMTEuMzM4
MTQyXSBzY3NpIDY6MDowOjA6IERpcmVjdC1BY2Nlc3MgICAgIEdlbmVyaWMtIE11bHRpLUNh
cmQgICAgICAgMS4wMCBQUTogMCBBTlNJOiAwIENDUwpbICAgMTEuMzM4MzI3XSBzZCA2OjA6
MDowOiBBdHRhY2hlZCBzY3NpIGdlbmVyaWMgc2cyIHR5cGUgMApbICAgMTEuMzQ0MTIyXSBz
ZCA2OjA6MDowOiBbc2RiXSBBdHRhY2hlZCBTQ1NJIHJlbW92YWJsZSBkaXNrClsgICAxMi41
OTg3NzZdIEVYVDMtZnMgKHNkYTUpOiB1c2luZyBpbnRlcm5hbCBqb3VybmFsClsgICAxMi44
MjEwOTJdIEFkZGluZyA0OTk4OTcyayBzd2FwIG9uIC9kZXYvc2RhNi4gIFByaW9yaXR5Oi0x
IGV4dGVudHM6MSBhY3Jvc3M6NDk5ODk3MmsgClsgICAxNi4zMjA0ODRdIHI4MTY5IDAwMDA6
MDU6MDAuMDogZXRoMDogdW5hYmxlIHRvIGxvYWQgZmlybXdhcmUgcGF0Y2ggcnRsX25pYy9y
dGw4MTY4ZS0yLmZ3ICgtMikKWyAgIDE2LjM1MTE5OV0gcjgxNjkgMDAwMDowNTowMC4wOiBl
dGgwOiBsaW5rIGRvd24KWyAgIDE2LjM1MTIxNF0gcjgxNjkgMDAwMDowNTowMC4wOiBldGgw
OiBsaW5rIGRvd24KWyAgIDE4LjA3MTQzNV0gcjgxNjkgMDAwMDowNTowMC4wOiBldGgwOiBs
aW5rIHVwClsgICAyMi4xMDIwODNdIG1pY3JvY29kZTogQ1BVMCB1cGRhdGVkIHRvIHJldmlz
aW9uIDB4MjUsIGRhdGUgPSAyMDExLTEwLTExClsgICAyMi4xMDI0MzddIG1pY3JvY29kZTog
Q1BVMSB1cGRhdGVkIHRvIHJldmlzaW9uIDB4MjUsIGRhdGUgPSAyMDExLTEwLTExClsgICAy
Mi4xMDI3NjhdIG1pY3JvY29kZTogQ1BVMiB1cGRhdGVkIHRvIHJldmlzaW9uIDB4MjUsIGRh
dGUgPSAyMDExLTEwLTExClsgICAyMi4xMDMxMTZdIG1pY3JvY29kZTogQ1BVMyB1cGRhdGVk
IHRvIHJldmlzaW9uIDB4MjUsIGRhdGUgPSAyMDExLTEwLTExClsgICAyMi4yNzkzNzJdIFtk
cm1dIENoYW5naW5nIExWRFMgcGFuZWwgZnJvbSAoK2hzeW5jLCAtdnN5bmMpIHRvICgtaHN5
bmMsIC12c3luYykKWyAgIDI0LjE4MjY5NV0gcjgxNjkgMDAwMDowNTowMC4wOiBldGgwOiBs
aW5rIGRvd24KWyAgIDI2LjU2ODEyOF0gcjgxNjkgMDAwMDowNTowMC4wOiBldGgwOiBsaW5r
IHVwClsgICA0My41NTc3MThdIFtkcm1dIENoYW5naW5nIExWRFMgcGFuZWwgZnJvbSAoLWhz
eW5jLCAtdnN5bmMpIHRvICgraHN5bmMsIC12c3luYykKWyAgIDQ1LjY0MjIzM10gYXRhMS4w
MDogY29uZmlndXJlZCBmb3IgVURNQS8xMzMKWyAgIDQ1LjY0MjI0N10gYXRhMTogRUggY29t
cGxldGUKWyAgIDk0LjM1NzIxNV0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6IHBjaWVf
aXNyOiBpbnRyX2xvYyAxMDgKWyAgIDk0LjM1NzIyNV0gcGNpZWhwIDAwMDA6MDA6MWMuNzpw
Y2llMDQ6IExpbmtTdGF0ZSBjaGFuZ2UKWyAgIDk0LjM1NzIyOF0gcGNpZWhwIDAwMDA6MDA6
MWMuNzpwY2llMDQ6IGxua19zdGF0dXMgPSA3MDExClsgICA5NC4zNTcyMjldIHBjaWVocCAw
MDAwOjAwOjFjLjc6cGNpZTA0OiBQcmVzZW5jZS9Ob3RpZnkgaW5wdXQgY2hhbmdlClsgICA5
NC4zNTcyMzJdIHBjaWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBDYXJkIHByZXNlbnQgb24g
U2xvdCg3KQpbICAgOTQuMzU3MjczXSBwY2llaHAgMDAwMDowMDoxYy43OnBjaWUwNDogU3Vy
cHJpc2UgUmVtb3ZhbApbICAgOTQuMzU3Mjg4XSBwY2llaHAgMDAwMDowMDoxYy43OnBjaWUw
NDogY2hlY2tfbGlua19hY3RpdmU6IGxua19zdGF0dXMgPSA3MDExClsgICA5NC40NjExNzNd
IHBjaWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBwY2llaHBfY2hlY2tfbGlua19zdGF0dXM6
IGxua19zdGF0dXMgPSA3MDExClsgICA5NC40NjEyNzRdIHBjaSAwMDAwOjExOjAwLjA6IFsx
MDMzOjAxOTRdIHR5cGUgMDAgY2xhc3MgMHgwYzAzMzAKWyAgIDk0LjQ2MTMyNV0gcGNpIDAw
MDA6MTE6MDAuMDogcmVnIDEwOiBbbWVtIDB4MDAwMDAwMDAtMHgwMDAwMWZmZiA2NGJpdF0K
WyAgIDk0LjQ2MTU2N10gcGNpIDAwMDA6MTE6MDAuMDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBE
MCBEM2hvdApbICAgOTQuNDgxMjEwXSBwY2kgMDAwMDoxMTowMC4wOiBCQVIgMDogYXNzaWdu
ZWQgW21lbSAweGY2YzAwMDAwLTB4ZjZjMDFmZmYgNjRiaXRdClsgICA5NC40ODEyNTVdIHBj
aWVwb3J0IDAwMDA6MDA6MWMuNzogUENJIGJyaWRnZSB0byBbYnVzIDExLTE2XQpbICAgOTQu
NDgxMjU4XSBwY2llcG9ydCAwMDAwOjAwOjFjLjc6ICAgYnJpZGdlIHdpbmRvdyBbaW8gIDB4
YzAwMC0weGRmZmZdClsgICA5NC40ODEyNjNdIHBjaWVwb3J0IDAwMDA6MDA6MWMuNzogICBi
cmlkZ2Ugd2luZG93IFttZW0gMHhmNmMwMDAwMC0weGY3Y2ZmZmZmXQpbICAgOTQuNDgxMjY3
XSBwY2llcG9ydCAwMDAwOjAwOjFjLjc6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZjAwMDAw
MDAtMHhmMTBmZmZmZiA2NGJpdCBwcmVmXQpbICAgOTQuNDgxNDA3XSB4aGNpX2hjZCAwMDAw
OjExOjAwLjA6IGVuYWJsaW5nIGRldmljZSAoMDEwMCAtPiAwMTAyKQpbICAgOTQuNDgxNDYz
XSB4aGNpX2hjZCAwMDAwOjExOjAwLjA6IHhIQ0kgSG9zdCBDb250cm9sbGVyClsgICA5NC40
ODE0NjhdIHhoY2lfaGNkIDAwMDA6MTE6MDAuMDogbmV3IFVTQiBidXMgcmVnaXN0ZXJlZCwg
YXNzaWduZWQgYnVzIG51bWJlciA1ClsgICA5NC40ODE3NjddIHhoY2lfaGNkIDAwMDA6MTE6
MDAuMDogaXJxIDE5LCBpbyBtZW0gMHhmNmMwMDAwMApbICAgOTQuNDgxODcyXSB4aGNpX2hj
ZCAwMDAwOjExOjAwLjA6IGlycSA1NCBmb3IgTVNJL01TSS1YClsgICA5NC40ODE4NzZdIHho
Y2lfaGNkIDAwMDA6MTE6MDAuMDogaXJxIDU1IGZvciBNU0kvTVNJLVgKWyAgIDk0LjQ4MTg3
OV0geGhjaV9oY2QgMDAwMDoxMTowMC4wOiBpcnEgNTYgZm9yIE1TSS9NU0ktWApbICAgOTQu
NDgxODgzXSB4aGNpX2hjZCAwMDAwOjExOjAwLjA6IGlycSA1NyBmb3IgTVNJL01TSS1YClsg
ICA5NC40ODE4ODddIHhoY2lfaGNkIDAwMDA6MTE6MDAuMDogaXJxIDU4IGZvciBNU0kvTVNJ
LVgKWyAgIDk0LjQ4MjAzNl0gdXNiIHVzYjU6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZl
bmRvcj0xZDZiLCBpZFByb2R1Y3Q9MDAwMgpbICAgOTQuNDgyMDM4XSB1c2IgdXNiNTogTmV3
IFVTQiBkZXZpY2Ugc3RyaW5nczogTWZyPTMsIFByb2R1Y3Q9MiwgU2VyaWFsTnVtYmVyPTEK
WyAgIDk0LjQ4MjAzOV0gdXNiIHVzYjU6IFByb2R1Y3Q6IHhIQ0kgSG9zdCBDb250cm9sbGVy
ClsgICA5NC40ODIwNDBdIHVzYiB1c2I1OiBNYW51ZmFjdHVyZXI6IExpbnV4IDMuNC4wLXJj
My1kZWZhdWx0IHhoY2lfaGNkClsgICA5NC40ODIwNDFdIHVzYiB1c2I1OiBTZXJpYWxOdW1i
ZXI6IDAwMDA6MTE6MDAuMApbICAgOTQuNDgyMTY0XSB4SENJIHhoY2lfYWRkX2VuZHBvaW50
IGNhbGxlZCBmb3Igcm9vdCBodWIKWyAgIDk0LjQ4MjE2Nl0geEhDSSB4aGNpX2NoZWNrX2Jh
bmR3aWR0aCBjYWxsZWQgZm9yIHJvb3QgaHViClsgICA5NC40ODIxODhdIGh1YiA1LTA6MS4w
OiBVU0IgaHViIGZvdW5kClsgICA5NC40ODIxOThdIGh1YiA1LTA6MS4wOiAyIHBvcnRzIGRl
dGVjdGVkClsgICA5NC40ODIyNjVdIHhoY2lfaGNkIDAwMDA6MTE6MDAuMDogeEhDSSBIb3N0
IENvbnRyb2xsZXIKWyAgIDk0LjQ4MjI2OF0geGhjaV9oY2QgMDAwMDoxMTowMC4wOiBuZXcg
VVNCIGJ1cyByZWdpc3RlcmVkLCBhc3NpZ25lZCBidXMgbnVtYmVyIDYKWyAgIDk0LjQ4NTAw
NF0gdXNiIHVzYjY6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZlbmRvcj0xZDZiLCBpZFBy
b2R1Y3Q9MDAwMwpbICAgOTQuNDg1MDA3XSB1c2IgdXNiNjogTmV3IFVTQiBkZXZpY2Ugc3Ry
aW5nczogTWZyPTMsIFByb2R1Y3Q9MiwgU2VyaWFsTnVtYmVyPTEKWyAgIDk0LjQ4NTAwOV0g
dXNiIHVzYjY6IFByb2R1Y3Q6IHhIQ0kgSG9zdCBDb250cm9sbGVyClsgICA5NC40ODUwMTFd
IHVzYiB1c2I2OiBNYW51ZmFjdHVyZXI6IExpbnV4IDMuNC4wLXJjMy1kZWZhdWx0IHhoY2lf
aGNkClsgICA5NC40ODUwMTNdIHVzYiB1c2I2OiBTZXJpYWxOdW1iZXI6IDAwMDA6MTE6MDAu
MApbICAgOTQuNDg1MTE1XSB4SENJIHhoY2lfYWRkX2VuZHBvaW50IGNhbGxlZCBmb3Igcm9v
dCBodWIKWyAgIDk0LjQ4NTExN10geEhDSSB4aGNpX2NoZWNrX2JhbmR3aWR0aCBjYWxsZWQg
Zm9yIHJvb3QgaHViClsgICA5NC40ODUxNDhdIGh1YiA2LTA6MS4wOiBVU0IgaHViIGZvdW5k
ClsgICA5NC40ODUxNjddIGh1YiA2LTA6MS4wOiAyIHBvcnRzIGRldGVjdGVkClsgICA5OC43
NTQ4MTNdIHVzYiA1LTE6IG5ldyBoaWdoLXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDIgdXNp
bmcgeGhjaV9oY2QKWyAgIDk4Ljc3ODM5Ml0gdXNiIDUtMTogTmV3IFVTQiBkZXZpY2UgZm91
bmQsIGlkVmVuZG9yPTEzZmQsIGlkUHJvZHVjdD0wNTUwClsgICA5OC43Nzg0MDNdIHVzYiA1
LTE6IE5ldyBVU0IgZGV2aWNlIHN0cmluZ3M6IE1mcj0xLCBQcm9kdWN0PTIsIFNlcmlhbE51
bWJlcj0zClsgICA5OC43Nzg0MDldIHVzYiA1LTE6IFByb2R1Y3Q6IFNUOTE2MDgyMUEgICAg
ICAKWyAgIDk4Ljc3ODQxNV0gdXNiIDUtMTogTWFudWZhY3R1cmVyOiBJbml0aW8gIApbICAg
OTguNzc4NDE5XSB1c2IgNS0xOiBTZXJpYWxOdW1iZXI6IDAwMTAxMDA1NTAwMDExQjgwClsg
ICA5OC43Nzg2MjZdIHVzYiA1LTE6IGVwIDB4ODEgLSByb3VuZGluZyBpbnRlcnZhbCB0byAz
Mjc2OCBtaWNyb2ZyYW1lcywgZXAgZGVzYyBzYXlzIDAgbWljcm9mcmFtZXMKWyAgIDk4Ljc3
ODYzMl0gdXNiIDUtMTogZXAgMHgyIC0gcm91bmRpbmcgaW50ZXJ2YWwgdG8gMzI3NjggbWlj
cm9mcmFtZXMsIGVwIGRlc2Mgc2F5cyAwIG1pY3JvZnJhbWVzClsgICA5OC43NzkzOTldIHNj
c2k3IDogdXNiLXN0b3JhZ2UgNS0xOjEuMApbICAgOTguNzgxNDE2XSBnZW5lcmljLXVzYiAw
MDAzOjEzRkQ6MDU1MC4wMDAzOiBoaWRkZXYwLGhpZHJhdzI6IFVTQiBISUQgdjEuMTAgRGV2
aWNlIFtJbml0aW8gICBTVDkxNjA4MjFBICAgICAgXSBvbiB1c2ItMDAwMDoxMTowMC4wLTEv
aW5wdXQxClsgICA5OS43NzQyNDFdIHNjc2kgNzowOjA6MDogRGlyZWN0LUFjY2VzcyAgICAg
SW5pdGlvICAgU1Q5MTYwODIxQSAgICAgICAzLjEyIFBROiAwIEFOU0k6IDAKWyAgIDk5Ljc3
NDM5Nl0gc2QgNzowOjA6MDogQXR0YWNoZWQgc2NzaSBnZW5lcmljIHNnMyB0eXBlIDAKWyAg
IDk5Ljc3NDYxNV0gc2QgNzowOjA6MDogW3NkY10gMzEyNTgxODA4IDUxMi1ieXRlIGxvZ2lj
YWwgYmxvY2tzOiAoMTYwIEdCLzE0OSBHaUIpClsgICA5OS43NzUyNDFdIHNkIDc6MDowOjA6
IFtzZGNdIFdyaXRlIFByb3RlY3QgaXMgb2ZmClsgICA5OS43NzUyNDRdIHNkIDc6MDowOjA6
IFtzZGNdIE1vZGUgU2Vuc2U6IDg2IDBiIDAwIDAyClsgICA5OS43NzYwMDZdIHNkIDc6MDow
OjA6IFtzZGNdIEluY29tcGxldGUgbW9kZSBwYXJhbWV0ZXIgZGF0YQpbICAgOTkuNzc2MDA5
XSBzZCA3OjA6MDowOiBbc2RjXSBBc3N1bWluZyBkcml2ZSBjYWNoZTogd3JpdGUgdGhyb3Vn
aApbICAgOTkuNzc3OTg3XSBzZCA3OjA6MDowOiBbc2RjXSBJbmNvbXBsZXRlIG1vZGUgcGFy
YW1ldGVyIGRhdGEKWyAgIDk5Ljc3Nzk4OV0gc2QgNzowOjA6MDogW3NkY10gQXNzdW1pbmcg
ZHJpdmUgY2FjaGU6IHdyaXRlIHRocm91Z2gKWyAgIDk5Ljk5NjcyMV0gIHNkYzogc2RjMSBz
ZGMyClsgICA5OS45OTg1MTVdIHNkIDc6MDowOjA6IFtzZGNdIEluY29tcGxldGUgbW9kZSBw
YXJhbWV0ZXIgZGF0YQpbICAgOTkuOTk4NTE4XSBzZCA3OjA6MDowOiBbc2RjXSBBc3N1bWlu
ZyBkcml2ZSBjYWNoZTogd3JpdGUgdGhyb3VnaApbICAgOTkuOTk4NTIwXSBzZCA3OjA6MDow
OiBbc2RjXSBBdHRhY2hlZCBTQ1NJIGRpc2sKWyAgMTQyLjIzNTI3Nl0gcGNpZWhwIDAwMDA6
MDA6MWMuNzpwY2llMDQ6IHBjaWVfaXNyOiBpbnRyX2xvYyAxMDgKWyAgMTQyLjIzNTI3OF0g
cGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6IExpbmtTdGF0ZSBjaGFuZ2UKWyAgMTQyLjIz
NTI4MV0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6IGxua19zdGF0dXMgPSA1MDExClsg
IDE0Mi4yMzUyODNdIHBjaWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBQcmVzZW5jZS9Ob3Rp
ZnkgaW5wdXQgY2hhbmdlClsgIDE0Mi4yMzUyODZdIHBjaWVocCAwMDAwOjAwOjFjLjc6cGNp
ZTA0OiBDYXJkIG5vdCBwcmVzZW50IG9uIFNsb3QoNykKWyAgMTQyLjIzNTMyNF0gcGNpZWhw
IDAwMDA6MDA6MWMuNzpwY2llMDQ6IFN1cnByaXNlIFJlbW92YWwKWyAgMTQyLjIzNTM1NF0g
cGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6IERpc2FibGluZyBkb21haW46YnVzOmRldmlj
ZT0wMDAwOjExOjAwClsgIDE0Mi4yMzUzNTddIHBjaWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0
OiBwY2llaHBfdW5jb25maWd1cmVfZGV2aWNlOiBkb21haW46YnVzOmRldiA9IDAwMDA6MTE6
MDAKWyAgMTQyLjI0MDE3OF0geGhjaV9oY2QgMDAwMDoxMTowMC4wOiByZW1vdmUsIHN0YXRl
IDQKWyAgMTQyLjI0MDE4NV0gdXNiIHVzYjY6IFVTQiBkaXNjb25uZWN0LCBkZXZpY2UgbnVt
YmVyIDEKWyAgMTQyLjI0MDIzNl0geEhDSSB4aGNpX2Ryb3BfZW5kcG9pbnQgY2FsbGVkIGZv
ciByb290IGh1YgpbICAxNDIuMjQwMjM4XSB4SENJIHhoY2lfY2hlY2tfYmFuZHdpZHRoIGNh
bGxlZCBmb3Igcm9vdCBodWIKWyAgMTQyLjI0MDMyM10geGhjaV9oY2QgMDAwMDoxMTowMC4w
OiBIb3N0IG5vdCBoYWx0ZWQgYWZ0ZXIgMTYwMDAgbWljcm9zZWNvbmRzLgpbICAxNDIuMjQw
MzI2XSB4aGNpX2hjZCAwMDAwOjExOjAwLjA6IFVTQiBidXMgNiBkZXJlZ2lzdGVyZWQKWyAg
MTQyLjI0MDMzMl0geGhjaV9oY2QgMDAwMDoxMTowMC4wOiByZW1vdmUsIHN0YXRlIDEKWyAg
MTQyLjI0MDMzN10gdXNiIHVzYjU6IFVTQiBkaXNjb25uZWN0LCBkZXZpY2UgbnVtYmVyIDEK
WyAgMTQyLjI0MDMzOV0gdXNiIDUtMTogVVNCIGRpc2Nvbm5lY3QsIGRldmljZSBudW1iZXIg
MgpbICAxOTIuMTY1ODU1XSB4aGNpX2hjZCAwMDAwOjExOjAwLjA6IFRpbWVvdXQgd2hpbGUg
d2FpdGluZyBmb3IgY29uZmlndXJlIGVuZHBvaW50IGNvbW1hbmQKWyAgMTkyLjE2NjA1Ml0g
eEhDSSB4aGNpX2Ryb3BfZW5kcG9pbnQgY2FsbGVkIGZvciByb290IGh1YgpbICAxOTIuMTY2
MDU0XSB4SENJIHhoY2lfY2hlY2tfYmFuZHdpZHRoIGNhbGxlZCBmb3Igcm9vdCBodWIKWyAg
MTkyLjE2NjE0Ml0geGhjaV9oY2QgMDAwMDoxMTowMC4wOiBIb3N0IG5vdCBoYWx0ZWQgYWZ0
ZXIgMTYwMDAgbWljcm9zZWNvbmRzLgpbICAxOTIuMTY2MjQyXSB4aGNpX2hjZCAwMDAwOjEx
OjAwLjA6IFVTQiBidXMgNSBkZXJlZ2lzdGVyZWQKWyAgMTkyLjE2NjI5OF0gcGNpIDAwMDA6
MTE6MDAuMDogZnJlZWluZyBwY2lfZGV2IGluZm8KWyAgNDE0LjY1MTk1NF0gcGNpZWhwIDAw
MDA6MDA6MWMuNzpwY2llMDQ6IHBjaWVfaXNyOiBpbnRyX2xvYyAxMDgKWyAgNDE0LjY1MTk2
NF0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6IExpbmtTdGF0ZSBjaGFuZ2UKWyAgNDE0
LjY1MTk2N10gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6IGxua19zdGF0dXMgPSA3MDEx
ClsgIDQxNC42NTE5NjldIHBjaWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBQcmVzZW5jZS9O
b3RpZnkgaW5wdXQgY2hhbmdlClsgIDQxNC42NTE5NzJdIHBjaWVocCAwMDAwOjAwOjFjLjc6
cGNpZTA0OiBDYXJkIHByZXNlbnQgb24gU2xvdCg3KQpbICA0MTQuNjUyMDEyXSBwY2llaHAg
MDAwMDowMDoxYy43OnBjaWUwNDogU3VycHJpc2UgUmVtb3ZhbApbICA0MTQuNjUyMDQ0XSBw
Y2llaHAgMDAwMDowMDoxYy43OnBjaWUwNDogY2hlY2tfbGlua19hY3RpdmU6IGxua19zdGF0
dXMgPSA3MDExClsgIDQxNC43NTQ0NDNdIHBjaWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBw
Y2llaHBfY2hlY2tfbGlua19zdGF0dXM6IGxua19zdGF0dXMgPSA3MDExClsgIDQxNC43NTQ1
NDBdIHBjaSAwMDAwOjExOjAwLjA6IFsxMDMzOjAxOTRdIHR5cGUgMDAgY2xhc3MgMHgwYzAz
MzAKWyAgNDE0Ljc1NDU5MV0gcGNpIDAwMDA6MTE6MDAuMDogcmVnIDEwOiBbbWVtIDB4MDAw
MDAwMDAtMHgwMDAwMWZmZiA2NGJpdF0KWyAgNDE0Ljc1NDgzNF0gcGNpIDAwMDA6MTE6MDAu
MDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMCBEM2hvdApbICA0MTQuNzc0NDQ3XSBwY2kgMDAw
MDoxMTowMC4wOiBCQVIgMDogYXNzaWduZWQgW21lbSAweGY2YzAwMDAwLTB4ZjZjMDFmZmYg
NjRiaXRdClsgIDQxNC43NzQ0NzhdIHBjaWVwb3J0IDAwMDA6MDA6MWMuNzogUENJIGJyaWRn
ZSB0byBbYnVzIDExLTE2XQpbICA0MTQuNzc0NDkzXSBwY2llcG9ydCAwMDAwOjAwOjFjLjc6
ICAgYnJpZGdlIHdpbmRvdyBbaW8gIDB4YzAwMC0weGRmZmZdClsgIDQxNC43NzQ0OThdIHBj
aWVwb3J0IDAwMDA6MDA6MWMuNzogICBicmlkZ2Ugd2luZG93IFttZW0gMHhmNmMwMDAwMC0w
eGY3Y2ZmZmZmXQpbICA0MTQuNzc0NTAyXSBwY2llcG9ydCAwMDAwOjAwOjFjLjc6ICAgYnJp
ZGdlIHdpbmRvdyBbbWVtIDB4ZjAwMDAwMDAtMHhmMTBmZmZmZiA2NGJpdCBwcmVmXQpbICA0
MTQuNzc0NjQ0XSB4aGNpX2hjZCAwMDAwOjExOjAwLjA6IGVuYWJsaW5nIGRldmljZSAoMDEw
MCAtPiAwMTAyKQpbICA0MTQuNzc0NjkzXSB4aGNpX2hjZCAwMDAwOjExOjAwLjA6IHhIQ0kg
SG9zdCBDb250cm9sbGVyClsgIDQxNC43NzQ2OThdIHhoY2lfaGNkIDAwMDA6MTE6MDAuMDog
bmV3IFVTQiBidXMgcmVnaXN0ZXJlZCwgYXNzaWduZWQgYnVzIG51bWJlciA1ClsgIDQxNC43
NzQ5OTJdIHhoY2lfaGNkIDAwMDA6MTE6MDAuMDogaXJxIDE5LCBpbyBtZW0gMHhmNmMwMDAw
MApbICA0MTQuNzc1MTAzXSB4aGNpX2hjZCAwMDAwOjExOjAwLjA6IGlycSA1NCBmb3IgTVNJ
L01TSS1YClsgIDQxNC43NzUxMDldIHhoY2lfaGNkIDAwMDA6MTE6MDAuMDogaXJxIDU1IGZv
ciBNU0kvTVNJLVgKWyAgNDE0Ljc3NTExNF0geGhjaV9oY2QgMDAwMDoxMTowMC4wOiBpcnEg
NTYgZm9yIE1TSS9NU0ktWApbICA0MTQuNzc1MTI3XSB4aGNpX2hjZCAwMDAwOjExOjAwLjA6
IGlycSA1NyBmb3IgTVNJL01TSS1YClsgIDQxNC43NzUxMzNdIHhoY2lfaGNkIDAwMDA6MTE6
MDAuMDogaXJxIDU4IGZvciBNU0kvTVNJLVgKWyAgNDE0Ljc3NTMwMF0gdXNiIHVzYjU6IE5l
dyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZlbmRvcj0xZDZiLCBpZFByb2R1Y3Q9MDAwMgpbICA0
MTQuNzc1MzAyXSB1c2IgdXNiNTogTmV3IFVTQiBkZXZpY2Ugc3RyaW5nczogTWZyPTMsIFBy
b2R1Y3Q9MiwgU2VyaWFsTnVtYmVyPTEKWyAgNDE0Ljc3NTMwM10gdXNiIHVzYjU6IFByb2R1
Y3Q6IHhIQ0kgSG9zdCBDb250cm9sbGVyClsgIDQxNC43NzUzMDRdIHVzYiB1c2I1OiBNYW51
ZmFjdHVyZXI6IExpbnV4IDMuNC4wLXJjMy1kZWZhdWx0IHhoY2lfaGNkClsgIDQxNC43NzUz
MDVdIHVzYiB1c2I1OiBTZXJpYWxOdW1iZXI6IDAwMDA6MTE6MDAuMApbICA0MTQuNzc1NDI1
XSB4SENJIHhoY2lfYWRkX2VuZHBvaW50IGNhbGxlZCBmb3Igcm9vdCBodWIKWyAgNDE0Ljc3
NTQyN10geEhDSSB4aGNpX2NoZWNrX2JhbmR3aWR0aCBjYWxsZWQgZm9yIHJvb3QgaHViClsg
IDQxNC43NzU0NTBdIGh1YiA1LTA6MS4wOiBVU0IgaHViIGZvdW5kClsgIDQxNC43NzU0NjJd
IGh1YiA1LTA6MS4wOiAyIHBvcnRzIGRldGVjdGVkClsgIDQxNC43NzU1NTldIHhoY2lfaGNk
IDAwMDA6MTE6MDAuMDogeEhDSSBIb3N0IENvbnRyb2xsZXIKWyAgNDE0Ljc3NTU3MF0geGhj
aV9oY2QgMDAwMDoxMTowMC4wOiBuZXcgVVNCIGJ1cyByZWdpc3RlcmVkLCBhc3NpZ25lZCBi
dXMgbnVtYmVyIDYKWyAgNDE0Ljc3ODIyOF0gdXNiIHVzYjY6IE5ldyBVU0IgZGV2aWNlIGZv
dW5kLCBpZFZlbmRvcj0xZDZiLCBpZFByb2R1Y3Q9MDAwMwpbICA0MTQuNzc4MjMwXSB1c2Ig
dXNiNjogTmV3IFVTQiBkZXZpY2Ugc3RyaW5nczogTWZyPTMsIFByb2R1Y3Q9MiwgU2VyaWFs
TnVtYmVyPTEKWyAgNDE0Ljc3ODIzMV0gdXNiIHVzYjY6IFByb2R1Y3Q6IHhIQ0kgSG9zdCBD
b250cm9sbGVyClsgIDQxNC43NzgyMzJdIHVzYiB1c2I2OiBNYW51ZmFjdHVyZXI6IExpbnV4
IDMuNC4wLXJjMy1kZWZhdWx0IHhoY2lfaGNkClsgIDQxNC43NzgyMzRdIHVzYiB1c2I2OiBT
ZXJpYWxOdW1iZXI6IDAwMDA6MTE6MDAuMApbICA0MTQuNzc4MjkxXSB4SENJIHhoY2lfYWRk
X2VuZHBvaW50IGNhbGxlZCBmb3Igcm9vdCBodWIKWyAgNDE0Ljc3ODI5M10geEhDSSB4aGNp
X2NoZWNrX2JhbmR3aWR0aCBjYWxsZWQgZm9yIHJvb3QgaHViClsgIDQxNC43NzgzMjBdIGh1
YiA2LTA6MS4wOiBVU0IgaHViIGZvdW5kClsgIDQxNC43NzgzMzJdIGh1YiA2LTA6MS4wOiAy
IHBvcnRzIGRldGVjdGVkClsgIDQxNS4wOTM5MzddIHVzYiA1LTE6IG5ldyBoaWdoLXNwZWVk
IFVTQiBkZXZpY2UgbnVtYmVyIDIgdXNpbmcgeGhjaV9oY2QKWyAgNDE1LjExNzM5OF0gdXNi
IDUtMTogTmV3IFVTQiBkZXZpY2UgZm91bmQsIGlkVmVuZG9yPTEzZmQsIGlkUHJvZHVjdD0w
NTUwClsgIDQxNS4xMTc0MDldIHVzYiA1LTE6IE5ldyBVU0IgZGV2aWNlIHN0cmluZ3M6IE1m
cj0xLCBQcm9kdWN0PTIsIFNlcmlhbE51bWJlcj0zClsgIDQxNS4xMTc0MTVdIHVzYiA1LTE6
IFByb2R1Y3Q6IFNUOTE2MDgyMUEgICAgICAKWyAgNDE1LjExNzQyMF0gdXNiIDUtMTogTWFu
dWZhY3R1cmVyOiBJbml0aW8gIApbICA0MTUuMTE3NDI1XSB1c2IgNS0xOiBTZXJpYWxOdW1i
ZXI6IDAwMTAxMDA1NTAwMDExQjgwClsgIDQxNS4xMTc2MDFdIHVzYiA1LTE6IGVwIDB4ODEg
LSByb3VuZGluZyBpbnRlcnZhbCB0byAzMjc2OCBtaWNyb2ZyYW1lcywgZXAgZGVzYyBzYXlz
IDAgbWljcm9mcmFtZXMKWyAgNDE1LjExNzYwNl0gdXNiIDUtMTogZXAgMHgyIC0gcm91bmRp
bmcgaW50ZXJ2YWwgdG8gMzI3NjggbWljcm9mcmFtZXMsIGVwIGRlc2Mgc2F5cyAwIG1pY3Jv
ZnJhbWVzClsgIDQxNS4xMTg0NDRdIHNjc2k4IDogdXNiLXN0b3JhZ2UgNS0xOjEuMApbICA0
MTUuMTIwMzE3XSBnZW5lcmljLXVzYiAwMDAzOjEzRkQ6MDU1MC4wMDA0OiBoaWRkZXYwLGhp
ZHJhdzI6IFVTQiBISUQgdjEuMTAgRGV2aWNlIFtJbml0aW8gICBTVDkxNjA4MjFBICAgICAg
XSBvbiB1c2ItMDAwMDoxMTowMC4wLTEvaW5wdXQxClsgIDQxNi4xMTMzNjddIHNjc2kgODow
OjA6MDogRGlyZWN0LUFjY2VzcyAgICAgSW5pdGlvICAgU1Q5MTYwODIxQSAgICAgICAzLjEy
IFBROiAwIEFOU0k6IDAKWyAgNDE2LjExMzUyOF0gc2QgODowOjA6MDogQXR0YWNoZWQgc2Nz
aSBnZW5lcmljIHNnMyB0eXBlIDAKWyAgNDE2LjExMzczNl0gc2QgODowOjA6MDogW3NkY10g
MzEyNTgxODA4IDUxMi1ieXRlIGxvZ2ljYWwgYmxvY2tzOiAoMTYwIEdCLzE0OSBHaUIpClsg
IDQxNi4xMTQzNDBdIHNkIDg6MDowOjA6IFtzZGNdIFdyaXRlIFByb3RlY3QgaXMgb2ZmClsg
IDQxNi4xMTQzNDRdIHNkIDg6MDowOjA6IFtzZGNdIE1vZGUgU2Vuc2U6IDg2IDBiIDAwIDAy
ClsgIDQxNi4xMTUxNDNdIHNkIDg6MDowOjA6IFtzZGNdIEluY29tcGxldGUgbW9kZSBwYXJh
bWV0ZXIgZGF0YQpbICA0MTYuMTE1MTUzXSBzZCA4OjA6MDowOiBbc2RjXSBBc3N1bWluZyBk
cml2ZSBjYWNoZTogd3JpdGUgdGhyb3VnaApbICA0MTYuMTE2OTkzXSBzZCA4OjA6MDowOiBb
c2RjXSBJbmNvbXBsZXRlIG1vZGUgcGFyYW1ldGVyIGRhdGEKWyAgNDE2LjExNzAwMV0gc2Qg
ODowOjA6MDogW3NkY10gQXNzdW1pbmcgZHJpdmUgY2FjaGU6IHdyaXRlIHRocm91Z2gKWyAg
NDE2LjMwOTY3NF0gIHNkYzogc2RjMSBzZGMyClsgIDQxNi4zMTEzMTJdIHNkIDg6MDowOjA6
IFtzZGNdIEluY29tcGxldGUgbW9kZSBwYXJhbWV0ZXIgZGF0YQpbICA0MTYuMzExMzIwXSBz
ZCA4OjA6MDowOiBbc2RjXSBBc3N1bWluZyBkcml2ZSBjYWNoZTogd3JpdGUgdGhyb3VnaApb
ICA0MTYuMzExMzI3XSBzZCA4OjA6MDowOiBbc2RjXSBBdHRhY2hlZCBTQ1NJIGRpc2sKWyAg
NDgxLjEzMTgyOF0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6IHBjaWVfaXNyOiBpbnRy
X2xvYyAxMDgKWyAgNDgxLjEzMTgzMF0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6IExp
bmtTdGF0ZSBjaGFuZ2UKWyAgNDgxLjEzMTgzNF0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2ll
MDQ6IGxua19zdGF0dXMgPSA1MDExClsgIDQ4MS4xMzE4MzVdIHBjaWVocCAwMDAwOjAwOjFj
Ljc6cGNpZTA0OiBQcmVzZW5jZS9Ob3RpZnkgaW5wdXQgY2hhbmdlClsgIDQ4MS4xMzE4Mzhd
IHBjaWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBDYXJkIG5vdCBwcmVzZW50IG9uIFNsb3Qo
NykKWyAgNDgxLjEzMTg3Nl0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6IFN1cnByaXNl
IFJlbW92YWwKWyAgNDgxLjEzMTkwNl0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6IERp
c2FibGluZyBkb21haW46YnVzOmRldmljZT0wMDAwOjExOjAwClsgIDQ4MS4xMzE5MDldIHBj
aWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBwY2llaHBfdW5jb25maWd1cmVfZGV2aWNlOiBk
b21haW46YnVzOmRldiA9IDAwMDA6MTE6MDAKWyAgNDgxLjEzNTcyNF0geGhjaV9oY2QgMDAw
MDoxMTowMC4wOiByZW1vdmUsIHN0YXRlIDQKWyAgNDgxLjEzNTczMV0gdXNiIHVzYjY6IFVT
QiBkaXNjb25uZWN0LCBkZXZpY2UgbnVtYmVyIDEKWyAgNDgxLjEzNTgwNl0geEhDSSB4aGNp
X2Ryb3BfZW5kcG9pbnQgY2FsbGVkIGZvciByb290IGh1YgpbICA0ODEuMTM1ODA4XSB4SENJ
IHhoY2lfY2hlY2tfYmFuZHdpZHRoIGNhbGxlZCBmb3Igcm9vdCBodWIKWyAgNDgxLjEzNTg4
NF0geGhjaV9oY2QgMDAwMDoxMTowMC4wOiBIb3N0IG5vdCBoYWx0ZWQgYWZ0ZXIgMTYwMDAg
bWljcm9zZWNvbmRzLgpbICA0ODEuMTM1ODg4XSB4aGNpX2hjZCAwMDAwOjExOjAwLjA6IFVT
QiBidXMgNiBkZXJlZ2lzdGVyZWQKWyAgNDgxLjEzNTg5M10geGhjaV9oY2QgMDAwMDoxMTow
MC4wOiByZW1vdmUsIHN0YXRlIDEKWyAgNDgxLjEzNTg5OF0gdXNiIHVzYjU6IFVTQiBkaXNj
b25uZWN0LCBkZXZpY2UgbnVtYmVyIDEKWyAgNDgxLjEzNTkwMF0gdXNiIDUtMTogVVNCIGRp
c2Nvbm5lY3QsIGRldmljZSBudW1iZXIgMgpbICA1MzEuMDYxMzgwXSB4aGNpX2hjZCAwMDAw
OjExOjAwLjA6IFRpbWVvdXQgd2hpbGUgd2FpdGluZyBmb3IgY29uZmlndXJlIGVuZHBvaW50
IGNvbW1hbmQKWyAgNTMxLjA2MTU3MF0geEhDSSB4aGNpX2Ryb3BfZW5kcG9pbnQgY2FsbGVk
IGZvciByb290IGh1YgpbICA1MzEuMDYxNTcyXSB4SENJIHhoY2lfY2hlY2tfYmFuZHdpZHRo
IGNhbGxlZCBmb3Igcm9vdCBodWIKWyAgNTMxLjA2MTY1OV0geGhjaV9oY2QgMDAwMDoxMTow
MC4wOiBIb3N0IG5vdCBoYWx0ZWQgYWZ0ZXIgMTYwMDAgbWljcm9zZWNvbmRzLgpbICA1MzEu
MDYxNzYxXSB4aGNpX2hjZCAwMDAwOjExOjAwLjA6IFVTQiBidXMgNSBkZXJlZ2lzdGVyZWQK
WyAgNTMxLjA2MTgxOF0gcGNpIDAwMDA6MTE6MDAuMDogZnJlZWluZyBwY2lfZGV2IGluZm8K
WyAgNTkyLjcwNDY2OF0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6IHBjaWVfaXNyOiBp
bnRyX2xvYyAxMDgKWyAgNTkyLjcwNDY3MF0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6
IExpbmtTdGF0ZSBjaGFuZ2UKWyAgNTkyLjcwNDY3M10gcGNpZWhwIDAwMDA6MDA6MWMuNzpw
Y2llMDQ6IGxua19zdGF0dXMgPSA3MDExClsgIDU5Mi43MDQ2ODJdIHBjaWVocCAwMDAwOjAw
OjFjLjc6cGNpZTA0OiBQcmVzZW5jZS9Ob3RpZnkgaW5wdXQgY2hhbmdlClsgIDU5Mi43MDQ2
ODVdIHBjaWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBDYXJkIHByZXNlbnQgb24gU2xvdCg3
KQpbICA1OTIuNzA0NzI0XSBwY2llaHAgMDAwMDowMDoxYy43OnBjaWUwNDogU3VycHJpc2Ug
UmVtb3ZhbApbICA1OTIuNzA0NzU4XSBwY2llaHAgMDAwMDowMDoxYy43OnBjaWUwNDogY2hl
Y2tfbGlua19hY3RpdmU6IGxua19zdGF0dXMgPSA3MDExClsgIDU5Mi44MDkzODddIHBjaWVo
cCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBwY2llaHBfY2hlY2tfbGlua19zdGF0dXM6IGxua19z
dGF0dXMgPSA3MDExClsgIDU5Mi44MDk0OTBdIHBjaSAwMDAwOjExOjAwLjA6IFsxMDMzOjAx
OTRdIHR5cGUgMDAgY2xhc3MgMHgwYzAzMzAKWyAgNTkyLjgwOTU0MV0gcGNpIDAwMDA6MTE6
MDAuMDogcmVnIDEwOiBbbWVtIDB4MDAwMDAwMDAtMHgwMDAwMWZmZiA2NGJpdF0KWyAgNTky
LjgwOTc4Nl0gcGNpIDAwMDA6MTE6MDAuMDogUE1FIyBzdXBwb3J0ZWQgZnJvbSBEMCBEM2hv
dApbICA1OTIuODI5NDAyXSBwY2kgMDAwMDoxMTowMC4wOiBCQVIgMDogYXNzaWduZWQgW21l
bSAweGY2YzAwMDAwLTB4ZjZjMDFmZmYgNjRiaXRdClsgIDU5Mi44Mjk0NDddIHBjaWVwb3J0
IDAwMDA6MDA6MWMuNzogUENJIGJyaWRnZSB0byBbYnVzIDExLTE2XQpbICA1OTIuODI5NDUw
XSBwY2llcG9ydCAwMDAwOjAwOjFjLjc6ICAgYnJpZGdlIHdpbmRvdyBbaW8gIDB4YzAwMC0w
eGRmZmZdClsgIDU5Mi44Mjk0NTVdIHBjaWVwb3J0IDAwMDA6MDA6MWMuNzogICBicmlkZ2Ug
d2luZG93IFttZW0gMHhmNmMwMDAwMC0weGY3Y2ZmZmZmXQpbICA1OTIuODI5NDU5XSBwY2ll
cG9ydCAwMDAwOjAwOjFjLjc6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZjAwMDAwMDAtMHhm
MTBmZmZmZiA2NGJpdCBwcmVmXQpbICA1OTIuODI5NTkzXSB4aGNpX2hjZCAwMDAwOjExOjAw
LjA6IGVuYWJsaW5nIGRldmljZSAoMDEwMCAtPiAwMTAyKQpbICA1OTIuODI5NjcxXSB4aGNp
X2hjZCAwMDAwOjExOjAwLjA6IHhIQ0kgSG9zdCBDb250cm9sbGVyClsgIDU5Mi44Mjk2NzZd
IHhoY2lfaGNkIDAwMDA6MTE6MDAuMDogbmV3IFVTQiBidXMgcmVnaXN0ZXJlZCwgYXNzaWdu
ZWQgYnVzIG51bWJlciA1ClsgIDU5Mi44Mjk5NzNdIHhoY2lfaGNkIDAwMDA6MTE6MDAuMDog
aXJxIDE5LCBpbyBtZW0gMHhmNmMwMDAwMApbICA1OTIuODMwMDkwXSB4aGNpX2hjZCAwMDAw
OjExOjAwLjA6IGlycSA1NCBmb3IgTVNJL01TSS1YClsgIDU5Mi44MzAwOTRdIHhoY2lfaGNk
IDAwMDA6MTE6MDAuMDogaXJxIDU1IGZvciBNU0kvTVNJLVgKWyAgNTkyLjgzMDA5OV0geGhj
aV9oY2QgMDAwMDoxMTowMC4wOiBpcnEgNTYgZm9yIE1TSS9NU0ktWApbICA1OTIuODMwMTAz
XSB4aGNpX2hjZCAwMDAwOjExOjAwLjA6IGlycSA1NyBmb3IgTVNJL01TSS1YClsgIDU5Mi44
MzAxMDddIHhoY2lfaGNkIDAwMDA6MTE6MDAuMDogaXJxIDU4IGZvciBNU0kvTVNJLVgKWyAg
NTkyLjgzMDI1OF0gdXNiIHVzYjU6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZlbmRvcj0x
ZDZiLCBpZFByb2R1Y3Q9MDAwMgpbICA1OTIuODMwMjYwXSB1c2IgdXNiNTogTmV3IFVTQiBk
ZXZpY2Ugc3RyaW5nczogTWZyPTMsIFByb2R1Y3Q9MiwgU2VyaWFsTnVtYmVyPTEKWyAgNTky
LjgzMDI2MV0gdXNiIHVzYjU6IFByb2R1Y3Q6IHhIQ0kgSG9zdCBDb250cm9sbGVyClsgIDU5
Mi44MzAyNjJdIHVzYiB1c2I1OiBNYW51ZmFjdHVyZXI6IExpbnV4IDMuNC4wLXJjMy1kZWZh
dWx0IHhoY2lfaGNkClsgIDU5Mi44MzAyNjNdIHVzYiB1c2I1OiBTZXJpYWxOdW1iZXI6IDAw
MDA6MTE6MDAuMApbICA1OTIuODMwMzgwXSB4SENJIHhoY2lfYWRkX2VuZHBvaW50IGNhbGxl
ZCBmb3Igcm9vdCBodWIKWyAgNTkyLjgzMDM4Ml0geEhDSSB4aGNpX2NoZWNrX2JhbmR3aWR0
aCBjYWxsZWQgZm9yIHJvb3QgaHViClsgIDU5Mi44MzA0MjFdIGh1YiA1LTA6MS4wOiBVU0Ig
aHViIGZvdW5kClsgIDU5Mi44MzA0MzRdIGh1YiA1LTA6MS4wOiAyIHBvcnRzIGRldGVjdGVk
ClsgIDU5Mi44MzA0OTVdIHhoY2lfaGNkIDAwMDA6MTE6MDAuMDogeEhDSSBIb3N0IENvbnRy
b2xsZXIKWyAgNTkyLjgzMDQ5OF0geGhjaV9oY2QgMDAwMDoxMTowMC4wOiBuZXcgVVNCIGJ1
cyByZWdpc3RlcmVkLCBhc3NpZ25lZCBidXMgbnVtYmVyIDYKWyAgNTkyLjgzMzIxMV0gdXNi
IHVzYjY6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZlbmRvcj0xZDZiLCBpZFByb2R1Y3Q9
MDAwMwpbICA1OTIuODMzMjE0XSB1c2IgdXNiNjogTmV3IFVTQiBkZXZpY2Ugc3RyaW5nczog
TWZyPTMsIFByb2R1Y3Q9MiwgU2VyaWFsTnVtYmVyPTEKWyAgNTkyLjgzMzIxNl0gdXNiIHVz
YjY6IFByb2R1Y3Q6IHhIQ0kgSG9zdCBDb250cm9sbGVyClsgIDU5Mi44MzMyMTddIHVzYiB1
c2I2OiBNYW51ZmFjdHVyZXI6IExpbnV4IDMuNC4wLXJjMy1kZWZhdWx0IHhoY2lfaGNkClsg
IDU5Mi44MzMyMTldIHVzYiB1c2I2OiBTZXJpYWxOdW1iZXI6IDAwMDA6MTE6MDAuMApbICA1
OTIuODMzMzE3XSB4SENJIHhoY2lfYWRkX2VuZHBvaW50IGNhbGxlZCBmb3Igcm9vdCBodWIK
WyAgNTkyLjgzMzMxOF0geEhDSSB4aGNpX2NoZWNrX2JhbmR3aWR0aCBjYWxsZWQgZm9yIHJv
b3QgaHViClsgIDU5Mi44MzMzNDVdIGh1YiA2LTA6MS4wOiBVU0IgaHViIGZvdW5kClsgIDU5
Mi44MzMzNjNdIGh1YiA2LTA6MS4wOiAyIHBvcnRzIGRldGVjdGVkClsgIDcyNS43ODI4MTdd
IHBjaWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBwY2llX2lzcjogaW50cl9sb2MgMTA4Clsg
IDcyNS43ODI4MTldIHBjaWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBMaW5rU3RhdGUgY2hh
bmdlClsgIDcyNS43ODI4MjJdIHBjaWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBsbmtfc3Rh
dHVzID0gNTAxMQpbICA3MjUuNzgyODIzXSBwY2llaHAgMDAwMDowMDoxYy43OnBjaWUwNDog
UHJlc2VuY2UvTm90aWZ5IGlucHV0IGNoYW5nZQpbICA3MjUuNzgyODI2XSBwY2llaHAgMDAw
MDowMDoxYy43OnBjaWUwNDogQ2FyZCBub3QgcHJlc2VudCBvbiBTbG90KDcpClsgIDcyNS43
ODI4NjVdIHBjaWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBTdXJwcmlzZSBSZW1vdmFsClsg
IDcyNS43ODI4OTVdIHBjaWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBEaXNhYmxpbmcgZG9t
YWluOmJ1czpkZXZpY2U9MDAwMDoxMTowMApbICA3MjUuNzgyODk4XSBwY2llaHAgMDAwMDow
MDoxYy43OnBjaWUwNDogcGNpZWhwX3VuY29uZmlndXJlX2RldmljZTogZG9tYWluOmJ1czpk
ZXYgPSAwMDAwOjExOjAwClsgIDcyNS43OTE1NTZdIHhoY2lfaGNkIDAwMDA6MTE6MDAuMDog
cmVtb3ZlLCBzdGF0ZSA0ClsgIDcyNS43OTE1NjJdIHVzYiB1c2I2OiBVU0IgZGlzY29ubmVj
dCwgZGV2aWNlIG51bWJlciAxClsgIDcyNS43OTE2MDddIHhIQ0kgeGhjaV9kcm9wX2VuZHBv
aW50IGNhbGxlZCBmb3Igcm9vdCBodWIKWyAgNzI1Ljc5MTYwOV0geEhDSSB4aGNpX2NoZWNr
X2JhbmR3aWR0aCBjYWxsZWQgZm9yIHJvb3QgaHViClsgIDcyNS43OTE4MjFdIHhoY2lfaGNk
IDAwMDA6MTE6MDAuMDogSG9zdCBub3QgaGFsdGVkIGFmdGVyIDE2MDAwIG1pY3Jvc2Vjb25k
cy4KWyAgNzI1Ljc5MTgyNV0geGhjaV9oY2QgMDAwMDoxMTowMC4wOiBVU0IgYnVzIDYgZGVy
ZWdpc3RlcmVkClsgIDcyNS43OTE4MzBdIHhoY2lfaGNkIDAwMDA6MTE6MDAuMDogcmVtb3Zl
LCBzdGF0ZSA0ClsgIDcyNS43OTE4MzRdIHVzYiB1c2I1OiBVU0IgZGlzY29ubmVjdCwgZGV2
aWNlIG51bWJlciAxClsgIDcyNS43OTE4NzFdIHhIQ0kgeGhjaV9kcm9wX2VuZHBvaW50IGNh
bGxlZCBmb3Igcm9vdCBodWIKWyAgNzI1Ljc5MTg3Ml0geEhDSSB4aGNpX2NoZWNrX2JhbmR3
aWR0aCBjYWxsZWQgZm9yIHJvb3QgaHViClsgIDcyNS43OTIxMDddIHhoY2lfaGNkIDAwMDA6
MTE6MDAuMDogSG9zdCBub3QgaGFsdGVkIGFmdGVyIDE2MDAwIG1pY3Jvc2Vjb25kcy4KWyAg
NzI1Ljc5MjE4OF0geGhjaV9oY2QgMDAwMDoxMTowMC4wOiBVU0IgYnVzIDUgZGVyZWdpc3Rl
cmVkClsgIDcyNS43OTIyNDJdIHBjaSAwMDAwOjExOjAwLjA6IGZyZWVpbmcgcGNpX2RldiBp
bmZvClsgIDcyNS43OTkwOTJdIHBjaWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBwY2llX2lz
cjogaW50cl9sb2MgMTA4ClsgIDcyNS43OTkwOTRdIHBjaWVocCAwMDAwOjAwOjFjLjc6cGNp
ZTA0OiBMaW5rU3RhdGUgY2hhbmdlClsgIDcyNS43OTkwOThdIHBjaWVocCAwMDAwOjAwOjFj
Ljc6cGNpZTA0OiBsbmtfc3RhdHVzID0gNzAxMQpbICA3MjUuNzk5MTEwXSBwY2llaHAgMDAw
MDowMDoxYy43OnBjaWUwNDogUHJlc2VuY2UvTm90aWZ5IGlucHV0IGNoYW5nZQpbICA3MjUu
Nzk5MTEzXSBwY2llaHAgMDAwMDowMDoxYy43OnBjaWUwNDogQ2FyZCBwcmVzZW50IG9uIFNs
b3QoNykKWyAgNzI1Ljc5OTExOF0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6IFN1cnBy
aXNlIFJlbW92YWwKWyAgNzI1Ljc5OTEyOF0gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6
IGNoZWNrX2xpbmtfYWN0aXZlOiBsbmtfc3RhdHVzID0gNzAxMQpbICA3MjUuOTAxMjE2XSBw
Y2llaHAgMDAwMDowMDoxYy43OnBjaWUwNDogcGNpZWhwX2NoZWNrX2xpbmtfc3RhdHVzOiBs
bmtfc3RhdHVzID0gNzAxMQpbICA3MjUuOTAxMzIyXSBwY2kgMDAwMDoxMTowMC4wOiBbMTAz
MzowMTk0XSB0eXBlIDAwIGNsYXNzIDB4MGMwMzMwClsgIDcyNS45MDEzNzNdIHBjaSAwMDAw
OjExOjAwLjA6IHJlZyAxMDogW21lbSAweDAwMDAwMDAwLTB4MDAwMDFmZmYgNjRiaXRdClsg
IDcyNS45MDE2MTddIHBjaSAwMDAwOjExOjAwLjA6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDAg
RDNob3QKWyAgNzI1LjkyMTI1OV0gcGNpIDAwMDA6MTE6MDAuMDogQkFSIDA6IGFzc2lnbmVk
IFttZW0gMHhmNmMwMDAwMC0weGY2YzAxZmZmIDY0Yml0XQpbICA3MjUuOTIxMzAzXSBwY2ll
cG9ydCAwMDAwOjAwOjFjLjc6IFBDSSBicmlkZ2UgdG8gW2J1cyAxMS0xNl0KWyAgNzI1Ljky
MTMwNl0gcGNpZXBvcnQgMDAwMDowMDoxYy43OiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweGMw
MDAtMHhkZmZmXQpbICA3MjUuOTIxMzExXSBwY2llcG9ydCAwMDAwOjAwOjFjLjc6ICAgYnJp
ZGdlIHdpbmRvdyBbbWVtIDB4ZjZjMDAwMDAtMHhmN2NmZmZmZl0KWyAgNzI1LjkyMTMxNV0g
cGNpZXBvcnQgMDAwMDowMDoxYy43OiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGYwMDAwMDAw
LTB4ZjEwZmZmZmYgNjRiaXQgcHJlZl0KWyAgNzI1LjkyMTQ1N10geGhjaV9oY2QgMDAwMDox
MTowMC4wOiBlbmFibGluZyBkZXZpY2UgKDAxMDAgLT4gMDEwMikKWyAgNzI1LjkyMTUwNV0g
eGhjaV9oY2QgMDAwMDoxMTowMC4wOiB4SENJIEhvc3QgQ29udHJvbGxlcgpbICA3MjUuOTIx
NTEwXSB4aGNpX2hjZCAwMDAwOjExOjAwLjA6IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFz
c2lnbmVkIGJ1cyBudW1iZXIgNQpbICA3MjUuOTIxODA4XSB4aGNpX2hjZCAwMDAwOjExOjAw
LjA6IGlycSAxOSwgaW8gbWVtIDB4ZjZjMDAwMDAKWyAgNzI1LjkyMTkxMV0geGhjaV9oY2Qg
MDAwMDoxMTowMC4wOiBpcnEgNTQgZm9yIE1TSS9NU0ktWApbICA3MjUuOTIxOTE0XSB4aGNp
X2hjZCAwMDAwOjExOjAwLjA6IGlycSA1NSBmb3IgTVNJL01TSS1YClsgIDcyNS45MjE5MThd
IHhoY2lfaGNkIDAwMDA6MTE6MDAuMDogaXJxIDU2IGZvciBNU0kvTVNJLVgKWyAgNzI1Ljky
MTkyMl0geGhjaV9oY2QgMDAwMDoxMTowMC4wOiBpcnEgNTcgZm9yIE1TSS9NU0ktWApbICA3
MjUuOTIxOTI2XSB4aGNpX2hjZCAwMDAwOjExOjAwLjA6IGlycSA1OCBmb3IgTVNJL01TSS1Y
ClsgIDcyNS45MjIwNzldIHVzYiB1c2I1OiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRWZW5k
b3I9MWQ2YiwgaWRQcm9kdWN0PTAwMDIKWyAgNzI1LjkyMjA4MV0gdXNiIHVzYjU6IE5ldyBV
U0IgZGV2aWNlIHN0cmluZ3M6IE1mcj0zLCBQcm9kdWN0PTIsIFNlcmlhbE51bWJlcj0xClsg
IDcyNS45MjIwODJdIHVzYiB1c2I1OiBQcm9kdWN0OiB4SENJIEhvc3QgQ29udHJvbGxlcgpb
ICA3MjUuOTIyMDgzXSB1c2IgdXNiNTogTWFudWZhY3R1cmVyOiBMaW51eCAzLjQuMC1yYzMt
ZGVmYXVsdCB4aGNpX2hjZApbICA3MjUuOTIyMDg0XSB1c2IgdXNiNTogU2VyaWFsTnVtYmVy
OiAwMDAwOjExOjAwLjAKWyAgNzI1LjkyMjIwOF0geEhDSSB4aGNpX2FkZF9lbmRwb2ludCBj
YWxsZWQgZm9yIHJvb3QgaHViClsgIDcyNS45MjIyMTBdIHhIQ0kgeGhjaV9jaGVja19iYW5k
d2lkdGggY2FsbGVkIGZvciByb290IGh1YgpbICA3MjUuOTIyMjMzXSBodWIgNS0wOjEuMDog
VVNCIGh1YiBmb3VuZApbICA3MjUuOTIyMjQ0XSBodWIgNS0wOjEuMDogMiBwb3J0cyBkZXRl
Y3RlZApbICA3MjUuOTIyMzEwXSB4aGNpX2hjZCAwMDAwOjExOjAwLjA6IHhIQ0kgSG9zdCBD
b250cm9sbGVyClsgIDcyNS45MjIzMTJdIHhoY2lfaGNkIDAwMDA6MTE6MDAuMDogbmV3IFVT
QiBidXMgcmVnaXN0ZXJlZCwgYXNzaWduZWQgYnVzIG51bWJlciA2ClsgIDcyNS45MjUwNDJd
IHVzYiB1c2I2OiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRWZW5kb3I9MWQ2YiwgaWRQcm9k
dWN0PTAwMDMKWyAgNzI1LjkyNTA0NV0gdXNiIHVzYjY6IE5ldyBVU0IgZGV2aWNlIHN0cmlu
Z3M6IE1mcj0zLCBQcm9kdWN0PTIsIFNlcmlhbE51bWJlcj0xClsgIDcyNS45MjUwNDddIHVz
YiB1c2I2OiBQcm9kdWN0OiB4SENJIEhvc3QgQ29udHJvbGxlcgpbICA3MjUuOTI1MDQ5XSB1
c2IgdXNiNjogTWFudWZhY3R1cmVyOiBMaW51eCAzLjQuMC1yYzMtZGVmYXVsdCB4aGNpX2hj
ZApbICA3MjUuOTI1MDUxXSB1c2IgdXNiNjogU2VyaWFsTnVtYmVyOiAwMDAwOjExOjAwLjAK
WyAgNzI1LjkyNTE2OF0geEhDSSB4aGNpX2FkZF9lbmRwb2ludCBjYWxsZWQgZm9yIHJvb3Qg
aHViClsgIDcyNS45MjUxNzBdIHhIQ0kgeGhjaV9jaGVja19iYW5kd2lkdGggY2FsbGVkIGZv
ciByb290IGh1YgpbICA3MjUuOTI1MjAzXSBodWIgNi0wOjEuMDogVVNCIGh1YiBmb3VuZApb
ICA3MjUuOTI1MjIyXSBodWIgNi0wOjEuMDogMiBwb3J0cyBkZXRlY3RlZApbICA5MzUuMDI4
MTM4XSBwY2llaHAgMDAwMDowMDoxYy43OnBjaWUwNDogcGNpZV9pc3I6IGludHJfbG9jIDEw
OApbICA5MzUuMDI4MTQ4XSBwY2llaHAgMDAwMDowMDoxYy43OnBjaWUwNDogTGlua1N0YXRl
IGNoYW5nZQpbICA5MzUuMDI4MTUxXSBwY2llaHAgMDAwMDowMDoxYy43OnBjaWUwNDogbG5r
X3N0YXR1cyA9IDUwMTEKWyAgOTM1LjAyODE1M10gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2ll
MDQ6IFByZXNlbmNlL05vdGlmeSBpbnB1dCBjaGFuZ2UKWyAgOTM1LjAyODE1Nl0gcGNpZWhw
IDAwMDA6MDA6MWMuNzpwY2llMDQ6IENhcmQgbm90IHByZXNlbnQgb24gU2xvdCg3KQpbICA5
MzUuMDI4MTg3XSBwY2llaHAgMDAwMDowMDoxYy43OnBjaWUwNDogU3VycHJpc2UgUmVtb3Zh
bApbICA5MzUuMDI4MjE3XSBwY2llaHAgMDAwMDowMDoxYy43OnBjaWUwNDogRGlzYWJsaW5n
IGRvbWFpbjpidXM6ZGV2aWNlPTAwMDA6MTE6MDAKWyAgOTM1LjAyODIxOV0gcGNpZWhwIDAw
MDA6MDA6MWMuNzpwY2llMDQ6IHBjaWVocF91bmNvbmZpZ3VyZV9kZXZpY2U6IGRvbWFpbjpi
dXM6ZGV2ID0gMDAwMDoxMTowMApbICA5MzUuMDMwMTQzXSB4aGNpX2hjZCAwMDAwOjExOjAw
LjA6IHJlbW92ZSwgc3RhdGUgNApbICA5MzUuMDMwMTQ4XSB1c2IgdXNiNjogVVNCIGRpc2Nv
bm5lY3QsIGRldmljZSBudW1iZXIgMQpbICA5MzUuMDMwMjA5XSB4SENJIHhoY2lfZHJvcF9l
bmRwb2ludCBjYWxsZWQgZm9yIHJvb3QgaHViClsgIDkzNS4wMzAyMTFdIHhIQ0kgeGhjaV9j
aGVja19iYW5kd2lkdGggY2FsbGVkIGZvciByb290IGh1YgpbICA5MzUuMDMwMjk5XSB4aGNp
X2hjZCAwMDAwOjExOjAwLjA6IEhvc3Qgbm90IGhhbHRlZCBhZnRlciAxNjAwMCBtaWNyb3Nl
Y29uZHMuClsgIDkzNS4wMzAzMDRdIHhoY2lfaGNkIDAwMDA6MTE6MDAuMDogVVNCIGJ1cyA2
IGRlcmVnaXN0ZXJlZApbICA5MzUuMDMwMzEwXSB4aGNpX2hjZCAwMDAwOjExOjAwLjA6IHJl
bW92ZSwgc3RhdGUgNApbICA5MzUuMDMwMzE1XSB1c2IgdXNiNTogVVNCIGRpc2Nvbm5lY3Qs
IGRldmljZSBudW1iZXIgMQpbICA5MzUuMDMwMzUxXSB4SENJIHhoY2lfZHJvcF9lbmRwb2lu
dCBjYWxsZWQgZm9yIHJvb3QgaHViClsgIDkzNS4wMzAzNTJdIHhIQ0kgeGhjaV9jaGVja19i
YW5kd2lkdGggY2FsbGVkIGZvciByb290IGh1YgpbICA5MzUuMDMwNDEwXSB4aGNpX2hjZCAw
MDAwOjExOjAwLjA6IEhvc3Qgbm90IGhhbHRlZCBhZnRlciAxNjAwMCBtaWNyb3NlY29uZHMu
ClsgIDkzNS4wMzA0OThdIHhoY2lfaGNkIDAwMDA6MTE6MDAuMDogVVNCIGJ1cyA1IGRlcmVn
aXN0ZXJlZApbICA5MzUuMDMwNTU0XSBwY2kgMDAwMDoxMTowMC4wOiBmcmVlaW5nIHBjaV9k
ZXYgaW5mbwpbICA5MzUuMDQzNjA2XSBwY2llaHAgMDAwMDowMDoxYy43OnBjaWUwNDogcGNp
ZV9pc3I6IGludHJfbG9jIDEwOApbICA5MzUuMDQzNjE5XSBwY2llaHAgMDAwMDowMDoxYy43
OnBjaWUwNDogTGlua1N0YXRlIGNoYW5nZQpbICA5MzUuMDQzNjIyXSBwY2llaHAgMDAwMDow
MDoxYy43OnBjaWUwNDogbG5rX3N0YXR1cyA9IDcwMTEKWyAgOTM1LjA0MzYyNF0gcGNpZWhw
IDAwMDA6MDA6MWMuNzpwY2llMDQ6IFByZXNlbmNlL05vdGlmeSBpbnB1dCBjaGFuZ2UKWyAg
OTM1LjA0MzYyN10gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6IENhcmQgcHJlc2VudCBv
biBTbG90KDcpClsgIDkzNS4wNDM2MzJdIHBjaWVocCAwMDAwOjAwOjFjLjc6cGNpZTA0OiBT
dXJwcmlzZSBSZW1vdmFsClsgIDkzNS4wNDM2NDVdIHBjaWVocCAwMDAwOjAwOjFjLjc6cGNp
ZTA0OiBjaGVja19saW5rX2FjdGl2ZTogbG5rX3N0YXR1cyA9IDcwMTEKWyAgOTM1LjE0OTc5
N10gcGNpZWhwIDAwMDA6MDA6MWMuNzpwY2llMDQ6IHBjaWVocF9jaGVja19saW5rX3N0YXR1
czogbG5rX3N0YXR1cyA9IDcwMTEKWyAgOTM1LjE0OTg5MF0gcGNpIDAwMDA6MTE6MDAuMDog
WzEwMzM6MDE5NF0gdHlwZSAwMCBjbGFzcyAweDBjMDMzMApbICA5MzUuMTQ5OTQwXSBwY2kg
MDAwMDoxMTowMC4wOiByZWcgMTA6IFttZW0gMHgwMDAwMDAwMC0weDAwMDAxZmZmIDY0Yml0
XQpbICA5MzUuMTUwMTkzXSBwY2kgMDAwMDoxMTowMC4wOiBQTUUjIHN1cHBvcnRlZCBmcm9t
IEQwIEQzaG90ClsgIDkzNS4xNjk4MDldIHBjaSAwMDAwOjExOjAwLjA6IEJBUiAwOiBhc3Np
Z25lZCBbbWVtIDB4ZjZjMDAwMDAtMHhmNmMwMWZmZiA2NGJpdF0KWyAgOTM1LjE2OTg0Ml0g
cGNpZXBvcnQgMDAwMDowMDoxYy43OiBQQ0kgYnJpZGdlIHRvIFtidXMgMTEtMTZdClsgIDkz
NS4xNjk4NTVdIHBjaWVwb3J0IDAwMDA6MDA6MWMuNzogICBicmlkZ2Ugd2luZG93IFtpbyAg
MHhjMDAwLTB4ZGZmZl0KWyAgOTM1LjE2OTg2MF0gcGNpZXBvcnQgMDAwMDowMDoxYy43OiAg
IGJyaWRnZSB3aW5kb3cgW21lbSAweGY2YzAwMDAwLTB4ZjdjZmZmZmZdClsgIDkzNS4xNjk4
NjRdIHBjaWVwb3J0IDAwMDA6MDA6MWMuNzogICBicmlkZ2Ugd2luZG93IFttZW0gMHhmMDAw
MDAwMC0weGYxMGZmZmZmIDY0Yml0IHByZWZdClsgIDkzNS4xNzAwMDFdIHhoY2lfaGNkIDAw
MDA6MTE6MDAuMDogZW5hYmxpbmcgZGV2aWNlICgwMTAwIC0+IDAxMDIpClsgIDkzNS4xNzAw
NTRdIHhoY2lfaGNkIDAwMDA6MTE6MDAuMDogeEhDSSBIb3N0IENvbnRyb2xsZXIKWyAgOTM1
LjE3MDA1OV0geGhjaV9oY2QgMDAwMDoxMTowMC4wOiBuZXcgVVNCIGJ1cyByZWdpc3RlcmVk
LCBhc3NpZ25lZCBidXMgbnVtYmVyIDUKWyAgOTM1LjE3MDM0OV0geGhjaV9oY2QgMDAwMDox
MTowMC4wOiBpcnEgMTksIGlvIG1lbSAweGY2YzAwMDAwClsgIDkzNS4xNzA0NTVdIHhoY2lf
aGNkIDAwMDA6MTE6MDAuMDogaXJxIDU0IGZvciBNU0kvTVNJLVgKWyAgOTM1LjE3MDQ2OV0g
eGhjaV9oY2QgMDAwMDoxMTowMC4wOiBpcnEgNTUgZm9yIE1TSS9NU0ktWApbICA5MzUuMTcw
NDc0XSB4aGNpX2hjZCAwMDAwOjExOjAwLjA6IGlycSA1NiBmb3IgTVNJL01TSS1YClsgIDkz
NS4xNzA0ODBdIHhoY2lfaGNkIDAwMDA6MTE6MDAuMDogaXJxIDU3IGZvciBNU0kvTVNJLVgK
WyAgOTM1LjE3MDQ4Nl0geGhjaV9oY2QgMDAwMDoxMTowMC4wOiBpcnEgNTggZm9yIE1TSS9N
U0ktWApbICA5MzUuMTcwNjUyXSB1c2IgdXNiNTogTmV3IFVTQiBkZXZpY2UgZm91bmQsIGlk
VmVuZG9yPTFkNmIsIGlkUHJvZHVjdD0wMDAyClsgIDkzNS4xNzA2NTRdIHVzYiB1c2I1OiBO
ZXcgVVNCIGRldmljZSBzdHJpbmdzOiBNZnI9MywgUHJvZHVjdD0yLCBTZXJpYWxOdW1iZXI9
MQpbICA5MzUuMTcwNjU2XSB1c2IgdXNiNTogUHJvZHVjdDogeEhDSSBIb3N0IENvbnRyb2xs
ZXIKWyAgOTM1LjE3MDY1N10gdXNiIHVzYjU6IE1hbnVmYWN0dXJlcjogTGludXggMy40LjAt
cmMzLWRlZmF1bHQgeGhjaV9oY2QKWyAgOTM1LjE3MDY1OF0gdXNiIHVzYjU6IFNlcmlhbE51
bWJlcjogMDAwMDoxMTowMC4wClsgIDkzNS4xNzA3MjBdIHhIQ0kgeGhjaV9hZGRfZW5kcG9p
bnQgY2FsbGVkIGZvciByb290IGh1YgpbICA5MzUuMTcwNzIyXSB4SENJIHhoY2lfY2hlY2tf
YmFuZHdpZHRoIGNhbGxlZCBmb3Igcm9vdCBodWIKWyAgOTM1LjE3MDc0Ml0gaHViIDUtMDox
LjA6IFVTQiBodWIgZm91bmQKWyAgOTM1LjE3MDc1M10gaHViIDUtMDoxLjA6IDIgcG9ydHMg
ZGV0ZWN0ZWQKWyAgOTM1LjE3MDg1NV0geGhjaV9oY2QgMDAwMDoxMTowMC4wOiB4SENJIEhv
c3QgQ29udHJvbGxlcgpbICA5MzUuMTcwODYwXSB4aGNpX2hjZCAwMDAwOjExOjAwLjA6IG5l
dyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIgNgpbICA5MzUuMTcz
NTg3XSB1c2IgdXNiNjogTmV3IFVTQiBkZXZpY2UgZm91bmQsIGlkVmVuZG9yPTFkNmIsIGlk
UHJvZHVjdD0wMDAzClsgIDkzNS4xNzM1ODldIHVzYiB1c2I2OiBOZXcgVVNCIGRldmljZSBz
dHJpbmdzOiBNZnI9MywgUHJvZHVjdD0yLCBTZXJpYWxOdW1iZXI9MQpbICA5MzUuMTczNTkx
XSB1c2IgdXNiNjogUHJvZHVjdDogeEhDSSBIb3N0IENvbnRyb2xsZXIKWyAgOTM1LjE3MzU5
Ml0gdXNiIHVzYjY6IE1hbnVmYWN0dXJlcjogTGludXggMy40LjAtcmMzLWRlZmF1bHQgeGhj
aV9oY2QKWyAgOTM1LjE3MzU5M10gdXNiIHVzYjY6IFNlcmlhbE51bWJlcjogMDAwMDoxMTow
MC4wClsgIDkzNS4xNzM2NTddIHhIQ0kgeGhjaV9hZGRfZW5kcG9pbnQgY2FsbGVkIGZvciBy
b290IGh1YgpbICA5MzUuMTczNjU5XSB4SENJIHhoY2lfY2hlY2tfYmFuZHdpZHRoIGNhbGxl
ZCBmb3Igcm9vdCBodWIKWyAgOTM1LjE3MzY3OF0gaHViIDYtMDoxLjA6IFVTQiBodWIgZm91
bmQKWyAgOTM1LjE3MzY4OV0gaHViIDYtMDoxLjA6IDIgcG9ydHMgZGV0ZWN0ZWQK
--------------030707080001040104060403--

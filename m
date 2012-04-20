Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab2DTRWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:22:50 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:47869 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754806Ab2DTRWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:22:48 -0400
Message-ID: <4F919C22.1070608@fold.natur.cuni.cz>
Date: Fri, 20 Apr 2012 19:25:54 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120319 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec
 timeframe
References: <4F6A483D.50702@fold.natur.cuni.cz> <CAE9FiQUbzM_TVu+bbXa6LWiUt01QsFiGoyYd0qV=41dXx4J31g@mail.gmail.com> <4F8D1B72.2000105@fold.natur.cuni.cz> <CAE9FiQW2MAW_WT+sq8XVtMOx=uR8FAN8O2wL2AOxkFBfEM285g@mail.gmail.com> <CAE9FiQWSw1h772ijZ6YL4EujwjgvZ84bbDx9VbF_cdE63D-41w@mail.gmail.com> <4F8D390F.9050408@fold.natur.cuni.cz> <CAE9FiQU-_BCCS1OKagVuj8YNrut8-6GH2_i86FsfS8UDWQ1pRA@mail.gmail.com> <CAE9FiQUxoHvUWFXv5LLcBT9vVGnQKp1-Tg7M3XPPULWwtX1iUw@mail.gmail.com> <4F8EFFA3.3050705@fold.natur.cuni.cz> <CAE9FiQVcJbPub1O6nwyNsiijHFpHN0jMsGO4MmKugybPL7Wnug@mail.gmail.com> <4F8F243B.70906@fold.natur.cuni.cz> <CAE9FiQXx1NcGY9cHDiM5isx7NyxWN--Exb-4Gfj0arr6vf5ghQ@mail.gmail.com> <4F909CEB.3060407@fold.natur.cuni.cz> <CAE9FiQU7gnKiwazN_2ykbXSkcuDqWMZNt0CHiGvae2L+rTVGug@mail.gmail.com> <CAE9FiQUk8D20mEFPE0ahwfigbEOHpbRp-X0wt4DC+293msw=4Q@mail.gmail.com> <4F91473A.1080007@fold.natur.cuni.cz> <CAE9FiQUQRAfdG1J6XUVcOVkeR00vyqnCrBg1O3S_ByC3dKOUog@mail.gmail.com>
In-Reply-To: <CAE9FiQUQRAfdG1J6XUVcOVkeR00vyqnCrBg1O3S_ByC3dKOUog@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yinghai Lu wrote:
> On Fri, Apr 20, 2012 at 4:23 AM, Martin Mokrejs
> <mmokrejs@fold.natur.cuni.cz> wrote:
>> Yinghai Lu wrote:
>>> On Thu, Apr 19, 2012 at 2:48 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>>> On Thu, Apr 19, 2012 at 4:16 PM, Martin Mokrejs
>>>>> I just tried something similar under linux, with all the patches I accumulated for 3.4-rc3
>>>>> and posted in my previous emails. It seems linux flips some value so on every second card
>>>>> removal it really does realize it was just unplugged.
>>>>
>>>> that is really looks like silicon problem.
>>>>
>>> please check attached patch. Hope link change bit is flip around...
>>> if there is change, we could add some logic:
>>>    check if the device is there, or will reset link to normal state.
>>
>> I don't think it helped but maybe you will see some difference:
> 
> No, the interrupt still get delayed.
> 
>>
>> Complete dmesg is attached. OK, the "60sec" delay is when xhci_hcd gives away its attempts.
>> I am not knowlegeable of the kernel at all but it is my impression that because of the
>> card presence detection there is no way to prevent that. But, if I get it right, now when I
>> pluging the card+USB disk in it into the computer before those "60sec" it gets detected,
>> so my problem is gone (xhci cancels the timeout because a "new card" was popped in with a "new"
>> device.
>>
>> So, although I am now not sure whether I need your last patch, for the practical purpose that
>> I want to plugin a new card with a device into my computer, it works now. (added Sarah Sharp
>> into CC: just to make her aware of this scenario, no problem with xhci_hcd in my eyes)
>> ;)
> 
> please try to "safely remove the card" before removing the card physically like:
> 
> echo 1 > /sys/bus/pci/devices/0000:11:00.0/remove
> 
> that will stop the drivers and remove pci device in the kernel.

Aha.

Apr 20 19:23:15 vostro kernel: [30595.322210] pciehp 0000:00:1c.7:pcie04: lnk_status = 5011
Apr 20 19:23:15 vostro kernel: [30595.322215] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
Apr 20 19:23:15 vostro kernel: [30595.329696] xhci_hcd 0000:11:00.0: remove, state 4
Apr 20 19:23:15 vostro kernel: [30595.329705] usb usb6: USB disconnect, device number 1
Apr 20 19:23:15 vostro kernel: [30595.329865] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 20 19:23:15 vostro kernel: [30595.329869] xhci_hcd 0000:11:00.0: USB bus 6 deregistered
Apr 20 19:23:15 vostro kernel: [30595.329875] xhci_hcd 0000:11:00.0: remove, state 4
Apr 20 19:23:15 vostro kernel: [30595.329879] usb usb5: USB disconnect, device number 1
Apr 20 19:23:15 vostro kernel: [30595.330071] xhci_hcd 0000:11:00.0: Host not halted after 16000 microseconds.
Apr 20 19:23:15 vostro kernel: [30595.330170] xhci_hcd 0000:11:00.0: USB bus 5 deregistered
Apr 20 19:23:15 vostro kernel: [30595.338471] pciehp 0000:00:1c.7:pcie04: lnk_status = 7011
Apr 20 19:23:15 vostro kernel: [30595.338486] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
Apr 20 19:23:15 vostro kernel: [30595.459499] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
Apr 20 19:23:15 vostro kernel: [30595.459542] pcieport 0000:00:1c.7: PCI bridge to [bus 11-16]
Apr 20 19:23:15 vostro kernel: [30595.459545] pcieport 0000:00:1c.7:   bridge window [io  0xc000-0xdfff]
Apr 20 19:23:15 vostro kernel: [30595.459550] pcieport 0000:00:1c.7:   bridge window [mem 0xf6c00000-0xf7cfffff]
Apr 20 19:23:15 vostro kernel: [30595.459554] pcieport 0000:00:1c.7:   bridge window [mem 0xf0000000-0xf10fffff 64bit pref]
Apr 20 19:23:15 vostro kernel: [30595.459688] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
Apr 20 19:23:15 vostro kernel: [30595.459894] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 19:23:15 vostro kernel: [30595.459900] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
Apr 20 19:23:15 vostro kernel: [30595.460199] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
Apr 20 19:23:15 vostro kernel: [30595.460472] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
Apr 20 19:23:15 vostro kernel: [30595.460474] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 19:23:15 vostro kernel: [30595.460475] usb usb5: Product: xHCI Host Controller
Apr 20 19:23:15 vostro kernel: [30595.460476] usb usb5: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 19:23:15 vostro kernel: [30595.460477] usb usb5: SerialNumber: 0000:11:00.0
Apr 20 19:23:15 vostro kernel: [30595.460600] hub 5-0:1.0: USB hub found
Apr 20 19:23:15 vostro kernel: [30595.460611] hub 5-0:1.0: 2 ports detected
Apr 20 19:23:15 vostro kernel: [30595.460706] xhci_hcd 0000:11:00.0: xHCI Host Controller
Apr 20 19:23:15 vostro kernel: [30595.460711] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
Apr 20 19:23:15 vostro kernel: [30595.463431] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
Apr 20 19:23:15 vostro kernel: [30595.463433] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Apr 20 19:23:15 vostro kernel: [30595.463434] usb usb6: Product: xHCI Host Controller
Apr 20 19:23:15 vostro kernel: [30595.463435] usb usb6: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
Apr 20 19:23:15 vostro kernel: [30595.463437] usb usb6: SerialNumber: 0000:11:00.0
Apr 20 19:23:15 vostro kernel: [30595.463534] hub 6-0:1.0: USB hub found
Apr 20 19:23:15 vostro kernel: [30595.463547] hub 6-0:1.0: 2 ports detected

echo 1 > /sys/bus/pci/devices/0000:11:00.0/remove

Apr 20 19:23:27 vostro kernel: [30607.046714] xhci_hcd 0000:11:00.0: remove, state 4
Apr 20 19:23:27 vostro kernel: [30607.046719] usb usb6: USB disconnect, device number 1
Apr 20 19:23:27 vostro kernel: [30607.065341] xhci_hcd 0000:11:00.0: USB bus 6 deregistered
Apr 20 19:23:27 vostro kernel: [30607.065350] xhci_hcd 0000:11:00.0: remove, state 4
Apr 20 19:23:27 vostro kernel: [30607.065353] usb usb5: USB disconnect, device number 1
Apr 20 19:23:27 vostro kernel: [30607.065692] xhci_hcd 0000:11:00.0: USB bus 5 deregistered

removing the card

Apr 20 19:23:36 vostro kernel: [30616.630816] pciehp 0000:00:1c.7:pcie04: lnk_status = 5011
Apr 20 19:23:36 vostro kernel: [30616.630820] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)

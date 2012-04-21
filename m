Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2DUJKT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:10:19 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:34206 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752666Ab2DUJKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:10:17 -0400
Message-ID: <4F927A16.1010908@fold.natur.cuni.cz>
Date: Sat, 21 Apr 2012 11:12:54 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120319 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
CC: Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec
 timeframe
References: <4F8F243B.70906@fold.natur.cuni.cz> <CAE9FiQXx1NcGY9cHDiM5isx7NyxWN--Exb-4Gfj0arr6vf5ghQ@mail.gmail.com> <4F909CEB.3060407@fold.natur.cuni.cz> <CAE9FiQU7gnKiwazN_2ykbXSkcuDqWMZNt0CHiGvae2L+rTVGug@mail.gmail.com> <CAE9FiQUk8D20mEFPE0ahwfigbEOHpbRp-X0wt4DC+293msw=4Q@mail.gmail.com> <4F91473A.1080007@fold.natur.cuni.cz> <CAE9FiQUQRAfdG1J6XUVcOVkeR00vyqnCrBg1O3S_ByC3dKOUog@mail.gmail.com> <4F919C22.1070608@fold.natur.cuni.cz> <4F919CD5.7070004@fold.natur.cuni.cz> <CAE9FiQV_cRTDTBmQwNLJtT-N=HTAxBiphBLDmKxM-N0JKyoR-w@mail.gmail.com> <20120420231748.GB7069@xanatos> <CAE9FiQX7JCZvL9S8ZOQQaHQ4nfU0XDj=8FmOfCtcz7WFjP8=Bg@mail.gmail.com> <CAE9FiQWLmiqg_8PQXYsccxqrvwEp5zhGLcEpsN-nAJq=1zTZ7Q@mail.gmail.com> <4F927787.409@fold.natur.cuni.cz>
In-Reply-To: <4F927787.409@fold.natur.cuni.cz>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Martin Mokrejs wrote:
> 
> 
> Yinghai Lu wrote:
>> On Fri, Apr 20, 2012 at 5:09 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>>> What do you mean "strange power state"?  The only PCI power states the
>>>> xHCI driver will use is D0 or D3hot.  D3hot is entered automatically by
>>>> the USB core runtime PM system when all USB devices are disconnected or
>>>> suspended.  So what strange power state are we talking about?
>>>
>>> that's helpful. Can that feature to be disabled?
>>
>> please check and set
>> /sys/bus/pci/devices/0000:11:00.0/power/control
>> /sys/bus/pci/devices/0000:11:00.0/usb?/power/control
>> from auto to on
> 
> I inserted the card, it was detected:
> 
> [33335.295737] pci 0000:11:00.0: [1033:0194] type 00 class 0x0c0330
> [33335.295789] pci 0000:11:00.0: reg 10: [mem 0x00000000-0x00001fff 64bit]
> [33335.296043] pci 0000:11:00.0: PME# supported from D0 D3hot
> [33335.315688] pci 0000:11:00.0: BAR 0: assigned [mem 0xf6c00000-0xf6c01fff 64bit]
> [33335.315796] xhci_hcd 0000:11:00.0: enabling device (0100 -> 0102)
> [33335.315893] xhci_hcd 0000:11:00.0: xHCI Host Controller
> [33335.315897] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 5
> [33335.316178] xhci_hcd 0000:11:00.0: irq 19, io mem 0xf6c00000
> [33335.316281] xhci_hcd 0000:11:00.0: irq 53 for MSI/MSI-X
> [33335.316285] xhci_hcd 0000:11:00.0: irq 54 for MSI/MSI-X
> [33335.316288] xhci_hcd 0000:11:00.0: irq 55 for MSI/MSI-X
> [33335.316292] xhci_hcd 0000:11:00.0: irq 56 for MSI/MSI-X
> [33335.316296] xhci_hcd 0000:11:00.0: irq 57 for MSI/MSI-X
> [33335.316447] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
> [33335.316448] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [33335.316450] usb usb5: Product: xHCI Host Controller
> [33335.316451] usb usb5: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
> [33335.316452] usb usb5: SerialNumber: 0000:11:00.0
> [33335.316574] xHCI xhci_add_endpoint called for root hub
> [33335.316575] xHCI xhci_check_bandwidth called for root hub
> [33335.316597] hub 5-0:1.0: USB hub found
> [33335.316609] hub 5-0:1.0: 2 ports detected
> [33335.316680] xhci_hcd 0000:11:00.0: xHCI Host Controller
> [33335.316683] xhci_hcd 0000:11:00.0: new USB bus registered, assigned bus number 6
> [33335.319424] usb usb6: New USB device found, idVendor=1d6b, idProduct=0003
> [33335.319426] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [33335.319428] usb usb6: Product: xHCI Host Controller
> [33335.319429] usb usb6: Manufacturer: Linux 3.4.0-rc3-default xhci_hcd
> [33335.319430] usb usb6: SerialNumber: 0000:11:00.0
> [33335.319560] xHCI xhci_add_endpoint called for root hub
> [33335.319562] xHCI xhci_check_bandwidth called for root hub
> [33335.319584] hub 6-0:1.0: USB hub found
> [33335.319602] hub 6-0:1.0: 2 ports detected
> 
> # cat /sys/bus/pci/devices/0000:11:00.0/power/control
> on
> # cat /sys/bus/pci/devices/0000:11:00.0/usb?/power/control
> auto
> auto
> # echo on > /sys/bus/pci/devices/0000:11:00.0/usb5/power/control
> # echo on > /sys/bus/pci/devices/0000:11:00.0/usb6/power/control
> #
> 
> I removed the card and it was NOT detected.
> 
> Note: I did the test with the running instance of kernel booted WITH pcie_aspm=off.
> Will reboot without tha option and re-try.

Same values in sysfs files, same result.

Martin

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970Ab1LPP0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 10:26:00 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56235 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826Ab1LPPZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 10:25:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAH9NwWfN8E5vZbpTGDySnT9VJ+3_-nuK1EAbaLVg7u4xZRLfkA@mail.gmail.com>
References: <CAH9NwWetBZvU6-16rV_s5n=vrAu1kyfsbsjKh+6O2ejf9mM_ww@mail.gmail.com>
 <CAErSpo4mbdaT1e2KmS2JjP1FFKfZDToXzgkb+Na_ejoo+t8snQ@mail.gmail.com> <CAH9NwWfN8E5vZbpTGDySnT9VJ+3_-nuK1EAbaLVg7u4xZRLfkA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 16 Dec 2011 08:25:34 -0700
Message-ID: <CAErSpo627xrofs=w2nTzp-6EJzcqxbdz-agHtYY4JLLns3hmvw@mail.gmail.com>
Subject: Re: PCI(e) enumeration
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 6:13 AM, Christian Gmeiner
<christian.gmeiner@gmail.com> wrote:
> Hi Bjorn,
>
> 2011/12/15 Bjorn Helgaas <bhelgaas@google.com>:
>> On Thu, Dec 15, 2011 at 2:41 AM, Christian Gmeiner
>> <christian.gmeiner@gmail.com> wrote:
>>> Hi all,
>>>
>>> I maintain a debian based linux RFS in my company and my college does the
>>> same for windows. Now we run into a problem that windows and linux use a
>>> different network interface as eth0. In our target system there
>>> are two identical NICs installed.
>>>
>>> So I am now looking to find out, how linux does the PCI enumeration
>>> and in which order
>>> the PCI driver gets called to do the initialization. Can somebody tell
>>> me if a depth-first search
>>> or a breadth-first search is done on the PCI bus.
>>>
>>>
>>> For instance look at this lspci output:
>>>
>>> 00:01.0 Host bridge: Advanced Micro Devices [AMD] CS5536 [Geode
>>> companion] Host Bridge (rev 33)
>>> 00:01.1 VGA compatible controller: Advanced Micro Devices [AMD] Geode LX Video
>>> 00:01.2 Entertainment encryption device: Advanced Micro Devices [AMD]
>>> Geode LX AES Security Block
>>> 00:04.0 Ethernet controller: Intel Corporation 8255xER/82551IT Fast
>>> Ethernet Controller (rev 10)
>>> 00:0f.0 ISA bridge: Advanced Micro Devices [AMD] CS5536 [Geode
>>> companion] ISA (rev 03)
>>> 00:0f.2 IDE interface: Advanced Micro Devices [AMD] CS5536 [Geode
>>> companion] IDE (rev 01)
>>> 00:0f.3 Multimedia audio controller: Advanced Micro Devices [AMD]
>>> CS5536 [Geode companion] Audio (rev 01)
>>> 00:0f.4 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode
>>> companion] OHC (rev 02)
>>> 00:0f.5 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode
>>> companion] EHC (rev 02)
>>> 00:0f.7 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode
>>> companion] UOC (rev 02)
>>>
>>> How will linux does the enumeration?
>>
>> The kernel enumerates PCI devices with a depth-first traversal, but
>> that isn't what determines the ethX device name.  That name is
>> determined by the order in which network drivers are loaded and claim
>> devices, which gets into distro details like udev.
>>
>> Here's a nice paper with more details:
>> http://www.dell.com/downloads/global/power/ps1q07-20060392-Domsch.pdf
>
> Thanks
>
>>
>> If that's not enough to solve your problem, a debian-related forum
>> will probably be more useful than LKML.
>
> I don't think that this is a debian related issue, as I use no special
> udev rule. Here is the lscpi
> output of the target machine, where I have this issue.
>
>
> root@OT1300:~# lspci
> 00:00.0 Host bridge: Intel Corporation Atom Processor E6xx PCI Host
> Bridge #1 (rev 05)
> 00:01.0 Host bridge: Intel Corporation Atom Processor E6xx
> Configuration Unit (rev 02)
> 00:02.0 VGA compatible controller: Intel Corporation Atom Processor
> E6xx Integrated Graphics Controller (rev 05)
> 00:03.0 Multimedia video controller: Intel Corporation Atom Processor
> E6xx Integrated Graphics Controller (rev 02)
> 00:17.0 PCI bridge: Intel Corporation Atom Processor E6xx PCI Express
> Port 1 (rev 02)
> 00:18.0 PCI bridge: Intel Corporation Atom Processor E6xx PCI Express
> Port 2 (rev 02)
> 00:19.0 PCI bridge: Intel Corporation Atom Processor E6xx PCI Express
> Port 3 (rev 02)
> 00:1a.0 PCI bridge: Intel Corporation Atom Processor E6xx PCI Express
> Port 4 (rev 02)
> 00:1f.0 ISA bridge: Intel Corporation Atom Processor E6xx LPC Bridge (rev 02)
> 01:00.0 PCI bridge: Intel Corporation Platform Controller Hub EG20T
> PCI Express Port (rev 01)
> 02:00.0 Unassigned class [ff00]: Intel Corporation Platform Controller
> Hub EG20T Packet Hub (rev 01)
> 02:00.1 Ethernet controller: Intel Corporation Platform Controller Hub
> EG20T Gigabit Ethernet Controller (rev 02)
> 02:00.2 Unassigned class [ff00]: Intel Corporation Platform Controller
> Hub EG20T General Purpose IO Controller (rev 01)
> 02:02.0 USB Controller: Intel Corporation Platform Controller Hub
> EG20T USB OHCI Controller #4 (rev 02)
> 02:02.1 USB Controller: Intel Corporation Platform Controller Hub
> EG20T USB OHCI Controller #5 (rev 02)
> 02:02.2 USB Controller: Intel Corporation Platform Controller Hub
> EG20T USB OHCI Controller #6 (rev 02)
> 02:02.3 USB Controller: Intel Corporation Platform Controller Hub
> EG20T USB2 EHCI Controller #2 (rev 02)
> 02:02.4 USB Controller: Intel Corporation Platform Controller Hub
> EG20T USB Client Controller (rev 02)
> 02:04.0 SD Host controller: Intel Corporation Platform Controller Hub
> EG20T SDIO Controller #1 (rev 01)
> 02:04.1 SD Host controller: Intel Corporation Platform Controller Hub
> EG20T SDIO Controller #2 (rev 01)
> 02:06.0 SATA controller: Intel Corporation Platform Controller Hub
> EG20T SATA AHCI Controller (rev 02)
> 02:08.0 USB Controller: Intel Corporation Platform Controller Hub
> EG20T USB OHCI Controller #1 (rev 02)
> 02:08.1 USB Controller: Intel Corporation Platform Controller Hub
> EG20T USB OHCI Controller #2 (rev 02)
> 02:08.2 USB Controller: Intel Corporation Platform Controller Hub
> EG20T USB OHCI Controller #3 (rev 02)
> 02:08.3 USB Controller: Intel Corporation Platform Controller Hub
> EG20T USB2 EHCI Controller #1 (rev 02)
> 02:0a.0 Unassigned class [ff00]: Intel Corporation Platform Controller
> Hub EG20T DMA Controller #1
> 02:0a.1 Serial controller: Intel Corporation Platform Controller Hub
> EG20T UART Controller 0 (rev 01)
> 02:0a.2 Serial controller: Intel Corporation Platform Controller Hub
> EG20T UART Controller 1
> 02:0a.3 Serial controller: Intel Corporation Platform Controller Hub
> EG20T UART Controller 2
> 02:0a.4 Serial controller: Intel Corporation Platform Controller Hub
> EG20T UART Controller 3
> 02:0c.0 Unassigned class [ff00]: Intel Corporation Platform Controller
> Hub EG20T DMA Controller #2
> 02:0c.1 Serial bus controller [0c80]: Intel Corporation Platform
> Controller Hub EG20T Serial Peripheral Interface Bus
> 02:0c.2 Serial bus controller [0c80]: Intel Corporation Platform
> Controller Hub EG20T I2C Controller
> 02:0c.3 CANBUS: Intel Corporation Platform Controller Hub EG20T
> Controller Area Network (CAN) Controller
> 02:0c.4 Unassigned class [ff00]: Intel Corporation Platform Controller
> Hub EG20T IEEE 1588 Hardware Assist (rev 01)
> 03:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
> 05:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
>
>
> The two important lines are these ones:
>
> 03:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
> 05:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
>
>
> As you can see we have two equal network controllers, which both are using the
> e1000e driver. In this case I think that the driver gets first control
> over 03:00.0
> and then over 05:00.0.
>
> So it is the case that
> - 03:00.0 is eth0
> - 05:00.0 is eth1
>
> To sum it up, if there are two devices handled by the same driver the
> device, which is
> higher in the pci bus, will become eth0. Or?

For devices handled by the same driver, they are claimed in the order
the devices are enumerated by the kernel, which does a depth-first
search.  Your lspci doesn't show the actual hierarchy, but it sounds
like we enumerate 03:00.0 first.

The "pci=bfsort" kernel option might be useful.

Bjorn

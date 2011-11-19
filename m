Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1KSS2P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 13:28:15 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:45044 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab1KSS2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 13:28:13 -0500
Message-ID: <4EC7F51F.6000004@linux.vnet.ibm.com>
Date: Sat, 19 Nov 2011 23:57:43 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: =?UTF-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
CC: Szymon Janc <szymon@janc.net.pl>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [REGRESSION] resume takes 10s longer due to e1b6eb3 (Bluetooth:
 Increase HCI reset timeout ...)
References: <20111118184017.GA5052@nomi.cz>
In-Reply-To: <20111118184017.GA5052@nomi.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 11111908-5490-0000-0000-000000275D1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Adding linux-pm mailing list to CC as well. ]

Thanks,
Srivatsa S. Bhat

On 11/19/2011 12:10 AM, Tomáš Janoušek wrote:
> Hello,
> 
> while testing the 3.2-rc kernel, I experienced that resume takes 10 seconds
> more than usual, and bisected this to be caused by e1b6eb3 (Bluetooth:
> Increase HCI reset timeout in hci_dev_do_close).
> 
> My hardware is Lenovo ThinkPad T420, model number 4178-A3G, with a Broadcom
> Bluetooth adapter (I'm attaching the relevant part of lsusb).
> 
> The relevant portion of dmesg is:
> [   76.502818] usb 1-1.4: reset full-speed USB device number 4 using ehci_hcd
> [   76.588225] btusb 1-1.4:1.0: no reset_resume for driver btusb?
> [   76.591870] btusb 1-1.4:1.1: no reset_resume for driver btusb?
> [   86.565269] PM: resume of devices complete after 10486.220 msecs
> 
> My resume scripts did contain a hciconfig hci0 down followed by up, because
> on my previous notebook (and the kernel I used at the time) it was needed for
> BT to work after suspend. On this hardware, however, none of that is needed.
> Bluetooth after suspend works regardless of whether that patch is applied or
> not, and I believe it would wait indefinitely if given large enough timeout.
> 
> Aside from reverting the patch, doing the following before suspend also works
> around the issue:
>     echo disable > /proc/acpi/ibm/bluetooth
> 
> Kind regards,
> -- Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
> 
> 
> bt.txt
> 
> 
> Bus 001 Device 006: ID 0a5c:217f Broadcom Corp. Bluetooth Controller
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass          224 Wireless
>   bDeviceSubClass         1 Radio Frequency
>   bDeviceProtocol         1 Bluetooth
>   bMaxPacketSize0        64
>   idVendor           0x0a5c Broadcom Corp.
>   idProduct          0x217f Bluetooth Controller
>   bcdDevice            7.48
>   iManufacturer           1 Broadcom Corp
>   iProduct                2 Broadcom Bluetooth Device
>   iSerial                 3 CCAF78EC8B4F
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength          216
>     bNumInterfaces          4
>     bConfigurationValue     1
>     iConfiguration          0 
>     bmAttributes         0xe0
>       Self Powered
>       Remote Wakeup
>     MaxPower                0mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           3
>       bInterfaceClass       224 Wireless
>       bInterfaceSubClass      1 Radio Frequency
>       bInterfaceProtocol      1 Bluetooth
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0010  1x 16 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass       224 Wireless
>       bInterfaceSubClass      1 Radio Frequency
>       bInterfaceProtocol      1 Bluetooth
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0000  1x 0 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0000  1x 0 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       1
>       bNumEndpoints           2
>       bInterfaceClass       224 Wireless
>       bInterfaceSubClass      1 Radio Frequency
>       bInterfaceProtocol      1 Bluetooth
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0009  1x 9 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0009  1x 9 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       2
>       bNumEndpoints           2
>       bInterfaceClass       224 Wireless
>       bInterfaceSubClass      1 Radio Frequency
>       bInterfaceProtocol      1 Bluetooth
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0011  1x 17 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0011  1x 17 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       3
>       bNumEndpoints           2
>       bInterfaceClass       224 Wireless
>       bInterfaceSubClass      1 Radio Frequency
>       bInterfaceProtocol      1 Bluetooth
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0020  1x 32 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0020  1x 32 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       4
>       bNumEndpoints           2
>       bInterfaceClass       224 Wireless
>       bInterfaceSubClass      1 Radio Frequency
>       bInterfaceProtocol      1 Bluetooth
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       5
>       bNumEndpoints           2
>       bInterfaceClass       224 Wireless
>       bInterfaceSubClass      1 Radio Frequency
>       bInterfaceProtocol      1 Bluetooth
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            1
>           Transfer Type            Isochronous
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        2
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0020  1x 32 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x04  EP 4 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0020  1x 32 bytes
>         bInterval               1
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        3
>       bAlternateSetting       0
>       bNumEndpoints           0
>       bInterfaceClass       254 Application Specific Interface
>       bInterfaceSubClass      1 Device Firmware Update
>       bInterfaceProtocol      1 
>       iInterface              0 
>       Device Firmware Upgrade Interface Descriptor:
>         bLength                             7
>         bDescriptorType                    33
>         bmAttributes                        7
>           Will Not Detach
>           Manifestation Tolerant
>           Upload Supported
>           Download Supported
>         wDetachTimeout                   5000 milliseconds
>         wTransferSize                      64 bytes
> Device Status:     0x0001
>   Self Powered
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab1E3TdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 15:33:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42428 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab1E3Tc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 15:32:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nUcXS4hFjYbhVQv2wJ/+xl+iaCQOwZJiUZDhrZY9V21QWOKulIhEsAbAble+5MnEsi
         f4DBl4jk+tQeBe7ObB3f5px37NMUTsDb0IUmKy6adRM2KT0X29fwrAllRM91X81wgRmz
         XjNYcfB7y9vMm/U/DhGBgs5dDThSGf+7KnobY=
Message-ID: <4DE3F0E6.6030507@gmail.com>
Date: Mon, 30 May 2011 21:32:54 +0200
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110516 Icedove/3.1.10
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oliver Neukum <oliver@neukum.name>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2.6.39] crash in acm_ctrl_msg+0x16/0x59
References: <4DE25252.7050503@gmail.com> <201105300754.14490.oneukum@suse.de> <4DE36118.4050706@gmail.com>
In-Reply-To: <4DE36118.4050706@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/05/2011 11:19, Riccardo Magliocchetti ha scritto:
> Hi,
>
> Il 30/05/2011 07:54, Oliver Neukum ha scritto:
>> Am Sonntag, 29. Mai 2011, 16:04:02 schrieb Riccardo Magliocchetti:
>>
>>> mtp-probe: bus: 6, device: 4 was not an MTP device
>>> [20462.901834] cdc_acm 6-1:1.0: ttyACM0: USB ACM device
>>> [20462.904417] usbcore: registered new interface driver cdc_acm
>>> [20462.904420] cdc_acm: v0.26:USB Abstract Control Model driver for USB
>>> modems and ISDN adapters
>>> [20463.624142] usb 6-1: USB disconnect, device number 4
>>> [20463.641859] CPU 0
>>>
>>> This is the stracktrace:
>>>
>>> acm_ctrl_msg+0x16/0x59
>>> mutex_lock+0x13/0x2a
>>> acm_port_down+0x4c/0xcb
>>> acm_tty_close+0x75/0x93
>>> tty_release+0x1b5/0x47c
>>> ? compat_do_readv_write+0x199/0x1ae
>>> fput+0xf8/0x1ad
>>> filp_close+0x69/0x75
>>> sys_close+0x8a/0xea
>>> sysenter_dispatch+0x07/0x32
>>
>> So we are trying to talk to a device that is already gone.
>> Is there anything unusual about your device? Could you
>> post "lsusb -v"?
>
> Yes, the unusual thing is that is very prone to freezing when booting,
> in fact it freezed when i got the crash in the laptop. Will post lsusb
> output later in the day.

Here's the lsusb -v

Bus 006 Device 003: ID 1457:5122 First International Computer, Inc. 
OpenMoko Neo1973 / Neo Freerunner kernel cdc_ether USB network
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            2 Communications
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         8
   idVendor           0x1457 First International Computer, Inc.
   idProduct          0x5122 OpenMoko Neo1973 / Neo Freerunner kernel 
cdc_ether USB network
   bcdDevice            3.12
   iManufacturer           1 Linux 2.6.29-20100313.git973a41fc with 
s3c2410_ud
   iProduct                2 RNDIS/Ethernet Gadget
   iSerial                 0
   bNumConfigurations      2
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           67
     bNumInterfaces          2
     bConfigurationValue     2
     iConfiguration          0
     bmAttributes         0xc0
       Self Powered
     MaxPower              500mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         2 Communications
       bInterfaceSubClass      2 Abstract (modem)
       bInterfaceProtocol    255 Vendor Specific (MSFT RNDIS?)
       iInterface              3 RNDIS Communications Control
       CDC Header:
         bcdCDC               1.10
       CDC Call Management:
         bmCapabilities       0x00
         bDataInterface          1
       CDC ACM:
         bmCapabilities       0x00
       CDC Union:
         bMasterInterface        0
         bSlaveInterface         1
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0008  1x 8 bytes
         bInterval              32
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       0
       bNumEndpoints           2
       bInterfaceClass        10 CDC Data
       bInterfaceSubClass      0 Unused
       bInterfaceProtocol      0
       iInterface              4 RNDIS Ethernet Data
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           80
     bNumInterfaces          2
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xc0
       Self Powered
     MaxPower              500mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         2 Communications
       bInterfaceSubClass      6 Ethernet Networking
       bInterfaceProtocol      0
       iInterface              5 CDC Ethernet Control Model (ECM)
       CDC Header:
         bcdCDC               1.10
       CDC Union:
         bMasterInterface        0
         bSlaveInterface         1
       CDC Ethernet:
         iMacAddress                      7 DA51BC59708F
         bmEthernetStatistics    0x00000000
         wMaxSegmentSize               1514
         wNumberMCFilters            0x0000
         bNumberPowerFilters              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0010  1x 16 bytes
         bInterval              32
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass        10 CDC Data
       bInterfaceSubClass      0 Unused
       bInterfaceProtocol      0
       iInterface              0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       1
       bNumEndpoints           2
       bInterfaceClass        10 CDC Data
       bInterfaceSubClass      0 Unused
       bInterfaceProtocol      0
       iInterface              6 CDC Ethernet Data
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
Device Status:     0x0001
   Self Powered

thanks,
riccardo

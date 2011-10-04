Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab1JDKcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 06:32:35 -0400
Received: from mailout06.t-online.de ([194.25.134.19]:40807 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab1JDKce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 06:32:34 -0400
Message-ID: <4E8AE0BC.70203@t-online.de>
Date: Tue, 04 Oct 2011 12:32:28 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG: kernel 3.0.4] Hard lockup / NULL pointer reference USB
 / BLOCK Layer
References: <4E89E374.8020804@t-online.de> <20111003233216.GA30470@suse.de>
In-Reply-To: <20111003233216.GA30470@suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: E2nvgGZCZhJhrhO8MBQWreasaQ+MMMZk4wYKaFukKJkknTXnjtaql+TmkCO7mfXg73
X-TOI-MSGID: d7c10a50-7e83-49c5-9207-45e10d4414b6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.10.2011 01:32, schrieb Greg KH:
> On Mon, Oct 03, 2011 at 06:31:48PM +0200, Knut Petersen wrote:
>> Hi everybody!
>>
>> I connected two USB flash drives and tried to erase them using dd:
>>
>> dd if=/dev/zero of=/dev/sdc bs=65536
>> dd if=/dev/zero of=/dev/sdd bs=65536
>>
>> I left the machine for some hours and found it completely locked
>> on return. No reaction to the keybard, network access impossible.
>> A hard reboot was necessary.
>>
>> Attached find the relevant part of /var/log/messages and the configuration
>> of the kernel used.
> Can you please try 3.0.6 which is now out?  There is a USB/block layer
> fix in it.
>
> thanks,
>
> greg k-h
>

Well ... that´s not possible now as that problem presumably killed one of the two USB flash drives.

Both were brand new identical drives, and identified themselves as flash drives made by Feiya.

Linux (openSuSE 11.4 with kernel 3.0.4 and Xorg git-master) accepted them both.

One of them still works and lsusb -v gives the following information:
===================================================

Bus 001 Device 002: ID 090c:1000 Feiya Technology Corp. Flash Drive
Device Descriptor:
bLength 18
bDescriptorType 1
bcdUSB 2.00
bDeviceClass 0 (Defined at Interface level)
bDeviceSubClass 0
bDeviceProtocol 0
bMaxPacketSize0 64
idVendor 0x090c Feiya Technology Corp.
idProduct 0x1000 Flash Drive
bcdDevice 10.00
iManufacturer 1 SMI Technology
iProduct 2 Intenso Premium Line
iSerial 3 11060300008139
bNumConfigurations 1
Configuration Descriptor:
bLength 9
bDescriptorType 2
wTotalLength 32
bNumInterfaces 1
bConfigurationValue 1
iConfiguration 0
bmAttributes 0x80
(Bus Powered)
MaxPower 200mA
Interface Descriptor:
bLength 9
bDescriptorType 4
bInterfaceNumber 0
bAlternateSetting 0
bNumEndpoints 2
bInterfaceClass 8 Mass Storage
bInterfaceSubClass 6 SCSI
bInterfaceProtocol 80 Bulk (Zip)
iInterface 0
Endpoint Descriptor:
bLength 7
bDescriptorType 5
bEndpointAddress 0x81 EP 1 IN
bmAttributes 2
Transfer Type Bulk
Synch Type None
Usage Type Data
wMaxPacketSize 0x0200 1x 512 bytes
bInterval 255
Endpoint Descriptor:
bLength 7
bDescriptorType 5
bEndpointAddress 0x02 EP 2 OUT
bmAttributes 2
Transfer Type Bulk
Synch Type None
Usage Type Data
wMaxPacketSize 0x0200 1x 512 bytes
bInterval 255
Device Qualifier (for other device speed):
bLength 10
bDescriptorType 6
bcdUSB 2.00
bDeviceClass 0 (Defined at Interface level)
bDeviceSubClass 0
bDeviceProtocol 0
bMaxPacketSize0 64
bNumConfigurations 1
Device Status: 0x0000
(Bus Powered)

The second one mutated:
===================
Bus 001 Device 003: ID 090c:3000 Feiya Technology Corp.
Device Descriptor:
bLength 18
bDescriptorType 1
bcdUSB 2.00
bDeviceClass 0 (Defined at Interface level)
bDeviceSubClass 0
bDeviceProtocol 0
bMaxPacketSize0 64
idVendor 0x090c Feiya Technology Corp.
idProduct 0x3000
bcdDevice 1.00
iManufacturer 1 Silicon Motion,Inc.
iProduct 2 SM3255AA MEMORY BAR
iSerial 0
bNumConfigurations 1
Configuration Descriptor:
bLength 9
bDescriptorType 2
wTotalLength 32
bNumInterfaces 1
bConfigurationValue 1
iConfiguration 0
bmAttributes 0x80
(Bus Powered)
MaxPower 100mA
Interface Descriptor:
bLength 9
bDescriptorType 4
bInterfaceNumber 0
bAlternateSetting 0
bNumEndpoints 2
bInterfaceClass 8 Mass Storage
bInterfaceSubClass 6 SCSI
bInterfaceProtocol 80 Bulk (Zip)
iInterface 0
Endpoint Descriptor:
bLength 7
bDescriptorType 5
bEndpointAddress 0x81 EP 1 IN
bmAttributes 2
Transfer Type Bulk
Synch Type None
Usage Type Data
wMaxPacketSize 0x0200 1x 512 bytes
bInterval 255
Endpoint Descriptor:
bLength 7
bDescriptorType 5
bEndpointAddress 0x02 EP 2 OUT
bmAttributes 2
Transfer Type Bulk
Synch Type None
Usage Type Data
wMaxPacketSize 0x0200 1x 512 bytes
bInterval 255
Device Qualifier (for other device speed):
bLength 10
bDescriptorType 6
bcdUSB 2.00
bDeviceClass 0 (Defined at Interface level)
bDeviceSubClass 0
bDeviceProtocol 0
bMaxPacketSize0 64
bNumConfigurations 1
Device Status: 0x0000
(Bus Powered)

Differences between the lsusb -v outputs:
===============================
knut@golem:~> diff lsusb-v-ok lsusb-v-bad
1c1
< Bus 001 Device 002: ID 090c:1000 Feiya Technology Corp. Flash Drive
---
 > Bus 001 Device 003: ID 090c:3000 Feiya Technology Corp.
11,15c11,15
< idProduct 0x1000 Flash Drive
< bcdDevice 10.00
< iManufacturer 1 SMI Technology
< iProduct 2 Intenso Premium Line
< iSerial 3 11060300008139
---
 > idProduct 0x3000
 > bcdDevice 1.00
 > iManufacturer 1 Silicon Motion,Inc.
 > iProduct 2 SM3255AA MEMORY BAR
 > iSerial 0
26c26
< MaxPower 200mA
---
 > MaxPower 100mA


So the second one does need less power and changed idProduct etc.
It´s no longer the flash drive that was accepted but a "memory bar":

[ 7628.496478] usb 1-2: Product: SM3255AA MEMORY BAR
[ 7628.496485] usb 1-2: Manufacturer: Silicon Motion,Inc.
[ 7628.508075] scsi3 : usb-storage 1-2:1.0
[ 7629.513289] scsi 3:0:0:0: Direct-Access USB MEMORY BAR 1000 PQ: 0 ANSI: 0 CCS
[ 7629.514374] sd 3:0:0:0: Attached scsi generic sg1 type 0
[ 7629.518569] sd 3:0:0:0: [sdb] Attached SCSI removable disk

fdisk -l does not know anything about that disk, and dd fails to write:
====================================================
linux-iffr:~ #
dd: öffne „/dev/sdb“: Kein Medium gefunden


linux-iffr:~ # dd if=/dev/zero of=/dev/sg1 bs=65536
dd: Schreiben von „/dev/sg1“: Das numerische Argument ist außerhalb des Definitionsbereiches
2+0 Datensätze ein
1+0 Datensätze aus
65536 Bytes (66 kB) kopiert, 0,00308981 s, 21,2 MB/s

Both 3.0.4 and 3.0.6 were two times able to write to the flash drive that still identifies
itself as a flash drive without problems with dd if=/dev/zero of=/dev/sda bs=65536.

Conclusion: Either there is/was a problem with massive parallel writes to at least two
usb (flash) drives, or there is a problem with one of the flash drives itself.

Any idea how to make a flash drive from that "memory bar"?

cu,
Knut


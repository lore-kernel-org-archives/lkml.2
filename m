Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab0JKTfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 15:35:51 -0400
Received: from shell4.bayarea.net ([209.128.82.1]:42209 "EHLO
	shell4.bayarea.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab0JKTfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 15:35:42 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Oct 2010 15:35:42 EDT
Message-ID: <4CB365FC.5010603@bayarea.net>
Date: Mon, 11 Oct 2010 20:31:08 +0100
From: Robert Gadsdon <rgadsdon@bayarea.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linux-USB <linux-usb-devel@lists.sourceforge.net>
Subject: PDA (Clie) USB sync fails with 2.6.25, OK with 2.6.34.1. versions
 of visor.c visor.h
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sony Clie USB sync (Jpilot and Kpilot) has been OK for years, but since 
2.6.35 (and 2.6.35.6) has failed.
2.6.34.1 (and earlier) works OK.
With 2.6.35, device files are created OK, and LSUSB shows PDA correctly:

# ll /dev/ttyU*
crw-rw---- 1 root uucp 188, 0 Oct  9 17:08 /dev/ttyUSB0
crw-rw---- 1 root uucp 188, 1 Oct  9 17:08 /dev/ttyUSB1

# lsusb
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 002: ID 04a9:10c9 Canon, Inc.
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 002: ID 054c:0144 Sony Corp. Clie PEG-TH55 PDA
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 004: ID 0a81:0101 Chesen Electronics Corp. Keyboard
Bus 003 Device 002: ID 046d:c52b Logitech, Inc.
Bus 003 Device 003: ID 0557:7000 ATEN International Co., Ltd Hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

lsusb -vv seems to contain identical values for both 2.6.34.1 and 2.6.35:
# lsusb -vv
Bus 006 Device 003: ID 054c:0144 Sony Corp. Clie PEG-TH55 PDA
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               1.10
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         8
   idVendor           0x054c Sony Corp.
   idProduct          0x0144 Clie PEG-TH55 PDA
   bcdDevice            1.00
   iManufacturer           1 Palm. Inc.
   iProduct                2 Palm Handheld
   iSerial                 0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           46
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xc0
       Self Powered
     MaxPower                2mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           4
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
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
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x05  EP 5 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval               0
Device Status:     0x0001
   Self Powered

But both Jpilot and Kpilot fail to connect-
(timeout, no activity, 'unable to access /dev/ttyUSB0')

Workaround is to copy the 2.6.34.1 versions of visor.c and visor.h to 
the 2.6.35 (or 2.6.35.6) code base, and recompile/reinstall.   Then 
everything works again.

Problem has been reproduced with 2 different Clie PDAs..

Robert Gadsdon.

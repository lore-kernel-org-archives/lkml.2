Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab2EASj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:39:27 -0400
Received: from tex.lwn.net ([70.33.254.29]:34691 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab2EASjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:39:25 -0400
Date: Tue, 1 May 2012 12:39:23 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-bluetooth@vger.kernel.org
Subject: Re: [now bisected] Weird bluetooth keyboard regression - just me?
Message-ID: <20120501123923.01ac1138@lwn.net>
In-Reply-To: <20120501183149.GA28536@srcf.ucam.org>
References: <20120501073711.028d31d6@lwn.net>
	<20120501110156.2b6e0561@lwn.net>
	<20120501171901.GA26006@srcf.ucam.org>
	<20120501120145.21f65ae2@lwn.net>
	<20120501183149.GA28536@srcf.ucam.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2012 19:31:49 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> > It's Rawhide, updated yesterday.  "Removable" says "fixed".  
> 
> Ok, well that's the problem. udev is seeing "fixed" and enabling 
> autosuspend. Is this really bluetooth, or does it appear as a USB HID 
> device? Can you send lsusb -v?

Whether it's really bluetooth has been an issue in the past... parts of
the system have fought over it.

lsusb says (on an older kernel where my keyboard works):

Bus 002 Device 003: ID 046d:0b04 Logitech, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0         8
  idVendor           0x046d Logitech, Inc.
  idProduct          0x0b04 
  bcdDevice           49.00
  iManufacturer           1 Logitech
  iProduct                2 Logitech BT Mini-Receiver
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0001  1x 1 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             3
  wHubCharacteristic 0x0004
    Ganged power switching
    Compound device
    Ganged overcurrent protection
  bPwrOn2PwrGood       50 * 2 milli seconds
  bHubContrCurrent    100 milli Ampere
  DeviceRemovable    0x0c
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0103 power enable connect
   Port 3: 0000.0103 power enable connect
Device Status:     0x0000
  (Bus Powered)

jon

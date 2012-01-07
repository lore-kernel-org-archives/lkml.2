Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab2AGPEh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 10:04:37 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58583 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2AGPEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 10:04:35 -0500
Message-ID: <4F085EFA.5070404@gmail.com>
Date: Sat, 07 Jan 2012 16:04:26 +0100
From: Dario Lucia <dario.lucia@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com
CC: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Patch for SITECOM WLA-1000 V1 001 WLAN USB Adapter (Realtek RTL8188S)
Content-Type: multipart/mixed;
 boundary="------------020208030300010604080806"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020208030300010604080806
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dear Larry and Florian,

I'm sending you this email, because you are marked as maintainers for 
the module r8712u. I had to patch it, in order to let it recognize my 
USB WLAN adapter from Sitecom (WLA-1000). Basically, I had to add the 
following line inside drivers/staging/rtl8712/usb_intf.c (line 89):

     {USB_DEVICE(0x0DF6, 0x005B)},

Would it be possible to have the following included in the next kernel 
version, so that we don't have to patch and recompile the kernel everytime?
I created the patch on kernel 3.1.7. The driver is working fine using 
the latest firmware from Realtek (2.6.6.0.20110401).

The output I have from lsusb is the following:

Bus 002 Device 005: ID 0df6:005b Sitecom Europe B.V.
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x0df6 Sitecom Europe B.V.
   idProduct          0x005b
   bcdDevice            2.00
   iManufacturer           1 Manufacturer Realtek
   iProduct                2 RTL8188S WLAN Adapter
   iSerial                 3 00e04c000001
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           46
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower              500mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           4
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass    255 Vendor Specific Subclass
       bInterfaceProtocol    255 Vendor Specific Protocol
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x04  EP 4 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x06  EP 6 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x0d  EP 13 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0000
   (Bus Powered)

The following is the output I get from dmesg, after having plugged the 
WLAN adapter in:

     [ 2854.704802] usb 2-1.7: new high speed USB device number 5 using 
ehci_hcd
     [ 2854.791717] r8712u: DriverVersion: v7_0.20100831
     [ 2854.791728] r8712u: register rtl8712_netdev_ops to netdev_ops
     [ 2854.791730] r8712u: USB_SPEED_HIGH with 4 endpoints
     [ 2854.792265] r8712u: Boot from EFUSE: Autoload OK
     [ 2855.553071] r8712u: CustomerID = 0x0000
     [ 2855.553076] r8712u: MAC Address from efuse = 00:0c:f6:b6:dd:b0

I make a "ifconfig wlan0 up"

     [ 3006.883663] r8712u: Loading firmware from "rtlwifi/rtl8712u.bin"
     [ 3007.533552] r8712u: 1 RCR=0x153f00e
     [ 3007.534471] r8712u: 2 RCR=0x553f00e
     [ 3007.640220] ADDRCONF(NETDEV_UP): wlan0: link is not ready

After configuring WPA supplicant and asked for an IP address, by running 
"dhcpcd wlan0"

     [ 3046.518482] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
     [ 3053.833957] r8712u: [r8712_got_addbareq_event_callback] mac = 
00:0c:f6:be:7f:44, seq = 48, tid = 0
     [ 3057.336367] wlan0: no IPv6 routers present

Iwconfig shows:

wlan0     IEEE 802.11bgn  ESSID:"WirelessLanDL"  Nickname:"rtl_wifi"
           Mode:Managed  Frequency:2.412 GHz  Access Point: 
00:0C:F6:BE:7F:44
           Bit Rate:150 Mb/s   Sensitivity:0/0
           Retry:off   RTS thr:off   Fragment thr:off
           Encryption key:****-****-****-****-****-****-****-****   
Security mode:open
           Power Management:off
           Link Quality=100/100  Signal level=73/100  Noise level=0/100
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Ifconfig shows:

wlan0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500  metric 1
         inet 192.168.0.102  netmask 255.255.255.0  broadcast 192.168.0.255
         inet6 fe80::20c:f6ff:feb6:ddb0  prefixlen 64  scopeid 0x20<link>
         ether 00:0c:f6:b6:dd:b0  txqueuelen 1000  (Ethernet)
         RX packets 17  bytes 5850 (5.7 KiB)
         RX errors 0  dropped 0  overruns 0  frame 0
         TX packets 14  bytes 2013 (1.9 KiB)
         TX errors 0  dropped 2 overruns 0  carrier 0  collisions 0

That's it. I apologize in case you already received a patch for this.

Best regards,
Dario Lucia



--------------020208030300010604080806
Content-Type: text/x-patch;
 name="rtl8712_3.1.7.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8712_3.1.7.patch"

--- drivers/staging/rtl8712/usb_intf.c.orig	2012-01-07 12:41:24.798555152 +0100
+++ drivers/staging/rtl8712/usb_intf.c	2012-01-07 12:41:54.414294675 +0100
@@ -86,6 +86,7 @@
 	{USB_DEVICE(0x0DF6, 0x0045)},
 	{USB_DEVICE(0x0DF6, 0x0059)}, /* 11n mode disable */
 	{USB_DEVICE(0x0DF6, 0x004B)},
+	{USB_DEVICE(0x0DF6, 0x005B)},
 	{USB_DEVICE(0x0DF6, 0x005D)},
 	{USB_DEVICE(0x0DF6, 0x0063)},
 	/* Sweex */

--------------020208030300010604080806--

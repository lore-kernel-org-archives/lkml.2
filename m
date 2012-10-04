Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab2JDCTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 22:19:00 -0400
Received: from vf1.bbnx.net ([173.9.142.98]:52105 "EHLO vf1.bbnx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab2JDCS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 22:18:59 -0400
X-Greylist: delayed 641 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2012 22:18:58 EDT
Message-ID: <506CEF8F.6080509@bbnx.net>
Date: Wed, 03 Oct 2012 22:08:15 -0400
From: "Ryan A. Krenzischek" <ryan@bbnx.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: jhovold@gmail.com, greg@kroah.com, bryder@sgi.com, kuba@mareimbrium.org
CC: linux-kernel@vger.kernel.org
Subject: FTDI Linux Kernel Driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Patch Description: Add product id in ftdi_sio.c struct table ( static 
struct usb_device_id id_table_combined []) and include a define 
statement in ftdi_sio_ids.h for RTSYSTEMS CT63 Radio Cable.

Output from dmesg regarding the hardware:

[ 5489.423407] usb 10-1: New USB device found, idVendor=2100, idProduct=9e58
[ 5489.423414] usb 10-1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[ 5489.423421] usb 10-1: Product: CT63 Radio Cable
[ 5489.423426] usb 10-1: Manufacturer: RT Systems
[ 5489.423431] usb 10-1: SerialNumber: RTUC68HJ

Output from lsusb -v:

Bus 010 Device 002: ID 2100:9e58
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         8
   idVendor           0x2100
   idProduct          0x9e58
   bcdDevice            6.00
   iManufacturer           1 RT Systems
   iProduct                2 CT63 Radio Cable
   iSerial                 3 RTUC68HJ
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           32
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower               90mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           2
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass    255 Vendor Specific Subclass
       bInterfaceProtocol    255 Vendor Specific Protocol
       iInterface              2 CT63 Radio Cable
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
Device Status:     0x0000
   (Bus Powered)

$> cat /tmp/ftdi-ct63.patch
diff -uprN linux-3.6-vanilla/drivers/usb/serial/ftdi_sio.c 
/home/ryan/src/linux-3.6-ftdi/drivers/usb/serial/ftdi_sio.c
--- linux-3.6-vanilla/drivers/usb/serial/ftdi_sio.c     2012-09-30 
19:47:46.000000000 -0400
+++ /home/ryan/src/linux-3.6-ftdi/drivers/usb/serial/ftdi_sio.c 
2012-10-03 21:44:56.024000806 -0400
@@ -738,6 +738,7 @@ static struct usb_device_id id_table_com
         { USB_DEVICE(TELLDUS_VID, TELLDUS_TELLSTICK_PID) },
         { USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_SERIAL_VX7_PID) },
         { USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_CT29B_PID) },
+       { USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_CT63_PID) },
         { USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_RTS01_PID) },
         { USB_DEVICE(FTDI_VID, FTDI_MAXSTREAM_PID) },
         { USB_DEVICE(FTDI_VID, FTDI_PHI_FISCO_PID) },
diff -uprN linux-3.6-vanilla/drivers/usb/serial/ftdi_sio_ids.h 
/home/ryan/src/linux-3.6-ftdi/drivers/usb/serial/ftdi_sio_ids.h
--- linux-3.6-vanilla/drivers/usb/serial/ftdi_sio_ids.h 2012-09-30 
19:47:46.000000000 -0400
+++ /home/ryan/src/linux-3.6-ftdi/drivers/usb/serial/ftdi_sio_ids.h 
2012-10-03 21:45:39.211999231 -0400
@@ -790,6 +790,7 @@
  #define RTSYSTEMS_VID                  0x2100  /* Vendor ID */
  #define RTSYSTEMS_SERIAL_VX7_PID       0x9e52  /* Serial converter for 
VX-7 Radios using FT232RL */
  #define RTSYSTEMS_CT29B_PID            0x9e54  /* CT29B Radio Cable */
+#define RTSYSTEMS_CT63_PID             0x9e58  /* CT63 Radio Cable */
  #define RTSYSTEMS_RTS01_PID            0x9e57  /* USB-RTS01 Radio Cable */

Signed-off-by: Ryan A. Krenzischek <ryan@bbnx.net>

73 de Ryan/W4NTR

-- 
Ryan A. Krenzischek
W4NTR, Amateur Radio;
W4NVU, Webmaster;
NNN0RGN/RGNNNN/NNR4GN, U.S. Navy-Marine Corps MARS (NMCM)/SHARES;
NNN0GAL TWO-FOUR, Assistant U.S. NMCM FL Training Officer;
NNN0GED NMCM Project Officer for Miami AT&T Restoration Center.


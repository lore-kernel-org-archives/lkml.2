Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab2JDHiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 03:38:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52285 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab2JDHiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 03:38:07 -0400
Message-ID: <506D3CD8.7070904@gmail.com>
Date: Thu, 04 Oct 2012 09:38:00 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Ryan A. Krenzischek" <ryan@bbnx.net>
CC: jhovold@gmail.com, greg@kroah.com, bryder@sgi.com, kuba@mareimbrium.org,
        linux-kernel@vger.kernel.org
Subject: Re: FTDI Linux Kernel Driver
References: <506CEF8F.6080509@bbnx.net>
In-Reply-To: <506CEF8F.6080509@bbnx.net>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

On 04.10.2012 04:08, Ryan A. Krenzischek wrote:
> Patch Description: Add product id in ftdi_sio.c struct table ( static 
> struct usb_device_id id_table_combined []) and include a define 
> statement in ftdi_sio_ids.h for RTSYSTEMS CT63 Radio Cable.

Thanks for sending patches to the mainline maintainers.

However, note that the format you sent them in is not appropriate. Could
you please read Documentation/SubmittingPatches and resend?


Daniel


> 
> Output from dmesg regarding the hardware:
> 
> [ 5489.423407] usb 10-1: New USB device found, idVendor=2100, idProduct=9e58
> [ 5489.423414] usb 10-1: New USB device strings: Mfr=1, Product=2, 
> SerialNumber=3
> [ 5489.423421] usb 10-1: Product: CT63 Radio Cable
> [ 5489.423426] usb 10-1: Manufacturer: RT Systems
> [ 5489.423431] usb 10-1: SerialNumber: RTUC68HJ
> 
> Output from lsusb -v:
> 
> Bus 010 Device 002: ID 2100:9e58
> Device Descriptor:
>    bLength                18
>    bDescriptorType         1
>    bcdUSB               2.00
>    bDeviceClass            0 (Defined at Interface level)
>    bDeviceSubClass         0
>    bDeviceProtocol         0
>    bMaxPacketSize0         8
>    idVendor           0x2100
>    idProduct          0x9e58
>    bcdDevice            6.00
>    iManufacturer           1 RT Systems
>    iProduct                2 CT63 Radio Cable
>    iSerial                 3 RTUC68HJ
>    bNumConfigurations      1
>    Configuration Descriptor:
>      bLength                 9
>      bDescriptorType         2
>      wTotalLength           32
>      bNumInterfaces          1
>      bConfigurationValue     1
>      iConfiguration          0
>      bmAttributes         0x80
>        (Bus Powered)
>      MaxPower               90mA
>      Interface Descriptor:
>        bLength                 9
>        bDescriptorType         4
>        bInterfaceNumber        0
>        bAlternateSetting       0
>        bNumEndpoints           2
>        bInterfaceClass       255 Vendor Specific Class
>        bInterfaceSubClass    255 Vendor Specific Subclass
>        bInterfaceProtocol    255 Vendor Specific Protocol
>        iInterface              2 CT63 Radio Cable
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x81  EP 1 IN
>          bmAttributes            2
>            Transfer Type            Bulk
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0040  1x 64 bytes
>          bInterval               0
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x02  EP 2 OUT
>          bmAttributes            2
>            Transfer Type            Bulk
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0040  1x 64 bytes
>          bInterval               0
> Device Status:     0x0000
>    (Bus Powered)
> 
> $> cat /tmp/ftdi-ct63.patch
> diff -uprN linux-3.6-vanilla/drivers/usb/serial/ftdi_sio.c 
> /home/ryan/src/linux-3.6-ftdi/drivers/usb/serial/ftdi_sio.c
> --- linux-3.6-vanilla/drivers/usb/serial/ftdi_sio.c     2012-09-30 
> 19:47:46.000000000 -0400
> +++ /home/ryan/src/linux-3.6-ftdi/drivers/usb/serial/ftdi_sio.c 
> 2012-10-03 21:44:56.024000806 -0400
> @@ -738,6 +738,7 @@ static struct usb_device_id id_table_com
>          { USB_DEVICE(TELLDUS_VID, TELLDUS_TELLSTICK_PID) },
>          { USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_SERIAL_VX7_PID) },
>          { USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_CT29B_PID) },
> +       { USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_CT63_PID) },
>          { USB_DEVICE(RTSYSTEMS_VID, RTSYSTEMS_RTS01_PID) },
>          { USB_DEVICE(FTDI_VID, FTDI_MAXSTREAM_PID) },
>          { USB_DEVICE(FTDI_VID, FTDI_PHI_FISCO_PID) },
> diff -uprN linux-3.6-vanilla/drivers/usb/serial/ftdi_sio_ids.h 
> /home/ryan/src/linux-3.6-ftdi/drivers/usb/serial/ftdi_sio_ids.h
> --- linux-3.6-vanilla/drivers/usb/serial/ftdi_sio_ids.h 2012-09-30 
> 19:47:46.000000000 -0400
> +++ /home/ryan/src/linux-3.6-ftdi/drivers/usb/serial/ftdi_sio_ids.h 
> 2012-10-03 21:45:39.211999231 -0400
> @@ -790,6 +790,7 @@
>   #define RTSYSTEMS_VID                  0x2100  /* Vendor ID */
>   #define RTSYSTEMS_SERIAL_VX7_PID       0x9e52  /* Serial converter for 
> VX-7 Radios using FT232RL */
>   #define RTSYSTEMS_CT29B_PID            0x9e54  /* CT29B Radio Cable */
> +#define RTSYSTEMS_CT63_PID             0x9e58  /* CT63 Radio Cable */
>   #define RTSYSTEMS_RTS01_PID            0x9e57  /* USB-RTS01 Radio Cable */
> 
> Signed-off-by: Ryan A. Krenzischek <ryan@bbnx.net>
> 
> 73 de Ryan/W4NTR
> 


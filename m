Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab1KSXKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 18:10:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab1KSXKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 18:10:12 -0500
Date: Sun, 20 Nov 2011 00:10:10 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dan Delaney <drdelaney@loclhst.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] usbled: add support for Dream Cheeky DL100B Mailbox
 Friends Alert (1d34:000a)
In-Reply-To: <4EC60E9D.6070606@loclhst.com>
Message-ID: <alpine.LNX.2.00.1111200007350.15187@pobox.suse.cz>
References: <4EC60E9D.6070606@loclhst.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011, Dan Delaney wrote:

> This patch will add support for the Dream Cheeky Mailbox Friends Alert (http://www.dreamcheeky.com/mailbox-friends-alert) usb led dongle.
> The drivers for the webmail notifier (1d34:0004) work perfectly fine, so I just would like to add support for the new device.
> I have tested the patch on gentoo sources of 2.6.39 and 3.0.6, as well as vanilla 3.1.1 and 3.2-rc2.
> 
> This is my first attempt at making a change to the kernel, so let me know if I need to change something (formatting, where to post, etc)
> 
> I am not sure who else I may need to CC on this.

Dan,

thanks for the patch.

I am adding some more CCs. Greg, it's 50:50 between HID and usbled code, 
so just let me know whether you'll be taking it or I should take it, 
either way is fine by me of course.

Dan, we also need your Signed-off-by: line (see 
Documentation/SubmittingPatches), othwewise we unfortunately can't accept 
your contribution.

> 
> Device data:
> [169976.524055] usb 6-1: new low speed USB device number 3 using ohci_hcd
> [169976.685943] usb 6-1: New USB device found, idVendor=1d34, idProduct=000a
> [169976.685947] usb 6-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [169976.685950] usb 6-1: Product: DL100B Dream Cheeky Generic Controller
> [169976.685951] usb 6-1: Manufacturer: Dream Link
> [169976.689931] usbled 6-1:1.0: USB LED device now attached
> 
> Bus 006 Device 003: ID 1d34:000a
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               1.10
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0         8
>   idVendor           0x1d34
>   idProduct          0x000a
>   bcdDevice            0.02
>   iManufacturer           1 Dream Link
>   iProduct                2 DL100B Dream Cheeky Generic Controller
>   iSerial                 0
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           34
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0x80
>       (Bus Powered)
>     MaxPower              500mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         3 Human Interface Device
>       bInterfaceSubClass      0 No Subclass
>       bInterfaceProtocol      0 None
>       iInterface              0
>         HID Device Descriptor:
>           bLength                 9
>           bDescriptorType        33
>           bcdHID               1.10
>           bCountryCode            0 Not supported
>           bNumDescriptors         1
>           bDescriptorType        34 Report
>           wDescriptorLength      37
>          Report Descriptors:
>            ** UNAVAILABLE **
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0008  1x 8 bytes
>         bInterval              10
> Device Status:     0x0000
>   (Bus Powered)
> 
> 
> And the patch:
> 
> --- a/drivers/hid/hid-core.c    2011-11-16 02:06:51.000000000 -0600
> +++ b/drivers/hid/hid-core.c    2011-11-16 02:01:06.000000000 -0600
> @@ -1687,6 +1687,7 @@
>         { HID_USB_DEVICE(USB_VENDOR_ID_DELORME, USB_DEVICE_ID_DELORME_EARTHMATE) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_DELORME, USB_DEVICE_ID_DELORME_EM_LT20) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_DREAM_CHEEKY, 0x0004) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_DREAM_CHEEKY, 0x000a) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_ESSENTIAL_REALITY, USB_DEVICE_ID_ESSENTIAL_REALITY_P5) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_ETT, USB_DEVICE_ID_TC5UH) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_ETT, USB_DEVICE_ID_TC4UM) },
> diff -ur a/drivers/usb/misc/usbled.c b/drivers/usb/misc/usbled.c
> --- a/drivers/usb/misc/usbled.c 2011-11-16 02:05:43.000000000 -0600
> +++ b/drivers/usb/misc/usbled.c 2011-11-16 02:01:40.000000000 -0600
> @@ -31,6 +31,8 @@
>                         .driver_info = DELCOM_VISUAL_SIGNAL_INDICATOR },
>         { USB_DEVICE(0x1d34, 0x0004),
>                         .driver_info = DREAM_CHEEKY_WEBMAIL_NOTIFIER },
> +       { USB_DEVICE(0x1d34, 0x000a),
> +                       .driver_info = DREAM_CHEEKY_WEBMAIL_NOTIFIER },
>         { },
>  };
>  MODULE_DEVICE_TABLE (usb, id_table);
> 
> 
> -- 
> Dan Delaney
> drdelaney@loclhst.com
> 

-- 
Jiri Kosina
SUSE Labs

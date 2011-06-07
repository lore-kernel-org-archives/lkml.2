Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab1FGGgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 02:36:01 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:46159 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab1FGGgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 02:36:00 -0400
Message-ID: <4DEDC6CE.7080100@msgid.tls.msk.ru>
Date: Tue, 07 Jun 2011 10:35:58 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110506 Icedove/3.0.11
MIME-Version: 1.0
To: =?UTF-8?B?UGF3ZcWCIERyb2Jlaw==?= <pawel.drobek@gmail.com>
CC: Greg KH <greg@kroah.com>, Linux USB list <linux-usb@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: option driver, ZTE MF_330 matches linux usb 2.0 root hub
References: <4DDEC269.30808@msgid.tls.msk.ru>	 <4DDEC606.4020504@msgid.tls.msk.ru> <20110527012022.GF24630@kroah.com>	 <BANLkTikcjXTczV2FmGcQ7BY=m_t7ep54Sw@mail.gmail.com>	 <4DDF427E.1030109@msgid.tls.msk.ru>	 <BANLkTikodJ4cnjJ9Lxx=zsHd-dAgPzfDrA@mail.gmail.com>	 <4DDF6917.9060004@msgid.tls.msk.ru>	 <BANLkTi==1WyJNACmoOxcrS6RiJ3w8Ow1zw@mail.gmail.com>	 <20110527100215.GC9272@kroah.com> <4DDFA4F5.8060502@msgid.tls.msk.ru>	 <BANLkTinAip5BswLBjxyJ1O_XPnUFq=FUjw@mail.gmail.com>	 <4DECD457.60101@msgid.tls.msk.ru>	 <BANLkTimLfkGjFtk_GJ87_+f7fswkdmSe3Q@mail.gmail.com> <1307422131.5615.3.camel@one.pl>
In-Reply-To: <1307422131.5615.3.camel@one.pl>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07.06.2011 08:48, Paweł Drobek wrote:

> Bus 003 Device 002: ID 19d2:0001 ONDA Communication S.p.A.
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               1.10
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x19d2 ONDA Communication S.p.A.
>   idProduct          0x0001
>   bcdDevice            0.00
>   iManufacturer           1 Qualcomm, Incorporated
>   iProduct                2 ZTE CDMA Technologies MSM
>   iSerial                 0
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           85
>     bNumInterfaces          3
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0xa0
>       (Bus Powered)
>       Remote Wakeup
>     MaxPower              500mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           3
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              3 Data Interface

So, as far as I can see, this is covered by

#define ZTE_VENDOR_ID                           0x19d2
#define ZTE_PRODUCT_MF622                       0x0001

{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */

and it should Just Work aftere reverting a559d2c8c1bf652ea2d0ecd6ab4a250fcdb37db8
"USB: option: add ID for ZTE MF 330".  But I'm not sure this really
is MF330, since the device ID says it's MF622.

Are we talking about the same device?

Besides, why in linux it's identified as ZTE, while
lsusb lists it as "ONDA Comm." ?

Thanks,

/mjt

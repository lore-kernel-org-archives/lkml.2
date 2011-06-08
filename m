Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab1FHNcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:32:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373Ab1FHNck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:32:40 -0400
Date: Wed, 8 Jun 2011 15:32:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: =?ISO-8859-2?Q?Pawe=B3_Drobek?= <pawel.drobek@gmail.com>,
        Greg KH <greg@kroah.com>, Linux USB list <linux-usb@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: option driver, ZTE MF_330 matches linux usb 2.0 root hub
In-Reply-To: <4DEDC6CE.7080100@msgid.tls.msk.ru>
Message-ID: <alpine.LRH.2.00.1106081531340.8510@twin.jikos.cz>
References: <4DDEC269.30808@msgid.tls.msk.ru>  <4DDEC606.4020504@msgid.tls.msk.ru> <20110527012022.GF24630@kroah.com>  <BANLkTikcjXTczV2FmGcQ7BY=m_t7ep54Sw@mail.gmail.com>  <4DDF427E.1030109@msgid.tls.msk.ru>  <BANLkTikodJ4cnjJ9Lxx=zsHd-dAgPzfDrA@mail.gmail.com>
  <4DDF6917.9060004@msgid.tls.msk.ru>  <BANLkTi==1WyJNACmoOxcrS6RiJ3w8Ow1zw@mail.gmail.com>  <20110527100215.GC9272@kroah.com> <4DDFA4F5.8060502@msgid.tls.msk.ru>  <BANLkTinAip5BswLBjxyJ1O_XPnUFq=FUjw@mail.gmail.com>  <4DECD457.60101@msgid.tls.msk.ru> 
 <BANLkTimLfkGjFtk_GJ87_+f7fswkdmSe3Q@mail.gmail.com> <1307422131.5615.3.camel@one.pl> <4DEDC6CE.7080100@msgid.tls.msk.ru>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jun 2011, Michael Tokarev wrote:

> > Bus 003 Device 002: ID 19d2:0001 ONDA Communication S.p.A.
> > Device Descriptor:
> >   bLength                18
> >   bDescriptorType         1
> >   bcdUSB               1.10
> >   bDeviceClass            0 (Defined at Interface level)
> >   bDeviceSubClass         0
> >   bDeviceProtocol         0
> >   bMaxPacketSize0        64
> >   idVendor           0x19d2 ONDA Communication S.p.A.
> >   idProduct          0x0001
> >   bcdDevice            0.00
> >   iManufacturer           1 Qualcomm, Incorporated
> >   iProduct                2 ZTE CDMA Technologies MSM
> >   iSerial                 0
> >   bNumConfigurations      1
> >   Configuration Descriptor:
> >     bLength                 9
> >     bDescriptorType         2
> >     wTotalLength           85
> >     bNumInterfaces          3
> >     bConfigurationValue     1
> >     iConfiguration          0
> >     bmAttributes         0xa0
> >       (Bus Powered)
> >       Remote Wakeup
> >     MaxPower              500mA
> >     Interface Descriptor:
> >       bLength                 9
> >       bDescriptorType         4
> >       bInterfaceNumber        0
> >       bAlternateSetting       0
> >       bNumEndpoints           3
> >       bInterfaceClass       255 Vendor Specific Class
> >       bInterfaceSubClass    255 Vendor Specific Subclass
> >       bInterfaceProtocol    255 Vendor Specific Protocol
> >       iInterface              3 Data Interface
> 
> So, as far as I can see, this is covered by
> 
> #define ZTE_VENDOR_ID                           0x19d2
> #define ZTE_PRODUCT_MF622                       0x0001
> 
> { USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */
> 
> and it should Just Work aftere reverting a559d2c8c1bf652ea2d0ecd6ab4a250fcdb37db8
> "USB: option: add ID for ZTE MF 330".  But I'm not sure this really
> is MF330, since the device ID says it's MF622.
> 
> Are we talking about the same device?
> 
> Besides, why in linux it's identified as ZTE, while
> lsusb lists it as "ONDA Comm." ?

ONDA and ZTE are usually the very same chip.

Also please note that USB ID of these devices usually changes after 
'usb_modeswtich' triggers in userspace (and many distros ship udev rule 
for this as a default nowadays), which might contribute to the overall 
confusion a little bit more.

-- 
Jiri Kosina
SUSE Labs


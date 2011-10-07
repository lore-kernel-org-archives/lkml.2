Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595Ab1JGIXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 04:23:13 -0400
Received: from mail.infrascan.de ([188.40.84.136]:46271 "EHLO infrascan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab1JGIXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 04:23:12 -0400
Message-ID: <4E8EB6EE.8040700@sensortherm.de>
Date: Fri, 07 Oct 2011 10:23:10 +0200
From: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: balbi@ti.com
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de> <20111006120830.GN1714@legolas.emea.dhcp.ti.com>
In-Reply-To: <20111006120830.GN1714@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thanks for your comments. See my patch v2.

Am 06.10.2011 14:08, schrieb Felipe Balbi:

>
>> +#define CDC_VENDOR_NUM	0x1d6b	/* Linux Foundation */
>> +#define CDC_PRODUCT_NUM	0x0106	/* CDC Composite: ACM + MS*/
>
> did you ask Greg for this ?
>

Greg wrote:

I'll do that when I accept the patch for merging into the kernel, and 
not before.


>> +/*-------------------------------------------------------------------------*/
>> +
>> +/*
>> + * Kbuild is not very cooperative with respect to linking separately
>> + * compiled library objects into one module.  So for now we won't use
>> + * separate compilation ... ensuring init/exit sections work to shrink
>> + * the runtime footprint, and giving us at least some parts of what
>> + * a "gcc --combine ... part1.c part2.c part3.c ... " build would.
>> + */
>> +
>> +#include "composite.c"
>> +#include "usbstring.c"
>> +#include "config.c"
>> +#include "epautoconf.c"
>> +#include "u_serial.c"
>> +#include "f_acm.c"
>> +#include "f_mass_storage.c"
>> +
>> +/*-------------------------------------------------------------------------*/
>> +
>> +static struct usb_device_descriptor device_desc = {
>> +	.bLength =		sizeof device_desc,
>> +	.bDescriptorType =	USB_DT_DEVICE,
>> +
>> +	.bcdUSB =		cpu_to_le16(0x0200),
>> +
>> +	.bDeviceClass =		USB_CLASS_COMM,
>> +	.bDeviceSubClass =	0,
>> +	.bDeviceProtocol =	0,
>> +	/* .bMaxPacketSize0 = f(hardware) */
>> +
>> +	/* Vendor and product id can be overridden by module parameters.  */
>> +	.idVendor =		cpu_to_le16(CDC_VENDOR_NUM),
>> +	.idProduct =		cpu_to_le16(CDC_PRODUCT_NUM),
>> +	/* .bcdDevice = f(hardware) */
>> +	/* .iManufacturer = DYNAMIC */
>> +	/* .iProduct = DYNAMIC */
>> +	/* NO SERIAL NUMBER */
>
> why not ? If someone wants to make a product out of this, they will need
> a serial number.
>

If an developer want a serial number, he can change this.

>> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
>> index dd1571d..f623f3d 100644
>> --- a/include/linux/usb/gadget.h
>> +++ b/include/linux/usb/gadget.h
>> @@ -15,6 +15,7 @@
>>   #ifndef __LINUX_USB_GADGET_H
>>   #define __LINUX_USB_GADGET_H
>>
>> +#include<linux/device.h>
>
> this is not part of $SUBJECT
>

changed git message


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2FCLsk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 07:48:40 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57620 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751764Ab2FCLsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 07:48:39 -0400
Message-ID: <1338724118.24148.22.camel@joe2Laptop>
Subject: Re: [PATCH] add new NRP power meter USB device driver
From: Joe Perches <joe@perches.com>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de,
        alan@lxorguk.ukuu.org.uk, thomas.braunstorfinger@rohde-schwarz.com
Date: Sun, 03 Jun 2012 04:48:38 -0700
In-Reply-To: <1338713172-7496-1-git-send-email-stefani@seibold.net>
References: <1338713172-7496-1-git-send-email-stefani@seibold.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-06-03 at 10:46 +0200, stefani@seibold.net wrote:
> From: Stefani Seibold <stefani@seibold.net>
> 
> This driver supports all of the Rohde&Schwarz RF Power Meter NRP Sensors. These
> sensors are intelligent standalone instruments that communicate via USB.

Just trivia:

> diff --git a/drivers/usb/misc/nrpz.c b/drivers/usb/misc/nrpz.c
[]
> +#include <linux/usb/nrpzmodule.h>

why in linux/usb?

> +static struct usb_device_id nrpz_table[] = {

const

> +	{USB_DEVICE(USB_RS_VENDOR_ID, USB_NRP_PRODUCT_ID)},
[]
> +};
> +MODULE_DEVICE_TABLE(usb, nrpz_table);
[]
> +static long nrpz_compat_ioctl(struct file *file, unsigned int cmd,
> +		unsigned long arg)
[]
> +	switch (cmd) {
> +	case NRPZ_START:
> +	 {
[]
> +	case NRPZ_VENDOR_CONTROL_MSG_OUT:
> +	 {
[]
> +	case NRPZ_VENDOR_CONTROL_MSG_IN:
> +	 {

Perhaps checkpatch should warn on these oddly indented braces.
I think case FOO: { is a bit more standard.

[]
> +static struct usb_class_driver nrpz_class = {
> +	.name = "nrpz%d",
> +	.fops = &nrpz_fops,
> +	.minor_base = NRPZ_MINOR_BASE,
> +};

const ?

[]
> +static struct usb_driver nrpz_driver = {

const ?

> diff --git a/include/linux/usb/nrpzmodule.h b/include/linux/usb/nrpzmodule.h
> new file mode 100644
> index 0000000..8a39aef
> --- /dev/null
> +++ b/include/linux/usb/nrpzmodule.h

Does this file really need to be in include/linux?
It might be better in the same directory as .c
[]
> +struct nrpz_sensor_info {
> +	unsigned char bDescriptorType;
> +	unsigned short bcdUSB;
> +	unsigned char bDeviceClass;
> +	unsigned char bDeviceSubClass;
> +	unsigned char bDeviceProtocol;
> +	unsigned char bMaxPacketSize0;
> +	unsigned short vendorId;
> +	unsigned short productId;
> +	unsigned short bcdDevice;
> +	unsigned char iManufacturer;
> +	unsigned char iProduct;
> +	unsigned char iSerialNumber;
> +	unsigned char bNumConfigurations;

This sort of layout creates alignment holes between
some of the struct members, you could reorder it.
or declare it packed if necessary.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab0LHNpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 08:45:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:36653 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab0LHNpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 08:45:10 -0500
Date: Wed, 8 Dec 2010 14:45:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: kverlin@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        rydberg@euromail.se
Subject: Re: [PATCH] USB: HID: Panasonic ub-t780 whiteboard hid driver
 stub.
In-Reply-To: <1290529358-6616-1-git-send-email-Anton.Chikin@dataart.com>
Message-ID: <alpine.LNX.2.00.1012081438110.14806@pobox.suse.cz>
References: <1290529358-6616-1-git-send-email-Anton.Chikin@dataart.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010, kverlin@gmail.com wrote:

> From: Anton Chikin <kverlin@panasonic-box.(none)>
> 
> ---
>  drivers/hid/Kconfig      |    6 +
>  drivers/hid/Makefile     |    1 +
>  drivers/hid/hid-core.c   |    2 +
>  drivers/hid/hid-ubt780.c |  237 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/hid/ubt780ctrl.h |  109 +++++++++++++++++++++
>  5 files changed, 355 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hid/hid-ubt780.c
>  create mode 100644 drivers/hid/ubt780ctrl.h
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 3052e29..ee912e2 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -114,6 +114,12 @@ config HID_CHICONY
>  	---help---
>  	Support for Chicony Tactical pad.
>  
> +config HID_PANASONIC
> +	tristate "Panasonic UB-T780 whiteboard"
> +	depends on USB_HID
> +	---help---
> +	Support for Panasonic Elite Panaboard UB-T780
> +
>  config HID_PRODIKEYS
>  	tristate "Prodikeys PC-MIDI Keyboard support"
>  	depends on USB_HID && SND
> diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
> index c335605..7404929 100644
> --- a/drivers/hid/Makefile
> +++ b/drivers/hid/Makefile
> @@ -70,6 +70,7 @@ obj-$(CONFIG_HID_ZEROPLUS)	+= hid-zpff.o
>  obj-$(CONFIG_HID_ZYDACRON)	+= hid-zydacron.o
>  obj-$(CONFIG_HID_WACOM)		+= hid-wacom.o
>  obj-$(CONFIG_HID_WALTOP)	+= hid-waltop.o
> +obj-$(CONFIG_HID_PANASONIC)	+= hid-ubt780.o
>  
>  obj-$(CONFIG_USB_HID)		+= usbhid/
>  obj-$(CONFIG_USB_MOUSE)		+= usbhid/
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 515345b..263210a 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1366,6 +1366,8 @@ static const struct hid_device_id hid_blacklist[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_18) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_PANASONIC, USB_DEVICE_ID_PANASONIC_PANABOARD_T780)},
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_PANASONIC, USB_DEVICE_ID_PANASONIC_PANABOARD_T880)},

This adds two new device IDs to hid_blacklist[]. I don't see any hunk in 
the provided patch which would be adding these to hid-ids.h.

> diff --git a/drivers/hid/hid-ubt780.c b/drivers/hid/hid-ubt780.c
> new file mode 100644
> index 0000000..c2c2e20
> --- /dev/null
> +++ b/drivers/hid/hid-ubt780.c
> @@ -0,0 +1,237 @@
> +/*
> + *  HID driver for Cando dual-touch panels
> + *
> + *  Copyright (c) 2010 Stephane Chatty <chatty@enac.fr>

The copyright looks bogus :)

[... snip ... ]
> +static struct hid_device_id ubt780_devices[] = {
> +	{ HID_USB_DEVICE(0x04da, 0x1044) },
> +	{ }

Here you are adding only one device ID, which seems to be slight 
discrepancy with the change in hid-core.

> +};
> +MODULE_DEVICE_TABLE(hid, ubt780_devices);
> +
> +static const struct hid_usage_id ubt780_grabbed_usages[] = {
> +	{ HID_ANY_ID, HID_ANY_ID, HID_ANY_ID },
> +	{ HID_ANY_ID - 1, HID_ANY_ID - 1, HID_ANY_ID - 1}
> +};

Why do you need this?


> diff --git a/drivers/hid/ubt780ctrl.h b/drivers/hid/ubt780ctrl.h
> new file mode 100644
> index 0000000..11810c8
> --- /dev/null
> +++ b/drivers/hid/ubt780ctrl.h
> @@ -0,0 +1,108 @@
> +/*
> + *  USB HID driver for Panasonic elite Panaboard UTB780
> + *  Copyright (c) 2008 Igor Shakirov, Victor Grenke <comp.vision@gmail.com>
> +
> + * Information.
> + * It's driver for supporting Panaboard elite USB device.
> + * The driver is redesigned using usb hid core driver:
> + * Copyright (c) 1999 Andreas Gal
> + * Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
> + * Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
> + * Copyright (c) 2010 Panasonic
> + */
> +
> +/*
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + */
> +
> +#ifndef UBT780CTRL
> +#define UBT780CTRL
> +
> +//////////////////////////////////////////////////////////////////////////////////////////////////
> +//IOCTRL codes
> +/** Battary status IOCTL defines */
> +#define GET_BATTERY_STATUS		0x01 /*get battery status, return BATTERY_STATUS_UKN, BATTERY_STATUS_FINE, BATTERY_STATUS_WEAK*/
> +#define GET_LAST_PACKET_OLD		0x02 /*get last packet (ubt780_dgtzr). It is necessary for calibration*/
> +
> +/** Modes of work IOCTL */
> +#define GET_MODE			0x10 /*get current mode, return MODE_MOUSE, MODE_DGTZR*/
> +#define SET_MODE			0x11 /*switch to mouse mode, MODE_MOUSE, MODE_DGTZR*/
> +#define SET_CALIB			0x20 /*set calibration mode*/
> +#define GET_LAST_PACKET			0x21 /*get last packet (ubt780_dgtzr). It is necessary for calibration*/
> +
> +////////////////////////////////
> +//return values for ioctrl
> +/** Battary status defines */
> +#define BATTERY_STATUS_FINE		0x00 /*battery is fine*/
> +#define BATTERY_STATUS_WEAK		0x01 /*battery is weak*/
> +#define BATTERY_STATUS_UKN		0x02 /*unknown status. Status will be known after the first pen touch*/
> +
> +/** Mode status defines */
> +#define MODE_MOUSE			0x10 /*current mode is mouse*/
> +#define MODE_DGTZR			0x11 /*current mode is digitizer*/
> +#define MODE_UKN			0x12 /*current mode is unknown. It will be known after the first pen touch*/
> +
> +////////////////////////////////
> +/** Digitize mode stucture: contains packet data */
> +struct ubt780_dgtzr
> +{
> +	/** Report contains the type of packet: 0 - mouse, 1 - digitize */
> +	unsigned char report;
> +	/** Command is coming from device */
> +	unsigned char command;
> +	/** Packet size */
> +	unsigned char number;
> +	/** Data part of packet */
> +	unsigned char data[17];
> +};
> +
> +/** Calibration stucture: contains calibration data */
> +struct ubt780_calib
> +{
> +	/** Screen coordinates: Left Top X */
> +	int LTx;
> +	/** Screen coordinates: Left Top Y */
> +	int LTy;
> +	/** Screen coordinates: Left Bottom X */
> +	int LBx;
> +	/** Screen coordinates: Left Bottom Y */
> +	int LBy;
> +	/** Screen coordinates: Right Top X */
> +	int RTx;
> +	/** Screen coordinates: Right Top Y */
> +	int RTy;
> +	/** Screen coordinates: Right Bottom X */
> +	int RBx;
> +	/** Screen coordinates: Right Bottom Y */
> +	int RBy;
> +
> +	/** Board coordinates: Left Top X */
> +	int LTX;
> +	/** Board coordinates: Left Top Y */
> +	int LTY;
> +	/** Board coordinates: Left Bottom X */
> +	int LBX;
> +	/** Board coordinates: Left Bottom Y */
> +	int LBY;
> +	/** Board coordinates: Right Top X */
> +	int RTX;
> +	/** Board coordinates: Right Top Y */
> +	int RTY;
> +	/** Board coordinates: Right Bottom X */
> +	int RBX;
> +	/** Board coordinates: Right Bottom Y */
> +	int RBY;
> +
> +	/** Calculated values */
> +	int Xoff_A;
> +	int Xmag_A;
> +	int Xmag_B;
> +	int Yoff_A;
> +	int Ymag_A;
> +	int Ymag_B;
> +};
> +
> +#endif //UBT780CTRL

This file is completely not compliant with kernel coding style, but that's 
not a main issue right now.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

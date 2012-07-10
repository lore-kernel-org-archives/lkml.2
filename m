Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2GJUFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 16:05:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab2GJUFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 16:05:45 -0400
Date: Tue, 10 Jul 2012 22:05:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Yuri Khan <yurivkhan@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 1/1] Input: xpad - Handle all variations of Mad Catz
 Beat Pad
In-Reply-To: <1341941602-18418-1-git-send-email-yurivkhan@gmail.com>
Message-ID: <alpine.LNX.2.00.1207102205290.19366@pobox.suse.cz>
References: <1341592324-665-1-git-send-email-yurivkhan@gmail.com> <1341941602-18418-1-git-send-email-yurivkhan@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012, Yuri Khan wrote:

> * Add this device to usbhid ignore list
> ---
>  drivers/hid/hid-core.c        |    1 +
>  drivers/hid/hid-ids.h         |    3 +++

Acked-by: Jiri Kosina <jkosina@suse.cz>

>  drivers/input/joystick/xpad.c |    1 +
>  3 files changed, 5 insertions(+)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 6ac0286..1540934 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1995,6 +1995,7 @@ static const struct hid_device_id hid_ignore_list[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_MCT) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HYBRID) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LD, USB_DEVICE_ID_LD_HEATCONTROL) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_BEATPAD) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1024LS) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_MCC, USB_DEVICE_ID_MCC_PMD1208LS) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICKIT1) },
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index d1cdd2d..43c3d75 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -518,6 +518,9 @@
>  #define USB_DEVICE_ID_CRYSTALTOUCH	0x0006
>  #define USB_DEVICE_ID_CRYSTALTOUCH_DUAL	0x0007
>  
> +#define USB_VENDOR_ID_MADCATZ		0x0738
> +#define USB_DEVICE_ID_MADCATZ_BEATPAD	0x4540
> +
>  #define USB_VENDOR_ID_MCC		0x09db
>  #define USB_DEVICE_ID_MCC_PMD1024LS	0x0076
>  #define USB_DEVICE_ID_MCC_PMD1208LS	0x007a
> diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
> index ee16fb6..16974ef 100644
> --- a/drivers/input/joystick/xpad.c
> +++ b/drivers/input/joystick/xpad.c
> @@ -238,6 +238,7 @@ static struct usb_device_id xpad_table [] = {
>  	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
>  	XPAD_XBOX360_VENDOR(0x046d),		/* Logitech X-Box 360 style controllers */
>  	XPAD_XBOX360_VENDOR(0x0738),		/* Mad Catz X-Box 360 controllers */
> +	{ USB_DEVICE(0x0738, 0x4540) },		/* Mad Catz Beat Pad */
>  	XPAD_XBOX360_VENDOR(0x0e6f),		/* 0x0e6f X-Box 360 controllers */
>  	XPAD_XBOX360_VENDOR(0x12ab),		/* X-Box 360 dance pads */
>  	XPAD_XBOX360_VENDOR(0x1430),		/* RedOctane X-Box 360 controllers */
> -- 
> 1.7.9.5
> 

-- 
Jiri Kosina
SUSE Labs

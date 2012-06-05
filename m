Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503Ab2FEJes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:34:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab2FEJeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:34:46 -0400
Date: Tue, 5 Jun 2012 11:34:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Austin Hendrix <ahendrix@willowgarage.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add Support for Novatek Touchscreen
In-Reply-To: <CAOY97VZN2a36OBsacQS21P8G70L2tbtbWK5OMWhZYa=D74XO+w@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1206051134020.5478@pobox.suse.cz>
References: <CAOY97VZN2a36OBsacQS21P8G70L2tbtbWK5OMWhZYa=D74XO+w@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2012, Austin Hendrix wrote:

> Add support for a Novatek touchscreen panel as a generic HID multitouch
> panel.
> 
> Signed-off-by: Austin Hendrix <ahendrix@willowgarage.com>
> ---
>  hid-core.c       |    1 +
>  hid-ids.h        |    3 +++
>  hid-multitouch.c |    5 +++++
>  3 files changed, 9 insertions(+)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 8e3a6b2..0d6dde1 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1605,6 +1605,7 @@ static const struct hid_device_id
> hid_have_special_driver[] = {

Austin,

thanks for the patch. Your mail client is corrupting (line-wrapping) 
patches. Please fix that for your future submissions.

I have now fixed that up manually and applied.

>  	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_16) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_17) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_18) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_NOVATEK, USB_DEVICE_ID_NOVATEK_PCT) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_PKB1700) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ORTEK, USB_DEVICE_ID_ORTEK_WKB2000) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_PETALYNX,
> USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE) },
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 9373f53..734a2b9 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -564,6 +564,9 @@
>  #define USB_VENDOR_ID_NINTENDO		0x057e
>  #define USB_DEVICE_ID_NINTENDO_WIIMOTE	0x0306
> 
> +#define USB_VENDOR_ID_NOVATEK		0x0603
> +#define USB_DEVICE_ID_NOVATEK_PCT	0x0600
> +
>  #define USB_VENDOR_ID_NTRIG		0x1b96
>  #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN   0x0001
>  #define USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_1   0x0003
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 6e3332a..fae08df 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -951,6 +951,11 @@ static const struct hid_device_id mt_devices[] = {
>  		MT_USB_DEVICE(USB_VENDOR_ID_PANASONIC,
>  			USB_DEVICE_ID_PANABOARD_UBT880) },
> 
> +	/* Novatek Panel */
> +	{ .driver_data = MT_CLS_DEFAULT,
> +		HID_USB_DEVICE(USB_VENDOR_ID_NOVATEK,
> +			USB_DEVICE_ID_NOVATEK_PCT) },
> +
>  	/* PenMount panels */
>  	{ .driver_data = MT_CLS_CONFIDENCE,
>  		MT_USB_DEVICE(USB_VENDOR_ID_PENMOUNT,
> 

-- 
Jiri Kosina
SUSE Labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab1CIIoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 03:44:37 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:55432 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756904Ab1CIIoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 03:44:25 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 9 Mar 2011 09:46:45 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] hid-multitouch: migrate 3M PCT touch screens to the
 unified driver.
Message-ID: <20110309084645.GB3569@polaris.bitmath.org>
References: <1299601979-4871-1-git-send-email-benjamin.tissoires@enac.fr>
 <1299601979-4871-4-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299601979-4871-4-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1PxEzv-0000nn-5y.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PxEzv-0000nn-5y 852b587071ad73e44d521cbcf05599e2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Tue, Mar 08, 2011 at 05:32:58PM +0100, Benjamin Tissoires wrote:
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> ---

Semms this patch is missing a commit message.

[...]
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index e7a4f83..f32bf46 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -5,6 +5,11 @@
>   *  Copyright (c) 2010-2011 Benjamin Tissoires <benjamin.tissoires@gmail.com>
>   *  Copyright (c) 2010-2011 Ecole Nationale de l'Aviation Civile, France
>   *
> + *  based on hid-3m-pct.c copyrighted as follows:
> + *    Copyright (c) 2009-2010 Stephane Chatty <chatty@enac.fr>
> + *    Copyright (c) 2010      Henrik Rydberg <rydberg@euromail.se>
> + *    Copyright (c) 2010      Canonical, Ltd.
> + *
>   */
>  
>  /*
> @@ -74,6 +79,7 @@ struct mt_class {
>  #define MT_CLS_DUAL_INRANGE_CONTACTNUMBER	3
>  #define MT_CLS_CYPRESS				4
>  #define MT_CLS_STANTUM				5
> +#define MT_CLS_3M				6
>  
>  /*
>   * these device-dependent functions determine what slot corresponds
> @@ -124,6 +130,11 @@ struct mt_class mt_classes[] = {
>  		.maxcontacts = 10 },
>  	{ .name = MT_CLS_STANTUM,
>  		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE },
> +	{ .name = MT_CLS_3M,
> +		.quirks = MT_QUIRK_VALID_IS_CONFIDENCE |
> +			MT_QUIRK_SLOT_IS_CONTACTID,
> +		.sn_move = 2048,
> +		.sn_pressure = 128 },
>  
>  	{ }
>  };
> @@ -479,6 +490,14 @@ static void mt_remove(struct hid_device *hdev)
>  
>  static const struct hid_device_id mt_devices[] = {
>  
> +	/* 3M panels */
> +	{ .driver_data = MT_CLS_3M,
> +		HID_USB_DEVICE(USB_VENDOR_ID_3M,
> +			USB_DEVICE_ID_3M1968) },
> +	{ .driver_data = MT_CLS_3M,
> +		HID_USB_DEVICE(USB_VENDOR_ID_3M,
> +			USB_DEVICE_ID_3M2256) },
> +
>  	/* Cypress panel */
>  	{ .driver_data = MT_CLS_CYPRESS,
>  		HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS,

The touch width correction from the original driver has gone missing
here. Otherwise, looks good, but will defer testing to the next round.

Cheers,
Henrik

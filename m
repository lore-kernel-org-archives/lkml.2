Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab2I0Jww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 05:52:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab2I0Jwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 05:52:51 -0400
Date: Thu, 27 Sep 2012 11:52:40 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: GeneralTouch <aroundight77@gmail.com>
Cc: yxhma <yxhma@163.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: Re: [PATCH 1/1] hid:Fix problem on GeneralTouch multi-touchscreen
In-Reply-To: <1348725525-3687-1-git-send-email-aroundight77@gmail.com>
Message-ID: <alpine.LNX.2.00.1209271149250.3587@pobox.suse.cz>
References: <1348725525-3687-1-git-send-email-aroundight77@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012, GeneralTouch wrote:

> From: Xianhan Yu <aroundight77@gmail.com>
> 
> Fix the touch-up no response problem on GeneralTouch twofingers 
> touchscreen and modify the driver for new GeneralTouch PWT touchscreen.
> 
> Signed-off-by: Xianhan Yu <aroundight77@gmail.com>

Thank you for the patch. Please find a few comments below. Please address 
those and resubmit.

Also adding Henrik to CC, as he is maintainer of hid multitouch.

> ---
>  drivers/hid/hid-ids.h        |    1 +
>  drivers/hid/hid-multitouch.c |   18 +++++++++++++++++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 1dcb76f..1325695 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -305,6 +305,7 @@
>  
>  #define USB_VENDOR_ID_GENERAL_TOUCH	0x0dfc
>  #define USB_DEVICE_ID_GENERAL_TOUCH_WIN7_TWOFINGERS 0x0003
> +#define USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PWT_TENFINGERS 0x0100
>  
>  #define USB_VENDOR_ID_GLAB		0x06c2
>  #define USB_DEVICE_ID_4_PHIDGETSERVO_30	0x0038
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 59c8b5c..959a892 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -115,6 +115,8 @@ struct mt_device {
>  #define MT_CLS_EGALAX_SERIAL			0x0104
>  #define MT_CLS_TOPSEED				0x0105
>  #define MT_CLS_PANASONIC			0x0106
> +#define MT_CLS_GENERALTOUCH_TWOFINGERS          0X0107
> +#define MT_CLS_GENERALTOUCH_PWT_TENFINGERS      0X0108

Please use '0x' here as a prefix. Both are correct, but the convention is 
to use 0x at least in the kernel.

Also please use tabs instead of spaces to properly align with the rest of 
the constants.

>  
>  #define MT_DEFAULT_MAXCONTACT	10
>  
> @@ -215,6 +217,17 @@ static struct mt_class mt_classes[] = {
>  	{ .name = MT_CLS_PANASONIC,
>  		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP,
>  		.maxcontacts = 4 },
> +        { .name = MT_CLS_GENERALTOUCH_TWOFINGERS,
> +		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
> +                        MT_QUIRK_VALID_IS_INRANGE |
> +		        MT_QUIRK_SLOT_IS_CONTACTNUMBER,
> +		.maxcontacts = 2 
> +        },
> +        { .name = MT_CLS_GENERALTOUCH_PWT_TENFINGERS,
> +		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
> +                        MT_QUIRK_SLOT_IS_CONTACTNUMBER,
> +		.maxcontacts = 10 
> +        },

Please use tabs as well here, to use the same formatting as the rest of 
the file.

>  
>  	{ }
>  };
> @@ -893,9 +906,12 @@ static const struct hid_device_id mt_devices[] = {
>  			USB_DEVICE_ID_ELO_TS2515) },
>  
>  	/* GeneralTouch panel */
> -	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
> +	{ .driver_data = MT_CLS_GENERALTOUCH_TWOFINGERS,
>  		MT_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
>  			USB_DEVICE_ID_GENERAL_TOUCH_WIN7_TWOFINGERS) },
> +        { .driver_data = MT_CLS_GENERALTOUCH_PWT_TENFINGERS,
> +		MT_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
> +			USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PWT_TENFINGERS) },
>  
>  	/* Gametel game controller */
>  	{ .driver_data = MT_CLS_DEFAULT,

And here as well.

-- 
Jiri Kosina
SUSE Labs

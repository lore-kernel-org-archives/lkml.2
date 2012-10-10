Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2JJQh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 12:37:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58696 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab2JJQh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 12:37:57 -0400
Date: Wed, 10 Oct 2012 09:37:47 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Yann Cantin <yann.cantin@laposte.net>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [ebeam PATCH v2 1/2] hid: Blacklist eBeam devices
Message-ID: <20121010163747.GD19335@core.coreip.homeip.net>
References: <1349529287-23193-1-git-send-email-yann.cantin@laposte.net>
 <1349529287-23193-2-git-send-email-yann.cantin@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349529287-23193-2-git-send-email-yann.cantin@laposte.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

Are you OK with this change?

Yann,

Is the device usable at all with generic HID driver? If it isn't then
maybe we should blacklist it unconditionally?

Thanks.

On Sat, Oct 06, 2012 at 03:14:46PM +0200, Yann Cantin wrote:
> 
> Signed-off-by: Yann Cantin <yann.cantin@laposte.net>
> ---
>  drivers/hid/hid-core.c |    3 +++
>  drivers/hid/hid-ids.h  |    3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index bd3971b..59ffaa2 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1937,6 +1937,9 @@ static const struct hid_device_id hid_ignore_list[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_DELORME, USB_DEVICE_ID_DELORME_EM_LT20) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_DREAM_CHEEKY, 0x0004) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_DREAM_CHEEKY, 0x000a) },
> +#if defined(CONFIG_INPUT_EBEAM_USB)
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_EFI, USB_DEVICE_ID_EFI_EBEAM) },
> +#endif
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ESSENTIAL_REALITY, USB_DEVICE_ID_ESSENTIAL_REALITY_P5) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ETT, USB_DEVICE_ID_TC5UH) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ETT, USB_DEVICE_ID_TC4UM) },
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 269b509..df826b8 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -274,6 +274,9 @@
>  #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72D0      0x72d0
>  #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_72C4      0x72c4
>  
> +#define USB_VENDOR_ID_EFI		0x2650
> +#define USB_DEVICE_ID_EFI_EBEAM		0x1311
> +
>  #define USB_VENDOR_ID_ELECOM		0x056e
>  #define USB_DEVICE_ID_ELECOM_BM084	0x0061
>  
> -- 
> 1.7.10
> 

-- 
Dmitry

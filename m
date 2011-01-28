Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab1A1RS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 12:18:59 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:34038 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753964Ab1A1RS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 12:18:57 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 28 Jan 2011 18:18:52 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hid-multitouch: work on default classes and renaming
 of classes
Message-ID: <20110128171852.GA2586@polaris.bitmath.org>
References: <1296230680-2871-1-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296230680-2871-1-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.192.164
X-Scan-Result: No virus found in message 1PirxO-00040C-BN.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PirxO-00040C-BN cc438e87a81e5724f70912d20bd882f1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> The safest quirk for a device (the one that works out of the box for
> most of them) is the MT_QUIRK_NOT_SEEN_MEANS_UP. Indeed, it does not
> make any assumption on the device. When adding a new device, we can
> easily test it against MT_CLS_DEFAULT, and then optimize it with other
> quirks: that's why no device use MT_CLS_DEFAULT right now.
> 
> This patch introduce also MT_CLS_DUAL_DEFAULT which has the same purpose
> than MT_CLS_DEFAULT, but for dual touch panels.

But it is used anywhere?
 
> Finally, the patch renames MT_CLS_DUAL1 to MT_CLS_DUAL_INRANGE_CONTACTID
> and MT_CLS_DUAL2 to MT_CLS_DUAL_INRANGE_CONTACTNUMBER for better
> readability.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> ---

The patch description and the content lacks a certain
distinctness. Please single out janitory actions into a separate
patch, or, if possible, skip it altogether.

>  drivers/hid/hid-multitouch.c |   25 +++++++++++++++----------
>  1 files changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 07d3183..ffe2a76 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -24,6 +24,7 @@
>  
>  
>  MODULE_AUTHOR("Stephane Chatty <chatty@enac.fr>");
> +MODULE_AUTHOR("Benjamin Tissoires <benjamin.tissoires@gmail.com>");

Adding this is fine, based on your prior contributions. Perhaps it
should be motivated as such in a separate patch instead.

>  MODULE_DESCRIPTION("HID multitouch panels");
>  MODULE_LICENSE("GPL");
>  
> @@ -65,10 +66,11 @@ struct mt_class {
>  };
>  
>  /* classes of device behavior */
> -#define MT_CLS_DEFAULT	1
> -#define MT_CLS_DUAL1	2
> -#define MT_CLS_DUAL2	3
> -#define MT_CLS_CYPRESS	4
> +#define MT_CLS_DEFAULT				1
> +#define MT_CLS_DUAL_DEFAULT			2
> +#define MT_CLS_DUAL_INRANGE_CONTACTID		3
> +#define MT_CLS_DUAL_INRANGE_CONTACTNUMBER	4
> +#define MT_CLS_CYPRESS				10

There is no need to change the numbering for unchanged names.

>  
>  /*
>   * these device-dependent functions determine what slot corresponds
> @@ -104,13 +106,16 @@ static int find_slot_from_contactid(struct mt_device *td)
>  
>  struct mt_class mt_classes[] = {
>  	{ .name = MT_CLS_DEFAULT,
> -		.quirks = MT_QUIRK_VALID_IS_INRANGE,
> +		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP,
>  		.maxcontacts = 10 },
> -	{ .name = MT_CLS_DUAL1,
> +	{ .name = MT_CLS_DUAL_DEFAULT,
> +		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP,
> +		.maxcontacts = 2 },
> +	{ .name = MT_CLS_DUAL_INRANGE_CONTACTID,
>  		.quirks = MT_QUIRK_VALID_IS_INRANGE |
>  			MT_QUIRK_SLOT_IS_CONTACTID,
>  		.maxcontacts = 2 },
> -	{ .name = MT_CLS_DUAL2,
> +	{ .name = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
>  		.quirks = MT_QUIRK_VALID_IS_INRANGE |
>  			MT_QUIRK_SLOT_IS_CONTACTNUMBER,
>  		.maxcontacts = 2 },
> @@ -466,15 +471,15 @@ static const struct hid_device_id mt_devices[] = {
>  			USB_DEVICE_ID_CYPRESS_TRUETOUCH) },
>  
>  	/* GeneralTouch panel */
> -	{ .driver_data = MT_CLS_DUAL2,
> +	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
>  		HID_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
>  			USB_DEVICE_ID_GENERAL_TOUCH_WIN7_TWOFINGERS) },
>  
>  	/* PixCir-based panels */
> -	{ .driver_data = MT_CLS_DUAL1,
> +	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
>  		HID_USB_DEVICE(USB_VENDOR_ID_HANVON,
>  			USB_DEVICE_ID_HANVON_MULTITOUCH) },
> -	{ .driver_data = MT_CLS_DUAL1,
> +	{ .driver_data = MT_CLS_DUAL_INRANGE_CONTACTID,
>  		HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
>  			USB_DEVICE_ID_CANDO_PIXCIR_MULTI_TOUCH) },
>  
> -- 
> 1.7.3.4
> 

Thanks,
Henrik

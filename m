Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab0KKIjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 03:39:51 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65347 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab0KKIjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 03:39:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ALfuZx0R/gasJuYkaq2ILGW7PuvGz3T05SXdybJ4/wcEbgNTughBuoHr2i8TaoQHMD
         frm4bzKYxpH2z8LOtJDhxCdNMv86diee0QJY6uHk5nRQHuxKsGYNHGNb0DZPMcqIq3EU
         Vv1Jg0BjpkLt4TxpPCoFhy22I4bzwchRr9l8o=
Date: Thu, 11 Nov 2010 00:39:41 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Edgar (gimli) Hucek" <gimli@dark-green.com>, stable@kernel.org
Subject: Re: [PATCH] input: bcm5974: Add support for MacBookAir3
Message-ID: <20101111083941.GE24415@core.coreip.homeip.net>
References: <1289320722-1948-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289320722-1948-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 05:38:42PM +0100, Henrik Rydberg wrote:
> From: Edgar (gimli) Hucek <gimli@dark-green.com>
> 
> This patch adds support for the MacBookAir3,1 and MacBookAir3,2
> models.
> 
> [rydberg@euromail.se: touchpad range calibration]
> Cc: stable@kernel.org
> Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi Dmitry, Jiri,
> 
> This patch was seen on lkml last week, and has now been excercised by
> a larger set of users. As usual, this patch should go before or
> together with the HID changes, so as not to break basic support from
> the non-MT HID driver.
> 

Jiri,

It looks like HID changes are more than simply adding USB device IDs so
it woudl make sense to merge through your tree,

Thanks.

> Cheers,
> Henrik
> 
>  drivers/input/mouse/bcm5974.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 40 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
> index b952317..ee82851 100644
> --- a/drivers/input/mouse/bcm5974.c
> +++ b/drivers/input/mouse/bcm5974.c
> @@ -55,6 +55,14 @@
>  #define USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI	0x0236
>  #define USB_DEVICE_ID_APPLE_WELLSPRING3_ISO	0x0237
>  #define USB_DEVICE_ID_APPLE_WELLSPRING3_JIS	0x0238
> +/* MacbookAir3,2 (unibody), aka wellspring5 */
> +#define USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI	0x023f
> +#define USB_DEVICE_ID_APPLE_WELLSPRING4_ISO	0x0240
> +#define USB_DEVICE_ID_APPLE_WELLSPRING4_JIS	0x0241
> +/* MacbookAir3,1 (unibody), aka wellspring4 */
> +#define USB_DEVICE_ID_APPLE_WELLSPRING4A_ANSI	0x0242
> +#define USB_DEVICE_ID_APPLE_WELLSPRING4A_ISO	0x0243
> +#define USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS	0x0244
>  
>  #define BCM5974_DEVICE(prod) {					\
>  	.match_flags = (USB_DEVICE_ID_MATCH_DEVICE |		\
> @@ -80,6 +88,14 @@ static const struct usb_device_id bcm5974_table[] = {
>  	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING3_ANSI),
>  	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING3_ISO),
>  	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING3_JIS),
> +	/* MacbookAir3,2 */
> +	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI),
> +	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING4_ISO),
> +	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING4_JIS),
> +	/* MacbookAir3,1 */
> +	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING4A_ANSI),
> +	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING4A_ISO),
> +	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS),
>  	/* Terminating entry */
>  	{}
>  };
> @@ -234,6 +250,30 @@ static const struct bcm5974_config bcm5974_config_table[] = {
>  		{ DIM_X, DIM_X / SN_COORD, -4460, 5166 },
>  		{ DIM_Y, DIM_Y / SN_COORD, -75, 6700 }
>  	},
> +	{
> +		USB_DEVICE_ID_APPLE_WELLSPRING4_ANSI,
> +		USB_DEVICE_ID_APPLE_WELLSPRING4_ISO,
> +		USB_DEVICE_ID_APPLE_WELLSPRING4_JIS,
> +		HAS_INTEGRATED_BUTTON,
> +		0x84, sizeof(struct bt_data),
> +		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
> +		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
> +		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
> +		{ DIM_X, DIM_X / SN_COORD, -4620, 5140 },
> +		{ DIM_Y, DIM_Y / SN_COORD, -150, 6600 }
> +	},
> +	{
> +		USB_DEVICE_ID_APPLE_WELLSPRING4A_ANSI,
> +		USB_DEVICE_ID_APPLE_WELLSPRING4A_ISO,
> +		USB_DEVICE_ID_APPLE_WELLSPRING4A_JIS,
> +		HAS_INTEGRATED_BUTTON,
> +		0x84, sizeof(struct bt_data),
> +		0x81, TYPE2, FINGER_TYPE2, FINGER_TYPE2 + SIZEOF_ALL_FINGERS,
> +		{ DIM_PRESSURE, DIM_PRESSURE / SN_PRESSURE, 0, 300 },
> +		{ DIM_WIDTH, DIM_WIDTH / SN_WIDTH, 0, 2048 },
> +		{ DIM_X, DIM_X / SN_COORD, -4616, 5112 },
> +		{ DIM_Y, DIM_Y / SN_COORD, -142, 5234 }
> +	},
>  	{}
>  };
>  
> -- 
> 1.7.1
> 

-- 
Dmitry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab0HWTWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 15:22:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:52672 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab0HWTWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 15:22:03 -0400
Date: Mon, 23 Aug 2010 12:18:59 -0700
From: Greg KH <gregkh@suse.de>
To: Dirk DeSchepper <ddeschepper@nvtl.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: option: Removing hardware ID disabling Novatel
 modems
Message-ID: <20100823191859.GA8529@suse.de>
References: <B29F014DE7B1F949B0BC4C1EBCF29DD67B0EBD@Vectra.nvtl.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B29F014DE7B1F949B0BC4C1EBCF29DD67B0EBD@Vectra.nvtl.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 07:43:41PM +0100, Dirk DeSchepper wrote:
> Unfortunately some of the hardware PID belonging to auto-install CDROM (AICD) of Novatel modems found their way into the option module. This causes the AICD to be treated as a modem 
> in stead of a disk. Since the modem ports do not appear until after the AICD is ejected, this essentially disables the modem. After a couple of minutes the AICD should auto-eject, but
> it is just too long a wait. The frequency of the failure seems to depend on both the hardware and the linux distribution.
> 
> Below is a patch for the issue (also adding a couple of new PID, offering some explanations and removing some incomplete and unnecessary comments) against the latest stable kernel 
> source (2.6.35.2). 
> 
> Please CC me on all issue related to this patch. 

Please wrap your emails at 72 columns like a sane person :)

I also need a "Signed-off-by:" line to be able to apply this patch.

> 
> diff -uNr linux-2.6.35.2_original/drivers/usb/serial/option.c linux-2.6.35.2/drivers/usb/serial/option.c
> --- linux-2.6.35.2_original/drivers/usb/serial/option.c	2010-08-20 12:03:42.000000000 +0200
> +++ linux-2.6.35.2/drivers/usb/serial/option.c	2010-08-20 16:35:50.000000000 +0200
> @@ -164,6 +164,15 @@
>  #define YISO_VENDOR_ID				0x0EAB
>  #define YISO_PRODUCT_U893			0xC893
>  
> +/* 
> + * NOVATEL WIRELESS PRODUCTS
> + *
> + * Note from Novatel Wireless:
> + * If your Novatel modem does not work on linux, don't 

Trailing space :(

> + * change the option module, but check our website. If
> + * that does not help, contact ddeschepper 
> + * at nvtl dot com

Please spell out your email address.

> +*/ 

Another trailing space :(

>  /* MERLIN EVDO PRODUCTS */
>  #define NOVATELWIRELESS_PRODUCT_V640		0x1100
>  #define NOVATELWIRELESS_PRODUCT_V620		0x1110
> @@ -189,20 +198,38 @@
>  /* OVATION PRODUCTS */
>  #define NOVATELWIRELESS_PRODUCT_MC727		0x4100
>  #define NOVATELWIRELESS_PRODUCT_MC950D		0x4400
> -#define NOVATELWIRELESS_PRODUCT_U727		0x5010
> -#define NOVATELWIRELESS_PRODUCT_MC727_NEW	0x5100
> -#define NOVATELWIRELESS_PRODUCT_MC760		0x6000
> +/*  

And another one :(

Please fix your editor to show those up in bright red so you don't apply
them.

Also, please run your patches through the scripts/checkpatch.pl script
to find all of these issues before sending them to me and having me find
them for you...

> + * Note from Novatel Wireless:
> + * All PID in the 5xxx range are currently reserved for
> + * auto-install CDROMs, and should not be added to this
> + * module.
> + *
> + * #define NOVATELWIRELESS_PRODUCT_U727		0x5010
> + * #define NOVATELWIRELESS_PRODUCT_MC727_NEW	0x5100
> +*/
>  #define NOVATELWIRELESS_PRODUCT_OVMC760		0x6002
> +#define NOVATELWIRELESS_PRODUCT_MC780		0x6010
>  
> -/* FUTURE NOVATEL PRODUCTS */
> +#define NOVATELWIRELESS_PRODUCT_EVDO_FULLSPEED	0X6000

Lowercase x please.

>  #define NOVATELWIRELESS_PRODUCT_EVDO_HIGHSPEED	0X6001
>  #define NOVATELWIRELESS_PRODUCT_HSPA_FULLSPEED	0X7000
>  #define NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED	0X7001
> +#define NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED3	0X7003
> +#define NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED4	0X7004
> +#define NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED5	0X7005
> +#define NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED6	0X7006
> +#define NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED7	0X7007
> +#define NOVATELWIRELESS_PRODUCT_MC996D		0X7030
> +#define NOVATELWIRELESS_PRODUCT_MF3470		0X7041
> +#define NOVATELWIRELESS_PRODUCT_MC547		0X7042
>  #define NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_FULLSPEED	0X8000
>  #define NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_HIGHSPEED	0X8001
>  #define NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_FULLSPEED	0X9000
>  #define NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_HIGHSPEED	0X9001
> -#define NOVATELWIRELESS_PRODUCT_GLOBAL		0XA001
> +
> +#define NOVATELWIRELESS_PRODUCT_G1		0XA001
> +#define NOVATELWIRELESS_PRODUCT_G1_M		0XA002
> +#define NOVATELWIRELESS_PRODUCT_G2		0XA010
>  
>  /* AMOI PRODUCTS */
>  #define AMOI_VENDOR_ID				0x1614
> @@ -490,36 +517,45 @@
>  	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_ETS1220, 0xff, 0xff, 0xff) },
>  	{ USB_DEVICE(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E14AC) },
>  	{ USB_DEVICE(AMOI_VENDOR_ID, AMOI_PRODUCT_9508) },
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) }, /* Novatel Merlin V640/XV620 */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V620) }, /* Novatel Merlin V620/S620 */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V740) }, /* Novatel Merlin EX720/V740/X720 */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V720) }, /* Novatel Merlin V720/S720/PC720 */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_U730) }, /* Novatel U730/U740 (VF version) */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_U740) }, /* Novatel U740 */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_U870) }, /* Novatel U870 */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_XU870) }, /* Novatel Merlin XU870 HSDPA/3G */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_X950D) }, /* Novatel X950D */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EV620) }, /* Novatel EV620/ES620 CDMA/EV-DO */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_ES720) }, /* Novatel ES620/ES720/U720/USB720 */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_E725) }, /* Novatel E725/E726 */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_ES620) }, /* Novatel Merlin ES620 SM Bus */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EU730) }, /* Novatel EU730 and Vodafone EU740 */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EU740) }, /* Novatel non-Vodafone EU740 */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EU870D) }, /* Novatel EU850D/EU860D/EU870D */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC950D) }, /* Novatel MC930D/MC950D */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC727) }, /* Novatel MC727/U727/USB727 */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC727_NEW) }, /* Novatel MC727/U727/USB727 refresh */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_U727) }, /* Novatel MC727/U727/USB727 */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_MC760) }, /* Novatel MC760/U760/USB760 */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_OVMC760) }, /* Novatel Ovation MC760 */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_FULLSPEED) }, /* Novatel HSPA product */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_FULLSPEED) }, /* Novatel EVDO Embedded product */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_FULLSPEED) }, /* Novatel HSPA Embedded product */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_HIGHSPEED) }, /* Novatel EVDO product */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED) }, /* Novatel HSPA product */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_HIGHSPEED) }, /* Novatel EVDO Embedded product */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_HIGHSPEED) }, /* Novatel HSPA Embedded product */
> -	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_GLOBAL) }, /* Novatel Global product */
> +
> +	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V640) },
> +	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_V620) }, 

Why did you strip off the names of the devices?

And again, trailing whitespace :(

Care to redo this patch?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab2JKFms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 01:42:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43150 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab2JKFmm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 01:42:42 -0400
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: Constantine Shulyupin <const@MakeLinux.com>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] usb: remove CONFIG_USB_MUSB_HOST etc
Thread-Topic: [PATCH] usb: remove CONFIG_USB_MUSB_HOST etc
Thread-Index: AQHNpVd+gQmEDX6glk2Cf0f3EaSh+5ezmWdg
Date: Thu, 11 Oct 2012 05:42:25 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC3E9CA495@DBDE01.ent.ti.com>
References: <1349702227-24875-1-git-send-email-const@MakeLinux.com>
In-Reply-To: <1349702227-24875-1-git-send-email-const@MakeLinux.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Mon, Oct 08, 2012 at 18:47:07, Constantine Shulyupin wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>
> 
> Remove USB configuration in arch/arm/mach-davinci/usb.c accordingly 
> CONFIG_USB_MUSB_OTG CONFIG_USB_MUSB_PERIPHERAL CONFIG_USB_MUSB_HOST 
> and set MUSB_OTG configuration by default
> because this configuration options are removed from Kconfig.
> 
> Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>
>  
> ---
>  arch/arm/mach-davinci/usb.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/usb.c b/arch/arm/mach-davinci/usb.c
> index f77b953..34509ff 100644
> --- a/arch/arm/mach-davinci/usb.c
> +++ b/arch/arm/mach-davinci/usb.c
> @@ -42,14 +42,8 @@ static struct musb_hdrc_config musb_config = {
>  };
>  
>  static struct musb_hdrc_platform_data usb_data = {
> -#if defined(CONFIG_USB_MUSB_OTG)
>  	/* OTG requires a Mini-AB connector */
>  	.mode           = MUSB_OTG,
> -#elif defined(CONFIG_USB_MUSB_PERIPHERAL)
> -	.mode           = MUSB_PERIPHERAL,
> -#elif defined(CONFIG_USB_MUSB_HOST)
> -	.mode           = MUSB_HOST,
> -#endif
>  	.clock		= "usb",
>  	.config		= &musb_config,
>  };

Tested it on DM6446-EVM for host mode with MSC thumb drive and gadget 
mode with g-ether. It works.

Acked-by: Manjunathappa, Prakash <prakash.pm@ti.com>

Thanks,
Prakash

> -- 
> 1.7.9.5
> 
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 


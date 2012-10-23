Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab2JWMfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 08:35:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56039 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756903Ab2JWMfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 08:35:09 -0400
Message-ID: <50868EED.7050909@ti.com>
Date: Tue, 23 Oct 2012 18:04:53 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Constantine Shulyupin <const@MakeLinux.com>
CC: <gregkh@linuxfoundation.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] usb: remove CONFIG_USB_MUSB_HOST etc
References: <1349702227-24875-1-git-send-email-const@MakeLinux.com>
In-Reply-To: <1349702227-24875-1-git-send-email-const@MakeLinux.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/2012 6:47 PM, Constantine Shulyupin wrote:
> From: Constantine Shulyupin <const@MakeLinux.com>
> 
> Remove USB configuration in arch/arm/mach-davinci/usb.c accordingly 
> CONFIG_USB_MUSB_OTG CONFIG_USB_MUSB_PERIPHERAL CONFIG_USB_MUSB_HOST 
> and set MUSB_OTG configuration by default
> because this configuration options are removed from Kconfig.
> 
> Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>

Queuing this patch for v3.8. Since the config options are removed there
is no use having code which refers to them. The patch has been tested on
DM644x and DM365 in both host and gadget mode (I will add this
information to commit text while committing). Without this patch .mode
seems to be defaulting to MUSB_UNDEFINED which I think is definitely wrong.

Thanks,
Sekhar

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
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab1JYVQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 17:16:35 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:58643 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab1JYVQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 17:16:34 -0400
Message-ID: <4EA7255D.6020102@atmel.com>
Date: Tue, 25 Oct 2011 23:08:45 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH] ARM: at91: Fix USBA gadget registration
References: <1319568666-10745-1-git-send-email-jochen@scram.de>
In-Reply-To: <1319568666-10745-1-git-send-email-jochen@scram.de>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2011 08:51 PM, Jochen Friedrich :
> Since 193ab2a6070039e7ee2b9b9bebea754a7c52fd1b, various AT91 boards don't
> register USBA adapters anymore due to depending on a now non-existing
> symbol. Fix the symbol name.

Friedrich,

Thanks a lot for this patch... and moreover I have just retrieved it in
my backlog: sorry for not having taken care of it earlier.

But actually, it is too bad that this patch has broken those tree boards.

> Signed-off-by: Jochen Friedrich <jochen@scram.de>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

I queue it in my at91-fixes branch and send it to Arnd soon.

Best regards,

> CC: stable@kernel.org

^^^^
Yes, for sure!

> ---
>  arch/arm/mach-at91/at91cap9_devices.c    |    2 +-
>  arch/arm/mach-at91/at91sam9g45_devices.c |    2 +-
>  arch/arm/mach-at91/at91sam9rl_devices.c  |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91cap9_devices.c b/arch/arm/mach-at91/at91cap9_devices.c
> index dba0d8d..0512baf 100644
> --- a/arch/arm/mach-at91/at91cap9_devices.c
> +++ b/arch/arm/mach-at91/at91cap9_devices.c
> @@ -92,7 +92,7 @@ void __init at91_add_device_usbh(struct at91_usbh_data *data) {}
>   *  USB HS Device (Gadget)
>   * -------------------------------------------------------------------- */
>  
> -#if defined(CONFIG_USB_GADGET_ATMEL_USBA) || defined(CONFIG_USB_GADGET_ATMEL_USBA_MODULE)
> +#if defined(CONFIG_USB_ATMEL_USBA) || defined(CONFIG_USB_ATMEL_USBA_MODULE)
>  
>  static struct resource usba_udc_resources[] = {
>  	[0] = {
> diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
> index 600bffb..371bb0e 100644
> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
> @@ -191,7 +191,7 @@ void __init at91_add_device_usbh_ehci(struct at91_usbh_data *data) {}
>   *  USB HS Device (Gadget)
>   * -------------------------------------------------------------------- */
>  
> -#if defined(CONFIG_USB_GADGET_ATMEL_USBA) || defined(CONFIG_USB_GADGET_ATMEL_USBA_MODULE)
> +#if defined(CONFIG_USB_ATMEL_USBA) || defined(CONFIG_USB_ATMEL_USBA_MODULE)
>  static struct resource usba_udc_resources[] = {
>  	[0] = {
>  		.start	= AT91SAM9G45_UDPHS_FIFO,
> diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
> index aacb19d..c884d59 100644
> --- a/arch/arm/mach-at91/at91sam9rl_devices.c
> +++ b/arch/arm/mach-at91/at91sam9rl_devices.c
> @@ -75,7 +75,7 @@ void __init at91_add_device_hdmac(void) {}
>   *  USB HS Device (Gadget)
>   * -------------------------------------------------------------------- */
>  
> -#if defined(CONFIG_USB_GADGET_ATMEL_USBA) || defined(CONFIG_USB_GADGET_ATMEL_USBA_MODULE)
> +#if defined(CONFIG_USB_ATMEL_USBA) || defined(CONFIG_USB_ATMEL_USBA_MODULE)
>  
>  static struct resource usba_udc_resources[] = {
>  	[0] = {


-- 
Nicolas Ferre

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761504Ab2ERIIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:08:47 -0400
Received: from antcom.de ([188.40.178.216]:60935 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759814Ab2ERIIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:08:44 -0400
Message-ID: <4FB6038A.90201@antcom.de>
Date: Fri, 18 May 2012 10:08:42 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] gpio/lpc32xx: Fixup of_xlate for core changes
References: <1337285060-31919-1-git-send-email-grant.likely@secretlab.ca> <1337285060-31919-3-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1337285060-31919-3-git-send-email-grant.likely@secretlab.ca>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 10:04 PM, Grant Likely wrote:
> Hi Roland,
> 
> I've reworked the of_xlate code for gpios in a way that I'm happier with, but it is untested.  Can you try it out with this patch to your code and make sure it works properly for you?  You can roll this change into your patch if it works.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Roland Stigge <stigge@antcom.de>

(After fixing the typo below.)

Tested-by: Roland Stigge <stigge@antcom.de>

> ---
>  drivers/gpio/gpio-lpc32xx.c |   13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-lpc32xx.c b/drivers/gpio/gpio-lpc32xx.c
> index d42bf6c..6ea7b38 100644
> --- a/drivers/gpio/gpio-lpc32xx.c
> +++ b/drivers/gpio/gpio-lpc32xx.c
> @@ -464,18 +464,15 @@ void __init lpc32xx_gpio_init(void)
>  {
>  }
>  
> -static int lpc32xx_of_xlate(struct gpio_chip **gc,
> +static int lpc32xx_of_xlate(struct gpio_chip *gc,
>  			    const struct of_phandle_args *gpiospec, u32 *flags)
>  {
> -	u32 bank;
> -	if (WARN_ON(gpiospec->args_count < 3))
> +	/* Is this the correct bank? */
> +	u32 bank = gpiospec->args[0];
> +	if ((bank > ARRAY_SIZE(lpc32xx_gpiochip) ||
> +	    (gc != &lpc32xx_gpiochip[bank].chip))

One final closing parenthesis is missing here.

>  		return -EINVAL;
>  
> -	bank = gpiospec->args[0];
> -	if (WARN_ON(bank > 5))
> -		return -EINVAL;
> -
> -	*gc = &lpc32xx_gpiochip[bank].chip;
>  	if (flags)
>  		*flags = gpiospec->args[2];
>  	return gpiospec->args[1];


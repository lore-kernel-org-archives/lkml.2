Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab2LRAiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 19:38:17 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:31203 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752253Ab2LRAiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 19:38:16 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/C1vIQjio98/NMRP9ABfUm6oqoruidUsI=
Date: Mon, 17 Dec 2012 19:38:10 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ARM: Dove: add Cubox sdhci card detect gpio
Message-ID: <20121218003810.GP21694@titan.lakedaemon.net>
References: <1355790269-10596-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1355790269-10596-3-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355790269-10596-3-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Tue, Dec 18, 2012 at 01:24:29AM +0100, Sebastian Hesselbarth wrote:
> Card detect for sdhci on Cubox is connected to the wrong pin
> (sdio1_cd instead of sdio0_cd). With support for cd-gpios and
> pinctrl add the corresponding properties to DT for Cubox.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/boot/dts/dove-cubox.dts |   14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dts
> index fed7d3f..cdee96f 100644
> --- a/arch/arm/boot/dts/dove-cubox.dts
> +++ b/arch/arm/boot/dts/dove-cubox.dts
> @@ -26,10 +26,15 @@
>  };
>  
>  &uart0 { status = "okay"; };
> -&sdio0 { status = "okay"; };
>  &sata0 { status = "okay"; };
>  &i2c0 { status = "okay"; };
>  
> +&sdio0 {
> +	status = "okay";
> +	/* sdio0 card detect is connected to wrong pin on CuBox */
> +	cd-gpios = <&gpio0 12 1>;

this looks like a fix that should be merged into v3.8, I'll cue it up
for v3.8-rc2.

thx,

Jason.

> +};
> +
>  &spi0 {
>  	status = "okay";
>  
> @@ -42,9 +47,14 @@
>  };
>  
>  &pinctrl {
> -	pinctrl-0 = <&pmx_gpio_18>;
> +	pinctrl-0 = <&pmx_gpio_12 &pmx_gpio_18>;
>  	pinctrl-names = "default";
>  
> +	pmx_gpio_12: pmx-gpio-12 {
> +		marvell,pins = "mpp12";
> +		marvell,function = "gpio";
> +	};
> +
>  	pmx_gpio_18: pmx-gpio-18 {
>  		marvell,pins = "mpp18";
>  		marvell,function = "gpio";
> -- 
> 1.7.10.4
> 

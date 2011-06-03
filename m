Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab1FCSI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:08:58 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55319 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1FCSI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:08:57 -0400
Date: Fri, 3 Jun 2011 12:08:56 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net, patches@linaro.org
Subject: Re: [PATCH] leds: remove config option LEDS_GPIO_PLATFORM from
 Kconfig
Message-ID: <20110603180856.GG15616@ponder.secretlab.ca>
References: <1306830223-18850-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306830223-18850-1-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 04:23:43PM +0800, Shawn Guo wrote:
> Since the commit a314c5c0040aab51ebb1ecfd37a9198a91962243
> (leds/leds-gpio: merge platform_driver with of_platform_driver),
> the config option LEDS_GPIO_PLATFORM becomes useless, so remove it.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>

Applied, thanks, and modified to also remove LEDS_GPIO_OF, changing
the #ifdef to check CONFIG_OF_GPIO instead.

g.

> ---
>  drivers/leds/Kconfig |   10 +---------
>  1 files changed, 1 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 23f0d5e..af86cbd 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -93,7 +93,7 @@ config LEDS_NET48XX
>  config LEDS_NET5501
>  	tristate "LED Support for Soekris net5501 series Error LED"
>  	depends on LEDS_TRIGGERS
> -	depends on X86 && LEDS_GPIO_PLATFORM && GPIO_CS5535
> +	depends on X86 && GPIO_CS5535
>  	select LEDS_TRIGGER_DEFAULT_ON
>  	default n
>  	help
> @@ -183,14 +183,6 @@ config LEDS_GPIO
>  	  defined as platform devices and/or OpenFirmware platform devices.
>  	  The code to use these bindings can be selected below.
>  
> -config LEDS_GPIO_PLATFORM
> -	bool "Platform device bindings for GPIO LEDs"
> -	depends on LEDS_GPIO
> -	default y
> -	help
> -	  Let the leds-gpio driver drive LEDs which have been defined as
> -	  platform devices.  If you don't know what this means, say yes.
> -
>  config LEDS_GPIO_OF
>  	bool "OpenFirmware platform device bindings for GPIO LEDs"
>  	depends on LEDS_GPIO && OF_DEVICE
> -- 
> 1.7.4.1
> 

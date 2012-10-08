Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab2JHV75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 17:59:57 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:55169 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751705Ab2JHV7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:59:55 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/KsXj07B63ydZb0FsmRPEn
Date: Mon, 8 Oct 2012 14:59:51 -0700
From: Tony Lindgren <tony@atomide.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bryan Wu <bryan.wu@canonical.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: OMAP: Fix dependency for OMAP_DEBUG_LEDS
Message-ID: <20121008215950.GV13011@atomide.com>
References: <1349604805.6017.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349604805.6017.1.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Axel Lin <axel.lin@ingics.com> [121007 03:14]:
> This fixes below build error when CONFIG_LEDS_CLASS is not set.
> 
>   LD      init/built-in.o
> arch/arm/plat-omap/built-in.o: In function `fpga_probe':
> arch/arm/plat-omap/debug-leds.c:113: undefined reference to `led_classdev_register'
> arch/arm/plat-omap/debug-leds.c:113: undefined reference to `led_classdev_register'
> arch/arm/plat-omap/debug-leds.c:113: undefined reference to `led_classdev_register'
> arch/arm/plat-omap/debug-leds.c:113: undefined reference to `led_classdev_register'
> arch/arm/plat-omap/debug-leds.c:113: undefined reference to `led_classdev_register'
> arch/arm/plat-omap/built-in.o:arch/arm/plat-omap/debug-leds.c:113: more undefined references to `led_classdev_register' follow
> make: *** [vmlinux] Error 1
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Thanks looks like I have already an earlier version of the same
patch from you already queued.

Regards,

Tony

> ---
>  arch/arm/plat-omap/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
> index ca83a76..c262781 100644
> --- a/arch/arm/plat-omap/Kconfig
> +++ b/arch/arm/plat-omap/Kconfig
> @@ -43,6 +43,7 @@ config OMAP_DEBUG_DEVICES
>  
>  config OMAP_DEBUG_LEDS
>  	def_bool y if NEW_LEDS
> +	select LEDS_CLASS
>  	depends on OMAP_DEBUG_DEVICES
>  
>  config POWER_AVS_OMAP
> -- 
> 1.7.9.5
> 
> 
> 

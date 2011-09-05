Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1IENKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 09:10:00 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:12430 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab1IENJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 09:09:58 -0400
Date: Mon, 5 Sep 2011 15:09:42 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Luciano Coelho <coelho@ti.com>, Randy Dunlap <rdunlap@xenotime.net>,
        matti.j.aaltonen@nokia.com, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] mfd: remove CONFIG_MFD_SUPPORT
Message-ID: <20110905150942.54aecf4e@endymion.delvare>
In-Reply-To: <201109021643.36369.arnd@arndb.de>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net>
	<201108311849.37273.arnd@arndb.de>
	<20110902143713.307bbebe@endymion.delvare>
	<201109021643.36369.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Sep 2011 16:43:36 +0200, Arnd Bergmann wrote:
> We currently have two symbols to control compilation the MFD subsystem,
> MFD_SUPPORT and MFD_CORE. The MFD_SUPPORT is actually not required
> at all, it only hides the submenu when not set, with the effect that
> Kconfig warns about missing dependencies when another driver selects
> an MFD driver while MFD_SUPPORT is disabled. Turning the MFD submenu
> back from menuconfig into a plain menu simplifies the Kconfig syntax
> for those kinds of users and avoids the surprise when the menu
> suddenly appears because another driver was enabled that selects this
> symbol.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-omap2/Kconfig |    1 -
>  drivers/gpio/Kconfig        |    3 +--
>  drivers/i2c/busses/Kconfig  |    1 -
>  drivers/media/radio/Kconfig |    1 -
>  drivers/mfd/Kconfig         |   22 ++++------------------
>  5 files changed, 5 insertions(+), 23 deletions(-)
> (...)
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -2,23 +2,8 @@
>  # Multifunction miscellaneous devices
>  #
>  
> -menuconfig MFD_SUPPORT
> -	bool "Multifunction device drivers"
> -	depends on HAS_IOMEM
> -	default y
> -	help
> -	  Multifunction devices embed several functions (e.g. GPIOs,
> -	  touchscreens, keyboards, current regulators, power management chips,
> -	  etc...) in one single integrated circuit. They usually talk to the
> -	  main CPU through one or more IRQ lines and low speed data busses (SPI,
> -	  I2C, etc..). They appear as one single device to the main system
> -	  through the data bus and the MFD framework allows for sub devices
> -	  (a.k.a. functions) to appear as discrete platform devices.
> -	  MFDs are typically found on embedded platforms.
> -
> -	  This option alone does not add any kernel code.
> -
> -if MFD_SUPPORT
> +if HAS_IOMEM
> +menu "Multifunction device drivers"
>  
>  config MFD_CORE
>  	tristate

I think I prefer Luciano's proposal, for the same reasons given for the
misc device drivers patch. But here again I'm not the one making the
decision, so it's up to Samuel to decide which patch he wants to apply.


-- 
Jean Delvare

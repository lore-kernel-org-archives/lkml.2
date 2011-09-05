Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab1IEMmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 08:42:47 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:22362 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1IEMmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 08:42:40 -0400
Date: Mon, 5 Sep 2011 14:41:34 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Luciano Coelho <coelho@ti.com>, Randy Dunlap <rdunlap@xenotime.net>,
        matti.j.aaltonen@nokia.com, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] misc: remove CONFIG_MISC_DEVICES
Message-ID: <20110905144134.2c80c4b9@endymion.delvare>
In-Reply-To: <201109021643.14275.arnd@arndb.de>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net>
	<201108311849.37273.arnd@arndb.de>
	<20110902143713.307bbebe@endymion.delvare>
	<201109021643.14275.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, 2 Sep 2011 16:43:14 +0200, Arnd Bergmann wrote:
> Since misc devices have nothing in common besides fitting in no
> other category, there is no need to group them in one Kconfig
> symbol. Simply removing the symbol gets rid of all sorts of
> Kconfig warnings about missing dependencies when another driver
> selects a misc driver without also selecting MISC_DEVICES.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-davinci/Kconfig |    6 ------
>  arch/unicore32/Kconfig        |    1 -
>  drivers/misc/Kconfig          |   26 ++++++++------------------
>  drivers/mmc/host/Kconfig      |    1 -
>  4 files changed, 8 insertions(+), 26 deletions(-)
> (...)
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -2,23 +2,7 @@
>  # Misc strange devices
>  #
>  
> -# This one has to live outside of the MISC_DEVICES conditional,
> -# because it may be selected by drivers/platform/x86/hp_accel.
> -config SENSORS_LIS3LV02D
> -	tristate
> -	depends on INPUT
> -	select INPUT_POLLDEV
> -	default n
> -
> -menuconfig MISC_DEVICES
> -	bool "Misc devices"
> -	---help---
> -	  Say Y here to get to see options for device drivers from various
> -	  different categories. This option alone does not add any kernel code.
> -
> -	  If you say N, all options in this submenu will be skipped and disabled.
> -
> -if MISC_DEVICES
> +menu "Misc devices"

As said before, I'm not sure. Yes, it makes it easier to select misc
device drivers from Kconfig files. But it also makes it impossible to
deselect all misc device drivers at once.

I think that what we really need is the implementation in the Kconfig
system of smart selects, i.e. whenever an entry is selected, everything
it depends on gets selected as well. I don't know how feasible this is,
but if it can be done then I'd prefer this to your proposal.

Meanwhile, I am not in favor of applying your patch. The benefit is
relatively small IMHO (misc device drivers are rarely selected) and
there is one significant drawback.

That being said, I'm not the one to decide, so if you can convince
someone with more power (aka Andrew Morton)...

>  
>  config AD525X_DPOT
>  	tristate "Analog Devices Digital Potentiometers"
> @@ -344,6 +328,12 @@ config ISL29020
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called isl29020.
>  
> +config SENSORS_LIS3LV02D
> +	tristate
> +	depends on INPUT
> +	select INPUT_POLLDEV
> +	default n
> +

If you patch gets applied, then this one would better be moved to
drivers/misc/lis3lv02d/Kconfig.

-- 
Jean Delvare

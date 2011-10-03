Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab1JCFTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 01:19:22 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:49847 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976Ab1JCFTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 01:19:17 -0400
Message-ID: <4E8945CE.6070800@ti.com>
Date: Mon, 03 Oct 2011 10:49:10 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 23/30] ARM: omap2: select twl4030 support on boards that
 need it
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-24-git-send-email-arnd@arndb.de>
In-Reply-To: <1317566760-25681-24-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 08:15 PM, Arnd Bergmann wrote:
> These three boards unconditionally use the twl4030 driver
> from the board-zoom-display.c file. Make sure that the driver
> is always there.
> We also need to select the I2C core so we are able to build
> that driver.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-omap2/Kconfig |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index 57b66d5..4deeade 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -253,6 +253,8 @@ config MACH_OMAP_ZOOM2
>  	select SERIAL_CORE_CONSOLE
>  	select SERIAL_8250_CONSOLE
>  	select REGULATOR_FIXED_VOLTAGE
> +	select TWL4030_CORE
> +	select I2C
>  
Another option to ensure I2C is selected when
TWL* drivers are selected is let it depends
on I2C. That wat we can avoid patching every
machine entry with I2C option.
Not a strong opinion though.

Regards
Santosh


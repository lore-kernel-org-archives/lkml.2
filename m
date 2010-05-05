Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab0EEUZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:25:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40696 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab0EEUZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:25:32 -0400
Date: Wed, 5 May 2010 22:25:29 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Anders Larsen <al@alarsen.net>
Cc: patches@arm.linux.org.uk, Andrew Victor <avictor.za@gmail.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [at91] Save power by disabling the processor clock when CPU is
	idle
Message-ID: <20100505202529.GB25037@pengutronix.de>
References: <1271156732l.25331l.7l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1271156732l.25331l.7l@i-dmzi_al.realan.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 13, 2010 at 01:05:32PM +0200, Anders Larsen wrote:
> Disable the processor clock when the CPU is idle.
> 
> This saves much more power than merely entering 'Wait for Interrupt' mode.
> Since JTAG-debugging doesn't work when the processor clock is switched off,
> make it conditional on CONFIG_DEBUG_KERNEL.
> 
> Signed-off-by: Anders Larsen <al@alarsen.net>
> Cc: Andrew Victor <avictor.za@gmail.com>
> ---
> KernelVersion: 2.6.33
> 
>  arch/arm/mach-at91/include/mach/system.h |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> 
> Index: b/arch/arm/mach-at91/include/mach/system.h
> ===================================================================
> --- a/arch/arm/mach-at91/include/mach/system.h
> +++ b/arch/arm/mach-at91/include/mach/system.h
> @@ -24,21 +24,24 @@
>  #include <mach/hardware.h>
>  #include <mach/at91_st.h>
>  #include <mach/at91_dbgu.h>
> +#include <mach/at91_pmc.h>
>  
>  static inline void arch_idle(void)
>  {
> +#ifndef CONFIG_DEBUG_KERNEL
>  	/*
>  	 * Disable the processor clock.  The processor will be automatically
>  	 * re-enabled by an interrupt or by a reset.
>  	 */
> -//	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
> -
> +	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
> +#else
>  	/*
>  	 * Set the processor (CP15) into 'Wait for Interrupt' mode.
>  	 * Unlike disabling the processor clock via the PMC (above)
>  	 *  this allows the processor to be woken via JTAG.
>  	 */
>  	cpu_do_idle();
> +#endif

There is a kernel parameter (IIRC "nohlt") that should take care of
this?!

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

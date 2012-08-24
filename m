Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030288Ab2HXUIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:08:10 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:44603 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964868Ab2HXUIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:08:07 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+LBN83fqgkyss8IV96UccJ
Date: Fri, 24 Aug 2012 12:07:14 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: alan@linux.intel.com, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: Re: [PATCH v3 01/23] serial: omap: define and use
 to_uart_omap_port()
Message-ID: <20120824190713.GP11011@atomide.com>
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
 <1345717983-18179-2-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345717983-18179-2-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [120823 03:37]:
> current code only works because struct uart_port
> is the first member on the uart_omap_port structure.
> 
> If, for whatever reason, someone puts another
> member as the first of the structure, that cast
> won't work anymore. In order to be safe, let's use
> a container_of() which, for now, gets optimized into
> a cast anyway.
> 
> Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  arch/arm/plat-omap/include/plat/omap-serial.h |  2 ++
>  drivers/tty/serial/omap-serial.c              | 36 +++++++++++++--------------
>  2 files changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/include/plat/omap-serial.h b/arch/arm/plat-omap/include/plat/omap-serial.h
> index 1a52725..f3b35d9 100644
> --- a/arch/arm/plat-omap/include/plat/omap-serial.h
> +++ b/arch/arm/plat-omap/include/plat/omap-serial.h
> @@ -137,4 +137,6 @@ struct uart_omap_port {
>  	struct work_struct	qos_work;
>  };
>  
> +#define to_uart_omap_port(p)	((container_of((p), struct uart_omap_port, port)))
> +
>  #endif /* __OMAP_SERIAL_H__ */

For the arch/arm/*omap*/* parts:

Acked-by: Tony Lindgren <tony@atomide.com>

FYI, note that there are ARM SoC patches to move various header files to
live under include/linux/platform_data which may cause conflicts with these
changes.

Regards,

Tony

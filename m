Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab2JHUvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 16:51:04 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:45872 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754126Ab2JHUu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 16:50:58 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19XveDRV4Gem2/Cpc9oVJnL
Date: Mon, 8 Oct 2012 13:50:53 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stan Hu <stanhu@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ARM: Add option to configure output line for McSPI
 driver
Message-ID: <20121008205052.GB13011@atomide.com>
References: <y>
 <1348684467-5707-1-git-send-email-stanhu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348684467-5707-1-git-send-email-stanhu@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stan Hu <stanhu@gmail.com> [120926 11:36]:
> McSPI driver previously assumed that D0 was input (MISO) and D1 was output (MOSI).
> This forces the hardware designer to wire all SPI peripherals in this way when
> it should be a software configuration option.
> 
> Signed-off-by: Stan Hu <stanhu@gmail.com>
> ---
>  arch/arm/plat-omap/include/plat/mcspi.h |    2 ++
>  drivers/spi/spi-omap2-mcspi.c           |   11 +++++++++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/include/plat/mcspi.h b/arch/arm/plat-omap/include/plat/mcspi.h
> index a357eb2..0a6b790 100644
> --- a/arch/arm/plat-omap/include/plat/mcspi.h
> +++ b/arch/arm/plat-omap/include/plat/mcspi.h
> @@ -18,6 +18,8 @@ struct omap2_mcspi_dev_attr {
>  
>  struct omap2_mcspi_device_config {
>  	unsigned turbo_mode:1;
> +	/* 1 -> [D0 = MOSI, D1 = MISO], otherwise vice versa */
> +	unsigned d0_is_output:1;
>  };
>  
>  #endif

FYI, if this did not yet get applied, this header has now been
moved to linux/platform_data/spi-omap2-mcspi.h. So you may want
to updated it and repost.

Also, you should probably Cc spi-devel-general@lists.sourceforge.net.

Regards,

Tony

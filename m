Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab1JMRrz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 13:47:55 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64061 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab1JMRrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 13:47:53 -0400
Date: Thu, 13 Oct 2011 11:47:48 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCH 3.1-rc3] gpio/omap: fix build error with certain OMAP1
 configs
Message-ID: <20111013174748.GI18574@ponder.secretlab.ca>
References: <201108231342.25101.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108231342.25101.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 01:42:24PM +0200, Janusz Krzysztofik wrote:
> With commit f64ad1a0e21a, "gpio/omap: cleanup _set_gpio_wakeup(), remove 
> ifdefs", access to build time conditionally omitted 'suspend_wakeup' 
> member of the 'gpio_bank' structure has been placed unconditionally in 
> function _set_gpio_wakeup(), which is always built. This resulted in the 
> driver compilation broken for certain OMAP1, i.e., non-OMAP16xx, 
> configurations.
> 
> Really required or not in previously excluded cases, define this 
> structure member unconditionally as a fix.
> 
> Tested with a custom OMAP1510 only configuration.
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

Applied, thanks.

g.

> ---
>  drivers/gpio/gpio-omap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- git/drivers/gpio/gpio-omap.c.orig	2011-08-22 08:34:02.000000000 +0200
> +++ git/drivers/gpio/gpio-omap.c	2011-08-23 12:47:36.000000000 +0200
> @@ -34,8 +34,8 @@ struct gpio_bank {
>  	u16 irq;
>  	u16 virtual_irq_start;
>  	int method;
> -#if defined(CONFIG_ARCH_OMAP16XX) || defined(CONFIG_ARCH_OMAP2PLUS)
>  	u32 suspend_wakeup;
> +#if defined(CONFIG_ARCH_OMAP16XX) || defined(CONFIG_ARCH_OMAP2PLUS)
>  	u32 saved_wakeup;
>  #endif
>  	u32 non_wakeup_gpios;

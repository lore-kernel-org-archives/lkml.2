Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab2CEV7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:59:00 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:41071 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab2CEV65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:58:57 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX192CWoC77UTwR88go1sPlk3
Date: Mon, 5 Mar 2012 13:58:54 -0800
From: Tony Lindgren <tony@atomide.com>
To: Bernhard Walle <walle@corscience.de>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: GPMC: Export gpmc_enable_hwecc and
 gpmc_calculate_ecc
Message-ID: <20120305215853.GW12083@atomide.com>
References: <1329489859-23929-1-git-send-email-walle@corscience.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329489859-23929-1-git-send-email-walle@corscience.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bernhard Walle <walle@corscience.de> [120217 06:15]:
> To be able to compile kernel/drivers/mtd/nand/omap2.ko as module, that
> two symbols need to be exported. Otherwise, I get following error
> message
> 
>     ERROR: "gpmc_calculate_ecc" [drivers/mtd/nand/omap2.ko] undefined!
>     ERROR: "gpmc_enable_hwecc" [drivers/mtd/nand/omap2.ko] undefined!
> 
> Signed-off-by: Bernhard Walle <walle@corscience.de>

Thanks applying into fixes-non-critical-part2.

Regards,

Tony

> ---
>  arch/arm/mach-omap2/gpmc.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
> index dfffbbf..00d5108 100644
> --- a/arch/arm/mach-omap2/gpmc.c
> +++ b/arch/arm/mach-omap2/gpmc.c
> @@ -888,6 +888,7 @@ int gpmc_enable_hwecc(int cs, int mode, int dev_width, int ecc_size)
>  	gpmc_write_reg(GPMC_ECC_CONFIG, val);
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(gpmc_enable_hwecc);
>  
>  /**
>   * gpmc_calculate_ecc - generate non-inverted ecc bytes
> @@ -918,3 +919,4 @@ int gpmc_calculate_ecc(int cs, const u_char *dat, u_char *ecc_code)
>  	gpmc_ecc_used = -EINVAL;
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(gpmc_calculate_ecc);
> -- 
> 1.7.9.1
> 

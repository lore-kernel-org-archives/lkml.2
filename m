Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1BDWyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 17:54:19 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:48403 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030Ab1BDWyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 17:54:18 -0500
From: Kevin Hilman <khilman@ti.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/20] mach-omap2: smartreflex: world-writable debugfs voltage files
Organization: Texas Instruments, Inc.
References: <cover.1296818921.git.segoon@openwall.com>
	<96a2b24548af3a68fde712c68b49e856e53ea1fc.1296818921.git.segoon@openwall.com>
Date: Fri, 04 Feb 2011 14:54:14 -0800
In-Reply-To: <96a2b24548af3a68fde712c68b49e856e53ea1fc.1296818921.git.segoon@openwall.com>
	(Vasiliy Kulikov's message of "Fri, 4 Feb 2011 15:23:20 +0300")
Message-ID: <87zkqbjtrd.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasiliy Kulikov <segoon@openwall.com> writes:

> Don't allow everybody to change voltage settings.
>
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Cannot compile the driver, so it is not tested at all.

Acked-by: Kevin Hilman <khilman@ti.com>


>  arch/arm/mach-omap2/smartreflex.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
> index c37e823..95ac336 100644
> --- a/arch/arm/mach-omap2/smartreflex.c
> +++ b/arch/arm/mach-omap2/smartreflex.c
> @@ -900,7 +900,7 @@ static int __init omap_sr_probe(struct platform_device *pdev)
>  		return PTR_ERR(dbg_dir);
>  	}
>  
> -	(void) debugfs_create_file("autocomp", S_IRUGO | S_IWUGO, dbg_dir,
> +	(void) debugfs_create_file("autocomp", S_IRUGO | S_IWUSR, dbg_dir,
>  				(void *)sr_info, &pm_sr_fops);
>  	(void) debugfs_create_x32("errweight", S_IRUGO, dbg_dir,
>  			&sr_info->err_weight);
> @@ -939,7 +939,7 @@ static int __init omap_sr_probe(struct platform_device *pdev)
>  		strcpy(name, "volt_");
>  		sprintf(volt_name, "%d", volt_data[i].volt_nominal);
>  		strcat(name, volt_name);
> -		(void) debugfs_create_x32(name, S_IRUGO | S_IWUGO, nvalue_dir,
> +		(void) debugfs_create_x32(name, S_IRUGO | S_IWUSR, nvalue_dir,
>  				&(sr_info->nvalue_table[i].nvalue));
>  	}

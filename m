Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab1BDWxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 17:53:55 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:40726 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030Ab1BDWxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 17:53:53 -0500
From: Kevin Hilman <khilman@ti.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/20] mach-omap2: pm: world-writable debugfs timer files
Organization: Texas Instruments, Inc.
References: <cover.1296818921.git.segoon@openwall.com>
	<aabede4db6c913bc7ab7c289d09eb272594e2290.1296818921.git.segoon@openwall.com>
Date: Fri, 04 Feb 2011 14:53:48 -0800
In-Reply-To: <aabede4db6c913bc7ab7c289d09eb272594e2290.1296818921.git.segoon@openwall.com>
	(Vasiliy Kulikov's message of "Fri, 4 Feb 2011 15:23:16 +0300")
Message-ID: <874o8jl8cj.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasiliy Kulikov <segoon@openwall.com> writes:

> Don't allow all users to change timer settings.
>
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Cannot compile the driver, so it is not tested at all.

Acked-by: Kevin Hilman <khilman@ti.com>


>  arch/arm/mach-omap2/pm-debug.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/pm-debug.c b/arch/arm/mach-omap2/pm-debug.c
> index 125f565..a5a83b3 100644
> --- a/arch/arm/mach-omap2/pm-debug.c
> +++ b/arch/arm/mach-omap2/pm-debug.c
> @@ -637,14 +637,14 @@ static int __init pm_dbg_init(void)
>  
>  		}
>  
> -	(void) debugfs_create_file("enable_off_mode", S_IRUGO | S_IWUGO, d,
> +	(void) debugfs_create_file("enable_off_mode", S_IRUGO | S_IWUSR, d,
>  				   &enable_off_mode, &pm_dbg_option_fops);
> -	(void) debugfs_create_file("sleep_while_idle", S_IRUGO | S_IWUGO, d,
> +	(void) debugfs_create_file("sleep_while_idle", S_IRUGO | S_IWUSR, d,
>  				   &sleep_while_idle, &pm_dbg_option_fops);
> -	(void) debugfs_create_file("wakeup_timer_seconds", S_IRUGO | S_IWUGO, d,
> +	(void) debugfs_create_file("wakeup_timer_seconds", S_IRUGO | S_IWUSR, d,
>  				   &wakeup_timer_seconds, &pm_dbg_option_fops);
>  	(void) debugfs_create_file("wakeup_timer_milliseconds",
> -			S_IRUGO | S_IWUGO, d, &wakeup_timer_milliseconds,
> +			S_IRUGO | S_IWUSR, d, &wakeup_timer_milliseconds,
>  			&pm_dbg_option_fops);
>  	pm_dbg_init_done = 1;

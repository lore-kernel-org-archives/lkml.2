Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab2ACX61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 18:58:27 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:51999 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755136Ab2ACX6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 18:58:24 -0500
From: Kevin Hilman <khilman@ti.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] omap: use usleep_range() instead of mdelay()/udelay()
Organization: Texas Instruments, Inc.
References: <4EF18426.3040805@linaro.org>
Date: Tue, 03 Jan 2012 15:58:16 -0800
In-Reply-To: <4EF18426.3040805@linaro.org> (Dmitry Antipov's message of "Wed,
	21 Dec 2011 11:00:54 +0400")
Message-ID: <87fwfw8hk7.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Antipov <dmitry.antipov@linaro.org> writes:

> From e4db974edb5c46360465462518a88b83f1bdedf6 Mon Sep 17 00:00:00 2001
> From: Dmitry Antipov <dmitry.antipov@linaro.org>
> Date: Wed, 21 Dec 2011 10:57:08 +0400
> Subject: [PATCH] omap: use usleep_range() instead of mdelay()/udelay()

Please include a signoff and a descriptive changelog (describing why.)

Thanks,

Kevin

> ---
>  arch/arm/mach-omap2/omap_phy_internal.c |    2 +-
>  arch/arm/mach-omap2/vc.c                |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/omap_phy_internal.c b/arch/arm/mach-omap2/omap_phy_internal.c
> index 58775e3..e5dff64 100644
> --- a/arch/arm/mach-omap2/omap_phy_internal.c
> +++ b/arch/arm/mach-omap2/omap_phy_internal.c
> @@ -145,7 +145,7 @@ int omap4430_phy_suspend(struct device *dev, int suspend)
>  		/* power on the phy */
>  		if (__raw_readl(ctrl_base + CONTROL_DEV_CONF) & PHY_PD) {
>  			__raw_writel(~PHY_PD, ctrl_base + CONTROL_DEV_CONF);
> -			mdelay(200);
> +			usleep_range(200000, 201000);
>  		}
>
>  		/* restore the context */
> diff --git a/arch/arm/mach-omap2/vc.c b/arch/arm/mach-omap2/vc.c
> index 031d116..57f44d5 100644
> --- a/arch/arm/mach-omap2/vc.c
> +++ b/arch/arm/mach-omap2/vc.c
> @@ -151,7 +151,7 @@ void omap_vc_post_scale(struct voltagedomain *voltdm,
>  	/* SMPS slew rate / step size. 2us added as buffer. */
>  	smps_delay = ((smps_steps * voltdm->pmic->step_size) /
>  			voltdm->pmic->slew_rate) + 2;
> -	udelay(smps_delay);
> +	usleep_range(smps_delay, smps_delay + 10);
>  }
>
>  /* vc_bypass_scale - VC bypass method of voltage scaling */

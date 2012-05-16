Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393Ab2EPRrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:47:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39158 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759250Ab2EPRrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:47:46 -0400
Date: Wed, 16 May 2012 19:47:40 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Robert Lee <rob.lee@linaro.org>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org,
        u.kleine-koenig@pengutronix.de, richard.zhao@freescale.com,
        amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, jj@chaosbits.net
Subject: Re: [PATCH v4 4/7] ARM: imx: Enable imx53 low power idle
Message-ID: <20120516174740.GW30400@pengutronix.de>
References: <1337135616-8988-1-git-send-email-rob.lee@linaro.org>
 <1337135616-8988-5-git-send-email-rob.lee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337135616-8988-5-git-send-email-rob.lee@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:41:01 up 186 days,  1:28, 31 users,  load average: 0.00, 0.25,
 0.85
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 09:33:33PM -0500, Robert Lee wrote:
> Add various functionality needed to enable a imx53 low power idle
> state.  This includes adding the imx53 gpc_dvfs clock and making a
> common imx5_late_init function and initializing all imx53
>  MACHINE_STATE late_init calls to imx5_late_init.
> 
> Signed-off-by: Robert Lee <rob.lee@linaro.org>
> ---
>  arch/arm/mach-imx/clock-mx51-mx53.c     |    1 +
>  arch/arm/mach-imx/imx53-dt.c            |    1 +
>  arch/arm/mach-imx/mach-mx53_ard.c       |    1 +
>  arch/arm/mach-imx/mach-mx53_evk.c       |    1 +
>  arch/arm/mach-imx/mach-mx53_loco.c      |    1 +
>  arch/arm/mach-imx/mach-mx53_smd.c       |    1 +
>  arch/arm/mach-imx/mm-imx5.c             |    7 ++++++-
>  arch/arm/plat-mxc/include/mach/common.h |    1 +
>  8 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-imx/clock-mx51-mx53.c b/arch/arm/mach-imx/clock-mx51-mx53.c
> index 0847050..decedc6 100644
> --- a/arch/arm/mach-imx/clock-mx51-mx53.c
> +++ b/arch/arm/mach-imx/clock-mx51-mx53.c
> @@ -1529,6 +1529,7 @@ static struct clk_lookup mx53_lookups[] = {
>  	_REGISTER_CLOCK("imx-ssi.1", NULL, ssi2_clk)
>  	_REGISTER_CLOCK("imx-ssi.2", NULL, ssi3_clk)
>  	_REGISTER_CLOCK("imx-keypad", NULL, dummy_clk)
> +	_REGISTER_CLOCK(NULL, "gpc_dvfs", gpc_dvfs_clk)

This has to be rebased against the common clock patches.

>  	.timer = &mx53_smd_timer,
>  	.init_machine = mx53_smd_board_init,
> +	.init_late	= imx5_init_late,
>  	.restart	= mxc_restart,
>  MACHINE_END
> diff --git a/arch/arm/mach-imx/mm-imx5.c b/arch/arm/mach-imx/mm-imx5.c
> index bb38747..7740739 100644
> --- a/arch/arm/mach-imx/mm-imx5.c
> +++ b/arch/arm/mach-imx/mm-imx5.c
> @@ -216,8 +216,13 @@ void __init imx53_soc_init(void)
>  					ARRAY_SIZE(imx53_audmux_res));
>  }
>  
> +void __init imx5_init_late(void)
> +{
> +	imx5_pm_init();
> +}
> +
>  void __init imx51_init_late(void)
>  {
>  	mx51_neon_fixup();
> -	imx5_pm_init();
> +	imx5_init_late();
>  }

Where would you add i.MX53 specific code above? Hint: imx5_init_late is
the wrong function name.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

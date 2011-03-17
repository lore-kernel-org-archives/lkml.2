Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab1CQIAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 04:00:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56545 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab1CQIAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 04:00:33 -0400
Date: Thu, 17 Mar 2011 09:00:31 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        arnaud.patard@rtp-net.org, ra5478@freescale.com,
        xiao-lizhang@freescale.com, festevam@gmail.com
Subject: Re: [PATCHv3 1/3] ARM: mx51: Add entry for gpc_dvfs_clk
Message-ID: <20110317080031.GR29521@pengutronix.de>
References: <1300305787-7970-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300305787-7970-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:59:46 up 28 days, 19:57, 27 users,  load average: 0.54, 0.30,
 0.12
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 03:03:05PM -0500, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> For MX51 SRPG, we need to turn on the GPC clock in order to set the
> SRPG registers.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/mach-mx5/clock-mx51-mx53.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-mx5/clock-mx51-mx53.c b/arch/arm/mach-mx5/clock-mx51-mx53.c
> index 652ace4..18492fa 100644
> --- a/arch/arm/mach-mx5/clock-mx51-mx53.c
> +++ b/arch/arm/mach-mx5/clock-mx51-mx53.c
> @@ -865,6 +865,13 @@ static struct clk aips_tz2_clk = {
>  	.disable = _clk_ccgr_disable_inwait,
>  };
>  
> +static struct clk gpc_dvfs_clk = {
> +	.enable_reg = MXC_CCM_CCGR5,
> +	.enable_shift = MXC_CCM_CCGRx_CG12_OFFSET,
> +	.enable = _clk_ccgr_enable,
> +	.disable = _clk_ccgr_disable,
> +};
> +
>  static struct clk gpt_32k_clk = {
>  	.id = 0,
>  	.parent = &ckil_clk,
> @@ -1448,6 +1455,7 @@ static struct clk_lookup mx51_lookups[] = {
>  	_REGISTER_CLOCK("imx-ipuv3", NULL, ipu_clk)
>  	_REGISTER_CLOCK("imx-ipuv3", "di0", ipu_di0_clk)
>  	_REGISTER_CLOCK("imx-ipuv3", "di1", ipu_di1_clk)
> +	_REGISTER_CLOCK(NULL, "gpc_dvfs_clk", gpc_dvfs_clk)

Please remove the _clk. The context makes it clear already that it's a
clock.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

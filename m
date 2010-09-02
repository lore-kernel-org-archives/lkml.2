Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab0IBNVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 09:21:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41379 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab0IBNVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 09:21:14 -0400
Date: Thu, 2 Sep 2010 14:20:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] initial support for LogicPD's OMAP3530LV SOM and
	OMAP35x Torpedo dev boards
Message-ID: <20100902132058.GE26319@n2100.arm.linux.org.uk>
References: <1282708420-26418-1-git-send-email-Jacob.Tanenbaum@logicpd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282708420-26418-1-git-send-email-Jacob.Tanenbaum@logicpd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 11:53:37PM -0400, Jacob Tanenbaum wrote:
> +/* Micron MT46H32M32LF-6 */
> +/* FIXME: borrowed from sdram-micron-mt46h32m32lf-6.h because on LogicPD
> + * boards we can't use the default values -- why? I suspect the reason
> + * lies in the boot strap code. We correct this part if we have ported
> + * U-Boot and X-Load. */
> +void init_sdram(struct omap_sdrc_params *sdrc_cs0){

static?  { on the following line?

> +	sdrc_cs0[0].actim_ctrla = 0xaa9db4c6;
> +	sdrc_cs0[0].actim_ctrlb = 0x00011517;
> +	sdrc_cs0[0].rfr_ctrl    = 0x0004e201;
> +	sdrc_cs0[1].rate        = 165941176;
> +	sdrc_cs0[1].actim_ctrla = 0xaa9db4c6;
> +	sdrc_cs0[1].actim_ctrlb = 0x00011217;
> +	sdrc_cs0[1].rfr_ctrl    = 0x0004dc01;
> +	sdrc_cs0[2].actim_ctrla = 0x8a99b481;
> +	sdrc_cs0[2].actim_ctrlb = 0x00011312;
> +	sdrc_cs0[2].rfr_ctrl    = 0x0003de017;

36-bit hex numbers?

> +	sdrc_cs0[3].actim_ctrla = 0x8a99b481;
> +	sdrc_cs0[3].actim_ctrlb = 0x00011312;
> +	sdrc_cs0[3].rfr_ctrl    = 0x0003de01;
> +}
> +
> +static struct regulator_consumer_supply omap3logic_vmmc1_supply = {
> +		.supply			= "vmmc",

Any reason for the additional tabs?


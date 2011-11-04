Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab1KDXXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 19:23:31 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:43988 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155Ab1KDXXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 19:23:30 -0400
From: Kevin Hilman <khilman@ti.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, lo <linux-omap@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, lm <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] OMAP4: hwmod data: add mmu hwmod for ipu and dsp
Organization: Texas Instruments, Inc.
References: <1320185752-568-1-git-send-email-omar.ramirez@ti.com>
	<1320185752-568-3-git-send-email-omar.ramirez@ti.com>
Date: Fri, 04 Nov 2011 16:23:24 -0700
In-Reply-To: <1320185752-568-3-git-send-email-omar.ramirez@ti.com> (Omar
	Ramirez Luna's message of "Tue, 1 Nov 2011 17:15:50 -0500")
Message-ID: <87sjm31ngz.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Omar Ramirez Luna <omar.ramirez@ti.com> writes:

> Add mmu hwmod data for ipu and dsp.
>
> Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>

[...]

> +static struct omap_hwmod omap44xx_ipu_mmu_hwmod = {
> +	.name		= "ipu_mmu",
> +	.class		= &omap44xx_mmu_hwmod_class,
> +	.mpu_irqs	= omap44xx_ipu_mmu_irqs,
> +	.rst_lines	= omap44xx_ipu_mmu_resets,
> +	.rst_lines_cnt	= ARRAY_SIZE(omap44xx_ipu_mmu_resets),
> +	.main_clk	= "ipu_fck",
> +	.prcm = {
> +		.omap4 = {
> +			.rstctrl_offs = OMAP4_RM_DUCATI_RSTCTRL_OFFSET,
> +		},
> +	},
> +	.dev_attr	= &ipu_mmu_dev_attr,
> +	.slaves		= omap44xx_ipu_mmu_slaves,
> +	.slaves_cnt	= ARRAY_SIZE(omap44xx_ipu_mmu_slaves),
> +	.flags		= HWMOD_INIT_NO_RESET,

Why is this needed?

[...]

> +static struct omap_hwmod omap44xx_dsp_mmu_hwmod = {
> +	.name		= "dsp_mmu",
> +	.class		= &omap44xx_mmu_hwmod_class,
> +	.mpu_irqs	= omap44xx_dsp_mmu_irqs,
> +	.rst_lines	= omap44xx_dsp_mmu_resets,
> +	.rst_lines_cnt	= ARRAY_SIZE(omap44xx_dsp_mmu_resets),
> +	.main_clk	= "dsp_fck",
> +	.prcm = {
> +		.omap4 = {
> +			.rstctrl_offs = OMAP4_RM_TESLA_RSTCTRL_OFFSET,
> +		},
> +	},
> +	.dev_attr	= &dsp_mmu_dev_attr,
> +	.slaves		= omap44xx_dsp_mmu_slaves,
> +	.slaves_cnt	= ARRAY_SIZE(omap44xx_dsp_mmu_slaves),
> +	.flags		= HWMOD_INIT_NO_RESET,

And this?

Kevin

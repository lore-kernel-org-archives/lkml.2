Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab0IBNYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 09:24:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48296 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab0IBNYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 09:24:38 -0400
Date: Thu, 2 Sep 2010 14:24:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Enabling Ethernet support for LogicPD's OMAP
	3530LV SOM and OMAP 35x Torpedo dev board
Message-ID: <20100902132420.GG26319@n2100.arm.linux.org.uk>
References: <1282708420-26418-1-git-send-email-Jacob.Tanenbaum@logicpd.com> <1282708420-26418-2-git-send-email-Jacob.Tanenbaum@logicpd.com> <1282708420-26418-3-git-send-email-Jacob.Tanenbaum@logicpd.com> <1282708420-26418-4-git-send-email-Jacob.Tanenbaum@logicpd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282708420-26418-4-git-send-email-Jacob.Tanenbaum@logicpd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 11:53:40PM -0400, Jacob Tanenbaum wrote:
> +static inline void __init board_smsc911x_init(void)
> +{
> +	/* OMAP3530 LV SOM board */
> +	if (machine_is_omap3530_lv_som()) {
> +		board_smsc911x_data.gpio_irq =
> +					OMAP3530_LV_SOM_SMSC911X_GPIO_IRQ;
> +		/* board_smsc911x_data.gpio_reset
> +			driven by SYS_nRESWARM, no GPIO */
> +		/* omap_cfg_reg(AE1_34XX_GPIO152_UP); */
> +		omap_mux_init_signal("gpio_152", OMAP_PIN_INPUT);
> +
> +/* omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);*/
> +
> +	/* OMAP3 Torpedo board */

missing tab?  Maybe it would make sense to put this after the line below?

> +	} else if (machine_is_omap3_torpedo()) {
> +		board_smsc911x_data.gpio_irq = OMAP3_TORPEDO_SMSC911X_GPIO_IRQ;
> +		/* board_smsc911x_data.gpio_reset driven
> +			by SYS_nRESWARM, no GPIO */
> +		/*omap_cfg_reg(AE1_34XX_GPIO152_UP);*/
> +		omap_mux_init_signal("gpio_129", OMAP_PIN_INPUT);
> +		/* TODO/FIXME (comment by Peter Barada, LogicPD):
> +		* On Torpedo, LAN9221 IRQ is an MMC1_DATA7 pin
> +		* and IRQ1760 IRQ is MMC1_DATA4 pin - need
> +		* to update PBIAS to get voltage to the device
> +		* so the IRQs works correctly rather than float
> +		* and cause an IRQ storm...
> +								*/
> +		omap3torpedo_fix_pbias_voltage();
> +	/* unsupported board */

missing tab?  or maybe it should be moved after the line below.

> +	} else {
> +		printk(KERN_ERR "%s(): unknown machine type\n", __func__);
> +		return;
> +	}
> +	gpmc_smsc911x_init(&board_smsc911x_data);
> +}

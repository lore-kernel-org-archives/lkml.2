Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935367Ab2KAOgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:36:15 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:57880 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761716Ab2KAOgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:36:13 -0400
Message-ID: <509288D9.7030406@iki.fi>
Date: Thu, 01 Nov 2012 16:36:09 +0200
From: Tomi Valkeinen <tomba@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/3] da8xx-dt: Create da8xx DT adapter device
References: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com> <1351783082-11411-3-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1351783082-11411-3-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-01 17:18, Pantelis Antoniou wrote:
> omap_device is going private.
> 
> Move the da8xx-dt adapter device to arch/arm/mach-omap2.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>


> +
> +	/* display_panel */
> +	priv->lcd_panel.panel_type	= QVGA;
> +	priv->lcd_panel.max_bpp		= 16;
> +	priv->lcd_panel.min_bpp		= 16;
> +	priv->lcd_panel.panel_shade	= COLOR_ACTIVE;
> +
> +	/* lcd_ctrl_config */
> +	priv->lcd_cfg.p_disp_panel	= &priv->lcd_panel;
> +	priv->lcd_cfg.ac_bias		= 255;
> +	priv->lcd_cfg.ac_bias_intrpt	= 0;
> +	priv->lcd_cfg.dma_burst_sz	= 16;
> +	priv->lcd_cfg.bpp		= 16;
> +	priv->lcd_cfg.fdd		= 0x80;
> +	priv->lcd_cfg.tft_alt_mode	= 0;
> +	priv->lcd_cfg.stn_565_mode	= 0;
> +	priv->lcd_cfg.mono_8bit_mode	= 0;
> +	priv->lcd_cfg.invert_line_clock	= 1;
> +	priv->lcd_cfg.invert_frm_clock	= 1;
> +	priv->lcd_cfg.sync_edge		= 0;
> +	priv->lcd_cfg.sync_ctrl		= 1;
> +	priv->lcd_cfg.raster_order	= 0;
> +
> +	/* da8xx_lcdc_platform_data */
> +	strcpy(priv->lcd_pdata.manu_name, "BBToys");
> +	priv->lcd_pdata.controller_data = &priv->lcd_cfg;
> +	strcpy(priv->lcd_pdata.type, panel_type);
> +
> +	priv->lcdc_oh = omap_hwmod_lookup("lcdc");
> +	if (priv->lcdc_oh == NULL) {
> +		dev_err(&pdev->dev, "Failed to lookup omap_hwmod lcdc\n");
> +		return -ENODEV;
> +	}
> +
> +	priv->lcdc_pdev = omap_device_build("da8xx_lcdc", 0, priv->lcdc_oh,
> +			&priv->lcd_pdata,
> +			sizeof(struct da8xx_lcdc_platform_data),
> +			NULL, 0, 0);
> +	if (priv->lcdc_pdev == NULL) {
> +		dev_err(&pdev->dev, "Failed to build LCDC device\n");
> +		return -ENODEV;
> +	}

I know nothing about BeagleBone, da8xx_lcdc, or the capes, but here are
my thoughts... =)

If I understood this cape-thing correctly, to handle the LCDs properly
the da8xx_lcdc driver should be changed to be more dynamic.

The da8xx_lcdc device should be always added by the standard SoC code.
If the LCD panel is fixed for the board in question, the lcdc could be
passed the LCD data as done now (I guess).

But in beaglebone's case the platform data for lcdc should be empty, and
the lcdc driver should do just minimal setup, like memmapping its
registers. No pinmuxing nor other such things.

When the cape is identified and the cape's driver is loaded, the driver
would configure lcdc depending on the cape, including pinmuxing. After
that the LCD should be functional.

 Tomi


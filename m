Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935750Ab2KAOiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:38:11 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:46614 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933397Ab2KAOiI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:38:08 -0400
Subject: Re: [PATCH 2/3] da8xx-dt: Create da8xx DT adapter device
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <509288D9.7030406@iki.fi>
Date: Thu, 1 Nov 2012 16:38:03 +0200
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <CA59AE1A-AF06-4BB2-B0C2-C6B79021C740@antoniou-consulting.com>
References: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com> <1351783082-11411-3-git-send-email-panto@antoniou-consulting.com> <509288D9.7030406@iki.fi>
To: Tomi Valkeinen <tomba@iki.fi>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

On Nov 1, 2012, at 4:36 PM, Tomi Valkeinen wrote:

> On 2012-11-01 17:18, Pantelis Antoniou wrote:
>> omap_device is going private.
>> 
>> Move the da8xx-dt adapter device to arch/arm/mach-omap2.
>> 
>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> 
> 
>> +
>> +	/* display_panel */
>> +	priv->lcd_panel.panel_type	= QVGA;
>> +	priv->lcd_panel.max_bpp		= 16;
>> +	priv->lcd_panel.min_bpp		= 16;
>> +	priv->lcd_panel.panel_shade	= COLOR_ACTIVE;
>> +
>> +	/* lcd_ctrl_config */
>> +	priv->lcd_cfg.p_disp_panel	= &priv->lcd_panel;
>> +	priv->lcd_cfg.ac_bias		= 255;
>> +	priv->lcd_cfg.ac_bias_intrpt	= 0;
>> +	priv->lcd_cfg.dma_burst_sz	= 16;
>> +	priv->lcd_cfg.bpp		= 16;
>> +	priv->lcd_cfg.fdd		= 0x80;
>> +	priv->lcd_cfg.tft_alt_mode	= 0;
>> +	priv->lcd_cfg.stn_565_mode	= 0;
>> +	priv->lcd_cfg.mono_8bit_mode	= 0;
>> +	priv->lcd_cfg.invert_line_clock	= 1;
>> +	priv->lcd_cfg.invert_frm_clock	= 1;
>> +	priv->lcd_cfg.sync_edge		= 0;
>> +	priv->lcd_cfg.sync_ctrl		= 1;
>> +	priv->lcd_cfg.raster_order	= 0;
>> +
>> +	/* da8xx_lcdc_platform_data */
>> +	strcpy(priv->lcd_pdata.manu_name, "BBToys");
>> +	priv->lcd_pdata.controller_data = &priv->lcd_cfg;
>> +	strcpy(priv->lcd_pdata.type, panel_type);
>> +
>> +	priv->lcdc_oh = omap_hwmod_lookup("lcdc");
>> +	if (priv->lcdc_oh == NULL) {
>> +		dev_err(&pdev->dev, "Failed to lookup omap_hwmod lcdc\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	priv->lcdc_pdev = omap_device_build("da8xx_lcdc", 0, priv->lcdc_oh,
>> +			&priv->lcd_pdata,
>> +			sizeof(struct da8xx_lcdc_platform_data),
>> +			NULL, 0, 0);
>> +	if (priv->lcdc_pdev == NULL) {
>> +		dev_err(&pdev->dev, "Failed to build LCDC device\n");
>> +		return -ENODEV;
>> +	}
> 
> I know nothing about BeagleBone, da8xx_lcdc, or the capes, but here are
> my thoughts... =)
> 
> If I understood this cape-thing correctly, to handle the LCDs properly
> the da8xx_lcdc driver should be changed to be more dynamic.
> 
> The da8xx_lcdc device should be always added by the standard SoC code.
> If the LCD panel is fixed for the board in question, the lcdc could be
> passed the LCD data as done now (I guess).
> 
> But in beaglebone's case the platform data for lcdc should be empty, and
> the lcdc driver should do just minimal setup, like memmapping its
> registers. No pinmuxing nor other such things.
> 
> When the cape is identified and the cape's driver is loaded, the driver
> would configure lcdc depending on the cape, including pinmuxing. After
> that the LCD should be functional.
> 
> Tomi
> 

You are absolutely correct. That's the proper way to go about it,
but you go to war with the drivers you have, and not the drivers you wish
you had :)

Meaning, it is getting fixed by the da8xx maintainers, but it's not ready yet.

The da8xx-dt can die a short and merciful death then.

Regards

-- Pantelis
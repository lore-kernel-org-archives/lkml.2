Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab2JaFtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:49:50 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:50428 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab2JaFtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:49:46 -0400
Date: Wed, 31 Oct 2012 05:49:44 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
cc: Tony Lindgren <tony@atomide.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        "Porter, Matt" <mporter@ti.com>, "Dill, Russ" <russ.dill@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: RE: [PATCH] omap2-clk: Add missing lcdc clock definition
In-Reply-To: <79CD15C6BA57404B839C016229A409A83EB529E4@DBDE01.ent.ti.com>
Message-ID: <alpine.DEB.2.00.1210310547560.8340@utopia.booyaka.com>
References: <1351698962-3923-1-git-send-email-panto@antoniou-consulting.com> <20121030181837.GM11908@atomide.com> <alpine.DEB.2.00.1210302324530.6152@utopia.booyaka.com> <79CD15C6BA57404B839C016229A409A83EB529E4@DBDE01.ent.ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Hiremath, Vaibhav wrote:

> As far as lck clock node is concerned, we had deliberately dropped all leaf-
> node clocks from the clock tree, please refer to the description mentioned 
> in -
> http://lists.infradead.org/pipermail/linux-arm-kernel/2012-May/101987.html

Ach, should have remembered that :-(  Indeed there is an LCDC hwmod:

static struct omap_hwmod am33xx_lcdc_hwmod = {
	.name		= "lcdc",
	.class		= &am33xx_lcdc_hwmod_class,
	.clkdm_name	= "lcdc_clkdm",
	.mpu_irqs	= am33xx_lcdc_irqs,
	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
	.main_clk	= "lcd_gclk",
	.prcm		= {
		.omap4	= {
			.clkctrl_offs	= AM33XX_CM_PER_LCDC_CLKCTRL_OFFSET,
			.modulemode	= MODULEMODE_SWCTRL,
		},
	},
};

> >From LCDC driver perspective, driver is using,
> 
> fb_clk = clk_get(&device->dev, NULL);
> 
> This I feel needs to be corrected for valid name as per Spec (mostly I would 
> vote for "fck") and then every platform should make sure that it returns 
> valid clock-node for it.
> 
> Change in Driver would be,
> 
> fb_clk = clk_get(&device->dev, "fck");

Indeed.


- Paul

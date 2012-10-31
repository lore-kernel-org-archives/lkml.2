Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab2JaGim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 02:38:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44008 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab2JaGik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 02:38:40 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Paul Walmsley <paul@pwsan.com>
CC: Tony Lindgren <tony@atomide.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        "Porter, Matt" <mporter@ti.com>, "Dill, Russ" <russ.dill@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: RE: [PATCH] omap2-clk: Add missing lcdc clock definition
Thread-Topic: [PATCH] omap2-clk: Add missing lcdc clock definition
Thread-Index: AQHNtvYG6t4YD4tdv0iN86NxZoH7IpfS0m0g//+6gQCAAGmq0A==
Date: Wed, 31 Oct 2012 06:38:27 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EB52BC6@DBDE01.ent.ti.com>
References: <1351698962-3923-1-git-send-email-panto@antoniou-consulting.com>
 <20121030181837.GM11908@atomide.com>
 <alpine.DEB.2.00.1210302324530.6152@utopia.booyaka.com>
 <79CD15C6BA57404B839C016229A409A83EB529E4@DBDE01.ent.ti.com>
 <alpine.DEB.2.00.1210310547560.8340@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1210310547560.8340@utopia.booyaka.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 11:19:44, Paul Walmsley wrote:
> On Wed, 31 Oct 2012, Hiremath, Vaibhav wrote:
> 
> > As far as lck clock node is concerned, we had deliberately dropped all leaf-
> > node clocks from the clock tree, please refer to the description mentioned 
> > in -
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2012-May/101987.html
> 
> Ach, should have remembered that :-(  Indeed there is an LCDC hwmod:
> 
> static struct omap_hwmod am33xx_lcdc_hwmod = {
> 	.name		= "lcdc",
> 	.class		= &am33xx_lcdc_hwmod_class,
> 	.clkdm_name	= "lcdc_clkdm",
> 	.mpu_irqs	= am33xx_lcdc_irqs,
> 	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
> 	.main_clk	= "lcd_gclk",
> 	.prcm		= {
> 		.omap4	= {
> 			.clkctrl_offs	= AM33XX_CM_PER_LCDC_CLKCTRL_OFFSET,
> 			.modulemode	= MODULEMODE_SWCTRL,
> 		},
> 	},
> };
> 
> > >From LCDC driver perspective, driver is using,
> > 
> > fb_clk = clk_get(&device->dev, NULL);
> > 
> > This I feel needs to be corrected for valid name as per Spec (mostly I would 
> > vote for "fck") and then every platform should make sure that it returns 
> > valid clock-node for it.
> > 
> > Change in Driver would be,
> > 
> > fb_clk = clk_get(&device->dev, "fck");
> 

Ok, thanks. Let me submit patch for this.

Thanks,
Vaibhav

> Indeed.
> 
> 
> - Paul
> 


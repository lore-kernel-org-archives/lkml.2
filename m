Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab0HKRXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 13:23:01 -0400
Received: from smtp.nokia.com ([192.100.122.230]:56354 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab0HKRXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 13:23:00 -0400
Date: Wed, 11 Aug 2010 20:22:32 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rmk@arm.linux.org.uk" <rmk@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>
Subject: Re: [PATCH 1/4] initial support for LogicPD's OMAP3 SOM and
 TORPEDO development kits
Message-ID: <20100811172232.GA21391@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1281544297-18015-1-git-send-email-Jacob.Tanenbaum@logicpd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1281544297-18015-1-git-send-email-Jacob.Tanenbaum@logicpd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Aug 2010 17:22:13.0594 (UTC) FILETIME=[BD0FB3A0:01CB3979]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacob,

few style comments only

On Wed, Aug 11, 2010 at 06:31:34PM +0200, ext Jacob Tanenbaum wrote:
>
>	Adding LogicPD OMAP3 board support
>
>         Adding support for LogicPD's OMAP 3530 LV SOM and
>         OMAP 35x Torpedo board.
>	
>	 Tested against: linux-next 81e09f50c93edff607259cbe374a3006c9c5fa74
>         Signed-off-by: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>

don't tab here. Please remove.

>+static int omap3logic_twl_gpio_setup(struct device *dev,
>+				unsigned gpio, unsigned ngpio)
>+{
>+	return 0;
>+}

no gpio setup ?? If you truly don't need, you don't have to add this 
stub function.

>+static struct twl4030_gpio_platform_data omap3logic_gpio_data = {
>+	.gpio_base	= OMAP_MAX_GPIO_LINES,
>+	.irq_base	= TWL4030_GPIO_IRQ_BASE,
>+	.irq_end	= TWL4030_GPIO_IRQ_END,
>+	.use_leds	= true,
>+	.pullups	= BIT(1),
>+	.pulldowns	= BIT(2)  | BIT(6)  | BIT(7)  | BIT(8)
>+			| BIT(13) | BIT(15) | BIT(16) | BIT(17),
>+	.setup		= omap3logic_twl_gpio_setup,
>+};
>+
>+static struct twl4030_platform_data omap3logic_twldata = {
>+	.irq_base	= TWL4030_IRQ_BASE,
>+	.irq_end	= TWL4030_IRQ_END,
>+
>+	/* platform_data for children goes here */
>+	.gpio		= &omap3logic_gpio_data,

no USB on this board ?

>+static struct omap_board_config_kernel omap3logic_config[] __initdata = {
>+};

just don't assign anything ?

>+static void __init omap3logic_init_irq(void)
>+{
>+	omap_board_config = omap3logic_config;
>+	omap_board_config_size = ARRAY_SIZE(omap3logic_config);
>+	omap2_init_common_hw(mt46h32m32lf6_sdrc_params,
>+				mt46h32m32lf6_sdrc_params);
>+	omap_init_irq();
>+#ifdef CONFIG_OMAP_32K_TIMER
>+	omap2_gp_clockevent_set_gptimer(12);
>+#endif
>+	omap_gpio_init();
>+}
>+
>+
>+

one blank line only

>+static void __init omap3logic_init(void)
>+{
>+	omap3logic_i2c_init();
>+	omap_serial_init();
>+
>+	/* Ensure SDRC pins are mux'd for self-refresh */
>+/*	omap_cfg_reg(H16_34XX_SDRC_CKE0);
>+	omap_cfg_reg(H17_34XX_SDRC_CKE1);
>+	omap_cfg_reg(SDRC_CKE0);
>+	omap_cfg_reg(SDRC_CKE1); */

remove this commented code if it's not used yet.

>+#ifdef CONFIG_MACH_OMAP3_TORPEDO

no need to wrap on this ifdef, please remove.

>+#ifdef CONFIG_MACH_OMAP3530_LV_SOM

neither this.

-- 
balbi

DefectiveByDesign.org

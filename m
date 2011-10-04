Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab1JDEGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 00:06:37 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:43003 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1JDEGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 00:06:35 -0400
Date: Tue, 4 Oct 2011 15:06:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the omap_dss2 tree with the arm-soc
 tree
Message-Id: <20111004150628.4c4aa1595977f3d5165215f3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
arch/arm/mach-omap2/board-rx51.c between commit 8f5b5a41ebc7 ("ARM: OMAP:
Introduce SoC specific early_init") from the arm-soc tree and commit
cc9347352509 ("OMAP: RX51: Remove unused old omapfb stuff") from the
omap_dss2 tree.

Just context changes.  I fixed it up (I think - see below) and can carry
the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-rx51.c
index e2e958a,9e7dde6..0000000
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@@ -79,29 -79,15 +79,6 @@@ static struct cpuidle_params rx51_cpuid
  	{7505 + 15274, 484329, 1},
  };
  
- static struct omap_lcd_config rx51_lcd_config = {
- 	.ctrl_name	= "internal",
- };
- 
- static struct omap_fbmem_config rx51_fbmem0_config = {
- 	.size = 752 * 1024,
- };
- 
- static struct omap_fbmem_config rx51_fbmem1_config = {
- 	.size = 752 * 1024,
- };
- 
- static struct omap_fbmem_config rx51_fbmem2_config = {
- 	.size = 752 * 1024,
- };
- 
- static struct omap_board_config_kernel rx51_config[] = {
- 	{ OMAP_TAG_FBMEM,	&rx51_fbmem0_config },
- 	{ OMAP_TAG_FBMEM,	&rx51_fbmem1_config },
- 	{ OMAP_TAG_FBMEM,	&rx51_fbmem2_config },
- 	{ OMAP_TAG_LCD,		&rx51_lcd_config },
- };
- 
 -static void __init rx51_init_early(void)
 -{
 -	struct omap_sdrc_params *sdrc_params;
 -
 -	omap2_init_common_infrastructure();
 -	sdrc_params = nokia_get_sdram_timings();
 -	omap2_init_common_devices(sdrc_params, sdrc_params);
 -}
 -
  extern void __init rx51_peripherals_init(void);
  
  #ifdef CONFIG_OMAP_MUX
@@@ -118,17 -104,9 +95,15 @@@ static struct omap_musb_board_data musb
  
  static void __init rx51_init(void)
  {
 +	struct omap_sdrc_params *sdrc_params;
 +
  	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
- 	omap_board_config = rx51_config;
- 	omap_board_config_size = ARRAY_SIZE(rx51_config);
  	omap3_pm_init_cpuidle(rx51_cpuidle_params);
  	omap_serial_init();
 +
 +	sdrc_params = nokia_get_sdram_timings();
 +	omap_sdrc_init(sdrc_params, sdrc_params);
 +
  	usb_musb_init(&musb_board_data);
  	rx51_peripherals_init();
  

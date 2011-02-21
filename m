Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab1BUDQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 22:16:56 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35048 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab1BUDQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 22:16:54 -0500
Date: Mon, 21 Feb 2011 14:16:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
        Senthilvadivu Guruswamy <svadivu@ti.com>
Subject: linux-next: manual merge of the omap_dss2 tree with the omap tree
Message-Id: <20110221141650.71b433b7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
arch/arm/mach-omap2/board-3430sdp.c between commits
e109f171e2f4128e867b3445c369c18830c73751 ("omap3sdp: Fix regulator
mapping for ads7846 TS controller") and
6b272c098f64f0451d2b19bb911d65c6cd11cfc7 ("omap3sdp: clean regulator
supply mapping in board file") from the omap tree and various commits
from the omap_dss2 tree.

So, I have no idea how to fix this up ... Can you guys come to some
argreement about who does what, please?  I have ended up with the merge
fix below, but I have no idea if it will even build, much less be
semantically correct, sorry.

Do these trees get merged separately by Linus?  If not, then maybe I
should just be merging the one tree that combines all the omap work and
let you guys figure out the merge mess.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-3430sdp.c
index 76a260f,33ff4f6..0000000
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@@ -307,18 -307,9 +307,6 @@@ static struct omap_dss_board_info sdp34
  	.default_device	= &sdp3430_lcd_device,
  };
  
- static struct platform_device sdp3430_dss_device = {
- 	.name		= "omapdss",
- 	.id		= -1,
- 	.dev		= {
- 		.platform_data = &sdp3430_dss_data,
- 	},
- };
- 
- static struct platform_device *sdp3430_devices[] __initdata = {
- 	&sdp3430_dss_device,
- };
- 
 -static struct regulator_consumer_supply sdp3430_vdda_dac_supply =
 -	REGULATOR_SUPPLY("vdda_dac", "omap_venc");
 -
  static struct omap_board_config_kernel sdp3430_config[] __initdata = {
  };
  
@@@ -402,34 -413,6 +390,35 @@@ static struct twl4030_madc_platform_dat
  	.irq_line	= 1,
  };
  
 +/* regulator consumer mappings */
 +
 +/* ads7846 on SPI */
 +static struct regulator_consumer_supply sdp3430_vaux3_supplies[] = {
 +	REGULATOR_SUPPLY("vcc", "spi1.0"),
 +};
 +
 +static struct regulator_consumer_supply sdp3430_vdda_dac_supplies[] = {
 +	REGULATOR_SUPPLY("vdda_dac", "omapdss"),
 +};
 +
 +/* VPLL2 for digital video outputs */
 +static struct regulator_consumer_supply sdp3430_vpll2_supplies[] = {
 +	REGULATOR_SUPPLY("vdds_dsi", "omapdss"),
++	REGULATOR_SUPPLY("vdds_dsi", "omap_dsi1"),
 +};
 +
 +static struct regulator_consumer_supply sdp3430_vmmc1_supplies[] = {
 +	REGULATOR_SUPPLY("vmmc", "mmci-omap-hs.0"),
 +};
 +
 +static struct regulator_consumer_supply sdp3430_vsim_supplies[] = {
 +	REGULATOR_SUPPLY("vmmc_aux", "mmci-omap-hs.0"),
 +};
 +
 +static struct regulator_consumer_supply sdp3430_vmmc2_supplies[] = {
 +	REGULATOR_SUPPLY("vmmc", "mmci-omap-hs.1"),
 +};
 +
  /*
   * Apply all the fixed voltages since most versions of U-Boot
   * don't bother with that initialization.

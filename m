Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab1BXDXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 22:23:22 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37022 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071Ab1BXDXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 22:23:20 -0500
Date: Thu, 24 Feb 2011 14:23:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>, Tony Lindgren <tony@atomide.com>,
        Senthilvadivu Guruswamy <svadivu@ti.com>
Subject: linux-next: manual merge of the omap_dss2 tree with the  tree
Message-Id: <20110224142316.6706625a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
arch/arm/mach-omap2/board-3430sdp.c between commit
73a92aa4f1d6786eaa5b4e637eee648db0dfd7a7 ("omap3sdp: clean regulator
supply mapping in board file") from the omap tree and commit
b3e0ccec47b179b0d3a7bfdb9df7112e508b009c ("OMAP2,3 DSS2 Change driver
name to omap_display") from the omap_dss2 tree.

I fixed it up (see below) and can carry this fix as necessary (though I
have no idea if it is correct).

[The merge today did, however, lose most of the other conflicts, thanks]
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-3430sdp.c
index 8950ecc,b4b89fd..0000000
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@@ -307,9 -307,9 +307,6 @@@ static struct omap_dss_board_info sdp34
  	.default_device	= &sdp3430_lcd_device,
  };
  
--static struct regulator_consumer_supply sdp3430_vdda_dac_supply =
- 	REGULATOR_SUPPLY("vdda_dac", "omapdss");
- 
 -	REGULATOR_SUPPLY("vdda_dac", "omap_venc");
 -
  static struct omap_board_config_kernel sdp3430_config[] __initdata = {
  };
  
@@@ -393,34 -412,6 +390,36 @@@ static struct twl4030_madc_platform_dat
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
- 	REGULATOR_SUPPLY("vdda_dac", "omapdss"),
++	REGULATOR_SUPPLY("vdda_dac", "omap_venc"),
 +};
 +
++
 +/* VPLL2 for digital video outputs */
 +static struct regulator_consumer_supply sdp3430_vpll2_supplies[] = {
- 	REGULATOR_SUPPLY("vdds_dsi", "omapdss"),
++	REGULATOR_SUPPLY("vdds_dsi", "omap_display"),
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

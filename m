Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab1AMB6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 20:58:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48008 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250Ab1AMB6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 20:58:17 -0500
Date: Thu, 13 Jan 2011 12:58:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@beagleboard.org>, Nishanth Menon <nm@ti.com>,
        Tony Lindgren <tony@atomide.com>, Bryan Wu <bryan.wu@canonical.com>,
        Tomi Valkeinen <tomi.valkeinen@nokia.com>
Subject: linux-next: manual merge of the fbdev tree with the omap tree
Message-Id: <20110113125811.d651c695.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the fbdev tree got a conflict in
arch/arm/mach-omap2/board-omap3beagle.c between commit
f8362d215549c66066f78e67c033dd370ae50322 ("omap3: beaglexm: fix DVI reset
GPIO") from the omap tree and commit
89747c9141cd750a610974d93f71492922b8cbd7 ("OMAP: use generic DPI panel
driver in board files") from the fbdev tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-omap3beagle.c
index 2ed8040,a4fe8e1..0000000
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@@ -197,11 -204,10 +204,10 @@@ static struct panel_generic_dpi_data dv
  static struct omap_dss_device beagle_dvi_device = {
  	.type = OMAP_DISPLAY_TYPE_DPI,
  	.name = "dvi",
- 	.driver_name = "generic_panel",
+ 	.driver_name = "generic_dpi_panel",
+ 	.data = &dvi_panel,
  	.phy.dpi.data_lines = 24,
 -	.reset_gpio = 170,
 +	.reset_gpio = -EINVAL,
- 	.platform_enable = beagle_enable_dvi,
- 	.platform_disable = beagle_disable_dvi,
  };
  
  static struct omap_dss_device beagle_tv_device = {

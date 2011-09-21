Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab1IUC6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 22:58:50 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:58371 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1IUC6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 22:58:49 -0400
Date: Wed, 21 Sep 2011 12:58:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the omap_dss2 tree with the arm-soc
 tree
Message-Id: <20110921125844.d83e02ba538d7626d6bdefcf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
arch/arm/mach-omap2/board-4430sdp.c between commit 8f5b5a41ebc7 ("ARM:
OMAP: Introduce SoC specific early_init") from the arm-soc tree and
commit 58282610da02 ("OMAP: 4430SDP: Remove unneeded lcd config") from
the omap_dss2 tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-4430sdp.c
index f3917b3,d3874a6..0000000
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@@ -381,14 -379,12 +379,6 @@@ static struct platform_device *sdp4430_
  	&sdp4430_vbat,
  };
  
- static struct omap_lcd_config sdp4430_lcd_config __initdata = {
- 	.ctrl_name	= "internal",
- };
- 
- static struct omap_board_config_kernel sdp4430_config[] __initdata = {
- 	{ OMAP_TAG_LCD,		&sdp4430_lcd_config },
- };
- 
 -static void __init omap_4430sdp_init_early(void)
 -{
 -	omap2_init_common_infrastructure();
 -	omap2_init_common_devices(NULL, NULL);
 -}
 -
  static struct omap_musb_board_data musb_board_data = {
  	.interface_type		= MUSB_INTERFACE_UTMI,
  	.mode			= MUSB_OTG,

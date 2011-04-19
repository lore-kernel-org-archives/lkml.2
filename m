Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1DSD12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 23:27:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57079 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219Ab1DSD10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 23:27:26 -0400
Date: Tue, 19 Apr 2011 13:27:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Archit Taneja <archit@ti.com>, Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: manual merge of the omap_dss2 tree with the
 fbdev-current tree
Message-Id: <20110419132720.d86b8afd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
drivers/video/omap2/dss/dss_features.c
drivers/video/omap2/dss/dss_features.h between commit 0b41136c0d2f
("OMAP: DSS2: DSI: Fix DSI PLL power bug") from the fbdev-current tree
and commit 0f7d043bd56b ("OMAP4: DSS2: Register configuration changes for
DSI") from the omap_dss2 tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/video/omap2/dss/dss_features.c
index 8c50e18,179a7a4..0000000
--- a/drivers/video/omap2/dss/dss_features.c
+++ b/drivers/video/omap2/dss/dss_features.c
@@@ -271,7 -272,8 +272,8 @@@ static struct omap_dss_features omap363
  		FEAT_LCDENABLESIGNAL | FEAT_PCKFREEENABLE |
  		FEAT_PRE_MULT_ALPHA | FEAT_FUNCGATED |
  		FEAT_ROWREPEATENABLE | FEAT_LINEBUFFERSPLIT |
- 		FEAT_RESIZECONF | FEAT_DSI_PLL_PWR_BUG,
 -		FEAT_RESIZECONF | FEAT_DSI_PLL_FREQSEL |
 -		FEAT_DSI_LDO_STATUS,
++		FEAT_RESIZECONF | FEAT_DSI_PLL_PWR_BUG |
++		FEAT_DSI_PLL_FREQSEL | FEAT_DSI_LDO_STATUS,
  
  	.num_mgrs = 2,
  	.num_ovls = 3,
diff --cc drivers/video/omap2/dss/dss_features.h
index 37922ce,c5c0b40..0000000
--- a/drivers/video/omap2/dss/dss_features.h
+++ b/drivers/video/omap2/dss/dss_features.h
@@@ -26,22 -26,24 +26,25 @@@
  
  /* DSS has feature id */
  enum dss_feat_id {
- 	FEAT_GLOBAL_ALPHA	= 1 << 0,
- 	FEAT_GLOBAL_ALPHA_VID1	= 1 << 1,
- 	FEAT_PRE_MULT_ALPHA	= 1 << 2,
- 	FEAT_LCDENABLEPOL	= 1 << 3,
- 	FEAT_LCDENABLESIGNAL	= 1 << 4,
- 	FEAT_PCKFREEENABLE	= 1 << 5,
- 	FEAT_FUNCGATED		= 1 << 6,
- 	FEAT_MGR_LCD2		= 1 << 7,
- 	FEAT_LINEBUFFERSPLIT	= 1 << 8,
- 	FEAT_ROWREPEATENABLE	= 1 << 9,
- 	FEAT_RESIZECONF		= 1 << 10,
- 	/* Independent core clk divider */
- 	FEAT_CORE_CLK_DIV	= 1 << 11,
- 	FEAT_LCD_CLK_SRC	= 1 << 12,
+ 	FEAT_GLOBAL_ALPHA		= 1 << 0,
+ 	FEAT_GLOBAL_ALPHA_VID1		= 1 << 1,
+ 	FEAT_PRE_MULT_ALPHA		= 1 << 2,
+ 	FEAT_LCDENABLEPOL		= 1 << 3,
+ 	FEAT_LCDENABLESIGNAL		= 1 << 4,
+ 	FEAT_PCKFREEENABLE		= 1 << 5,
+ 	FEAT_FUNCGATED			= 1 << 6,
+ 	FEAT_MGR_LCD2			= 1 << 7,
+ 	FEAT_LINEBUFFERSPLIT		= 1 << 8,
+ 	FEAT_ROWREPEATENABLE		= 1 << 9,
+ 	FEAT_RESIZECONF			= 1 << 10,
 -	/* Independent core clk divider */
+ 	FEAT_CORE_CLK_DIV		= 1 << 11,
+ 	FEAT_LCD_CLK_SRC		= 1 << 12,
+ 	FEAT_DSI_PLL_FREQSEL		= 1 << 13,
+ 	FEAT_DSI_LDO_STATUS		= 1 << 14,
+ 	FEAT_DSI_DCS_CMD_CONFIG_VC	= 1 << 15,
+ 	FEAT_DSI_VC_OCP_WIDTH		= 1 << 16,
 +	/* DSI-PLL power command 0x3 is not working */
- 	FEAT_DSI_PLL_PWR_BUG	= 1 << 13,
++	FEAT_DSI_PLL_PWR_BUG		= 1 << 17,
  };
  
  /* DSS register field id */

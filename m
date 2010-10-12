Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932568Ab0JLNB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:01:57 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:54579 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932476Ab0JLNBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:01:20 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 6/7] ste_dma40: remove enum for endianess
Date: Tue, 12 Oct 2010 15:00:54 +0200
Message-ID: <1286888455-11385-7-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1286888455-11385-6-git-send-email-linus.walleij@stericsson.com>
References: <1286888455-11385-1-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-2-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-3-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-4-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-5-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-6-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

A bool will suffice.  The default is little endian.

Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-ux500/devices-db8500.c           |    4 ----
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    9 ++-------
 drivers/dma/ste_dma40.c                        |    4 ++--
 drivers/dma/ste_dma40_ll.c                     |    6 ++++--
 4 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index bb3b9d6..4a94be3 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -211,12 +211,10 @@ struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
 	.mode = STEDMA40_MODE_PHYSICAL,
 	.dir = STEDMA40_MEM_TO_MEM,
 
-	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
 	.src_info.data_width = STEDMA40_BYTE_WIDTH,
 	.src_info.psize = STEDMA40_PSIZE_PHY_1,
 	.src_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
 
-	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
 	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
 	.dst_info.psize = STEDMA40_PSIZE_PHY_1,
 	.dst_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
@@ -225,12 +223,10 @@ struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
 struct stedma40_chan_cfg dma40_memcpy_conf_log = {
 	.dir = STEDMA40_MEM_TO_MEM,
 
-	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
 	.src_info.data_width = STEDMA40_BYTE_WIDTH,
 	.src_info.psize = STEDMA40_PSIZE_LOG_1,
 	.src_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
 
-	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
 	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
 	.dst_info.psize = STEDMA40_PSIZE_LOG_1,
 	.dst_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index d57f37e..07339f1 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -69,11 +69,6 @@ enum stedma40_flow_ctrl {
 	STEDMA40_FLOW_CTRL,
 };
 
-enum stedma40_endianess {
-	STEDMA40_LITTLE_ENDIAN,
-	STEDMA40_BIG_ENDIAN
-};
-
 enum stedma40_periph_data_width {
 	STEDMA40_BYTE_WIDTH = STEDMA40_ESIZE_8_BIT,
 	STEDMA40_HALFWORD_WIDTH = STEDMA40_ESIZE_16_BIT,
@@ -92,13 +87,13 @@ enum stedma40_xfer_dir {
 /**
  * struct stedma40_chan_cfg - dst/src channel configuration
  *
- * @endianess: Endianess of the src/dst hardware
+ * @big_endian: true if the src/dst should be read as big endian
  * @data_width: Data width of the src/dst hardware
  * @p_size: Burst size
  * @flow_ctrl: Flow control on/off.
  */
 struct stedma40_half_channel_info {
-	enum stedma40_endianess endianess;
+	bool big_endian;
 	enum stedma40_periph_data_width data_width;
 	int psize;
 	enum stedma40_flow_ctrl flow_ctrl;
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index e6e1504..fab68a5 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2251,11 +2251,11 @@ static void d40_set_runtime_config(struct dma_chan *chan,
 	/* Set up all the endpoint configs */
 	cfg->src_info.data_width = addr_width;
 	cfg->src_info.psize = psize;
-	cfg->src_info.endianess = STEDMA40_LITTLE_ENDIAN;
+	cfg->src_info.big_endian = false;
 	cfg->src_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL;
 	cfg->dst_info.data_width = addr_width;
 	cfg->dst_info.psize = psize;
-	cfg->dst_info.endianess = STEDMA40_LITTLE_ENDIAN;
+	cfg->dst_info.big_endian = false;
 	cfg->dst_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL;
 
 	/* Fill in register values */
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index cfc86a5..8557cb8 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -113,8 +113,10 @@ void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
 		dst |= 1 << D40_SREG_CFG_PRI_POS;
 	}
 
-	src |= cfg->src_info.endianess << D40_SREG_CFG_LBE_POS;
-	dst |= cfg->dst_info.endianess << D40_SREG_CFG_LBE_POS;
+	if (cfg->src_info.big_endian)
+		src |= 1 << D40_SREG_CFG_LBE_POS;
+	if (cfg->dst_info.big_endian)
+		dst |= 1 << D40_SREG_CFG_LBE_POS;
 
 	*src_cfg = src;
 	*dst_cfg = dst;
-- 
1.6.3.3


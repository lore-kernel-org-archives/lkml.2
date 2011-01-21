Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab1AUOMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 09:12:30 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43047 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab1AUOMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 09:12:23 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH repost 4/4] avr32: at32ap700x: specify DMA src and dst masters
Date: Fri, 21 Jan 2011 14:11:55 +0000
Message-Id: <1295619115-18420-5-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1295619115-18420-1-git-send-email-jamie@jamieiles.com>
References: <1295619115-18420-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the dw_dmac DMA driver supports configurable source and
destination masters we need to specify which ones to use. This was
previously hardcoded to 0 and 1 respectively in the driver.

Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 arch/avr32/mach-at32ap/at32ap700x.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index e67c999..2747cde 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -2048,6 +2048,8 @@ at32_add_device_ac97c(unsigned int id, struct ac97c_platform_data *data,
 		rx_dws->reg_width = DW_DMA_SLAVE_WIDTH_16BIT;
 		rx_dws->cfg_hi = DWC_CFGH_SRC_PER(3);
 		rx_dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
+		rx_dws->src_master = 0;
+		rx_dws->dst_master = 1;
 	}
 
 	/* Check if DMA slave interface for playback should be configured. */
@@ -2056,6 +2058,8 @@ at32_add_device_ac97c(unsigned int id, struct ac97c_platform_data *data,
 		tx_dws->reg_width = DW_DMA_SLAVE_WIDTH_16BIT;
 		tx_dws->cfg_hi = DWC_CFGH_DST_PER(4);
 		tx_dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
+		rx_dws->src_master = 0;
+		rx_dws->dst_master = 1;
 	}
 
 	if (platform_device_add_data(pdev, data,
@@ -2128,6 +2132,8 @@ at32_add_device_abdac(unsigned int id, struct atmel_abdac_pdata *data)
 	dws->reg_width = DW_DMA_SLAVE_WIDTH_32BIT;
 	dws->cfg_hi = DWC_CFGH_DST_PER(2);
 	dws->cfg_lo &= ~(DWC_CFGL_HS_DST_POL | DWC_CFGL_HS_SRC_POL);
+	dws->src_master = 0;
+	dws->dst_master = 1;
 
 	if (platform_device_add_data(pdev, data,
 				sizeof(struct atmel_abdac_pdata)))
-- 
1.7.3.4


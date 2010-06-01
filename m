Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab0FAMW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:22:29 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:47742 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756439Ab0FAMWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:22:25 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 14/18] DMAENGINE: ste_dma40: no flow control on memcpy
Date: Tue, 1 Jun 2010 14:22:19 +0200
Message-ID: <1275394939-26725-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

On memcpy DMA operations we don't need flow control.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-ux500/devices-db8500.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index 638964e..8d94bc6 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -140,11 +140,12 @@ struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
 	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
 	.src_info.data_width = STEDMA40_BYTE_WIDTH,
 	.src_info.psize = STEDMA40_PSIZE_PHY_1,
+	.src_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
 
 	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
 	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
 	.dst_info.psize = STEDMA40_PSIZE_PHY_1,
-
+	.dst_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
 };
 /* Default configuration for logical memcpy */
 struct stedma40_chan_cfg dma40_memcpy_conf_log = {
@@ -157,11 +158,12 @@ struct stedma40_chan_cfg dma40_memcpy_conf_log = {
 	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
 	.src_info.data_width = STEDMA40_BYTE_WIDTH,
 	.src_info.psize = STEDMA40_PSIZE_LOG_1,
+	.src_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
 
 	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
 	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
 	.dst_info.psize = STEDMA40_PSIZE_LOG_1,
-
+	.dst_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
 };
 
 /*
-- 
1.6.3.3


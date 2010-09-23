Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab0IWWic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:38:32 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:5472 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab0IWWi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:38:29 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 1/9] MIPS: Octeon: Set dma_masks for octeon_mgmt device.
Date: Thu, 23 Sep 2010 15:38:08 -0700
Message-Id: <1285281496-24696-2-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
References: <1285281496-24696-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 23 Sep 2010 22:38:29.0549 (UTC) FILETIME=[0B5FE5D0:01CB5B70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows follow-on patches to dma mapping functions to work with
the octeon mgmt device..

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/cavium-octeon/octeon-platform.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/mips/cavium-octeon/octeon-platform.c b/arch/mips/cavium-octeon/octeon-platform.c
index 62ac30e..c32d40d 100644
--- a/arch/mips/cavium-octeon/octeon-platform.c
+++ b/arch/mips/cavium-octeon/octeon-platform.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/i2c.h>
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 
@@ -301,6 +302,10 @@ static int __init octeon_mgmt_device_init(void)
 			ret = -ENOMEM;
 			goto out;
 		}
+		/* No DMA restrictions */
+		pd->dev.coherent_dma_mask = DMA_BIT_MASK(64);
+		pd->dev.dma_mask = &pd->dev.coherent_dma_mask;
+
 		switch (port) {
 		case 0:
 			mgmt_port_resource.start = OCTEON_IRQ_MII0;
-- 
1.7.2.2


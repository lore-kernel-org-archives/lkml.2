Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2DPJXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 05:23:25 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:61191 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab2DPJVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 05:21:22 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, arnd@arndb.de, olof@lixom.net
Cc: plagnioj@jcrosoft.com, ludovic.desroches@atmel.com,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Chris Ball <cjb@laptop.org>, <linux-mmc@vger.kernel.org>
Subject: [PATCH 09/12] ARM: at91/atmel-mci: remove unused setup_dma_addr() macro
Date: Mon, 16 Apr 2012 11:20:53 +0200
Message-Id: <93a2e5f55b3064422a7fab75d5d9035c58152989.1334567594.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1334567594.git.nicolas.ferre@atmel.com>
References: <cover.1334567594.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is not used anymove in atmel-mci driver. It has been removed
by a patch that was dealing with dw_dmac.c e2b35f3:
(dmaengine/dw_dmac: Fix dw_dmac user drivers to adapt to slave_config changes)

We are now using the dmaengine API to specify the slave DMA parameters:
dmaengine_slave_config().

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: Chris Ball <cjb@laptop.org>
Cc: <linux-mmc@vger.kernel.org>
---
 arch/arm/mach-at91/include/mach/atmel-mci.h |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/arm/mach-at91/include/mach/atmel-mci.h b/arch/arm/mach-at91/include/mach/atmel-mci.h
index 998cb0c..5d84fe3 100644
--- a/arch/arm/mach-at91/include/mach/atmel-mci.h
+++ b/arch/arm/mach-at91/include/mach/atmel-mci.h
@@ -14,11 +14,4 @@ struct mci_dma_data {
 #define	slave_data_ptr(s)	(&(s)->sdata)
 #define find_slave_dev(s)	((s)->sdata.dma_dev)
 
-#define	setup_dma_addr(s, t, r)	do {		\
-	if (s) {				\
-		(s)->sdata.tx_reg = (t);	\
-		(s)->sdata.rx_reg = (r);	\
-	}					\
-} while (0)
-
 #endif /* __MACH_ATMEL_MCI_H */
-- 
1.7.10


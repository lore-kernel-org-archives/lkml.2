Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab1CVJfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 05:35:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46646 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab1CVJf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 05:35:27 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] dma: let IMX_DMA depend on IMX_HAVE_DMA_V1 instead of an explicit list of SoCs
Date: Tue, 22 Mar 2011 10:35:17 +0100
Message-Id: <1300786517-3695-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a side effect this makes IMX_DMA selectable on i.MX21 again, because
the symbol ARCH_MX21 doesn't exist (MACH_MX21 would have been more correct).

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/dma/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 1c28816..f2463b4 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -221,7 +221,7 @@ config IMX_SDMA
 
 config IMX_DMA
 	tristate "i.MX DMA support"
-	depends on ARCH_MX1 || ARCH_MX21 || MACH_MX27
+	depends on IMX_HAVE_DMA_V1
 	select DMA_ENGINE
 	help
 	  Support the i.MX DMA engine. This engine is integrated into
-- 
1.7.2.3


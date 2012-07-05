Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab2GETfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:35:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41981 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757312Ab2GETfh (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Thu, 5 Jul 2012 15:35:37 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/6] mfd: arizona: Don't free unallocated supplies on error
Date: Thu,  5 Jul 2012 20:35:32 +0100
Message-Id: <1341516933-16474-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1341516933-16474-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1341516933-16474-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARRAY_SIZE() may be larger than the number of supplies actually used.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 4d249ed..a55e52e 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -514,7 +514,7 @@ err_reset:
 err_dcvdd:
 	regulator_disable(arizona->dcvdd);
 err_enable:
-	regulator_bulk_disable(ARRAY_SIZE(arizona->core_supplies),
+	regulator_bulk_disable(arizona->num_core_supplies,
 			       arizona->core_supplies);	
 err_early:
 	mfd_remove_devices(dev);
-- 
1.7.10


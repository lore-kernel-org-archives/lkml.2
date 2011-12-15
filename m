Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627Ab1LOWWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:22:03 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:60805 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756480Ab1LOWV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:21:59 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH] mfd/db8500-prcmu: remove support for early silicon revisions
Date: Thu, 15 Dec 2011 23:21:43 +0100
Message-ID: <1323987703-27525-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The DB8500 ED (Early Drop) and V1 are only available inside of
ST-Ericsson or partners, we have actively replaced and scrapped
these prototypes. All Nova products on the open market (such as
the Snowball board) are based on V2 and later ASIC variants.
So let us focus on supporting the silicon that will be used and
delete this to get a clear overview.

Cc: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Sam if this is OK with you I'd prefer to take this one patch
through the ux500 tree since it depends on other changes there
so your ACK would be appreciated!
---
 drivers/mfd/db8500-prcmu.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index a25ab9c..af8e0ef 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -2102,14 +2102,11 @@ static struct irq_chip prcmu_irq_chip = {
 void __init db8500_prcmu_early_init(void)
 {
 	unsigned int i;
-
-	if (cpu_is_u8500v1()) {
-		tcdm_base = __io_address(U8500_PRCMU_TCDM_BASE_V1);
-	} else if (cpu_is_u8500v2()) {
+	if (cpu_is_u8500v2()) {
 		void *tcpm_base = ioremap_nocache(U8500_PRCMU_TCPM_BASE, SZ_4K);
 
 		if (tcpm_base != NULL) {
-			int version;
+			u32 version;
 			version = readl(tcpm_base + PRCMU_FW_VERSION_OFFSET);
 			prcmu_version.project_number = version & 0xFF;
 			prcmu_version.api_version = (version >> 8) & 0xFF;
-- 
1.7.3.2


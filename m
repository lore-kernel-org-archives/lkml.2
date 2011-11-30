Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab1K3Hus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 02:50:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:49670 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab1K3Huq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 02:50:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="81483044"
From: Feng Tang <feng.tang@intel.com>
To: grant.likely@secretlab.ca, tomoya-linux@dsn.lapis-semi.com,
        linux-kernel@vger.kernel.org
Cc: joel.clark@intel.com, ying.huang@intel.com, qi.wang@intel.com,
        kok.howg.ewe@intel.com, Feng Tang <feng.tang@intel.com>
Subject: [PATCH 1/2] gpio-ml-ioh: fix a bug in the interrupt handler
Date: Wed, 30 Nov 2011 15:51:40 +0800
Message-Id: <1322639501-11940-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO's irq action's dev_id is set to the first struct ioh_gpio chip,
so when loop checking the 8 chips, the "chip" should be changed
according.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 drivers/gpio/gpio-ml-ioh.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
index ea8e738..92b6f51 100644
--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@ -339,7 +339,7 @@ static irqreturn_t ioh_gpio_handler(int irq, void *dev_id)
 	int i, j;
 	int ret = IRQ_NONE;
 
-	for (i = 0; i < 8; i++) {
+	for (i = 0; i < 8; i++, chip++) {
 		reg_val = ioread32(&chip->reg->regs[i].istatus);
 		for (j = 0; j < num_ports[i]; j++) {
 			if (reg_val & BIT(j)) {
-- 
1.7.1


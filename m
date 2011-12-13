Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab1LMPxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 10:53:15 -0500
Received: from mga14.intel.com ([143.182.124.37]:3434 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab1LMPxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 10:53:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="85223345"
From: Feng Tang <feng.tang@intel.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        tomoya-linux@dsn.lapis-semi.com, linux-kernel@vger.kernel.org
Cc: joel.clark@intel.com, ying.huang@intel.com, qi.wang@intel.com,
        kok.howg.ewe@intel.com, Feng Tang <feng.tang@intel.com>
Subject: [PATCH 1/2] gpio-ml-ioh: fix a bug in the interrupt handler
Date: Tue, 13 Dec 2011 23:53:49 +0800
Message-Id: <1323791630-4125-1-git-send-email-feng.tang@intel.com>
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


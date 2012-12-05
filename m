Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab2LECqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 21:46:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41100 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753300Ab2LECqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 21:46:35 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Log if we fail to create the primary IRQ domain
Date: Wed,  5 Dec 2012 11:46:26 +0900
Message-Id: <1354675586-24864-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the only thing in probe for which we don't log an error.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-irq.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index 113805d..2bec5f0 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -210,6 +210,7 @@ int arizona_irq_init(struct arizona *arizona)
 	arizona->virq = irq_domain_add_linear(NULL, 2, &arizona_domain_ops,
 					      arizona);
 	if (!arizona->virq) {
+		dev_err(arizona->dev, "Failed to add core IRQ domain\n");
 		ret = -EINVAL;
 		goto err;
 	}
-- 
1.7.10.4


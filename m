Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2HARlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 13:41:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44212 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab2HARkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 13:40:55 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 2/3] regmap: name irq_chip based on regmap_irq_chip's name
Date: Wed,  1 Aug 2012 11:40:48 -0600
Message-Id: <1343842849-15958-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1343842849-15958-1-git-send-email-swarren@wwwdotorg.org>
References: <1343842849-15958-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

This is intended to give each irq_chip a useful name, rather than hard-
coding them all as "regmap".

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/base/regmap/regmap-irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 07fae4c..5a3624f 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -131,7 +131,6 @@ static int regmap_irq_set_wake(struct irq_data *data, unsigned int on)
 }
 
 static const struct irq_chip regmap_irq_chip = {
-	.name			= "regmap",
 	.irq_bus_lock		= regmap_irq_lock,
 	.irq_bus_sync_unlock	= regmap_irq_sync_unlock,
 	.irq_disable		= regmap_irq_disable,
@@ -287,6 +286,7 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	}
 
 	d->irq_chip = regmap_irq_chip;
+	d->irq_chip.name = chip->name;
 	d->irq = irq;
 	d->map = map;
 	d->chip = chip;
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab2AXUhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:37:31 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:15112
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755942Ab2AXUha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:37:30 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275ch8275bhz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <broonie@opensource.wolfsonmicro.com>, <rdunlap@xenotime.net>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] regulator: mc13xxx-regulator-core: Fix the build when driver is selected as module
Date: Tue, 24 Jan 2012 18:37:16 -0200
Message-ID: <1327437436-10937-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build error when mc138xxx driver is built as module:

ERROR: "mc13xxx_parse_regulators_dt" [drivers/regulator/mc13892-regulator.ko] undefined!
ERROR: "mc13xxx_get_num_regulators_dt" [drivers/regulator/mc13892-regulator.ko] undefined!

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/regulator/mc13xxx-regulator-core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index 80ecafe..62dcd0a 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -254,6 +254,7 @@ int __devinit mc13xxx_get_num_regulators_dt(struct platform_device *pdev)
 
 	return num;
 }
+EXPORT_SYMBOL_GPL(mc13xxx_get_num_regulators_dt);
 
 struct mc13xxx_regulator_init_data * __devinit mc13xxx_parse_regulators_dt(
 	struct platform_device *pdev, struct mc13xxx_regulator *regulators,
@@ -291,6 +292,7 @@ struct mc13xxx_regulator_init_data * __devinit mc13xxx_parse_regulators_dt(
 
 	return data;
 }
+EXPORT_SYMBOL_GPL(mc13xxx_parse_regulators_dt);
 #endif
 
 MODULE_LICENSE("GPL v2");
-- 
1.7.1



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab2CCLkN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 06:40:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50108 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab2CCLkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 06:40:11 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        Estevam Fabio-R49496 <r49496@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/4] regulator fixed: Do not report enumaratable voltages if there are none
Date: Sat,  3 Mar 2012 12:40:01 +0100
Message-Id: <1330774804-7310-2-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1330774804-7310-1-git-send-email-s.hauer@pengutronix.de>
References: <1330774804-7310-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If used as a dummy voltage provider the fixed regulator should
not set n_voltages to make the core accept the device.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/regulator/fixed.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index e24e3a1..40f3803 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -192,7 +192,9 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	drvdata->desc.type = REGULATOR_VOLTAGE;
 	drvdata->desc.owner = THIS_MODULE;
 	drvdata->desc.ops = &fixed_voltage_ops;
-	drvdata->desc.n_voltages = 1;
+
+	if (config->microvolts)
+		drvdata->desc.n_voltages = 1;
 
 	drvdata->microvolts = config->microvolts;
 	drvdata->gpio = config->gpio;
-- 
1.7.9.1


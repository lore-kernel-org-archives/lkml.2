Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab2B2IBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:01:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48818 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab2B2IBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:01:46 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: <linux-arm-kernel@lists.infradead.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] regulator mc13783: bail out without platform data
Date: Wed, 29 Feb 2012 09:01:40 +0100
Message-Id: <1330502500-30567-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.9.1
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the platform data pointer is used without checking it. Bail out
in the driver instead of crashing the kernel.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/regulator/mc13783-regulator.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index 8e9b90a..6c0face 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -344,6 +344,9 @@ static int __devinit mc13783_regulator_probe(struct platform_device *pdev)
 
 	dev_dbg(&pdev->dev, "%s id %d\n", __func__, pdev->id);
 
+	if (!pdata)
+		return -EINVAL;
+
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv) +
 			pdata->num_regulators * sizeof(priv->regulators[0]),
 			GFP_KERNEL);
-- 
1.7.9.1


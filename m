Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1K0COY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 21:14:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54150 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab1K0COX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 21:14:23 -0500
Message-ID: <1322360030.6779.1.camel@phoenix>
Subject: [PATCH] regulator: Avoid potential NULL dereference in
 reg_fixed_voltage_probe()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rajendra Nayak <rnayak@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sun, 27 Nov 2011 10:13:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_fixed_voltage_config() may return NULL, return -ENOMEM in this case
so we don't dereference NULL pointer.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/fixed.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 639e19d..2f917a1 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -166,8 +166,11 @@ static int __devinit reg_fixed_voltage_probe(struct platform_device *pdev)
 	struct fixed_voltage_data *drvdata;
 	int ret;
 
-	if (pdev->dev.of_node)
+	if (pdev->dev.of_node) {
 		config = of_get_fixed_voltage_config(&pdev->dev);
+		if (!config)
+			return -ENOMEM;
+	}
 
 	drvdata = kzalloc(sizeof(struct fixed_voltage_data), GFP_KERNEL);
 	if (drvdata == NULL) {
-- 
1.7.5.4




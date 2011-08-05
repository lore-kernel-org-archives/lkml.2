Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab1HEWx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 18:53:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34521 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab1HEWx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 18:53:57 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        John Bonesio <bones@secretlab.ca>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [RESEND PATCH] i2c: Tegra: Add of_match_table
Date: Fri,  5 Aug 2011 16:53:48 -0600
Message-Id: <1312584828-23474-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Bonesio <bones@secretlab.ca>

This patch was intended to be part of 7ca2d1a105a239e300b937e9c41a10a4bd08f569
"i2c: Tegra: Add DeviceTree support". However, an early version of that patch,
which was missing a chunk, was applied to next-i2c. This change is that
missing chunk.

Signed-off-by: John Bonesio <bones@secretlab.ca>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/i2c/busses/i2c-tegra.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 0c6e840..dd1f21b 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -720,6 +720,17 @@ static int tegra_i2c_resume(struct platform_device *pdev)
 }
 #endif
 
+#if defined(CONFIG_OF)
+/* Match table for of_platform binding */
+static const struct of_device_id tegra_i2c_of_match[] __devinitconst = {
+	{ .compatible = "nvidia,tegra20-i2c", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, tegra_i2c_of_match);
+#else
+#define tegra_i2c_of_match NULL
+#endif
+
 static struct platform_driver tegra_i2c_driver = {
 	.probe   = tegra_i2c_probe,
 	.remove  = tegra_i2c_remove,
@@ -730,6 +741,7 @@ static struct platform_driver tegra_i2c_driver = {
 	.driver  = {
 		.name  = "tegra-i2c",
 		.owner = THIS_MODULE,
+		.of_match_table = tegra_i2c_of_match,
 	},
 };
 
-- 
1.7.0.4


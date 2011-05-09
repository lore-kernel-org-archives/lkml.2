Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab1EIAdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:33:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:2637 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756377Ab1EIAdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:33:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,337,1301900400"; 
   d="scan'208";a="919712941"
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Ian Molton <spyro@f2s.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 04/19] mmc: Use device platform_data to retrieve tmio_mmc platform bits
Date: Mon,  9 May 2011 02:31:56 +0200
Message-Id: <1304901131-7104-5-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of the platform device mfd_cell pointer, we can now
cleanly pass the sub device drivers platform data pointers through the
regular device platform_data one, and get rid of mfd_get_data()

Cc: Ian Molton <spyro@f2s.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/asic3.c         |    3 ++-
 drivers/mfd/t7l66xb.c       |    3 ++-
 drivers/mfd/tc6387xb.c      |    3 ++-
 drivers/mfd/tc6393xb.c      |    3 ++-
 drivers/mmc/host/tmio_mmc.c |    2 +-
 5 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index d4a851c..1df4f2c 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -777,7 +777,8 @@ static struct mfd_cell asic3_cell_mmc = {
 	.name          = "tmio-mmc",
 	.enable        = asic3_mmc_enable,
 	.disable       = asic3_mmc_disable,
-	.mfd_data      = &asic3_mmc_data,
+	.platform_data = &asic3_mmc_data,
+	.pdata_size    = sizeof(asic3_mmc_data),
 	.num_resources = ARRAY_SIZE(asic3_mmc_resources),
 	.resources     = asic3_mmc_resources,
 };
diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
index 42830e6..5ef0b8f 100644
--- a/drivers/mfd/t7l66xb.c
+++ b/drivers/mfd/t7l66xb.c
@@ -170,7 +170,8 @@ static struct mfd_cell t7l66xb_cells[] = {
 		.name = "tmio-mmc",
 		.enable = t7l66xb_mmc_enable,
 		.disable = t7l66xb_mmc_disable,
-		.mfd_data = &t7166xb_mmc_data,
+		.platform_data = &t7166xb_mmc_data,
+		.pdata_size    = sizeof(t7166xb_mmc_data),
 		.num_resources = ARRAY_SIZE(t7l66xb_mmc_resources),
 		.resources = t7l66xb_mmc_resources,
 	},
diff --git a/drivers/mfd/tc6387xb.c b/drivers/mfd/tc6387xb.c
index b006f7c..ad715bf 100644
--- a/drivers/mfd/tc6387xb.c
+++ b/drivers/mfd/tc6387xb.c
@@ -131,7 +131,8 @@ static struct mfd_cell tc6387xb_cells[] = {
 		.name = "tmio-mmc",
 		.enable = tc6387xb_mmc_enable,
 		.disable = tc6387xb_mmc_disable,
-		.mfd_data = &tc6387xb_mmc_data,
+		.platform_data = &tc6387xb_mmc_data,
+		.pdata_size    = sizeof(tc6387xb_mmc_data),
 		.num_resources = ARRAY_SIZE(tc6387xb_mmc_resources),
 		.resources = tc6387xb_mmc_resources,
 	},
diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index fc53ce2..8e9b1b7 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -393,7 +393,8 @@ static struct mfd_cell __devinitdata tc6393xb_cells[] = {
 		.name = "tmio-mmc",
 		.enable = tc6393xb_mmc_enable,
 		.resume = tc6393xb_mmc_resume,
-		.mfd_data = &tc6393xb_mmc_data,
+		.platform_data = &tc6393xb_mmc_data,
+		.pdata_size    = sizeof(tc6393xb_mmc_data),
 		.num_resources = ARRAY_SIZE(tc6393xb_mmc_resources),
 		.resources = tc6393xb_mmc_resources,
 	},
diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index 79c5684..7ae05f9 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -72,7 +72,7 @@ static int __devinit tmio_mmc_probe(struct platform_device *pdev)
 	if (pdev->num_resources != 2)
 		goto out;
 
-	pdata = mfd_get_data(pdev);
+	pdata = pdev->dev.platform_data;
 	if (!pdata || !pdata->hclk)
 		goto out;
 
-- 
1.7.2.3


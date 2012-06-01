Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240Ab2FAJOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:14:33 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15623 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759169Ab2FAJOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:14:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 01 Jun 2012 02:12:06 -0700
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <olof@lixom.net>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, <jak@jak-linux.org>,
        <marvin24@gmx.de>, <gregkh@linuxfoundation.org>,
        <ac100@lists.launchpad.net>, <devel@driverdev.osuosl.org>
Subject: [PATCH 7/9] staging: nvec: add clk_prepare/clk_unprepare
Date: Fri, 1 Jun 2012 14:42:46 +0530
Message-ID: <1338541968-7961-8-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1338541968-7961-1-git-send-email-pgaikwad@nvidia.com>
References: <1338541968-7961-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use clk_prepare/clk_unprepare as required by the generic clk framework.

This patch should go through Tegra tree since other patches to port Tegra
to generic clock framework are dependent on it. Posting here to get ack from
the maintainers.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 drivers/staging/nvec/nvec.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index 3c60088..9356886 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -675,7 +675,7 @@ static void tegra_init_i2c_slave(struct nvec_chip *nvec)
 {
 	u32 val;
 
-	clk_enable(nvec->i2c_clk);
+	clk_prepare_enable(nvec->i2c_clk);
 
 	tegra_periph_reset_assert(nvec->i2c_clk);
 	udelay(2);
@@ -695,14 +695,14 @@ static void tegra_init_i2c_slave(struct nvec_chip *nvec)
 
 	enable_irq(nvec->irq);
 
-	clk_disable(nvec->i2c_clk);
+	clk_disable_unprepare(nvec->i2c_clk);
 }
 
 static void nvec_disable_i2c_slave(struct nvec_chip *nvec)
 {
 	disable_irq(nvec->irq);
 	writel(I2C_SL_NEWSL | I2C_SL_NACK, nvec->base + I2C_SL_CNFG);
-	clk_disable(nvec->i2c_clk);
+	clk_disable_unprepare(nvec->i2c_clk);
 }
 
 static void nvec_power_off(void)
@@ -812,7 +812,7 @@ static int __devinit tegra_nvec_probe(struct platform_device *pdev)
 
 	tegra_init_i2c_slave(nvec);
 
-	clk_enable(i2c_clk);
+	clk_prepare_enable(i2c_clk);
 
 
 	/* enable event reporting */
-- 
1.7.4.1

